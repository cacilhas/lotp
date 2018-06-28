local *

ffi = assert require"ffi", "require LuaJIT"
import band from assert require"bit", "require LuaJIT"
sha1 = assert require"sha1",
    "missing: luarocks install sha1 # git@github.com:kikito/sha1.lua.git"


hextou64 = (str) ->
    res = ffi.new "uint8_t[?]", 8
    str = "0000000000000000#{str}"\sub -16
    i = 7
    for char in str\gmatch ".."
        res[i] = tonumber char, 16
        i -= 1
    p = ffi.cast "uint64_t*", res
    p[0]


itoa = (num) ->
    num = hextou64 num if "string" == type num
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
    _G.lotp or= {}
    lotp._test or= {}
    lotp._test.hotp = :hextou64, :hmac, :itoa


--------------------------------------------------------------------------------
class HOTP
    length: 6
    currentstep: 0

    --- :new(seed)
    -- @param seed base32 string
    -- @returns HOTP
    new: (seed) => @seed = seed

    --- :digest(password, step?)
    -- @param password number
    -- @param step number or uint64_t
    -- @returns boolean
    digest: (password, step) =>
        step or= @currentstep
        @currentstep = step + 1
        password == @\password step

    --- :password(step?)
    -- @param step number or uint64_t
    -- @returns number
    password: (step) =>
        step or= @currentstep
        phrase = (hmac @seed, step)
        -- Dynamic truncation
        dt = 2 * tonumber (phrase\sub -1), 16
        phrase = phrase\sub dt+1, dt+8
        num = band (tonumber phrase, 16), 0x7fffffff
        num % (10 ^ @length)
