local events = require "kong.core.events"
local cache = require "kong.tools.database_cache"

local function invalidate(message_t)
  if message_t.collection == "ipauth_credentials" then
    cache.delete("ipauth_credentials:" .. (message_t.old_entity and message_t.old_entity.ip or message_t.entity.ip))
  end
end

return {
  [events.TYPES.ENTITY_UPDATED] = function(message_t)
    invalidate(message_t)
  end,
  [events.TYPES.ENTITY_DELETED] = function(message_t)
    invalidate(message_t)
  end
}