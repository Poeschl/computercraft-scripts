-- A simple script which displays the charged percent as well as a trend
-- When a monitor is connected via a network cable or direct it will display it as well (advanced monitor -> with colors)
-- An redstone low signal is outputed on the left side of the computer if the level is below the charge_threshold. (High otherwise)
-- An redstone low signal is output to the top if the level is below alarm_threshold. (High otherwise)

BATTERY = peripheral.find("mekanism:ultimate_energy_cube")
LAST_PERCENTAGE = 0
CHARGE_THRESHOLD = 0.6
CHARGE_OUTPUT_SIDE = 'left'
ALARM_THRESHOLD = 0.3
ALARM_OUTPUT_SIDE = 'top'

local function display_external(current, trend)
  local monitor = peripheral.find("monitor")

  monitor.setTextColor(colors.black)

  if current < (ALARM_THRESHOLD * 100) then
    monitor.setBackgroundColour(colors.red)
  elseif current < (CHARGE_THRESHOLD * 100) then    
    monitor.setBackgroundColour(colors.orange)
  else
    monitor.setBackgroundColour(colors.green)
  end

  monitor.clear()
  monitor.setCursorPos(1,1)
  monitor.write("Current percentage: " .. current .. "%")
  monitor.setCursorPos(1,2)
  monitor.write("Trend: " .. trend .. "%")
end

local function display(current, trend)
  term.clear()
  term.setCursorPos(1,1)
  print("Current percentage: " .. current .. "%")
  print("Trend: " .. trend .. "%")
end

local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

while true do
  local batteryPercentage = BATTERY.getEnergy() / BATTERY.getEnergyCapacity()
  local trend = batteryPercentage - LAST_PERCENTAGE

  local rounded_current = round(batteryPercentage * 100, 2)
  local rounded_trend = round(trend * 100, 2)

  display_external(rounded_current,  rounded_trend)
  display(rounded_current,  rounded_trend)

  redstone.setOutput(CHARGE_OUTPUT_SIDE, batteryPercentage >= CHARGE_THRESHOLD)
  redstone.setOutput(ALARM_OUTPUT_SIDE, batteryPercentage >= ALARM_THRESHOLD)

  sleep(5)
  LAST_PERCENTAGE = batteryPercentage
end

