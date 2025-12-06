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
smokerItemList = loadJSONData("smokerItemList.json").items
blastFurnaceItemList = loadJSONData("blastFurnaceItemList.json").items

function registerItemInput()
    local data = loadJSONData("inputOutput.json")
    itemInput = peripheral.wrap(data.itemInput)
end

-- Move items with a function based on whether it's present in a list
function sortInputItems()

    for slot, item in pairs(itemInput.list()) do
        for i = 1, item.count do
            if isSmokerItem(item.name) then
                moveItemToSmoker(slot)
                smokerIncrement = smokerIncrement + 1
                if smokerIncrement > #cookingBlocks["smokers"] then smokerIncrement = 1 end
            elseif isBlastFurnaceItem(item.name) then
                moveItemToBlastFurnace(slot)
                blastFurnaceIncrement = blastFurnaceIncrement + 1
                if blastFurnaceIncrement > #cookingBlocks["blastFurnaces"] then blastFurnaceIncrement = 1 end
            else
                moveItemToFurnace(slot)
                furnaceIncrement = furnaceIncrement + 1
                if furnaceIncrement > #cookingBlocks["furnaces"] then furnaceIncrement = 1 end
            end
        end
    end
end

--## Item movement ##--
function moveItemToFurnace(slot)
    itemInput.pushItems(cookingBlocks["furnaces"][furnaceIncrement],slot,1,1)
end

function moveItemToSmoker(slot)
    itemInput.pushItems(cookingBlocks["smokers"][smokerIncrement],slot,1,1)
end

function moveItemToBlastFurnace(slot)
    itemInput.pushItems(cookingBlocks["blastFurnaces"][blastFurnaceIncrement],slot,1,1)
end

-- ## Item type checking ##--
function isSmokerItem(itemName)
    for _, smokerItemName in pairs(smokerItemList) do
        if itemName == smokerItemName then
            return true
        end
    end
    return false -- If not found in list
end

function isBlastFurnaceItem(itemName)
    for _, blastFurnaceItemName in ipairs(blastFurnaceItemList) do
        if itemName == blastFurnaceItemName then
            return true
        end
    end
    return false -- If not found in list
end

--## Program opening & main loop ##--
registerItemInput()
while true do
    sortInputItems()
    sleep(0.05)
end