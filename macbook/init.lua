hyper = {"ctrl", "alt", "cmd"}
hypershift = {"ctrl", "alt", "cmd", "shift"}

-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17")

-- load window mangement stuff
require('windows')

-- Trigger global shortcuts mapped to hyper
hyperBindings = {'m','\'','e','d','r','-','='}
for i,key in ipairs(hyperBindings) do
  k:bind({}, key, function() hs.eventtap.keyStroke(hyper, key)
    k.triggered = true
  end)
end

-- until karabiner can do per device filtering, this maps hyper+shift+numers to function keys
fkey_map = {
  f1  = '1', f2  = '2', f3  = '3',
  f4  = '4', f5  = '5', f6  = '6',
  f7  = '7', f8  = '8', f9  = '9',
  f10 = '0', f11 = '-', f12 = '=',
}

for fkey,key in pairs(fkey_map) do
  k:bind({'shift'}, key, function() hs.eventtap.keyStroke({}, fkey)
    k.triggered = true
  end)
end

-- temporary fix to acomodate alfred's clipboard between laptop and desktop
k:bind({}, 'v', function() hs.eventtap.keyStroke(hypershift, 'v')
  k.triggered = true
end)
k:bind({}, 't', function() hs.eventtap.keyStroke(hypershift, 't')
  k.triggered = true
end)

-- direct paste in whatever I have in the current clipboard
k:bind({'shift'}, 'v', function() hs.eventtap.keyStrokes(hs.pasteboard.getContents())
  k.triggered = true
end)

-- HYPER + HJKL to arrows

arrows = { h = 'left', j = 'down', k = 'up', l = 'right'}

local function pressedArrow(arrow, mod)
  mod = mod or {}
  return function()
    hs.eventtap.event.newKeyEvent(mod, arrow, true):post()
    hs.eventtap.event.newKeyEvent(mod, arrow, false):post()
    k.triggered = true
  end
end

local function repeatArrow(arrow, mod)
  mod = mod or {}
  return function()
    hs.eventtap.event.newKeyEvent(mod, arrow, true):setProperty(hs.eventtap.event.properties.keyboardEventAutorepeat, 1):post()
  end
end

for key,arrow in pairs(arrows) do
  k:bind({}, key, pressedArrow(arrow), nil, repeatArrow(arrow))
  k:bind({'shift'}, key, pressedArrow(arrow, {'shift'}), nil, repeatArrow(arrow, {'shift'}))
end

-- hyper + hjkl to arrow keys 
-- no repeat, do not use
-- for key,arrow in pairs(arrows) do
--   hs.hotkey.bind({'ctrl'}, key, function() hs.eventtap.keyStroke({}, arrow, 100); end)
-- end

-- hyper + s to activate screensaver

k:bind({}, 's', function() 
  ActivateScreenSaverScript = [[
    tell application "System Events"
      start current screen saver
    end tell
  ]]
  hs.osascript.applescript(ActivateScreenSaverScript)
  k.triggered = true
end)

-- hyper + c to copy solution:

k:bind({}, 'c', function()
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
  k.triggered = true
end)


-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedF18 = function()
  k.triggered = false
  k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- send ESCAPE if no other keys are pressed during F18 modal
releasedF18 = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)

-- all above is hyper modal stuff
-- below stuff not related with the hyper key
-- maybe do a spoon with this


-- using keyevents for remapping hjkl which will allow repeat

-- function keysDown(modifiers, key)
--    modifiers = modifiers or {}
--    return function()
--       hs.eventtap.event.newKeyEvent(modifiers, key, true):post()
--       hs.eventtap.event.newKeyEvent(modifiers, key, false):post()
--    end
-- end
-- hs.hotkey.bind({'shift'}, '3', keysDown({'alt'}, '3'), keysDown({'alt'}, '3'))

require('auto_reloader')
-- require('move')
require('mute_mic')
