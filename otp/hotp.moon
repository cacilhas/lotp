local *

sha1 = assert require"sha1",
    "missing: luarocks install sha1 # git@github.com:kikito/sha1.lua.git"
import band from assert require "bit"


itoa = (num) ->
    table.concat [string.char band (math.floor num / (2^i)), 0xff for i = 56, 0, -8], ""


hmac = (key, counter) ->
    sha1.hmac key, itoa counter


--------------------------------------------------------------------------------
class HOTP
    length: 6
    currentstep: 0

    new: (seed) => @seed = seed

    digest: (password, step) =>
        step or= @currentstep
        @currentstep = step + 1
        password == @\password step

    password: (step) =>
        phrase = (hmac @seed, step)
        -- Dynamic truncation
        dt = 2 * tonumber (phrase\sub -1), 16
        phrase = phrase\sub dt+1, dt+8
        num = band (tonumber phrase, 16), 0x7fffffff
        num % (10 ^ @length)


with HOTP
    -- For test purpose
    ._test = :itoa, :hmac if _TEST
