-- a enubar icon to show the current mic state
muteMicIcon = hs.menubar.new()

function setIconState(state)
  if state then
    muteMicIcon:setTitle('🚫')
  else
    muteMicIcon:setTitle('🎙')
  end
end

function muteMicClicked()
  toggle_mic_mute()     -- when clicked
end

if muteMicIcon then
  muteMicIcon:setClickCallback(muteMicClicked)                    -- callback when clicked
  setIconState(hs.audiodevice.defaultInputDevice():inputMuted())  -- startup icon status
end

-- toggle mute state. Also update the menubar icon
function toggle_mic_mute()
  if hs.audiodevice.defaultInputDevice():inputMuted() then
    hs.audiodevice.defaultInputDevice():setInputMuted(false)
    setIconState(false) -- not muted, show the mic icon
  else
    hs.audiodevice.defaultInputDevice():setInputMuted(true)
    setIconState(true) -- muted, show the nope icon
  end
end

-- bind the toggle function to my hyper+f key
k:bind({}, 'f', function() toggle_mic_mute()
  k.triggered = true
end)

