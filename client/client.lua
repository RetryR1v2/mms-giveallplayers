local VORPcore = exports.vorp_core:GetCore()
local FeatherMenu =  exports['feather-menu'].initiate()

local CheckboxItem = false
local CheckboxMoney = false

---------------------------------------------------------------------------------
-- Get Player Data
Citizen.CreateThread(function ()
    Citizen.Wait(3000)
    TriggerServerEvent('mms-giveallplayers:server:getplayerdata')
end)

RegisterNetEvent('vorp:SelectedCharacter')
AddEventHandler('vorp:SelectedCharacter', function()
    Citizen.Wait(5000)
    TriggerServerEvent('mms-giveallplayers:server:getplayerdata')
end)

RegisterNetEvent('mms-giveallplayers:client:recieveuserdata')
AddEventHandler('mms-giveallplayers:client:recieveuserdata',function(group)
    --- CHECK IF ADMIN TO GIVE ALL MENU POPUP
    if group == Config.AdminGroup then
        RegisterCommand(Config.GiveAllCommand, function()
            GiveAllMenu:Open({
                startupPage = GiveAllMenuPage1,
            })
        end)
    end
end)


-------------------------------------- MENU ---------------------------------

Citizen.CreateThread(function()  
    GiveAllMenu = FeatherMenu:RegisterMenu('feather:character:giveallmenu', {
        top = '10%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '700px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '800px',
        style = {
            ['border'] = '5px solid orange',
            -- ['background-image'] = 'none',
            ['background-color'] = '#FF8C00'
        },
        contentslot = {
            style = {
                ['height'] = '550px',
                ['min-height'] = '550px'
            }
        },
        draggable = true,
    --canclose = false
}, {
    opened = function()
        --print("MENU OPENED!")
    end,
    closed = function()
        --print("MENU CLOSED!")
    end,
    topage = function(data)
        --print("PAGE CHANGED ", data.pageid)
    end
})
    GiveAllMenuPage1 = GiveAllMenu:RegisterPage('seite1')
    GiveAllMenuPage1:RegisterElement('header', {
        value = _U('GiveAllHeader'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    GiveAllMenuPage1:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    GiveAllMenuPage1:RegisterElement("checkbox", {
        label = _U('Item'),
        start = false,
        sound = {
            action = "SELECT",
            soundset = "RDRO_Character_Creator_Sounds"
        },
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        }
    }, function(data)
        CheckboxItem = data.value
    end)
    GiveAllMenuPage1:RegisterElement("checkbox", {
        label = _U('Money'),
        start = false,
        sound = {
            action = "SELECT",
            soundset = "RDRO_Character_Creator_Sounds"
        },
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        }
    }, function(data)
        CheckboxMoney = data.value
    end)
    local InputItemName = ''
    GiveAllMenuPage1:RegisterElement('input', {
        label = _U('ItemName1'),
        placeholder = _U('ItemName2'),
        persist = false,
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
    }
    }, function(data)
        InputItemName = data.value
    end)
    local InputAmount = ''
    GiveAllMenuPage1:RegisterElement('input', {
        label = _U('Amount1'),
        placeholder = _U('Amount2'),
        persist = false,
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
    }
    }, function(data)
        InputAmount = data.value
    end)
    GiveAllMenuPage1:RegisterElement('button', {
        label = _U('GiveAllButton'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-giveallplayers:client:GiveAllPlayersEvent',CheckboxItem,CheckboxMoney,InputItemName,InputAmount)
    end)
    GiveAllMenuPage1:RegisterElement('button', {
        label =  _U('CloseMenu'),
        style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
        },
    }, function()
        GiveAllMenu:Close({ 
        })
    end)
    GiveAllMenuPage1:RegisterElement('subheader', {
        value = _U('GiveAllHeader'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    GiveAllMenuPage1:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })


end)

RegisterNetEvent('mms-giveallplayers:client:GiveAllPlayersEvent')
AddEventHandler('mms-giveallplayers:client:GiveAllPlayersEvent',function (CheckboxItem,CheckboxMoney,InputItemName,InputAmount)
    TriggerServerEvent('mms-giveallplayers:client:GiveAllPlayersEvent',CheckboxItem,CheckboxMoney,InputItemName,InputAmount)
end)