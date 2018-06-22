local *

import band from assert require "bit"
import hmac from assert require "otp.utils"


--------------------------------------------------------------------------------
(seed, step, len=6) ->
    phrase = (hmac seed, step)
    -- Dynamic truncation
    dt = 2 * tonumber (phrase\sub -1), 16
    phrase = phrase\sub dt+1, dt+8
    num = band (tonumber phrase, 16), 0x7fffffff
    num % (10 ^ len)
