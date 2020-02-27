-- Mute Current Audio Input

local obj = {}
obj.__index = obj

-- {{{ metadata
obj.name = "MuteMic"
obj.version = "0.0.1"
obj.author = "sQuEE"
obj.homepage = "https://github.com/prsquee/hammerspoon/tree/master/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"
-- }}}

local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()

function obj:init()
  self.menuBarItem  = nil
  self.hotkeyToggle = nil
  self.activeMicIcon = hs.image.imageFromPath(self.spoonPath.."activeMic.png")
  self.inactiveMicIcon = hs.image.imageFromPath(self.spoonPath.."inactiveMic.png")
  self.headphones_icon = hs.menubar.new()
end

function obj:bindHotkeys(mapping)
  if (self.hotkeyToggle) then
    self.hotkeyToggle:delete()
  end
  local toggleMods = mapping["toggle"][1]
  local toggleKey  = mapping["toggle"][2]
  self.hotkeyToggle = hs.hotkey.new(toggleMods, toggleKey, function() self.clicked() end)
  return self
end

function audiodevwatch(dev_uid, event_name, event_scope, event_element)
  print("dev_uid:", dev_uid, "event_name:", event_name, "event_scope:",event_scope, "event_element:",event_element)
  if hs.audiodevice.findDeviceByUID(dev_uid):inputMuted() then
    obj.menuBarItem:setIcon(obj.inactiveMicIcon:setSize({w=16,h=16}))
  else
    obj.menuBarItem:setIcon(obj.activeMicIcon:setSize({w=16,h=16}))
  end
end

function obj:start()
  hs.audiodevice.defaultInputDevice():setInputMuted(true)
  self.menuBarItem = hs.menubar.new()
  self.menuBarItem:setIcon(self.inactiveMicIcon:setSize({w=16,h=16}))
  self.menuBarItem:setClickCallback(self.clicked)
  self.startInputWatchers()

  if self.hotkeyToggle then
    self.hotkeyToggle:enable()
  end

  return self
end

function obj:stop()
  self.menuBarItem:removeFromMenuBar()
  if self.hotkeyToggle then
    self.hotkeyToggle:disable()
  end

  return self
end

function obj.startInputWatchers()
  for i,input in ipairs(hs.audiodevice.allInputDevices()) do
    if not input:watcherIsRunning() then
      print("Setting up watcher for audio device: ", input:name())
      input:watcherCallback(audiodevwatch):watcherStart()
    end
  end
end

function obj.clicked()
  if hs.audiodevice.defaultInputDevice():inputMuted() then
    hs.audiodevice.defaultInputDevice():setInputMuted(false)
    hs.audiodevice.defaultInputDevice():setInputVolume(100)
  else
    hs.audiodevice.defaultInputDevice():setInputMuted(true)
  end
end

return obj

