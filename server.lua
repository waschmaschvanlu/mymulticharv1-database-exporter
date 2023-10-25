function updateidentifiers()
    Config = {}
    Config.Tables = {
        --{table = "phone_users_contacts", column = "identifier"},
        { table = "users", column = "identifier" },
        --  { table = "user_inventory", column = "identifier" },
    }
    Config.Prefix = "char"
    function getnewidentifier(identifier)
        newidentifier = Config.Prefix .. '%:' .. identifier

        local query = "SELECT COUNT(*) FROM users WHERE identifier LIKE '" .. newidentifier .. "'"

        result = MySQL.single.await(query)
        returnidentifier = Config.Prefix .. result["COUNT(*)"] + 1 .. ':' .. identifier
        return returnidentifier
    end

    for k, v in pairs(Config.Tables) do
        local query = "SELECT " .. v.column .. " FROM " .. v.table .. " WHERE " .. v.column .. " NOT LIKE '%:%'"
        result = MySQL.query.await(query)
        if #result == 0 or result == nil then
            print("no players found left to update")
        end
        for k, y in pairs(result) do
            print(getnewidentifier(y.identifier))
            print(y.identifier)

            local query = "UPDATE " ..
                v.table ..
                " SET " ..
                v.column ..
                " = '" .. getnewidentifier(y.identifier) .. "' WHERE " .. v.column .. " = '" .. y.identifier .. "'"
            MySQL.Async.execute(query)

            print("updated " .. y.identifier .. " to " .. getnewidentifier(y.identifier) .. " in " .. v.table)
        end
    end

    print(
    "if no error happened then ur ready to use mymulticharv2/v3! but.. if u have any issues please contact myScripts on Discord")
    if (GetResourceState("es_extended") == "started") then
        if (exports["es_extended"] and exports["es_extended"].getSharedObject) then
            ESX = exports["es_extended"]:getSharedObject()
        else
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        end
    end
    if ESX.GetConfig().Multichar == false then
        print("es_extended config multichar is not set to true, please set it to true")
    end

    local query = "CREATE TABLE IF NOT EXISTS `multicharacter_slots` ("
        .. "`identifier` VARCHAR(60) NOT NULL,"
        .. "`slots` INT(11) NOT NULL,"
        .. "PRIMARY KEY (`identifier`) USING BTREE,"
        .. "INDEX `slots` (`slots`) USING BTREE"
        .. ") ENGINE=InnoDB;"
    queryy = MySQL.Async.execute(query)
    if queryy then
        print("created multicharacter_slots table because you didnt have it")
    end

    local createTableQuery = [[
    CREATE TABLE IF NOT EXISTS `users` (
        `identifier` varchar(60) NOT NULL,
        `accounts` longtext DEFAULT NULL,
        `group` varchar(50) DEFAULT 'user',
        `inventory` longtext DEFAULT NULL,
        `job` varchar(20) DEFAULT 'unemployed',
        `job_grade` int(11) DEFAULT 0,
        `loadout` longtext DEFAULT NULL,
        `metadata` LONGTEXT NULL DEFAULT NULL,
        `position` longtext NULL DEFAULT NULL,
        `firstname` varchar(16) DEFAULT NULL,
        `lastname` varchar(16) DEFAULT NULL,
        `dateofbirth` varchar(10) DEFAULT NULL,
        `sex` varchar(1) DEFAULT NULL,
        `height` int(11) DEFAULT NULL,
        `skin` longtext DEFAULT NULL,
        `status` longtext DEFAULT NULL,
        `is_dead` tinyint(1) DEFAULT 0,
        `id` int(11) NOT NULL,
        `disabled` TINYINT(1) NULL DEFAULT '0',
        `last_property` varchar(255) DEFAULT NULL,
        `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
        `last_seen` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
        `phone_number` VARCHAR(20) DEFAULT NULL
    ) ENGINE=InnoDB
]]
    query2 = MySQL.Async.execute(createTableQuery)
    if query2 then
        print("fixed  users table because you didnt have all of the stuff")
    end

    -- Check and create columns if they don't exist
    local checkColumnsQuery = [[
        ALTER TABLE `users`
        ADD COLUMN IF NOT EXISTS `identifier` VARCHAR(90) DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `identifier` varchar(60) NOT NULL,
        ADD COLUMN IF NOT EXISTS `accounts` longtext DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `group` varchar(50) DEFAULT 'user',
        ADD COLUMN IF NOT EXISTS `inventory` longtext DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `job` varchar(20) DEFAULT 'unemployed',
        ADD COLUMN IF NOT EXISTS `job_grade` int(11) DEFAULT 0,
        ADD COLUMN IF NOT EXISTS `loadout` longtext DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `metadata` LONGTEXT NULL DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `position` longtext NULL DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `firstname` varchar(16) DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `lastname` varchar(16) DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `dateofbirth` varchar(10) DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `sex` varchar(1) DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `height` int(11) DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `skin` longtext DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `status` longtext DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `is_dead` tinyint(1) DEFAULT 0,
        ADD COLUMN IF NOT EXISTS `id` int(11) NOT NULL,
        ADD COLUMN IF NOT EXISTS `disabled` TINYINT(1) NULL DEFAULT '0',
        ADD COLUMN IF NOT EXISTS `last_property` varchar(255) DEFAULT NULL,
        ADD COLUMN IF NOT EXISTS `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
        ADD COLUMN IF NOT EXISTS `last_seen` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
        ADD COLUMN IF NOT EXISTS `phone_number` VARCHAR(20) DEFAULT NULL
    ]]
    query3 = MySQL.Async.execute(checkColumnsQuery)
    if query3 then
        print("checked and created columns in users if they don't exist")
    end
end

RegisterCommand('changeidentifiers', function(source, args, rawCommand)
    if source == 0 then
        updateidentifiers()
    end
end)
