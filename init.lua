hyper = {"ctrl", "alt", "shift"}
hypercmd = {"ctrl", "alt", "shift", "cmd"}
hostname = hs.host.localizedName()
if hostname == "Magic Computer" then
  -- {{{ audio switch
  hs.loadSpoon("AudioSwitch")
  spoon.AudioSwitch:bindHotkeys({toggle={hyper, "a"}})
  spoon.AudioSwitch:start()
  --}}}
end

local HUE_URL = "http://192.168.1.6/api/gvm-8AuYApYytrTI9FrwZsbyoWYqHc94gKip0stK/lights/17/state"
local function setDeskLamp(on)
  hs.http.doAsyncRequest(HUE_URL, "PUT",
    on and '{"on":true}' or '{"on":false}', nil, function() end)
end

deskLampWatcher = hs.caffeinate.watcher.new(function(event)
  if event == hs.caffeinate.watcher.screensDidUnlock then
    local hour = os.date("*t").hour
    if hour >= 19 or hour < 7 then
      setDeskLamp(true)
    end
  elseif event == hs.caffeinate.watcher.screensDidSleep then
    setDeskLamp(false)
  end

end)
deskLampWatcher:start()

require('auto_reloader')
require('hyper')
--{{{ mutemic
--hs.loadSpoon("MuteMic")
--spoon.MuteMic:bindHotkeys({toggle={hyper, "f"}})
--}}}
-- {{{ windows manager
hs.loadSpoon('MiroWindowsManager')
hs.window.animationDuration = 0
spoon.MiroWindowsManager:bindHotkeys({
  up =          {hyper, "up"},
  right =       {hyper, "right"},
  down =        {hyper, "down"},
  left =        {hyper, "left"},
  fullscreen =  {hyper, "space"},
  nextScreen =  {hyper, "delete"},
  vertical =    {hyper, "\\"},
  resizeLeft =  {hypercmd, "left"},
  resizeRight = {hypercmd, "right"},
  resizeUp =    {hypercmd, "up"},
  resizeDown =  {hypercmd, "down"}
})
--}}}
require('mouse')
