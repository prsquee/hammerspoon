-- hyper key mapping
hyper = { "⌘", "⌥", "⌃", "⇧" }

-- start a logger
log = hs.logger.new('global','debug')
log.i('init')
--
-- get the current output device and then my speakers and headphones
-- I'm using the UID because finding by name didn't work

--log.d(hs.audiodevice.defaultOutputDevice():uid())

headphones = hs.audiodevice.findDeviceByUID('AppleHDAEngineOutput:1B,2,1,2:0')
-- speakers = hs.audiodevice.findDeviceByUID('AppleHDAEngineOutput:1B,2,1,3:1')  -- this is the FIRST 'Line Out' device
speakers = hs.audiodevice.findDeviceByUID('AppleHDAEngineOutput:1B,2,1,4:2')  -- this is the SECOND 'Line Out' device
webcamMic = hs.audiodevice.findInputByUID('AppleUSBAudioEngine:Unknown Manufacturer:HD Webcam C525:92B1D710:1')
headphonesMic = hs.audiodevice.findInputByUID('AppleHDAEngineInput:1B,2,1,0:4')

function toggle_audio_output()
  local currentOutput = hs.audiodevice.defaultOutputDevice()

  if not speakers or not headphones then
    hs.notify.new({title="Hammerspoon", informativeText="ERROR: Some audio devices are missing", ""}):send()
    return
  end

  if currentOutput:name() == speakers:name() then
    headphones:setDefaultOutputDevice()
    headphonesMic:setDefaultInputDevice()
    -- change the icons in the menubar
    audioOutputIcon:setTitle('🎧')
    setIconState(headphonesMic:inputMuted()) -- change mic icon status

    -- hs.notify.new({title='🎧', informativeText='Now using Headphones'}):send()
  else
    speakers:setDefaultOutputDevice()
    webcamMic:setDefaultInputDevice()

    audioOutputIcon:setTitle('🔊')
    setIconState(webcamMic:inputMuted()) -- change mic icon status

    -- hs.notify.new({title='🔊', informativeText='Now using Speakers'}):send()
  end
end
-- bind the toggle to hyper+a
hs.hotkey.bind(hyper, 'a', toggle_audio_output)

-- create the output icon in the menubar:
audioOutputIcon = hs.menubar.new()

function audioIconClicked()
  toggle_audio_output()
end

if audioOutputIcon then
  audioOutputIcon:setClickCallback(audioIconClicked) -- callback when clicked
  if hs.audiodevice.defaultOutputDevice():name() == speakers:name() then
    audioOutputIcon:setTitle('🔊')
  else
    audioOutputIcon:setTitle('🎧')
  end
end

-- -- -- toggle mic mute state -- -- --

function toggle_mic_mute()
  if hs.audiodevice.defaultInputDevice():inputMuted() then
    hs.audiodevice.defaultInputDevice():setInputMuted(false)
    setIconState(false) -- not muted, show the mic icon
  else
    hs.audiodevice.defaultInputDevice():setInputMuted(true)
    setIconState(true) -- muted, show the nope icon
  end
end

hs.hotkey.bind(hyper, 'f', toggle_mic_mute)

-- menubar item
muteMicIcon = hs.menubar.new()

function setIconState(state)
  if state then
    muteMicIcon:setTitle('🚫')
  else
    muteMicIcon:setTitle('🎙')
  end
end

function muteMicClicked()
  toggle_mic_mute() -- when clicked
end

if muteMicIcon then
  muteMicIcon:setClickCallback(muteMicClicked) -- callback when clicked
  setIconState(hs.audiodevice.defaultInputDevice():inputMuted()) -- startup icon status
end
