--[[ quest_complete]]--
-- A notification trigger for quest objective commpletion
local _G = getfenv(0)
local _, _, _, client = GetBuildInfo()
client = client or 11200

local function GetQuestLogTitle(id)
  local title, level, tag, group, header, collapsed, complete, daily, _
  if client <= 11200 then -- vanilla
    title, level, tag, header, collapsed, complete = _G.GetQuestLogTitle(id)
  elseif client > 11200 then -- tbc
    title, level, tag, group, header, collapsed, complete, daily = _G.GetQuestLogTitle(id)
  end
  return title, level, tag, header, collapsed, complete
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("QUEST_WATCH_UPDATE")
frame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
frame.queue = nil
frame:SetScript("OnEvent", function()
  if event == "QUEST_WATCH_UPDATE" then
    frame.queue = arg1
  elseif event == "UNIT_QUEST_LOG_CHANGED" and frame.queue and arg1 == "player" then
    local title, level, tag, header, collapsed, complete = GetQuestLogTitle(frame.queue)
    if complete then
      libnotify:ShowPopup(title, level, nil, tag)
    end
    frame.queue = nil
  end
end)
