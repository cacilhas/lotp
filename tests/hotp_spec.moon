export ^
local *

unit = assert require "luaunit"
HOTP = assert require "otp.hotp"

TestHOTP =
    hotp: HOTP "12345678901234567890"

    specs:
        [0]: 755224
        [1]: 287082
        [2]: 359152
        [3]: 969429
        [4]: 338314
        [5]: 254676
        [6]: 287922
        [7]: 162583
        [8]: 399871
        [9]: 520489

    populate: =>
        for step, exp in pairs @specs
            @["test_password_#{step}"] = => unit.assertEquals (@hotp\password step), exp
            @["test_digest_#{step}"] = => unit.assertTrue (@hotp\digest exp, step)

    test_progression: =>
        @hotp.currentstep = 0
        unit.assertTrue @hotp\digest @specs[0]
        unit.assertTrue @hotp\digest exp for _, exp in ipairs @specs

TestHOTP\populate!
