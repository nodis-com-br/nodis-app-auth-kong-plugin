local BasePlugin = require "kong.plugins.base_plugin"
local RedisPoolManager = require "kong.plugins.nodis-app-auth-kong-plugin.RedisPoolManager"
local UsuarioService = require "kong.plugins.nodis-app-auth-kong-plugin.UsuarioService"
local req_get_header = kong.request.get_header
local table_find = (require "kong.plugins.nodis-app-auth-kong-plugin.util").table_find

local NodisAppAuthHandler = BasePlugin:extend()

NodisAppAuthHandler.VERSION = "0.1.0-0"
NodisAppAuthHandler.PRIORITY = 998 --- After jwt-header-forward

function NodisAppAuthHandler:new()
  NodisAppAuthHandler.super.new(self, "nodis-app-auth")
end

--- Verifica se o usuário é administrador
-- @param conf Configurações do plugin
-- @param usuario_id ID do usuário
-- @return true se o usuário é administrador, false caso contrário
local function is_admin(conf, usuario_id)
  return table_find(conf.admins, usuario_id) ~= nil
end

function NodisAppAuthHandler:access(conf)
  NodisAppAuthHandler.super.access(self, conf)

  local usuario_id = req_get_header(conf.header_usuario_id)
  local loja_id = req_get_header(conf.header_loja_id)

  if not usuario_id or not loja_id then
    return kong.response.exit(400, { message = "Usuário ou loja não informados" })
  end

  if is_admin(conf, usuario_id) then
    return
  end

  local redis_pool_manager = RedisPoolManager.new(conf)
  local autorizado, err = redis_pool_manager:with_connection_do(function(redis)
    local usuario_service = UsuarioService.new(conf, redis)
    return usuario_service:possui_acesso(usuario_id, loja_id)
  end)

  if err then
    kong.log.err(err)
    return kong.response.exit(500, { message = err })
  end

  if not autorizado then
    return kong.response.exit(403, { message = "Usuário não autorizado" })
  end
end

return NodisAppAuthHandler
