package = "ip-auth"
version = "0.0.2-1"

supported_platforms = {"linux", "macosx"}
source = {
  url = "git://github.com/raunsbaekdk/ip-auth",
  tag = "0.0.2"
}

description = {
  summary = "IP Auth",
  homepage = "http://getkong.org",
  license = "MIT"
}

dependencies = {
}

local pluginName = "ip-auth"
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.ip-auth.migrations.cassandra"] = "kong/plugins/ip-auth/migrations/cassandra.lua",
    ["kong.plugins.ip-auth.migrations.postgres"] = "kong/plugins/ip-auth/migrations/postgres.lua",
    ["kong.plugins.ip-auth.handler"] = "kong/plugins/ip-auth/handler.lua",
    ["kong.plugins.ip-auth.hooks"] = "kong/plugins/ip-auth/hooks.lua",
    ["kong.plugins.ip-auth.schema"] = "kong/plugins/ip-auth/schema.lua",
    ["kong.plugins.ip-auth.api"] = "kong/plugins/ip-auth/api.lua",
    ["kong.plugins.ip-auth.daos"] = "kong/plugins/ip-auth/daos.lua",
  }
}