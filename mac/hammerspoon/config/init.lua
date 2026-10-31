---@diagnostic disable: undefined-global
require("hs.ipc")

for _, moduleName in ipairs({
    "lib.notify",
    "lib.capslock",
    "lib.utils",
    "lib.window",
    "lib.bindings",
}) do
    package.loaded[moduleName] = nil
end

local notify = require("lib.notify")
notify.success("Hyper Key Config Loaded")

local capslock = require("lib.capslock")
local utils    = require("lib.utils")
local window   = require("lib.window")
local bindings = require("lib.bindings")

capslock.setup()
bindings.setup(capslock.modal, utils, window)

hs.shutdownCallback = function()
    capslock.teardown()
end
