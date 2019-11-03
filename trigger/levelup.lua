local mod = math.mod or mod
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:SetScript("OnEvent", function()
  local elite = mod(arg1,10) == 0 and true or nil
  libnotify:ShowPopup("Level: " .. arg1, arg1, "Interface\\Icons\\Spell_ChargePositive", elite)
end)
