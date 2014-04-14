ArcEmu
======
ArcBliz v1.1 - ArcEmu Fork

# Compiling binaries tutorial

*Generating build files with CMake [1]
*Generating binaries with Visual Studio 2010[2]

# Changelog
·Enabled LuaEngine instead of LuaBridge
·Changed "[ERR]" and "[BSC]" for debug logs as LOG_DETAIL("ERROR: ..."); and LOG_DETAIL("BASIC: ...");
This prevents seeing errors on the log, to see the errors, just increase the LogLevel on the world.conf
·Changed some erronic INSERT INTO by REPLACE INTO (by default, INSERT INTO give errors on existing entries, now this way is fixed)


[1]: http://rawgit.com/dberga/arcemu/master/Compiling/Compiling1.htm
[2]: http://rawgit.com/dberga/arcemu/master/Compiling/Compiling2.htm
