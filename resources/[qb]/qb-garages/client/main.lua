local currentHouseGarage = nil
local hasGarageKey = nil
local currentGarage = nil
local OutsideVehicles = {}
local PlayerGang = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerGang = QBCore.Functions.GetPlayerData().gang
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate')
AddEventHandler('QBCore:Client:OnGangUpdate', function(gang)
    PlayerGang = gang
end)

RegisterNetEvent('qb-garages:client:setHouseGarage')
AddEventHandler('qb-garages:client:setHouseGarage', function(house, hasKey)
    currentHouseGarage = house
    hasGarageKey = hasKey
end)

RegisterNetEvent('qb-garages:client:houseGarageConfig')
AddEventHandler('qb-garages:client:houseGarageConfig', function(garageConfig)
    HouseGarages = garageConfig
end)

RegisterNetEvent('qb-garages:client:addHouseGarage')
AddEventHandler('qb-garages:client:addHouseGarage', function(house, garageInfo)
    HouseGarages[house] = garageInfo
end)

RegisterNetEvent('qb-garages:client:takeOutDepot')
AddEventHandler('qb-garages:client:takeOutDepot', function(vehicle)
    if OutsideVehicles ~= nil and next(OutsideVehicles) ~= nil then
        if OutsideVehicles[vehicle.plate] ~= nil then
            local Engine = GetVehicleEngineHealth(OutsideVehicles[vehicle.plate])
            findVehFromPlateAndLocate(vehicle.plate)
            QBCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                QBCore.Functions.TriggerCallback('qb-garage:server:GetVehicleProperties', function(properties)
                    QBCore.Functions.SetVehicleProperties(veh, properties)
                    enginePercent = round(vehicle.engine / 10, 0)
                    bodyPercent = round(vehicle.body / 10, 0)
                    currentFuel = vehicle.fuel

                    if vehicle.plate ~= nil then
                        DeleteVehicle(OutsideVehicles[vehicle.plate])
                        OutsideVehicles[vehicle.plate] = veh
                        TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                    end

                    SetVehicleNumberPlateText(veh, vehicle.plate)
                    SetEntityHeading(veh, Depots[currentGarage].takeVehicle.w)
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
                    SetEntityAsMissionEntity(veh, true, true)
                    doCarDamage2(veh, vehicle)
                    SetVehicleNumberPlateText(veh, vehicle.plate)
                    TriggerServerEvent('qb-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                    QBCore.Functions.Notify("Đã Lấy Xe Biển Số "..vehicle.plate.."", "primary", 4500)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                    closeMenuFull()
                    SetVehicleEngineOn(veh, true, true)
                    --[[ local bienxe = GetVehicleNumberPlateText(veh)
                    if bienxe == vehicle.plate then
                        QBCore.Functions.Notify("Lấy Thành Công Xe Có Biển Số "..bienxe.."", "primary")
                    else
                        QBCore.Functions.Notify("Xe Của Bạn Bị Lỗi Biển Số, Hãy Báo Lại Cho Admin", "error", 60000)
                        TriggerServerEvent('qb-garage:server:refund')
                    end ]]
                end, vehicle.plate)
                TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
            end, Depots[currentGarage].spawnPoint, true)
            SetTimeout(250, function()
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
            end)
        else
            QBCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                QBCore.Functions.TriggerCallback('qb-garage:server:GetVehicleProperties', function(properties)
                    QBCore.Functions.SetVehicleProperties(veh, properties)
                    enginePercent = round(vehicle.engine / 10, 0)
                    bodyPercent = round(vehicle.body / 10, 0)
                    currentFuel = vehicle.fuel

                    if vehicle.plate ~= nil then
                        OutsideVehicles[vehicle.plate] = veh
                        TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                    end

                    SetVehicleNumberPlateText(veh, vehicle.plate)
                    SetEntityHeading(veh, Depots[currentGarage].takeVehicle.w)
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
                    SetEntityAsMissionEntity(veh, true, true)
                    doCarDamage2(veh, vehicle)
                    TriggerServerEvent('qb-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                    QBCore.Functions.Notify("Đã Lấy Xe Biển Số "..vehicle.plate.."", "primary", 4500)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                    closeMenuFull()
                    SetVehicleEngineOn(veh, true, true)
                    --[[ local bienxe = GetVehicleNumberPlateText(veh)
                    if bienxe == vehicle.plate then
                        QBCore.Functions.Notify("Lấy Thành Công Xe Có Biển Số "..bienxe.."", "primary")
                    else
                        QBCore.Functions.Notify("Xe Của Bạn Bị Lỗi Biển Số, Hãy Báo Lại Cho Admin", "error", 60000)
                        TriggerServerEvent('qb-garage:server:refund')
                    end ]]
                end, vehicle.plate)
                TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
            end, Depots[currentGarage].spawnPoint, true)
            SetTimeout(250, function()
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
            end)
        end
    else
        QBCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            QBCore.Functions.TriggerCallback('qb-garage:server:GetVehicleProperties', function(properties)
                QBCore.Functions.SetVehicleProperties(veh, properties)
                enginePercent = round(vehicle.engine / 10, 0)
                bodyPercent = round(vehicle.body / 10, 0)
                currentFuel = vehicle.fuel

                if vehicle.plate ~= nil then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end

                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, Depots[currentGarage].takeVehicle.w)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
                SetEntityAsMissionEntity(veh, true, true)
                doCarDamage2(veh, vehicle)
                TriggerServerEvent('qb-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                QBCore.Functions.Notify("Đã Lấy Xe Biển Số "..vehicle.plate.."", "primary", 4500)
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                closeMenuFull()
                SetVehicleEngineOn(veh, true, true)
                --[[ local bienxe = GetVehicleNumberPlateText(veh)
                if bienxe == vehicle.plate then
                    QBCore.Functions.Notify("Lấy Thành Công Xe Có Biển Số "..bienxe.."", "primary")
                else
                    QBCore.Functions.Notify("Xe Của Bạn Bị Lỗi Biển Số, Hãy Báo Lại Cho Admin", "error", 60000)
                    TriggerServerEvent('qb-garage:server:refund')
                end ]]
            end, vehicle.plate)
            TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
        end, Depots[currentGarage].spawnPoint, true)
        SetTimeout(250, function()
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
        end)
    end
end)

DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    for k, v in pairs(Garages) do
        if v.showBlip then
            local Garage = AddBlipForCoord(Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z)

            SetBlipSprite (Garage, 357)
            SetBlipDisplay(Garage, 4)
            SetBlipScale  (Garage, 0.65)
            SetBlipAsShortRange(Garage, true)
            SetBlipColour(Garage, 3)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Garages[k].label)
            EndTextCommandSetBlipName(Garage)
        end
    end

    for k, v in pairs(Depots) do
        if v.showBlip then
            local Depot = AddBlipForCoord(Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z)

            SetBlipSprite (Depot, 68)
            SetBlipDisplay(Depot, 4)
            SetBlipScale  (Depot, 0.7)
            SetBlipAsShortRange(Depot, true)
            SetBlipColour(Depot, 5)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Depots[k].label)
            EndTextCommandSetBlipName(Depot)
        end
    end
end)

function MenuGarage()
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Danh Sách Xe", "VehicleList", nil)
    Menu.addButton("Close Menu", "close", nil)
end

function GangMenuGarage()
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Danh Sách Xe", "GangVehicleList", nil)
    Menu.addButton("Close Menu", "close", nil)
end

function MenuDepot()
    ped = PlayerPedId();
    MenuTitle = "Impound"
    ClearMenu()
    Menu.addButton("Xe Bị Mất", "DepotList", nil)
    Menu.addButton("Close Menu", "close", nil)
end

function MenuHouseGarage(house)
    ped = PlayerPedId();
    MenuTitle = HouseGarages[house].label
    ClearMenu()
    Menu.addButton("Danh Sách Xe", "HouseGarage", house)
    Menu.addButton("Close Menu", "close", nil)
end

function HouseGarage(house)
    QBCore.Functions.TriggerCallback("qb-garage:server:GetHouseVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "Xe Bị Mất :"
        ClearMenu()

        if result == nil then
            QBCore.Functions.Notify("Bạn Không Có Xe Ở Đây", "error", 5000)
            closeMenuFull()
        else
            Menu.addButton(HouseGarages[house].label, "HouseGarage", HouseGarages[house].label)

            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                curGarage = HouseGarages[house].label

                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garaged"
                elseif v.state == 2 then
                    v.state = "Impound"
                end

                Menu.addButton(QBCore.Shared.Vehicles[v.vehicle]["name"], "TakeOutGarageVehicle", v, v.state , v.plate , " Motor: " .. enginePercent.."%", " Body: " .. bodyPercent.."%", " Fuel: "..currentFuel.."%")
            end
        end

        Menu.addButton("Trở Lại", "MenuHouseGarage", house)
    end, house)
end

function getPlayerVehicles(garage)
    local vehicles = {}

    return vehicles
end

function DepotList()
    QBCore.Functions.TriggerCallback("qb-garage:server:GetDepotVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "Xe Bị Giam Giữ :"
        ClearMenu()

        if result == nil then
            QBCore.Functions.Notify("Không Có Chiếc Xe Nào Bị Giam", "error", 5000)
            closeMenuFull()
        else
            Menu.addButton(Depots[currentGarage].label, "DepotList", Depots[currentGarage].label)

            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel


                if v.state == 0 then
                    v.state = "Impound"
                end

                Menu.addButton(QBCore.Shared.Vehicles[v.vehicle]["name"], "TakeOutDepotVehicle", v, v.state .. " ($"..v.depotprice..",-)", " Motor: " .. enginePercent.."%", " Body: " .. bodyPercent.."%", " Fuel: "..currentFuel.."%")
            end
        end

        Menu.addButton("Trở Lại", "MenuDepot",nil)
    end)
end

function VehicleList()
    QBCore.Functions.TriggerCallback("qb-garage:server:GetUserVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "Danh Sách Xe :"
        ClearMenu()

        if result == nil then
            QBCore.Functions.Notify("Bạn Không Có Chiếc Xe Nào Ở Đây", "error", 5000)
            closeMenuFull()
        else
            Menu.addButton(Garages[currentGarage].label, "VehicleList", Garages[currentGarage].label)

            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                curGarage = Garages[v.garage].label


                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garaged"
                elseif v.state == 2 then
                    v.state = "Impound"
                end

                Menu.addButton(QBCore.Shared.Vehicles[v.vehicle]["name"], "TakeOutVehicle", v, v.plate , v.state, " Motor: " .. enginePercent .. "%", " Body: " .. bodyPercent.. "%")
            end
        end

        Menu.addButton("Trở Lại", "MenuGarage",nil)
    end, currentGarage)
end

function GangVehicleList()
    QBCore.Functions.TriggerCallback("qb-garage:server:GetUserVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "Danh Sách Xe :"
        ClearMenu()

        if result == nil then
            QBCore.Functions.Notify("Bạn Không Có Chiếc Xe Nào Ở Đây", "error", 5000)
            closeMenuFull()
        else
            Menu.addButton(GangGarages[currentGarage].label, "GangVehicleList", GangGarages[currentGarage].label)

            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                curGarage = GangGarages[v.garage].label



                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garaged"
                elseif v.state == 2 then
                    v.state = "Impound"
                end

                Menu.addButton(QBCore.Shared.Vehicles[v.vehicle]["name"], "TakeOutGangVehicle", v, v.state, " Motor: " .. enginePercent .. "%", " Body: " .. bodyPercent.. "%", " Fuel: "..currentFuel.. "%")
            end
        end

        Menu.addButton("Trở Lại", "MenuGarage",nil)
    end, currentGarage)
end

local Antibug = false
function TakeOutVehicle(vehicle)
  --  print("đã chọn", vehicle.plate)
    Antibug = true
	if Antibug == true then
        if vehicle.state == "Garaged" then
            enginePercent = round(vehicle.engine / 10, 1)
            bodyPercent = round(vehicle.body / 10, 1)
            currentFuel = vehicle.fuel

            findVehFromPlateAndLocate(vehicle.plate)

            QBCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                QBCore.Functions.TriggerCallback('qb-garage:server:GetVehicleProperties', function(properties)

                    if vehicle.plate ~= nil then
                        OutsideVehicles[vehicle.plate] = veh
                        TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                    end

                    QBCore.Functions.SetVehicleProperties(veh, properties)
                    --print("hahaha", vehicle.plate)
                    SetVehicleNumberPlateText(veh, vehicle.plate)
                    SetEntityHeading(veh, Garages[currentGarage].spawnPoint.w)
                    exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
                    doCarDamage(veh, vehicle)
                    SetEntityAsMissionEntity(veh, true, true)
                    TriggerServerEvent('qb-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                    QBCore.Functions.Notify("Vehicle Off:Engine " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
                    closeMenuFull()
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                    SetVehicleEngineOn(veh, true, true)
                    SetVehicleNumberPlateText(veh, vehicle.plate)
                    local bienxe = GetVehicleNumberPlateText(veh)
                    if bienxe == vehicle.plate then
                        QBCore.Functions.Notify("Lấy Thành Công Xe Có Biển Số "..bienxe.."", "primary")
                        --TriggerServerEvent('qb-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                    else
                        QBCore.Functions.Notify("Xe Này Bị Lỗi Nên Đã Tự Động Xóa , Bạn Lấy Lại Đi Nhé", "error", 20000)
                        TriggerServerEvent('qb-garage:server:refund')
                       -- QBCore.Functions.DeleteVehicle(veh)
                    end
                end, vehicle.plate)
                Citizen.Wait(1000)
                Antibug = false

            end, Garages[currentGarage].spawnPoint, true)
        elseif vehicle.state == "Out" then
            QBCore.Functions.Notify("Chiếc Xe Của Bạn Đã Bị Mất", "error", 2500)
        elseif vehicle.state == "Impound" then
            QBCore.Functions.Notify("Chiếc xe này bị cảnh sát bị giam giữ", "error", 4000)
        end
    Citizen.Wait(1000)
	Antibug = false
	else
		QBCore.Functions.Notify("BUG!!", "primary", 4500) -- ban thao tac qa nhanh, xin hay doi trong giay lat
	end
end

local Antibug1 = false
function TakeOutGangVehicle(vehicle)
    Antibug1 = true
    if Antibug == true then
    if vehicle.state == "Garaged" then
        enginePercent = round(vehicle.engine / 10, 1)
        bodyPercent = round(vehicle.body / 10, 1)
        currentFuel = vehicle.fuel

        QBCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            QBCore.Functions.TriggerCallback('qb-garage:server:GetVehicleProperties', function(properties)

                if vehicle.plate ~= nil then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end

                QBCore.Functions.SetVehicleProperties(veh, properties)
                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, GangGarages[currentGarage].spawnPoint.w)
                exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
                doCarDamage(veh, vehicle)
                SetEntityAsMissionEntity(veh, true, true)
                TriggerServerEvent('qb-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                QBCore.Functions.Notify("Vehicle Off:Engine " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
                closeMenuFull()
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                SetVehicleEngineOn(veh, true, true)
            end, vehicle.plate)
            Citizen.Wait(1000)
			Antibug1 = false

        end, GangGarages[currentGarage].spawnPoint, true)
    elseif vehicle.state == "Out" then
        QBCore.Functions.Notify("Chiếc Xe Của Bạn Đã Bị Mất", "error", 2500)
    elseif vehicle.state == "Impound" then
        QBCore.Functions.Notify("Chiếc xe này bị cảnh sát bị giam giữ", "error", 4000)
    end
    Citizen.Wait(1000)
	Antibug1 = false
	else
		QBCore.Functions.Notify("BUG!!", "primary", 4500) -- ban thao tac qa nhanh, xin hay doi trong giay lat
	end
end

function TakeOutDepotVehicle(vehicle)
    if vehicle.state == "Impound" then
        TriggerServerEvent("qb-garage:server:PayDepotPrice", vehicle)
        Citizen.Wait(1000)
    end
end

function TakeOutGarageVehicle(vehicle)
    if vehicle.state == "Garaged" then
        QBCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            QBCore.Functions.TriggerCallback('qb-garage:server:GetVehicleProperties', function(properties)
                QBCore.Functions.SetVehicleProperties(veh, properties)
                enginePercent = round(vehicle.engine / 10, 1)
                bodyPercent = round(vehicle.body / 10, 1)
                currentFuel = vehicle.fuel

                if vehicle.plate ~= nil then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end

                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, HouseGarages[currentHouseGarage].takeVehicle.w)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
                SetEntityAsMissionEntity(veh, true, true)
                doCarDamage(veh, vehicle)
                TriggerServerEvent('qb-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                QBCore.Functions.Notify("Vehicle Off:Engine " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
                closeMenuFull()
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                SetVehicleEngineOn(veh, true, true)
                --[[ local bienxe = GetVehicleNumberPlateText(veh)
                if bienxe == vehicle.plate then
                    QBCore.Functions.Notify("Lấy Thành Công Xe Có Biển Số "..bienxe.."", "primary")
                else
                    QBCore.Functions.Notify("Xe Của Bạn Bị Lỗi Biển Số, Hãy Báo Lại Cho Admin", "error", 60000)
                    TriggerServerEvent('qb-garage:server:refund')
                end ]]
            end, vehicle.plate)
        end, HouseGarages[currentHouseGarage].takeVehicle, true)
    end
end

function doCarDamage2(currentVehicle, veh)
	smash = false
	damageOutside = false
	damageOutside2 = false
	local engine = 250 + 0.0
	local body = 250 + 0.0
	if engine < 200.0 then
		engine = 200.0
    end

    if engine > 1000.0 then
        engine = 1000.0
    end

	if body < 150.0 then
		body = 150.0
	end
	if body < 900.0 then
		smash = true
	end

	if body < 800.0 then
		damageOutside = true
	end

	if body < 500.0 then
		damageOutside2 = true
	end

    Citizen.Wait(100)
    SetVehicleEngineHealth(currentVehicle, engine)
	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 400.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 400.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 400.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 400.0)
	end
	if body < 1000 then 
		SetVehicleBodyHealth(currentVehicle, body)
        print(body)
	end
end

function doCarDamage(currentVehicle, veh)
	smash = false
	damageOutside = false
	damageOutside2 = false
	local engine = veh.engine + 0.0
	local body = veh.body + 0.0
	if engine < 200.0 then
		engine = 200.0
    end

    if engine > 1000.0 then
        engine = 1000.0
    end

	if body < 150.0 then
		body = 150.0
	end
	if body < 900.0 then
		smash = true
	end

	if body < 800.0 then
		damageOutside = true
	end

	if body < 500.0 then
		damageOutside2 = true
	end

    Citizen.Wait(100)
    SetVehicleEngineHealth(currentVehicle, engine)
	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end
	if body < 1000 then 
		SetVehicleBodyHealth(currentVehicle, body)
        print(body)
	end
end

function close()
    Menu.hidden = true
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function ClearMenu()
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false

        for k, v in pairs(Garages) do
            local takeDist = #(pos - vector3(Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z))
            if takeDist <= 15 then
                inGarageRange = true
                DrawMarker(2, Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                if takeDist <= 1.5 then
                    if not IsPedInAnyVehicle(ped) then
                        DrawText3Ds(Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
                        if IsControlJustPressed(1, 177) and not Menu.hidden then
                            close()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        end
                        if IsControlJustPressed(0, 38) then
                            MenuGarage()
                            Menu.hidden = not Menu.hidden
                            currentGarage = k
                        end
                    else
                        DrawText3Ds(Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z, Garages[k].label)
                    end
                end

                Menu.renderGUI()

                if takeDist >= 4 and not Menu.hidden then
                    closeMenuFull()
                end
            end

            local putDist = #(pos - vector3(Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z))

            if putDist <= 25 and IsPedInAnyVehicle(ped) then
                inGarageRange = true
                DrawMarker(2, Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 255, false, false, false, true, false, false, false)
                if putDist <= 1.5 then
                    DrawText3Ds(Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z + 0.5, '~g~E~w~ - Đậu Xe')
                    if IsControlJustPressed(0, 38) then
                        local curVeh = GetVehiclePedIsIn(ped)
                        local plate = GetVehicleNumberPlateText(curVeh)
                        QBCore.Functions.TriggerCallback('qb-garage:server:checkVehicleOwner', function(owned)
                            if owned then
                                local bodyDamage = math.ceil(GetVehicleBodyHealth(curVeh))
                                local engineDamage = math.ceil(GetVehicleEngineHealth(curVeh))
                                local totalFuel = exports['LegacyFuel']:GetFuel(curVeh)
                                local passenger = GetVehicleMaxNumberOfPassengers(curVeh)
                                local mods = QBCore.Functions.GetVehicleProperties(curVeh)
                                if cooldown then
                                    QBCore.Functions.Notify("Bạn Không Thể Cất Xe Quá Nhanh, Chờ 1 Phút")
                                else
                                    CheckPlayers(curVeh)
                                    TriggerServerEvent('qb-garage:server:updateVehicleStatus', mods, totalFuel, engineDamage, bodyDamage, plate, k)
                                    TriggerServerEvent('qb-garage:server:updateVehicleState', 1, plate, k)
                                
                                    if plate ~= nil then
                                        OutsideVehicles[plate] = veh
                                        TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                                    end
                                    QBCore.Functions.Notify("Chiếc Xe Đã Được Cất, "..Garages[k].label, "primary", 4500)
                                    cooldown = true
                                    Citizen.Wait(60000)
                                    cooldown = false
                                end
                                QBCore.Functions.Notify("Bạn Có Thể Cất Xe Bây Giờ", "primary", 4500)
                            else
                                QBCore.Functions.Notify("Bạn Không Phải Chủ Xe", "error", 3500)
                            end
                        end, plate)
                    end
                end
            end
        end

        if not inGarageRange then
            Citizen.Wait(1000)
        end
    end
end)

function CheckPlayers(vehicle)
    for i = -1, 5,1 do                
        seat = GetPedInVehicleSeat(vehicle,i)
        if seat ~= 0 then
            TaskLeaveVehicle(seat,vehicle,0)
            SetVehicleDoorsLocked(vehicle)
            Wait(1500)
            QBCore.Functions.DeleteVehicle(vehicle)
        end
    end
end


Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false
        if PlayerGang.name ~= nil then
        Name = PlayerGang.name.."garage"
        end
         for k, v in pairs(GangGarages) do
            
            if PlayerGang.name == GangGarages[k].job then
                local ballasDist = #(pos - vector3(GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z))
                if ballasDist <= 15 then
                    inGarageRange = true
                    DrawMarker(2, GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if ballasDist <= 1.5 then
                        if not IsPedInAnyVehicle(ped) then
                            DrawText3Ds(GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
                            if IsControlJustPressed(1, 177) and not Menu.hidden then
                                close()
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            end
                            if IsControlJustPressed(0, 38) then
                                GangMenuGarage()
                                Menu.hidden = not Menu.hidden
                                currentGarage = Name
                            end
                        else
                            DrawText3Ds(GangGarages[Name].takeVehicle.x, GangGarages[Name].takeVehicle.y, GangGarages[Name].takeVehicle.z, GangGarages[Name].label)
                        end
                    end

                    Menu.renderGUI()

                    if ballasDist >= 4 and not Menu.hidden then
                        closeMenuFull()
                    end
                end

                local putDist = #(pos - vector3(GangGarages[Name].putVehicle.x, GangGarages[Name].putVehicle.y, GangGarages[Name].putVehicle.z))

                if putDist <= 25 and IsPedInAnyVehicle(ped) then
                    inGarageRange = true
                    DrawMarker(2, GangGarages[Name].putVehicle.x, GangGarages[Name].putVehicle.y, GangGarages[Name].putVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 255, false, false, false, true, false, false, false)
                    if putDist <= 1.5 then
                        DrawText3Ds(GangGarages[Name].putVehicle.x, GangGarages[Name].putVehicle.y, GangGarages[Name].putVehicle.z + 0.5, '~g~E~w~ - Đậu Xe')
                        if IsControlJustPressed(0, 38) then
                            local curVeh = GetVehiclePedIsIn(ped)
                            local plate = GetVehicleNumberPlateText(curVeh)
                            QBCore.Functions.TriggerCallback('qb-garage:server:checkVehicleOwner', function(owned)
                                if owned then
                                    local bodyDamage = math.ceil(GetVehicleBodyHealth(curVeh))
                                    local engineDamage = math.ceil(GetVehicleEngineHealth(curVeh))
                                    local totalFuel = exports['LegacyFuel']:GetFuel(curVeh)
                                    local mods = QBCore.Functions.GetVehicleProperties(curVeh)
                                    CheckPlayers(curVeh)
                                    Wait(500)
                                    if DoesEntityExist(curVeh) then
                                        QBCore.Functions.Notify("Trong Xe Có Người.", "error", 4500)
                                    else
                                    TriggerServerEvent('qb-garage:server:updateVehicleStatus', mods, totalFuel, engineDamage, bodyDamage, plate, Name)
                                    TriggerServerEvent('qb-garage:server:updateVehicleState', 1, plate, Name)                                    
                                    if plate ~= nil then
                                        OutsideVehicles[plate] = veh
                                        TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                                    end
                                    QBCore.Functions.Notify("Chiếc Xe Đã Được Cất Tại "..GangGarages[Name].label, "primary", 4500)
                                end
                                else
                                    QBCore.Functions.Notify("Bạn Không Phải Chủ Xe", "error", 3500)
                                end
                            end, plate)
                        end
                    end
                end
            end
        end
        if not inGarageRange then
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false

        if HouseGarages ~= nil and currentHouseGarage ~= nil then
            if hasGarageKey and HouseGarages[currentHouseGarage] ~= nil and HouseGarages[currentHouseGarage].takeVehicle ~= nil then
                local takeDist = #(pos - vector3(HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z))
                if takeDist <= 15 then
                    inGarageRange = true
                    DrawMarker(2, HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if takeDist < 2.0 then
                        if not IsPedInAnyVehicle(ped) then
                            DrawText3Ds(HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
                            if IsControlJustPressed(1, 177) and not Menu.hidden then
                                close()
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            end
                            if IsControlJustPressed(0, 38) then
                                MenuHouseGarage(currentHouseGarage)
                                Menu.hidden = not Menu.hidden
                            end
                        elseif IsPedInAnyVehicle(ped) then
                            DrawText3Ds(HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z + 0.5, '~g~E~w~ - To Park')
                            if IsControlJustPressed(0, 38) then
                                local curVeh = GetVehiclePedIsIn(ped)
                                local plate = GetVehicleNumberPlateText(curVeh)
                                QBCore.Functions.TriggerCallback('qb-garage:server:checkVehicleHouseOwner', function(owned)
                                    if owned then
                                        local bodyDamage = round(GetVehicleBodyHealth(curVeh), 1)
                                        local engineDamage = round(GetVehicleEngineHealth(curVeh), 1)
                                        local totalFuel = exports['LegacyFuel']:GetFuel(curVeh)
                                        local mods = QBCore.Functions.GetVehicleProperties(curVeh)
                                            CheckPlayers(curVeh)
                                        if DoesEntityExist(curVeh) then
                                                QBCore.Functions.Notify("Có Người Trong Xe.", "error", 4500)
                                        else
                                        TriggerServerEvent('qb-garage:server:updateVehicleStatus', mods, totalFuel, engineDamage, bodyDamage, plate, currentHouseGarage)
                                        TriggerServerEvent('qb-garage:server:updateVehicleState', 1, plate, currentHouseGarage)
                                        QBCore.Functions.DeleteVehicle(curVeh)
                                        if plate ~= nil then
                                            OutsideVehicles[plate] = veh
                                            TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                                        end
                                        QBCore.Functions.Notify("Chiếc Xe Đã Được Cất Tại "..HouseGarages[currentHouseGarage], "primary", 4500)
                                    end
                                    else
                                        QBCore.Functions.Notify("Bạn Không Phải Chủ Xe", "error", 3500)
                                    end
                              
                                end, plate, currentHouseGarage)
                            end
                        end

                        Menu.renderGUI()
                    end

                    if takeDist > 1.99 and not Menu.hidden then
                        closeMenuFull()
                    end
                end
            end
        end

        if not inGarageRange then
            Citizen.Wait(5000)
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inGarageRange = false

        for k, v in pairs(Depots) do
            local takeDist = #(pos - vector3(Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z))
            if takeDist <= 15 then
                inGarageRange = true
                DrawMarker(2, Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                if takeDist <= 1.5 then
                    if not IsPedInAnyVehicle(ped) then
                        DrawText3Ds(Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
                        if IsControlJustPressed(1, 177) and not Menu.hidden then
                            close()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        end
                        if IsControlJustPressed(0, 38) then
                            MenuDepot()
                            Menu.hidden = not Menu.hidden
                            currentGarage = k
                        end
                    end
                end

                Menu.renderGUI()

                if takeDist >= 4 and not Menu.hidden then
                    closeMenuFull()
                end
            end
        end

        if not inGarageRange then
            Citizen.Wait(5000)
        end
    end
end)

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end



function findVehFromPlateAndLocate(plate)


    local gameVehicles = QBCore.Functions.GetVehicles()
  
    for i = 1, #gameVehicles do
        local vehicle = gameVehicles[i]
  
        if DoesEntityExist(vehicle) then
            if GetVehicleNumberPlateText(vehicle) == plate then
                local vehCoords = GetEntityCoords(vehicle)
                QBCore.Functions.DeleteVehicle(vehicle)
            end
        end
    end
end