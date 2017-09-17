-- get the current output device and then my speakers and headphones
-- I'm using the UID because finding by name didn't work

headphones  = hs.audiodevice.findDeviceByUID('AppleHDAEngineOutput:1F,3,0,1,2:0')
speakers    = hs.audiodevice.findDeviceByUID('AppleHDAEngineOutput:1F,3,0,1,3:1')    -- this is the FIRST line out device
-- whatever = hs.audiodevice.findDeviceByUID('AppleHDAEngineOutput:1F,3,0,1,4:2')   -- this is the SECOND line out device
webcamMic = hs.audiodevice.findInputByUID('AppleUSBAudioEngine:Unknown Manufacturer:HD Webcam C525:92B1D710:1')
headphonesMic = hs.audiodevice.findInputByUID('AppleHDAEngineInput:1F,3,0,1,0:4')

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
    spoon.MuteMic:setIconState(headphonesMic:inputMuted())
    -- hs.alert.show("headphones")

    -- hs.notify.new({title='🎧', informativeText='Now using Headphones'}):send()
  else
    speakers:setDefaultOutputDevice()
    webcamMic:setDefaultInputDevice()

    audioOutputIcon:setTitle('🔊')
    spoon.MuteMic:setIconState(webcamMic:inputMuted())
    -- hs.alert.show("speakers")

    -- hs.notify.new({title='🔊', informativeText='Now using Speakers'}):send()
  end
end


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

hs.hotkey.bind(hyper, 'a', nil, function() toggle_audio_output() end)
