local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local isOpen = false
local pauseActive = false

RegisterNetEvent('ufo_identification:open')
AddEventHandler('ufo_identification:open', function(data, type)
    isOpen = true
    SendNUIMessage({
        action = "open",
        array = data,
        type = type,
        nationality = Config.Nationality,
        male = TranslateCap('male'),
        female = TranslateCap('female')
    })
end)

RegisterNetEvent('ufo_identification:notification')
AddEventHandler('ufo_identification:notification', function(title, description)
    lib.notify({
        title = title,
        description = description,
    })
end)

Citizen.CreateThread(function()
	while true do
		if IsPauseMenuActive() and not pauseActive or IsControlJustReleased(0, Keys['BACKSPACE']) and isOpen or IsControlJustReleased(0, Keys['F5']) and isOpen then
			SendNUIMessage({
				action = "close"
			})
			isOpen = false
		end
        Citizen.Wait(0)
	end
end)

function ShowLicenseToNearestPlayer(type)
    local playerId, dist = ESX.Game.GetClosestPlayer()

    if dist ~= -1 and dist <= Config.Distance then
        TriggerServerEvent('ufo_identification:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(playerId), type)
        if Config.Notifications then
            lib.notify({
                title = TranslateCap('showPlayerTitle'),
                description = TranslateCap('showPlayerDesc'),
                type = "success"
            })
        end
    else
        if Config.Notifications then
            lib.notify({
                title = TranslateCap('showPlayerTitle'),
                description = TranslateCap('showPlayerErrorDesc'),
                type = "error"
            })
        end
    end
end

function ShowIdToNearestPlayer()
    local playerId, dist = ESX.Game.GetClosestPlayer()

    if dist ~= -1 and dist <= Config.Distance then
        TriggerServerEvent('ufo_identification:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(playerId))
        if Config.Notifications then
            lib.notify({
                title = TranslateCap('showPlayerTitle'),
                description = TranslateCap('showPlayerDesc'),
                type = "success"
            })
        end
    else
        if Config.Notifications then
            lib.notify({
                title = TranslateCap('showPlayerTitle'),
                description = TranslateCap('showPlayerErrorDesc'),
                type = "error"
            })
        end
    end
end

RegisterCommand("_identification", function()
    OpenIdentificationMenu()
end)

RegisterKeyMapping('_identification', Translate('KeyMapping'), 'keyboard', 'f5')

function OpenIdentificationMenu()
    local elements = {
        {
         unselectable=true,
         title= TranslateCap('IdMenuTitle'),
        },
        {
         icon="fa-regular fa-address-card",
         title= TranslateCap('OwnIdTitle'),
         description= TranslateCap('OwnIdDesc')
        },
        {
         icon="fa-regular fa-address-card",
         title= TranslateCap('ShowIdTitle'),
         description= TranslateCap('ShowIdDesc')
        },
        {
         icon="fa-regular fa-address-card",
         title= TranslateCap('LicensesMenu'),
         description= TranslateCap('LicensesMenuDesc')
        }
      }
      
      ESX.OpenContext("right" , elements, 
        function(menu,element) 
      
        if element.title == TranslateCap('OwnIdTitle') then
          TriggerServerEvent('ufo_identification:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
          if Config.Notifications then
            lib.notify({
                title = TranslateCap('showPlayerTitle'),
                description = TranslateCap('showIdDesc'),
                type = 'success'
            })
          end
          ESX.CloseContext()
        end

        if element.title == TranslateCap('ShowIdTitle') then
            ShowIdToNearestPlayer()
            ESX.CloseContext()
        end

        if element.title == TranslateCap('LicensesMenu') then
            OpenLicenseMenu()
        end
      
      end, function(menu)
      end)
end

function OpenLicenseMenu()
    local elements = {
        {
         unselectable=true,
         title= TranslateCap('LicensesMenu'),
        },
        {
         icon="fa-regular fa-address-card",
         title= TranslateCap('DriverLicenseTitle'),
         description= TranslateCap('DriverLicenseDesc')
        },
        {
         icon="fa-regular fa-address-card",
         title= TranslateCap('ShowDriverLicenseTitle'),
         description= TranslateCap('ShowDriverLicenseDesc')
        },
        {
         icon="fa-regular fa-address-card",
         title= TranslateCap('WeaponLicenseTitle'),
         description= TranslateCap('WeaponLicenseDesc')
        },
        {
         icon="fa-regular fa-address-card",
         title= TranslateCap('ShowWeaponLicenseTitle'),
         description= TranslateCap('ShowWeaponLicenseDesc')
        }
      }
      
      ESX.OpenContext("right" , elements, 
        function(menu,element) 
      
        if element.title == TranslateCap('DriverLicenseTitle') then
          TriggerServerEvent('ufo_identification:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
          ESX.CloseContext()
        end

        if element.title == TranslateCap('WeaponLicenseTitle') then
            TriggerServerEvent('ufo_identification:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
            ESX.CloseContext()
          end

        if element.title == TranslateCap('ShowDriverLicenseTitle') then
            ShowLicenseToNearestPlayer('driver')
            ESX.CloseContext()
        end

        if element.title == TranslateCap('ShowWeaponLicenseTitle') then
            ShowLicenseToNearestPlayer('weapon')
            ESX.CloseContext()
        end
      
        ESX.CloseContext()
      end, function(menu)
      end)
end

