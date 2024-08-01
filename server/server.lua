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

RegisterServerEvent('mms-giveallplayers:client:GiveAllPlayersEvent',function(CheckboxItem,CheckboxRemoveItem,CheckboxMoney,CheckboxRemoveMoney,CheckboxWeapon,InputItemName,InputAmount,InputWeapon)
    local src = source
    local SrcCharacter = VORPcore.getUser(src).getUsedCharacter
    local Srcfirstname = SrcCharacter.firstname
    local Srclastname = SrcCharacter.lastname
    local SrcGroup = SrcCharacter.group
    local InputAmountNumber = tonumber(InputAmount)
    if SrcGroup == Config.AdminGroup then
        if CheckboxItem then
            for _, player in ipairs(GetPlayers()) do
                if #GetPlayers() ~= nil then
                    local Character = VORPcore.getUser(player).getUsedCharacter
                    local charidentifier = Character.charIdentifier
                    local PlayerFirstname = Character.firstname
                    local PlayerLastname = Character.lastname
                    if charidentifier ~= nil then
                        local CanCarry = exports.vorp_inventory:canCarryItem(src, InputItemName, InputAmountNumber)
                        if CanCarry then
                            exports.vorp_inventory:addItem(player, InputItemName, InputAmountNumber, nil, nil)
                            VORPcore.NotifyTip(player,_U('YouGotAnItem') .. InputAmountNumber .. ' ' .. InputItemName .. _U('GivenFrom') .. Srcfirstname .. ' ' .. Srclastname,"right",10000)
                            if Config.WebHook then
                                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink,Srcfirstname .. ' ' .. Srclastname .. ' Gave ' .. InputAmountNumber .. ' ' .. InputItemName .. ' To ' .. PlayerFirstname .. ' ' .. PlayerLastname, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                            end
                        end
                    end
                end
            end
        elseif CheckboxRemoveItem then
            for _, player in ipairs(GetPlayers()) do
                if #GetPlayers() ~= nil then
                    local Character = VORPcore.getUser(player).getUsedCharacter
                    local charidentifier = Character.charIdentifier
                    local PlayerFirstname = Character.firstname
                    local PlayerLastname = Character.lastname
                    if charidentifier ~= nil then
                        local HasItem = exports.vorp_inventory:getItemCount(player, nil, InputItemName,nil)
                        if HasItem >= InputAmountNumber then
                            exports.vorp_inventory:subItem(player, InputItemName, InputAmountNumber, nil, nil)
                            VORPcore.NotifyTip(player,_U('YouGotAnItem') .. InputAmountNumber .. ' ' .. InputItemName .. _U('RemovedFrom') .. Srcfirstname .. ' ' .. Srclastname,"right",10000)
                            if Config.WebHook then
                                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink,Srcfirstname .. ' ' .. Srclastname .. ' Removed ' .. InputAmountNumber .. ' ' .. InputItemName .. ' From ' .. PlayerFirstname .. ' ' .. PlayerLastname, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                            end
                        end
                    end
                end
            end
        elseif CheckboxMoney then
            for _, player in ipairs(GetPlayers()) do
                if #GetPlayers() ~= nil then
                    local Character = VORPcore.getUser(player).getUsedCharacter
                    local charidentifier = Character.charIdentifier
                    local PlayerFirstname = Character.firstname
                    local PlayerLastname = Character.lastname
                   if charidentifier ~= nil then
                        Character.addCurrency(0, InputAmountNumber)
                        VORPcore.NotifyTip(player,_U('YouGotAnItem') .. InputAmountNumber .. _U('DollaGivenFrom') .. Srcfirstname .. ' ' .. Srclastname,"right",10000)
                        if Config.WebHook then
                            VORPcore.AddWebhook(Config.WHTitle, Config.WHLink,Srcfirstname .. ' ' .. Srclastname .. ' Gave ' .. InputAmountNumber .. ' $ To ' .. PlayerFirstname .. ' ' .. PlayerLastname, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                        end
                    end
                end
            end
        elseif CheckboxRemoveMoney then
            for _, player in ipairs(GetPlayers()) do
                if #GetPlayers() ~= nil then
                    local Character = VORPcore.getUser(player).getUsedCharacter
                    local charidentifier = Character.charIdentifier
                    local PlayerFirstname = Character.firstname
                    local PlayerLastname = Character.lastname
                   if charidentifier ~= nil then
                        local PlayerMoney = Character.money
                        if PlayerMoney >= InputAmountNumber then
                            Character.removeCurrency(0, InputAmountNumber)
                            VORPcore.NotifyTip(player,_U('YouGotAnItem') .. InputAmountNumber .. _U('DollaRemovedFrom') .. Srcfirstname .. ' ' .. Srclastname,"right",10000)
                            if Config.WebHook then
                                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink,Srcfirstname .. ' ' .. Srclastname .. ' Removed ' .. InputAmountNumber .. ' $ From ' .. PlayerFirstname .. ' ' .. PlayerLastname, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                            end
                        end
                    end
                end
            end
        elseif CheckboxWeapon then
            for _, player in ipairs(GetPlayers()) do
                if #GetPlayers() ~= nil then
                    local Character = VORPcore.getUser(player).getUsedCharacter
                    local charidentifier = Character.charIdentifier
                    local PlayerFirstname = Character.firstname
                    local PlayerLastname = Character.lastname
                    if charidentifier ~= nil then
                        local canCarryWeapons = exports.vorp_inventory:canCarryWeapons(player, 1, nil, InputWeapon)
                        if canCarryWeapons then
                            exports.vorp_inventory:createWeapon(player, InputWeapon, nil, nil, nil,nil,'00000-00000','Given by Admin','This Weapon was Given by Admin')
                            VORPcore.NotifyTip(player,_U('YouGotAnWeapon') .. InputWeapon .. _U('GivenFrom') .. Srcfirstname .. ' ' .. Srclastname,"right",10000)
                            if Config.WebHook then
                                VORPcore.AddWebhook(Config.WHTitle, Config.WHLink,Srcfirstname .. ' ' .. Srclastname .. ' Gave ' .. InputWeapon .. ' To ' .. PlayerFirstname .. ' ' .. PlayerLastname, Config.WHColor, Config.WHName, Config.WHLogo, Config.WHFooterLogo, Config.WHAvatar)
                            end
                        end
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