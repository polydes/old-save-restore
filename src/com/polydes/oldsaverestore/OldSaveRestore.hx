import com.stencyl.behavior.Script;
#if mobile
import com.stencyl.purchases.Purchases;
#end
import lime.app.Application;
import lime.system.System;
import openfl.net.SharedObject;
#if sys
import sys.FileSystem;
#end

class OldSaveRestore
{
	public static function setAppStorageDirectoryForAppName(appName:String):Void
	{
		clearSharedObjects();
		clearApplicationStorageDirectoryCache();
		
		Application.current.meta.set("file", appName);
		trace("Set Application Storage Directory to " + System.applicationStorageDirectory);
		
		reloadSharedObjects();
	}
	
	public static function hasSaveData(appName:String, name:String):Bool
	{
		var localPath = Application.current.meta.get("localSavePath");
		if(localPath == null) localPath = "";
		
		var cacheAppName = Application.current.meta.get("file");
		
		clearApplicationStorageDirectoryCache();
		Application.current.meta.set("file", appName);
		
		var path = getSharedObjectPath(name, localPath);
		clearApplicationStorageDirectoryCache();
		Application.current.meta.set("file", cacheAppName);
		
		return FileSystem.exists(path);
	}
	
	private static function getSharedObjectPath(name:String, localPath:String):String
	@:privateAccess {
		return SharedObject.__getPath(localPath, name);
	}
	
	private static function clearApplicationStorageDirectoryCache():Void
	@:privateAccess {
		System.__directories.remove(1 /* 1 is SystemDirectory.APPLICATION_STORAGE */);
		System.__applicationStorageDirectory = null;
	}
	
	private static function clearSharedObjects():Void
	@:privateAccess {
		if(SharedObject.__sharedObjects != null)
		{
			for(sharedObject in SharedObject.__sharedObjects)
			{
				sharedObject.flush();
			}
			SharedObject.__sharedObjects.clear();
		}
	}
	
	private static function reloadSharedObjects():Void
	@:privateAccess {
		#if mobile
		Purchases.load();
		#end
	}
}