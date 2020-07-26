hyper = {"ctrl", "alt", "shift"}
hypercmd = {"ctrl", "alt", "shift", "cmd"}
require('auto_reloader')
require('hyper')

-- hs.loadSpoon("MuteMic")
-- spoon.MuteMic:bindHotkeys({toggle={hyper, "f"}})
-- spoon.MuteMic:start()

-- {{{ audio switch
hs.loadSpoon("AudioSwitch")
yeti = hs.audiodevice.findInputByName("Yeti Stereo Microphone")
if yeti then
  yeti:setDefaultInputDevice()
  spoon.AudioSwitch:bindHotkeys({toggle={hyper, "a"}})
  spoon.AudioSwitch:start()
end

--}}}
--{{{ screen rotation
hs.loadSpoon("RotateScreen")
secondScreen = nil
screenWatcher = hs.screen.watcher.new(function()
  if hs.screen'BenQ' then
    hasSecondScreen()
  else
    spoon.RotateScreen:stop()
  end
end)

function hasSecondScreen()
  spoon.RotateScreen:bindHotkeys({toggle={hyper, "`"}})
  spoon.RotateScreen:start(hs.screen'BenQ')
end

secondScreen = hs.screen'BenQ'
  if secondScreen then
    hasSecondScreen()
  else
end
-- }}}-
-- {{{ windows manager
hs.loadSpoon('MiroWindowsManager')
hs.window.animationDuration = 0
spoon.MiroWindowsManager:bindHotkeys({
  up =          {hyper, "up"},
  right =       {hyper, "right"},
  down =        {hyper, "down"},
  left =        {hyper, "left"},
  fullscreen =  {hyper, "space"},
  vertical =    {hyper, "\\"},
  resizeLeft =  {hypercmd, "left"},
  resizeRight = {hypercmd, "right"},
  resizeUp =    {hypercmd, "up"},
  resizeDown =  {hypercmd, "down"}
})
--}}}
--{{{ coffee
hs.loadSpoon("Coffee")
spoon.Coffee:bindHotkeys({toggle={hyper, "m"}, startSaver={hyper, "s"} })
spoon.Coffee:start()
--}}}
hostname = hs.host.localizedName()
if hostname == "Magic Catalina" then
  require("lights")
end
