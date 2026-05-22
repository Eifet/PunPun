local jokeLibrary = {
    "Becoming a vegetarian is one big missed steak.",
    "I tried to find camouflage pants in the store but couldn’t find any.",
    "I want to be cremated as it is my last hope for a smoking hot body.",
    "To the guy who invented zero, thanks for nothing.",
    "Why do rogues prefer leather armor? Because it's made of hide.",
    "What do you call a Tauren rogue? Invisi-bull.",
    "What do you call a druid fighting in treant form? A combat log.",
    "Why are Frost Mages so great at guild meetups? They really know how to break the ice.",
    "What do you call an Undead who plays the piano? A decomposer.",
    "How many rogues does it take to kill a paladin? Two; one to jump him, and one to wait at the inn in Ironforge.",
    "Why don’t priests ever get invited to a fancy dinner? Because they can’t use plate.",
    "Did you know a lot of players play as Tauren paladins? Holy cow!",
    "Where do Ogres buy their clothes? From the Dire Mall",
    "Yo Mama's so fat, chain lightning hits her three times.",
    "Yo mama so fat, she hit exalted with McDonalds.",
    "Yo mama so fat, when a rogue shadowsteps her, he gets a loading screen.",
    "Yo mama so fat, when a rogue shadowsteps her, he gets a loading screen.",
    "Yo mama so fat, you need a full raid of warlocks to summon her.",
    "Why don't warriors enchant their weapons with +intellect? Because they don't want their weapons to be smarter than they are.",
    "What’s the abbreviation for Death Knight? Decay.",
}

local currentChannelName = "Say"
local currentChannel = "SAY"

local channelsConfig = {
    { name = "Say", code = "SAY" },
    { name = "Target", code = "WHISPER" },
    { name = "Yell", code = "YELL" },
    { name = "Emote", code = "EMOTE" },
    { name = "Party", code = "PARTY" },
    { name = "Instance", code = "INSTANCE_CHAT" },
    { name = "Raid", code = "RAID" },
    { name = "Raid Warning", code = "RAID_WARNING" },
    { name = "Guild", code = "GUILD" },
    { name = "Officer", code = "OFFICER" },
    { name = "Spam our GM a pun", code = "WHISPER" },
    { name = "Spam Waleeria a pun", code = "WHISPER" },
    { name = "Spam Lulu the Pun-tastic", code = "WHISPER" },
}

-------------------------------------------------
-- 1. MAIN WINDOW SETUP
-------------------------------------------------
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
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
jokeWindow:SetBackdropColor(0, 0, 0, 0.8)

local titleText = jokeWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
titleText:SetPoint("TOP", jokeWindow, "TOP", 0, -15)
titleText:SetText("Lulu's Pun-tastic jokes")

local watermark = jokeWindow:CreateTexture(nil, "BACKGROUND")

-- Load your custom image
watermark:SetTexture("Interface\\AddOns\\PunPun\\Big_icon.tga")

-- Size and position it perfectly in the center of the window
watermark:SetSize(450, 450)
watermark:SetPoint("CENTER", jokeWindow, "CENTER", -15, 0)

-- Make it highly transparent! (0.0 is invisible, 1.0 is solid)
-- 0.15 gives it a subtle, professional watermark look
watermark:SetAlpha(0.45)

-- Create the standard Blizzard Close Button
local closeButton = CreateFrame("Button", nil, jokeWindow, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", jokeWindow, "TOPRIGHT", 0, 0)
closeButton:SetScript("OnClick", function()
    jokeWindow:Hide()
end)

-------------------------------------------------
-- 2. DROPDOWN MENU SETUP
-------------------------------------------------
local dropdown = CreateFrame("DropdownButton", "PunPunChannelDropdown", jokeWindow, "WowStyle1DropdownTemplate")
dropdown:SetPoint("TOPRIGHT", jokeWindow, "TOPRIGHT", -20, -35)
dropdown:SetSize(120, 25)
dropdown:SetDefaultText("Say")

dropdown:SetupMenu(function(dropdownFrame, rootDescription)
    for i = 1, #channelsConfig do
        local channelData = channelsConfig[i]
        rootDescription:CreateButton(channelData.name, function()
            currentChannelName = channelData.name
            currentChannel = channelData.code
            dropdownFrame:SetDefaultText(channelData.name)
        end)
    end
end)

-------------------------------------------------
-- 3. SCROLLBOX & LIST VIEW
-------------------------------------------------
local scrollBox = CreateFrame("Frame", nil, jokeWindow, "WowScrollBoxList")
scrollBox:SetPoint("TOPLEFT", jokeWindow, "TOPLEFT", 15, -60)
scrollBox:SetPoint("BOTTOMRIGHT", jokeWindow, "BOTTOMRIGHT", -30, 15)

local scrollBar = CreateFrame("EventFrame", nil, jokeWindow, "MinimalScrollBar")
scrollBar:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 5, 0)
scrollBar:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 5, 0)

local view = CreateScrollBoxListLinearView()

-- A. THE MEASURING TOOL (Hidden string just for calculating dynamic heights)
local measureString = UIParent:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
measureString:SetWidth(270) -- Must perfectly match the row text width below!
measureString:SetWordWrap(true)
measureString:SetJustifyH("LEFT")
measureString:Hide()

-- B. TELL THE SCROLLBOX THE EXACT HEIGHT OF EVERY ROW AHEAD OF TIME
view:SetElementExtentCalculator(function(dataIndex, data)
    measureString:SetText(data.joke)
    local textHeight = measureString:GetStringHeight()
    return textHeight + 16 -- Add 16px of vertical padding to the returned height
end)

-- C. THE ROW FACTORY (Using a valid empty XML frame template)
view:SetElementInitializer("BackdropTemplate", function(row, data)

    if not row.initialized then
        row:EnableMouse(true) -- Allow the Frame to be clicked

        -- Manually add the Button Hover Highlight
        row.highlight = row:CreateTexture(nil, "HIGHLIGHT")
        row.highlight:SetAllPoints(row)
        row.highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
        row.highlight:SetBlendMode("ADD")

        -- Background Color Layer
        row.bg = row:CreateTexture(nil, "BACKGROUND")
        row.bg:SetAllPoints(row)

        -- Text Layout
        row.text = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        row.text:SetPoint("LEFT", row, "LEFT", 10, 0)
        row.text:SetJustifyH("LEFT")
        row.text:SetJustifyV("TOP")
        row.text:SetWidth(270)
        row.text:SetWordWrap(true)
        row.text:SetTextColor(1, 1, 1, 1)

        row.initialized = true
    end

    -- Inject Data
    row.text:SetText(data.joke)

    -- Alternating Background Colors
    if data.index % 2 == 0 then
        row.bg:SetColorTexture(0.2, 0.2, 0.2, 0.6)
    else
        row.bg:SetColorTexture(0, 0, 0, 0)
    end

    -- D. THE CLICK LOGIC (Using OnMouseUp since it's a Frame, not a Button)
    row:SetScript("OnMouseUp", function()
        if currentChannelName == "Target" then
            local targetName = UnitName("target")
            if targetName then
                SendChatMessage(data.joke, currentChannel, nil, targetName)
            else
                print("|cFFFF0000PunPun:|r Please select a target to whisper the joke.")
            end
            return
        end

        if currentChannelName == "Spam our GM a pun" then
            SendChatMessage(data.joke, "WHISPER", nil, "Marionamay-Silvermoon")
            SendChatMessage(data.joke, "WHISPER", nil, "Lilithmsky-Silvermoon")
            SendChatMessage(data.joke, "WHISPER", nil, "Whackabeitch-Daggerspine")
            return
        end

        if currentChannelName == "Spam Waleeria a pun" then
            SendChatMessage(data.joke, "WHISPER", nil, "Wáleeria-ArgentDawn")
            SendChatMessage(data.joke, "WHISPER", nil, "Néleeria-ArgentDawn")
            SendChatMessage(data.joke, "WHISPER", nil, "Máleeria-ArgentDawn")
            SendChatMessage(data.joke, "WHISPER", nil, "Támeeria-ArgentDawn")
            return
        end
        
        if currentChannelName == "Spam Lulu the Pun-tastic" then
            SendChatMessage(data.joke, "WHISPER", nil, "Pennsatucky-Silvermoon")
            SendChatMessage(data.joke, "WHISPER", nil, "Shandie-Silvermoon")
            SendChatMessage(data.joke, "WHISPER", nil, "Lululime-Silvermoon")
            SendChatMessage(data.joke, "WHISPER", nil, "Artego-ArgentDawn")
            return
        end
        
        SendChatMessage(data.joke, currentChannel)
    end)
end)

ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBar, view)

local dataProvider = CreateDataProvider()
for i = 1, #jokeLibrary do
    dataProvider:Insert({ index = i, joke = jokeLibrary[i] })
end
scrollBox:SetDataProvider(dataProvider)
-------------------------------------------------
-- 4. MINIMAP ICON SETUP
-------------------------------------------------
local PunPunLDB = LibStub("LibDataBroker-1.1"):NewDataObject("PunPun", {
    type = "launcher",
    text = "PunPun",
    icon = "Interface\\AddOns\\PunPun\\Small_icon.tga",
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