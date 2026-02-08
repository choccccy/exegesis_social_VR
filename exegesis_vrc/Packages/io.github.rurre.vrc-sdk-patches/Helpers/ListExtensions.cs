using System.Collections.Generic;

namespace Pumkin.VrcSdkPatches
{
    public static class ListExtensions
    {
		public static bool TryGet<T>(this List<T> list, int index, out T value)
    	{
        	value = default;
        	if(index < list.Count && index >= 0)
        	{
            	value = list[index];
            	return true;
        	}
        	return false;
    	}    
	}    
}