---@diagnostic disable: undefined-global
local utils = {}

--- 发送组合键
function utils.sendKey(mods, key)
    hs.eventtap.keyStroke(mods, key, 0)
end

--- 在模态内绑定按键，支持长按重复
---@param modal table
---@param key string
---@param fn function
---@param shouldRepeat boolean|nil
function utils.bindModalKey(modal, key, fn, shouldRepeat)
    if shouldRepeat then
        modal:bind({}, key,
            function() fn() end,
            function() end,
            function() fn() end
        )
    else
        modal:bind({}, key,
            function() fn() end,
            function() end,
            function() end
        )
    end
end

return utils
