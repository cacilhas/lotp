local *

HOTP = assert require "otp.hotp"

epoch = os.time os.date "!*t", 0

cicles = (interval, t) ->
    t or= os.date "!*t"
    math.floor ((os.time t) - epoch) / interval


--------------------------------------------------------------------------------
class TOTP
    interval: 30
    last: 1
    post: 2

    new: (seed) => @hotp = HOTP seed

    digest: (password, t) =>
        step = cicles @interval, t
        @hotp.length = @length if @length
        for cur = (step - @last), (step + @post)
            return true if @hotp\digest password, cur
        false

    password: (t) =>
        step = cicles @interval, t
        @hotp.length = @length if @length
        @hotp\password step


with TOTP
    -- For test purpose
    ._test = :cicles if _TEST
