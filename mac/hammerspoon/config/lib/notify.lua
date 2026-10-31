---@diagnostic disable: undefined-global
local notify = {}

local palette = {
    success = { stroke = "#34C759", text = "#FFFFFF" },
    warn    = { stroke = "#FFCC00", text = "#FFFFFF" },
    error   = { stroke = "#FF3B30", text = "#FFFFFF" },
}

---@param level string  "success" | "warn" | "error"
---@param msg    string
function notify.show(level, msg)
    local c = palette[level] or palette.error
    hs.alert.show(msg, {
        fontSize = 14,
        fadeOutDuration = 1.0,
        textColor = { hex = c.text },
        strokeColor = { hex = c.stroke },
    })
end

function notify.success(msg) notify.show("success", msg) end
function notify.warn(msg)    notify.show("warn",    msg) end
function notify.error(msg)   notify.show("error",   msg) end

return notify
