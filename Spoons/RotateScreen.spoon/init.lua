-- ROTATE external display
local obj = {}

obj.__index = obj

-- metadata
obj.name = "RotateScren"
obj.version = "0.2"
obj.author = "sQuEE"
obj.homepage = "https://github.com/prsquee/hammerspoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

local screen = nil
local watcher = nil
function obj:bindHotkeys(mapping)
  if (self.hotkeyToggle) then
    self.hotkeyToggle:delete()
  end
  local toggleMods = mapping["toggle"][1]
  local toggleKey  = mapping["toggle"][2]
  self.hotkeyToggle = hs.hotkey.new(toggleMods, toggleKey, function() self.rotateScreen() end)
  return self
end

function obj:start(secondScreen)
  if secondScreen and self.hotkeyToggle then
    print('setting up shortcut for rotating second display')
    self.hotkeyToggle:enable()
    screen = secondScreen
  end
  return self
end


function obj:stop()
  --print('second display disconnedted. Removing keyboard shortcut')
  if self.hotkeyToggle then
    self.hotkeyToggle:disable()
  end
  return self
end

function obj.rotateScreen()
  if screen:rotate() == 270 then
    screen:rotate(0)
  else
    screen:rotate(270)
  end
end

return obj
