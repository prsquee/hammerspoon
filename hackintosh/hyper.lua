hyper = {"ctrl", "alt", "cmd"}
hypershift = {"ctrl", "alt", "cmd", "shift"}

-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17")

-- Trigger global shortcuts mapped to hyper in keyboard -> shortcuts
hyperBindings = {'\'','e','d','r','-','=','v','t'}
for i,key in ipairs(hyperBindings) do
  k:bind({}, key, function() hs.eventtap.keyStroke(hyper, key)
    k.triggered = true
  end)
end

-- paste in stuff like it was typed from keyboard
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

-- Leave Hyper Mode when F18 (mapped to capslock with Karabiner) is pressed,
-- send ESCAPE if no other keys are pressed during F18 modal
releasedF18 = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)
