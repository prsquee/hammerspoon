-- toggle between speakers and headpphones

local obj = {}
obj.__index = obj

-- metadata

obj.name = "AudioSwitch"
obj.version = "0.1"
obj.author = "sQuEE"
obj.homepage = "https://github.com/prsquee/hammerspoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.outputIcon  = nil
obj.hotkeyToggle = nil

-- all my devices
obj.headphones = hs.audiodevice.findDeviceByUID('AppleHDAEngineOutput:1F,3,0,1,2:0')
obj.speakers   = hs.audiodevice.findDeviceByUID('AppleHDAEngineOutput:1F,3,0,1,3:1')    -- this is the FIRST line out device
-- whatever = hs.audiodevice.findDeviceByUID('AppleHDAEngineOutput:1F,3,0,1,4:2')   -- this is the SECOND line out device
obj.webcamMic = hs.audiodevice.findInputByUID('AppleUSBAudioEngine:Unknown Manufacturer:HD Webcam C525:92B1D710:1')
obj.headphonesMic = hs.audiodevice.findInputByUID('AppleHDAEngineInput:1F,3,0,1,0:4')

local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()

obj.airpodsIcon = hs.image.imageFromPath(script_path() .. "airpods.png"):setSize({w=16,h=16})
obj.speakersIcon = hs.image.imageFromPath(script_path() .. "harman.png"):setSize({w=16,h=16})
obj.headphonesIcon = hs.image.imageFromPath(script_path() .. "headphones.png"):setSize({w=16,h=16})

function obj:bindHotkeys(mapping)
  if (self.hotkeyToggle) then
    self.hotkeyToggle:delete()
  end
  local toggleMods = mapping["toggle"][1]
  local toggleKey  = mapping["toggle"][2]
  self.hotkeyToggle = hs.hotkey.new(toggleMods, toggleKey, function() self.clicked() end)

  return self
end

function obj:start()
  if not self.speakers or not self.headphones then
    hs.notify.new({title="Hammerspoon", informativeText="ERROR: Some audio devices are missing", ""}):send()
    return
  end

  self.outputIcon = hs.menubar.new()
  self.outputIcon:setClickCallback(self.clicked)

  setOutputIcon()

  if self.hotkeyToggle then
    self.hotkeyToggle:enable()
  end

  return self
end

function obj:stop()
  self.outputIcon:removeFromMenuBar()
  if self.hotkeyToggle then
    self.hotkeyToggle:disable()
  end

  return self
end

function obj.clicked()
  local currentOutput = hs.audiodevice.defaultOutputDevice()

  if currentOutput:name() == obj.speakers:name() then
    obj.headphones:setDefaultOutputDevice()
    obj.headphonesMic:setDefaultInputDevice()
  else
    obj.speakers:setDefaultOutputDevice()
    obj.webcamMic:setDefaultInputDevice()
  end
end

-- this is run when input has changed.
function audiowatch(arg)
  -- print("Audiowatch arg: ", arg)
  if arg == "dIn " then
    print("input changed to " .. hs.audiodevice.defaultInputDevice():name())
    if hs.audiodevice.defaultInputDevice():inputMuted() then
      spoon.MuteMic:setMenuBarIcon('mute')
    else
      spoon.MuteMic:setMenuBarIcon('unmute')
    end
  elseif (arg == "dOut") then
    setOutputIcon()
  elseif (arg == "dev#") then
    spoon.MuteMic:startInputWatchers()
  end
end


function setOutputIcon()
  if hs.audiodevice.defaultOutputDevice():name() == obj.speakers:name() then
    obj.outputIcon:setIcon(obj.speakersIcon)
  elseif hs.audiodevice.defaultOutputDevice():name():match('AirPods') then
    obj.outputIcon:setIcon(obj.airpodsIcon)
  else
    obj.outputIcon:setIcon(obj.headphonesIcon)
  end
end

hs.audiodevice.watcher.setCallback(audiowatch)
hs.audiodevice.watcher.start()

return obj
