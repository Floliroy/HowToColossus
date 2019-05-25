local LGPS = LibStub("LibGPS2")
local LMP = LibStub("LibMapPing")

HowToColossus = HowToColossus or {}
local HowToColossus = HowToColossus

local COLOSSUS = 1
local HORN = 2

local MAJOR_VULNE_ID = 122397
local MAJOR_FORCE_ID = 40225
local HORN_ID = 40224

local WROTHGAR_MAP_INDEX  = 27
local WROTHGAR_MAP_STEP_SIZE = 1.428571431461e-005

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

function HowToColossus.GetNextColossus(force)
	local ultPercent = 0
	local name = ""
	local playerTag = ""

	for key, value in pairs(HowToColossus.groupUltimates) do
		if not force or key ~= HowToColossus.playerTag then 
			if value.ultType == COLOSSUS and value.ultPercent >= 100 then
				return value.name, key

			elseif value.ultType == COLOSSUS and value.ultPercent > ultPercent then

				ultPercent = value.ultPercent
				name = value.name
				playerTag = key

			end
		end
	end

	return name, playerTag
end

function HowToColossus.GetInfoWithTag()
	if HowToColossus.groupUltimates[HowToColossus.playerTag] then 
		return 	HowToColossus.groupUltimates[HowToColossus.playerTag].name,
				HowToColossus.groupUltimates[HowToColossus.playerTag].ultType,
				HowToColossus.groupUltimates[HowToColossus.playerTag].ultPercent
	else
		return "", 0, 0
	end
end

function HowToColossus.GetUltimates()
    LGPS:PushCurrentMap()
	SetMapToMapListIndex(WROTHGAR_MAP_INDEX)

    if GetGroupSize() > 0 then
        for i = 1, GetGroupSize() do
            local x, y = LMP:GetMapPing(MAP_PIN_TYPE_PING, "group" .. i)
            local name = GetUnitDisplayName("group" .. i)

            if LMP:IsPositionOnMap(x, y) then --and name ~= GetUnitDisplayName("player") then
                local ultType = math.floor(x / WROTHGAR_MAP_STEP_SIZE)
                local ultPercent = math.floor(y / WROTHGAR_MAP_STEP_SIZE) + 1

                HowToColossus.groupUltimates["group" .. i] = {
                    name = name,
                    ultType = ultType,
                    ultPercent = ultPercent
                }
            end
        end
    end
    LGPS:PopCurrentMap()
end

function HowToColossus.SendUltimate(ultType, ultPercent)
    LMP:MutePing(MAP_PIN_TYPE_PING)

	LGPS:PushCurrentMap()
	SetMapToMapListIndex(WROTHGAR_MAP_INDEX)

    local x = ultType * WROTHGAR_MAP_STEP_SIZE
    local y = ultPercent * WROTHGAR_MAP_STEP_SIZE
	LMP:SetMapPing(MAP_PIN_TYPE_PING, MAP_TYPE_LOCATION_CENTERED, x, y)
	LGPS:PopCurrentMap()
end