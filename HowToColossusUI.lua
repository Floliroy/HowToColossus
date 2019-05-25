HowToColossus = HowToColossus or {}
local HowToColossus = HowToColossus

local WM = GetWindowManager()

local COLOSSUS = 1
local HORN = 2

local MAJOR_VULNE_ID = 122397
local MAJOR_FORCE_ID = 40225
local HORN_ID = 40224

function HowToColossus.SaveColossusLoc()
	HowToColossus.savedVariables.collossusAlertX = ColossusAlert:GetLeft()
	HowToColossus.savedVariables.collossusAlertY = ColossusAlert:GetTop()
end	

function HowToColossus.SaveHornLoc()
	HowToColossus.savedVariables.hornAlertX = HornAlert:GetLeft()
	HowToColossus.savedVariables.hornAlertY = HornAlert:GetTop()
end	

function HowToColossus.SaveColossusWin()
	HowToColossus.savedVariables.collossusWindowX = ColossusWindow:GetLeft()
	HowToColossus.savedVariables.collossusWindowY = ColossusWindow:GetTop()
end	

function HowToColossus.SaveHornWin()
	HowToColossus.savedVariables.hornWindowX = HornWindow:GetLeft()
	HowToColossus.savedVariables.hornWindowY = HornWindow:GetTop()
end	

function HowToColossus.SetUIHidden(hide)
    HornAlert:SetHidden(hide)
    ColossusAlert:SetHidden(hide)
    HornWindow:SetHidden(hide)
    ColossusWindow:SetHidden(hide)
end

function HowToColossus.UpdateWindowPannel()
    local rows = {}

    for key, value in pairs(HowToColossus.groupUltimates) do
        local segmentRow
        if value.ultType == COLOSSUS and HowToColossus.showColossus then
            if WM:GetControlByName("ColossusWindow_Segment", key) then
                segmentRow = WM:GetControlByName("ColossusWindow_Segment", key)
            else
                segmentRow = WM:CreateControlFromVirtual("ColossusWindow_Segment", ColossusWindow, "ColossusWindow_Segment", key)
            end

        elseif value.ultType == HORN and HowToColossus.showHorn then
            if WM:GetControlByName("HornWindow_Segment", key) then
                segmentRow = WM:GetControlByName("HornWindow_Segment", key)
            else
                segmentRow = WM:CreateControlFromVirtual("HornWindow_Segment", HornWindow, "HornWindow_Segment", key)
            end
            
        end
        value.segmentRow = segmentRow

        segmentRow:GetNamedChild('_Name'):SetText(value.name)
        segmentRow:GetNamedChild('_Value'):SetText(value.ultPercent .. "%")
        if value.ultPercent >= 100 then
            segmentRow:GetNamedChild('_Value'):SetColor(unpack {0, 1, 0})
        elseif value.ultPercent >= 70 then
            segmentRow:GetNamedChild('_Value'):SetColor(unpack {1, 1, 0})
        else
            segmentRow:GetNamedChild('_Value'):SetColor(unpack {1, 1, 1})
        end

        table.insert(rows, {key, value.ultPercent})
    end

    table.sort(rows, function(a, b) return a[2] > b[2] end)

	for i, row in ipairs(rows) do
        local player = HowToColossus.groupUltimates[row[1]]
        if player.ultType == COLOSSUS and HowToColossus.showColossus then
            player.segmentRow:SetAnchor(TOPLEFT, ColossusWindow, TOPLEFT, 22, i*24)
        elseif player.ultType == HORN and HowToColossus.showHorn then
            player.segmentRow:SetAnchor(TOPLEFT, HornWindow, TOPLEFT, 22, i*24)
        end
		
		player.segmentRow:SetHidden(false)
	end

    HowToColossus.SetUIHidden(false)
end
