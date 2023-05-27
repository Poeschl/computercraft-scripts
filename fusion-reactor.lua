-- A script which let you control the Mekanism fusion reactor startup process.
-- It requries:
-- * One single-block monitor for user input.
-- * One redstone input for the "Ready for ignition" output of the fusion reactor.
-- * One redstone output which control the fuel generation and stops it when the reactor should shutdown.
-- * One redstone output which controls the lasers.

-- Requires the try-catch.lua file
require "try-catch"

REACTOR_IGNITION_READY_INPUT_SIDE = 'right'
FUEL_GENERATION_OUTPUT_SIDE = 'top'
LASER_ACTIVATION_OUTPUT_SIDE = 'left'

-- No changes below this point (except you know what you are doing)

local function blank_external_monitors() 
  local monitors = { peripheral.find("monitor") }

  for _, monitor in pairs(monitors) do
    monitor.setTextColor(colors.white)
    monitor.setBackgroundColour(colors.blue)
    monitor.clear()
    monitor.setCursorPos(2, 2)
    monitor.write("Error")
    monitor.setCursorPos(2, 4)
    monitor.write("X_x")
  end
end

local function reset_screen(monitor)
  monitor.setTextColor(colors.white)
  monitor.setBackgroundColour(colors.black)
  monitor.clear()
  monitor.setTextScale(0.5)
end

local function update_stage()
  local ignition_temp_reached = redstone.getInput(REACTOR_IGNITION_READY_INPUT_SIDE)
  local laser_activited = redstone.getOutput(LASER_ACTIVATION_OUTPUT_SIDE)
  local fuel_activated = redstone.getOutput(FUEL_GENERATION_OUTPUT_SIDE)

  if fuel_activated and laser_activited and not ignition_temp_reached then
    CURRENT_STAGE = STAGE.IGNITION
  elseif fuel_activated and not laser_activited and ignition_temp_reached then
      CURRENT_STAGE = STAGE.RUNNING
  elseif not fuel_activated and not laser_activited and ignition_temp_reached then
      CURRENT_STAGE = STAGE.SHUTTING_DOWN
  else 
    CURRENT_STAGE = STAGE.OFF
  end
end

local function draw_button(monitor, color, text)
  local restore_color = monitor.getTextColor()
  local button_line = 8

  monitor.setTextColor(color)
  monitor.setCursorPos(1, button_line)
  monitor.write("#-------------#")
  monitor.setCursorPos(1, button_line + 1)
  monitor.write("|             |")
  monitor.setCursorPos(1, button_line + 2)
  monitor.write("#-------------#")

  local text_start = (13 - string.len(text)) / 2
  monitor.setCursorPos(2 + text_start, button_line + 1)
  monitor.write(text)

  monitor.setTextColor(restore_color)
end

local function print_header(monitor)
  monitor.setCursorPos(1, 1)
  monitor.write("Fusion Reaktor")
end

local function off_screen(monitor)
  reset_screen(monitor)
  print_header(monitor)

  monitor.setCursorPos(1, 3)
  monitor.write("Status: Aus")

  draw_button(monitor, colors.green, "Starten")
end

local function ignition_screen(monitor)
  reset_screen(monitor)
  print_header(monitor)

  monitor.setCursorPos(1, 3)
  monitor.write("Benötigt:")
  monitor.setCursorPos(1, 4)
  monitor.write("- Hohlraum")
  monitor.setCursorPos(1, 5)
  monitor.write("  einsetzen")
  monitor.setCursorPos(1, 6)
  monitor.write("- Fire Laser")
  monitor.setCursorPos(1, 7)
  monitor.write("  (500 kFE)")

  draw_button(monitor, colors.red, "Abbruch")
end

local function on_screen(monitor)
  reset_screen(monitor)
  print_header(monitor)

  monitor.setCursorPos(1, 3)
  monitor.write("Status:")
  monitor.setTextColor(colors.green)
  monitor.setCursorPos(9, 3)
  monitor.write("Aktiv")
  monitor.setTextColor(colors.white)

  draw_button(monitor, colors.red, "Stoppen")
end

local function shuting_down_screen(monitor)
  reset_screen(monitor)
  print_header(monitor)

  monitor.setCursorPos(1, 3)
  monitor.write("Status:")
  monitor.setTextColor(colors.yellow)
  monitor.setCursorPos(1, 4)
  monitor.write("Shutdown")
  monitor.setTextColor(colors.white)

  draw_button(monitor, colors.green, "Nope")
end

STAGE = {UNKNOWN = 0, OFF = 1, IGNITION = 2, RUNNING = 3, SHUTTING_DOWN = 4}
CURRENT_STAGE = STAGE.UNKNOWN

print("Started fusion reactor control logic")
print("Stry - T -> quit")

running = true
while running do
  try {
    function()
      local monitors = { peripheral.find("monitor") }
      update_stage()

      for _, monitor in pairs(monitors) do

        if CURRENT_STAGE == STAGE.OFF then
          off_screen(monitor)
        elseif CURRENT_STAGE == STAGE.IGNITION then
          ignition_screen(monitor)
        elseif CURRENT_STAGE == STAGE.RUNNING then
          on_screen(monitor)
        elseif CURRENT_STAGE == STAGE.SHUTTING_DOWN then
          shuting_down_screen(monitor)
        end
      end
     
      -- Event loop part
      local eventData = {os.pullEvent()}
      local eventType = eventData[1]

      if eventType == "monitor_touch" then
        local x = eventData[3]
        local y = eventData[4]

        if x >= 1 and x < 16 and y >= 8 and y < 11 then
          if CURRENT_STAGE == STAGE.OFF then
            redstone.setOutput(LASER_ACTIVATION_OUTPUT_SIDE, true)
            redstone.setOutput(FUEL_GENERATION_OUTPUT_SIDE, true)

          elseif CURRENT_STAGE == STAGE.IGNITION then
            redstone.setOutput(LASER_ACTIVATION_OUTPUT_SIDE, false)
            redstone.setOutput(FUEL_GENERATION_OUTPUT_SIDE, false)

          elseif CURRENT_STAGE == STAGE.RUNNING then
            redstone.setOutput(FUEL_GENERATION_OUTPUT_SIDE, false)

          elseif CURRENT_STAGE == STAGE.SHUTTING_DOWN then
            redstone.setOutput(FUEL_GENERATION_OUTPUT_SIDE, true)
          end 
        end

      elseif eventType == "redstone" then
        local ignition_temp_reached = redstone.getInput(REACTOR_IGNITION_READY_INPUT_SIDE)
        if CURRENT_STAGE == STAGE.IGNITION and ignition_temp_reached then
          redstone.setOutput(LASER_ACTIVATION_OUTPUT_SIDE, false)
        end
      end 
    end,
    catch {
      function(error)
        blank_external_monitors()
        print("Detected error:")
        print(error)
        print()
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
          end
        end
      end
    }
  }
end
