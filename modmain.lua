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


local function toggle_flashlight(act)
	if act.target.flashlightt == nil then
		act.target.flashlightt = true
		act.target.components.flicker:ToggleFlashlight()
	elseif act.target.flashlightt == true then
		act.target.flashlightt = nil
		act.target.components.flicker:ToggleFlashlight()
	end
end

local function PlaySounds()
	local TheWorld = GLOBAL.TheWorld
	local TheFrontEnd = GLOBAL.TheFrontEnd
	TheWorld.components.ambientsound:SetReverbPreset("woods")
    TheFrontEnd:GetSound():PlaySound("scary_mod/music/gamemusic", "gamemusic")
    		
end
AddSimPostInit(PlaySounds)

AddPlayerPostInit(function(player)
	player:AddTag("camper")
	player.AnimState:SetBuild("camp_leader_build")
    player.AnimState:SetBank("camper")
    player:SetStateGraph("SGcamperbeta3") 
end)





local FLASHLIGHT = GLOBAL.Action()
FLASHLIGHT.str = "Flashlight"
FLASHLIGHT.id = "FLASHLIGHT"
FLASHLIGHT.fn = function(act)
	toggle_flashlightt(act)
end
AddAction(FLASHLIGHT)

GLOBAL.TUNING.MIN_TIME_BETWEEN_FLICKER = 20
GLOBAL.TUNING.MAX_TIME_BETWEEN_FLICKER = 30
GLOBAL.TUNING.MIN_FLICKER_DURATION = 0.5
GLOBAL.TUNING.MAX_FLICKER_DURATION = 2.5
GLOBAL.TUNING.OFF_SUBFLICKER_TICKS = 6
GLOBAL.TUNING.ON_SUBFLICKER_TICKS = 1
GLOBAL.TUNING.FLICKER_DIM_AMOUNT = 0.5
GLOBAL.TUNING.MIN_REASONABLE_FUEL = 0.12
GLOBAL.TUNING.MIN_REASONABLE_BRIGHTNESS = 0.45
GLOBAL.TUNING.LOW_FUEL_LEVEL = 100 --This is the value at which we start to consider the player to be in darkness while flashlight is on
GLOBAL.TUNING.STARTING_FUEL_LEVEL = 3000 --How much fuel is in the battery the player starts with
GLOBAL.TUNING.MAX_FUEL_LEVEL = 10000 --this is also how many tic

GLOBAL.TUNING.SEARCH_CONTAINER_DURATION = 1.5

GLOBAL.TUNING.MOUSE_SENSITIVITY = 0.15 --Was originally 1.5
GLOBAL.TUNING.PITCH_ADJUSTMENT_MULTIPLIER = 5

GLOBAL.TUNING.PITCH_ADDITIONAL_OFFSET = 0.2


GLOBAL.TUNING.BLOOD_OVERLAY_VALUE_FOR_DEATH = 7.5
GLOBAL.TUNING.DARKNESS_STALKTIME = 4.5
GLOBAL.TUNING.DARKNESS_STALKTIME2 = 5

GLOBAL.TUNING.IS_FPS = false
if GLOBAL.TUNING.IS_FPS then
	GLOBAL.TUNING.DEFAULT_CAM_DISTANCE = 8
	GLOBAL.TUNING.ZOOMED_CAM_DISTANCE = 8
	GLOBAL.TUNING.CAMERAY_OFFSET = 4.5
end

GLOBAL.TUNING.SANITYAURA_MONSTER = 50
GLOBAL.TUNING.DAPPERNESS_FREE = 2


AddComponentPostInit("sanity", function(component)

	GLOBAL.require("mathutil")


	--component.debugger = component.inst.entity:AddDebugRender()

	function component:Recalc(dt)
		local total_dapperness = self.dapperness or 0
		local mitigates_rain = false
		for k,v in pairs (self.inst.components.inventory.equipslots) do
			if v.components.dapperness then
				total_dapperness = total_dapperness + v.components.dapperness:GetDapperness(self.inst)
			end		
		end
		local dapper_delta = total_dapperness*GLOBAL.TUNING.SANITY_DAPPERNESS

		local aura_delta = 0
		local x,y,z = self.inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z, GLOBAL.TUNING.SANITY_EFFECT_RANGE)
--component.debugger:Flush()
		for k,v in pairs(ents) do 
			if v.components.sanityaura and v ~= self.inst and not v:IsInLimbo() then
				local dist = math.sqrt(self.inst:GetDistanceSqToInst(v))
				local aura_pct = GLOBAL.Lerp(0, 1, (GLOBAL.TUNING.SANITY_EFFECT_RANGE-dist)/GLOBAL.TUNING.SANITY_EFFECT_RANGE)
				local aura_val = aura_pct * v.components.sanityaura:GetAura(self.inst)
				if aura_val < 0 then
					aura_val = aura_val * self.neg_aura_mult
				end

				local p2 = v:GetPosition()
--component.debugger:Line(x, z, p2.x, p2.z, aura_pct, 1-aura_pct, 0, 1)
--component.debugger:String(aura_val, p2.x, p2.z, 0.5)

				aura_delta = aura_delta + aura_val
			end
		end

		--if delta < 0 then
			--if delta*dt < TUNING.SANITY_DECAY_RATE*dt then
				--self:DoDelta(TUNING.SANITY_DECAY_RATE*dt, true)
			--else
				--self:DoDelta(delta*dt, true)
			--end
		--elseif delta > 0 then
			--if delta*dt > TUNING.SANITY_RESTORE_RATE*dt then
				--self:DoDelta(TUNING.SANITY_RESTORE_RATE*dt, true)
			--else
				--self:DoDelta(delta*dt, true)
			--end
		--end

		self.rate = (dapper_delta + aura_delta)

		--print (string.format("dapper: %2.2f light: %2.2f TOTAL: %2.2f", dapper_delta, light_delta, self.rate*dt))
		self:DoDelta(self.rate*dt, true)
	end

	local easing = GLOBAL.require("easing")
	
	function component:OnUpdate(dt)
		
		local speed = easing.outQuad( 1 - self:GetPercent(), 0, .2, 1) 
		self.fxtime = self.fxtime + dt*speed
		
		GLOBAL.PostProcessor:SetEffectTime(self.fxtime)
		
		local distortion_value = easing.inQuad( self:GetPercent(), 0, 1, 1) 
		--local colour_value = 1 - easing.outQuad( self:GetPercent(), 0, 1, 1) 
		--PostProcessor:SetColourCubeLerp( 1, colour_value )
		GLOBAL.PostProcessor:SetDistortionFactor(distortion_value)
		GLOBAL.PostProcessor:SetDistortionRadii( 0.5, 0.685 )

		if self.inst.components.health.invincible == true or self.inst.is_teleporting == true then
			return
		end
		
		self:Recalc(dt)	
	end
end)



GLOBAL.require("debugkeys")
GLOBAL.require("consolecommands")
GLOBAL.AddGameDebugKey(GLOBAL.KEY_F, function(down)
	local player = GLOBAL.GetPlayer()
	local flashlight_ent = player.FlashlightEnt()
	if flashlight_ent == nil then
		flashlight_ent = GLOBAL.SpawnPrefab("flashlight")
		player.components.inventory:Equip(flashlight_ent)
		player:ListenForEvent("flashlighton", function() player:PushEvent("flashlighton") end, player.FlashlightEnt())
		player:ListenForEvent("flashlightoff", function() player:PushEvent("flashlightoff") end, player.FlashlightEnt())
		player:ListenForEvent("fuellow", function() player:PushEvent("fuellow") end, player.FlashlightEnt())
		player:ListenForEvent("fuelnotlow", function() player:PushEvent("fuelnotlow") end, player.FlashlightEnt())
		flashlight_ent.components.flicker:ToggleFlashlight()
		flashlight_ent.components.flicker:ToggleFlashlight()
	end
	flashlight_ent.components.lightfueldimmer:AddFuel(10000)
	--GLOBAL.c_select(flashlight_ent)
end)


-- Add the action and action handler for toggling the flashlight
local Action = GLOBAL.Action
local ActionHandler = GLOBAL.ActionHandler
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
AddStategraphActionHandler("camperbeta", GLOBAL.ActionHandler(toggleflashlightact, "doflashlighttoggle"))



