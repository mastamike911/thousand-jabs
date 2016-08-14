local addonName, internal = ...;
local Z = LibStub('AceAddon-3.0'):NewAddon(addonName, 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0', 'LibProfiling-1.0')
internal.Z = Z
local consoleCommand = 'tj'

local error = error
local type = type
local pairs = pairs
local setmetatable = setmetatable
local format = string.format
local strmatch = strmatch
local tconcat = table.concat

local LTC = LibStub('LibTableCache-1.0')
local LUC = LibStub('LibUnitCache-1.0')
local LSM = LibStub('LibSharedMedia-3.0')

------------------------------------------------------------------------------------------------------------------------
-- Addon initialistion
------------------------------------------------------------------------------------------------------------------------

local devMode = false
Z:EnableProfiling(devMode)
Z:ProfileFunction(LUC, 'UpdateUnitCache', 'unitcache:UpdateUnitCache')
if devMode then _G['tj'] = Z end

------------------------------------------------------------------------------------------------------------------------
-- Local definitions
------------------------------------------------------------------------------------------------------------------------

local printedOnce = {}
local dbglist = {}

------------------------------------------------------------------------------------------------------------------------
-- Printing and debug functions
------------------------------------------------------------------------------------------------------------------------

function internal.formatHelper(fmt, ...)
    return ((select('#', ...) > 0) and format(fmt, ...) or fmt or '')
end
local formatHelper = internal.formatHelper

local oldprint = Z.Print
function Z:Print(...)
    oldprint(self, formatHelper(...))
end

function Z:PrintOnce(...)
    local text = formatHelper(...)
    if not printedOnce[text] then
        printedOnce[text] = true
        self:Print(text)
    end
end

function Z:Debug(...)
    if self.DB.do_debug then self:Print(formatHelper(...)) end
end

function Z:SetDebug(s)
    self.DB.do_debug = (s and true or false)
end

------------------------------------------------------------------------------------------------------------------------
-- Helpers
------------------------------------------------------------------------------------------------------------------------

function Z:LoadFunctionString(funcStr, name)
    local loader, errStr = loadstring(funcStr, name)
    if errStr then
        Z:PrintOnce('Error loading function for %s:\n%s', name, errStr)
    else
        local success, retval = pcall(assert(loader))
        if success then
            return retval
        else
            Z:PrintOnce('Error creating function for %s:\n%s', name, tostring(retval))
        end
    end
end

------------------------------------------------------------------------------------------------------------------------
-- Debug log
------------------------------------------------------------------------------------------------------------------------

function internal.DBG(...)
    if Z.DB.do_debug then
        if #dbglist == 0 then dbglist[1] = addonName .. ' Debug log (|cFF00FFFFhide with /'..consoleCommand..' _dbg|r):' end
        dbglist[1+#dbglist] = formatHelper(...)
    end
end

function internal.DBGR()
    wipe(dbglist)
end

function internal.DBGSTR()
    return tconcat(dbglist, '\n  ')
end

------------------------------------------------------------------------------------------------------------------------
-- Logging frame
------------------------------------------------------------------------------------------------------------------------

function Z:ShowLoggingFrame()
    if not self.log_frame then
        self.log_frame = CreateFrame("Frame", format("%sLog", addonName), UIParent)
        self.log_frame:ClearAllPoints()
        self.log_frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 550, -20)
        self.log_frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 20)
        self.log_frame.text = self.log_frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        self.log_frame.text:SetJustifyH("LEFT")
        self.log_frame.text:SetJustifyV("TOP")
        self.log_frame.text:SetPoint("TOPLEFT", 8, -8)
        self.log_frame.text:SetPoint("BOTTOMRIGHT", -8, 8)
        local f = LSM:Fetch("font", "mplus-1m-bold")
        if f then self.log_frame.text:SetFont(f, 9, "OUTLINE") end
    end

    self.log_frame:Show()
    self.log_frame.text:Show()
end

function Z:HideLoggingFrame()
    if self.log_frame then
        self.log_frame:Hide()
    end
end

function Z:UpdateLog()
    if self.DB.do_debug and self.log_frame then
        if self:ProfilingEnabled() then
            self.log_frame.text:SetText(self:GetProfilingString() .. '\n\n' .. internal.DBGSTR())
        else
            self.log_frame.text:SetText(internal.DBGSTR())
        end
    end
end

------------------------------------------------------------------------------------------------------------------------
-- Logged table, prints when accessing fields which don't exist
------------------------------------------------------------------------------------------------------------------------

local function targetFieldName(tableName, key)
    return type(key) == 'number' and format('%s[%d]', tableName, tostring(key)) or format('%s.%s', tableName, tostring(key))
end

local tableNames = {}
local missing = {}
local missingFieldMetatable = {
    __index = function(tbl, key)
        local tableName = (type(tableNames[tbl]) == 'string' and tableNames[tbl] or "UNKNOWN_TABLE")
        if not key then error(format('Attempted to index table "%s" with nil key.', tableName)) end
        if type(key) == 'table' then error(format('Attempted to index table "%s" with key of type table.\n%s', tableName, debugstack(1))) end
        if Z.DB and Z.DB.do_debug then
            local errTxt = format('Missing field: "%s":\n%s', targetFieldName(tableName, key), debugstack(2))
            if not missing[errTxt] then
                missing[errTxt] = true
                Z:Print(errTxt)
                if not IsAddOnLoaded('Blizzard_DebugTools') then LoadAddOn('Blizzard_DebugTools') end
                DevTools_Dump{[tableName]=tbl}
            end
        end
    end
}

function Z:MissingFieldTable(tableName, tbl)
    local k,v
    tableNames[tbl] = tableName
    setmetatable(tbl, missingFieldMetatable)
    for k,v in pairs(tbl) do
        if type(v) == 'table' then
            tbl[k] = self:MissingFieldTable(targetFieldName(tableName, k), v)
        end
    end
    return tbl
end

------------------------------------------------------------------------------------------------------------------------
-- Merge multiple tables together
------------------------------------------------------------------------------------------------------------------------

function Z:MergeTables(...)
    local t = {...}
    local target = {}
    for i=1,#t do
        local idx = #t-i+1
        if t[idx] then
            for k,v in pairs(t[idx]) do
                if not target[k] then target[k] = v end
            end
        end
    end
    return target
end

------------------------------------------------------------------------------------------------------------------------
-- Console command
------------------------------------------------------------------------------------------------------------------------
function Z:ConsoleCommand(args)
    if args == "move" then
        if self.movable then
            self.movable = false
            self:Print('Frame movement disabled.')
        else
            self.movable = true
            self:Print('Frame movement enabled.')
        end
        self.actionsFrame:SetMovable(self.movable)
        self.actionsFrame:EnableMouse(self.movable)
    elseif args == "resetpos" then
        self:Print('Resetting position.')
        self.actionsFrame:ClearAllPoints()
        self.actionsFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, -180)
        self.actionsFrame:SetMovable(self.movable)
        self.actionsFrame:EnableMouse(self.movable)
        self.DB.x, self.DB.y = self.actionsFrame:GetLeft(), self.actionsFrame:GetBottom()
    elseif args == "_dbg" then
        if self.DB.do_debug then
            self.DB.do_debug = false
            self:HideLoggingFrame()
            self:Print('Debugging info disabled. Enable with "|cFFFF6600/%s _dbg|r".', consoleCommand)
        else
            self.DB.do_debug = true
            self:ShowLoggingFrame()
            self:Print('Debugging info enabled. Disable with "|cFFFF6600/%s _dbg|r".', consoleCommand)
        end
    elseif args == '_dtc' then
        self:Print('Dumping table cache metrics:')
        self:Print(' - Total allocated: %d, total acquired: %d, total released: %d, total in-use: %d',
            LTC.TableCache.TotalAllocated, LTC.TableCache.TotalAcquired, LTC.TableCache.TotalReleased, LTC.TableCache.TotalAcquired - LTC.TableCache.TotalReleased)
    elseif args == '_db' then
        self:Print('Dumping SavedVariables table:')
        if not IsAddOnLoaded('Blizzard_DebugTools') then LoadAddOn('Blizzard_DebugTools') end
        DevTools_Dump{db=self.DB}
    elseif args == '_duc' then
        self:Print('Dumping unit cache table:')
        if not IsAddOnLoaded('Blizzard_DebugTools') then LoadAddOn('Blizzard_DebugTools') end
        DevTools_Dump{unitCache=LUC.unitCache}
    elseif args == '_mem' then
        UpdateAddOnMemoryUsage()
        self:Print('Memory usage: %d kB', GetAddOnMemoryUsage(addonName))
    else
      self:Print('%s chat commands:', addonName)
      self:Print("     |cFFFF6600/tj move|r - Toggles frame moving.")
      self:Print("     |cFFFF6600/tj resetpos|r - Resets frame positioning to default.")
      self:Print('%s debugging:', addonName)
      self:Print('     |cFFFF6600/%s _dbg|r - Toggles debug information visibility.', consoleCommand)
      self:Print('     |cFFFF6600/%s _dtc|r - Dumps table cache information.', consoleCommand)
      self:Print('     |cFFFF6600/%s _db|r - Dumps SavedVariables table.', consoleCommand)
      self:Print('     |cFFFF6600/%s _duc|r - Dumps unit cache table.', consoleCommand)
      self:Print('     |cFFFF6600/%s _mem|r - Dumps addon memory usage.', consoleCommand)
    end
end
Z:RegisterChatCommand(consoleCommand, 'ConsoleCommand')
