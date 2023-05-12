-- A simple script which displays the charged percent as well as a trend of an energy cell or induction matrix.
-- When a monitor is connected via a network cable or direct it will display it as well (advanced monitor -> with colors)
-- An redstone high signal is outputed on the right side of the computer if the level is below the charge_threshold. (Low otherwise)
-- An redstone high signal is output to the top if the level is below alarm_threshold. (Low otherwise)

-- Requires the try-catch.lua file
require "try-catch"

BATTERY_TYPE = "mekanism:induction_port"
CHARGE_THRESHOLD = 0.6
CHARGE_OUTPUT_SIDE = 'right'
CHARGE_INVERT_OUTPUT = false
ALARM_THRESHOLD = 0.3
ALARM_OUTPUT_SIDE = 'top'
ALARM_INVERT_OUTPUT = false
PRECISION_DISPLAYED = 3
UPDATE_INTERVAL_SEC = 2

LAST_PERCENTAGE = 0

local function blank_external_monitors() 
  local monitors = { peripheral.find("monitor") }

  for _, monitor in pairs(monitors) do
    monitor.setTextColor(colors.white)
    monitor.setBackgroundColour(colors.blue)
    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.write("Error")
  end
end

local function display_external(current, trend)
  local monitors = { peripheral.find("monitor") }

  for _, monitor in pairs(monitors) do
    monitor.setTextColor(colors.black)

    if current < (ALARM_THRESHOLD * 100) then
      monitor.setBackgroundColour(colors.red)
    elseif current < (CHARGE_THRESHOLD * 100) then
      monitor.setBackgroundColour(colors.orange)
    else
      monitor.setBackgroundColour(colors.green)
    end

    monitor.clear()
    monitor.setTextScale(1) -- Reset text scale
    local monitor_size = monitor.getSize()

    -- Switch between big and small infos
    if monitor_size <= 7 then
      monitor.setTextScale(0.5)
      monitor.setCursorPos(1, 1)
      monitor.write("Current:")
      monitor.setCursorPos(1, 2)
      monitor.write(current .. "%")
      monitor.setCursorPos(1, 3)
      monitor.write("Trend:")
      monitor.setCursorPos(1, 4)
      monitor.write(trend .. "%")
    elseif monitor_size <= 14 then
      monitor.setCursorPos(1, 1)
      monitor.write("Current: " .. current .. "%")
      monitor.setCursorPos(1, 2)
      monitor.write("Trend: " .. trend .. "%")
    else
      monitor.setCursorPos(1, 1)
      monitor.write("Current percentage: " .. current .. "%")
      monitor.setCursorPos(1, 2)
      monitor.write("Trend: " .. trend .. "%")
    end
  end
end

local function display(current, trend, max_hint)
  term.clear()
  term.setCursorPos(1, 1)
  print("Current percentage: " .. current .. "%")
  print("Trend: " .. trend .. "%")

  if max_hint then
    print()
    print("The max energy capacity is MAX_INT!")
    print("There might be more energy left as it can be displayed")
  end
end

local function round(num, numDecimalPlaces)
  local mult = 10 ^ (numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function wait_for_battery()
  local battery
  while battery == nil do
    local temp_battery = peripheral.find(BATTERY_TYPE)
    if temp_battery ~= nil and pcall(temp_battery.getEnergy) then
      battery = temp_battery
    else
      print("Detecting battery")
      sleep(3)
    end
  end
  return battery
end

-- Check for connection (for example on server startup)
BATTERY = wait_for_battery()

running = true
while running do
  try {
    function()
      local batteryPercentage = BATTERY.getEnergy() / BATTERY.getEnergyCapacity()
      local trend = batteryPercentage - LAST_PERCENTAGE

      local rounded_current = round(batteryPercentage * 100, PRECISION_DISPLAYED)
      local rounded_trend = round(trend * 100, PRECISION_DISPLAYED)

      display_external(rounded_current, rounded_trend)
      display(rounded_current, rounded_trend, BATTERY.getEnergyCapacity() == 2147483647)

      if CHARGE_INVERT_OUTPUT then
        redstone.setOutput(CHARGE_OUTPUT_SIDE, batteryPercentage >= CHARGE_THRESHOLD)
      else
        redstone.setOutput(CHARGE_OUTPUT_SIDE, batteryPercentage < CHARGE_THRESHOLD)
      end

      if ALARM_INVERT_OUTPUT then
        redstone.setOutput(ALARM_OUTPUT_SIDE, batteryPercentage >= ALARM_THRESHOLD)
      else
        redstone.setOutput(ALARM_OUTPUT_SIDE, batteryPercentage < ALARM_THRESHOLD)
      end

      LAST_PERCENTAGE = batteryPercentage

      sleep(UPDATE_INTERVAL_SEC)
    end,
    catch {
      function(error)
        blank_external_monitors()
        print("Detected error: Wait for input")
        print("r -> restart")
        print("q -> quit")
        local valid_input = false
        while not valid_input do
          local _,key = os.pullEvent("key")

          if key == keys.q then
            valid_input = true
            running = false
          elseif key == keys.r then
            valid_input = true
            BATTERY = wait_for_battery()
          end
        end
      end
    }
  }
end
