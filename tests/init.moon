local *

package.path = "?.lua;?/init.lua;#{package.path}"
import loadfile from assert require "moonscript.base"
unit = assert require "luaunit"
lfs = assert require "lfs"


--------------------------------------------------------------------------------
for dirent in lfs.dir "tests"
    if (dirent\match ".-_spec%.moon")
        f, err = loadfile"tests/#{dirent}"
        error err unless f
        f!


--------------------------------------------------------------------------------
os.exit unit.LuaUnit.run!
