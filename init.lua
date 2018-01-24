hyper = {"ctrl", "alt", "shift"}
require('auto_reloader')
require('hyper')

hs.loadSpoon("MuteMic")
spoon.MuteMic:bindHotkeys({toggle={hyper, "f"}})
spoon.MuteMic:start()

hostname = hs.host.localizedName()
if (hostname == "Magic Hi Sierra") then
  require('audio_switch_hackintosh')
end
require('windows')

-- not sure if this is a good place to put this
function audiowatch(arg)
  -- print("Audiowatch arg: ", arg)
  if arg == "dIn " then
    if hs.audiodevice.defaultInputDevice():inputMuted() then
      spoon.MuteMic:setMenuBarIcon('🙊')
    else
      spoon.MuteMic:setMenuBarIcon('🎙')
    end
  end
end

hs.audiodevice.watcher.setCallback(audiowatch)
hs.audiodevice.watcher.start()

