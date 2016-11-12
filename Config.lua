local addonName, internal = ...;
local TJ = internal.TJ
local Debug = internal.Debug
local fmt = internal.fmt
local Config = TJ:GetModule('Config')
local UI = TJ:GetModule('UI')
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local select = select
local type = type

local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

internal.Safety()

local defaultConf = {
    allowBetaProfiles = false,
    showCleave = true,
    showAoE = true,
    inCombatAlpha = 1,
    outOfCombatAlpha = 1,
    backgroundOpacity = 0.3,
    geometry = {
        singleTargetSize = 80,
        cleaveSize = 40,
        aoeSize = 35,
        sizeDecrease = 0.7,
        padding = 4,
        scale = 1,
    },
    position = {
        offsetX = 0,
        offsetY = -180,
        tgtPoint = "CENTER",
    },
    do_debug = false,
}


function Config:OpenDialog()
    ACD:Open(addonName)
    ACD:SelectGroup(addonName, "general")
end

function Config:Upgrade()
    -- Added Geometry:
    if type(Config:Get("scale")) ~= "nil" then
        Config:Set(Config:Get("scale"), "geometry", "scale")
        Config:Set(nil, "scale")
        Config:Set(Config:Get("padding"), "geometry", "padding")
        Config:Set(nil, "padding")
    end
end

local function getconf(tbl, key, ...)
    if select('#', ...) == 0 then return tbl[key] end
    local e = tbl[key]
    if type(e) == "nil" then return nil end
    return getconf(e, ...)
end

local function setconf(value, tbl, ...)
    local keys = {...}
    local p = tbl
    for i=1,#keys-1 do
        if not p[keys[i]] then p[keys[i]] = {} end
        p = p[keys[i]]
    end
    p[keys[#keys]] = value
end

function Config:Get(...)
    ThousandJabsDB = ThousandJabsDB or {}
    local res = getconf(ThousandJabsDB, ...)
    if type(res) == "nil" then res = getconf(defaultConf, ...) end
    return res
end

function Config:Set(value, ...)
    ThousandJabsDB = ThousandJabsDB or {}
    setconf(value, ThousandJabsDB, ...)
end

function Config:GetSpec(e)
    local classID, specID = select(3, UnitClass('player')), GetSpecialization()
    return Config:Get("class", classID, "spec", specID, "config", e)
end

function Config:SetSpec(value, e)
    local classID, specID = select(3, UnitClass('player')), GetSpecialization()
    Config:Set(value, "class", classID, "spec", specID, "config", e)
end

function internal.trim(s)
    return ((s or ""):gsub("^%s*(.-)%s*$", "%1"))
end

AC:RegisterOptionsTable(addonName, function()
    local options = {
        name = "Thousand Jabs",
        handler = TJ,
        type = "group",
        order = 1,
        args = {
            general = {
                name = L["General Settings"],
                type = "group",
                order = 1,
                args = {
                    generalHeader = {
                        type = "header",
                        name = L["General Settings"],
                        order = 100,
                    },
                    lockunlock = {
                        type = "execute",
                        order = 101,
                        name = L["Toggle Lock"],
                        func = function()
                            UI:ToggleMovement()
                        end
                    },
                    resetpos = {
                        type = "execute",
                        order = 102,
                        name = L["Reset Position"],
                        func = function()
                            UI:ResetPosition()
                        end
                    },
                    showCleave = {
                        type = "toggle",
                        order = 103,
                        name = L["Show Cleave Abilties"],
                        get = function(info)
                            return Config:Get("showCleave") and true or false
                        end,
                        set = function(info, val)
                            Config:Set(val and true or false, "showCleave")
                            UI:ReapplyLayout()
                        end
                    },
                    showAoE = {
                        type = "toggle",
                        order = 104,
                        name = L["Show AoE Abilties"],
                        get = function(info)
                            return Config:Get("showAoE") and true or false
                        end,
                        set = function(info, val)
                            Config:Set(val and true or false, "showAoE")
                            UI:ReapplyLayout()
                        end
                    },
                    backgroundOpacity = {
                        type = "range",
                        order = 105,
                        name = L["Background Opacity"],
                        min = 0.0,
                        max = 1.0,
                        step = 0.05,
                        get = function(info)
                            return Config:Get("backgroundOpacity")
                        end,
                        set = function(info, val)
                            Config:Set(val, "backgroundOpacity")
                            UI:ReapplyLayout()
                        end
                    },
                    outOfCombatHide = {
                        type = "toggle",
                        order = 106,
                        name = L["Hide out-of-combat"],
                        get = function(info)
                            return (Config:Get("outOfCombatAlpha") == 0) and true or false
                        end,
                        set = function(info, val)
                            Config:Set(val and 0 or 1, "outOfCombatAlpha")
                            UI:UpdateAlpha()
                        end
                    },
                    allowBetaProfiles = {
                        type = "toggle",
                        order = 107,
                        name = L["Allow Beta Profiles"],
                        get = function(info)
                            return Config:Get("allowBetaProfiles") and true or false
                        end,
                        set = function(info, val)
                            Config:Set(val and true or false, "allowBetaProfiles")
                            TJ:DeactivateProfile()
                            TJ:ActivateProfile()
                        end
                    },
                    fadingHeader = {
                        type = "header",
                        name = L["Fading"],
                        order = 200,
                    },
                    inCombatAlpha = {
                        type = "range",
                        order = 201,
                        name = L["In-combat alpha"],
                        min = 0,
                        max = 1,
                        step = 0.05,
                        get = function(info)
                            return Config:Get("inCombatAlpha")
                        end,
                        set = function(info, val)
                            Config:Set(val, "inCombatAlpha")
                            UI:UpdateAlpha()
                        end
                    },
                    outOfCombatAlpha = {
                        type = "range",
                        order = 202,
                        name = L["Out-of-combat alpha"],
                        min = 0,
                        max = 1,
                        step = 0.05,
                        get = function(info)
                            return Config:Get("outOfCombatAlpha")
                        end,
                        set = function(info, val)
                            Config:Set(val, "outOfCombatAlpha")
                            UI:UpdateAlpha()
                        end
                    },
                    geometryHeader = {
                        type = "header",
                        name = L["Geometry"],
                        order = 300,
                    },
                    scale = {
                        type = "range",
                        order = 301,
                        name = L["Window Scale"],
                        min = 0.5,
                        max = 2.0,
                        step = 0.05,
                        get = function(info)
                            return Config:Get("geometry", "scale")
                        end,
                        set = function(info, val)
                            Config:Set(val, "geometry", "scale")
                            UI:ReapplyLayout()
                        end
                    },
                    singleTargetSize = {
                        type = "range",
                        order = 302,
                        name = L["Single-target Size"],
                        min = 20,
                        max = 300,
                        step = 1,
                        get = function(info)
                            return Config:Get("geometry", "singleTargetSize")
                        end,
                        set = function(info, val)
                            Config:Set(val, "geometry", "singleTargetSize")
                            UI:ReapplyLayout()
                        end
                    },
                    cleaveSize = {
                        type = "range",
                        order = 303,
                        name = L["Cleave Size"],
                        min = 20,
                        max = 300,
                        step = 1,
                        get = function(info)
                            return Config:Get("geometry", "cleaveSize")
                        end,
                        set = function(info, val)
                            Config:Set(val, "geometry", "cleaveSize")
                            UI:ReapplyLayout()
                        end
                    },
                    aoeSize = {
                        type = "range",
                        order = 304,
                        name = L["AoE Size"],
                        min = 20,
                        max = 300,
                        step = 1,
                        get = function(info)
                            return Config:Get("geometry", "aoeSize")
                        end,
                        set = function(info, val)
                            Config:Set(val, "geometry", "aoeSize")
                            UI:ReapplyLayout()
                        end
                    },
                    nextScale = {
                        type = "range",
                        order = 305,
                        name = L["Next Ability Scale"],
                        min = 0.1,
                        max = 1.0,
                        step = 0.01,
                        get = function(info)
                            return Config:Get("geometry", "sizeDecrease")
                        end,
                        set = function(info, val)
                            Config:Set(val, "geometry", "sizeDecrease")
                            UI:ReapplyLayout()
                        end
                    },
                    padding = {
                        type = "range",
                        order = 306,
                        name = L["Padding"],
                        min = 0,
                        max = 20,
                        step = 1,
                        get = function(info)
                            return Config:Get("geometry", "padding")
                        end,
                        set = function(info, val)
                            Config:Set(val, "geometry", "padding")
                            UI:ReapplyLayout()
                        end
                    },
                    resetGeometry = {
                        type = "execute",
                        order = 307,
                        name = L["Reset Geometry"],
                        func = function()
                            Config:Set(nil, "geometry")
                            UI:ReapplyLayout()
                        end
                    },
                },
            },
        }
    }

    for specID=1,GetNumSpecializations() do
        local _, _, classID = UnitClass("player")
        local _, specName, _, specIcon = GetSpecializationInfo(specID)
        local thisSpecOptions = {
            name = internal.fmt("\124T%s:0|t %s", specIcon, specName),
            type = "group",
            order = 1000+specID,
            args = {
                specHeader = {
                    type = "header",
                    name = L["Specialisation Settings"],
                    order = 1000,
                },
                profileDisabled = {
                    type = "toggle",
                    order = 1001,
                    name = L["Disable Specialisation"],
                    get = function(info)
                        return Config:Get("class", classID, "spec", specID, "disabled") and true or false
                    end,
                    set = function(info, val)
                        Config:Set(val and true or false, "class", classID, "spec", specID, "disabled")
                        TJ:DeactivateProfile()
                        TJ:ActivateProfile()
                    end
                },
            },
        }

        local profile = TJ.profiles and TJ.profiles[classID] and TJ.profiles[classID][specID] or nil

        if profile and profile.configCheckboxes then
            local order = 2000
            thisSpecOptions.args.specConfigHeader = {
                type = "header",
                name = L["Specialisation Configuration"],
                order = order,
            }

            for e, v in pairs(profile.configCheckboxes) do
                order = order + 1
                if type(v) == "boolean" then
                    thisSpecOptions.args[e] = {
                        type = "toggle",
                        order = order,
                        name = e,
                        get = function(info)
                            return Config:Get("class", classID, "spec", specID, "config", e) and true or false
                        end,
                        set = function(info, val)
                            Config:Set(val and true or false, "class", classID, "spec", specID, "config", e)
                            TJ:DeactivateProfile()
                            TJ:ActivateProfile()
                            TJ:QueueUpdate()
                        end
                    }
                elseif type(v) == "table" and #v == 2 and type(v[1]) == "number" and type(v[2]) == "number" then
                    thisSpecOptions.args[e] = {
                        type = "range",
                        order = order,
                        name = e,
                        min = v[1],
                        max = v[2],
                        get = function(info)
                            return Config:Get("class", classID, "spec", specID, "config", e)
                        end,
                        set = function(info, val)
                            Config:Set(val, "class", classID, "spec", specID, "config", e)
                            TJ:DeactivateProfile()
                            TJ:ActivateProfile()
                            TJ:QueueUpdate()
                        end
                    }
                end
            end
        end

        if profile and profile.parsedActions then
            local order = 3000
            thisSpecOptions.args.abilityHeader = {
                type = "header",
                name = L["Ability Disabling"],
                order = order,
            }
            local allActions = {}

            for aplName,apl in pairs(profile.parsedActions) do
                for _, entry in pairs(apl) do
                    local action = rawget(profile.actions, entry.action)
                    if action then
                        allActions[--[[action.Name or]] entry.action] = entry.action
                    end
                end
            end

            for k,v in internal.orderedpairs(allActions) do
                order = order + 1
                thisSpecOptions.args[k] = {
                    type = "toggle",
                    order = order,
                    name = k,
                    get = function(info)
                        return Config:Get("class", classID, "spec", specID, "blacklist", k) and true or false
                    end,
                    set = function(info, val)
                        Config:Set(val and true or false, "class", classID, "spec", specID, "blacklist", k)
                        TJ:DeactivateProfile()
                        TJ:ActivateProfile()
                        TJ:QueueUpdate()
                    end
                }
            end
        end

        options.args[specName] = thisSpecOptions
    end

    return options
end)
ACD:AddToBlizOptions(addonName, "Thousand Jabs")
