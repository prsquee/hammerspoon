k:bind({}, 'return', function()
  telephoneApp = hs.application.find('Telephone')
  telephoneApp:activate(allWindows)
  telephoneApp:selectMenuItem({"Call", "Answer"})
  k.triggered = true
end)


