---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by MSI.
--- DateTime: 14.07.2022 22:54
---
do


    DAMAGE_TYPE_STANDARD = 1
    DAMAGE_TYPE_EXPLOSIVE = 2
    DAMAGE_TYPE_CONCUSSION = 3

    OrderInterceptionTrigger = 0



    ---@param source unit
    ---@param target unit
    ---@param amount real
    ---@param damage_type number
    function DamageUnit(source, target, amount, damage_type)
        local attacker = GetUnitData(source)
        local victim = GetUnitData(target)
        local damage = amount

            if attacker == nil then print("Warning: " .. GetUnitName(source) .. " doesn't have unit data.") end
            if victim == nil then print("Warning: " .. GetUnitName(target) .. " doesn't have unit data.") end

            if target == nil then return 0 end

            if GetUnitState(target, UNIT_STATE_LIFE) <= 0.045 then
                return
            end

            local damage_table = { damage = damage, damage_type = damage_type or nil }

            damage_table = OnDamageStart(source, target, damage_table)

            damage_table.damage = damage
            damage_table.damage_type = damage_type

                if damage < 1 then damage = 1 end

                    damage_table.damage = damage
                    OnDamage_PreHit(source, target, damage, damage_table)
                    damage = damage_table.damage

                    if damage > 0  then
                        UnitDamageTarget(source, target, damage, true, false, ATTACK_TYPE_NORMAL, nil, nil)
                        OnDamage_End(source, target, damage, damage_table)
                    end



        return damage
    end



    function MainEngineInit()


        local attack_trigger = CreateTrigger()

        TriggerRegisterAnyUnitEventBJ(attack_trigger, EVENT_PLAYER_UNIT_ATTACKED)
        TriggerAddAction(attack_trigger, function()
            local unit_data = GetUnitData(GetAttacker())

                if unit_data and unit_data.weapon and unit_data.weapon.fire_sound then
                    AddSoundVolume(unit_data.weapon.fire_sound.pack[GetRandomInt(1, #unit_data.weapon.fire_sound.pack)], GetUnitX(unit_data.Owner), GetUnitY(unit_data.Owner), unit_data.weapon.fire_sound.volume or 125, unit_data.weapon.fire_sound.cutoff or 2000.)
                end

        end)


        local y
        local trg = CreateTrigger()

            TriggerRegisterAnyUnitEventBJ(trg, EVENT_PLAYER_UNIT_DAMAGED)
            TriggerAddAction(trg, function()

                if BlzGetEventAttackType() == ATTACK_TYPE_MELEE and GetEventDamage() > 0. and GetUnitData(GetEventDamageSource()) then
                    local data = GetUnitData(GetEventDamageSource())

                        DamageUnit(data.Owner, GetTriggerUnit(), data.weapon.damage, data.weapon.damage_type)

                    BlzSetEventDamage(0.)
                end

            end)


    end

end