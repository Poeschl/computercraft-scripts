-- A small installer for the scripts in this repository

GITHUB_REPRO_LINK = 'https://api.github.com/repos/Poeschl/computercraft-scripts/contents/'

local function ends_with(str, ending)
    return ending == "" or str:sub(-#ending) == ending
 end

----------------- Main function

print(" ")
print("Poeschl CC Scripts Installer")

local githubFilesString = http.get(GITHUB_REPRO_LINK).readAll()

if not githubFilesString then
    error("Could not connect to " .. GITHUB_REPRO_LINK)
end
local githubFiles = textutils.unserialiseJSON(githubFilesString)

local availableFiles = {}
for index, file in ipairs(githubFiles) do
    if file['type'] == 'file' and ends_with(file['name'], '.lua') then
        table.insert(availableFiles, {name = file['name'], url = file['download_url']})
    end
end

print("Available Scripts (type number to download):")
local options = {}
for index, script in ipairs(availableFiles) do
    print(index .. ') ' .. script['name'])
    table.insert(options, index)
end

local downloadIndex = tonumber(read(nil, options))

local selectedScript = availableFiles[downloadIndex]

shell.run("wget",selectedScript['url'], selectedScript['name'])
print ("Script " .. selectedScript['name'] .. " downloaded")