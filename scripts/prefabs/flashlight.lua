local assets =
{
	Asset("ANIM", "anim/torch.zip"),
	Asset("ANIM", "anim/swap_torch.zip"),
	Asset("SOUND", "sound/common.fsb"),
    Asset("ATLAS", "images/inventoryimages/flashlight.xml"),
    Asset("IMAGE", "images/inventoryimages/flashlight.tex"),
}
 
local prefabs =
{
    "flashlight_lightpiece",
    --"flashlight_particles",
}    

local function OnKeyPressed(inst, data)
    if data.inst == ThePlayer then
  
        if data.inst.HUD and (data.inst.HUD:IsChatInputScreenOpen() or data.inst.HUD:IsConsoleScreenOpen()) then return end -- If player's in console or chat then don't preform actions!
    
            if data.key == KEY_F then
                if TheWorld.ismastersim then
                    BufferedAction(inst, inst, ACTIONS.FLASHLIGHT):Do()
                else
                    SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.FLASHLIGHT.code, inst, ACTIONS.FLASHLIGHT.mod_name)
                end
                
            end
    end
end



local function onequip(inst, owner) 
    
    local light1 = SpawnPrefab("flashlight_lightpiece")
    light1.Light:SetRadius(0.5)
    local light15 = SpawnPrefab("flashlight_lightpiece")
    light15.Light:SetRadius(0.6)
    local light2 = SpawnPrefab("flashlight_lightpiece")
    light2.Light:SetRadius(0.75)
    local light25 = SpawnPrefab("flashlight_lightpiece")
    light25.Light:SetRadius(0.9)
    local light3 = SpawnPrefab("flashlight_lightpiece")
    light3.Light:SetRadius(1.10)
    local light35 = SpawnPrefab("flashlight_lightpiece")
    light35.Light:SetRadius(1.30)
    local light4 = SpawnPrefab("flashlight_lightpiece")
    light4.Light:SetRadius(1.55)
    local light45 = SpawnPrefab("flashlight_lightpiece")
    light45.Light:SetRadius(1.9)
    local light5 = SpawnPrefab("flashlight_lightpiece")
    light5.Light:SetRadius(2.2)

    ---[[
    local light6 = SpawnPrefab("flashlight_lightpiece")
    light6.Light:SetRadius(0.5)
    light6.Light:SetIntensity(0.5)
    local light7 = SpawnPrefab("flashlight_lightpiece")
    light7.Light:SetRadius(0.5)
    light7.Light:SetIntensity(0.5)
    local light8 = SpawnPrefab("flashlight_lightpiece")
    light7.Light:SetRadius(0.5)
    light7.Light:SetIntensity(0.5)
    ---]]
    --local light8 = SpawnPrefab("flashlight_lightpiece")
    --light8.Light:SetRadius(0.5)

    local lights = { light1, light15, light2, light25, light3, light35, light4, light45, light5, light6, light7, light8 }

    inst:AddComponent("flicker")
    inst:AddComponent("lightfueldimmer")
    inst:AddComponent("lightbeam")
    inst.components.flicker:ToggleFlashlight()
    for i, v in ipairs(lights) do
        --Add the flicker component and give it knowledge of the lights
        inst.components.flicker:AddLight(v)    

        --Add the lightfueldimmer component and give it knowledge of the lights
        inst.components.lightfueldimmer:AddLight(v)

        --Give the lightbeam component knowledge of the lights
        inst.components.lightbeam:AddLight(v)
    end

    inst.components.flicker.normalintensity = 1
    inst.components.lightfueldimmer:SetMaxColour({197/255,197/255,50/255})
end



local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()

    -- Use torch anims for now
    anim:SetBank("torch")
    anim:SetBuild("torch")
    anim:PlayAnimation("idle")
    MakeInventoryPhysics(inst)
    
    -----------------------------------
    --inst:AddComponent("lighter")
    -----------------------------------
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/flashlight.xml"
    -----------------------------------
    inst:AddComponent("equippable")


    inst.components.equippable:SetOnEquip( onequip )
    -----------------------------------  
    inst:AddComponent("inspectable")    
    -----------------------------------
    inst:AddComponent("heater")
    inst.components.heater.equippedheat = 5
  -- inst.components.fueled:SetDepletedFn(function(inst) inst:Remove() end)
    
    return inst
end

return Prefab( "common/inventory/flashlight", fn, assets, prefabs) 
