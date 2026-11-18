using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Exegesis.Fx
{
    /// <summary>
    /// An avatar's VRChat expressions: the expression parameters (what syncs and saves) and the
    /// menu tree. ExpressionsBuilder writes them into the existing assets, so the GUIDs the
    /// avatar descriptors and the VRCFury prefab reference never change.
    ///
    /// Plain data, no SDK types, like LayerSpec: the definitions and their validation compile
    /// without the VRChat SDK; only the writer needs it.
    /// </summary>
    public sealed class ExpressionsSpec
    {
        /// <summary>The VRCExpressionParameters asset this avatar's descriptor uses.</summary>
        public string ParametersAsset { get; }

        public IReadOnlyList<ExpressionParam> Parameters { get; }

        /// <summary>The descriptor's root menu.</summary>
        public MenuSpec MainMenu { get; }

        /// <summary>
        /// Menus not reachable from the main menu but used elsewhere - ncho's tail menu, which a
        /// VRCFury prefab installs.
        /// </summary>
        public IReadOnlyList<MenuSpec> OtherMenus { get; }

        public ExpressionsSpec(string parametersAsset, IEnumerable<ExpressionParam> parameters,
                               MenuSpec mainMenu, IEnumerable<MenuSpec> otherMenus = null)
        {
            ParametersAsset = parametersAsset;
            Parameters = parameters.ToList();
            MainMenu = mainMenu;
            OtherMenus = (otherMenus ?? Enumerable.Empty<MenuSpec>()).ToList();
        }

        /// <summary>Every menu this avatar writes: the main menu's whole tree, then the others'.</summary>
        public IEnumerable<MenuSpec> AllMenus()
        {
            var seen = new HashSet<string>();
            var stack = new Stack<MenuSpec>(OtherMenus.Reverse().Append(MainMenu));
            while (stack.Count > 0)
            {
                var m = stack.Pop();
                if (!seen.Add(m.Path)) continue;
                yield return m;
                foreach (var c in Enumerable.Reverse(m.Controls))
                    if (c.SubMenu != null) stack.Push(c.SubMenu);
            }
        }

        public IEnumerable<string> Problems()
        {
            foreach (var g in Parameters.GroupBy(p => p.Name).Where(g => g.Count() > 1))
                yield return $"expression parameter '{g.Key}' is declared {g.Count()} times.";

            var declared = new HashSet<string>(Parameters.Select(p => p.Name));
            foreach (var menu in AllMenus())
            {
                if (menu.Controls.Count > MenuSpec.MaxControls)
                    yield return $"menu {menu.Path} has {menu.Controls.Count} controls; VRChat shows {MenuSpec.MaxControls}.";

                foreach (var c in menu.Controls)
                {
                    if (c.Parameter.Length > 0 && !declared.Contains(c.Parameter))
                        yield return $"menu {menu.Path}, '{c.Name}': parameter '{c.Parameter}' is not an expression parameter, so the control does nothing.";
                    foreach (var sp in c.SubParameters.Where(sp => sp.Length > 0 && !declared.Contains(sp)))
                        yield return $"menu {menu.Path}, '{c.Name}': sub-parameter '{sp}' is not an expression parameter.";
                }
            }
        }
    }

    public enum ExpressionType { Int = 0, Float = 1, Bool = 2 }

    /// <summary>One expression parameter. The default here, not the animator's, is what VRChat applies.</summary>
    public readonly struct ExpressionParam
    {
        public string Name { get; }
        public ExpressionType Type { get; }
        public float Default { get; }
        public bool Saved { get; }
        public bool Synced { get; }

        private ExpressionParam(string name, ExpressionType type, float def, bool saved, bool synced)
        {
            Name = name;
            Type = type;
            Default = def;
            Saved = saved;
            Synced = synced;
        }

        public static ExpressionParam Bool(string name, bool def = false, bool saved = false, bool synced = true) =>
            new ExpressionParam(name, ExpressionType.Bool, def ? 1f : 0f, saved, synced);

        public static ExpressionParam Int(string name, int def = 0, bool saved = false, bool synced = true) =>
            new ExpressionParam(name, ExpressionType.Int, def, saved, synced);

        public static ExpressionParam Float(string name, float def = 0f, bool saved = false, bool synced = true) =>
            new ExpressionParam(name, ExpressionType.Float, def, saved, synced);
    }

    public enum ControlType { Button = 101, Toggle = 102, SubMenu = 103 }

    /// <summary>
    /// One menu asset: its path, its controls in order, and the parameters asset its inspector
    /// uses for dropdowns (VRChat ignores that reference at runtime).
    /// </summary>
    public sealed class MenuSpec
    {
        public const int MaxControls = 8;

        public string Path { get; }

        /// <summary>Inspector-only reference to an expression parameters asset, or null.</summary>
        public string ParametersAsset { get; }

        public List<ControlSpec> Controls { get; } = new List<ControlSpec>();

        public MenuSpec(string path, string parametersAsset = null)
        {
            Path = path;
            ParametersAsset = parametersAsset;
        }

        public MenuSpec Toggle(string name, string parameter, float value = 1f, string icon = null,
                               params string[] subParameters)
        {
            Controls.Add(new ControlSpec(name, ControlType.Toggle, parameter, value, icon, null, subParameters));
            return this;
        }

        public MenuSpec Button(string name, string parameter, float value = 1f, string icon = null)
        {
            Controls.Add(new ControlSpec(name, ControlType.Button, parameter, value, icon, null, new string[0]));
            return this;
        }

        /// <param name="menu">The submenu, or null for a submenu control that opens nothing.</param>
        public MenuSpec SubMenu(string name, MenuSpec menu, string icon = null, float value = 1f,
                                params string[] subParameters)
        {
            Controls.Add(new ControlSpec(name, ControlType.SubMenu, "", value, icon, menu, subParameters));
            return this;
        }

        /// <summary>
        /// The whole tree under this menu as text: two avatars may share a menu asset only if
        /// they describe it identically.
        /// </summary>
        public string Describe()
        {
            var sb = new StringBuilder();
            sb.AppendLine($"{Path} params={ParametersAsset}");
            foreach (var c in Controls)
                sb.AppendLine($"  {c.Name}|{c.Type}|{c.Parameter}|{c.Value}|{c.Icon}|{c.SubMenu?.Path}|{string.Join(",", c.SubParameters)}");
            foreach (var c in Controls.Where(c => c.SubMenu != null))
                sb.Append(c.SubMenu.Describe());
            return sb.ToString();
        }
    }

    public sealed class ControlSpec
    {
        public string Name { get; }
        public ControlType Type { get; }
        public string Parameter { get; }
        public float Value { get; }
        public string Icon { get; }
        public MenuSpec SubMenu { get; }
        public string[] SubParameters { get; }

        public ControlSpec(string name, ControlType type, string parameter, float value, string icon,
                           MenuSpec subMenu, string[] subParameters)
        {
            Name = name;
            Type = type;
            Parameter = parameter ?? "";
            Value = value;
            Icon = icon;
            SubMenu = subMenu;
            SubParameters = subParameters ?? new string[0];
        }
    }
}
