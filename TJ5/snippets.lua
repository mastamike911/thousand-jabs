-- /run LibStub('LibSandbox-5.0'):GetSandbox('TJ5').TJ:ExportDebuggingInformation()
local LSD = LibStub("LibSerpentDump-5.0")
local TJ5 = LibStub('LibSandbox-5.0'):GetSandbox('TJ5')
local TJ5_mt = getmetatable(TJ5)
local TJ = TJ5.TJ
local Engine = TJ5.Engine
local start
local function Metrics()
    local TC = TJ5.TableCache.TableCache
    TJ:Print('Table Cache - Total allocated: %d, total acquired: %d, total released: %d, total in-use: %d', TC.TotalAllocated, TC.TotalAcquired, TC.TotalReleased, TC.TotalAcquired - TC.TotalReleased)
end

TJ5.TJ:DevPrint('#################################################')
TJ5.TJ:DevPrint('--------------- checkpoint start --------------- ')
local beginRun = debugprofilestop()

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Generic stuff
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
--DevTools_Dump{TJ5DB=TJ5DB,TJ5=TJ5,TJ5_mt=TJ5_mt}
DevTools_Dump{TJ_globalReadNames=TJ.globalReadNames}
TJ:ExportDebuggingInformation()
--]]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- APL parsing
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
TJ5.TJ:DevPrint('--------------- pre-APL --------------- ')
start = debugprofilestop()
local apl = LibStub('AceAddon-3.0'):GetAddon('ThousandJabs').profileDefinitions['simc::mage::frost'].aplData
print(apl)
local res = TJ:ExpressionParser(apl)
--DevTools_Dump{res=res}
local tmp = TJ5.CT()
for k,v in TJ:OrderedPairsTC(res, tmp) do
print(k)
end
TJ5.RT(tmp)
TJ5.RT(res)
TJ5.TJ:DevPrint('--------------- post-APL --------------- (dt=%dms)', debugprofilestop()-start)
--]]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Defaults/fallback tables
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
local function EvalDumpRelease(tbl)
local tmp = tbl:Evaluate(TJ5.CT)
DevTools_Dump{tbl=tmp}--,mt=getmetatable(tbl)}
TJ5.RT(tmp)
end
local f = TJ:CreateDefaultsTable('zzz', { default1 = function() return 'visible_func' end }, { default2 = 'visible' }, { default1 = 'invisible' })
local g = TJ:CreateDefaultsTable('yyy', f, { default3 = 'visible' }, { default1 = 'invisible', f = f }, { default2 = 'invisible' })
TJ5.TJ:DevPrint('--------------- pre-assign/reset --------------- ')
start = debugprofilestop()
--EvalDumpRelease(g)
f.a = 99
g.f.ppp =5
g.x = 9
f.default1 = 'override'
g.default1 = 'override'
f.newvalue1 = 'override'
--EvalDumpRelease(g)
g:Reset()
--EvalDumpRelease(g)
TJ5.TJ:DevPrint('--------------- post-assign/reset --------------- (dt=%dms)', debugprofilestop()-start)
--]]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Test message notifications
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
-- /run LibStub('LibSandbox-5.0'):GetSandbox('TJ5').Engine:ActivateProfile()
--Engine:ActivateProfile()
--DevTools_Dump{profile=Engine.activeProfile or 'none'}
--DevTools_Dump{eventHandlers=TJ5.TJ.eventSystem}
TJ5.TJ:DevPrint('--------------- pre-notify --------------- ')
UpdateAddOnMemoryUsage()
start = debugprofilestop()
local oldMem = GetAddOnMemoryUsage('TJ5')
for i=1,10000 do TJ5.TJ:Notify('TempCallback', 8, 3) end
UpdateAddOnMemoryUsage()
local newMem = GetAddOnMemoryUsage('TJ5')
TJ5.TJ:DevPrint('--------------- post-notify --------------- (dt=%dms)', debugprofilestop()-start)
print("Diff:", newMem-oldMem)
--]]


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Profile Testing
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
DevTools_Dump{available={Engine:GetAvailableProfilesForSpec()}}
DevTools_Dump{abilities=TJ:ExportAbilitiesFromSpellBook()}
TJ:ExportAbilitiesFromSpellBook()
--]]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Stats Testing
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DevTools_Dump{Broker=TJ5.Broker}
DevTools_Dump{Stats=TJ5.Stats}
local env = { predictionOffset = 0, currentTime = GetTime() }
Engine.resources.soul_fragments.expirationTime = 0
Engine.resources.soul_fragments:SetEnv(env)
Engine.resources.soul_fragments:SetState(env)
DevTools_Dump{soul_fragments=Engine.resources.soul_fragments:Evaluate()}--, soul_fragments_mt=getmetatable(Engine.resources.soul_fragments)}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ensure we're not leaking tables
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Metrics()
TJ5.TJ:DevPrint('--------------- checkpoint end --------------- (dt=%dms)', debugprofilestop()-beginRun)
