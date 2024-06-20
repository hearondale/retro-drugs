local ox_inventory = exports.ox_inventory

lib.callback.register('drugs:sellToNPC', function(source, itemname, cnt)
    local source = source

    local result = ox_inventory:RemoveItem(source, itemname, cnt + 1)
    if result then
        ox_inventory:AddItem(source, 'money', Config.Price[itemname])
    else
        lib.notify(source, {
            title = 'Не вышло',
            description = 'Покупатель хотел приобрести больше товара, чем у вас есть',
            type = 'error'
        })
    end
end)