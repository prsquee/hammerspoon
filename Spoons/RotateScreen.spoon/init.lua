-- ROTATE external display
local obj = {}

obj.__index = obj

-- metadata
obj.name = "RotateScren"
obj.version = "0.2"
obj.author = "sQuEE"
obj.homepage = "https://github.com/prsquee/hammerspoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

local screens = hs.screen.allScreens()
local watcher = hs.screen.watcher.new(function()
	screens = hs.screen.allScreens()
end)
watcher:start()

function obj:bindHotkeys(key)
  if (self.hotkeyToggle) then
    self.hotkeyToggle:delete()
  end
  self.hotkeyToggle = hs.hotkey.new("", key, function() self.rotateScreen() end)
  self.hotkeyToggle:enable()
  return self
end

function obj:stop()
  if self.hotkeyToggle then
    self.hotkeyToggle:disable()
  end
  return self
end

function obj.rotateScreen()
  for id,screen in pairs(screens) do
    if (screen:name() == 'BenQ GW2283') then
      if screen:rotate() == 90 then
        screen:rotate(0)
      else
        screen:rotate(90)
      end
    end
  end
end

return obj
