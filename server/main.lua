local ox_inventory = exports.ox_inventory

lib.callback.register('drugs:sellToNPC', function(source, itemname, cnt, ped)
    if DoesEntityExist(ped) then
        DropPlayer(source, "You obviously did smth suspicious")
    end

    local result = ox_inventory:RemoveItem(source, itemname, cnt + 1)
    if result then
        ox_inventory:AddItem(source, 'money', Config.Price[itemname])
        return true
    else
        return false
    end
end)
