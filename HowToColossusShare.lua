local LGPS = LibStub("LibGPS2")
local LMP = LibStub("LibMapPing")
LMP:MutePing(MAP_PIN_TYPE_PING)

HowToColossus = HowToColossus or {}
local HowToColossus = HowToColossus

local WROTHGAR_MAP_INDEX  = 27
local WROTHGAR_MAP_STEP_SIZE = 1.428571431461e-005

function HowToColossus.GetUltimates()
    LGPS:PushCurrentMap()
	SetMapToMapListIndex(WROTHGAR_MAP_INDEX)

    if GetGroupSize() > 0 then
        for i = 1, GetGroupSize() do
            local x, y = LMP:GetMapPing(MAP_PIN_TYPE_PING, "group" .. i)
            local name = GetUnitDisplayName("group" .. i)

            if LMP:IsPositionOnMap(x, y) then --and name ~= GetUnitDisplayName("player") then
                local ultType = math.floor(x / WROTHGAR_MAP_STEP_SIZE)
                local ultPercent = math.floor(y / WROTHGAR_MAP_STEP_SIZE)

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
	LGPS:PushCurrentMap()
	SetMapToMapListIndex(WROTHGAR_MAP_INDEX)

    --HowToColossus.groupUltimates["group0"] = {
    --   name = GetUnitDisplayName("player"),
    --    ultType = ultType,
    --    ultPercent = ultPercent
    --}

    local x = ultType * WROTHGAR_MAP_STEP_SIZE
    local y = ultPercent * WROTHGAR_MAP_STEP_SIZE
	LMP:SetMapPing(MAP_PIN_TYPE_PING, MAP_TYPE_LOCATION_CENTERED, x, y)
	LGPS:PopCurrentMap()
end