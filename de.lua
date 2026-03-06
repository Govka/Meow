--// ╔══════════════════════════════════════════════╗
--// ║   ANTI-DEBUG SYSTEM v2 — CRASH ON DETECT    ║
--// ║   Ставится ПЕРЕД основным скриптом           ║
--// ╚══════════════════════════════════════════════╝

do
    -- Функция краша — бесконечный loop, Roblox зависнет намертво
    local function CRASH()
        -- Способ 1: Бесконечный цикл (главный)
        -- repeat until false тоже работает, но while надёжнее
        spawn(function()
            while true do
                -- Спамим Instance чтобы память забить
                Instance.new("Part", Instance.new("Folder"))
                Instance.new("Part", Instance.new("Folder"))
                Instance.new("Part", Instance.new("Folder"))
            end
        end)

        spawn(function()
            while true do
                -- Второй поток — тоже жрёт память
                local t = {}
                for i = 1, 999999 do
                    t[i] = string.rep("X", 9999)
                end
            end
        end)

        -- Основной поток тоже вешаем
        while true do end
    end


    --// ═══════════ ПРОВЕРКА 1: debug библиотека ═══════════
    do
        local dangerous = {
            "sethook", "getregistry", "setlocal",
            "setupvalue", "getlocal", "getupvalue",
            "setfenv", "traceback", "getinfo"
        }

        if debug then
            for _, name in ipairs(dangerous) do
                if debug[name] then
                    -- Перезаписываем — если кто-то вызовет = краш
                    debug[name] = function()
                        CRASH()
                    end
                end
            end
        end
    end


    --// ═══════════ ПРОВЕРКА 2: Spy инструменты в CoreGui ═══════════
    do
        local spy_names = {
            "remotespy", "simplespy", "httpspy", "dex",
            "explorer", "infinity", "spy", "debug",
            "monitor", "hydroxide", "scriptdump",
            "dumper", "decompile", "output"
        }

        spawn(function()
            while task.wait(1) do
                local ok, core = pcall(function()
                    return game:GetService("CoreGui")
                end)

                if ok and core then
                    for _, child in ipairs(core:GetChildren()) do
                        local lower = child.Name:lower()
                        for _, spy in ipairs(spy_names) do
                            if lower:find(spy) then
                                -- Нашли шпиона — краш
                                CRASH()
                            end
                        end
                    end
                end
            end
        end)
    end


    --// ═══════════ ПРОВЕРКА 3: Тайминг (пошаговый дебаг) ═══════════
    -- Если кто-то идёт по строкам в дебаггере — между точками будет задержка
    do
        local t1 = tick()

        -- Делаем бесполезные операции (дебаггер на них тормозит)
        local _ = tostring(game)
        local _ = type(workspace)
        local _ = typeof(Vector3.new())
        local _ = tostring(tick())
        local _ = game:GetService("Players")

        local t2 = tick()

        -- Нормальное выполнение = <0.1 сек
        -- Дебаг пошагово = обычно >1 сек
        if (t2 - t1) > 0.5 then
            CRASH()
        end
    end


    --// ═══════════ ПРОВЕРКА 4: hookfunction / hookmetamethod ═══════════
    -- Если кто-то хукает функции — значит дебажит/модифицирует
    do
        local hook_tools = {
            "hookfunction", "hookmetamethod", "replaceclosure",
            "detour_function", "hookfunc"
        }

        -- Проверяем наличие хук-инструментов
        for _, tool_name in ipairs(hook_tools) do
            if getgenv and getgenv()[tool_name] then
                -- Хук-инструмент найден — ставим ловушку
                local original_tool = getgenv()[tool_name]

                -- Перехватываем сам хук-инструмент
                getgenv()[tool_name] = function(...)
                    CRASH()
                end
            end
        end
    end


    --// ═══════════ ПРОВЕРКА 5: getrawmetatable подмена ═══════════
    do
        if getrawmetatable then
            local mt = getrawmetatable(game)
            if mt then
                spawn(function()
                    local original_namecall = rawget(mt, "__namecall")
                    local original_index = rawget(mt, "__index")

                    while task.wait(2) do
                        local current_nc = rawget(mt, "__namecall")
                        local current_idx = rawget(mt, "__index")

                        -- Если кто-то подменил __namecall
                        if current_nc ~= original_namecall then
                            CRASH()
                        end

                        -- Если кто-то подменил __index
                        if current_idx ~= original_index then
                            CRASH()
                        end
                    end
                end)
            end
        end
    end


    --// ═══════════ ПРОВЕРКА 6: Второй тайминг-чек (отложенный) ═══════════
    do
        local start = tick()

        spawn(function()
            task.wait(0.1) -- ждём 0.1 сек

            local elapsed = tick() - start

            -- Если прошло сильно больше 0.1 — кто-то тормозил выполнение
            if elapsed > 2 then
                CRASH()
            end
        end)
    end


    --// ═══════════ ПРОВЕРКА 7: pcall/xpcall подмена ═══════════
    do
        -- Проверяем что pcall не хукнут
        local test_ok, test_result = pcall(function()
            return 42
        end)

        if not test_ok or test_result ~= 42 then
            CRASH()
        end
    end

    print("[AntiDebug] Shield active")
end

--// ╔══════════════════════════════════════════════╗
--// ║   НИЖЕ СТАВЬ СВОЙ ОСНОВНОЙ СКРИПТ           ║
--// ╚══════════════════════════════════════════════╝


loadstring(game:HttpGet("https://raw.githubusercontent.com/Govka/Meow/refs/heads/main/Dash_helper.lua"))()
