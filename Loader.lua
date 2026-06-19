local PlaceId = game.PlaceId

local Loaders = {
    {
        Ids = {136801880565837}, -- [FPS] Flick
        Link = "https://raw.githubusercontent.com/UnlessDahell/Zelo/refs/heads/main/Flick%20Patch%202"
    },

    {
        Ids = {142823291, 3351674303}, -- Murder Mystery 2
        Link = "https://raw.githubusercontent.com/UnlessDahell/Zelo/refs/heads/main/MM2"
    },
    
    {
        Ids = {893973440}, -- Flee the Facility 
        Link = "https://raw.githubusercontent.com/UnlessDahell/Zelo/refs/heads/main/FtF.txt"
    },
    {
        Ids = {79268393072444}, -- Sell a Lemons
        Link = "https://raw.githubusercontent.com/UnlessDahell/Zelo/refs/heads/main/SAL"
    },
    {
        Ids = {4924922222}, -- Brookheaven
        Link = "https://raw.githubusercontent.com/UnlessDahell/Zelo/refs/heads/main/Brookheaven"
    },
    {
        Ids = {97598239454123}, -- Grow a Garden 2
        Link = "https://api.rubis.app/v2/scrap/AVGjNAIpO5S9Br7d/raw"
    }
    
}

for _, Data in pairs(Loaders) do
    if table.find(Data.Ids, PlaceId) then
        
        loadstring(game:HttpGet(Data.Link))()

        break
    end
end
