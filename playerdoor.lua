-- Will output a redstone signal to a given side, when a player is detected by a connected Player Detector (Advanced Peripherals)

REDSTONE_SIDE = "right"
PLAYER_DETECTOR_SIDE = "left"
RANGE_DAY = 3
RANGE_NIGHT = 2
KNOWN_PLAYERS = {"Poeschl"}

local playerDetector = peripheral.find("playerDetector")

local function sendRedstone(on)
    redstone.setOutput(REDSTONE_SIDE, on)
end

local function isKnownPlayerInRange(range)
    for index, username in ipairs(KNOWN_PLAYERS) do
        if playerDetector.isPlayerInRange(range, username) then
            print("Player '" .. username .. "' detected")
            return true
        end
    end
    return false
end

local function isDay()
    local time = os.time()
    return time > 6000 and time < 18000
end

print("Start player detection loop")

while true do
    if isDay() then
        sendRedstone(isKnownPlayerInRange(RANGE_DAY))
    else
        sendRedstone(isKnownPlayerInRange(RANGE_NIGHT))
    end
    sleep(0.2)
end