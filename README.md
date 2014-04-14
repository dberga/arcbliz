ArcBliz v1.1 - ArcEmu Fork
======

# Compiling binaries

* Generate build files with CMake [tutorial here][1]
* Generate binaries with Visual Studio 2010 [tutorial here][2]

# Changelog

· Enabled LuaEngine instead of LuaBridge

· Changed "[ERR]" and "[BSC]" for debug logs as LOG_DETAIL("ERROR: ..."); and LOG_DETAIL("BASIC: ...");

This prevents seeing errors on the log, to see the errors, just increase the LogLevel on the world.conf

· Changed some erronic INSERT INTO by REPLACE INTO (by default, INSERT INTO give errors on existing entries, now this way is fixed)

# Demo

Post on ragezone [here][3]
Arcbliz v1.1 release [here][4]

[1]: http://rawgit.com/dberga/arcemu/master/Compiling/Compiling1.htm
[2]: http://rawgit.com/dberga/arcemu/master/Compiling/Compiling2.htm
[3]: http://forum.ragezone.com/f647/arcbliz-repack-3-3-5-a-997075/
[4]: https://mega.co.nz/#!IUU3iQiT!zHzES_lBUVmNAve9UlCTvowVdkXi3KGtqggwJ5ws1Gs

