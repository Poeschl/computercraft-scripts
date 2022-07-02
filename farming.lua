-- Farming turtle
-- farms and replants an field with specified widht and height
-- The turtle must be placed at one corner like so. (T = turtle, x = wheat). It is assumed that that farm has 1 space air around the wheat.
--
-- Txxxx
--  xxxx
--  xxxx
--

local function getSlotFor(tag)
  local slots = {}
  for slot = 1,16 do
    local item = turtle.getItemDetail(slot, true)
    if item ~= nil then
      local itemTags = item["tags"]
      if itemTags[tag] ~= nil and itemTags[tag] then
        table.insert(slots, slot)
      end
    end
  end
  return slots
end

local function countItems(slots)
  local sum = 0
  if #slots > 0 then
    for index = 1, #slots do
      sum = sum + turtle.getItemCount(slots[index])
    end
  end
  return sum
end

local function updateSeedSlots()
  SEED_SLOTS = getSlotFor("forge:seeds")
end

local function screenTemplate()
	shell.run("clear")
	print(TITLE)
	print("=======================================")
  print("Init system...")
	term.setCursorPos(1,5)
	term.clearLine()
	print("---------------------------------------")
end

local function time()
	term.setCursorPos(1, 1)
	local zeit
	zeit = textutils.formatTime(os.time(), true) -- 24h
  term.setCursorPos(35, 1)
	if (string.len(zeit) == 4) then -- before 10
    print(" " .. zeit)
	else -- after 10
    print(zeit)
	end
end

local function updateStatusLines()
  term.setCursorPos(1, 3)
	term.clearLine()
	local fuellevel = turtle.getFuelLevel()
  if (fuellevel < 500) then
    fuellevel = fuellevel .. "!! Warning !!"
  end
	print("Fuel: " .. fuellevel)

  term.setCursorPos(1, 4)
	term.clearLine()
	print("Farming Size: " .. FIELD_WIDTH .. " x " .. FIELD_LENGTH)
end

local function itemsCountUpdates()
  while true do
    updateSeedSlots()
    local seedCount = countItems(SEED_SLOTS)

    local fuelSlots = getSlotFor(COAL_TAG)
    local count = countItems(fuelSlots)

    term.setCursorPos(1,6)
    term.clearLine()
    print("Needed seeds for empty farm: " .. FIELD_LENGTH * FIELD_WIDTH )
    print("Detected " .. seedCount .. " (Slot:" .. table.concat(SEED_SLOTS,",") ..")" )

    if count > 0 then
      term.setCursorPos(1,9)
      term.clearLine()
      print("Will be refueled on start with " .. count .. " items.")
    end
    term.setCursorPos(30, 12) -- set to user input
    sleep(1)
  end
end

local function runningText()
  term.setCursorPos(1,11)
  term.clearLine()
  print("Run Farming logic")
  term.clearLine()
end

local function finishText()
  term.setCursorPos(1,11)
  term.clearLine()
  print("Finished Farming")
  term.clearLine()
end

local function screenUpdate()
  while true do
    time()
    updateStatusLines()
    term.setCursorPos(30, 12) -- set to user input
    sleep(0.4)
  end
end

local function waitForStart()
  while true do
    term.setCursorPos(1,11)
    term.clearLine()
    print("Hit Enter to start farming")
    print("(Settings in config file)")
    term.setCursorPos(30, 12) -- set to user input

    local inputstring = read()
    if (inputstring ~= nil) then -- check for input (Enter is empty input)
      return -- exit loop and start
    end
  end
end

local function saveConfig()
	local config = fs.open("farming.conf", "w")
	config.writeLine("fieldWidth      = " .. FIELD_WIDTH)
	config.writeLine("fieldLength     = " .. FIELD_LENGTH)
	config.close()
end

local function readConfig()
  if not fs.exists("farming.conf") then
    saveConfig()
  end

	local config = fs.open("farming.conf", "r")
	if config then
		local line = config.readLine()
		FIELD_WIDTH = tonumber(string.sub(line,18,21))
		line = config.readLine()
		FIELD_LENGTH = tonumber(string.sub(line,18,21))
		config.close()
    end
end

local function refuel()
  local fuelSlots = getSlotFor(COAL_TAG)
  if #fuelSlots > 0 then
    for slot = 1, #fuelSlots do
      turtle.select(slot)
      turtle.refuel()
    end
  end
end

local function harvestBelow()
  turtle.digDown()
end

local function plantBelow()
  local seedSlot = SEED_SLOTS[1]
  if turtle.getItemCount(seedSlot) < 1 then
    updateSeedSlots()
    seedSlot = SEED_SLOTS[1]
  end

  turtle.select(seedSlot)
  turtle.placeDown()
end

local function doLine()
  local limit = FIELD_LENGTH

  for block = 1, limit do
    harvestBelow()
    plantBelow()

    if block < limit then
      turtle.forward()
    end
  end

end

local function backToBaseLine()
  for i = 1, FIELD_LENGTH - 1 do
    turtle.back()
  end
end

local function farm()
  turtle.up()
  turtle.forward()
  local limit = FIELD_WIDTH
  for line = 1, limit do
    doLine()
    backToBaseLine()

    if line < limit then
      turtle.turnRight()
      turtle.forward()
      turtle.turnLeft()
    end
  end

  turtle.turnLeft()
  for i = 1, FIELD_WIDTH - 1 do
    turtle.forward()
  end
  turtle.turnLeft()
  turtle.forward()
  turtle.down()
end

-- global vars
TITLE = "P-Farming"
COAL_TAG = "minecraft:coal"
SEED_SLOTS = {}

-- config vars
FIELD_WIDTH = 16 -- length in front of the turtle
FIELD_LENGTH = 16 --length to the right side of the turtle

readConfig()
screenTemplate()

parallel.waitForAny(waitForStart, screenUpdate, itemsCountUpdates)

runningText()
refuel()
farm()
finishText()
