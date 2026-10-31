---@diagnostic disable: undefined-global
local notify = require("lib.notify")
local window = {}

--- 改变窗口布局
function window.changeLayout(mode)
    local win = hs.window.focusedWindow()
    if not win then return end

    if win:isFullScreen() and mode ~= "fullScreen" then
        win:setFullScreen(false)
        hs.timer.usleep(50000)
    end

    if mode == "maximize" then
        win:moveToUnit({ 0, 0, 1, 1 })
    elseif mode == "fullScreen" then
        win:setFullScreen(true)
    elseif mode == "left" then
        win:moveToUnit({ 0, 0, 0.5, 1 })
    elseif mode == "right" then
        win:moveToUnit({ 0.5, 0, 0.5, 1 })
    end
end

--- 切换到下一个桌面
function window.switchSpace()
    local allSpaces = hs.spaces.allSpaces()
    local focusedSpace = hs.spaces.focusedSpace()
    for _, spaceIDs in pairs(allSpaces) do
        for i, spaceID in ipairs(spaceIDs) do
            if spaceID == focusedSpace then
                local nextIdx = (i % #spaceIDs) + 1
                hs.spaces.gotoSpace(spaceIDs[nextIdx])
                notify.success("切换至桌面: " .. nextIdx)
                return
            end
        end
    end
end

return window
