local typedefs = require "kong.db.schema.typedefs"

return {
  name = "nodis-app-auth",
  fields = {
    { consumer = typedefs.no_consumer },
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          {
            redis = {
              type = "record",
              required = true,
              fields = {
                { host = { type = "string", default = "redis0001.redis.svc.cluster.local" } },
                { port = { type = "number", default = 6379 } },
                { connect_timeout = { type = "number", default = 1000 } },
                { send_timeout = { type = "number", default = 1000 } },
                { read_timeout = { type = "number", default = 1000 } },
                { max_idle_timeout = { type = "number", default = 60000 } },
                { pool_size = { type = "number", default = 20 } }
              }
            }
          },
          {
            header_usuario_id = {
              type = "string",
              default = "X-Nodis-UsuarioId"
            },
          },
          {
            header_loja_id = {
              type = "string",
              default = "X-Nodis-LojaId"
            }
          },
          {
            prefix = {
              type = "string",
              default = "Nodis.Acesso_"
            }
          },
          {
            admins = {
              type = "set",
              required = true,
              elements = { type = "string" },
              default = {}
            }
          }
        },
        required = true,
      },
    },
  }
}
