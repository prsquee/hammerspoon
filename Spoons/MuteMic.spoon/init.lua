-- Mute Current Audio Input

local obj = {}
obj.__index = obj

local watchers = {}

function obj:init()
  self.menuBarItem     = nil
  self.hotkeyToggle    = nil
  self.activeMicIcon   = hs.image.imageFromPath(self.spoonPath.."activeMic.png")
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
function audioDevWatch(dev_uid, event_name, event_scope, event_element)
  print(dev_uid, event_name, event_scope, event_element)
  current_input = hs.audiodevice.current('input')
  if current_input['uid'] == dev_uid and event_name == "mute" then
    if current_input['muted'] then
      print(current_input['name'] .. " is muted")
      obj.menuBarItem:setIcon(obj.inactiveMicIcon:setSize({w=18,h=18}))
    else
      print(hs.audiodevice.findDeviceByUID(dev_uid):name() .. " is not muted")
      obj.menuBarItem:setIcon(obj.activeMicIcon:setSize({w=18,h=18}))
    end
  end
end

function obj:start()
  hs.audiodevice.defaultInputDevice():setInputMuted(true)
  self.menuBarItem = hs.menubar.new()
  self.menuBarItem:setIcon(self.inactiveMicIcon:setSize({w=18,h=18}))
  self.menuBarItem:setClickCallback(self.clicked)
  obj:startInputWatchers()

  if self.hotkeyToggle then
    self.hotkeyToggle:enable()
  end

  return self
end

function obj:setMenuBarIcon(arg)
  if arg == "mute" then
    obj.menuBarItem:setIcon(obj.inactiveMicIcon:setSize({w=18,h=18}))
  elseif arg == "unmute" then
    obj.menuBarItem:setIcon(obj.activeMicIcon:setSize({w=18,h=18}))
  end
end

function obj:startInputWatchers()
  for i,input in ipairs(hs.audiodevice.allInputDevices()) do
    if not input:watcherIsRunning() then
      name = input:name():gsub(' ', '')
      watchers[name] = input:watcherCallback(audioDevWatch):watcherStart()
      print("setting up watcher for " .. name)
    end
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

-- watch for new devices 
--hs.audiodevice.watcher.setCallback(function(arg)
--  -- device number changed, check if it's the yeti
--  if arg == 'dev#' then
--    print("dev# changed")
--    spoon.MuteMic:startInputWatchers()
--    yeti = hs.audiodevice.findInputByName("Yeti Stereo Microphone")
--    if yeti then
--      yeti:setDefaultInputDevice()
--      hs.loadSpoon("AudioSwitch")
--      spoon.AudioSwitch:bindHotkeys({toggle={hyper, "a"}})
--      spoon.AudioSwitch:start()
--    end
--  end
--end)

return obj

