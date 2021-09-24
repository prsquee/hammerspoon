-- yet another caffeinate 🥄

local obj = {}
obj.__index = obj

obj.name = "Coffee"
obj.version = "0.1"
obj.author = "sQuEE"
obj.homepage = "https://github.com/prsquee/hammerspoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function obj:bindHotkeys(mapping)
  local toggleMods = mapping["toggle"][1]
  local toggleKey  = mapping["toggle"][2]
  self.hotkeyToggle = hs.hotkey.new(toggleMods, toggleKey, function() self.toggle() end)

  local startSaverMods = mapping["startSaver"][1]
  local startSaverKey  = mapping["startSaver"][2]
  self.hotkeyStartSaver = hs.hotkey.new(startSaverMods, startSaverKey, function() hs.caffeinate.startScreensaver() end)

  return self
end

function obj:init()
  print('serving coffee')
  print('displayIdle: ', hs.caffeinate.get("displayIdle"))
  print('systemIdle: ', hs.caffeinate.get("systemIdle"))
end

function obj:start()
  if self.hotkeyToggle then
    self.hotkeyToggle:enable()
  end
  if self.hotkeyStartSaver then
    self.hotkeyStartSaver:enable()
  end
  return self
end

function obj:toggle()
  if not menu then
    menu = hs.menubar.new()
    obj:enable()
  else
    obj:disable()
  end
 return self
end

function obj:enable()
  hs.caffeinate.set("displayIdle", true, true)
  print('displayIdle: ', hs.caffeinate.get("displayIdle"))
  hs.caffeinate.set("systemIdle", true, true)
  print('systemIdle: ', hs.caffeinate.get("systemIdle"))
  menu:returnToMenuBar()
  menu:setTitle("🧉")
  menu:setTooltip("Caffeinated!")
  menu:setClickCallback(function() self.disable() end)
  return self
end

function obj:disable()
  hs.caffeinate.set("displayIdle", false, false)
  print('displayIdle: ', hs.caffeinate.get("displayIdle"))
  hs.caffeinate.set("systemIdle", false, false)
  print('systemIdle: ', hs.caffeinate.get("systemIdle"))
  menu:delete()
  menu = nil
  return self
end

return obj
