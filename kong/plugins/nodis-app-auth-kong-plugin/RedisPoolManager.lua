--- This is a handy wrapper around resty.redis that provides a python-like
-- context manager interface which puts the connection back into the pool even
-- in case of errors.

local redis = require "resty.redis"

local RedisPoolManager = {}
RedisPoolManager.__index = RedisPoolManager

function RedisPoolManager.new(conf)
  local self = setmetatable({}, RedisPoolManager)

  local conf_redis = conf.redis
  self.host = conf_redis.host or "localhost"
  self.port = conf_redis.port or 6379
  self.connect_timeout = conf_redis.connect_timeout or 1000
  self.send_timeout = conf_redis.send_timeout or 1000
  self.read_timeout = conf_redis.read_timeout or 1000
  self.max_idle_timeout = conf_redis.max_idle_timeout or 60000
  self.pool_size = conf_redis.pool_size or 20

  self.client = redis:new()
  self.client:set_timeouts(self.connect_timeout, self.send_timeout, self.read_timeout)

  return self
end

--- Calls the given callback with a connected redis client.
-- This makes sure the client is returned to the pool even if the callback
-- throws an error.
-- @param callback The callback to call.
-- @return The results of the callback, or nil if an error occurred.
-- @return The error object, if any.
function RedisPoolManager:with_connection_do(callback)
  local client = self.client

  -- Connect is a misnomer. It takes a connection from the pool if available.
  local ok, err = client:connect(self.host, self.port)
  if not ok then
    return nil, err
  end

  -- Call the callback passing the connected client
  local t = table.pack(pcall(callback, client))
  ok = t[1]
  err = t[2]

  -- Put the connection back in the pool
  self.client:set_keepalive(self.max_idle_timeout, self.pool_size)

  if not ok then
    return nil, err
  end

  -- Handle callbacks with multiple return values
  return table.unpack(t, 2)
end

return RedisPoolManager
