-- audio stuff on macbook pro

local airpodsIcon = hs.image.imageFromPath("airpods.png")
local outputIcon = hs.menubar.new()

local builtinOutput = hs.audiodevice.findDeviceByName("Built-in Output")
local digitalOutput = nil
local hotkeyToggle  = hs.hotkey.new(hyper, "a", function() toggleOutput() end)

-- {{{ general watcher for dev# dIn dOut events
function audiowatch(arg)
  print("Audiowatch arg: ", arg)
  print(hs.audiodevice.defaultOutputDevice():name())
  print(hs.audiodevice.defaultOutputDevice():currentOutputDataSource():name())
  if arg == "dev#" then
    print("Audiowatch arg: ", arg)
    print(hs.audiodevice.defaultOutputDevice():name(), hs.audiodevice.defaultInputDevice():name())
    -- if a new input device is added, like the airpods, start a watcher for it
    spoon.MuteMic:startInputWatchers()
    setupAudioOutputToggle()
  end

  if arg == "dIn " then
    if hs.audiodevice.defaultInputDevice():inputMuted() then
      spoon.MuteMic:setMenuBarIcon("mute")
    else
      spoon.MuteMic:setMenuBarIcon("unmute")
    end
  end
  if (arg == "dOut") then
    setOutputIcon()
    if not hotkeyToggle then
      setupAudioOutputToggle()
    end
  end
end
-- }}}
-- {{{ menubar icon setting
function setOutputIcon()
  if hs.audiodevice.defaultOutputDevice():name() == "Built-in Output" then
    if hs.audiodevice.defaultOutputDevice():currentOutputDataSource():name() == 'Headphones' then
      outputIcon:setIcon(nil)
      outputIcon:setTitle('🎧')
      outputIcon:returnToMenuBar()
    else
      outputIcon:removeFromMenuBar()
    end
  elseif hs.audiodevice.defaultOutputDevice():name():match("AirPods") then
    outputIcon:setTitle(nil)
    outputIcon:setIcon(airpodsIcon:setSize({w=16,h=16}))
    outputIcon:returnToMenuBar()
  elseif (hs.audiodevice.defaultOutputDevice():name() == "DisplayPort" or
          hs.audiodevice.defaultOutputDevice():name() == "HDMI") then
    outputIcon:setIcon(nil)
    outputIcon:setTitle('🔊')
    outputIcon:returnToMenuBar()
  end
end
-- }}}
-- {{{ individual watchers for each output device
function audioOutWatcher()
  print("dev_uid:", dev_uid, "event_name:", event_name, "event_scope:",event_scope, "event_element:",event_element)
  print(hs.audiodevice.findDeviceByUID(dev_uid):name())
  outputDev = hs.audiodevice.findDeviceByUID(dev_uid)
  if (event_name == 'diff' and hs.audiodevice.defaultOutputDevice():currentOutputDataSource():name() == 'Headphones') then
    setOutputIcon()
  end
end
-- }}}
-- {{{ audio device toggle
function setupAudioOutputToggle()
  -- we do have a DP or HDMI audio out connected?
  if #hs.audiodevice.allOutputDevices() >= 2 then
    for i,dev in ipairs(hs.audiodevice.allOutputDevices()) do
      if (dev:name() == "DisplayPort" or dev:name() == "HDMI") then
        digitalOutput = dev
      end
    end
    -- start:
    hotkeyToggle:enable()
    setOutputIcon()
  else
    -- stop:
    hotkeyToggle:disable()
    digitalOutput = nil
    setOutputIcon()
  end
end
function toggleOutput()
  local currentOutput = hs.audiodevice.defaultOutputDevice()
  if digitalOutput then
    if currentOutput:name() == builtinOutput:name() then
      digitalOutput:setDefaultOutputDevice()
    else
      builtinOutput:setDefaultOutputDevice()
    end
  else
    print("no digital or builtin devices are detected. This should never happened")
  end
end
-- }}}

for i,outputDev in ipairs(hs.audiodevice.allOutputDevices()) do
  print("watching output device: ", outputDev:name())
  outputDev:watcherCallback(audioOutWatcher):watcherStart()
end

hs.audiodevice.watcher.setCallback(audiowatch)
hs.audiodevice.watcher.start()

setOutputIcon()
setupAudioOutputToggle()
