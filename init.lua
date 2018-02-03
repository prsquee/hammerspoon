hyper = {"ctrl", "alt", "shift"}
require('auto_reloader')
require('hyper')

hs.loadSpoon("MuteMic")
spoon.MuteMic:bindHotkeys({toggle={hyper, "f"}})
spoon.MuteMic:start()

hostname = hs.host.localizedName()
if hostname == "Magic Hi Sierra" then
  -- require('audio_switch_hackintosh')
  print('hackintosh')
  hs.loadSpoon("AudioSwitch")
  spoon.AudioSwitch:bindHotkeys({toggle={hyper, "a"}})
  spoon.AudioSwitch:start()
end
if hostname == "multivac" then
  spoon.MuteMic:mbpHeadphonesWatcher()
  require('audiowatcher')
end

require('windows')

-- moving this to a hostname based watcher
-- function audiowatch(arg)
--   -- print("Audiowatch arg: ", arg)
--   if arg == "dIn " then
--     if hs.audiodevice.defaultInputDevice():inputMuted() then
--       spoon.MuteMic:setMenuBarIcon('🙊')
--     else
--       spoon.MuteMic:setMenuBarIcon('🎙')
--     end
--   end
--   if (arg == "dOut" and hostname == "Magic Hi Sierra") then
--     if hs.audiodevice.defaultOutputDevice():name() == spoon.AudioSwitch.speakers:name() then
--       spoon.AudioSwitch:setMenuBarIcon('🔊')
--     else
--       spoon.AudioSwitch:setMenuBarIcon('🎧')
--     end
--   end
-- end
-- 
-- hs.audiodevice.watcher.setCallback(audiowatch)
-- hs.audiodevice.watcher.start()
