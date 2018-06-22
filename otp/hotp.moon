local *

import band from assert require "bit"
import hmac from assert require "otp.utils"


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
