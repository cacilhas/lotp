local *

ffi = assert require"ffi", "require LuaJIT"
import band from assert require"bit", "require LuaJIT"
sha1 = assert require"sha1",
    "missing: luarocks install sha1 # git@github.com:kikito/sha1.lua.git"


itoa = (num) -> -- TODO: support string number
    bnum = ffi.new "uint64_t[?]", 1
    bnum[0] = num
    p = ffi.cast "uint8_t*", bnum
    buf = ffi.new "uint8_t[?]", 8
    buf[7-i] = p[i] for i = 0, 7
    ffi.string buf, 8


hmac = (key, counter) ->
    sha1.hmac key, itoa counter


if _TEST
    -- For test purpose
    _G.otp or= {}
    otp._test or= {}
    otp._test.hotp = :hmac, :itoa


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
