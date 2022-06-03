-- Mute Current Audio Input

local obj = {}
obj.__index = obj

function obj:toggleMute()
  local input = hs.audiodevice.defaultInputDevice()
  if input:muted() then
    input:setMuted(false)
  else
    input:setMuted(true)
  end
end

function obj:bindHotkeys(mapping)
  if (self.hotkeyToggle) then
    self.hotkeyToggle:delete()
  end
  local toggleMods = mapping["toggle"][1]
  local toggleKey  = mapping["toggle"][2]
  self.hotkeyToggle = hs.hotkey.new(toggleMods, toggleKey, function() self:toggleMute() end)
  self.defaultKey   = hs.hotkey.bind({}, "f18", function() self:toggleMute() end)
  self.hotkeyToggle:enable()
  return self
end
return obj
