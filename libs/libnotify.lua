libnotify = {}
libnotify.window = {}

libnotify.max_window = 5

-- detect current addon path
local addonpath
local tocs = { "", "-master", "-tbc", "-wotlk" }
for _, name in pairs(tocs) do
  local current = string.format("ShaguNotify%s", name)
  local _, title = GetAddOnInfo(current)
  if title then
    addonpath = "Interface\\AddOns\\" .. current
    break
  end
end

function libnotify:CreateFrame()
  local frame = CreateFrame("Button", "Achievment", UIParent)

  frame:SetWidth(300)
  frame:SetHeight(88)
  frame:SetFrameStrata("DIALOG")
  frame:Hide()

  do -- animations
    frame:SetScript("OnShow", function()
      this.modifyA = 1
      this.modifyB = 0
      this.stateA = 0
      this.stateB = 0
      this.animate = true

      this.showTime = GetTime()
    end)

    frame:SetScript("OnUpdate", function()
      if ( this.tick or 1) > GetTime() then return else this.tick = GetTime() + .01 end

      if this.animate == true then
        if this.stateA > .50 and this.modifyA == 1 then
          this.modifyB = 1
        end

        if this.stateA > .75 then
          this.modifyA = -1
        end

        if this.stateB > .50 then
          this.modifyB = -1
        end

        this.stateA = this.stateA + this.modifyA/50
        this.stateB = this.stateB + this.modifyB/50

        this.glow:SetGradientAlpha("HORIZONTAL",
          this.stateA, this.stateA, this.stateA, this.stateA,
          this.stateB, this.stateB, this.stateB, this.stateB)

        this.shine:SetGradientAlpha("VERTICAL",
          this.stateA, this.stateA, this.stateA, this.stateA,
          this.stateB, this.stateB, this.stateB, this.stateB)

        if this.stateA < 0 and this.stateB < 0 then
          this.animate = false
        end
      end

      if this.showTime + 5 < GetTime() then
        this:SetAlpha(this:GetAlpha() - .05)
        if this:GetAlpha() <= 0 then
          this:Hide()
          this:SetAlpha(1)
        end
      end
    end)
  end

  frame.background = frame:CreateTexture("background", "BACKGROUND")
  frame.background:SetTexture(addonpath .. "\\textures\\UI-Achievement-Alert-Background")
  frame.background:SetPoint("TOPLEFT", 0, 0)
  frame.background:SetPoint("BOTTOMRIGHT", 0, 0)
  frame.background:SetTexCoord(0, .605, 0, .703)

  frame.unlocked = frame:CreateFontString("Unlocked", "DIALOG", "GameFontBlack")
  frame.unlocked:SetWidth(200)
  frame.unlocked:SetHeight(12)
  frame.unlocked:SetPoint("TOP", 7, -23)
  frame.unlocked:SetText(COMPLETE)

  frame.name = frame:CreateFontString("Name", "DIALOG", "GameFontHighlight")
  frame.name:SetWidth(240)
  frame.name:SetHeight(16)
  frame.name:SetPoint("BOTTOMLEFT", 72, 36)
  frame.name:SetPoint("BOTTOMRIGHT", -60, 36)

  frame.glow = frame:CreateTexture("glow", "OVERLAY")
  frame.glow:SetTexture(addonpath .. "\\textures\\UI-Achievement-Alert-Glow")
  frame.glow:SetBlendMode("ADD")
  frame.glow:SetWidth(400)
  frame.glow:SetHeight(171)
  frame.glow:SetPoint("CENTER", 0, 0)
  frame.glow:SetTexCoord(0, 0.78125, 0, 0.66796875)
  frame.glow:SetAlpha(0)

  frame.shine = frame:CreateTexture("shine", "OVERLAY")
  frame.shine:SetBlendMode("ADD")
  frame.shine:SetTexture(addonpath .. "\\textures\\UI-Achievement-Alert-Glow")
  frame.shine:SetWidth(67)
  frame.shine:SetHeight(72)
  frame.shine:SetPoint("BOTTOMLEFT", 0, 8)
  frame.shine:SetTexCoord(0.78125, 0.912109375, 0, 0.28125)
  frame.shine:SetAlpha(0)

  frame.icon = CreateFrame("Frame", "icon", frame)
  frame.icon:SetWidth(124)
  frame.icon:SetHeight(124)
  frame.icon:SetPoint("TOPLEFT", -26, 16)

  --[[
  frame.icon.backfill = frame.icon:CreateTexture("backfill", "BACKGROUND")
  frame.icon.backfill:SetBlendMode("ADD")
  frame.icon.backfill:SetTexture(addonpath .. "\\textures\\UI-Achievement-IconFrame-Backfill")
  frame.icon.backfill:SetPoint("CENTER", 0, 0)
  frame.icon.backfill:SetWidth(64)
  frame.icon.backfill:SetHeight(64)
  ]]--

  frame.icon.bling = frame.icon:CreateTexture("bling", "BORDER")
  frame.icon.bling:SetTexture(addonpath .. "\\textures\\UI-Achievement-Bling")
  frame.icon.bling:SetPoint("CENTER", -1, 1)
  frame.icon.bling:SetWidth(116)
  frame.icon.bling:SetHeight(116)

  frame.icon.texture = frame.icon:CreateTexture("texture", "ARTWORK")
  frame.icon.texture:SetPoint("CENTER", 0, 3)
  frame.icon.texture:SetWidth(50)
  frame.icon.texture:SetHeight(50)

  frame.icon.overlay = frame.icon:CreateTexture("overlay", "OVERLAY")
  frame.icon.overlay:SetTexture(addonpath .. "\\textures\\UI-Achievement-IconFrame")
  frame.icon.overlay:SetPoint("CENTER", -1, 2)
  frame.icon.overlay:SetHeight(72)
  frame.icon.overlay:SetWidth(72)
  frame.icon.overlay:SetTexCoord(0, 0.5625, 0, 0.5625)

  frame.shield = CreateFrame("Frame", "shield", frame)
  frame.shield:SetWidth(64)
  frame.shield:SetHeight(64)
  frame.shield:SetPoint("TOPRIGHT", -10, -13)

  frame.shield.icon = frame.shield:CreateTexture("icon", "BACKGROUND")
  frame.shield.icon:SetTexture(addonpath .. "\\textures\\UI-Achievement-Shields")
  frame.shield.icon:SetWidth(52)
  frame.shield.icon:SetHeight(48)
  frame.shield.icon:SetPoint("TOPRIGHT", 1, -8)

  frame.shield.points = frame.shield:CreateFontString("Name", "DIALOG", "GameFontWhite")
  frame.shield.points:SetPoint("CENTER", 7, 2)
  frame.shield.points:SetWidth(64)
  frame.shield.points:SetHeight(64)

  return frame
end

function libnotify:ShowPopup(text, points, icon, elite)
  for i=1, libnotify.max_window do
    if not libnotify.window[i]:IsVisible() then
      libnotify.window[i].unlocked:SetText(COMPLETE)
      libnotify.window[i].name:SetText(text or "DUMMY")
      libnotify.window[i].icon.texture:SetTexture(icon or "Interface\\QuestFrame\\UI-QuestLog-BookIcon")

      if elite then
        libnotify.window[i].shield.icon:SetTexCoord(0, .5 , .5 , 1)
      else
        libnotify.window[i].shield.icon:SetTexCoord(0, .5 , 0 , .5)
      end

      libnotify.window[i].shield.points:SetText(points or "10")
      libnotify.window[i]:Show()

      return
    end
  end
end

for i=1, libnotify.max_window do
  libnotify.window[i] = libnotify:CreateFrame()
  libnotify.window[i]:SetPoint("BOTTOM", 0, 28 + (100*i))
end
