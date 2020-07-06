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

local watchers = {}

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

-- thsi is run when mute event is received by a device.
function audiodevwatch(dev_uid, event_name, event_scope, event_element)
  current_input = hs.audiodevice.current('input')
  if current_input['uid'] == dev_uid and current_input['muted'] then
    print(current_input['name'] .. " is muted")
    obj.menuBarItem:setIcon(obj.inactiveMicIcon:setSize({w=16,h=16}))
  else
    print(hs.audiodevice.findDeviceByUID(dev_uid):name() .. " is not muted")
    obj.menuBarItem:setIcon(obj.activeMicIcon:setSize({w=16,h=16}))
  end
end

function obj:start()
  hs.audiodevice.defaultInputDevice():setInputMuted(true)
  self.menuBarItem = hs.menubar.new()
  self.menuBarItem:setIcon(self.inactiveMicIcon:setSize({w=16,h=16}))
  self.menuBarItem:setClickCallback(self.clicked)
  startInputWatchers()

  if self.hotkeyToggle then
    self.hotkeyToggle:enable()
  end

  return self
end

function obj:setMenuBarIcon(arg)
  if arg == "mute" then
    obj.menuBarItem:setIcon(obj.inactiveMicIcon:setSize({w=16,h=16}))
  elseif arg == "unmute" then
    obj.menuBarItem:setIcon(obj.activeMicIcon:setSize({w=16,h=16}))
  end
end

function startInputWatchers()
  for i,input in ipairs(hs.audiodevice.allInputDevices()) do
    if not input:watcherIsRunning() then
      name = input:name():gsub(' ', '')
      watchers[name] = input:watcherCallback(audiodevwatch):watcherStart()
    end
  end
  for i,x in ipairs(watchers) do
    print("Setting up watcher for audio device: " .. watchers[i])
  end
end

function obj.clicked()
  if hs.audiodevice.defaultInputDevice():inputMuted() then
    hs.audiodevice.defaultInputDevice():setInputMuted(false)
    hs.audiodevice.defaultInputDevice():setInputVolume(99)
  else
    hs.audiodevice.defaultInputDevice():setInputMuted(true)
  end
end

return obj

