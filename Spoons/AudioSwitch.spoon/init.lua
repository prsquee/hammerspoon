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
obj.speakers = nil
obj.speakersIcon = nil
obj.headphones = nil

local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()


--obj.speakers = hs.audiodevice.findDeviceByName('Built-in Line Output')
obj.speakers     = hs.audiodevice.findDeviceByUID('AppleHDAEngineOutput:1F,3,0,1,3:1') -- this is the second line out device
obj.speakersIcon = hs.image.imageFromPath(script_path() .. "harman.png"):setSize({w=18,h=18})
obj.headphones   = hs.audiodevice.findDeviceByName("Built-in Output")
obj.loopback     = hs.audiodevice.findInputByName("Loopback Audio")
--obj.yeti = hs.audiodevice.findInputByName("Yeti Stereo Microphone")

obj.headphonesIcon = hs.image.imageFromPath(script_path() .. "headphones.png"):setSize({w=18,h=18})

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
  self.outputIcon = hs.menubar.new()
  self.outputIcon:setClickCallback(self.clicked)

  self.setOutputIcon()

  if self.hotkeyToggle then
    self.hotkeyToggle:enable()
  end

  return self
end

function obj:stop()
  if self.outputIcon then
    self.outputIcon:removeFromMenuBar()
    self.outputIcon = nil
  end

  if self.hotkeyToggle then
    self.hotkeyToggle:disable()
  end
  return self
end

function obj.clicked()
  local currentOutput = hs.audiodevice.defaultOutputDevice()

  if currentOutput:name() == obj.speakers:name() then
    obj.headphones:setDefaultOutputDevice()
  else
    obj.speakers:setDefaultOutputDevice()
  end
end

function obj.setOutputIcon()
  print(hs.audiodevice.defaultOutputDevice():name())
  if hs.audiodevice.defaultOutputDevice():name() == obj.speakers:name() then
    obj.outputIcon:setIcon(obj.speakersIcon)
  else
    obj.outputIcon:setIcon(obj.headphonesIcon)
  end
end

function obj.changeInputToLoopback()
  if obj.loopback then
    obj.headphones:setDefaultInputDevice()
  end
end
return obj
