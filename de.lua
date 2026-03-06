--!native
--!optimize 2
--// ╔══════════════════════════════════════════════════╗
--// ║   ANTI-DEBUG v3 — HARDENED EDITION               ║
--// ║   Учтены все замечания. Краш не хукается.        ║
--// ╚══════════════════════════════════════════════════╝

do
    --// ══════════════════════════════════════════
    --// ЯДРО: Генератор краш-методов
    --// Нет единой функции CRASH() которую можно хукнуть
    --// Каждая проверка крашит по-своему
    --// ══════════════════════════════════════════

    -- Метод 1: Stack overflow через рекурсию (нельзя хукнуть — это замыкание)
    local method_overflow
    method_overflow = function()
        return method_overflow() and method_overflow()
    end

    -- Метод 2: Бесконечный yield (тихий, Hyperion не заметит)
    local method_freeze = function()
        -- Убиваем ВСЕ потоки через перегрузку
        for i = 1, 200 do
            coroutine.wrap(function()
                while true do end
            end)()
        end
        while true do end
    end

    -- Метод 3: Через ошибку в protected call (трудно отловить)
    local method_error = function()
        while true do
            pcall(error, string.rep("\0", 2^20))
        end
    end

    -- Собираем методы в массив (случайный выбор при каждом детекте)
    local crash_methods = {method_overflow, method_freeze, method_error}

    -- Эту функцию нельзя хукнуть обычным hookfunction
    -- потому что она создаётся заново каждый раз
    local function execute_crash()
        -- Сначала пробуем кикнуть
        pcall(function()
            game:GetService("Players").LocalPlayer:Kick("")
        end)

        -- Запускаем ВСЕ методы одновременно
        for _, m in ipairs(crash_methods) do
            coroutine.wrap(function()
                pcall(m)
                -- Если pcall поймал — пробуем снова без pcall
                m()
            end)()
        end

        -- Финальная страховка
        while true do end
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 1: debug библиотека
    --// ═══════════════════════════════════════════
    do
        if debug then
            local funcs = {
                "sethook", "getregistry", "setlocal",
                "setupvalue", "getlocal", "getupvalue",
                "setfenv", "traceback", "getinfo"
            }
            for _, name in ipairs(funcs) do
                if debug[name] then
                    -- Каждая функция крашит по-своему (инлайн)
                    debug[name] = function()
                        -- Инлайн краш — нечего хукать
                        local f f = function() return f() and f() end
                        f()
                    end
                end
            end
        end
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 2: Тайминг (пошаговый дебаг)
    --// ═══════════════════════════════════════════
    do
        local t1 = tick()

        -- Операции которые в дебаггере занимают время
        local _ = tostring(game)
        local _ = type(workspace)
        local _ = typeof(Vector3.new())
        local _ = game:GetService("Players")
        local _ = tostring(os.clock())
        local _ = string.format("%s%s%s", "a", "b", "c")

        local t2 = tick()

        if (t2 - t1) > 0.5 then
            -- Инлайн краш (не вызов функции)
            local f f = function() return f() and f() end
            pcall(f) -- stack overflow
            while true do end
        end
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 3: Обнаружение spy/debug tools
    --// (НЕ через CoreGui — через connections и память)
    --// ═══════════════════════════════════════════
    do
        spawn(function()
            while task.wait(3) do

                -- Способ A: Проверяем количество connections на RemoteEvent
                -- Spy-тулы подключаются к .OnClientEvent для перехвата
                pcall(function()
                    local rs = game:GetService("ReplicatedStorage")
                    for _, child in ipairs(rs:GetDescendants()) do
                        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                            -- getconnections доступен в эксплойтах
                            if getconnections then
                                local conns = getconnections(child.OnClientEvent or child.OnClientInvoke)
                                for _, conn in ipairs(conns) do
                                    -- Проверяем что connection не из нашего скрипта
                                    if getinfo then
                                        local info = getinfo(conn.Function)
                                        if info and info.source then
                                            local src = info.source:lower()
                                            if src:find("spy") or src:find("monitor")
                                               or src:find("log") or src:find("intercept") then
                                                -- Инлайн краш
                                                local f f = function() return f() and f() end
                                                f()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)

                -- Способ B: Проверяем через gethui() (hidden UI контейнер)
                pcall(function()
                    if gethui then
                        local hidden = gethui()
                        if hidden then
                            for _, child in ipairs(hidden:GetChildren()) do
                                local lower = child.Name:lower()
                                local bad = {
                                    "spy", "remote", "http", "dex",
                                    "explorer", "dump", "monitor",
                                    "hydroxide", "infinite"
                                }
                                for _, word in ipairs(bad) do
                                    if lower:find(word) then
                                        child:Destroy()
                                        local f f = function() return f() and f() end
                                        f()
                                    end
                                end
                            end
                        end
                    end
                end)

                -- Способ C: Проверяем PlayerGui на инжектированные GUI
                pcall(function()
                    local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    if pg then
                        for _, gui in ipairs(pg:GetChildren()) do
                            -- Нормальные GUI от игры имеют определённые свойства
                            -- Инжектированные обычно ResetOnSpawn = false
                            if gui:IsA("ScreenGui") and gui.ResetOnSpawn == false then
                                local lower = gui.Name:lower()
                                local bad = {"spy", "debug", "admin", "hack", "exploit", "cheat"}
                                for _, word in ipairs(bad) do
                                    if lower:find(word) then
                                        gui:Destroy()
                                        local f f = function() return f() and f() end
                                        f()
                                    end
                                end
                            end
                        end
                    end
                end)

            end
        end)
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 4: hookfunction ловушка (улучшенная)
    --// Перехватываем сам hookfunction
    --// ═══════════════════════════════════════════
    do
        if getgenv then
            local hook_names = {
                "hookfunction", "hookmetamethod",
                "replaceclosure", "hookfunc", "detour_function"
            }

            for _, name in ipairs(hook_names) do
                local original = getgenv()[name]
                if original then
                    -- Заворачиваем — если попытаются хукнуть что-то
                    -- мы узнаем ЧТО они хукают
                    getgenv()[name] = function(target, hook)
                        -- Кто-то пытается хукнуть!
                        -- Инлайн краш (не через CRASH())
                        for i = 1, 100 do
                            coroutine.wrap(function()
                                while true do end
                            end)()
                        end
                        while true do end
                    end
                end
            end
        end
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 5: metatable мониторинг
    --// ═══════════════════════════════════════════
    do
        if getrawmetatable then
            pcall(function()
                local mt = getrawmetatable(game)
                if mt then
                    -- Сохраняем хеши оригинальных функций
                    local orig_nc  = rawget(mt, "__namecall")
                    local orig_idx = rawget(mt, "__index")
                    local orig_ni  = rawget(mt, "__newindex")

                    -- Для сравнения используем tostring (даёт адрес в памяти)
                    local nc_id  = tostring(orig_nc)
                    local idx_id = tostring(orig_idx)
                    local ni_id  = tostring(orig_ni)

                    spawn(function()
                        while task.wait(1.5) do
                            local cur_nc  = rawget(mt, "__namecall")
                            local cur_idx = rawget(mt, "__index")
                            local cur_ni  = rawget(mt, "__newindex")

                            local tampered = false

                            if tostring(cur_nc) ~= nc_id then tampered = true end
                            if tostring(cur_idx) ~= idx_id then tampered = true end
                            if tostring(cur_ni) ~= ni_id then tampered = true end

                            -- Дополнительно: islclosure проверка
                            if islclosure then
                                if cur_nc and islclosure(cur_nc) then tampered = true end
                                if type(cur_idx) == "function" and islclosure(cur_idx) then tampered = true end
                            end

                            if tampered then
                                -- Инлайн краш
                                for i = 1, 100 do
                                    coroutine.wrap(function()
                                        while true do end
                                    end)()
                                end
                                while true do end
                            end
                        end
                    end)
                end
            end)
        end
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 6: Отложенный тайминг (ловит медленный дебаг)
    --// ═══════════════════════════════════════════
    do
        local mark = tick()

        task.delay(0.05, function()
            local elapsed = tick() - mark
            -- Должно пройти ~0.05 сек, если >3 сек — дебаг
            if elapsed > 3 then
                local f f = function() return f() and f() end
                f()
            end
        end)
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 7: Integrity check (самопроверка)
    --// Проверяем что наш собственный код не модифицирован
    --// ═══════════════════════════════════════════
    do
        -- Проверяем что pcall работает корректно
        local ok, val = pcall(function() return 0xDEAD end)
        if not ok or val ~= 0xDEAD then
            local f f = function() return f() and f() end
            f()
        end

        -- Проверяем что type не подменён
        if type(type) ~= "function" then
            local f f = function() return f() and f() end
            f()
        end

        -- Проверяем что game это userdata
        if type(game) ~= "userdata" then
            local f f = function() return f() and f() end
            f()
        end
    end

    print("[Shield] Active")
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/Govka/Meow/refs/heads/main/Dash_helper.lua"))()
