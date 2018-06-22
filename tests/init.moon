local *

package.path = "?.lua;?/init.lua;#{package.path}"
import loadfile from assert require "moonscript.base"
unit = assert require "luaunit"
lfs = assert require "lfs"


--------------------------------------------------------------------------------
for dirent in lfs.dir "tests"
    (assert loadfile"tests/#{dirent}")! if (dirent\match ".-_spec%.moon")


--------------------------------------------------------------------------------
os.exit unit.LuaUnit.run!
