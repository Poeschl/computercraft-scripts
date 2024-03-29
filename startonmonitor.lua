-- A script which starts an other script on a monitor with the specified font size

MONITOR_SIDE = "back"
FONT_SIZE = 1.5
SCRIPT_TO_START = "./alongtimeago.lua"
WAIT_FOR_REDSTONE = true -- If enabled the monitor will wait for an redstone signal to start

local monitor = peripheral.wrap(MONITOR_SIDE)
monitor.setTextScale(FONT_SIZE)
monitor.clear()

if WAIT_FOR_REDSTONE then
    while true do
        ---@diagnostic disable-next-line: undefined-field
        os.pullEvent("redstone")
        shell.run("monitor", MONITOR_SIDE, SCRIPT_TO_START)
        monitor.clear()
    end
else
    shell.run("monitor", MONITOR_SIDE, SCRIPT_TO_START)
    monitor.clear()
end
