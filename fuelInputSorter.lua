furnaceIncrement = 1
smokerIncrement = 1
blastFurnaceIncrement = 1

function loadJSONData(path)
    local file = fs.open(path, "r")
    local data = textutils.unserialiseJSON(file.readAll())
    file.close()
    return data
end
cookingBlocks = loadJSONData("registeredCookingBlocks.json")

function registerFuelInput()
    local data = loadJSONData("inputOutput.json")
    fuelInput = peripheral.wrap(data.fuelInput)
end

-- Move fuel to all cooking blocks
function sortInputFuel()

    for slot, fuel in pairs(fuelInput.list()) do
        for i = 1, fuel.count do
            moveItemToSmoker(slot)
            smokerIncrement = smokerIncrement + 1
            if smokerIncrement > #cookingBlocks["smokers"] then smokerIncrement = 1 end

            moveItemToBlastFurnace(slot)
            blastFurnaceIncrement = blastFurnaceIncrement + 1
            if blastFurnaceIncrement > #cookingBlocks["blastFurnaces"] then blastFurnaceIncrement = 1 end

            moveItemToFurnace(slot)
            furnaceIncrement = furnaceIncrement + 1
            if furnaceIncrement > #cookingBlocks["furnaces"] then furnaceIncrement = 1 end
        end
    end
end

--## Item movement ##--
function moveItemToFurnace(slot)
    fuelInput.pushItems(cookingBlocks["furnaces"][furnaceIncrement],slot,1,2)
end

function moveItemToSmoker(slot)
    fuelInput.pushItems(cookingBlocks["smokers"][smokerIncrement],slot,1,2)
end

function moveItemToBlastFurnace(slot)
    fuelInput.pushItems(cookingBlocks["blastFurnaces"][blastFurnaceIncrement],slot,1,2)
end

registerFuelInput()
while true do
    sortInputFuel()
    sleep(0.05)
end