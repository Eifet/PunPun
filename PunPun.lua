local ScrollBox = CreateFrame("Frame", nil, UIParent, "WowScrollBoxList")
ScrollBox:SetPoint("CENTER")
ScrollBox:SetSize(300, 300)

local ScrollBar = CreateFrame("EventFrame", nil, UIParent, "MinimalScrollBar")
ScrollBar:SetPoint("TOPLEFT", ScrollBox, "TOPRIGHT")
ScrollBar:SetPoint("BOTTOMLEFT", ScrollBox, "BOTTOMRIGHT")


local ScrollView = CreateScrollBoxListLinearView()

ScrollUtil.InitScrollBoxListWithScrollBar(ScrollBox, ScrollBar, ScrollView)

-- The 'button' argument is the frame that our data will inhabit in our list
-- The 'data' argument will be the data table mentioned above
local function Initializer(button, data)
    local playerName = data.PlayerName
    local playerClass = data.PlayerClass
    button:SetScript("OnClick", function()
        print(playerName .. ": " .. playerClass)
    end)
    button:SetText(playerName)
end

-- The first argument here can either be a frame type or frame template. We're just passing the "UIPanelButtonTemplate" template here
ScrollView:SetElementInitializer("UIPanelButtonTemplate", Initializer)

-- Optional Resetter function which you can use to reset your frame or data element.
local function Resetter(frame, data)

    -- Insert reset code here

end
ScrollView:SetElementResetter(Resetter)

local DataProvider = CreateDataProvider()
ScrollView:SetDataProvider(DataProvider)

local myData = {
    PlayerName = "Ghost",
    PlayerClass = "Priest",
}

DataProvider:Insert(myData)



--local jokeLibrary = {
--    "Becoming a vegetarian is one big missed steak.",
--    "Becoming a vegetarian",
--    "To the guy who invented zero, thanks for nothing.",
--    "Some aquatic mammals at the zoo escaped. It was otter chaos! Some aquatic mammals at the zoo escaped. It was otter chaos! Some aquatic mammals at the zoo escaped. It was otter chaos!",
--    "I made a pun about the wind, but it blows.",
--    "Getting the ability to fly would be so uplifting. Getting the ability to fly would be so uplifting. Getting the ability to fly would be so uplifting.",
--    "Getting the ability to fly would be so uplifting. Getting the ability to fly would be so uplifting. Getting the ability to fly would be so uplifting. Getting the ability to fly would be so uplifting. Getting the ability to fly would be so uplifting.",
--    "Getting the ability to fly would be so uplifting.",
--    "@_@",
--}
--local currentChannelName = "Say"
--local currentChannel = "SAY"
--local channelsConfig = {
--    { name = "Say", code = "SAY" },
--    { name = "Target", code = "WHISPER" },
--    { name = "Yell", code = "YELL" },
--    { name = "Emote", code = "EMOTE" },
--    { name = "Party", code = "PARTY" },
--    { name = "Instance", code = "INSTANCE_CHAT" },
--    { name = "Raid", code = "RAID" },
--    { name = "Raid Warning", code = "RAID_WARNING" },
--    { name = "Guild", code = "GUILD" },
--    { name = "Officer", code = "OFFICER" },
--    { name = "Spam our GM a pun", code = "WHISPER" },
--    { name = "Spam Zalaha the Pun-tastic", code = "WHISPER" },
--}
--
--------------------------------------------------
--local jokeWindow = CreateFrame("Frame", "PunPunMainWindow", UIParent, "BackdropTemplate")
--
--jokeWindow:SetSize(350, 400)
--jokeWindow:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
--
--jokeWindow:SetMovable(true)
--jokeWindow:EnableMouse(true)
--jokeWindow:RegisterForDrag("LeftButton")
--jokeWindow:SetScript("OnDragStart", jokeWindow.StartMoving)
--jokeWindow:SetScript("OnDragStop", jokeWindow.StopMovingOrSizing)
--
--jokeWindow:SetBackdrop({
--    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
--    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
--    tile = true,
--    tileSize = 32,
--    edgeSize = 32,
--    insets = { left = 8, right = 8, top = 8, bottom = 8 },
--})
--jokeWindow:SetBackdropColor(0, 0, 0, 0.8)
--
--local titleText = jokeWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
--titleText:SetPoint("TOP", jokeWindow, "TOP", 0, -15)
--titleText:SetText("Zalaha's Pun-tastic jokes")
--
--local dropdown = CreateFrame("DropdownButton", "PunPunChannelDropdown", jokeWindow, "WowStyle1DropdownTemplate")
--dropdown:SetPoint("TOPRIGHT", jokeWindow, "TOPRIGHT", -20, -15)
--dropdown:SetSize(120, 25)
--dropdown:SetDefaultText("Say")
--
--dropdown:SetupMenu(function(dropdownFrame, rootDescription)
--    for i = 1, #channelsConfig do
--        local channelData = channelsConfig[i]
--
--        rootDescription:CreateButton(channelData.name, function()
--            currentChannelName = channelData.name
--            currentChannel = channelData.code
--            dropdownFrame:SetDefaultText(channelData.name)
--        end)
--    end
--end)
--UIDropDownMenu_Initialize(dropdown, InitializeDropdown)
--UIDropDownMenu_SetText(dropdown, "Say")
--
---- 1. The main clipping container (The Mask)
--local scrollBox = CreateFrame("Frame", nil, jokeWindow, "WowScrollBoxList")
--scrollBox:SetPoint("TOPLEFT", jokeWindow, "TOPLEFT", 10, -50)
--scrollBox:SetSize(300, 250)
--
---- 2. The scrollbar slider
--local scrollBar = CreateFrame("EventFrame", nil, jokeWindow, "WowTrimScrollBar")
--scrollBar:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 5, 0)
--scrollBar:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 5, 0)
--
--local view = CreateScrollBoxListLinearView()
--view:SetElementInitializer("Button", function(button, jokeText)
--
--    -- 1. BUILD THE UI (Only happens once per recycled button)
--    if not button.text then
--        button.text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--        button.text:SetPoint("TOPLEFT", button, "TOPLEFT", 5, -10)
--        button.text:SetWidth(280)
--        button.text:SetWordWrap(true)
--        button.text:SetJustifyH("LEFT")
--
--        -- (Optional) Add your click logic here!
--        button:SetScript("OnClick", function()
--            print("You clicked: " .. jokeText)
--        end)
--    end
--
--    -- 2. INJECT THE DATA
--    button.text:SetText(jokeText)
--
--    -- 3. CALCULATE HEIGHT
--    local textHeight = button.text:GetStringHeight()
--    button:SetHeight(textHeight + 20)
--
--end)
---- Link the UI and the Factory
--ScrollUtil.InitScrollBoxWithScrollBar(scrollBox, scrollBar, view)
--
---- Feed the Data (This automatically spawns the rows!)
--local dataProvider = CreateDataProvider(jokeLibrary)
--scrollBox:SetDataProvider(dataProvider)
--
--local prevRow = nil
--for i = 1, #jokeLibrary do
--    local row = CreateFrame("Button", nil, scrollContents, "BackdropTemplate")
--    row.joke = jokeLibrary[i]
--    row:SetHeight(30)
--
--    row:SetBackdrop({
--        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
--        tile = true, tileSize = 8, edgeSize = 8,
--        insets = { left = 2, right = 2, top = 0, bottom = 0 }
--    })
--    row:SetBackdropColor(0, 0, 0, 0)
--    if i % 2 == 0 then
--        row:SetBackdropColor(0.2, 0.2, 0.2, 0.6)
--    end
--    row:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.5)
--
--    row:SetScript("OnClick", function(self, button)
--
--        if currentChannelName == "Target" then
--            local targetName = UnitName("target")
--            if targetName then
--                SendChatMessage(self.joke, currentChannel, nil, targetName)
--            else
--                print("No target selected. Please select a target to whisper the joke.")
--            end
--            return
--        end
--        if currentChannelName == "GM Marion" then
--            SendChatMessage(self.joke, currentChannel, nil, "Marionamay-Silvermoon")
--            SendChatMessage(self.joke, currentChannel, nil, "Lilithmsky-Silvermoon")
--            SendChatMessage(self.joke, currentChannel, nil, "Whackabeitch-Daggerspine")
--            return
--        end
--        if currentChannelName == "Zalaha the Pun-tastic" then
--            SendChatMessage(self.joke, currentChannel, nil, "Zalaha-Silvermoon")
--            return
--        end
--
--        SendChatMessage(self.joke, currentChannel)
--    end)
--
--    local fontString = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--    fontString:SetPoint("LEFT", row, "LEFT", 10, 0)
--    fontString:SetJustifyH("LEFT")
--    fontString:SetJustifyV("TOP")
--    fontString:SetTextColor(1, 1, 1, 1)
--
--    --row:SetHeight(fontString:GetStringHeight() + 10) -- Add some padding
--    fontString:SetWidth(310)
--    fontString:SetWordWrap(true)
--
--    fontString:SetText(jokeLibrary[i])
--    local finalHeight = fontString:GetStringHeight()
--    row:SetHeight(finalHeight + 10) -- Add your padding
--
--    local margin = 10
--    if i == 1 then
--        -- The absolute first item pins to the top of the container window
--        row:SetPoint("TOPLEFT", jokeWindow, "TOPLEFT", margin, -40)
--        row:SetPoint("RIGHT", jokeWindow, "RIGHT", -margin, 0)
--    else
--        -- Every subsequent item pins directly below the previous item
--        row:SetPoint("TOPLEFT", prevRow, "BOTTOMLEFT", 0, 0)
--        row:SetPoint("RIGHT", jokeWindow, "RIGHT", -margin, 0)
--    end
--
--    --totalContentsHeight = totalContentsHeight + finalRowHeight + 6
--    prevRow = row
--end
--
----scrollContents:SetHeight(totalContentsHeight)
----jokeWindow:Hide()
--
------------------------------
--
--local PunPunLDB = LibStub("LibDataBroker-1.1"):NewDataObject("PunPun", {
--    type = "launcher",
--    text = "PunPun",
--    icon = "Interface\\Icons\\Spell_ChargePositive",
--
--    OnClick = function(self, button)
--        if jokeWindow:IsShown() then
--            jokeWindow:Hide()
--        else
--            jokeWindow:Show()
--        end
--    end,
--})
--
--local frame = CreateFrame("Frame")
--frame:RegisterEvent("ADDON_LOADED")
--frame:SetScript("OnEvent", function(self, event, addonName)
--    if addonName == "PunPun" then
--        PunPunDB = PunPunDB or {}
--
--        LibStub("LibDBIcon-1.0"):Register("PunPun", PunPunLDB, PunPunDB)
--    end
--end)