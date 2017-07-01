local utils = require "kong.tools.utils"

local SCHEMA = {
  primary_key = {"id"},
  table = "ipauth_credentials",
  fields = {
    id = {type = "id", dao_insert_value = true},
    created_at = {type = "timestamp", immutable = true, dao_insert_value = true},
    consumer_id = {type = "id", required = true, foreign = "consumers:id"},
    ip = {type = "string", required = true, unique = false}
  },
  marshall_event = function(self, t)
    return {id = t.id, consumer_id = t.consumer_id, ip = t.ip}
  end
}

return {ipauth_credentials = SCHEMA}