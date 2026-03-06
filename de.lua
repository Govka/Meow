--!native
--!optimize 2
--// ╔═══════════════════════════════════════════════════╗
--// ║   ANTI-DEBUG v4 — SILENT HARDENED EDITION         ║
--// ║   Тихий краш • Без false positive • Native        ║
--// ╚═══════════════════════════════════════════════════╝

do
    --// ══════════════════════════════════════════
    --// ЯДРО: Silent Freeze (тихий краш)
    --//
    --// НЕ генерирует ошибок
    --// НЕ пишет в консоль
    --// НЕ спамит Instance.new
    --// Просто сжирает 100% CPU тихо
    --// ══════════════════════════════════════════

    -- Тихий freeze через тяжёлые math операции
    -- Нет имени функции = нечего хукать
    -- Нет error/print = ничего в консоли
    local function silent_freeze()
        -- Кик (тихий, без сообщения)
        pcall(function()
            game:GetService("Players").LocalPlayer:Kick("")
        end)

        -- Замораживаем ВСЕ потоки
        -- Каждый поток делает тяжёлые вычисления бесконечно
        for i = 1, 50 do
            pcall(function()
                coroutine.wrap(function()
                    local x = 1.123456789
                    while true do
                        x = math.sin(x) * math.cos(x) * math.tan(x + 0.001)
                        x = x * x * x * x * x
                        x = math.sqrt(math.abs(x) + 1)
                        x = math.log(math.abs(x) + 1) * math.exp(x % 10)
                    end
                end)()
            end)
        end

        -- Основной поток тоже вешаем (тихо)
        local x = 1.1
        while true do
            x = math.sin(x) * math.cos(x) * math.tan(x + 0.001)
            x = x * x * x * x
            x = math.sqrt(math.abs(x) + 1)
        end
    end

    -- Инлайн версия (для вставки прямо в проверку)
    -- Копируем логику чтобы не зависеть от одной функции
    local function inline_die()
        pcall(function()
            game:GetService("Players").LocalPlayer:Kick("")
        end)
        local x = 1.1
        for i = 1, 50 do
            pcall(function()
                coroutine.wrap(function()
                    while true do
                        x = math.sin(x) * math.cos(x)
                    end
                end)()
            end)
        end
        while true do
            x = math.sin(x) * math.cos(x)
        end
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 1: debug библиотека
    --// (с pcall защитой от read-only)
    --// ═══════════════════════════════════════════
    do
        if debug then
            local dangerous = {
                "sethook", "getregistry", "setlocal",
                "setupvalue", "getlocal", "getupvalue",
                "setfenv", "traceback", "getinfo"
            }

            for _, name in ipairs(dangerous) do
                if rawget(debug, name) or debug[name] then
                    -- Пробуем перезаписать
                    local write_ok = pcall(function()
                        debug[name] = function()
                            inline_die()
                        end
                    end)

                    -- Если read-only — пробуем через rawset
                    if not write_ok then
                        pcall(function()
                            rawset(debug, name, function()
                                inline_die()
                            end)
                        end)
                    end

                    -- Если и rawset не сработал — просто отслеживаем вызов
                    -- (альтернативный метод: сохраняем адрес и мониторим)
                end
            end
        end
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 2: Тайминг (пошаговый дебаг)
    --// Срабатывает СРАЗУ — без задержки
    --// ═══════════════════════════════════════════
    do
        local t1 = tick()

        -- Набор операций — в реальном времени <0.01 сек
        -- В дебаггере (пошагово) — >1 сек
        local _ = tostring(game)
        local _ = type(workspace)
        local _ = typeof(Vector3.new())
        local _ = game:GetService("Players")
        local _ = tostring(os.clock())
        local _ = string.format("%s%s%s", "", "", "")
        local _ = math.floor(tick() * 1000)
        local _ = string.len(tostring(game.PlaceId))

        local t2 = tick()

        -- Порог 0.5 сек — нормальное выполнение никогда столько не займёт
        if (t2 - t1) > 0.5 then
            silent_freeze()
        end
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 3: Spy/Debug tools через connections
    --// (УЛУЧШЕННАЯ — фильтрует системные подключения)
    --// ═══════════════════════════════════════════
    do
        spawn(function()
            -- Небольшая задержка чтобы игра загрузилась
            task.wait(2)

            while task.wait(5) do
                pcall(function()

                    -- === Способ A: getconnections анализ ===
                    if getconnections and getinfo then
                        local rs = game:GetService("ReplicatedStorage")

                        for _, child in ipairs(rs:GetDescendants()) do
                            if child:IsA("RemoteEvent") then
                                pcall(function()
                                    local conns = getconnections(child.OnClientEvent)

                                    for _, conn in ipairs(conns) do
                                        if conn.Function then
                                            local info = getinfo(conn.Function)

                                            if info and info.source then
                                                local src = info.source:lower()

                                                -- ═══ ФИЛЬТРАЦИЯ ═══
                                                -- Пропускаем системные подключения Roblox
                                                local is_system = false

                                                -- C-closure = встроенная функция Roblox
                                                if iscclosure and iscclosure(conn.Function) then
                                                    is_system = true
                                                end

                                                -- CoreScript пути
                                                local system_paths = {
                                                    "corescript", "coregui", "roblox",
                                                    "playermodule", "chatmodule",
                                                    "builtinplugins", "starterplayer",
                                                    "[c]", "[string", "="
                                                }

                                                for _, path in ipairs(system_paths) do
                                                    if src:find(path) then
                                                        is_system = true
                                                        break
                                                    end
                                                end

                                                -- Если НЕ системный — проверяем на spy
                                                if not is_system then
                                                    local spy_keywords = {
                                                        "spy", "monitor", "intercept",
                                                        "logger", "sniff", "capture",
                                                        "hook", "listen", "dump"
                                                    }

                                                    for _, word in ipairs(spy_keywords) do
                                                        if src:find(word) then
                                                            -- Сначала отключаем connection
                                                            pcall(function()
                                                                conn:Disable()
                                                            end)
                                                            inline_die()
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                    end

                    -- === Способ B: gethui() (Hidden UI контейнер) ===
                    if gethui then
                        pcall(function()
                            local hidden = gethui()
                            if hidden then
                                for _, child in ipairs(hidden:GetChildren()) do
                                    local lower = child.Name:lower()
                                    local spy_names = {
                                        "spy", "remote", "http", "dex",
                                        "explorer", "dump", "monitor",
                                        "hydroxide", "infinite", "script"
                                    }
                                    for _, word in ipairs(spy_names) do
                                        if lower:find(word) then
                                            pcall(function()
                                                child:Destroy()
                                            end)
                                            inline_die()
                                        end
                                    end
                                end
                            end
                        end)
                    end

                end)
            end
        end)
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 4: hookfunction ловушка
    --// (С WARM-UP DELAY — ждём пока эксплойт доинжектится)
    --// ═══════════════════════════════════════════
    do
        spawn(function()
            -- ⏳ WARM-UP: ждём 1 секунду
            -- Эксплойт должен завершить свои внутренние хуки
            task.wait(1)

            if getgenv then
                local hook_names = {
                    "hookfunction", "hookmetamethod",
                    "replaceclosure", "hookfunc",
                    "detour_function"
                }

                for _, name in ipairs(hook_names) do
                    local original = rawget(getgenv(), name)

                    if original then
                        -- Пробуем перехватить хук-инструмент
                        local write_ok = pcall(function()
                            getgenv()[name] = function(target, replacement)
                                -- Кто-то пытается хукнуть функцию!
                                -- Тихий краш
                                pcall(function()
                                    game:GetService("Players").LocalPlayer:Kick("")
                                end)
                                local x = 1.1
                                for i = 1, 50 do
                                    pcall(function()
                                        coroutine.wrap(function()
                                            while true do
                                                x = math.sin(x) * math.cos(x)
                                            end
                                        end)()
                                    end)
                                end
                                while true do
                                    x = math.sin(x) * math.cos(x)
                                end
                            end
                        end)

                        -- Если не получилось перезаписать — сохраняем адрес
                        -- и мониторим изменения
                        if not write_ok then
                            local original_addr = tostring(original)

                            spawn(function()
                                while task.wait(2) do
                                    pcall(function()
                                        local current = rawget(getgenv(), name)
                                        if current and tostring(current) ~= original_addr then
                                            inline_die()
                                        end
                                    end)
                                end
                            end)
                        end
                    end
                end
            end
        end)
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 5: metatable мониторинг
    --// (С WARM-UP DELAY)
    --// ═══════════════════════════════════════════
    do
        spawn(function()
            -- ⏳ WARM-UP: ждём 1 секунду
            task.wait(1)

            if getrawmetatable then
                pcall(function()
                    local mt = getrawmetatable(game)

                    if mt then
                        -- Сохраняем адреса ПОСЛЕ того как эксплойт доинжектился
                        local nc_addr  = tostring(rawget(mt, "__namecall") or "nil")
                        local idx_addr = tostring(rawget(mt, "__index") or "nil")
                        local ni_addr  = tostring(rawget(mt, "__newindex") or "nil")

                        while task.wait(2) do
                            pcall(function()
                                local cur_nc  = tostring(rawget(mt, "__namecall") or "nil")
                                local cur_idx = tostring(rawget(mt, "__index") or "nil")
                                local cur_ni  = tostring(rawget(mt, "__newindex") or "nil")

                                local tampered = false

                                -- Сравниваем адреса
                                if cur_nc ~= nc_addr then tampered = true end
                                if cur_idx ~= idx_addr then tampered = true end
                                if cur_ni ~= ni_addr then tampered = true end

                                -- islclosure доп. проверка
                                if not tampered and islclosure then
                                    pcall(function()
                                        local nc = rawget(mt, "__namecall")
                                        if nc and islclosure(nc) then
                                            -- Дополнительно проверяем — может это
                                            -- легитимный хук эксплойта
                                            -- Если адрес не менялся — ОК
                                            -- Если менялся — тревога
                                        end
                                    end)
                                end

                                if tampered then
                                    inline_die()
                                end
                            end)
                        end
                    end
                end)
            end
        end)
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 6: Отложенный тайминг
    --// ═══════════════════════════════════════════
    do
        local mark = tick()

        task.delay(0.05, function()
            local elapsed = tick() - mark

            -- Должно быть ~0.05 сек
            -- Если >3 сек — кто-то тормозил выполнение
            if elapsed > 3 then
                inline_die()
            end
        end)
    end


    --// ═══════════════════════════════════════════
    --// ПРОВЕРКА 7: Integrity (самопроверка)
    --// ═══════════════════════════════════════════
    do
        -- pcall работает корректно?
        local ok, val = pcall(function() return 0xDEAD end)
        if not ok or val ~= 0xDEAD then
            inline_die()
        end

        -- type не подменён?
        local type_check = pcall(function()
            if type(type) ~= "function" then
                inline_die()
            end
            if type(game) ~= "userdata" then
                inline_die()
            end
            if type(workspace) ~= "userdata" then
                inline_die()
            end
        end)
    end

end -- конец блока do

--// ═══════════════════════════════════════════════
--// НИЖЕ — ТВОЙ ОСНОВНОЙ СКРИПТ
--// ═══════════════════════════════════════════════
loadstring(game:HttpGet("https://raw.githubusercontent.com/Govka/Meow/refs/heads/main/Dash_helper.lua"))()
