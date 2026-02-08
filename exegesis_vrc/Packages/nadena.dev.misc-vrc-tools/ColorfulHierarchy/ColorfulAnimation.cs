using System;
using System.Collections.Generic;
using System.Reflection;
using System.Reflection.Emit;
using HarmonyLib;
using UnityEditor;
using UnityEditor.Experimental.GraphView;
using UnityEditor.IMGUI.Controls;
using UnityEngine;

namespace nadena.dev.misc.ColorfulAnimation.Editor
{
    public static class ColorfulAnimation
    {
        private static readonly Type t_AnimationWindow = AccessTools.TypeByName("UnityEditor.AnimationWindow");
        private static readonly MethodInfo m_AW_get_state = AccessTools.PropertyGetter(t_AnimationWindow, "state");
        
        private static readonly Type t_AnimationWindowState = AccessTools.TypeByName("UnityEditorInternal.AnimationWindowState");
        private static readonly FieldInfo f_AWS_showCurveEditor = AccessTools.Field(t_AnimationWindowState, "showCurveEditor");
        
        private static readonly Type t_DopeLine = AccessTools.TypeByName("UnityEditorInternal.DopeLine");
        private static readonly FieldInfo f_DopeLine_isMaster = AccessTools.Field(t_DopeLine, "isMasterDopeline");
        private static readonly Type t_AnimationWindowCurve = AccessTools.TypeByName("UnityEditorInternal.AnimationWindowCurve");
        private static readonly MethodInfo p_AWC_Binding_Getter = AccessTools.PropertyGetter(t_AnimationWindowCurve, "binding");
        private static readonly FieldInfo f_DopeLine_Curves = AccessTools.Field(t_DopeLine, "m_Curves");

        private static readonly Type t_AWHN = AccessTools.TypeByName("UnityEditorInternal.AnimationWindowHierarchyNode");

        [InitializeOnLoadMethod]
        static void Init()
        {
            // Avoid initializing editor classes too early...
            EditorApplication.delayCall += Patch;
        }

        private static Harmony harmony;
        
        static void Patch() {
            harmony = new Harmony("nadena.dev.misc.ColorfulAnimation");
            HarmonyMethod hm = new HarmonyMethod(typeof(ColorfulAnimation), nameof(TranspileDopeSheetEditor));

            Type target = AccessTools.TypeByName("UnityEditorInternal.DopeSheetEditor");

            var method = AccessTools.Method(target, "DopeLineRepaint");

            harmony.Patch(
                method, transpiler: hm
            );
            
            harmony.Patch(AccessTools.Method(target, "DopelinesGUI"),
                prefix: new HarmonyMethod(typeof(ColorfulAnimation), nameof(Prefix_DopelinesGUI)));
            
            var t_AnimationWindowHierarchyGUI = AccessTools.TypeByName("UnityEditorInternal.AnimationWindowHierarchyGUI");
            harmony.Patch(AccessTools.Method(t_AnimationWindowHierarchyGUI, "DoNodeGUI"),
                prefix: new HarmonyMethod(typeof(ColorfulAnimation), nameof(Prefix_DoNodeGUI)));
            harmony.Patch(AccessTools.Method(t_AnimationWindowHierarchyGUI, "DoRowBackground"),
                prefix: new HarmonyMethod(typeof(ColorfulAnimation), nameof(Prefix_DoRowBackground)),
                postfix: new HarmonyMethod(typeof(ColorfulAnimation), nameof(Postfix_DoRowBackground)));
            
            harmony.Patch(AccessTools.Method(t_AnimationWindow, "OnGUI"),
                postfix: new HarmonyMethod(typeof(ColorfulAnimation), nameof(Prefix_AnimationWindow_OnGUI)));
            
        }
        
        private static int CurrentIndex;
        private static Color DopelineColor = Color.magenta;
        private static Dictionary<int, Color> NodeToColor = new();

        private static bool CurrentNodeIsChild;
        private static bool Enabled;

        private static void Prefix_AnimationWindow_OnGUI(object __instance)
        {
            var state = m_AW_get_state.Invoke(__instance, new object[0]);
            if (state == null) return;
            
            Enabled = ! (bool) f_AWS_showCurveEditor.GetValue(state);
        }
        
        private static void Prefix_DoNodeGUI(
            Rect rect,
            TreeViewItem /* AnimationWindowHierarchyNode */ node,
            bool selected,
            bool focused,
            int row
        )
        {
            //Debug.Log("DoNodeGUI: " + StackTraceUtility.ExtractStackTrace());
            
            if (!Enabled) return;
            
            if (row == 0)
            {
                CurrentIndex = -1;
            }

            var depth = node.depth;
            CurrentNodeIsChild = depth > 0;

            if (!CurrentNodeIsChild)
            {
                CurrentIndex++;
            }
            
            var h = (CurrentIndex / (Mathf.PI * 4f)) % 1.0f;
            var s = Mathf.Lerp(0.7f, 0.9f, CurrentIndex % 2);
            DopelineColor = Color.HSVToRGB(h, s, 1.0f);
            NodeToColor[node.id] = DopelineColor;
        }

        private static Color gui_color_prev;
        private static bool Prefix_DoRowBackground(Rect rect, int row)
        {
            gui_color_prev = GUI.color;

            if (!Enabled) return true;
            
            if (Event.current.type != EventType.Repaint) return false;
            
            Color c = DopelineColor;
            c.a *= CurrentNodeIsChild ? 0.05f : 0.16f;

            GUI.color = c;

            var style = AccessTools.Field(t_DopeLine, "dopekeyStyle")
                .GetValue(null) as GUIStyle;

            rect.y -= 1;
            
            style.Draw(rect, GUIContent.none, 0, false);

            GUI.color = gui_color_prev;
            return false;
        }

        private static void Postfix_DoRowBackground()
        {
            if (!Enabled) return;
            GUI.color = gui_color_prev;
        }
        
        private static (string, Type, string) AWC_GetBinding(object curve)
        {
            var binding = (EditorCurveBinding) p_AWC_Binding_Getter.Invoke(curve, null);
            return (binding.path, binding.type, binding.propertyName);
        }
        
        private static object OnStartDopeline(object node, object dopeline)
        {
            if (!Enabled) return node;
            var trace = StackTraceUtility.ExtractStackTrace();
            
            var isMaster = (bool) f_DopeLine_isMaster.GetValue(dopeline);

            if (isMaster)
            {
                CurrentIndex = -1;
                DopelineColor = Color.gray;
                return node;
            }
            
            if (node is TreeViewItem item && NodeToColor.TryGetValue(item.id, out var color))
            {
                DopelineColor = color;
            }
            else
            {
                DopelineColor = Color.gray;
            }

            return node;
        }

        public static Color GetDopelineColor()
        {
            if (!Enabled) return Color.gray;
            
            return DopelineColor;
        }

        static void Prefix_DopelinesGUI(Rect position, Vector2 scrollPosition)
        {
            CurrentIndex = 0;
        }

        static IEnumerable<CodeInstruction> TranspileDopeSheetEditor(IEnumerable<CodeInstruction> instructions)
        {
            bool didNodeLookup = false;
            
            foreach (var inst in instructions)
            {
                if (!didNodeLookup && inst.Is(OpCodes.Castclass, t_AWHN))
                {
                    // node = (AWHN) OnStartDopeline(node, dopeline)
                    yield return new CodeInstruction(OpCodes.Ldarg_1);
                    yield return new CodeInstruction(OpCodes.Call,
                        AccessTools.Method(typeof(ColorfulAnimation), nameof(OnStartDopeline)));
                    
                    yield return inst;

                    didNodeLookup = true;
                }
                
                if (inst.Is(OpCodes.Call, typeof(Color).GetMethod("get_gray")))
                {
                    var newInst = new CodeInstruction(OpCodes.Call,
                        AccessTools.Method(typeof(ColorfulAnimation), nameof(GetDopelineColor)));
                    newInst.labels = inst.labels;
                    newInst.blocks = inst.blocks;
                    yield return newInst;
                    continue;
                }

                yield return inst;
            }
        }
    }
}
