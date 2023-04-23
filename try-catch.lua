-- This is a utility class to add try - catch functionallity
-- include it by downloading to your computer and import it with `require "try-catch"`

function catch(what)
  return what[1]
end

function try(what)
  local status, result = pcall(what[1])
  if not status then
     what[2](result)
  end
  return result
end