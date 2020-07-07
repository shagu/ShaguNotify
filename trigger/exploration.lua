local match = string.gsub(ERR_ZONE_EXPLORED, "%%s", "(.+)")

local frame = CreateFrame("Frame")
frame:RegisterEvent("UI_INFO_MESSAGE")
frame:SetScript("OnEvent", function()
  local _, _, name = string.find(arg1, match)
  if not name then return end
  libnotify:ShowPopup(name, 20, "Interface\\WorldMap\\WorldMap-MagnifyingGlass", nil, "Discovered")
end)
