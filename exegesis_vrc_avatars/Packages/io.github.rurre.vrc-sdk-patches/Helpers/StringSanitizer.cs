using System.IO;

namespace Pumkin.VrcSdkPatches
{
    public static class StringSanitizer
    {
        static char[] InvalidFilenameChars 
        {
            get
            {
                if(_invalidFilenameChars == null)
                    _invalidFilenameChars = Path.GetInvalidFileNameChars();
                return _invalidFilenameChars;
            }
        }
        static char[] _invalidFilenameChars;

        /// <summary>
        /// Removes illegal filename characters (Path.GetInvalidFilenameChars()) from string.
        /// </summary>
        /// <param name="str">String to remove illegal characters from</param>
        /// <returns></returns>
        public static string RemoveInvalidFilenameChars(string str)
        {
            if(string.IsNullOrWhiteSpace(str))
                return str;
            return string.Join("_", str.Split(InvalidFilenameChars));  
        }
    }
}