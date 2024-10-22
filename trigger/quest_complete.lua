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

local quests = {}

local function ScanCompletedQuests(silent)
  for qlogid=1,40 do
    local title, level, tag, header, collapsed, complete = GetQuestLogTitle(qlogid)
    if title and complete and not quests[title] then
      if not silent then libnotify:ShowPopup(title, level, nil, tag) end
      quests[title] = true
    elseif title and quests[title] and not complete then
      -- remove completed quest
      quests[title] = nil
    end
  end
end

local frame = CreateFrame("Frame")
frame.lock = GetTime() + 3

frame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
frame:SetScript("OnEvent", function()
  if arg1 == "player" then
    ScanCompletedQuests()
  end
end)

frame:SetScript("OnUpdate", function()
  if GetTime() > frame.lock then
    ScanCompletedQuests(true)
    this:Hide()
  end
end)
