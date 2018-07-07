local function PlaySounds()
	local TheWorld = GLOBAL.TheWorld
	local TheFrontEnd = GLOBAL.TheFrontEnd
	TheWorld.components.ambientsound:SetReverbPreset("woods")
    TheFrontEnd:GetSound():PlaySound("scary_mod/music/gamemusic", "gamemusic")
    		
end
AddSimPostInit(PlaySounds)




AddPlayerPostInit(function(player)
	player:AddTag("camper")
	

	player:DoTaskInTime(.1, function()
		local defskin = player.prefab
		player.components.skinner:ClearAllClothing()
		player.AnimState:SetSkin(defskin)
	end)
	

	if player:HasTag("player") then
		player:DoTaskInTime(.3, function()
			player.AnimState:SetBuild("camp_leader_build")
		end)
		player.AnimState:SetBank("camper")
		player:SetStateGraph("SGcamperbeta3")
	end

end)




AddPrefabPostInit("multiplayer_portal", function(inst)
	inst:DoTaskInTime(0, inst.Remove)
end)