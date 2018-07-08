local EQUIPSLOTS = _G.EQUIPSLOTS


AddPlayersPostInit(function(inst)
	inst:AddTag("camper")
	inst:SetStateGraph("SGcamperbeta")
	
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