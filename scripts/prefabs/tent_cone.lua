local assets=
{
	Asset("ANIM", "anim/tent_cone.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tent_cone")
    inst.AnimState:SetBuild("tent_cone")
    inst.AnimState:PlayAnimation("idle")
    
    return inst
end

return Prefab( "common/inventory/tent_cone", fn, assets) 

