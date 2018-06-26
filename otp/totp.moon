local *

ffi = assert require"ffi", "require LuaJIT"
HOTP = assert require "otp.hotp"

uint64_t = ffi.typeof "uint64_t"
epoch = uint64_t os.time os.date "!*t", 0

cicles = (interval, t) ->
    t or= os.date "!*t"
    ((uint64_t os.time t) - epoch) / interval


if _TEST
    -- For test purpose
    _G.otp or= {}
    otp._test or= {}
    otp._test.totp = :cicles


--------------------------------------------------------------------------------
class TOTP
    interval: 30
    last: 1
    post: 2

    new: (seed) => @hotp = HOTP seed

    digest: (password, t) =>
        step = cicles @interval, t
        @hotp.length = @length if @length
        for cur = -@last, @post
            return true if @hotp\digest password, step + cur
        false

    password: (t) =>
        step = cicles @interval, t
        @hotp.length = @length if @length
        @hotp\password step
