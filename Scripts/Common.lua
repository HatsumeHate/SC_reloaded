---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by MSI.
--- DateTime: 16.07.2022 22:45
---
do



    
    function SetDetectionState(target, flag)
        local unit_data = GetUnitData(target)

            if flag then
                if unit_data.detection_ability then
                    UnitAddAbility(target, FourCC(unit_data.detection_ability))
                end
            else
                if GetUnitAbilityLevel(target, FourCC("A003")) > 0 then
                    unit_data.detection_ability = "A003"
                    UnitRemoveAbility(target, FourCC("A003"))
                end
            end

    end


    function SetCloakState(target, flag)

        if flag then
            if (GetUnitAbilityLevel(target, FourCC("A00J")) > 0 or GetUnitAbilityLevel(target, FourCC("A00C")) > 0) and BlzGetUnitRealField(target, UNIT_RF_MANA_REGENERATION) < 0. then
                UnitAddAbility(target, FourCC("A00B"))
            end
        else
            UnitRemoveAbility(target, FourCC("A00B"))
        end
    end

    ---@param target unit
    ---@param buff string
    ---@param duration real
    ---@param end_function function
    function ApplyTimedEffect(target, buff, duration, end_function)
        local unit_data = GetUnitData(target)
        local id = FourCC(buff)

            if not unit_data.timed_effects then unit_data.timed_effects = {} end

            if GetUnitAbilityLevel(target, id) == 0 then
                local timer = CreateTimer()

                    UnitAddAbility(target, id)
                    unit_data.timed_effects[buff] = duration

                        TimerStart(timer, 0.1, true, function()
                            --if not target then target = unit_data.Owner end
                            if unit_data.timed_effects[buff] <= 0. or GetUnitAbilityLevel(target, id) == 0 or GetUnitState(target, UNIT_STATE_LIFE) <= 0.045 then
                                UnitRemoveAbility(target, id)
                                DestroyTimer(timer)
                                if end_function then end_function() end
                            else
                                unit_data.timed_effects[buff] = unit_data.timed_effects[buff] - 0.1
                            end
                        end)

            else
                unit_data.timed_effects[buff] = duration
            end

    end

    function IsUnitDisabled(target)
        return GetUnitAbilityLevel(target, FourCC("A00E")) == 1
    end


    function ResumeUnitAction(unit)
        local unit_data = GetUnitData(unit)

            if unit_data.action_time then
                TimerStart(unit_data.action_timer, unit_data.action_time, false, function()
                    unit_data.action_callback()
                end)
            end

    end

    function PauseUnitAction(unit)
        local unit_data = GetUnitData(unit)

            unit_data.action_time = TimerGetRemaining(unit_data.action_timer)
            TimerStart(unit_data.action_timer, 0., false, nil)

    end

    function QueueUnitAction(unit, delay, callback)
        local unit_data = GetUnitData(unit)

            unit_data.action_callback = callback
            TimerStart(unit_data.action_timer, delay, false, function()
                if GetUnitState(unit, UNIT_STATE_LIFE) > 0.045 and not IsUnitDisabled(unit) then
                    callback()
                    unit_data.action_time = nil
                end
            end)

    end



    local OrderInterceptionData

    function RemoveOrderInterception(index)
        DestroyTrigger(OrderInterceptionData[index].order_trigger)
        DestroyTrigger(OrderInterceptionData[index].death_trigger)
        OrderInterceptionData[index] = nil
        --table.remove(OrderInterceptionData, index)
    end

    function RegisterOrderInterception(unit, func, death_func)
        local index = 1

        while(true) do
            if not OrderInterceptionData[index] then
                break
            else
                index = index + 1
            end
        end

        OrderInterceptionData[index] = {}
        local trg = CreateTrigger()
        local death = CreateTrigger()

        OrderInterceptionData[index].order_trigger = trg
        OrderInterceptionData[index].death_trigger = death

            TriggerRegisterUnitEvent(trg, unit, EVENT_UNIT_ISSUED_ORDER)
            TriggerRegisterUnitEvent(trg, unit, EVENT_UNIT_ISSUED_TARGET_ORDER)
            TriggerRegisterUnitEvent(trg, unit, EVENT_UNIT_ISSUED_POINT_ORDER)
            TriggerRegisterUnitEvent(death, unit, EVENT_UNIT_DEATH)


            TriggerAddAction(trg, function()
                local halt = false

                    if func then halt = func(GetIssuedOrderId(), GetOrderPointX(), GetOrderPointY(), GetOrderTargetUnit()) end

                    if halt then
                        DestroyTrigger(trg)
                        DestroyTrigger(death)
                    end

            end)

            TriggerAddAction(death, function()
                if death_func then death_func() end
                DestroyTrigger(trg)
                DestroyTrigger(death)
            end)

        return index
    end


    function ClearLandingSite()

    end


    function CommonFunctionsData()
        OrderInterceptionData = {}
    end

end