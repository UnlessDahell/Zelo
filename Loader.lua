
local PlaceId = game.PlaceId

local Loaders = {
    {
        Ids = {2753915549},
        Link = "https://raw.githubusercontent.com/UnlessDahell/Zelo/refs/heads/main/Flick.lua"
    },

    {
        Ids = {142823291, 3351674303},
        Link = "https://example.com/mm2.lua"
    }
}

for _, Data in pairs(Loaders) do
    if table.find(Data.Ids, PlaceId) then
        loadstring(game:HttpGet(Data.Link))()
        break
    end
end
