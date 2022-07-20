-- Will output a redstone signal to a given side, when a player is detected by a connected Player Detector (Advanced Peripherals)

REDSTONE_SIDE = "right"
PLAYER_DETECTOR_SIDE = "left"
RANGE = 3
KNOWN_PLAYERS = {"Poeschl"}

local playerDetector = peripheral.find("playerDetector")

local function sendRedstone(on)
    redstone.setOutput(REDSTONE_SIDE, on)
end

local function isKnownPlayerInRange()
    for index, username in ipairs(KNOWN_PLAYERS) do
        if playerDetector.isPlayerInRange(RANGE, username) then
            print("Player '" .. username .. "' detected")
            return true
        end
    end
    return false
end

print("Start player detection loop")

while true do
    sendRedstone(isKnownPlayerInRange())
    sleep(0.2)
end