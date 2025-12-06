function loadJSONData(path)
    local file = fs.open(path, "r")
    local data = textutils.unserialiseJSON(file.readAll())
    file.close()
    return data
end
cookingBlocks = loadJSONData("registeredCookingBlocks.json")

function registerItemOutput()
    local data = loadJSONData("inputOutput.json")
    itemOutput = peripheral.wrap(data.itemOutput)
end

function findAndExtract()
    for _, block in pairs(cookingBlocks.furnaces) do
        itemOutput.pullItems(block,3)
    end

    for _, block in pairs(cookingBlocks.smokers) do
        itemOutput.pullItems(block,3)
    end

        for _, block in pairs(cookingBlocks.blastFurnaces) do
        itemOutput.pullItems(block,3)
    end
end

registerItemOutput()
while true do
    findAndExtract()
    sleep(0.05)
end