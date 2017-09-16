-- DEPRECATED. THIS IS NOW A SPOON
hyper = {"ctrl", "alt", "cmd", "shift"}
muteMicIcon = hs.menubar.new()

function setIconState(state)
  if state then
    muteMicIcon:setTitle('🚫')
  else
    muteMicIcon:setTitle('🎙')
  end
end

if muteMicIcon then
  muteMicIcon:setClickCallback(toggle_mic_mute)                   -- callback when clicked
  hs.audiodevice.defaultInputDevice():setInputMuted(true)         -- force mute on HS start
  setIconState(hs.audiodevice.defaultInputDevice():inputMuted())  -- set startup icon status
end

-- toggle mute state. Also update the menubar icon
function toggle_mic_mute()
  if hs.audiodevice.defaultInputDevice():inputMuted() then
    hs.audiodevice.defaultInputDevice():setInputMuted(false)
    hs.audiodevice.defaultInputDevice():setInputVolume(95)
    setIconState(false) -- not muted, show the mic icon
  else
    hs.audiodevice.defaultInputDevice():setInputMuted(true)
    setIconState(true) -- muted, show the muted icon
  end
end

hs.hotkey.bind(hyper, 'f', nil, function() toggle_mic_mute() end)
