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
HowToColossus.playerTag = " "
HowToColossus.targetTag = " "

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

	if HowToColossus.shareColossus then
		local ultPercent = HowToColossus.GetUltimatePercent(COLOSSUS)
		HowToColossus.SendUltimate(COLOSSUS, ultPercent)

	elseif HowToColossus.shareHorn then
		local ultPercent = HowToColossus.GetUltimatePercent(HORN)
		HowToColossus.SendUltimate(HORN, ultPercent)
	end
end

function HowToColossus.GetTargetTag()
	local cpt = 0
	local targetTag = " "

	for i = 1, MAX_BOSSES do
		if DoesUnitExist("boss" .. i) then
			targetTag = "boss" .. i
			cpt = cpt + 1
		end
	end

	if cpt == 1 then
		return targetTag
	else
		return "notOneBoss"
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
	local name = " "
	local playerTag = " "

	for key, value in pairs(HowToColossus.groupUltimates) do

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
	d("OnGroupDeath: " .. unitTag)
	if HowToColossus.playerTag == unitTag and isDead then 
		HowToColossus.UpdateAlert()

	end
end

function HowToColossus.OnCombatState(eventCode, inCombat)
	local inCombat = inCombat or IsUnitInCombat("player") 
	
	if not inCombat then
		HowToColossus.UpdateNext()
		EVENT_MANAGER:UnregisterForUpdate(HowToColossus.name .. "Alert")
	else
        HowToColossus.targetTag = HowToColossus.GetTargetTag()
		EVENT_MANAGER:RegisterForUpdate(HowToColossus.name .. "Alert", 100, HowToColossus.UpdateAlert)
	end
end

--------------
---- Main ----
--------------
function HowToColossus.UpdateGeneral()
	HowToColossus.Share()
	--TODO HowToColossus.UpdatePannel()
end

function HowToColossus.UpdateNext()
	local playerName, playerTag = HowToColossus.GetNextColossus()
	HowToColossus.playerTag = playerTag
	HTCAlert_Name:SetHidden(false)
	HTCAlert_Timer:SetHidden(false)
	HTCAlert_Text:SetHidden(false)

	if playerName ~= " " then
		
		HTCAlert_Name:SetText(string.upper(playerName) .. "  NEXT")
		HTCAlert_Timer:SetText(" ")
	else
		HTCAlert_Name:SetHidden(true)
		HTCAlert_Timer:SetHidden(true)
		HTCAlert_Text:SetHidden(true)
	end
end

function HowToColossus.UpdateIn(majorVulne)	
	HTCAlert_Name:SetHidden(false)
	HTCAlert_Timer:SetHidden(false)
	HTCAlert_Text:SetHidden(false)

	if majorVulne <= 0 then
		HTCAlert_Timer:SetText("  ASAP")
	else
		HTCAlert_Timer:SetText("  IN  " .. majorVulne)
	end

	if majorVulne > 4.9 then
		local playerName, playerTag = HowToColossus.GetNextColossus()
		HowToColossus.playerTag = playerTag

		HTCAlert_Name:SetText(string.upper(playerName))

	end
end

function HowToColossus.UpdateAlert()
	local majorVulne = HowToColossus.GetMajorVulneOn(HowToColossus.targetTag)

	if HowToColossus.playerTag == " " or HowToColossus.targetTag == " "  or HowToColossus.targetTag == "notOneBoss" 
	or (HowToColossus.groupUltimates[HowToColossus.playerTag].ultPercent < 10 and majorVulne <= 0) then
		HowToColossus.UpdateNext()
	else
		HowToColossus.UpdateIn(majorVulne)
	end
end

function HowToColossus:Initialize()
	--Settings
	HowToColossus.CreateSettingsWindow()
	
	--Saved Variables
	HowToColossus.savedVariables = ZO_SavedVars:New("HowToColossusVariables", 1, nil, HowToColossus.Default)
	HowToColossus.GetSavedVariables()

	--UI
	HTCAlert_Name:SetHidden(true)
	HTCAlert_Timer:SetHidden(true)
	HTCAlert_Text:SetHidden(true)

	--Events Register HowToColossus.OnCombatState
	EVENT_MANAGER:RegisterForUpdate(HowToColossus.name .. "Update", 900, HowToColossus.UpdateGeneral)

	EVENT_MANAGER:RegisterForEvent(HowToColossus.name .. "Combat", EVENT_PLAYER_COMBAT_STATE, HowToColossus.OnCombatState)	
	EVENT_MANAGER:RegisterForEvent(HowToColossus.name .. "Death", EVENT_UNIT_DEATH_STATE_CHANGED, HowToColossus.OnGroupDeath)
	EVENT_MANAGER:AddFilterForEvent(HowToColossus.name .. "Death", EVENT_UNIT_DEATH_STATE_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")
	
	EVENT_MANAGER:RegisterForEvent(HowToColossus.name .. "Activate", EVENT_PLAYER_ACTIVATED, HowToColossus.UpdateNext)
	EVENT_MANAGER:RegisterForEvent(HowToColossus.name .. "Join", EVENT_GROUP_MEMBER_JOINED, HowToColossus.UpdateNext)
	EVENT_MANAGER:RegisterForEvent(HowToColossus.name .. "Left", EVENT_GROUP_MEMBER_LEFT, HowToColossus.UpdateNext)
	zo_callLater(function() HowToColossus.UpdateNext() end, 2000)

	EVENT_MANAGER:UnregisterForEvent(HowToColossus.name, EVENT_ADD_ON_LOADED)
	
end

function HowToColossus.SaveLoc()
	HowToColossus.savedVariables.OffsetX = HTCAlert:GetLeft()
	HowToColossus.savedVariables.OffsetY = HTCAlert:GetTop()
end	
 
function HowToColossus.OnAddOnLoaded(event, addonName)
	if addonName ~= HowToColossus.name then return end
		HowToColossus:Initialize()
end

EVENT_MANAGER:RegisterForEvent(HowToColossus.name, EVENT_ADD_ON_LOADED, HowToColossus.OnAddOnLoaded)