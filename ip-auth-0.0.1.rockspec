package = "ip-auth"
version = "0.0.1"
source = {
	url: "http://raunsbaek.dk"
}
description = {
   summary = "IP Auth",
   license = "MIT/X11",
   maintainer = "Mike"
}
dependencies = {
  "luasec == 0.6",
  "luasocket == 2.0.2",
  "penlight == 1.4.1",
  "mediator_lua == 1.1.2",
  "lua-resty-http == 0.08",
  "lua-resty-jit-uuid == 0.0.5",
  "multipart == 0.5",
  "version == 0.2",
  "lapis == 1.5.1",
  "lua-cassandra == 1.2.2",
  "pgmoon-mashape == 2.0.1",
  "luatz == 0.3",
  "lua_system_constants == 0.1.2",
  "lua-resty-iputils == 0.2.1",
  "luacrypto == 0.3.2",
  "luasyslog == 1.0.0",
  "lua_pack == 1.0.4",
  "lua-resty-dns-client == 0.4.2",
  "lua-resty-worker-events == 0.3.0",
}
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