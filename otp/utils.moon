local *

sha1 = assert require"sha1",
    "missing: luarocks install sha1 # git@github.com:kikito/sha1.lua.git"
import band from assert require "bit"

itoa = (num) ->
    table.concat [string.char band (math.floor num / (2^i)), 0xff for i = 56, 0, -8], ""


hmac = (key, counter) ->
    sha1.hmac key, itoa counter


epoch = os.time os.date "!*t", 0

cicles = (interval, t) ->
    t or= os.date "!*t"
    math.floor ((os.time t) - epoch) / interval


--------------------------------------------------------------------------------
:cicles, :hmac, :itoa, :unixtime
