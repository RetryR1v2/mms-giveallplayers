local VORPcore = exports.vorp_core:GetCore()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-giveallplayers/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end
-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------

--- Get Player Data

RegisterServerEvent('mms-giveallplayers:server:getplayerdata',function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local group = Character.group
    TriggerClientEvent('mms-giveallplayers:client:recieveuserdata',src,group)
end)

--- Give All Players

RegisterServerEvent('mms-giveallplayers:client:GiveAllPlayersEvent',function(CheckboxItem,CheckboxMoney,InputItemName,InputAmount)
    local src = source
    local SrcCharacter = VORPcore.getUser(src).getUsedCharacter
    local Srcfirstname = SrcCharacter.firstname
    local Srclastname = SrcCharacter.lastname
    local SrcGroup = SrcCharacter.group
    local InputAmountNumber = tonumber(InputAmount)
    -- Check if Admin Runs this
    if SrcGroup == Config.AdminGroup then
        if CheckboxItem then
            for _, player in ipairs(GetPlayers()) do
                if #GetPlayers() ~= nil then
                    local Character = VORPcore.getUser(player).getUsedCharacter
                    local charidentifier = Character.charIdentifier
                    if charidentifier ~= nil then
                        local CanCarry = exports.vorp_inventory:canCarryItem(src, InputItemName, InputAmountNumber)
                        if CanCarry then
                            exports.vorp_inventory:addItem(player, InputItemName, InputAmountNumber, nil, nil)
                            VORPcore.NotifyTip(player,_U('YouGotAnItem') .. InputAmountNumber .. ' ' .. InputItemName .. _U('GivenFrom') .. Srcfirstname .. ' ' .. Srclastname,"right",10000)
                        end
                    end
                end
            end
        elseif CheckboxMoney then
            for _, player in ipairs(GetPlayers()) do
                if #GetPlayers() ~= nil then
                local Character = VORPcore.getUser(player).getUsedCharacter
                local charidentifier = Character.charIdentifier
                   if charidentifier ~= nil then
                        Character.addCurrency(0, InputAmountNumber)
                        VORPcore.NotifyTip(player,_U('YouGotAnItem') .. InputAmountNumber .. _U('DollaGivenFrom') .. Srcfirstname .. ' ' .. Srclastname,"right",10000)
                    end
                end
            end
        end
    end
end)


--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()