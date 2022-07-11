-- A script which starts an other script on a monitor with the specified font size

MONITOR_SIDE = "back"
FONT_SIZE = 1.5
SCRIPT_TO_START = "./alongtimeago.lua"

local monitor = peripheral.wrap(MONITOR_SIDE)
monitor.setTextScale(FONT_SIZE)

shell.run("monitor", MONITOR_SIDE, SCRIPT_TO_START)