local EQUIPSLOTS = _G.EQUIPSLOTS
local resolvefilepath = _G.resolvefilepath

AddWorldPostInit(function(w)
	local TheFrontEnd = _G.TheFrontEnd
	w.components.ambientsound:SetReverbPreset("woods")
    TheFrontEnd:GetSound():PlaySound("scary_mod/music/gamemusic", "gamemusic")
	w:PushEvent("overridecolourcube", resolvefilepath("images/colour_cubes/screecher_cc.tex"))
end)

AddPlayersPostInit(function(inst)
	inst:AddTag("camper")
	inst:SetStateGraph("SGcamperbeta7")
	
	inst.FlashlightEnt = function()
		return inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	end
end)

AddPlayersAfterInit(function(inst)
	if inst.components.skinner then
		inst.components.skinner:ClearAllClothing()
	end
	
	inst.AnimState:SetSkin(inst.prefab)
	inst.AnimState:SetBank("camper")
	inst.AnimState:SetBuild("camp_leader_build")
end)

AddPrefabPostInit("multiplayer_portal", function(inst)
	inst:DoTaskInTime(0, inst.Remove)
end)