local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")
-----------------
---- Globals ----
-----------------
--Base
HowToColossus = HowToColossus or {}
local HowToColossus = HowToColossus

HowToColossus.name = "HowToColossus"
HowToColossus.version = "0.1"

--ultimates
local COLOSSUS = 1
local HORN = 2

--in game ID
local MAJOR_VULNE_ID = 122397
local MAJOR_FORCE_ID = 40225
local HORN_ID = 40224

--variables
HowToColossus.groupUltimates = {}
HowToColossus.playerTag = ""

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

-------------------
---- Functions ----
-------------------
function HowToColossus.GetUltimatePercent(ultType)

	local cost
	if ultType == COLOSSUS then --colossus
		cost = GetAbilityCost(122395)
	else --horn
		cost = GetAbilityCost(40223)
	end

	local current = GetUnitPower("player", POWERTYPE_ULTIMATE)

	return math.min(100, math.floor((current / cost) * 100))
end

function HowToColossus.Share()
	HowToColossus.GetUltimates()
	--TODO add share to settings
	HowToColossus.shareColossus = true
	HowToColossus.shareHorn = false

	if HowToColossus.shareColossus then
		local ultPercent = HowToColossus.GetUltimatePercent(COLOSSUS)
		HowToColossus.SendUltimate(COLOSSUS, ultPercent)

	elseif HowToColossus.shareHorn then
		local ultPercent = HowToColossus.GetUltimatePercent(HORN)
		HowToColossus.SendUltimate(HORN, ultPercent)
	end
end

function HowToColossus.GetMajorVulneOn(unitTag)
	local currentTimeStamp = GetGameTimeMilliseconds() / 1000

	for i=1,GetNumBuffs(unitTag) do 
		local _, _, timeEnding, _, _, _, _, _, _, _, abilityId, _, _ = GetUnitBuffInfo(unitTag,i)
		if zo_strformat(SI_ABILITY_NAME,GetAbilityName(abilityId)) == zo_strformat(SI_ABILITY_NAME, GetAbilityName(MAJOR_VULNE_ID)) then
			return timeEnding - currentTimeStamp
		end
	end
	return 0
end

function HowToColossus.GetHornInGroup()
	local currentTimeStamp = GetGameTimeMilliseconds() / 1000
	local timerForce = 0
	local timerHorn = 0

	if GetGroupSize() > 0 then
		for i = 1, GetGroupSize() do
			local _, _, timeEnding, _, _, _, _, _, _, _, abilityId, _, _ = GetUnitBuffInfo(unitTag,i)
			if zo_strformat(SI_ABILITY_NAME,GetAbilityName(abilityId)) == zo_strformat(SI_ABILITY_NAME, GetAbilityName(MAJOR_FORCE_ID)) then
				if timeEnding - currentTimeStamp > timerForce then
					timerForce = timeEnding - currentTimeStamp
				end
			end
			if zo_strformat(SI_ABILITY_NAME,GetAbilityName(abilityId)) == zo_strformat(SI_ABILITY_NAME, GetAbilityName(HORN_ID)) and timerForce == 0 then
				if timeEnding - currentTimeStamp > timerHorn then
					timerHorn = timeEnding - currentTimeStamp
				end
			end
		end
	end

	if timerForce == 0 then
		return timerHorn
	else
		return timerForce
	end
end

function HowToColossus.GetNextColossus()
	local ultPercent = 0
	local name = ""
	local playerTag = ""

	for key, value in ipairs(HowToColossus.groupUltimates) do
		if value.ultType == COLOSSUS and value.ultPercent >= 100 then
			return value.name, key

		elseif value.ultType == COLOSSUS and value.ultPercent > ultPercent then
			ultPercent = value.ultPercent
			name = value.name
			playerTag = key

		end
	end

	return name, playerTag
end

function HowToColossus.OnGroupDeath(eventCode, unitTag, isDead)
	if HowToColossus.playerTag == unitTag and isDead then 
		HowToColossus.UpdateAlert()

	end
end

function HowToColossus.OnCombatState(eventCode, inCombat)
	inCombat = inCombat or false 
	if not inCombat then
		HowToColossus.UpdateNext()
		EVENT_MANAGER:UnregisterForUpdate(HowToColossus.name .. "Alert")
	else
		EVENT_MANAGER:RegisterForUpdate(HowToColossus.name .. "Alert", 100, HowToColossus.UpdateAlert)
	end
end

--------------
---- Main ----
--------------
function HowToColossus.UpdateGeneral()
	HowToColossus.Share()
	--HowToColossus.UpdatePannel()
end

function HowToColossus.UpdateNext()
	local playerName, playerTag = HowToColossus.GetNextColossus()
	HowToColossus.playerTag = playerTag

	HTCAlertName:SetText(playerName .. " NEXT")
	HTCAlertTimer:SetText("")
end

function HowToColossus.UpdateIn()	
	if HowToColossus.GetMajorVulneOn("boss1") <= 0 then
		HTCAlertTimer:SetText("ASAP")
	else
		HTCAlertTimer:SetText("IN " .. HowToColossus.GetMajorVulneOn("boss1"))
	end

	if HowToColossus.GetMajorVulneOn("boss1") > 4.9 then
		local playerName, playerTag = HowToColossus.GetNextColossus()
		HowToColossus.playerTag = playerTag

		HTCAlertName:SetText(playerName)

	end
end

function HowToColossus.UpdateAlert()
	if HowToColossus.playerTag == "" or (HowToColossus.groupUltimates[HowToColossus.playerTag].ultPercent < 10 and HowToColossus.GetMajorVulneOn("boss1") <= 0) then
		HowToColossus.UpdateNext()
	else
		HowToColossus.UpdateIn()
	end
end

function HowToColossus:Initialize()
	--Settings
	HowToColossus.CreateSettingsWindow()
	
	--Saved Variables
	HowToColossus.savedVariables = ZO_SavedVars:New("HowToColossusVariables", 1, nil, HowToColossus.Default)

	--Events Register HowToColossus.OnCombatState
	EVENT_MANAGER:RegisterForEvent(HowToColossus.name .. "Activate", EVENT_PLAYER_ACTIVATED, HowToColossus.OnCombatState)
	EVENT_MANAGER:RegisterForEvent(HowToColossus.name .. "Combat", EVENT_PLAYER_COMBAT_STATE, HowToColossus.OnCombatState)	
	EVENT_MANAGER:RegisterForEvent(HowToColossus.name .. "Death", EVENT_UNIT_DEATH_STATE_CHANGED, HowToColossus.OnGroupDeath)
	EVENT_MANAGER:AddFilterForEvent(HowToColossus.name .. "Death", EVENT_UNIT_DEATH_STATE_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")

	EVENT_MANAGER:RegisterForUpdate(HowToColossus.name .. "Update", 900, HowToColossus.UpdateGeneral)

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