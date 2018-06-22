export ^
local *

unit = assert require "luaunit"
hotp = assert require "otp.hotp"

TestHOTP =
    seed: "12345678901234567890"

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
            @["test_#{step}"] = => unit.assertEquals (hotp @seed, step), exp

TestHOTP\populate!
