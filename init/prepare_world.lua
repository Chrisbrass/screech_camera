local resolvefilepath = _G.resolvefilepath

AddPrefabPostInit("multiplayer_portal", function(inst)
	inst:DoTaskInTime(0, inst.Remove)
end)