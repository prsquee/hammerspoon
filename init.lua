hyper = {"ctrl", "alt", "shift"}
hypercmd = {"ctrl", "alt", "shift", "cmd"}
require('auto_reloader')
require('hyper')
--{{{ mutemic
hs.loadSpoon("MuteMic")
spoon.MuteMic:init()
spoon.MuteMic:bindHotkeys({toggle={hyper, "f"}})
--}}}
-- hs.timer.usleep(103)
-- {{{ audio switch
hs.loadSpoon("AudioSwitch")
yeti = hs.audiodevice.findInputByName("Yeti Stereo Microphone")
if yeti then
  yeti:setDefaultInputDevice()
  spoon.AudioSwitch:bindHotkeys({toggle={hyper, "a"}})
  spoon.AudioSwitch:start()
end

if not hs.audiodevice.watcher.isRunning() then
  -- this is run when output,input,device number are changed
  hs.audiodevice.watcher.setCallback(function(arg)
    if arg == "dOut" then
      spoon.AudioSwitch:setOutputIcon()
    elseif arg == "dev#" then
      print('device number changed. checking for yeti')
      spoon.AudioSwitch:checkYeti()
   -- elseif arg == "dIn " then
   --   spoon.MuteMic:fixIcon()
    end
  end)
  hs.audiodevice.watcher.start()
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
