using AnimatorAsCode.V1;
using UnityEditor.Animations;

namespace Exegesis.Aac
{
    /// <summary>
    /// Animator As Code's defaults, adjusted to what this controller actually contains.
    ///
    /// Two of AAC's four virtual members are overridden, and both for the same reason: AAC's
    /// defaults are perfectly sensible for a greenfield avatar, and this controller is not one.
    /// It ships, people wear it, and its layer names are referenced by tests, by docs and by the
    /// prefix-teardown convention the generators are built on.
    ///
    /// Every value in ConfigureTransition below was MEASURED off the committed controller
    /// through ControllerSnapshot, not assumed. Two of them would otherwise have been wrong:
    /// Unity's AddTransition leaves exitTime at 0.9 rather than the 0 AAC writes, and
    /// canTransitionToSelf at true rather than AAC's false.
    ///
    /// Neither of those two can change behaviour here - exitTime is unreachable while
    /// hasExitTime is false, and canTransitionToSelf only matters for Any-State transitions,
    /// which no generated layer has. They are reproduced anyway. An equivalence diff that is
    /// genuinely empty is worth a great deal more than one that is empty except for two
    /// differences carrying a footnote about why they are fine, because next time the footnote
    /// is what someone reaches for.
    /// </summary>
    public class ExegesisDefaultsProvider : AacDefaultsProvider
    {
        // Every state in this controller, generated and hand-built, is Write Defaults OFF. That
        // is what lets the layers stack: a layer sitting in a state that writes nothing lets the
        // layers below it win, which is how "bare" costs no clip and no state.
        public ExegesisDefaultsProvider() : base(writeDefaults: false)
        {
        }

        public override string ConvertLayerName(string systemName) => systemName;

        /// <summary>
        /// Single underscore, not AAC's double. "rcs" + "group_packs" has to come out as
        /// rcs_group_packs, because that is the name the teardown prefix matches, the name
        /// SlotParameterTests looks up, and the name in the docs.
        /// </summary>
        public override string ConvertLayerNameWithSuffix(string systemName, string suffix) =>
            $"{systemName}_{suffix}";

        public override void ConfigureTransition(AnimatorStateTransition transition)
        {
            transition.duration = 0f;
            transition.hasExitTime = false;
            transition.exitTime = 0.9f;
            transition.hasFixedDuration = true;
            transition.offset = 0f;
            transition.interruptionSource = TransitionInterruptionSource.None;
            transition.orderedInterruption = true;
            transition.canTransitionToSelf = true;
        }
    }
}
