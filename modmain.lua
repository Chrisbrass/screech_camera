modimport("scripts/libs/lib_ver.lua")

PrefabFiles = {
	-- The basic monster wandering the island. It loves to eat campers.
	

	"flashlight_lightpiece",

	"flashlight_particles",

	"lootcontainer",

	"flashlight",

	"generator",

	"firepit",

	"log_chunk",

	"tent_cone",

	"ground_grass",

	"helicopter_beacon",


}

Assets =
{
	Asset("SOUNDPACKAGE", "sound/scary_mod.fev"),
	Asset("SOUND", "sound/scary_mod.fsb"),  

	-- Note textures
	--[[Asset("IMAGE", "images/hud/note1.tex"),
	Asset("ATLAS", "images/hud/note1.xml"),
	Asset("IMAGE", "images/hud/note2.tex"),
	Asset("ATLAS", "images/hud/note2.xml"),
	Asset("IMAGE", "images/hud/note3.tex"),
	Asset("ATLAS", "images/hud/note3.xml"),
	Asset("IMAGE", "images/hud/note4.tex"),
	Asset("ATLAS", "images/hud/note4.xml"),
	Asset("IMAGE", "images/hud/note5.tex"),
	Asset("ATLAS", "images/hud/note5.xml"),
	Asset("IMAGE", "images/hud/note9.tex"),
	Asset("ATLAS", "images/hud/note9.xml"),

	Asset("IMAGE", "images/hud/note_flashlight.tex"),
	Asset("ATLAS", "images/hud/note_flashlight.xml"),
	Asset("IMAGE", "images/hud/note_helicopter.tex"),
	Asset("ATLAS", "images/hud/note_helicopter.xml"),
	Asset("IMAGE", "images/hud/note_frequency.tex"),
	Asset("ATLAS", "images/hud/note_frequency.xml"),

	Asset("IMAGE", "images/hud/note_Jan09.tex"),
	Asset("ATLAS", "images/hud/note_Jan09.xml"),
	Asset("IMAGE", "images/hud/note_Jan12.tex"),
	Asset("ATLAS", "images/hud/note_Jan12.xml"),
	Asset("IMAGE", "images/hud/note_Jan14.tex"),
	Asset("ATLAS", "images/hud/note_Jan14.xml"),

	Asset("IMAGE", "images/hud/faceless.tex"),
	Asset("ATLAS", "images/hud/faceless.xml"),
	Asset("IMAGE", "images/hud/owl_face_1.tex"),
	Asset("ATLAS", "images/hud/owl_face_1.xml"),
	Asset("IMAGE", "images/hud/owl_face_2.tex"),
	Asset("ATLAS", "images/hud/owl_face_2.xml"),

	Asset("IMAGE", "images/hud/flashlight.tex"),
	Asset("ATLAS", "images/hud/flashlight.xml"),
	Asset("IMAGE", "images/hud/battery.tex"),
	Asset("ATLAS", "images/hud/battery.xml"),]]
	--Asset("IMAGE", "images/hud/map.tex"),
	--Asset("ATLAS", "images/hud/map.xml"),

	--[[Asset("IMAGE", "images/hud/youdied.tex"),
	Asset("ATLAS", "images/hud/youdied.xml"),
	Asset("IMAGE", "images/shadow1.tex"),
	Asset("IMAGE", "images/screecher_main_menu.tex"),
	Asset("ATLAS", "images/screecher_main_menu.xml"),
	Asset("IMAGE", "images/screecher_logo.tex"),
	Asset("ATLAS", "images/screecher_logo.xml"),]]

	--[[Asset("IMAGE", "colour_cubes/screecher_cc.tex"),
	Asset("IMAGE", "colour_cubes/screecher_cc_red_cc.tex"),]]

	Asset("IMAGE", "images/leader.tex"),
	Asset("ATLAS", "images/leader.xml"),
	--Asset("IMAGE", "images/helipad.tex"),
	--Asset("ATLAS", "images/helipad.xml"),
	Asset("ANIM", "anim/camp_leader_basic.zip"),
    Asset("ANIM", "anim/camp_leader_build.zip"),
    Asset("ANIM", "anim/camp_leader.zip"),

}
-- Set up some tuning values which will be used be our custom creatures and
-- components.
modimport("init/tuning.lua")

if SERVER_SIDE then --Server only
	modimport("init/prepare_player_world.lua")
end

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



