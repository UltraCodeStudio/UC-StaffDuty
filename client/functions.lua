
function SetClothing (appearance)
    local ped = PlayerPedId()
     for k, v in pairs(appearance.components or {}) do
        if v.component_id then
            SetPedComponentVariation(ped, v.component_id, v.drawable, v.texture, 0)
        end
    end
    for k, v in pairs(appearance.props or {}) do
        if v.prop_id then
            SetPedPropIndex(ped, v.prop_id, v.drawable, v.texture, false)
        end
    end
end

function RestoreAppearance (appearance)
    if not appearance then return end
    
   SetClothing(appearance)
end

function GetAppearance (entity)
    if not entity and not DoesEntityExist(entity) then return {} end
    local model = GetEntityModel(entity)
    local skinData = { model = model, components = {}, props = {} }
    for i = 0, 11 do
        table.insert(skinData.components,
            { component_id = i, drawable = GetPedDrawableVariation(entity, i), texture = GetPedTextureVariation(entity, i) })
    end
    for i = 0, 13 do
        table.insert(skinData.props,
            { prop_id = i, drawable = GetPedPropIndex(entity, i), texture = GetPedPropTextureIndex(entity, i) })
    end
    return skinData
end