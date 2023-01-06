-- Open ID card
RegisterServerEvent('ufo_identification:open')
AddEventHandler('ufo_identification:open', function(ID, targetID, type)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source
	local show       = false

	MySQL.query('SELECT firstname, lastname, dateofbirth, sex, job FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) then
			MySQL.query('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = identifier},
			function (licenses)
				if type ~= nil then
					if type == 'driver' and Config.Notifications then
						TriggerClientEvent('ufo_identification:notification', _source, TranslateCap('LicensesMenu'), TranslateCap('driverLicenseDesc'), "success")
					end
					for i=1, #licenses, 1 do
						if type == 'driver' then
							if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' then
								show = true
							end
						elseif type =='weapon' then
							if licenses[i].type == 'weapon' then
								if Config.Notifications then
									TriggerClientEvent('ufo_identification:notification', _source, TranslateCap('LicensesMenu'), TranslateCap('weaponLicenseDesc'), "success")
								end
								show = true
							end
						end
					end
					if type == 'driver' then
						if Config.Notifications then
						end
					elseif type == 'weapon' then
						if Config.Notifications then
						
						end
					end
				else
					show = true
				end

				if show then
					local array = {
						user = user,
						licenses = licenses
					}
					TriggerClientEvent('ufo_identification:open', _source, array, type)
				else
					if Config.Notifications then
						TriggerClientEvent('ufo_identification:notification', _source, TranslateCap('LicensesMenu'), TranslateCap('noLicense'), 'error')
					end
				end
			end)
		end
	end)
end)