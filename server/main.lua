local ox_inventory = exports.ox_inventory

lib.callback.register('drugs:sellToNPC', function(source, itemname, cnt, ped)
    if DoesEntityExist(ped) or not Config.Drugs[itemname].price then
        DropPlayer(source, Config.suspissiousCallOfServerEvent)
    end

    local result = ox_inventory:RemoveItem(source, itemname, cnt + 1)
    if result then
        ox_inventory:AddItem(source, 'money', Config.Drugs[itemname].price * (cnt + 1))
        return true
    else
        return false
    end
end)