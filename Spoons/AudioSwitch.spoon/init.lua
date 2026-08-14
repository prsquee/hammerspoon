-- AudioSwitch: menubar output-device switcher for Hammerspoon.
-- Hotkey toggles between speakers and headphones; the menubar icon reflects
-- the current default output (speakers / headphones / AirPods / AirPods Pro /
-- AirPods Max). Click the menubar item for a full picker.

local obj = {}
obj.__index = obj

-- metadata
obj.name = "AudioSwitch"
obj.version = "0.2"
obj.author = "sQuEE"
obj.homepage = "https://github.com/prsquee/hammerspoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.outputIcon   = nil
obj.hotkeyToggle = nil
obj.log          = hs.logger.new("AudioSwitch", "info")

local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()

-- ---------------------------------------------------------------------------
-- Configuration
-- ---------------------------------------------------------------------------

-- Devices to toggle between. Resolved lazily (by name) at use time, so a
-- device that's absent at load won't break anything. If two devices ever share
-- a name, swap findDeviceByName for findDeviceByUID inside deviceByName().
obj.speakersName   = "Built-in Output"
obj.headphonesName = "Built-in Line Output"

-- SF Symbols rendered in the menubar. To get a glyph: open SF Symbols.app,
-- pick a symbol, right-click -> Copy Symbol, paste it between the quotes.
-- An icon can be either:
--   a plain glyph string            -> drawn as menubar text (fast path), or
--   { glyph = "X", rotate = 180 }   -> drawn as a rotated template image.
obj.speakersIcon   = { glyph = "􀝏", rotate = 180 }  -- SoundSticks: testtube.2, flipped -- REPLACE glyph with real testtube.2
obj.headphonesIcon = "􀑈"   -- headphones

-- Icon selection rules: first substring match (case-sensitive) wins. AirPods
-- report names like "Fede's AirPods Pro", hence substring matching. Add rows
-- for any other output you own (a Bluetooth speaker, an external DAC, etc.).
obj.iconRules = {
  { match = "AirPods Max", icon = "􀺹" },   -- airpodsmax  <-- REPLACE
  { match = "AirPods Pro", icon = "􀪷" },   -- airpodspro  <-- REPLACE
}

obj.iconFontSize = 19    -- menubar glyph size, in points
obj.iconOffset   = -1    -- vertical nudge: negative = lower, positive = raise

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

local function deviceByName(name)
  return name and hs.audiodevice.findDeviceByName(name) or nil
end

-- Render a glyph rotated by `angle` degrees into a menubar template image.
-- (setTitle/styledtext can't rotate text, so rotated icons go through canvas.)
local function glyphImage(glyph, size, angle)
  local dim   = math.ceil(size * 1.7)       -- canvas size (glyph scales to the bar)
  local lineH = math.ceil(size * 1.3)       -- approx glyph line height
  local raise = 0                           -- fine-tune: + = up, - = down (post-flip)
  local c = hs.canvas.new({ x = 0, y = 0, w = dim, h = dim })
  c[1] = {
    type  = "text",
    text  = hs.styledtext.new(glyph, {
      font           = { name = ".AppleSystemUIFont", size = size },
      color          = { white = 0, alpha = 1 },
      paragraphStyle = { alignment = "center" },
    }),
    -- vertically centered frame so the flip keeps the glyph centered
    frame = { x = 0, y = math.floor((dim - lineH) / 2) + raise, w = dim, h = lineH },
    transformation = hs.canvas.matrix.translate(dim / 2, dim / 2)
                                     :rotate(angle or 180)
                                     :translate(-dim / 2, -dim / 2),
  }
  local img = c:imageFromCanvas()
  c:delete()
  return img:template(true)                 -- adapt to light/dark menu bar
end

-- Pick the glyph for whatever the current default output is.
function obj.iconForDevice(dev)
  if not dev then return obj.headphonesIcon end

  local name = dev:name() or ""
  for _, rule in ipairs(obj.iconRules) do
    if name:find(rule.match, 1, true) then return rule.icon end
  end
  if name == obj.speakersName   then return obj.speakersIcon   end
  if name == obj.headphonesName then return obj.headphonesIcon end
  return obj.headphonesIcon   -- generic fallback for anything else
end

-- ---------------------------------------------------------------------------
-- Menubar rendering
-- ---------------------------------------------------------------------------

function obj.setOutputIcon()
  if not obj.outputIcon then return end
  local dev  = hs.audiodevice.defaultOutputDevice()
  local name = dev and dev:name() or "No output device"
  obj.log.i("output device -> " .. name)

  local icon = obj.iconForDevice(dev)
  if type(icon) == "table" then
    -- rotated / flipped glyph, drawn as a template image
    obj.outputIcon:setTitle("")
    obj.outputIcon:setIcon(glyphImage(icon.glyph, obj.iconFontSize, icon.rotate or 180))
  else
    -- plain glyph, drawn as menubar text
    obj.outputIcon:setIcon(nil)
    obj.outputIcon:setTitle(hs.styledtext.new(icon, {
      font = { name = ".AppleSystemUIFont", size = obj.iconFontSize },
      baselineOffset = obj.iconOffset,
    }))
  end
  obj.outputIcon:setTooltip(name)
end

-- ---------------------------------------------------------------------------
-- Actions
-- ---------------------------------------------------------------------------

function obj.clicked()
  local speakers   = deviceByName(obj.speakersName)
  local headphones = deviceByName(obj.headphonesName)
  local current    = hs.audiodevice.defaultOutputDevice()
  if not (speakers and headphones and current) then
    obj.log.w("toggle skipped: missing speakers / headphones / current device")
    return
  end
  if current:name() == speakers:name() then
    headphones:setDefaultOutputDevice()
  else
    speakers:setDefaultOutputDevice()
  end
end

-- ---------------------------------------------------------------------------
-- Spoon lifecycle
-- ---------------------------------------------------------------------------

function obj:bindHotkeys(mapping)
  if self.hotkeyToggle then
    self.hotkeyToggle:delete()
  end
  local toggleMods = mapping["toggle"][1]
  local toggleKey  = mapping["toggle"][2]
  self.hotkeyToggle = hs.hotkey.new(toggleMods, toggleKey, function() self.clicked() end)
  return self
end

function obj:start()
  self.outputIcon = hs.menubar.new()
  self.outputIcon:setClickCallback(self.clicked)   -- click toggles speaker/headphone

  self.setOutputIcon()

  -- System-level watcher: default output changed (dOut) or a device
  -- (dis)connected (dev#). One physical action can fire several events.
  hs.audiodevice.watcher.setCallback(function(event)
    if event == "dOut" then
      obj.setOutputIcon()
    elseif event == "dev#" then
      hs.timer.doAfter(1, function() obj.setOutputIcon() end)  -- let the default settle
    end
  end)
  hs.audiodevice.watcher.start()

  if self.hotkeyToggle then
    self.hotkeyToggle:enable()
  end
  return self
end

function obj:stop()
  if self.outputIcon then
    self.outputIcon:removeFromMenuBar()
    self.outputIcon = nil
  end
  hs.audiodevice.watcher.stop()
  if self.hotkeyToggle then
    self.hotkeyToggle:disable()
  end
  return self
end

return obj
