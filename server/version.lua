----------------------------------------------------------
-------------------- Don't touch this --------------------
----------------------------------------------------------

if Config.checkVersion then
    local currentVersion = GetResourceMetadata(GetCurrentResourceName(), "version")
    local resourceName = "ufo_identification"

    CreateThread(function()
        if GetCurrentResourceName() ~= "ufo_identification" then
            resourceName = "ufo_identification ("..GetCurrentResourceName()..")"
        end
    end)

    CreateThread(function()
        while true do
            PerformHttpRequest("", checkVersion, "GET") -- GitHub releases
            Wait(3600000)
        end
    end)

    function checkVersion(err, responseText, headers)
        local repoVersion, repoURL, repoBody = GetRepoInformations()

        CreateThread(function()
            if currentVersion ~= repoVersion then
                Wait(4000)
                print("^0[^3WARNING^0] "..resourceName.." is ^1NOT ^0up to date!")
                print("^0[^3WARNING^0] Your Version: ^1"..curVersion.."^0")
                print("^0[^3WARNING^0] Latest Version: ^2"..repoVersion.."^0")
                print("^0[^3WARNING^0] Get the latest Version from: ^2"..repoURL.."^0")
            else
                Wait(4000)
                print("^0[^2INFO^0] "..resourceName.." is up to date! (^2"..curVersion.."^0)")
            end
        end)
    end

    function GetRepoInformations()
        local repoVersion, repoURL, repoBody = nil, nil, nil

        PerformHttpRequest("https://api.github.com/repos/wasabirobby/wasabi_backpack/releases/latest", function(err, response, headers)
            if err == 200 then
                local data = json.decode(response)

                repoVersion = data.tag_name
                repoURL = data.html_url
                repoBody = data.body
            else
                repoVersion = curVersion
                repoURL = "https://github.com/wasabirobby/wasabi_backpack"
            end
        end, "GET")

        repeat
            Wait(50)
        until (repoVersion and repoURL and repoBody)

        return repoVersion, repoURL, repoBody
    end

end