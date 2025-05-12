local opt = require "mp.options"
local utils = require "mp.utils"

local options = {
    account_pin = ""
}

opt.read_options(options, mp.get_script_name())

local function setupLogin()
    if options.account_pin == "" then
        return ""
    end

    local base64Login = io.popen("printf 'euro:%s' '" .. options.account_pin .. "' | base64")
    if base64Login == nil then
        return ""
    end

    local login = "Authorization: Basic " .. base64Login:read("*a")
    base64Login:close()
    return login
end


---@param currentFile string
---@param path string
local function getEp(currentFile, path)
    local pfile = io.popen('episode-grabber.py "' .. currentFile .. '" "' .. path .. '"')
    if pfile == nil then
        return
    end
    local res = pfile:read("*a")
    pfile:close()
    return res
end

local function getEpisodeAIOId(location)
    local cloud = os.getenv("CLOUD") or ""
    location = location:gsub("\\$CLOUD", cloud)
    local idProg = io.popen("getAIOId '" .. location .. "'")
    if idProg == nil then
        return ""
    end

    local id = idProg:read("*a")
    idProg:close()
    return id
end

---@param login string
---@param location string
---@param num string
local function updateCurrEp(login, location, num)

    local itemId = getEpisodeAIOId(location)
    if itemId == "" then
        print("Item has no AIO ItemId")
        return ""
    end

    local req = io.popen("curl -H '" ..
        login ..
        "' 'http://10.0.0.2:8888/api/v1/engagement/mod-entry?uid=1&id=" .. itemId .. "&current-position=" .. num .. "'")
    if req == nil then
        return
    end
    local res = req:read("*a")
    print(res)
    req:close()
end

local function onload()
    local wd = mp.get_property("working-directory")

    local pp = mp.get_property('playlist-path')
    if pp == nil then
        print("Not playing a playlist")
        return
    end

    if not pp:match("^/") then
        pp = wd .. "/" .. pp
    end


    --check if we are in an AIO-dir
    local f = io.open(pp .. "/.AIO-ID", "r")
    if f ~= nil then
        f:close()
    else
        return
    end

    local login = setupLogin()

    if login == "" then
        print("No account pin")
        return
    end

    local pos = mp.get_property("playlist-playing-pos")
    if pos == -1 then
        print("Unknown playing position")
        return
    end

    local current_file = mp.get_property("playlist/" .. pos .. "/filename")

    local playlistPath = mp.get_property("playlist/" .. pos .. "/playlist-path")

    local playlistPathLen = string.len(playlistPath)
    --current_file may contain the playlist path which may contain the season number
    --this messes up episode-grabber
    --remove the playlist path from current_file
    if string.sub(current_file, 0, playlistPathLen) == playlistPath then
        current_file = string.sub(current_file, playlistPathLen + 1)
    end

    if current_file:sub(0, 1) == "/" then
        current_file = string.sub(current_file, 2)
    end

    local ep = getEp(current_file, pp)
    if ep == nil then
        return
    end

    ep, _ = string.gsub(ep, "\n", "")
    print("Extracted episode: " .. ep)
    updateCurrEp(login, pp, ep)
end

mp.register_event("file-loaded", onload)
