local firstPersonVehicleEnabled = true
local WasAimingThirdPerson = false

-- Export function to enable/disable first person vehicle aiming cam
function SetFirstPersonVehicleEnabled(state)
    firstPersonVehicleEnabled = state
end

exports("setFirstPersonVehicleEnabled", SetFirstPersonVehicleEnabled)

CreateThread(function()
    while true do
        Wait(0)

        if firstPersonVehicleEnabled then
            local ped = PlayerPedId()
            local isInVehicle = IsPedInAnyVehicle(ped, false)
            local viewMode = GetFollowVehicleCamViewMode() -- 1 = third-person far, 2 = third-person medium, 3 = third-person close, 4 = first-person
            local isAiming = (IsControlPressed(0, 25) and IsUsingKeyboard(0)) or IsAimCamActive()

            if isInVehicle and isAiming and not WasAimingThirdPerson then
                if viewMode ~= 4 then
                    WasAimingThirdPerson = viewMode -- save current view mode
                    SetFollowVehicleCamViewMode(4) -- set to first person
                    DisableAimCamThisUpdate() -- prevent aim cam from overriding view
                end
            elseif WasAimingThirdPerson and not isAiming then
                SetFollowVehicleCamViewMode(WasAimingThirdPerson) -- restore saved view mode
                WasAimingThirdPerson = false
            end
        elseif WasAimingThirdPerson then
            -- if feature was disabled while aiming, restore camera
            SetFollowVehicleCamViewMode(WasAimingThirdPerson)
            WasAimingThirdPerson = false
        end
    end
end)