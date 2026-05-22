local jokeLibrary = {
    "Becoming a vegetarian is one big missed steak.",
    "Becoming a vegetarian",
    "To the guy who invented zero, thanks for nothing.",
    "Some aquatic mammals at the zoo escaped. It was otter chaos! Some aquatic mammals at the zoo escaped. It was otter chaos! Some aquatic mammals at the zoo escaped. It was otter chaos!",
    "I made a pun about the wind, but it blows.",
    "Getting the ability to fly would be so uplifting. Getting the ability to fly would be so uplifting. Getting the ability to fly would be so uplifting.",
    "Getting the ability to fly would be so uplifting. Getting the ability to fly would be so uplifting. Getting the ability to fly would be so uplifting. Getting the ability to fly would be so uplifting. Getting the ability to fly would be so uplifting.",
    "Getting the ability to fly would be so uplifting.",
}
local currentChannel = "SAY"

------------------------------------------------
local jokeWindow = CreateFrame("Frame", "PunPunMainWindow", UIParent, "BackdropTemplate")

jokeWindow:SetSize(350, 400)
jokeWindow:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

jokeWindow:SetMovable(true)
jokeWindow:EnableMouse(true)
jokeWindow:RegisterForDrag("LeftButton")
jokeWindow:SetScript("OnDragStart", jokeWindow.StartMoving)
jokeWindow:SetScript("OnDragStop", jokeWindow.StopMovingOrSizing)

jokeWindow:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
jokeWindow:SetBackdropColor(0, 0, 0, 0.8)

local titleText = jokeWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
titleText:SetPoint("TOP", jokeWindow, "TOP", 0, -15)
titleText:SetText("Zalaha's Pun-tastic jokes")

local dropdown = CreateFrame("DropdownButton", "PunPunChannelDropdown", jokeWindow, "UIDropDownMenuTemplate")
dropdown:SetPoint("TOPRIGHT", jokeWindow, "TOPRIGHT", -20, -15)
dropdown:SetSize(120, 25)
--dropdown:SetDefaultText("Say")

-- 2. Define the Menu Initialization function
local function InitializeDropdown(self, level)
    -- We use a single reusable table to pass details to the button generator
    local info = UIDropDownMenu_CreateInfo()

    -- Option 1: Say
    info.text = "Say"
    info.value = "SAY"
    info.func = function(button)
        -- 'button.value' contains "SAY"
        currentChannel = button.value
        -- Set the text showing on the closed dropdown box
        UIDropDownMenu_SetText(dropdown, button:GetText())
    end
    UIDropDownMenu_AddButton(info)

    -- Option 2: Party
    info.text = "Party"
    info.value = "PARTY"
    info.func = function(button)
        currentChannel = button.value
        UIDropDownMenu_SetText(dropdown, button:GetText())
    end
    UIDropDownMenu_AddButton(info)
end
UIDropDownMenu_Initialize(dropdown, InitializeDropdown)
UIDropDownMenu_SetText(dropdown, "Say")

-- Set the initial text displayed on the button when the addon loads
--dropdown:SetSelectionText(function() return "Say" end)


local prevRow = nil
for i = 1, #jokeLibrary do
    local row = CreateFrame("Button", nil, jokeWindow, "BackdropTemplate")
    row.joke = jokeLibrary[i]
    row:SetHeight(30)

    row:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = true, tileSize = 8, edgeSize = 8,
        insets = { left = 2, right = 2, top = 0, bottom = 0 }
    })
    row:SetBackdropColor(0, 0, 0, 0)
    if i % 2 == 0 then
        row:SetBackdropColor(0.2, 0.2, 0.2, 0.6) 
    end
    row:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.5) 
    
    row:SetScript("OnClick", function(self, button)
        SendChatMessage(self.joke, currentChannel)
    end)
    
    local fontString = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fontString:SetPoint("LEFT", row, "LEFT", 10, 0)
    fontString:SetJustifyH("LEFT")
    fontString:SetJustifyV("TOP")
    fontString:SetTextColor(1, 1, 1, 1)

    --row:SetHeight(fontString:GetStringHeight() + 10) -- Add some padding
    fontString:SetWidth(310)
    fontString:SetWordWrap(true)

    fontString:SetText(jokeLibrary[i])
    local finalHeight = fontString:GetStringHeight()
    row:SetHeight(finalHeight + 10) -- Add your padding
    
    local margin = 10
    if i == 1 then
        -- The absolute first item pins to the top of the container window
        row:SetPoint("TOPLEFT", jokeWindow, "TOPLEFT", margin, -40)
        row:SetPoint("RIGHT", jokeWindow, "RIGHT", -margin, 0)
    else
        -- Every subsequent item pins directly below the previous item
        row:SetPoint("TOPLEFT", prevRow, "BOTTOMLEFT", 0, 0)
        row:SetPoint("RIGHT", jokeWindow, "RIGHT", -margin, 0)
    end

    prevRow = row
end

--jokeWindow:Hide()

----------------------------

local PunPunLDB = LibStub("LibDataBroker-1.1"):NewDataObject("PunPun", {
    type = "launcher",
    text = "PunPun",
    icon = "Interface\\Icons\\Spell_ChargePositive",

    OnClick = function(self, button)
        if jokeWindow:IsShown() then
            jokeWindow:Hide()
        else
            jokeWindow:Show()
        end
    end,
})

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "PunPun" then
        PunPunDB = PunPunDB or {}

        LibStub("LibDBIcon-1.0"):Register("PunPun", PunPunLDB, PunPunDB)
    end
end)