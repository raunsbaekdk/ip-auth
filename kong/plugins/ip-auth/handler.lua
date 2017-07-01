local cache = require "kong.tools.database_cache"
local responses = require "kong.tools.responses"
local constants = require "kong.constants"
local singletons = require "kong.singletons"
local BasePlugin = require "kong.plugins.base_plugin"
local iputils = require "resty.iputils"

local ngx_set_header = ngx.req.set_header
local type = type

local _realm = 'Key realm="' .. _KONG._NAME .. '"'

local IPAuthHandler = BasePlugin:extend()

IPAuthHandler.PRIORITY = 1001

function IPAuthHandler:new()
  IPAuthHandler.super.new(self, "ip-auth")
end

local function load_credential(ip)
  local creds, err = singletons.dao.ipauth_credentials:find_all {
    ip = ip
  }
  if not creds then
    return nil, err
  end
  return creds[1]
end

local function load_consumer(consumer_id, anonymous)
  local result, err = singletons.dao.consumers:find { id = consumer_id }
  if not result then
    if anonymous and not err then
      err = 'anonymous consumer "' .. consumer_id .. '" not found'
    end
    return nil, err
  end
  return result
end

local function set_consumer(consumer, credential)
  ngx_set_header(constants.HEADERS.CONSUMER_ID, consumer.id)
  ngx_set_header(constants.HEADERS.CONSUMER_CUSTOM_ID, consumer.custom_id)
  ngx_set_header(constants.HEADERS.CONSUMER_USERNAME, consumer.username)
  ngx.ctx.authenticated_consumer = consumer
  if credential then
    ngx_set_header(constants.HEADERS.CREDENTIAL_USERNAME, credential.username)
    ngx.ctx.authenticated_credential = credential
    ngx_set_header(constants.HEADERS.ANONYMOUS, nil) -- in case of auth plugins concatenation
  else
    ngx_set_header(constants.HEADERS.ANONYMOUS, true)
  end

end

local function do_authentication(conf)
  local ip = ngx.var.remote_addr

  if not ip then
    return responses.send_HTTP_FORBIDDEN("Cannot identify the client IP address, unix domain sockets are not supported.")
  end

  -- retrieve our consumer linked to this ip
  local credential, err = cache.get_or_set("ipauth_credentials:" .. ip, nil, load_credential, ip)
  if err then
    return responses.send_HTTP_INTERNAL_SERVER_ERROR(err)
  end

  -- no credential in DB, for this ip, it is invalid, HTTP 403
  if not credential then
    return false, {status = 403, message = "Invalid authentication credentials"}
  end

  -----------------------------------------
  -- Success, this request is authenticated
  -----------------------------------------

  -- retrieve the consumer linked to this ip, to set appropriate headers
  local consumer, err = cache.get_or_set(cache.consumer_key(credential.consumer_id), nil, load_consumer, credential.consumer_id)
  if err then
    return responses.send_HTTP_INTERNAL_SERVER_ERROR(err)
  end

  set_consumer(consumer, credential)

  return true
end


function IPAuthHandler:access(conf)
  IPAuthHandler.super.access(self)

  if ngx.ctx.authenticated_credential and conf.anonymous ~= "" then
    -- we're already authenticated, and we're configured for using anonymous,
    -- hence we're in a logical OR between auth methods and we're already done.
    return
  end

  local ok, err = do_authentication(conf)
  if not ok then
    if conf.anonymous ~= "" and conf.anonymous ~= nil then
      -- get anonymous user
      local consumer, err = cache.get_or_set(cache.consumer_key(conf.anonymous),
                            nil, load_consumer, conf.anonymous, true)
      if err then
        responses.send_HTTP_INTERNAL_SERVER_ERROR(err)
      end
      set_consumer(consumer, nil)
    else
      return responses.send(err.status, err.message)
    end
  end
end


return IPAuthHandler