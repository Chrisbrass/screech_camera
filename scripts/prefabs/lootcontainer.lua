local assets =
{
	Asset("ANIM", "containeranim/bag.zip"), 
	Asset("ANIM", "containeranim/backpack1.zip"),
	Asset("ANIM", "containeranim/backpack2.zip"),
	Asset("ANIM", "containeranim/bedroll.zip"),
	Asset("ANIM", "containeranim/bedroll2.zip"),
	Asset("ANIM", "containeranim/cooler.zip"),
	Asset("ANIM", "containeranim/cooler_small.zip"),
	Asset("ANIM", "containeranim/footlocker.zip"), 
	Asset("ANIM", "containeranim/garbage.zip"), 
	Asset("ANIM", "containeranim/junkpile.zip"),
	Asset("ANIM", "containeranim/lunchbag.zip"),
	Asset("ANIM", "containeranim/jacket.zip"),
	Asset("ANIM", "containeranim/vest.zip"),
	Asset("ANIM", "containeranim/boots.zip"),
	Asset("ANIM", "containeranim/pack.zip"),
}


local function OnGetFlashlight(inst)
	if inst.components.highlight then
		inst.components.highlight:UnHighlight()
	end
	inst:RemoveTag("CLICK")
	inst.name = ""

	local player = ThePlayer

	local flashlight = SpawnPrefab("flashlight")
	player.components.inventory:Equip(flashlight)
	flashlight.components.flicker:ToggleFlashlight() --Make the flashlight off to start (to train toggle)

	player:ListenForEvent("flashlighton", function() player:PushEvent("flashlighton") end, player.FlashlightEnt())
	player:ListenForEvent("flashlighttoggleon", function() player:PushEvent("flashlighttoggleon") end, player.FlashlightEnt())
    player:ListenForEvent("flashlightoff", function() player:PushEvent("flashlightoff") end, player.FlashlightEnt())
    player:ListenForEvent("fuellow", function() player:PushEvent("fuellow") end, player.FlashlightEnt())
    player:ListenForEvent("fuelnotlow", function() player:PushEvent("fuelnotlow") end, player.FlashlightEnt())
    inst.AnimState:SetMultColour(0.2,0.2,0.2,1)

    if player.savedbatteries ~= nil then
    	local flashlight = c_find("flashlight")
    	flashlight.components.lightfueldimmer:AddFuel(4000)
    end

end


local function OnActivate(inst)
	if inst.components.highlight then
		inst.components.highlight:UnHighlight()
	end
	inst:RemoveTag("CLICK")
	inst.name = ""

	local player = ThePlayer
	local flashlight_ent = player.FlashlightEnt()
	if player and flashlight_ent then
		local encountermgr = player.components.scarymodencountermanager
		local adjustedlootdrop = encountermgr:GetLootDrop(flashlight_ent.components.lightfueldimmer.fuellevel/TUNING.MAX_FUEL_LEVEL)
		if adjustedlootdrop == 0 then
			-- Battery
			local batteryamount = encountermgr:GetBatteryAmount(flashlight_ent.components.lightfueldimmer.fuellevel/TUNING.MAX_FUEL_LEVEL)
			if flashlight_ent then
				inst.SoundEmitter:PlaySound("scary_mod/stuff/battery_pickup")
				flashlight_ent.components.lightfueldimmer:AddFuel(batteryamount)
				-- Dip the fuel consumption rate imperceptibly and briefly so that the HUD pulses
				flashlight_ent.components.lightfueldimmer:ModifyFuelConsumptionRate(0.99, 0.75)
				--player.HUD.note:DisplayImage("images/hud/battery.xml", "battery.tex", {imagetype="batteries"})
				local rand = 0
				while not player.pickedline do
					rand = math.random()
					if rand < 0.25 and player.lastbatterydialog ~= 1 then
						player.components.talker:Say("Found a battery.", 2.5, false)
						player.lastbatterydialog = 1
						player.pickedline = true
					elseif rand < 0.5 and player.lastbatterydialog ~= 2 then
						player.components.talker:Say("A pack of batteries. Nice.", 2.5, false)
						player.lastbatterydialog = 2
						player.pickedline = true
					elseif rand < 0.75 and player.lastbatterydialog ~= 3 then
						player.components.talker:Say("One battery left in here.", 2.5, false)
						player.lastbatterydialog = 3
						player.pickedline = true
					elseif player.lastbatterydialog ~= 4 then
						player.components.talker:Say("Jackpot. Batteries.", 2.5, false)
						player.lastbatterydialog = 4
						player.pickedline = true
					end
				end
				player.pickedline = false
			end
			-- Nothing
			local rand = 0
			while not player.pickedline do
				rand = math.random()
				if rand < 0.1 and player.lastnothingdialog ~= 1 then
					player.components.talker:Say("Empty.", 2.5, false)
					player.lastnothingdialog = 1
					player.pickedline = true
				elseif rand < 0.2 and player.lastnothingdialog ~= 2 then
					player.components.talker:Say("Just a bunch of trash.", 2.5, false)
					player.lastnothingdialog = 2
					player.pickedline = true
				elseif rand < 0.3 and player.lastnothingdialog ~= 3 then
					player.components.talker:Say("Nothing.", 2.5, false)
					player.lastnothingdialog = 3
					player.pickedline = true
				elseif rand < 0.4 and player.lastnothingdialog ~= 4 then
					player.components.talker:Say("Some tattered rags.", 2.5, false)
					player.lastnothingdialog = 4
					player.pickedline = true
				elseif rand < 0.5 and player.lastnothingdialog ~= 5 then
					player.components.talker:Say("Oh god, something's rotting in there.", 2.5, false)
					player.lastnothingdialog = 5
					player.pickedline = true
				elseif rand < 0.6 and player.lastnothingdialog ~= 6 then
					player.components.talker:Say("Somebody's clothes.", 2.5, false)
					player.lastnothingdialog = 6
					player.pickedline = true
				elseif rand < 0.7 and player.lastnothingdialog ~= 7 then
					player.components.talker:Say("Whatever it was, it's ripped to shreds.", 2.5, false)
					player.lastnothingdialog = 7
					player.pickedline = true
				elseif rand < 0.8 and player.lastnothingdialog ~= 8 then
					player.components.talker:Say("Nothing useful in here.", 2.5, false)
					player.lastnothingdialog = 8
					player.pickedline = true
				elseif rand < 0.9 and player.lastnothingdialog ~= 9 then
					player.components.talker:Say("Can't use any of this stuff.", 2.5, false)
					player.lastnothingdialog = 9
					player.pickedline = true
				elseif player.lastnothingdialog ~= 10 then
					player.components.talker:Say("Junk. All of it.", 2.5, false)
					player.lastnothingdialog = 10
					player.pickedline = true
				end
			end
			player.pickedline = false
		end
	end

	inst.AnimState:SetMultColour(0.2,0.2,0.2,1)
end

local function OnGetBatteries(inst)
	if inst.components.highlight then
		inst.components.highlight:UnHighlight()
	end
	inst:RemoveTag("CLICK")
	inst.name = ""

	local player = ThePlayer
	local flashlight_ent = player.FlashlightEnt()
	inst.SoundEmitter:PlaySound("scary_mod/stuff/battery_pickup")
	--player.HUD.note:DisplayImage("images/hud/battery.xml", "battery.tex", {imagetype="batteries"})
	

	if flashlight_ent then
		-- Dip the fuel consumption rate super briefly so that the HUD pulses
		flashlight_ent.components.lightfueldimmer:ModifyFuelConsumptionRate(0.99, 0.75)
		flashlight_ent.components.lightfueldimmer:AddFuel(3000)
		player.components.talker:Say("Perfect Batteries!.")
	end

	inst.AnimState:SetMultColour(0.2,0.2,0.2,1)
end

local containers = {
	duffel = {
		name = "Duffel Bag",
		bank = "bag",
		build = "bag",
	},
	backpack = {
		name = "Backpack",
		bank = "backpack1",
		build = "backpack1",
	},
	backpack2 = {
		name = "Backpack",
		bank = "backpack2",
		build = "backpack2",
	},
	bedroll = {
		name = "Bedroll",
		bank = "bedroll",
		build = "bedroll",
	},
	bedroll2 = {
		name = "Bedroll",
		bank = "bedroll2",
		build = "bedroll2",
	},
	cooler = {
		name = "Cooler",
		bank = "cooler",
		build = "cooler",
	},
	cooler_small = {
		name = "Cooler",
		bank = "cooler_small",
		build = "cooler_small",
	},
	footlocker = {
		name = "Footlocker",
		bank = "footlocker",
		build = "footlocker",
	},
	garbage = {
		name = "Garbage Bag",
		bank = "garbage",
		build = "garbage",
	},
	junkpile = {
		name = "Pile of Garbage",
		bank = "junkpile",
		build = "junkpile",
	},
	-- Not a container
	--tent = {
		--name = "Tent",
		--bank = "tent",
		--build = "tent",
	--},
	vest = {
		name = "Vest",
		bank = "vest2",
		build = "vest",
	},
	jacket = {
		name = "Jacket",
		bank = "jacket",
		build = "jacket",
	},
	pack = {
		name = "Fanny Pack",
		bank = "pack",
		build = "pack",
	},
	boots = {
		name = "Boots",
		bank = "boots",
		build = "boots",
	},
}

local function create_lootcontainer(Sim, id)
	local inst = CreateEntity()

	inst:AddTag("CLICK")

	inst.entity:AddTransform()

	--We'll want to randomize the sprite on this at some point
	inst.entity:AddAnimState()

	inst:ListenForEvent("removelootname", function(it, data) 
		if data.loot == inst then
			inst.name = ""
		end
	end, ThePlayer)

	local kind = id and containers[id] or GetRandomItem(containers)
	inst.AnimState:SetBank(kind.bank)
	inst.AnimState:SetBuild(kind.build)
	inst.name = kind.name

	inst.AnimState:PlayAnimation("idle")

	inst.entity:AddSoundEmitter()
		
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(2.5, 2.0)	

	inst:AddComponent("activatable")
	inst.components.activatable.distance = nil
	inst.components.activatable.OnActivate = OnActivate
	inst.components.activatable.inactive = true
	inst.components.activatable.quickaction = false
	inst:AddComponent("highlight")

	if TUNING.IS_FPS then
		inst.Transform:SetScale(1.2,1.2,1.2)
	end

	return inst
end

local function LootContainer(id)
	local function fn(Sim)
		local inst = create_lootcontainer(Sim, id)
		return inst
	end
	return fn
end
local function create_flashlightloot(Sim)
	local inst = create_lootcontainer(Sim)
	inst.AnimState:SetBank("footlocker")
    inst.AnimState:SetBuild("footlocker")
	inst.name = "Box"

    inst.components.activatable.OnActivate = OnGetFlashlight

    return inst
end

local function create_batteries(Sim)
	local inst = create_lootcontainer(Sim)
	inst.AnimState:SetBank("bag")
    inst.AnimState:SetBuild("bag")
	inst.name = "Duffel Bag"

    inst.components.activatable.OnActivate = OnGetBatteries

    return inst
end


local prefabs = {
	Prefab("common/lootcontainer", create_lootcontainer, assets, nil),
	Prefab("common/batteries", create_batteries, assets, nil),
	Prefab("common/flashlightloot", create_flashlightloot, assets, nil)
}
-- Add a specific prefab for every loot graphic
for k,v in pairs(containers) do
	table.insert(prefabs, Prefab("lootcontainer_"..k, LootContainer(k), assets))
end

return unpack(prefabs)
