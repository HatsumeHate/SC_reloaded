---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by MSI.
--- DateTime: 25.07.2022 21:48
---
do

    function BunkerStopOrder(bunker)
        local bunker_data = GetUnitData(bunker)

            ForGroup(bunker_data.cargo_group, function()
                local unit_data = GetUnitData(GetEnumUnit())
                IssueImmediateOrderById(unit_data.bunker_unit, order_stop)
            end)

    end


    function BunkerAttackOrder(bunker, target)
        local bunker_data = GetUnitData(bunker)

            ForGroup(bunker_data.cargo_group, function()
                local unit_data = GetUnitData(GetEnumUnit())

                    if IsUnitInRange(unit_data.bunker_unit, target, BlzGetUnitWeaponRealField(unit_data.bunker_unit, UNIT_WEAPON_RF_ATTACK_RANGE, 0)) then
                        IssueTargetOrderById(unit_data.bunker_unit, order_attack, target)
                    end

            end)

    end

    function BunkerStimpackOrder(bunker)
        local bunker_data = GetUnitData(bunker)

            ForGroup(bunker_data.cargo_group, function()
                local unit = GetEnumUnit()
                local unit_data = GetUnitData(unit)

                    if GetUnitAbilityLevel(unit, FourCC("A005")) > 0 then
                        StimpackEffect(unit)
                        StimpackEffect_Bunker(unit_data.bunker_unit)
                        SetUnitState(unit, UNIT_STATE_LIFE, GetUnitState(unit_data.bunker_unit, UNIT_STATE_LIFE))
                    end

            end)

    end


    function BunkerRemoveAllUnits(bunker)
        local bunker_data = GetUnitData(bunker)

            ForGroup(bunker_data.cargo_group, function() BunkerRemoveUnit(bunker, GetEnumUnit()) end)
            UnitRemoveAbility(bunker, FourCC("A00Y"))
            UnitRemoveAbility(bunker, FourCC("A00Z"))
            UnitRemoveAbility(bunker, FourCC("A010"))

    end


    function BunkerRemoveUnit(bunker, target)
        local bunker_data = GetUnitData(bunker)
        local unit_data = GetUnitData(target)

            GroupRemoveUnit(bunker_data.cargo_group, target)

            if BlzGroupGetSize(bunker_data.cargo_group) == 0 then
                UnitRemoveAbility(bunker, FourCC("A00Y"))
                UnitRemoveAbility(bunker, FourCC("A00Z"))
                UnitRemoveAbility(bunker, FourCC("A010"))
            end

            ForGroup(bunker_data.cargo_group, function()
                 if GetUnitAbilityLevel(GetEnumUnit(), FourCC("A005")) > 0 then
                    UnitAddAbility(bunker, FourCC("A010"))
                end
            end)

            DestroyTimer(unit_data.bunker_timer)
            if unit_data.bunker_unit then
                SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(unit_data.bunker_unit, UNIT_STATE_LIFE))
                SetUnitState(target, UNIT_STATE_MANA, GetUnitState(unit_data.bunker_unit, UNIT_STATE_MANA))
                RemoveUnit(unit_data.bunker_unit)
            end

    end


    function BunkerLoadUnit(bunker, target)
        local x, y = GetUnitX(bunker), GetUnitY(bunker)
        local bunker_data = GetUnitData(bunker)
        local unit_type = GetUnitTypeId(target)
        local load_unit_data = GetUnitData(target)

            if unit_type == FourCC("trmr") then unit_type = FourCC("h007")
            elseif unit_type == FourCC("trfb") then unit_type = FourCC("h006")
            elseif unit_type == FourCC("trmd") then unit_type = FourCC("h008")
            elseif unit_type == FourCC("trgh") then unit_type = FourCC("h009")
            end

            GroupAddUnit(bunker_data.cargo_group, target)
            load_unit_data.bunker_unit = CreateUnit(GetOwningPlayer(target), unit_type, x, y, 0.)

            SetUnitState(load_unit_data.bunker_unit, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE))
            SetUnitState(load_unit_data.bunker_unit, UNIT_STATE_MANA, GetUnitState(target, UNIT_STATE_MANA))

            load_unit_data.bunker_timer = CreateTimer()

            local cooldown = 0.

            TimerStart(load_unit_data.bunker_timer, 0.03, true, function()
                SetUnitState(load_unit_data.bunker_unit, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE))
                SetUnitState(load_unit_data.bunker_unit, UNIT_STATE_MANA, GetUnitState(target, UNIT_STATE_MANA))
                --SetUnitX(load_unit_data.bunker_unit, x)
               -- SetUnitY(load_unit_data.bunker_unit, y)

                    if GetUnitAbilityLevel(target, FourCC("A002")) > 0 then

                        if cooldown <= 0. then
                            for i = 0, 3 do
                                local picked = BlzGroupUnitAt(bunker_data.cargo_group, i)

                                    if picked ~= target and GetUnitState(picked, UNIT_STATE_LIFE) < BlzGetUnitMaxHP(picked) and GetUnitState(target, UNIT_STATE_MANA) >= 1 then
                                        SetUnitState(picked, UNIT_STATE_LIFE, GetUnitState(picked, UNIT_STATE_LIFE) + 2)
                                        SetUnitState(target, UNIT_STATE_MANA, GetUnitState(target, UNIT_STATE_MANA) - 1)
                                        cooldown = 0.193
                                        AddSoundVolume("Abilities\\Spells\\Human\\Heal\\HealTarget.wav", x, y, 90, 1900., 4000.)
                                        break
                                    end

                            end
                        else
                            cooldown = cooldown - 0.03
                        end

                    end

            end)

            UnitsList[GetHandleId(load_unit_data.bunker_unit)] = load_unit_data
            SetUnitX(load_unit_data.bunker_unit, x)
            SetUnitY(load_unit_data.bunker_unit, y)

            --SetUnitVertexColor(load_unit_data.bunker_unit, 255, 255, 255, 0)

            UnitAddAbility(bunker, FourCC("A00Y"))
            UnitAddAbility(bunker, FourCC("A00Z"))

            if GetUnitAbilityLevel(target, FourCC("A005")) > 0 then
                UnitAddAbility(bunker, FourCC("A010"))
            end

            if GetUnitAbilityLevel(target, FourCC("A006")) > 0 then
                StimpackEffect_Bunker(load_unit_data.bunker_unit)
                SetUnitUserData(load_unit_data.bunker_unit, math.floor(load_unit_data.timed_effects["A006"] * 1000))
            end

    end

    
    function BunkerBuilt(unit)
        local death_trigger = CreateTrigger()
        local bunker_data = GetUnitData(unit)

            TriggerRegisterUnitEvent(death_trigger, unit, EVENT_UNIT_DEATH)
            TriggerAddAction(death_trigger, function()
                BunkerRemoveAllUnits(unit)
            end)

            bunker_data.cargo_group = CreateGroup()

    end
    
end 