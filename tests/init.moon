local *

package.path = "?.lua;?/init.lua;#{package.path}"
import loadfile from assert require "moonscript.base"
unit = assert require "luaunit"
lfs = assert require "lfs"


--------------------------------------------------------------------------------
loaddir = (dirname) ->
    for dirent in lfs.dir dirname
        unless dirent\find "^%."
            name = "#{dirname}/#{dirent}"
            (assert loadfile name)! if (dirent\match ".-_spec%.moon")
            loaddir name if (lfs.attributes name).mode == "directory"

loaddir "tests"

--------------------------------------------------------------------------------
os.exit unit.LuaUnit.run!
