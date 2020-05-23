local obj = {}
obj.__index = obj

-- metadata
obj.name = "RotateScren"
obj.version = "0.1"
obj.author = "sQuEE"
obj.homepage = "https://github.com/prsquee/hammerspoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

local screen = nil

function obj:bindHotkeys(mapping)
  if (self.hotkeyToggle) then
    self.hotkeyToggle:delete()
  end
  local toggleMods = mapping["toggle"][1]
  local toggleKey  = mapping["toggle"][2]
  self.hotkeyToggle = hs.hotkey.new(toggleMods, toggleKey, function() self.rotateScreen() end)
  return self
end

function obj:start(screenObjFromConfig)
  if self.hotkeyToggle then
    self.hotkeyToggle:enable()
  end
  screen = screenObjFromConfig
  return self
end

function obj:stop()
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
