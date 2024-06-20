local ox_inventory = exports.ox_inventory

lib.callback.register('drugs:sellToNPC', function(source, itemname, cnt)
    local source = source

    local result = ox_inventory:RemoveItem(source, itemname, cnt + 1)
    if result then
        ox_inventory:AddItem(source, 'money', Config.Price[itemname])
    else
        lib.notify(source, {
            title = 'Bad luck',
            description = 'The buyer wanted to purchase more goods than you have',
            type = 'error'
        })
    end
end)
