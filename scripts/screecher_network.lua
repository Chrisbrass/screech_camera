local resolvefilepath = _G.resolvefilepath

local function OnRedCC(inst)
	if inst._parent == nil then
		return
	end
	
	local player = inst._parent
	local w = _G.TheWorld
	
	if inst.screecher_red_cc:value() then
		w:PushEvent("overridecolourcube", resolvefilepath("images/colour_cubes/screecher_cc_red_cc.tex"))
	else
		w:PushEvent("overridecolourcube", resolvefilepath("images/colour_cubes/screecher_cc.tex"))
	end
end

AddPrefabPostInit("player_classified",function(inst)
	inst.screecher_red_cc = _G.net_bool(inst.GUID, "screecher.red_cc", "RedCCDirty") --ThePlayer.player_classified.screecher_red_cc:set(true)
	
	if not TheNet:IsDedicated() then --Client or local host
		inst:ListenForEvent("RedCCDirty", OnRedCC)
	end
end)
