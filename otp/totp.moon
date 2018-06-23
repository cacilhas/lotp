local *

import cicles from assert require "otp.utils"
HOTP = assert require "otp.hotp"


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

