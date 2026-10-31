---@diagnostic disable: undefined-global
local bindings = {}
local spaces = require("hs.spaces")

---@param modal table
---@param utils table
---@param window table
function bindings.setup(modal, utils, window)
  -- 窗口布局
  utils.bindModalKey(modal, "up", function() window.changeLayout("maximize") end)
  utils.bindModalKey(modal, "down", function() window.changeLayout("fullScreen") end)
  utils.bindModalKey(modal, "left", function() window.changeLayout("left") end)
  utils.bindModalKey(modal, "right", function() window.changeLayout("right") end)
  utils.bindModalKey(modal, "a", function() window.changeLayout("maximize") end)

  -- 系统功能
  utils.bindModalKey(modal, "tab", window.switchSpace)
  utils.bindModalKey(modal, "r", function() utils.sendKey({ "cmd" }, "`") end, true)
  local function sendCtrlUp()
    spaces.toggleMissionControl()
  end
  local function sendCtrlDown()
    spaces.toggleAppExpose()
  end
  utils.bindModalKey(modal, "0", sendCtrlDown)
  utils.bindModalKey(modal, "pad0", sendCtrlDown)
  utils.bindModalKey(modal, "9", sendCtrlUp)
  utils.bindModalKey(modal, "pad9", sendCtrlUp)
  -- Caps+1/2（含小键盘）发送 Ctrl+Shift+Tab / Ctrl+Tab。
  utils.bindModalKey(modal, "1", function() utils.sendKey({ "ctrl", "shift" }, "tab") end)
  utils.bindModalKey(modal, "2", function() utils.sendKey({ "ctrl" }, "tab") end)
  utils.bindModalKey(modal, "pad1", function() utils.sendKey({ "ctrl", "shift" }, "tab") end)
  utils.bindModalKey(modal, "pad2", function() utils.sendKey({ "ctrl" }, "tab") end)
  local function mediaPlayPause()
    hs.eventtap.event.newSystemKeyEvent("PLAY", true):post()
  end
  utils.bindModalKey(modal, "\\", mediaPlayPause)

  -- Caps +/-：每次 1%，支持长按；底部 HUD 显示百分比/静音，最后一次操作 1 秒后隐藏。
  -- 显式布局避免文字裁切；重复按键复用画布和计时器，并重新定位到当前主屏幕。
  local volCanvas = nil
  local volHideTimer = nil
  local hudWidth, hudHeight = 260, 84
  local barWidth = hudWidth - 40

  local function volumeAlert(vol, muted)
    if not volCanvas then
      volCanvas = hs.canvas.new({ x = 0, y = 0, w = hudWidth, h = hudHeight })
      volCanvas:level(hs.canvas.windowLevels.overlay)
      volCanvas:behavior({
        hs.canvas.windowBehaviors.canJoinAllSpaces,
        hs.canvas.windowBehaviors.stationary,
        hs.canvas.windowBehaviors.ignoresCycle,
      })
      volCanvas:appendElements({
        {
          type = "rectangle",
          action = "strokeAndFill",
          frame = { x = 1, y = 1, w = hudWidth - 2, h = hudHeight - 2 },
          fillColor = { white = 0.10, alpha = 0.94 },
          strokeColor = { white = 1, alpha = 0.14 },
          strokeWidth = 1,
          roundedRectRadii = { xRadius = 16, yRadius = 16 },
        },
        {
          type = "text",
          frame = { x = 20, y = 16, w = 120, h = 26 },
          text = "音量",
          textFont = ".AppleSystemUIFont",
          textSize = 16,
          textColor = { white = 0.85 },
        },
        {
          type = "text",
          frame = { x = 140, y = 13, w = 100, h = 30 },
          text = "",
          textFont = "Menlo",
          textSize = 20,
          textColor = { white = 1 },
          textAlignment = "right",
        },
        {
          type = "rectangle",
          action = "fill",
          frame = { x = 20, y = 56, w = barWidth, h = 6 },
          fillColor = { white = 1, alpha = 0.18 },
          roundedRectRadii = { xRadius = 3, yRadius = 3 },
        },
        {
          type = "rectangle",
          action = "fill",
          frame = { x = 20, y = 56, w = barWidth, h = 6 },
          fillColor = { white = 1, alpha = 0.95 },
          roundedRectRadii = { xRadius = 3, yRadius = 3 },
        },
      })
      volHideTimer = hs.timer.delayed.new(1, function() volCanvas:hide() end)
    end

    local sf = hs.screen.mainScreen():frame()
    volCanvas:topLeft({
      x = sf.x + (sf.w - hudWidth) / 2,
      y = sf.y + sf.h - hudHeight - 48,
    })
    local silent = muted or vol <= 0
    volCanvas:elementAttribute(2, "text", silent and "静音" or "音量")
    volCanvas:elementAttribute(3, "text", string.format("%.0f%%", vol))
    volCanvas:elementAttribute(5, "frame", {
      x = 20, y = 56, w = barWidth * vol / 100, h = 6,
    })
    volCanvas:elementAttribute(5, "action", silent and "skip" or "fill")
    volCanvas:show()
    volHideTimer:start()
  end

  utils.bindModalKey(modal, "=", function()
    local dev = hs.audiodevice.defaultOutputDevice()
    if dev then
      local vol = math.min(100, dev:volume() + 1)
      dev:setVolume(vol)
      volumeAlert(vol, dev:muted())
    end
  end, true)
  utils.bindModalKey(modal, "-", function()
    local dev = hs.audiodevice.defaultOutputDevice()
    if dev then
      local vol = math.max(0, dev:volume() - 1)
      dev:setVolume(vol)
      volumeAlert(vol, dev:muted())
    end
  end, true)

  -- Vim 风格导航（支持长按重复）
  utils.bindModalKey(modal, "h", function() utils.sendKey({}, "left") end, true)
  utils.bindModalKey(modal, "j", function() utils.sendKey({}, "down") end, true)
  utils.bindModalKey(modal, "k", function() utils.sendKey({}, "up") end, true)
  utils.bindModalKey(modal, "l", function() utils.sendKey({}, "right") end, true)
  utils.bindModalKey(modal, "d", function() utils.sendKey({}, "delete") end, true)

  -- 快速启动应用
  utils.bindModalKey(modal, "i", function() hs.application.launchOrFocus("BrowserOS") end)
  utils.bindModalKey(modal, "o", function() hs.application.launchOrFocusByBundleID("dev.herdr.app") end)
  utils.bindModalKey(modal, "u", function() hs.application.launchOrFocusByBundleID("dev.herdr.app") end)
  utils.bindModalKey(modal, "m", function() hs.application.launchOrFocus("NeteaseMusic") end)
  utils.bindModalKey(modal, "b", function() hs.application.launchOrFocus("WeChat") end)
  utils.bindModalKey(modal, "p", function() hs.application.launchOrFocus("HbuilderX") end)
  utils.bindModalKey(modal, "f", function() hs.application.launchOrFocus("Finder") end)
  utils.bindModalKey(modal, "y", function() hs.application.launchOrFocus("Helium") end)

  -- Caps+N：前置 Herdr 桌面端，并按名称定位现有 me / 1。
  -- 异步执行桌面端 CLI，避免阻塞 Hammerspoon 的按键事件。
  local herdrTask
  utils.bindModalKey(modal, "n", function()
    if herdrTask then return end
    local bundle = "dev.herdr.app"
    local appPath = hs.application.pathForBundleID(bundle)
    if not appPath or not hs.application.launchOrFocusByBundleID(bundle) then
      hs.alert.show("Herdr：无法打开桌面端")
      return
    end
    local function run(args, success)
      herdrTask = hs.task.new(appPath .. "/Contents/MacOS/Herdr", function(code, stdout, stderr)
        herdrTask = nil
        local ok, result = pcall(hs.json.decode, stdout)
        if code ~= 0 or not ok or not result or result.error then
          hs.alert.show("Herdr：" .. tostring(ok and result and result.error or stderr or stdout))
          return
        end
        success(result)
      end, args)
      if not herdrTask or not herdrTask:start() then
        herdrTask = nil
        hs.alert.show("Herdr：无法执行桌面端命令")
      end
    end
    run({ "ls" }, function(result)
      local workspace, tab
      for _, item in ipairs(result.spaces or {}) do
        if item.name == "me" then
          if workspace then hs.alert.show("Herdr：存在多个 me Workspace"); return end
          workspace = item
        end
      end
      if not workspace then hs.alert.show("Herdr：找不到 me Workspace"); return end
      for _, item in ipairs(workspace.tabs) do
        if item.name == "1" then
          if tab then hs.alert.show("Herdr：me 中存在多个名为 1 的 Tab"); return end
          tab = item
        end
      end
      if not tab then hs.alert.show("Herdr：me 中找不到名为 1 的 Tab"); return end
      run({ "do", "space.select", "--id", workspace.id }, function()
        run({ "do", "tab.select", "--id", tab.id }, function() end)
      end)
    end)
  end)

  -- 全局导航映射；Herdr 桌面端由原生 Ctrl+Tab / Ctrl+Shift+Tab 绑定处理循环。
  hs.hotkey.bind({ "cmd" }, "1", function() utils.sendKey({ "ctrl", "shift" }, "tab") end)
  hs.hotkey.bind({ "cmd" }, "2", function() utils.sendKey({ "ctrl" }, "tab") end)
end

return bindings
