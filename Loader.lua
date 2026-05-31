local PlaceId = game.PlaceId

local Loaders = {
    {
        Ids = {136801880565837}, -- [FPS] Flick
        Link = "https://raw.githubusercontent.com/UnlessDahell/Zelo/refs/heads/main/Flick%20Patch%202"
    },

    {
        Ids = {142823291, 3351674303}, -- Murder Mystery 2
        Link = "https://raw.githubusercontent.com/UnlessDahell/Zelo/refs/heads/main/MM2"
    }
}

for _, Data in pairs(Loaders) do
    if table.find(Data.Ids, PlaceId) then
        
        loadstring(game:HttpGet(Data.Link))()

        break
    end
end
