package = "nodis-app-auth-kong-plugin"
version = "0.1.0-0"
source = {
    url = "git+https://github.com/nodis-com-br/nodis-app-auth-kong-plugin",
    dir = "nodis-app-auth-kong-plugin"
}
description = {
    summary = "",
    detailed = [[
        ]],
    homepage = "https://github.com/nodis-com-br/nodis-app-auth-kong-plugin",
    license = "Apache 2.0"
}
dependencies = {
    "luasec",
    "luasocket",
    "ltn12",
    "lua-cjson"
}

build = {
    type = "builtin",
    modules = {
        ["kong.plugins.nodis-app-auth-kong-plugin.handler"] = "kong/plugins/nodis-app-auth-kong-plugin/handler.lua",
        ["kong.plugins.nodis-app-auth-kong-plugin.schema"] = "kong/plugins/nodis-app-auth-kong-plugin/schema.lua",
    }
}
