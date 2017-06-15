local TJ = LibStub('AceAddon-3.0'):GetAddon('ThousandJabs')
local Core = TJ:GetModule('Core')
local TableCache = TJ:GetModule('TableCache')

local LSD = LibStub("LibSerpentDump")

local BOOKTYPE_PET = BOOKTYPE_PET
local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local co_yield = coroutine.yield
local CreateFrame = CreateFrame
local DECIMAL_SEPERATOR = DECIMAL_SEPERATOR
local GetActiveSpecGroup = GetActiveSpecGroup
local GetLocale = GetLocale
local GetNumSpellTabs = GetNumSpellTabs
local GetSpellBookItemInfo = GetSpellBookItemInfo
local GetSpellBookItemName = GetSpellBookItemName
local GetSpellInfo = GetSpellInfo
local GetSpellLink = GetSpellLink
local GetSpellTabInfo = GetSpellTabInfo
local GetTalentInfo = GetTalentInfo
local IsPassiveSpell = IsPassiveSpell
local IsPlayerSpell = IsPlayerSpell
local IsTalentSpell = IsTalentSpell
local LARGE_NUMBER_SEPERATOR = LARGE_NUMBER_SEPERATOR
local LearnTalent = LearnTalent
local mfloor = math.floor
local pairs = pairs
local real_G = _G
local select = select
local tconcat = table.concat
local tContains = tContains
local tinsert = table.insert
local tonumber = tonumber
local type = type

Core:Safety()

------------------------------------------------------------------------------------------------------------------------
-- Spellbook iteration
------------------------------------------------------------------------------------------------------------------------

local IterateSpellbook
do
    local function CollectInfoForSpell(spellID, spellBookSlotID, bookType, isOffSpec)
        local ok, _
        if not spellBookSlotID then
            ok, spellBookSlotID = pcall(FindSpellBookSlotBySpellID, spellID)
        end

        local ok, spellName, _, icon, castTime, _, _, spellID = pcall(GetSpellInfo, spellID)
        if not ok then return nil end

        local spellSubtext, isTalent = '', false
        if spellBookSlotID then
            ok, _, spellSubtext = pcall(GetSpellBookItemName, spellBookSlotID, bookType)
            if not ok then return nil end

            ok, isTalent = pcall(IsTalentSpell, spellBookSlotID, bookType)
            if not ok then return nil end
        end

        local ok, isPassive = pcall(IsPassiveSpell, spellID)
        if not ok then return nil end

        local ok, isPlayerSpell = pcall(IsPlayerSpell, spellID)
        if not ok then return nil end

        local e = TableCache:Acquire()
        e.bookType, e.spellID, e.spellName, e.spellSubtext, e.spellBookSlotID, e.isTalent, e.icon, e.castTime, e.isPassive, e.isOffSpec, e.isMainSpec, e.isPlayerSpell
        = bookType, spellID, spellName, spellSubtext, spellBookSlotID, isTalent and true or false, icon, castTime, isPassive and true or false, isOffSpec, not isOffSpec, isPlayerSpell
        return e
    end

    local function CollectPlayerSpells(filter)
        local allSpells = TableCache:Acquire()
        local numTabs = GetNumSpellTabs()
        for i=1,numTabs do
            local ok, _, _, offset, numSpells, _, offSpecID = pcall(GetSpellTabInfo, i)
            if ok then
                local first = offset+1
                local last = offset+numSpells
                local isOffSpec = (offSpecID ~= 0)
                for j=first,last do
                    local ok, skillType, spellBookID = pcall(GetSpellBookItemInfo, j, BOOKTYPE_SPELL)
                    if not skillType then break end
                    if ok then
                        if skillType == "SPELL" then
                            local ok, link = pcall(GetSpellLink, j, BOOKTYPE_SPELL)
                            if link then
                                local spellID = tonumber(link:match('Hspell:(%d+)')) or -1
                                if spellID and spellID >= 0 then
                                    local e = CollectInfoForSpell(spellID, j, BOOKTYPE_SPELL, isOffSpec)
                                    if e then
                                        if not filter or filter(e) then
                                            allSpells[1+#allSpells] = e
                                        else
                                            TableCache:Release(e)
                                        end
                                    end
                                end
                            end
                        elseif skillType == "FLYOUT" then
                            local ok, _, _, numSlots = pcall(GetFlyoutInfo, spellBookID)
                            if ok then
                                for k=1,numSlots do
                                    local ok, spellID = pcall(GetFlyoutSlotInfo, spellBookID, k)
                                    if ok then
                                        local e = CollectInfoForSpell(spellID, nil, BOOKTYPE_SPELL, isOffSpec)
                                        if e then
                                            if not filter or filter(e) then
                                                allSpells[1+#allSpells] = e
                                            else
                                                TableCache:Release(e)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return allSpells
    end

    local function CollectPetSpells(filter)
        if not HasPetSpells() or not PetHasSpellbook() then
            return nil
        end

        local allSpells = TableCache:Acquire()
        for i=1,100 do
            local ok, skillType, spellBookID = pcall(GetSpellBookItemInfo, i, BOOKTYPE_PET)
            if not skillType then break end
            if ok and skillType == "PETACTION" then
                local ok, link = pcall(GetSpellLink, i, BOOKTYPE_PET)
                if link then
                    local spellID = tonumber(link:match('Hspell:(%d+)')) or -1
                    if spellID and spellID >= 0 then
                        local e = CollectInfoForSpell(spellID, i, BOOKTYPE_PET, false)
                        if e then
                            if not filter or filter(e) then
                                allSpells[1+#allSpells] = e
                            else
                                TableCache:Release(e)
                            end
                        end
                    end
                end
            end
        end
        return allSpells
    end

    local function CollectSpells(bookType, filter)
        if bookType == BOOKTYPE_SPELL then
            return CollectPlayerSpells(filter)
        elseif bookType == BOOKTYPE_PET then
            return CollectPetSpells(filter)
        end
    end

    local function dispatch(state)
        while true do
            state.index = state.index + 1
            if not state.allSpells then return nil end
            local e = state.allSpells[state.index]
            if not e then
                TableCache:Release(state)
                return nil
            end
            return e.spellID, e.spellName, e.spellSubtext, e.spellBookSlotID, e.isTalent, e.icon, e.castTime, e.isPassive, e.isOffSpec
        end
    end

    IterateSpellbook = function(bookType, filter)
        local state = TableCache:Acquire()
        state.allSpells = CollectSpells(bookType, filter)
        state.index = 0
        return dispatch, state
    end
end

------------------------------------------------------------------------------------------------------------------------
-- Retrieve all abilities from the spellbook
------------------------------------------------------------------------------------------------------------------------

local lastExportedSpecialisation = nil
local definedAbilities = {}
local function slug(name)
    if GetLocale() ~= "enUS" then return name end -- Slug names are only relevant for en-US, other locales are internally matched by spellID anyway
    return name:lower():gsub(' ','_'):gsub('[^%a%d_]','')
end
local blacklistedExportedAbilities = {
    'apprentice_riding',
    'arcane_acuity',
    'arcane_affinity',
    'arcane_resistance',
    'arcane_torrent',
    'archaeology',
    'armor_skills',
    'auto_attack',
    'avoidance',
    'beast_slaying',
    'blacksmithing',
    'bouncy',
    'broken_isles_pathfinder',
    'celestial_fortune',
    'cold_weather_flying',
    'combat_ally',
    'command_demon',
    'cooking_fire',
    'cooking',
    'da_voodoo_shuffle',
    'disenchant',
    'double_jump',
    'draenor_pathfinder',
    'enchanting',
    'engineering',
    'epicurean',
    'first_aid',
    'fishing',
    'flight_masters_license',
    'garrison_ability',
    'gnomish_engineer',
    'goblin_engineer',
    'gourmand',
    'guild_mail',
    'hasty_hearth',
    'herb_gathering',
    'herbalism_skills',
    'honorable_medallion',
    'inner_peace',
    'jewelcrafting',
    'languages',
    'master_riding',
    'mastery_chaotic_energies',
    'mining_skills',
    'mobile_banking',
    'mount_up',
    'path_of_the_black_ox',
    'path_of_the_jade_serpent',
    'path_of_the_mogu_king',
    'path_of_the_necromancer',
    'path_of_the_scarlet_blade',
    'path_of_the_scarlet_mitre',
    'path_of_the_setting_sun',
    'path_of_the_shadopan',
    'path_of_the_stout_brew',
    'portal_dalaran__northrend',
    'portal_orgrimmar',
    'portal_shattrath',
    'portal_silvermoon',
    'portal_stonard',
    'portal_thunder_bluff',
    'portal_undercity',
    'prospecting',
    'quaking_palm',
    'regeneration',
    'revive_battle_pets',
    'shoot',
    'survey',
    'teleport_dalaran__northrend',
    'teleport_orgrimmar',
    'teleport_shattrath',
    'teleport_silvermoon',
    'teleport_stonard',
    'teleport_thunder_bluff',
    'teleport_undercity',
    'the_codex_of_xerrath',
    'the_quick_and_the_dead',
    'weapon_skills',
    'windwalking',
    'wisdom_of_the_four_winds',
    'zen_pilgrimage_return',
    'zen_pilgrimage',
}

function TJ:DetectAbilitiesFromSpellBook()
    local abilities = {}

    local filter = function(e)
        local ok = (not e.isOffSpec) and (not e.isPassive) and (e.spellBookSlotID or e.isPlayerSpell) -- Dodgy comparison - DH's don't seem to think IsPlayerSpell is valid for things like sigils, when Concentrated Sigils is selected.
        --[[
        local c1 = ok and '|cFF00FF00' or '|cFFFF0000'
        local c2 = ok and '|cFF99FF99' or '|cFFFF9999'
        print(("%s%d %s -- %s%s | spellBookSlotID = %s | isPlayerSpell = %s|r"):format(c1, e.spellID, GetSpellLink(e.spellID), c2, e.spellName, tostring(e.spellBookSlotID), tostring(e.isPlayerSpell)))
        --]]
        return ok
    end

    -- Helper to work out the 'simulationcraft-ified' name for the spell
    -- Iterate over the spellbook, collecting all the abilities
    local function RetrieveSpells(bookType, caster)
        for spellID, spellName, spellSubText, spellBookItem, spellIsTalent, spellIcon, castTime, isPassive in IterateSpellbook(bookType, filter) do
            if spellID and spellName then
                abilities[slug(spellName)] = {
                    Name = spellName,
                    SpellIDs = { spellID },
                    KeyedSpellIDs = { [spellID] = true },
                    SpellBookSubtext = spellSubText,
                    SpellBookItem = spellBookItem,
                    IsTalent = spellIsTalent,
                    IsPassive = isPassive,
                    SpellBookSpellID = spellID,
                    Icon = spellIcon,
                    SpellBookCaster = caster
                }
            end
        end
    end

    RetrieveSpells(BOOKTYPE_SPELL, 'player')
    RetrieveSpells(BOOKTYPE_PET, 'pet')

    -- Detect talents, update values accordingly
    for tier=1,7 do
        for column=1,3 do
            local talentID, name = GetTalentInfo(tier, column, GetActiveSpecGroup())
            if talentID and name then
                abilities[slug(name)] = abilities[slug(name)] or {}
                abilities[slug(name)].TalentID = talentID
                abilities[slug(name)].IsTalent = true
            end
        end
    end

    -- Merge the abilities with the full list, so that we can export later on
    definedAbilities = Core:MergeTables(abilities, definedAbilities)

    return abilities
end

local function GeneratePermutations(entries, count)
    if count <= 1 then
        local ret = {}
        for k,v in pairs(entries) do
            ret[1+#ret] = { v }
        end
        return ret
    else
        local ret = {}
        local children = GeneratePermutations(entries, count-1)
        for _,child in pairs(children) do
            for _,entry in pairs(entries) do
                local thisEntry = {}
                for _,e in pairs(child) do
                    thisEntry[1+#thisEntry] = e
                end
                thisEntry[1+#thisEntry] = entry
                ret[1+#ret] = thisEntry
            end
        end
        return ret
    end
end

function TJ:ExportAbilitiesFromSpellBook(runAllPossibleCombinations)
    -- Get the currently-active talents
    local specID = GetSpecialization()
    local talents = {}
    for k=1,GetMaxTalentTier() do
        talents[k] = select(10, GetTalentInfoBySpecialization(specID, k, 1)) and 1
            or select(10, GetTalentInfoBySpecialization(specID, k, 2)) and 2
            or select(10, GetTalentInfoBySpecialization(specID, k, 3)) and 3
    end

    -- Clear out the defined abilities if we're exporting a different specialisation
    if lastExportedSpecialisation ~= specID then
        definedAbilities = {}
        lastExportedSpecialisation = specID
    end

    local function Detect()
        TJ:DetectAbilitiesFromSpellBook()
        co_yield()
        TJ:DetectAbilitiesFromSpellBook()
        TJ:QueueProfileReload(true)
        co_yield()
    end

    self:ExecuteFuncAsCoroutine(function()
        local canceled = false

        -- Start off by detecting the initial set with current talent loadout
        Detect()

        -- Swap all talents to generate all spell information
        if runAllPossibleCombinations then
            local allPermutations = GeneratePermutations({1,2,3}, GetMaxTalentTier())
            for perm=1,#allPermutations do
                for i=1,GetMaxTalentTier() do
                    LearnTalent(GetTalentInfoBySpecialization(specID, i, allPermutations[perm][i]))
                end
                Detect()

                if IsRightShiftKeyDown() and IsRightControlKeyDown() and IsRightAltKeyDown() then
                    canceled = true
                    break
                end
            end
        else
            for row=1,GetMaxTalentTier() do
                for column=1,3 do
                    if column ~= talents[row] then
                        LearnTalent(GetTalentInfoBySpecialization(specID, row, column))
                        Detect()
                    end
                end

                if IsRightShiftKeyDown() and IsRightControlKeyDown() and IsRightAltKeyDown() then
                    canceled = true
                    break
                end
            end
        end

        -- Restore original talents
        for row=1,GetMaxTalentTier() do
            LearnTalent(GetTalentInfoBySpecialization(specID, row, talents[row]))
            Detect()
        end

        -- Show the spell export window
        if not canceled then
            TJ:ShowSpellExportWindow()
        else
            TJ:Print('Spell data export canceled.')
        end
    end)
end

function TJ:ShowSpellExportWindow()
    -- Build the string
    local export = ''
    local addline = function(...)
        export = Core:Format("%s\n%s", export, Core:Format(...))
    end

    local gameVersion = GetBuildInfo()

    -- Ability IDs
    addline("-- exported with /tj _esd")
    addline("local %s_abilities_exported = {", select(2, GetSpecializationInfo(GetSpecialization())):lower())
    for k,v in Core:OrderedPairs(definedAbilities) do
        if not tContains(blacklistedExportedAbilities, k) then
            local line = Core:Format('    %s = { ', k)
            if v.KeyedSpellIDs then
                local ids = {}
                for id in Core:OrderedPairs(v.KeyedSpellIDs) do
                    ids[1+#ids] = id
                end
                line = line .. Core:Format('SpellIDs = { %s }, ', tconcat(ids, ", "))
            end
            if v.TalentID then line = line .. Core:Format('TalentID = %d, ', v.TalentID) end
            line = line .. '},'
            addline(line)
        end
    end
    addline("}")
    addline("")

    -- Display the exported data
    Core:OpenDebugWindow('Thousand Jabs Actions Data Export', export)
end

------------------------------------------------------------------------------------------------------------------------
-- Spell info from tooltip
------------------------------------------------------------------------------------------------------------------------

local tts = CreateFrame('GameTooltip', 'ThousandJabsTooltipScanner')
local ttsl1 = tts:CreateFontString('$parentTextLeft1', nil, "GameTooltipText")
local ttsr1 = tts:CreateFontString('$parentTextRight1', nil, "GameTooltipText")
tts:AddFontStrings(ttsl1, ttsr1)
tts:SetOwner(UIParent, "ANCHOR_NONE")

function TJ:GetTooltipEntries(link)
    tts:SetOwner(UIParent, "ANCHOR_NONE")
    tts:ClearLines()
    tts:SetHyperlink(link)
    local tooltipName = tts:GetName()
    local entries = TableCache:Acquire()

    local function checkadd(x)
        local frm = real_G[tooltipName..x]
        local errfun = function(e)
            Core:Error(Core:Format('Could not retrieve info from frame "%s", %s', tooltipName..x, e), Core:Format('Could not retrieve info from frame "%s", %s', tooltipName..x, e))
        end
        if type(frm) == 'nil' then
            errfun('Frame was nil')
        else
            local xt = frm:GetText()
            if xt ~= "" then
                local e = TableCache:Acquire()
                e.t = xt or ""
                e.c = TableCache:Acquire()
                e.c[1], e.c[2], e.c[3] = frm:GetTextColor()
                e.cb = TableCache:Acquire()
                e.cb[1], e.cb[2], e.cb[3] = mfloor(e.c[1]*256), mfloor(e.c[2]*256), mfloor(e.c[3]*256)
                entries[1+#entries] = e
            end
        end
    end

    for i = 1, tts:NumLines() do
        checkadd('TextLeft'..i)
        checkadd('TextRight'..i)
    end

    return entries
end

local function IsGreen(colour) -- work out if it's increased by haste
    return colour[1] == 0 and colour[2] == 255 and colour[3] == 0 and true
end

local RegexPatterns = setmetatable({ ['.'] = '%.', [' '] = '%s' }, { __index = function(tbl,idx) return idx end })
local PowerTypes = { 'mana', 'energy', 'chi', 'pain', 'fury', 'rune', 'runic_power', 'rage', 'soul_shards', 'maelstrom' }
local PowerSuffixes = { '_COST', '_COST_PER_TIME', '_COST_PER_TIME_NO_BASE', '_COST_PCT' }
local PowerPatterns = {}
for _,v in pairs(PowerTypes) do
    for _,s in pairs(PowerSuffixes) do
        local b = v:upper() .. s
        if real_G[b] then
            local t = real_G[b]
            t = t:gsub('%%s', '([.,%%d]+)')
            t = LARGE_NUMBER_SEPERATOR:len() > 0 and t:gsub(RegexPatterns[LARGE_NUMBER_SEPERATOR], '') or t

            local placeholder = '____PLACEHOLDER____'
            local A, B
            t = t:gsub('|4([^:]+):([^;]+);', function(a, b) -- (a or b - "|4aaa:bbb;")
                A, B = a, b
                return placeholder
            end)
            if A then
                PowerPatterns[1+#PowerPatterns] = { b:gsub('_COST',''):lower(), '^' .. t:gsub(placeholder,A) .. '$'}
                PowerPatterns[1+#PowerPatterns] = { b:gsub('_COST',''):lower(), '^' .. t:gsub(placeholder,B) .. '$'}
            else
                PowerPatterns[1+#PowerPatterns] = { b:gsub('_COST',''):lower(), '^' .. t .. '$'}
            end
        end
    end
end
Core.PowerPatterns = PowerPatterns

local DurationChecks = { 'days', 'hours', 'min', 'sec' }
local DurationMultiplier = { days = 86400, hours = 3600, min = 60, sec = 1 }
local CooldownPatterns = {}
local RechargePatterns = {}
for _,v in pairs(DurationChecks) do
    local b = 'SPELL_RECAST_TIME_' .. v:upper()
    if real_G[b] then
        local t = real_G[b]
        t = t:gsub('%%.3g', '([.,%%d]+)')
        t = LARGE_NUMBER_SEPERATOR:len() > 0 and t:gsub(RegexPatterns[LARGE_NUMBER_SEPERATOR], '') or t

        local placeholder = '____PLACEHOLDER____'
        local A, B
        t = t:gsub('|4([^:]+):([^;]+);', function(a, b) -- (a or b - "|4aaa:bbb;")
            A, B = a, b
            return placeholder
        end)
        if A then
            CooldownPatterns[1+#CooldownPatterns] = { v, '^' .. t:gsub(placeholder,A) .. '$'}
            CooldownPatterns[1+#CooldownPatterns] = { v, '^' .. t:gsub(placeholder,B) .. '$'}
        else
            CooldownPatterns[1+#CooldownPatterns] = { v, '^' .. t .. '$'}
        end
    end
    b = 'SPELL_RECAST_TIME_CHARGES_' .. v:upper()
    if real_G[b] then
        local t = real_G[b]
        t = t:gsub('%%.3g', '([.,%%d]+)')
        t = LARGE_NUMBER_SEPERATOR:len() > 0 and t:gsub(RegexPatterns[LARGE_NUMBER_SEPERATOR], '') or t

        local placeholder = '____PLACEHOLDER____'
        local A, B
        t = t:gsub('|4([^:]+):([^;]+);', function(a, b) -- (a or b - "|4aaa:bbb;")
            A, B = a, b
            return placeholder
        end)
        if A then
            RechargePatterns[1+#RechargePatterns] = { v, '^' .. t:gsub(placeholder,A) .. '$'}
            RechargePatterns[1+#RechargePatterns] = { v, '^' .. t:gsub(placeholder,B) .. '$'}
        else
            RechargePatterns[1+#RechargePatterns] = { v, '^' .. t .. '$'}
        end
    end
end
Core.CooldownPatterns = CooldownPatterns
Core.RechargePatterns = RechargePatterns

function TJ:GetSpellCost(spellID)
    local entries = self:GetTooltipEntries(Core:Format('|cff71d5ff|Hspell:%d|h[spell%d]|h|r', spellID))
    for _,e in pairs(entries) do
        for k,v in pairs(PowerPatterns) do
            local f = LARGE_NUMBER_SEPERATOR:len() > 0 and e.t:gsub(RegexPatterns[LARGE_NUMBER_SEPERATOR], '') or e.t
            local a, b, c = f:match(v[2])
            -- strip non-digit and convert to number
            if a then a = a:gsub('%D', '') + 0 end
            if b then b = b:gsub('%D', '') + 0 end
            if c then c = c:gsub('%D', '') + 0 end
            if a then
                TableCache:Release(entries)
                return v[1], a, b, c --, { result = { a, b, c }, matchtext = e.t, pattern = v }
            end
        end
    end
    TableCache:Release(entries)
end

local function split(str, delim)
    local t = TableCache:Acquire()
    local pos = 0
    while true do
        local idx = str:find(delim, pos, true)
        if idx ~= nil then
            tinsert(t, str:sub(pos, idx - 1))
            pos = idx + delim:len()
        else
            tinsert(t, str:sub(pos))
            break
        end
    end
    return t
end

local function extract_number(str)
    local str = str:gsub('[^,%.%d]', '')
    local vals = split(str, RegexPatterns[DECIMAL_SEPERATOR])
    vals[1] = LARGE_NUMBER_SEPERATOR:len() > 0 and vals[1]:gsub(RegexPatterns[LARGE_NUMBER_SEPERATOR], '') or vals[1]
    vals[2] = '0.' .. (vals[2] or '0')
    local out = tonumber(vals[1]) + tonumber(vals[2])
    Core.Loader[1+#Core.Loader] = LSD({str=str,vals=vals,out=out}):gsub('[%s\n]','')
    TableCache:Release(vals)
    return out
end

local function get_spell_cooldown_or_recharge(spellID, patterns)
    local entries = TJ:GetTooltipEntries(Core:Format('spell:%d', spellID))
    for _,e in pairs(entries) do
        for k,v in pairs(patterns) do
            local f = LARGE_NUMBER_SEPERATOR:len() > 0 and e.t:gsub(RegexPatterns[LARGE_NUMBER_SEPERATOR], '') or e.t
            local r = f:match(v[2])
            if r then
                local isGreen = IsGreen(e.cb)
                TableCache:Release(entries)
                return extract_number(r) * DurationMultiplier[v[1]], isGreen --, { result = r, matchtext = e.t, pattern = v }
            end
        end
    end
    TableCache:Release(entries)
    return 0
end

function TJ:GetSpellCooldown(spellID)
    return get_spell_cooldown_or_recharge(spellID, CooldownPatterns)
end

function TJ:GetSpellRechargeTime(spellID)
    return get_spell_cooldown_or_recharge(spellID, RechargePatterns)
end

-- /dump tj:ScanTooltip('spell:188501', function(t) print(t) end, nil, { 255, 210, 0 })
function TJ:ScanTooltip(link, callback, pattern, colour)
    local entries = self:GetTooltipEntries(link)
    local function patternmatch(str, pattern)
        return pattern and type(pattern) == 'string' and str:match(pattern) and true or false
    end
    local function colourmatch(c1, c2)
        return c2 and type(c2) == 'table' and #c2 == 3 and c1[1] == c2[1] and c1[2] == c2[2] and c1[3] == c2[3] and true or false
    end
    for _,e in pairs(entries) do
        if patternmatch(e.t, pattern) and colourmatch(e.cb, colour) then
            callback(e.t, e.cb)
        elseif patternmatch(e.t, pattern) and colour == nil then
            callback(e.t, e.cb)
        elseif pattern == nil and colourmatch(e.cb, colour) then
            callback(e.t, e.cb)
        end
    end
    TableCache:Release(entries)
end

function TJ:ExportSpecsTables()
    local allClasses = {}
    local allSpecs = {}
    for classID=1,30 do
        local className, classToken = GetClassInfo(classID)
        if className then
            local noSpaceClassName = className:gsub(' ', '')
            for specID=1,10 do
                local specNumber, specName = GetSpecializationInfoForClassID(classID, specID)
                if specNumber then
                    local simcSpecName = specName:gsub(' ', '_'):lower()
                    allSpecs[noSpaceClassName] = allSpecs[noSpaceClassName] or {
                        classID = classID,
                        className = className,
                        noSpaceClassName = noSpaceClassName,
                        classToken = classToken,
                        specs = {}
                    }

                    allSpecs[noSpaceClassName].specs[simcSpecName] = allSpecs[noSpaceClassName].specs[simcSpecName] or {}
                    allSpecs[noSpaceClassName].specs[simcSpecName] = {
                        specID = specID,
                        specName = specName,
                        simcSpecName = simcSpecName,
                        specNumber = specNumber
                    }
                end
            end
        end
    end

    local output = "# Exported by /tj _est\nmy $exportedSpecData = {"
    local firstClass = true
    for className,classData in Core:OrderedPairs(allSpecs) do
        output = output .. Core:Format("%s\n    %s => {", firstClass and '' or ',', className)
        output = output .. Core:Format("\n        classID => %d,", classData.classID)
        output = output .. Core:Format("\n        name => '%s',", classData.className)
        output = output .. Core:Format("\n        specs => {")
        local firstSpec = true
        for specName,specData in Core:OrderedPairs(classData.specs) do
            output = output .. Core:Format("%s\n            %s => { specID => %d, name => \"%s\" }", firstSpec and '' or ',', specName, specData.specID, specData.specName)
            firstSpec = false
        end
        output = output .. "\n        }"
        output = output .. "\n    }"
        firstClass = false
    end
    output = output .. "\n};"
    output = output .. "\n\nlocal lua_spec_table = " .. LSD(allSpecs)
    Core:OpenDebugWindow('Thousand Jabs Spec Data Export', output)
end
