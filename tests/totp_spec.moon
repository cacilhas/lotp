export ^
local *

unit = assert require "luaunit"
TOTP = assert require "otp.totp"


TestTOTP =
    totp: TOTP "12345678901234567890"

    specs:
        [{year: 1970, month: 1, day: 1, hour: 0, min: 0, sec: 59}]: 94287082
        [{year: 2005, month: 3, day: 18, hour: 1, min: 58, sec: 29}]: 7081804
        [{year: 2005, month: 3, day: 18, hour: 1, min: 58, sec: 31}]: 14050471
        --[{year: 2009, month: 2, day: 13, hour: 23, min: 31, sec: 30}]: 89005924
        [{year: 2033, month: 5, day: 18, hour: 3, min: 33, sec: 20}]: 69279037
        [{year: 2603, month: 10, day: 11, hour: 11, min: 33, sec: 20}]: 65353130

    setup: =>
        @totp.last = 0
        @totp.post = 0
        @totp.length = 8

    populate: =>
        for t, exp in pairs @specs
            name = os.date "%Y-%m-%d %H:%M:%S", os.time t
            @["test_password #{name}"] = => unit.assertEquals (@totp\password t), exp
            @["test_digest #{name}"] = => unit.assertTrue @totp\digest exp, t

    skip_test_last_post: =>
        @totp.last = 1
        @totp.post = 1
        t = {year: 2005, month: 3, day: 18, hour: 1, min: 58, sec: 29}
        unit.assertFalse @totp\digest 48150727, t  -- 1m before
        unit.assertTrue  @totp\digest 44266759, t  -- 30s before
        unit.assertTrue  @totp\digest  7081804, t  -- t itself
        unit.assertTrue  @totp\digest 14050471, t  -- 30s after
        unit.assertFalse @totp\digest 44266759, t  -- 1m after

TestTOTP\populate!
