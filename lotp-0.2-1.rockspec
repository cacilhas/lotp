package = "LOTP"
version = "0.2-1"
source = {
  url = ""
}
description = {
  summary = "LuaOTP – HOTP and TOTP support",
  detailed = "",
  homepage = "https://bitbucket.org/cacilhas/lotp",
  license = "BSD-3 Clausule",
}
dependencies = {
  "lua >= 5.1, < 5.2",
  "sha1 >= 0.5-1, < 0.6",
  "basexx >= 0.4.0-1, < 0.5",
}
build = {
  type = "make",
  modules = {
    lotp = "lotp/init.lua",
    ["lotp.hotp"] = "lotp/hotp.lua",
    ["lotp.totp"] = "lotp/totp.lua",
  },
}
