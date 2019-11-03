local combat = CreateFrame("Frame")
combat:RegisterEvent("PLAYER_ENTER_COMBAT")
combat:RegisterEvent("PLAYER_LEAVE_COMBAT")
combat:SetScript("OnEvent", function()
  this.inCombat = event == "PLAYER_ENTER_COMBAT" and true or nil
end)

local frame = CreateFrame("Frame")
frame:RegisterEvent("UNIT_HEALTH")
frame:SetScript("OnEvent", function()
  if arg1 == "player" and combat.inCombat then
    local perc = UnitHealth("player") / UnitHealthMax("player") * 100
    if perc < 5 or UnitHealth("player") <= 5 then
      this.waslow = true
    end
  end

  if UnitHealth("player") < 0 or UnitIsDead("player") then
    this.waslow = nil
  end
end)

frame:SetScript("OnUpdate", function()
  if not this.waslow then return end
  if combat.inCombat then return end

  this.waslow = nil
  libnotify:ShowPopup("I will survive!", UnitLevel("player"), "Interface\\Icons\\INV_Misc_Bomb_04", true)
end)
