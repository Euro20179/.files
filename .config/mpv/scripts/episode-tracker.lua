local function isAnime()
    return mp.get_property("working-directory"):match("/Anime") or mp.get_property("path"):match("/Anime/")
end

---@param currentFile string
---@param path string
local function getEp(currentFile, path)
    local pfile = io.popen('episode-grabber.py "' .. currentFile .. '" "' .. path .. '"')
    if pfile == nil then
        return
    end
    local res = pfile:read("a")
    pfile:close()
    return res
end

---@param location string
---@param num string
local function updateCurrEp(location, num)
    local req = io.popen("curl 'http://localhost:8080/api/v1/query?' -G -d 'location=" .. location .. "' | jq '.ItemId'")
    if req == nil then
        return
    end

    local itemId = req:read("a")
    req:close()

    itemId, _ = string.gsub(itemId, "\n", "")

    req = io.popen("curl 'http://localhost:8080/api/v1/engagement/mod-entry?id=" .. itemId .. "&current-position=" .. num .. "'")
    if req == nil then
        return
    end
    local res = req:read('a')
    print(res)
    req:close()
end

local function onload()
    if not isAnime() then
        return
    end

    local pos = mp.get_property("playlist-playing-pos")
    if pos == -1 then
        return
    end

    local pp = mp.get_property('playlist-path')
    local wd = mp.get_property("working-directory")
    pp = wd .. "/" .. pp

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

    ep, _= string.gsub(ep, "\n", "")
    print("Extracted episode: " .. ep)
    updateCurrEp(pp, ep)
end

mp.register_event("file-loaded", onload)