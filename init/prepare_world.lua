local resolvefilepath = _G.resolvefilepath

AddWorldPostInit(function(w)
	local TheFrontEnd = _G.TheFrontEnd
	w.components.ambientsound:SetReverbPreset("woods")
    TheFrontEnd:GetSound():PlaySound("scary_mod/music/gamemusic", "gamemusic")
	w:PushEvent("overridecolourcube", resolvefilepath("images/colour_cubes/screecher_cc.tex"))
end)


AddPrefabPostInit("multiplayer_portal", function(inst)
	inst:DoTaskInTime(0, inst.Remove)
end)