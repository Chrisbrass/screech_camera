modimport("scripts/libs/lib_ver.lua")




-- Set up some tuning values which will be used be our custom creatures and
-- components.
modimport("load_all")
print("Everything Loaded Succesfuly!")

if SERVER_SIDE then --Server only
	modimport("init/prepare_player_world.lua")
end

--This one must be set on the client AND server
AddWorldPostInit(function(w)
    w:PushEvent("overrideambientlighting", _G.Point(0, 0, 0))
end)

if not DEDICATED_SIDE then --Dedicated servers don't need to add this component
	AddPlayersPostInit(function(isnt)
		if not inst.components.characterbreathing then
			isnt:AddComponent("characterbreathing")
		end
	end
end

modimport("scripts/screecher_network.lua")

local TUNING = _G.TUNING

AddComponentPostInit("sanity", function(self)
	local easing = require("easing")
	
	function self:OnUpdate(dt)
		local speed = easing.outQuad( 1 - self:GetPercent(), 0, .2, 1) 
		self.fxtime = self.fxtime + dt*speed
		
		_G.PostProcessor:SetEffectTime(self.fxtime)
		
		local distortion_value = easing.inQuad( self:GetPercent(), 0, 1, 1) 
		--local colour_value = 1 - easing.outQuad( self:GetPercent(), 0, 1, 1) 
		--PostProcessor:SetColourCubeLerp( 1, colour_value )
		_G.PostProcessor:SetDistortionFactor(distortion_value)
		_G.PostProcessor:SetDistortionRadii( 0.5, 0.685 )

		if self.inst.components.health.invincible == true or self.inst.is_teleporting == true then
			return
		end
		
		self:Recalc(dt)	
	end
end)

require("debugkeys")
require("consolecommands")
_G.AddGameDebugKey(_G.KEY_F, function(down)
	local player = _G.ThePlayer
	local flashlight_ent = player.FlashlightEnt()
	if flashlight_ent == nil then
		flashlight_ent = SpawnPrefab("flashlight")
		player.components.inventory:Equip(flashlight_ent)
		player:ListenForEvent("flashlighton", function() player:PushEvent("flashlighton") end, player.FlashlightEnt())
		player:ListenForEvent("flashlightoff", function() player:PushEvent("flashlightoff") end, player.FlashlightEnt())
		player:ListenForEvent("fuellow", function() player:PushEvent("fuellow") end, player.FlashlightEnt())
		player:ListenForEvent("fuelnotlow", function() player:PushEvent("fuelnotlow") end, player.FlashlightEnt())
		flashlight_ent.components.flicker:ToggleFlashlight()
		flashlight_ent.components.flicker:ToggleFlashlight()
	end
	flashlight_ent.components.lightfueldimmer:AddFuel(10000)
	--_G.c_select(flashlight_ent)
end)

local function toggle_flashlight(act)
	if act.target.flashlightt == nil then
		act.target.flashlightt = true
		act.target.components.flicker:ToggleFlashlight()
	elseif act.target.flashlightt == true then
		act.target.flashlightt = nil
		act.target.components.flicker:ToggleFlashlight()
	end
end


local FLASHLIGHT = _G.Action()
FLASHLIGHT.str = "Flashlight"
FLASHLIGHT.id = "FLASHLIGHT"
FLASHLIGHT.fn = function(act)
	toggle_flashlightt(act)
end

AddAction(FLASHLIGHT)

-- Add the action and action handler for toggling the flashlight
local Action = _G.Action
local ActionHandler = _G.ActionHandler

local toggleflashlightact = Action(4, true, true)
toggleflashlightact.str = "Toggle Flashlight"
toggleflashlightact.id = "TOGGLEFLASHLIGHT"
toggleflashlightact.fn = function(act)
    local flashlight = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if flashlight and flashlight.components.flicker then
        flashlight.components.flicker:ToggleFlashlight()
        return true
    end
end

AddAction(toggleflashlightact)
AddStategraphActionHandler("camperbeta", ActionHandler(toggleflashlightact, "doflashlighttoggle"))

-- Rename the stinger played on "goinsane" to null. Throws an FMOD error in log
-- But it prevents the stinger from playing.  Hacky, but works...
RemapSoundEvent("dontstarve/sanity/gonecrazy_stinger", "")


