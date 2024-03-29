---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by MSI.
--- DateTime: 16.07.2022 22:19
---
do


    function FirebatAttack(source, target)
        local first_splash_group = CreateGroup()
        local second_splash_group = CreateGroup()
        local third_splash_group = CreateGroup()
        local x, y = GetUnitX(source), GetUnitY(source)
        local angle = AngleBetweenUnits(source, target)
        local player = GetOwningPlayer(source)
        local unit_data = GetUnitData(source)



            x = x + Rx(50., angle); y = y + Ry(50., angle)
            GroupEnumUnitsInRange(first_splash_group, x, y, 75., nil)
            x = x + Rx(50., angle); y = y + Ry(50., angle)
            GroupEnumUnitsInRange(second_splash_group, x, y, 75., nil)
            x = x + Rx(50., angle); y = y + Ry(50., angle)
            GroupEnumUnitsInRange(third_splash_group, x, y, 75., nil)


            for index = BlzGroupGetSize(first_splash_group) - 1, 0, -1 do
                local picked = BlzGroupUnitAt(first_splash_group, index)

                if IsUnitEnemy(picked, player) and GetUnitState(picked, UNIT_STATE_LIFE) > 0.045 and GetUnitAbilityLevel(picked, FourCC("Avul")) == 0 then
                    DamageUnit(source, picked, unit_data.weapon[1].damage, unit_data.weapon[1].damage_type)
                end
            end

            for index = BlzGroupGetSize(second_splash_group) - 1, 0, -1 do
                local picked = BlzGroupUnitAt(second_splash_group, index)

                if IsUnitEnemy(picked, player) and GetUnitState(picked, UNIT_STATE_LIFE) > 0.045 and GetUnitAbilityLevel(picked, FourCC("Avul")) == 0 then
                    DamageUnit(source, picked, unit_data.weapon[1].damage, unit_data.weapon[1].damage_type)
                end
            end

            for index = BlzGroupGetSize(third_splash_group) - 1, 0, -1 do
                local picked = BlzGroupUnitAt(third_splash_group, index)

                if IsUnitEnemy(picked, player) and GetUnitState(picked, UNIT_STATE_LIFE) > 0.045 and GetUnitAbilityLevel(picked, FourCC("Avul")) == 0 then
                    DamageUnit(source, picked, unit_data.weapon[1].damage, unit_data.weapon[1].damage_type)
                end
            end

            DestroyGroup(first_splash_group)
            DestroyGroup(second_splash_group)
            DestroyGroup(third_splash_group)

    end

end