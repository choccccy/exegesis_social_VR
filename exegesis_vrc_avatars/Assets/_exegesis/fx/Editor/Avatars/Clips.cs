namespace Exegesis.Fx
{
    /// <summary>Where the clips live. One helper per folder, so layer definitions read as names.</summary>
    public static class Clips
    {
        /// <summary>
        /// Animates one irrelevant property on a GameObject that does not exist. With Write
        /// Defaults off it writes nothing, which is what an "off" state needs: the layers below
        /// get to win.
        /// </summary>
        public const string Empty = "Assets/_exegesis/generic_anim/_Empty.anim";

        public static string Generic(string name) => $"Assets/_exegesis/generic_anim/{name}.anim";
        public static string Ncho(string name) => $"Assets/_exegesis/ncho/ncho_anim/{name}.anim";
        public static string Hud(string name) => $"Assets/_exegesis/HUD/{name}.anim";
        public static string Lemaitre(string name) => $"Assets/_exegesis/lemaitre/{name}.anim";
        public static string ObiMe(string name) => $"Assets/_exegesis/obi-me/{name}.anim";
    }
}
