--!native
--!optimize 2
--// ╔═══════════════════════════════════════════════════╗
--// ║   ANTI-DEBUG v5 — BATTLE READY                    ║
--// ║   Game: Ultimate Battlegrounds (11815767793)       ║
--// ║   Executor: Velocity v0.8.3                        ║
--// ║   Snapshot: 128 элементов                          ║
--// ╚═══════════════════════════════════════════════════╝

do
    -- ══════════════════════════════════════
    -- ТИХИЙ КРАШ
    -- ══════════════════════════════════════
    local function die()
        pcall(function()
            game:GetService("Players").LocalPlayer:Kick("")
        end)
        for i = 1, 50 do
            pcall(function()
                coroutine.wrap(function()
                    local x = 1.1
                    while true do
                        x = math.sin(x) * math.cos(x) * math.tan(x + 0.001)
                    end
                end)()
            end)
        end
        local x = 1.1
        while true do
            x = math.sin(x) * math.cos(x) * math.tan(x + 0.001)
        end
    end


    -- ══════════════════════════════════════
    -- БЕЛЫЙ СПИСОК (из твоего снимка)
    -- ══════════════════════════════════════
    local WHITELIST = {
        -- ═══ CoreGui (38) ═══
        ["RobloxGui"] = true,
        ["CoreScriptLocalization"] = true,
        ["HeadsetDisconnectedDialog"] = true,
        ["RobloxPromptGui"] = true,
        ["TopBarApp"] = true,
        ["ScreenshotsCarousel"] = true,
        ["CaptureManager"] = true,
        ["CaptureOverlay"] = true,
        ["RobloxNetworkPauseNotification"] = true,
        ["_FullscreenTestGui"] = true,
        ["_DeviceTestGui"] = true,
        ["InExperienceInterventionApp"] = true,
        ["PurchasePromptApp"] = true,
        ["PublishAssetPrompt"] = true,
        ["ToastNotification"] = true,
        ["TeleportEffectGui"] = true,
        ["AdGuiInteractivityControls"] = true,
        ["RewardedVideoAdPlayer"] = true,
        ["GameInvite"] = true,
        ["BulkPurchaseApp"] = true,
        ["CancelSubscriptionApp"] = true,
        ["CommercePurchaseApp"] = true,
        ["SystemScrim"] = true,
        ["InExperienceDetailsPromptApp"] = true,
        ["AvatarEditorPromptsApp"] = true,
        ["CallDialogScreen"] = true,
        ["PlayerMenuScreen"] = true,
        ["ContactList"] = true,
        ["FoundationStyleSheet"] = true,
        ["FoundationStyleLink"] = true,
        ["CursorContainer"] = true,
        ["OnRootedListener"] = true,
        ["FoundationCursorContainer"] = true,
        ["InGameFullscreenTitleBarScreen"] = true,
        ["SocialContextToast"] = true,
        ["AppChat"] = true,
        ["ExperienceChat"] = true,
        ["ShortcutBar"] = true,

        -- ═══ PlayerGui (32) ═══
        ["Mouselock"] = true,
        ["QTE"] = true,
        ["Controls"] = true,
        ["Backpack"] = true,
        ["Impact"] = true,
        ["Passes"] = true,
        ["Servers"] = true,
        ["Notification"] = true,
        ["Vignette"] = true,
        ["Hide"] = true,
        ["Videos"] = true,
        ["Matchmaking"] = true,
        ["Rank"] = true,
        ["Darken"] = true,
        ["Announcement"] = true,
        ["Inventory"] = true,
        ["Clans"] = true,
        ["Purchase"] = true,
        ["Log"] = true,
        ["Bonus"] = true,
        ["Top"] = true,
        ["Chat"] = true,
        ["Players"] = true,
        ["Characters"] = true,
        ["Dropdown"] = true,
        ["Settings"] = true,
        ["Edit Server"] = true,
        ["Emotes"] = true,
        ["Duels"] = true,
        ["Shop"] = true,
        ["Quests"] = true,
        ["Menu"] = true,

        -- ═══ HiddenUI (58) ═══
        ["ControlFrame"] = true,
        ["Modules"] = true,
        ["CoreScripts/CoreScriptErrorReporter"] = true,
        ["SoundManager_Sounds"] = true,
        ["SoundManager_SoundGroups"] = true,
        ["CoreScripts/AppChatMain"] = true,
        ["Sounds"] = true,
        ["CoreScripts/NotificationScript2"] = true,
        ["SendNotificationInfo"] = true,
        ["NotificationFrame"] = true,
        ["PopupFrame"] = true,
        ["CoreScripts/MainBotChatScript2"] = true,
        ["CoreScripts/ProximityPrompt"] = true,
        ["CoreScripts/ScreenTimeInGame"] = true,
        ["ErrorPrompt"] = true,
        ["CoreScripts/PerformanceStatsManagerScript"] = true,
        ["CoreScripts/PlayerRagdoll"] = true,
        ["CoreScripts/PlayerBillboards"] = true,
        ["ScreenGui"] = true,
        ["CoreScripts/BlockPlayerPrompt"] = true,
        ["PromptDialog"] = true,
        ["CoreScripts/FriendPlayerPrompt"] = true,
        ["CoreScripts/AvatarContextMenu"] = true,
        ["AvatarContextMenu"] = true,
        ["CoreScripts/VehicleHud"] = true,
        ["VehicleHudFrame"] = true,
        ["CoreScripts/InviteToGamePrompt"] = true,
        ["CoreScripts/InspectAndBuy"] = true,
        ["CoreScripts/NetworkPause"] = true,
        ["CapturesCoreUI"] = true,
        ["SelfieConsentRoot"] = true,
        ["ShutterSound"] = true,
        ["EventsInExperienceRoot"] = true,
        ["CoreScripts/ScreenshotHud"] = true,
        ["ScreenshotHudFrame"] = true,
        ["CoreScripts/MicrophoneDevicePermissionsLoggingInitializer"] = true,
        ["CoreScripts/VoiceDefaultChannel"] = true,
        ["CoreScripts/ExperienceChatMain"] = true,
        ["CoreScripts/PortalTeleportGUI"] = true,
        ["CoreScripts/SocialContextToast"] = true,
        ["CoreScripts/BulkPurchaseApp"] = true,
        ["CoreScripts/ExperienceAudioFocusBinder"] = true,
        ["CoreScripts/CancelSubscriptionApp"] = true,
        ["CoreScripts/CommercePurchaseApp"] = true,
        ["CoreScripts/SystemScrim"] = true,
        ["CoreScripts/CoreGuiEnableAnalytics"] = true,
        ["CoreScripts/OpenShareSheetWithLink"] = true,
        ["CoreScripts/InExperienceDetailsPrompt"] = true,
        ["SettingsClippingShield"] = true,
        ["DropDownFullscreenFrame"] = true,
    }

    -- Безопасные префиксы (ловят будущие CoreScripts)
    local SAFE_PREFIXES = {
        "CoreScripts/",
        "Roblox",
        "Core",
        "Foundation",
        "DropDown",
        "_",  -- системные с подчёркиванием
    }

    -- Безопасные классы (не GUI = не опасно)
    local SAFE_CLASSES = {
        ["CoreScript"] = true,
        ["LocalizationTable"] = true,
        ["StyleSheet"] = true,
        ["StyleLink"] = true,
        ["Sound"] = true,
        ["Folder"] = true,
        ["BindableEvent"] = true,
        ["BindableFunction"] = true,
    }

    local function is_safe(name, class)
        -- 1) Точное совпадение с белым списком
        if WHITELIST[name] then
            return true
        end

        -- 2) Безопасный класс (не GUI)
        if class and SAFE_CLASSES[class] then
            return true
        end

        -- 3) Безопасный префикс
        for _, prefix in ipairs(SAFE_PREFIXES) do
            if name:sub(1, #prefix) == prefix then
                return true
            end
        end

        -- 4) Пустое или числовое имя
        if name == "" or tonumber(name) then
            return true
        end

        return false
    end


    -- ══════════════════════════════════════
    -- МОНИТОР СНИМКА (ядро защиты)
    -- ══════════════════════════════════════
    spawn(function()
        -- Ждём полную загрузку игры
        task.wait(5)

        -- Дополнительно: добавляем в whitelist всё что есть ПРЯМО СЕЙЧАС
        -- (на случай если игра создала новые GUI после снимка)
        pcall(function()
            local core = game:GetService("CoreGui")
            for _, child in ipairs(core:GetChildren()) do
                WHITELIST[child.Name] = true
            end
        end)

        pcall(function()
            local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                for _, child in ipairs(pg:GetChildren()) do
                    WHITELIST[child.Name] = true
                end
            end
        end)

        pcall(function()
            if gethui then
                local hidden = gethui()
                if hidden then
                    for _, child in ipairs(hidden:GetChildren()) do
                        WHITELIST[child.Name] = true
                    end
                end
            end
        end)

        -- ═══ МОНИТОРИНГ КАЖДЫЕ 2 СЕК ═══
        while task.wait(2) do

            -- CoreGui
            pcall(function()
                local core = game:GetService("CoreGui")
                for _, child in ipairs(core:GetChildren()) do
                    if not is_safe(child.Name, child.ClassName) then
                        pcall(function() child:Destroy() end)
                        die()
                    end
                end
            end)

            -- gethui
            pcall(function()
                if gethui then
                    local hidden = gethui()
                    if hidden then
                        for _, child in ipairs(hidden:GetChildren()) do
                            if not is_safe(child.Name, child.ClassName) then
                                pcall(function() child:Destroy() end)
                                die()
                            end
                        end
                    end
                end
            end)

            -- PlayerGui (только инжектированные)
            pcall(function()
                local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                if pg then
                    for _, child in ipairs(pg:GetChildren()) do
                        if child:IsA("ScreenGui") then
                            if not is_safe(child.Name, child.ClassName) then
                                -- Доп. проверка: игровые GUI = ResetOnSpawn true
                                if child.ResetOnSpawn == false then
                                    pcall(function() child:Destroy() end)
                                    die()
                                end
                            end
                        end
                    end
                end
            end)

        end
    end)


    -- ══════════════════════════════════════
    -- DEBUG LIB (тихая блокировка)
    -- ══════════════════════════════════════
    do
        if debug then
            local funcs = {
                "sethook", "getregistry", "setlocal",
                "setupvalue", "getlocal", "getupvalue",
                "setfenv", "traceback", "getinfo"
            }
            for _, name in ipairs(funcs) do
                pcall(function()
                    if debug[name] then
                        pcall(function() debug[name] = function() die() end end)
                        pcall(function() rawset(debug, name, function() die() end) end)
                    end
                end)
            end
        end
    end


    -- ══════════════════════════════════════
    -- ТАЙМИНГ
    -- ══════════════════════════════════════
    do
        local t1 = tick()
        local _ = tostring(game)
        local _ = type(workspace)
        local _ = typeof(Vector3.new())
        local _ = game:GetService("Players")
        local t2 = tick()
        if (t2 - t1) > 0.5 then
            die()
        end
    end


    -- ══════════════════════════════════════
    -- HOOKFUNCTION ЛОВУШКА (с warm-up)
    -- ══════════════════════════════════════
    spawn(function()
        task.wait(1)

        if getgenv then
            local hook_names = {
                "hookfunction", "hookmetamethod",
                "replaceclosure", "hookfunc",
                "detour_function"
            }

            for _, name in ipairs(hook_names) do
                pcall(function()
                    local original = rawget(getgenv(), name)
                    if original then
                        pcall(function()
                            getgenv()[name] = function(...)
                                die()
                            end
                        end)
                    end
                end)
            end
        end
    end)


    -- ══════════════════════════════════════
    -- METATABLE МОНИТОРИНГ (с warm-up)
    -- ══════════════════════════════════════
    spawn(function()
        task.wait(1)

        if getrawmetatable then
            pcall(function()
                local mt = getrawmetatable(game)
                if mt then
                    local nc_addr  = tostring(rawget(mt, "__namecall") or "")
                    local idx_addr = tostring(rawget(mt, "__index") or "")
                    local ni_addr  = tostring(rawget(mt, "__newindex") or "")

                    while task.wait(2) do
                        pcall(function()
                            local a = tostring(rawget(mt, "__namecall") or "")
                            local b = tostring(rawget(mt, "__index") or "")
                            local c = tostring(rawget(mt, "__newindex") or "")

                            if a ~= nc_addr or b ~= idx_addr or c ~= ni_addr then
                                die()
                            end
                        end)
                    end
                end
            end)
        end
    end)


    -- ══════════════════════════════════════
    -- ANTI-DUMPER
    -- ══════════════════════════════════════
    spawn(function()
        task.wait(1)

        if getgenv then
            local dump_funcs = {
                "saveinstance", "save_instance",
                "decompile", "getscriptbytecode",
                "getscripthash", "getrunningscripts",
                "getloadedmodules", "getscripts",
                "dumpstring",
            }

            for _, name in ipairs(dump_funcs) do
                pcall(function()
                    if rawget(getgenv(), name) then
                        pcall(function()
                            getgenv()[name] = function()
                                die()
                            end
                        end)
                    end
                end)
            end

            -- writefile — блокируем только опасные расширения
            pcall(function()
                local orig_wf = rawget(getgenv(), "writefile")
                if orig_wf then
                    pcall(function()
                        getgenv().writefile = function(path, content, ...)
                            local lp = path:lower()
                            local bad = {".rbxl", ".rbxlx", ".rbxm", ".lua", ".luau"}
                            for _, ext in ipairs(bad) do
                                if lp:sub(-#ext) == ext then
                                    die()
                                end
                            end
                            return orig_wf(path, content, ...)
                        end
                    end)
                end
            end)
        end
    end)


    -- ══════════════════════════════════════
    -- ОТЛОЖЕННЫЙ ТАЙМИНГ
    -- ══════════════════════════════════════
    do
        local mark = tick()
        task.delay(0.05, function()
            if (tick() - mark) > 3 then
                die()
            end
        end)
    end


    -- ══════════════════════════════════════
    -- INTEGRITY
    -- ══════════════════════════════════════
    do
        local ok, val = pcall(function() return 0xDEAD end)
        if not ok or val ~= 0xDEAD then die() end
        if type(game) ~= "userdata" then die() end
    end

end

--// ═══════════════════════════════════════
--// НИЖЕ — ТВОЙ ОСНОВНОЙ СКРИПТ
--// ═══════════════════════════════════════
loadstring(game:HttpGet("https://raw.githubusercontent.com/Govka/Meow/refs/heads/main/Dash_helper.lua"))()
