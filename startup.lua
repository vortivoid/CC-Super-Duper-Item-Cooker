term.clear()
term.setCursorPos(1,1)

print("Super Duper Item Cooker Script")
sleep(1)
print("By VortiVoid")
sleep(2)


-- Register attached cooking peripherals IDs for quick transfers
function registerCookingBlocks()
    term.clear()
    term.setCursorPos(1,1)
    local cookingBlocks = {
    furnaces = {},
    smokers = {},
    blastFurnaces = {}
}
    print("Registering connected cooking blocks...")
    for _, furnace in ipairs(table.pack(peripheral.find("minecraft:furnace"))) do
        table.insert(cookingBlocks["furnaces"], peripheral.getName(furnace))
    end
    for _, smoker in ipairs(table.pack(peripheral.find("minecraft:smoker"))) do
        table.insert(cookingBlocks["smokers"], peripheral.getName(smoker))
    end
    for _, blastFurnace in ipairs(table.pack(peripheral.find("minecraft:blast_furnace"))) do
        table.insert(cookingBlocks["blastFurnaces"], peripheral.getName(blastFurnace))
    end

    local file = fs.open("registeredCookingBlocks.json", "w")
    file.write(textutils.serialiseJSON(cookingBlocks))
    file.close()

    print("Finished registering cooking blocks!")
end

function registerInputOutput()
    if fs.exists("/inputOutput.json") then
        term.clear()
        term.setCursorPos(1,1)
        local file = fs.open("inputOutput.json", "r")
        local inputOutputData = textutils.unserialiseJSON(file.readAll())
        print("Existing data found:")
        print("Item Input:", inputOutputData.itemInput)
        print("Fuel Input:", inputOutputData.fuelInput)
        print("Item Output:", inputOutputData.itemOutput)
        print("Is the above information correct?")
        term.write("(Y/N): ")
        local storageChangedResponse = read()
        if string.upper(storageChangedResponse) == "Y" then 
            return
        end
    end
    print("Please enter the following peripheral IDs for each item (example: minecraft:chest_2)")
    write("Item Input: ")
    local newItemInput = validatePeripheral(read())
    write("Fuel Input: ")
    local newFuelInput = validatePeripheral(read())
    write("Item Output: ")
    local newItemOutput = validatePeripheral(read())

    local inputOutput = {itemInput = newItemInput, fuelInput = newFuelInput, itemOutput = newItemOutput}

    local file = fs.open("inputOutput.json", "w")
    file.write(textutils.serialiseJSON(inputOutput))
    file.close()
end

function validatePeripheral(ID)
    while not peripheral.isPresent(ID) do
        print("Peripheral not detected! Please double-check and try again:")
        term.write("Enter ID: ")
        ID = read()
    end
    return ID
end

function startProgram(path)
    print("Starting", path, "...")
    sleep(1)
    shell.openTab(path)
    sleep(1)
end

-- Main sequence
registerCookingBlocks()
registerInputOutput()
startProgram("itemInputSorter.lua")
startProgram("fuelInputSorter.lua")
startProgram("outputSorter.lua")
print("All programs started!")
while true do
    sleep(0.05)
end