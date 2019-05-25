local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")

HowToColossus = HowToColossus or {}
local HowToColossus = HowToColossus

---------------------------
---- Variables Default ----
---------------------------
HowToColossus.Default = {
	enabled = true,
	lockUI = true,

	shareColossus = true,
	showColossus = true,
	alertColossus = true,
	shareHorn = false,
	showHorn = true,
	alertHorn = false,
}
-------------------
---- Functions ----
-------------------
function HowToColossus.GetSavedVariables()
    HowToColossus.enabled = HowToColossus.enabled
	HowToColossus.lockUI = HowToColossus.lockUI

	HowToColossus.shareColossus = HowToColossus.shareColossus
	HowToColossus.showColossus = HowToColossus.showColossus
	HowToColossus.alertColossus = HowToColossus.alertColossus
	HowToColossus.shareHorn = HowToColossus.shareHorn
	HowToColossus.showHorn = HowToColossus.showHorn
	HowToColossus.alertHorn = HowToColossus.alertHorn
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
        },
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
            --disabled = function() return GetUnitRaceId("player") ~= 3 end,
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
        },
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
            --disabled = function() return HowToColossus.savedVariables.shareColossus end,
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
            tooltip = "Show an alert who will tell who need to use next Horn, and (if the addon can) when to use it",
            default = false,
            getFunc = function() return HowToColossus.alertHorn end,
            setFunc = function(newValue) 
                HowToColossus.savedVariables.alertHorn = newValue
                HowToColossus.alertHorn = newValue 
            end,
        },
	}
	LAM2:RegisterOptionControls("HowToColossus_Settings", optionsData)
end