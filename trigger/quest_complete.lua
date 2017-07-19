--[[ quest_complete]]--
-- A notification trigger for quest objective commpletion

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
