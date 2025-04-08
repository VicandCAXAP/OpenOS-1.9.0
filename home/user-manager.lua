-- user-manager.lua
-- Скрипт для создания пользователей с домашними директориями в OpenComputers

local component = require("component")
local fs = require("filesystem")
local shell = require("shell")
local term = require("term")
local event = require("event")

-- Основные настройки
local USERS_DIR = "/Users/"
local DEFAULT_DIRS = {"home", "downloads", "documents"}

-- Функция для создания директорий пользователя
local function createUserDirs(username, basePath)
    local userPath = fs.concat(basePath, username)
    
    -- Создаем основную директорию пользователя
    if not fs.exists(userPath) then
        if not fs.makeDirectory(userPath) then
            return false, "Не удалось создать директорию пользователя"
        end
    end
    
    -- Создаем стандартные поддиректории
    for _, dir in ipairs(DEFAULT_DIRS) do
        local dirPath = fs.concat(userPath, dir)
        if not fs.exists(dirPath) then
            if not fs.makeDirectory(dirPath) then
                return false, "Не удалось создать директорию " .. dir
            end
        end
    end
    
    return true, userPath
end

-- Функция создания пользователя
local function createUser()
    term.clear()
    print("=== Создание нового пользователя ===")
    
    -- Запрос имени пользователя
    term.write("Введите имя пользователя: ")
    local username = term.read():gsub("^%s+", ""):gsub("%s+$", "")
    
    if username == "" then
        print("Имя пользователя не может быть пустым!")
        event.timer(2, function() end)
        return
    end
    
    -- Выбор места создания пользователя
    print("\nГде создать пользователя?")
    print("1. В корне диска (/" .. username .. ")")
    print("2. В папке Users (/Users/" .. username .. ")")
    term.write("Выберите вариант (1/2): ")
    
    local choice = tonumber(term.read())
    local basePath = ""
    
    if choice == 1 then
        basePath = "/"
    elseif choice == 2 then
        basePath = USERS_DIR
        -- Создаем папку Users если её нет
        if not fs.exists(USERS_DIR) then
            fs.makeDirectory(USERS_DIR)
        end
    else
        print("Неверный выбор!")
        event.timer(2, function() end)
        return
    end
    
    -- Создаем директории
    local success, message = createUserDirs(username, basePath)
    if not success then
        print("Ошибка: " .. message)
    else
        print("\nПользователь " .. username .. " успешно создан!")
        print("Домашняя директория: " .. message)
        
        -- Переходим в /Users/ после создания
        if fs.exists(USERS_DIR) then
            shell.setWorkingDirectory(USERS_DIR)
        end
    end
    
    event.timer(3, function() end)
end

-- Главное меню
local function mainMenu()
    while true do
        term.clear()
        print("=== Менеджер пользователей ===")
        print("1. Создать нового пользователя")
        print("2. Выход")
        print("Текущая директория: " .. shell.getWorkingDirectory())
        term.write("Выберите действие (1/2): ")
        
        local choice = tonumber(term.read())
        
        if choice == 1 then
            createUser()
        elseif choice == 2 then
            -- Переходим в /Users/ перед выходом
            if fs.exists(USERS_DIR) then
                shell.setWorkingDirectory(USERS_DIR)
            end
            term.clear()
            return
        else
            print("Неверный выбор!")
            event.timer(1, function() end)
        end
    end
end

-- Запуск программы
mainMenu()