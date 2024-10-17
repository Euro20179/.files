local settings = require "settings"
local select = require "select"
local editor = require "editor"

local engines = settings.window.search_engines

engines.ddg = "https://www.duckduckgo.com/?q=%s"
engines.brave = "https://search.brave.com/search?q=%s"
engines.searx = "https://searx.prvcy.eu/search?q=%s"
engines.default = engines.brave

settings.window.home_page = engines.brave

select.label_maker = function ()
    local chars = charset("asdfjkl;")
    return trim(sort(reverse(chars)))
end

editor.editor_cmd = "footclient nvim {file} +{line}"

local files = {
    "downloads.db",
    "history.db",
    "cookies.db"
}
for i = 1, #files, 1 do
    local share = os.getenv("XDG_DATA_HOME")
    local path = share .. "/luakit/" .. files[i]
    os.remove(path)
end
