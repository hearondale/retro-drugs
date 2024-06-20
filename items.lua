["weed_baggy"] = {
    label = "Some weed",
    weight = 5,
    buttons = {
        {
            label = 'Offer to a passerby',
            action = function(slot)
                exports['retro-drugs']:selltoNPC('weed_baggy') -- name of defined item (above)
            end
        }
    }
}

["lsd_mark"] = {
    label = "Mark of LSD",
    weight = 5,
    buttons = {
        {
            label = 'Offer to a passerby',
            action = function(slot)
                exports['retro-drugs']:selltoNPC('lsd_mark') -- name of defined item (above)
            end
        }
    }
}