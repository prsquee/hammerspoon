hyper = {"ctrl", "alt", "cmd", "shift"}

hs.hotkey.bind(hyper, 'b', function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- arrows = { h = 'left', j = 'down', k = 'up', l = 'right'}
-- 
-- local function pressedArrow(arrow, mod)
--   mod = mod or {}
--   return function()
--     hs.eventtap.event.newKeyEvent(mod, arrow, true):post()
--     hs.eventtap.event.newKeyEvent(mod, arrow, false):post()
--     k.triggered = true
--   end
-- end
-- 
-- local function repeatArrow(arrow, mod)
--   mod = mod or {}
--   return function()
--     hs.eventtap.event.newKeyEvent(mod, arrow, true):setProperty(hs.eventtap.event.properties.keyboardEventAutorepeat, 1):post()
--   end
-- end
-- 
-- for key,arrow in pairs(arrows) do
--   k:bind({}, key, pressedArrow(arrow), nil, repeatArrow(arrow))
--   k:bind({'shift'}, key, pressedArrow(arrow, {'shift'}), nil, repeatArrow(arrow, {'shift'}))
-- end
-- 
-- hyper + s to activate screensaver

hs.hotkey.bind(hyper, 's', function()
  ActivateScreenSaverScript = [[
    tell application "System Events"
      start current screen saver
    end tell
  ]]
  hs.osascript.applescript(ActivateScreenSaverScript)
end)

-- hyper + c to copy solution:

hs.hotkey.bind(hyper, 'c', function()
  if hs.application.frontmostApplication():name() == 'Safari' then
  CopySolution = [[
    tell application "Safari"
      set separator to "----------------------------------------" as string
      set varURL to the URL of front document as string
      set varTITLE to the name of front document as string
      set solution to separator & "
" & varTITLE & "
" & varURL & "
" & separator
      set the clipboard to solution
    end tell
  ]]
    if hs.osascript.applescript(CopySolution) then
      hs.notify.new({title="Copy Solution", informativeText="copied to clipboard"}):send()
    end
  end
end)

-- answer phone
--
hs.hotkey.bind(hyper, 'return', function()
  telephoneApp = hs.application.find('Telephone')
  telephoneApp:activate(allWindows)
  hs.timer.usleep(1000)
  if (telephoneApp:focusedWindow():title() ~= "Red Hat") then
    telephoneApp:selectMenuItem({"Call", "Answer"})
  end
end)
