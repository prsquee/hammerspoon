-- Mute Current Audio Input

-- Download:

local obj = {}
obj.__index = obj

-- metadata

obj.name = "MuteMic"
obj.version = "0.1"
obj.author = "sQuEE"
obj.homepage = "https://github.com/prsquee"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.menuBarItem  = nil
obj.hotkeyToggle = nil

local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()

function obj:init()
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
  -- print("dev_uid:", dev_uid, "event_name:", event_name, "event_scope:",event_scope, "event_element:",event_element)
  inputDev = hs.audiodevice.findDeviceByUID(dev_uid)
  if inputDev:inputMuted() then
    obj.menuBarItem:setTitle('🙊')
  else
    obj.menuBarItem:setTitle('🎙')
  end
end

function obj:start()
  -- print('this is start')
  hs.audiodevice.defaultInputDevice():setInputMuted(true)
  self.menuBarItem = hs.menubar.new()
  self.menuBarItem:setTitle('🙊')
  self.menuBarItem:setClickCallback(self.clicked)

  for i,dev in ipairs(hs.audiodevice.allInputDevices()) do
    print("Setting up watcher for audio device: ", dev:name())
    dev:watcherCallback(audiodevwatch):watcherStart()
  end

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

  for i,dev in ipairs(hs.audiodevice.allInputDevices()) do
    dev:watcherStop()
    print("stopping watcher for audio device: ", dev:name())
  end

  return self
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
