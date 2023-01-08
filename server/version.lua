----------------------------------------------------------
-------------------- Don't touch this --------------------
----------------------------------------------------------

local currentVersion = GetResourceMetadata(GetCurrentResourceName(), "version")
local resourceName = "ufo_identification"

if Config.Update then
    CreateThread(function()
        if GetCurrentResourceName() ~= "ufo_identification" then
            resourceName = "ufo_identification (" .. GetCurrentResourceName() .. ")"
        end
    end)

    CreateThread(function()
        while true do
            PerformHttpRequest("https://api.github.com/repos/druf0/ufo_identification/releases/latest", CheckVersion, "GET")
            Wait(3600000)
        end
    end)

    CheckVersion = function(err, responseText, headers)
        local repoVersion, repoURL, repoBody = GetRepoInformations()

        CreateThread(function()
            if currentVersion ~= repoVersion then
                Wait(4000)
                print("^0[^3WARNING^0] " .. resourceName .. " is ^1outdated^0, get the latest version from ^2".. repoURL .. "^0")
            end
        end)
    end

    GetRepoInformations = function()
        local repoVersion, repoURL, repoBody = nil, nil, nil

        PerformHttpRequest("https://api.github.com/repos/druf0/ufo_identification/releases/latest", function(err, response, headers)
            if err == 200 then
                local data = json.decode(response)

                repoVersion = data.tag_name
                repoURL = data.html_url
                repoBody = data.body
            else
                repoVersion = currentVersion
                repoURL = "https://github.com/druf0/ufo_identification"
            end
        end, "GET")

        repeat
            Wait(50)
        until (repoVersion and repoURL and repoBody)

        return repoVersion, repoURL, repoBody
    end
end