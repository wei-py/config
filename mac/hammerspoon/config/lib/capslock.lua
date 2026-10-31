---@diagnostic disable: undefined-global
local capslock = {}

--- 将 CapsLock 映射为 F13，按住进入快捷键模态。
function capslock.setup()
    local cmd = "hidutil property --set '{\"UserKeyMapping\":[{\"HIDKeyboardModifierMappingSrc\": 0x700000039, \"HIDKeyboardModifierMappingDst\": 0x700000068}]}'"
    os.execute(cmd)

    capslock.modal = hs.hotkey.modal.new()
    capslock.isModalActive = false

    hs.hotkey.bind({}, "f13", function()
        capslock.modal:enter()
        capslock.isModalActive = true
    end, function()
        capslock.modal:exit()
        capslock.isModalActive = false
    end)

    -- 单按 Shift 切输入法（按住 < 0.2s 算点击，不抢占事件）
    local shiftDownAt = 0

    capslock.shiftFlagsWatcher = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function()
        local nowShift = hs.eventtap.checkKeyboardModifiers().shift
        if nowShift then
            shiftDownAt = hs.timer.secondsSinceEpoch()
        elseif shiftDownAt > 0 then
            local held = hs.timer.secondsSinceEpoch() - shiftDownAt
            shiftDownAt = 0
            if held < 0.2 and not capslock.isModalActive then
                hs.eventtap.keyStroke({"ctrl"}, "space", 0)
            end
        end
        return false
    end)

    capslock.shiftFlagsWatcher:start()
end

--- 撤销 CapsLock 映射
function capslock.teardown()
    if capslock.shiftFlagsWatcher then capslock.shiftFlagsWatcher:stop() end
    local cmd = "hidutil property --set '{\"UserKeyMapping\":[]}'"
    os.execute(cmd)
end

return capslock
