local assets=
{
	Asset("ANIM", "anim/generator.zip"),
}

local LIGHT_FRAMES = 
{
    0,3,5,11
}

local LIGHT_FRAMES_START = 
{
    0,3
}


local function OnActivate(inst)
    if inst.num_generator_pulls < 3 then          
        inst:DoTaskInTime(1.7, function()
            inst.components.activatable.inactive = true
        end)
    else
        inst:RemoveTag("CLICK")

        for k, v in ipairs(LIGHT_FRAMES_START) do
            inst:DoTaskInTime(v*FRAMES, function()
                inst.Light:SetIntensity(0.2)
            end)
            inst:DoTaskInTime(v*FRAMES+1*FRAMES, function()
                inst.Light:SetIntensity(0.175)
            end)
            inst:DoTaskInTime(v*FRAMES+2*FRAMES, function()
                inst.Light:SetIntensity(0.1)
            end)
        end

        inst:DoTaskInTime(7*FRAMES, function()
            inst.Light:SetIntensity(0.2)
        end)

    end
    if inst.num_generator_pulls == 3 then
        inst.num_generator_pulls = -1
        inst.components.activatable.inactive = true
    end
    if inst.num_generator_pulls == 0 then
        inst.SoundEmitter:KillSound("generatorloop")
        for k,beacon in pairs(Ents) do if beacon:HasTag("beacon") then beacon.AnimState:SetBloomEffectHandle( "" ) end end
    end


    local player = ThePlayer


    
    inst.components.activatable.inactive = true

    player:PushEvent("generator_pull", {num_generator_pulls=inst.num_generator_pulls})
end


local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("generator")
    inst.AnimState:SetBuild("generator")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddTag("CLICK")
    inst:AddTag("generator")
    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.inactive = true
    inst.components.activatable.quickaction = false
    inst.components.activatable.distance = 1

    local light = inst.entity:AddLight()
    light:SetFalloff(0.7)
    light:SetIntensity(0)
    light:SetRadius(1)
    light:SetColour(237/255, 237/255, 209/255)
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )


    inst.num_generator_pulls = 0


    inst:ListenForEvent("pullinggeneratorcord", function(it)
        inst.num_generator_pulls = inst.num_generator_pulls + 1

        if inst.num_generator_pulls < 3 then
            inst.SoundEmitter:PlaySound("scary_mod/stuff/genny_falsestart")
            inst.AnimState:PlayAnimation("rev")

            for k, v in ipairs(LIGHT_FRAMES) do
                inst:DoTaskInTime(v*FRAMES, function()
                    inst.Light:SetIntensity(0.2)
                    for k,beacon in pairs(Ents) do if beacon:HasTag("beacon") then beacon:PushEvent("onbeacontemplit") end end
                end)
                inst:DoTaskInTime(v*FRAMES+1*FRAMES, function()
                    inst.Light:SetIntensity(0.175)
                    for k,beacon in pairs(Ents) do if beacon:HasTag("beacon") then beacon:PushEvent("onbeacontemplit") end end
                end)
                inst:DoTaskInTime(v*FRAMES+2*FRAMES, function()
                    inst.Light:SetIntensity(0.1)
                    for k,beacon in pairs(Ents) do if beacon:HasTag("beacon") then beacon:PushEvent("onbeacontemplit") end end
                end)
                inst:DoTaskInTime(v*FRAMES+3*FRAMES, function()
                    inst.Light:SetIntensity(0.05)
                    for k,beacon in pairs(Ents) do if beacon:HasTag("beacon") then beacon:PushEvent("onbeacontemplit") end end
                end)
                inst:DoTaskInTime(v*FRAMES+4*FRAMES, function()
                    inst.Light:SetIntensity(0)
                    for k,beacon in pairs(Ents) do if beacon:HasTag("beacon") then beacon:PushEvent("onbeacontemplit") end end
                end)
            end
        else
            --start it up!
            inst.SoundEmitter:PlaySound("scary_mod/stuff/genny_LP", "generatorloop")
            inst.AnimState:PlayAnimation("rev_on", false)
            inst.AnimState:PushAnimation("on_loop", true)
            local beacon = TheSim:FindFirstEntityWithTag("beacon")
            for k,beacon in pairs(Ents) do if beacon:HasTag("beacon") then beacon:PushEvent("onbeaconlit") end end
        end
    end, ThePlayer)

    return inst
end

return Prefab( "generator", fn, assets)
