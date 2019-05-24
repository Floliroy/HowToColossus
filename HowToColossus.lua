local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")
-----------------
---- Globals ----
-----------------
HowToColossus = HowToColossus or {}
local HowToColossus = HowToColossus

HowToColossus.name = "HowToColossus"
HowToColossus.version = "0.1"

---------------------------
---- Variables Default ----
---------------------------
HowToColossus.Default = {
}

-------------------------
---- Settings Window ----
-------------------------
function HowToColossus.CreateSettingsWindow()
	local panelData = {
		type = "panel",
		name = "HowToColossus",
		displayName = "HowTo|cdf25e4Colossus|r",
		author = "Floliroy",
		version = HowToColossus.version,
		slashCommand = "/htbeam",
		registerForRefresh = true,
		registerForDefaults = true,
	}
	
	local cntrlOptionsPanel = LAM2:RegisterAddonPanel("HowToColossus_Settings", panelData)
	
	local optionsData = {
	}
	LAM2:RegisterOptionControls("HowToColossus_Settings", optionsData)
end
 
function HowToColossus:Initialize()
	--Settings
	HowToColossus.CreateSettingsWindow()
	
	--Saved Variables
	HowToColossus.savedVariables = ZO_SavedVars:New("HowToColossusVariables", 1, nil, HowToColossus.Default)

	--Events Register
	EVENT_MANAGER:UnregisterForEvent(HowToColossus.name, EVENT_ADD_ON_LOADED)
	
end

function HowToColossus.SaveLoc()
	HowToColossus.savedVariables.OffsetX = HowToColossusAlert:GetLeft()
	HowToColossus.savedVariables.OffsetY = HowToColossusAlert:GetTop()
end	
 
function HowToColossus.OnAddOnLoaded(event, addonName)
	if addonName ~= HowToColossus.name then return end
		HowToColossus:Initialize()
end

EVENT_MANAGER:RegisterForEvent(HowToColossus.name, EVENT_ADD_ON_LOADED, HowToColossus.OnAddOnLoaded)