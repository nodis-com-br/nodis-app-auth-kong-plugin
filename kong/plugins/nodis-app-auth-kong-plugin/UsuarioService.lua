local table_find = (require "kong.plugins.nodis-app-auth-kong-plugin.util").table_find

local UsuarioService = {}
UsuarioService.__index = UsuarioService

function UsuarioService.new(conf, redis)
  local self = setmetatable({}, UsuarioService)

  self.prefix = conf.prefix
  self.redis = redis

  return self
end

--- Verifica se o usuário possui acesso a uma loja
-- @param usuario_id ID do usuário
-- @param loja_id ID da loja
-- @return true se o usuário possui acesso a loja, false caso contrário
function UsuarioService:possui_acesso(usuario_id, loja_id)
  local key = self.prefix .. usuario_id
  local res, err = self.redis:lrange(key, 0, -1)

  if err then
    return nil, err
  end

  local pos = table_find(res, loja_id)

  return pos ~= nil, nil
end

return UsuarioService
