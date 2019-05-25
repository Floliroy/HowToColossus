local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")

HowToColossus = HowToColossus or {}
local HowToColossus = HowToColossus

---------------------------
---- Variables Default ----
---------------------------
HowToColossus.Default = {
	enabled = true,
	lockUI = true,

    --general
	shareColossus = true,
	showColossus = true,
	alertColossus = true,
	shareHorn = false,
	showHorn = true,
    alertHorn = false,
    
    --alert
    fontSize = 36,
    colorColossus = {175/255,37/255,235/255,1},
    colorHorn = {199/255,151/255,0,1},

    --UI
    collossusAlertX = 800,
    collossusAlertY = 300,
    hornAlertX = 800,
    hornAlertY = 340,
    collossusWindowX = 800,
    collossusWindowY = 500,
    hornWindowX = 1000,
    hornWindowY = 500,
}
-------------------
---- Functions ----
-------------------
function HowToColossus.GetSavedVariables()
    HowToColossus.enabled = HowToColossus.savedVariables.enabled
	HowToColossus.lockUI = HowToColossus.savedVariables.lockUI

    --general
	HowToColossus.shareColossus = HowToColossus.savedVariables.shareColossus
	HowToColossus.showColossus = HowToColossus.savedVariables.showColossus
	HowToColossus.alertColossus = HowToColossus.savedVariables.alertColossus
	HowToColossus.shareHorn = HowToColossus.savedVariables.shareHorn
	HowToColossus.showHorn = HowToColossus.savedVariables.showHorn
    HowToColossus.alertHorn = HowToColossus.savedVariables.alertHorn
    
    --alert
    HowToColossus.fontSize = HowToColossus.savedVariables.fontSize
    HowToColossus.colorColossus = HowToColossus.savedVariables.colorColossus
    HowToColossus.colorHorn = HowToColossus.savedVariables.colorHorn
    
    --UI
    HowToColossus.collossusAlertX = HowToColossus.savedVariables.collossusAlertX
    HowToColossus.collossusAlertY = HowToColossus.savedVariables.collossusAlertY
    HowToColossus.hornAlertX = HowToColossus.savedVariables.hornAlertX
    HowToColossus.hornAlertY = HowToColossus.savedVariables.hornAlertY
    HowToColossus.collossusWindowX = HowToColossus.savedVariables.collossusWindowX
    HowToColossus.collossusWindowY = HowToColossus.savedVariables.collossusWindowY
    HowToColossus.hornWindowX = HowToColossus.savedVariables.hornWindowX
    HowToColossus.hornWindowY = HowToColossus.savedVariables.hornWindowY
end

--------------
---- Menu ----
--------------
function HowToColossus.CreateSettingsWindow()
	local panelData = {
		type = "panel",
		name = "HowToColossus",
		displayName = "HowTo|caf25ebColossus|r",
		author = "Floliroy",
		version = HowToColossus.version,
		slashCommand = "/htbeam",
		registerForRefresh = true,
		registerForDefaults = true,
	}
	
	local cntrlOptionsPanel = LAM2:RegisterAddonPanel("HowToColossus_Settings", panelData)
	
	local optionsData = {
        -----------------
        ---- General ----
        -----------------
		{	type = "description",
			text = "TL;DR: Franchement Baz ...",
        },
        {   type = "header",
			name = "General",
        },
        {   type = "checkbox",
            name = "Enabled",
            tooltip = "To enable or not this addon",
            default = true,
            getFunc = function() return HowToColossus.enabled end,
            setFunc = function(newValue) 
                HowToColossus.savedVariables.enabled = newValue
                HowToColossus.enabled = newValue 
            end,
            width = "half",
        },
        {   type = "checkbox",
            name = "Lock UI",
            tooltip = "To move different window and / or announcment",
            default = true,
            getFunc = function() return HowToColossus.lockUI end,
            setFunc = function(newValue) 
                HowToColossus.savedVariables.lockUI = newValue
                HowToColossus.lockUI = newValue 
            end,
            width = "half",
        },
        {   type = "slider",
			name = "Text Size",
			tooltip = "Here you can set the size of the announcments",
			min = 20,
			max = 52,
			step = 2,
			default = 36,
			getFunc = function() return HowToColossus.fontSize end,
			setFunc = function(newValue) 
				HowToColossus.savedVariables.fontSize = newValue
				HowToColossus.fontSize = newValue
				end,
        },
        ------------------
        ---- Colossus ----
        ------------------
        {   type = "header",
			name = "|caf25ebColossus|r Part",
        },
        {   type = "checkbox",
			name = "Share Colossus",
            tooltip = function() if GetUnitRaceId("player") ~= 3 then 
                    return "You're not a necromancer you can't activate this option"
                else
                    return "Share your Colossus ultimate percentage to your group"
                end
            end,
			default = true,
			getFunc = function() return HowToColossus.shareColossus end,
			setFunc = function(newValue) 
                HowToColossus.savedVariables.shareColossus = newValue
				HowToColossus.shareColossus = newValue 
            end,
            disabled = function() return GetUnitRaceId("player") ~= 3 end,
        },
        {   type = "checkbox",
            name = "Show Colossus",
            tooltip = "Show a window with Colossus ultimate percentage of all people sharing this ultimate in your group",
            default = true,
            getFunc = function() return HowToColossus.showColossus end,
            setFunc = function(newValue) 
                HowToColossus.savedVariables.showColossus = newValue
                HowToColossus.showColossus = newValue 
            end,
        },
        {   type = "checkbox",
            name = "Show Alert",
            tooltip = "Show an alert who will tell who need to use next Colossus, and (if the addon can) when to use it",
            default = true,
            getFunc = function() return HowToColossus.alertColossus end,
            setFunc = function(newValue) 
                HowToColossus.savedVariables.alertColossus = newValue
                HowToColossus.alertColossus = newValue 
            end,
            width = "half",
        },
        {   type = "colorpicker",
            name = "Text Color",
            tooltip = "Here you can set the color of the colossus announcments",
            --default = HowToColossus.Default.colorColossus,
            getFunc = function() return unpack(HowToColossus.colorColossus) end,
            setFunc = function(r,g,b,a)
                HowToColossus.savedVariables.colorColossus = {r,g,b,a}
                HowToColossus.colorColossus = {r,g,b,a}
                HTCAlert_Name:SetColor(unpack(HowToColossus.savedVariables.colorColossus))
                HTCAlert_Timer:SetColor(unpack(HowToColossus.savedVariables.colorColossus))
                HTCAlert_Text:SetColor(unpack(HowToColossus.savedVariables.colorColossus))
            end,
            width = "half",
        },
        --------------
        ---- Horn ----
        --------------
        {   type = "header",
			name = "|cc79700Horn|r Part",
        },
        {   type = "checkbox",
			name = "Share Horn",
			tooltip = "Share your Horn ultimate percentage to your group",
			default = false,
			getFunc = function() return HowToColossus.shareHorn end,
			setFunc = function(newValue) 
                HowToColossus.savedVariables.shareHorn = newValue
				HowToColossus.shareHorn = newValue 
            end,
            disabled = function() return HowToColossus.savedVariables.shareColossus end,
        },
        {   type = "checkbox",
            name = "Show Horn",
            tooltip = "Show a window with Horn ultimate percentage of all people sharing this ultimate in your group",
            default = true,
            getFunc = function() return HowToColossus.showHorn end,
            setFunc = function(newValue) 
                HowToColossus.savedVariables.showHorn = newValue
                HowToColossus.showHorn = newValue 
            end,
        },
        {   type = "checkbox",
            name = "Show Alert",
            tooltip = "Show an alert who will tell who need to use next Horn, and when to use it",
            default = false,
            getFunc = function() return HowToColossus.alertHorn end,
            setFunc = function(newValue) 
                HowToColossus.savedVariables.alertHorn = newValue
                HowToColossus.alertHorn = newValue 
            end,
            width = "half",
        },
        {   type = "colorpicker",
            name = "Text Color",
            tooltip = "Here you can set the color of the colossus announcments",
            --default = HowToColossus.Default.colorColossus,
            getFunc = function() return unpack(HowToColossus.colorHorn) end,
            setFunc = function(r,g,b,a)
                HowToColossus.savedVariables.colorHorn = {r,g,b,a}
                HowToColossus.colorHorn = {r,g,b,a}
                --HTCAlert_Name:SetColor(unpack(HowToColossus.savedVariables.colorHorn))
                --HTCAlert_Timer:SetColor(unpack(HowToColossus.savedVariables.colorHorn))
                --HTCAlert_Text:SetColor(unpack(HowToColossus.savedVariables.colorHorn))
            end,
            width = "half",
        }, 
	}
	LAM2:RegisterOptionControls("HowToColossus_Settings", optionsData)
end