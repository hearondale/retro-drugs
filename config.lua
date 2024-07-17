Config = {}

Config.Debug = false

Config.maxDistToSell = 2
Config.timeOfSelling = 3000 -- In ms

Config.chanceToSell = 40 -- in percent
Config.maxAmountToSell = 3

Config.chanceToCallCops = 25 -- in percent

Config.Target = {
    weed_baggy = 'Offer weed',
    lsd_mark = 'Offer LSD mark',
}


Config.Drugs = {
    weed_baggy = {
        price = 51,
        target_label = 'Offer weed',
        icon = 'fas fa-cannabis'
    },
    lsd_mark = {
        price = 112,
        target_label = 'Offer LSD mark',
        icon = 'fas fa-cannabis'
    }
}

Config.Failure = {
    title = 'Bad luck',
    description = 'The buyer wanted to purchase more goods than you have',
}

Config.suspissiousCallOfServerEvent = 'You have definetely done something suspicious'

