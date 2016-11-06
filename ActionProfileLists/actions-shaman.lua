local _, internal = ...
internal.apls = internal.apls or {}
internal.actions = internal.actions or {}

internal.apls["legion-dev::shaman::enhancement"] = [[
actions.precombat=flask,type=seventh_demon
actions.precombat+=/augmentation,type=defiled
actions.precombat+=/food,name=nightborne_delicacy_platter
actions.precombat+=/snapshot_stats
actions.precombat+=/potion,name=old_war
actions.precombat+=/lightning_shield
actions=wind_shear
actions+=/bloodlust,if=target.health.pct<25|time>0.500
actions+=/auto_attack
actions+=/feral_spirit
actions+=/crash_lightning,if=artifact.alpha_wolf.rank&prev_gcd.feral_spirit
actions+=/potion,name=old_war,if=feral_spirit.remains>5|target.time_to_die<=30
actions+=/berserking,if=buff.ascendance.up|!talent.ascendance.enabled|level<100
actions+=/blood_fury
actions+=/crash_lightning,if=talent.crashing_storm.enabled&active_enemies>=3
actions+=/boulderfist,if=buff.boulderfist.remains<gcd&maelstrom>=50&active_enemies>=3
actions+=/boulderfist,if=buff.boulderfist.remains<gcd|(charges_fractional>1.75&maelstrom<=100&active_enemies<=2)
actions+=/crash_lightning,if=buff.crash_lightning.remains<gcd&active_enemies>=2
actions+=/windstrike,if=active_enemies>=3&!talent.hailstorm.enabled
actions+=/stormstrike,if=active_enemies>=3&!talent.hailstorm.enabled
actions+=/windstrike,if=buff.stormbringer.react
actions+=/stormstrike,if=buff.stormbringer.react
actions+=/frostbrand,if=talent.hailstorm.enabled&buff.frostbrand.remains<gcd
actions+=/flametongue,if=buff.flametongue.remains<gcd
actions+=/windsong
actions+=/ascendance
actions+=/fury_of_air,if=!ticking
actions+=/doom_winds
actions+=/crash_lightning,if=active_enemies>=3
actions+=/windstrike
actions+=/stormstrike
actions+=/lightning_bolt,if=talent.overcharge.enabled&maelstrom>=60
actions+=/lava_lash,if=buff.hot_hand.react
actions+=/earthen_spike
actions+=/crash_lightning,if=active_enemies>1|talent.crashing_storm.enabled|feral_spirit.remains>5
actions+=/frostbrand,if=talent.hailstorm.enabled&buff.frostbrand.remains<4.8
actions+=/flametongue,if=buff.flametongue.remains<4.8
actions+=/sundering
actions+=/lava_lash,if=maelstrom>=90
actions+=/rockbiter
actions+=/flametongue
actions+=/boulderfist
]]

-- keywords: legion-dev::shaman::enhancement
---- active_enemies
---- alpha_wolf.artifact_rank
---- ascendance.spell_remains
---- ascendance.talent_enabled
---- boulderfist.spell_charges_fractional
---- boulderfist.spell_remains
---- crash_lightning.spell_remains
---- crashing_storm.talent_enabled
---- feral_spirit.remains
---- flametongue.spell_remains
---- frostbrand.spell_remains
---- fury_of_air.spell_remains
---- fury_of_air.spell_ticking
---- gcd
---- hailstorm.talent_enabled
---- health.target_percent
---- hot_hand.spell_remains
---- level
---- maelstrom
---- overcharge.talent_enabled
---- prev_gcd.feral_spirit
---- stormbringer.spell_remains
---- target.time_to_die
---- time

internal.actions['legion-dev::shaman::enhancement'] = {
    default = {
        {
            action = 'bloodlust',
            condition = 'target.health.pct<25|time>0.500',
            condition_converted = '((((health.target_percent_as_number) < (25))) or (((time_as_number) > (0.500))))',
            condition_keywords = {
                'health.target_percent',
                'time',
            },
            simc_line = 'actions+=/bloodlust,if=target.health.pct<25|time>0.500',
        },
        {
            action = 'crash_lightning',
            condition = 'artifact.alpha_wolf.rank&prev_gcd.feral_spirit',
            condition_converted = '((alpha_wolf.artifact_rank) and (prev_gcd.feral_spirit))',
            condition_keywords = {
                'alpha_wolf.artifact_rank',
                'prev_gcd.feral_spirit',
            },
            simc_line = 'actions+=/crash_lightning,if=artifact.alpha_wolf.rank&prev_gcd.feral_spirit',
        },
        {
            action = 'potion',
            condition = 'feral_spirit.remains>5|target.time_to_die<=30',
            condition_converted = '((((feral_spirit.remains_as_number) > (5))) or (((target.time_to_die_as_number) <= (30))))',
            condition_keywords = {
                'feral_spirit.remains',
                'target.time_to_die',
            },
            name = 'old_war',
            simc_line = 'actions+=/potion,name=old_war,if=feral_spirit.remains>5|target.time_to_die<=30',
        },
        {
            action = 'berserking',
            condition = 'buff.ascendance.up|!talent.ascendance.enabled|level<100',
            condition_converted = '(((ascendance.spell_remains_as_number > 0)) or ((((not ascendance.talent_enabled)) or (((level_as_number) < (100))))))',
            condition_keywords = {
                'ascendance.spell_remains',
                'ascendance.talent_enabled',
                'level',
            },
            simc_line = 'actions+=/berserking,if=buff.ascendance.up|!talent.ascendance.enabled|level<100',
        },
        {
            action = 'crash_lightning',
            condition = 'talent.crashing_storm.enabled&active_enemies>=3',
            condition_converted = '((crashing_storm.talent_enabled) and (((active_enemies_as_number) >= (3))))',
            condition_keywords = {
                'active_enemies',
                'crashing_storm.talent_enabled',
            },
            simc_line = 'actions+=/crash_lightning,if=talent.crashing_storm.enabled&active_enemies>=3',
        },
        {
            action = 'boulderfist',
            condition = 'buff.boulderfist.remains<gcd&maelstrom>=50&active_enemies>=3',
            condition_converted = '((((boulderfist.spell_remains_as_number) < (gcd_as_number))) and (((((maelstrom_as_number) >= (50))) and (((active_enemies_as_number) >= (3))))))',
            condition_keywords = {
                'active_enemies',
                'boulderfist.spell_remains',
                'gcd',
                'maelstrom',
            },
            simc_line = 'actions+=/boulderfist,if=buff.boulderfist.remains<gcd&maelstrom>=50&active_enemies>=3',
        },
        {
            action = 'boulderfist',
            condition = 'buff.boulderfist.remains<gcd|(charges_fractional>1.75&maelstrom<=100&active_enemies<=2)',
            condition_converted = '((((boulderfist.spell_remains_as_number) < (gcd_as_number))) or ((((((boulderfist.spell_charges_fractional_as_number) > (1.75))) and (((((maelstrom_as_number) <= (100))) and (((active_enemies_as_number) <= (2)))))))))',
            condition_keywords = {
                'active_enemies',
                'boulderfist.spell_charges_fractional',
                'boulderfist.spell_remains',
                'gcd',
                'maelstrom',
            },
            simc_line = 'actions+=/boulderfist,if=buff.boulderfist.remains<gcd|(charges_fractional>1.75&maelstrom<=100&active_enemies<=2)',
        },
        {
            action = 'crash_lightning',
            condition = 'buff.crash_lightning.remains<gcd&active_enemies>=2',
            condition_converted = '((((crash_lightning.spell_remains_as_number) < (gcd_as_number))) and (((active_enemies_as_number) >= (2))))',
            condition_keywords = {
                'active_enemies',
                'crash_lightning.spell_remains',
                'gcd',
            },
            simc_line = 'actions+=/crash_lightning,if=buff.crash_lightning.remains<gcd&active_enemies>=2',
        },
        {
            action = 'windstrike',
            condition = 'active_enemies>=3&!talent.hailstorm.enabled',
            condition_converted = '((((active_enemies_as_number) >= (3))) and ((not hailstorm.talent_enabled)))',
            condition_keywords = {
                'active_enemies',
                'hailstorm.talent_enabled',
            },
            simc_line = 'actions+=/windstrike,if=active_enemies>=3&!talent.hailstorm.enabled',
        },
        {
            action = 'stormstrike',
            condition = 'active_enemies>=3&!talent.hailstorm.enabled',
            condition_converted = '((((active_enemies_as_number) >= (3))) and ((not hailstorm.talent_enabled)))',
            condition_keywords = {
                'active_enemies',
                'hailstorm.talent_enabled',
            },
            simc_line = 'actions+=/stormstrike,if=active_enemies>=3&!talent.hailstorm.enabled',
        },
        {
            action = 'windstrike',
            condition = 'buff.stormbringer.react',
            condition_converted = '(stormbringer.spell_remains_as_number > 0)',
            condition_keywords = {
                'stormbringer.spell_remains',
            },
            simc_line = 'actions+=/windstrike,if=buff.stormbringer.react',
        },
        {
            action = 'stormstrike',
            condition = 'buff.stormbringer.react',
            condition_converted = '(stormbringer.spell_remains_as_number > 0)',
            condition_keywords = {
                'stormbringer.spell_remains',
            },
            simc_line = 'actions+=/stormstrike,if=buff.stormbringer.react',
        },
        {
            action = 'frostbrand',
            condition = 'talent.hailstorm.enabled&buff.frostbrand.remains<gcd',
            condition_converted = '((hailstorm.talent_enabled) and (((frostbrand.spell_remains_as_number) < (gcd_as_number))))',
            condition_keywords = {
                'frostbrand.spell_remains',
                'gcd',
                'hailstorm.talent_enabled',
            },
            simc_line = 'actions+=/frostbrand,if=talent.hailstorm.enabled&buff.frostbrand.remains<gcd',
        },
        {
            action = 'flametongue',
            condition = 'buff.flametongue.remains<gcd',
            condition_converted = '((flametongue.spell_remains_as_number) < (gcd_as_number))',
            condition_keywords = {
                'flametongue.spell_remains',
                'gcd',
            },
            simc_line = 'actions+=/flametongue,if=buff.flametongue.remains<gcd',
        },
        {
            action = 'fury_of_air',
            condition = '!ticking',
            condition_converted = '(fury_of_air.spell_remains == 0)',
            condition_keywords = {
                'fury_of_air.spell_remains',
            },
            simc_line = 'actions+=/fury_of_air,if=!ticking',
        },
        {
            action = 'crash_lightning',
            condition = 'active_enemies>=3',
            condition_converted = '((active_enemies_as_number) >= (3))',
            condition_keywords = {
                'active_enemies',
            },
            simc_line = 'actions+=/crash_lightning,if=active_enemies>=3',
        },
        {
            action = 'lightning_bolt',
            condition = 'talent.overcharge.enabled&maelstrom>=60',
            condition_converted = '((overcharge.talent_enabled) and (((maelstrom_as_number) >= (60))))',
            condition_keywords = {
                'maelstrom',
                'overcharge.talent_enabled',
            },
            simc_line = 'actions+=/lightning_bolt,if=talent.overcharge.enabled&maelstrom>=60',
        },
        {
            action = 'lava_lash',
            condition = 'buff.hot_hand.react',
            condition_converted = '(hot_hand.spell_remains_as_number > 0)',
            condition_keywords = {
                'hot_hand.spell_remains',
            },
            simc_line = 'actions+=/lava_lash,if=buff.hot_hand.react',
        },
        {
            action = 'crash_lightning',
            condition = 'active_enemies>1|talent.crashing_storm.enabled|feral_spirit.remains>5',
            condition_converted = '((((active_enemies_as_number) > (1))) or (((crashing_storm.talent_enabled) or (((feral_spirit.remains_as_number) > (5))))))',
            condition_keywords = {
                'active_enemies',
                'crashing_storm.talent_enabled',
                'feral_spirit.remains',
            },
            simc_line = 'actions+=/crash_lightning,if=active_enemies>1|talent.crashing_storm.enabled|feral_spirit.remains>5',
        },
        {
            action = 'frostbrand',
            condition = 'talent.hailstorm.enabled&buff.frostbrand.remains<4.8',
            condition_converted = '((hailstorm.talent_enabled) and (((frostbrand.spell_remains_as_number) < (4.8))))',
            condition_keywords = {
                'frostbrand.spell_remains',
                'hailstorm.talent_enabled',
            },
            simc_line = 'actions+=/frostbrand,if=talent.hailstorm.enabled&buff.frostbrand.remains<4.8',
        },
        {
            action = 'flametongue',
            condition = 'buff.flametongue.remains<4.8',
            condition_converted = '((flametongue.spell_remains_as_number) < (4.8))',
            condition_keywords = {
                'flametongue.spell_remains',
            },
            simc_line = 'actions+=/flametongue,if=buff.flametongue.remains<4.8',
        },
        {
            action = 'lava_lash',
            condition = 'maelstrom>=90',
            condition_converted = '((maelstrom_as_number) >= (90))',
            condition_keywords = {
                'maelstrom',
            },
            simc_line = 'actions+=/lava_lash,if=maelstrom>=90',
        },
    },
    precombat = {
        {
            action = 'flask',
            simc_line = 'actions.precombat=flask,type=seventh_demon',
            type = 'seventh_demon',
        },
        {
            action = 'augmentation',
            simc_line = 'actions.precombat+=/augmentation,type=defiled',
            type = 'defiled',
        },
        {
            action = 'food',
            name = 'nightborne_delicacy_platter',
            simc_line = 'actions.precombat+=/food,name=nightborne_delicacy_platter',
        },
        {
            action = 'potion',
            name = 'old_war',
            simc_line = 'actions.precombat+=/potion,name=old_war',
        },
    },
}


internal.apls["legion-dev::shaman::elemental"] = [[
actions.precombat=flask,type=whispered_pact
actions.precombat+=/food,name=fishbrul_special
actions.precombat+=/augmentation,type=defiled
actions.precombat+=/snapshot_stats
actions.precombat+=/potion,name=deadly_grace
actions.precombat+=/stormkeeper
actions.precombat+=/totem_mastery
actions=bloodlust,if=target.health.pct<25|time>0.500
actions+=/potion,name=deadly_grace,if=buff.ascendance.up|target.time_to_die<=30
actions+=/totem_mastery,if=buff.resonance_totem.remains<2
actions+=/fire_elemental
actions+=/storm_elemental
actions+=/elemental_mastery
actions+=/blood_fury,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
actions+=/berserking,if=!talent.ascendance.enabled|buff.ascendance.up
actions+=/run_action_list,name=aoe,if=active_enemies>2&(spell_targets.chain_lightning>2|spell_targets.lava_beam>2)
actions+=/run_action_list,name=single
actions.aoe=stormkeeper
actions.aoe+=/ascendance
actions.aoe+=/liquid_magma_totem
actions.aoe+=/flame_shock,if=spell_targets.chain_lightning=3&maelstrom>=20,target_if=refreshable
actions.aoe+=/earthquake
actions.aoe+=/lava_burst,if=buff.lava_surge.up&spell_targets.chain_lightning=3
actions.aoe+=/lava_beam
actions.aoe+=/chain_lightning,target_if=!debuff.lightning_rod.up
actions.aoe+=/chain_lightning
actions.aoe+=/lava_burst,moving=1
actions.aoe+=/flame_shock,moving=1,target_if=refreshable
actions.single=ascendance,if=dot.flame_shock.remains>buff.ascendance.duration&(time>=60|buff.bloodlust.up)&cooldown.lava_burst.remains>0&!buff.stormkeeper.up
actions.single+=/flame_shock,if=!ticking
actions.single+=/flame_shock,if=maelstrom>=20&remains<=buff.ascendance.duration&cooldown.ascendance.remains+buff.ascendance.duration<=duration
actions.single+=/earth_shock,if=maelstrom>=92
actions.single+=/icefury,if=raid_event.movement.in<5
actions.single+=/lava_burst,if=dot.flame_shock.remains>cast_time&(cooldown_react|buff.ascendance.up)
actions.single+=/elemental_blast
actions.single+=/earthquake,if=buff.echoes_of_the_great_sundering.up
actions.single+=/flame_shock,if=maelstrom>=20&buff.elemental_focus.up,target_if=refreshable
actions.single+=/frost_shock,if=talent.icefury.enabled&buff.icefury.up&((maelstrom>=20&raid_event.movement.in>buff.icefury.remains)|buff.icefury.remains<(1.5*spell_haste*buff.icefury.stack))
actions.single+=/frost_shock,moving=1,if=buff.icefury.up
actions.single+=/earth_shock,if=maelstrom>=86
actions.single+=/icefury,if=maelstrom<=70&raid_event.movement.in>30&((talent.ascendance.enabled&cooldown.ascendance.remains>buff.icefury.duration)|!talent.ascendance.enabled)
actions.single+=/liquid_magma_totem,if=raid_event.adds.count<3|raid_event.adds.in>50
actions.single+=/stormkeeper,if=(talent.ascendance.enabled&cooldown.ascendance.remains>10)|!talent.ascendance.enabled
actions.single+=/totem_mastery,if=buff.resonance_totem.remains<10|(buff.resonance_totem.remains<(buff.ascendance.duration+cooldown.ascendance.remains)&cooldown.ascendance.remains<15)
actions.single+=/lava_beam,if=active_enemies>1&spell_targets.lava_beam>1
actions.single+=/lightning_bolt,if=buff.power_of_the_maelstrom.up,target_if=!debuff.lightning_rod.up
actions.single+=/lightning_bolt,if=buff.power_of_the_maelstrom.up
actions.single+=/chain_lightning,if=active_enemies>1&spell_targets.chain_lightning>1,target_if=!debuff.lightning_rod.up
actions.single+=/chain_lightning,if=active_enemies>1&spell_targets.chain_lightning>1
actions.single+=/lightning_bolt,target_if=!debuff.lightning_rod.up
actions.single+=/lightning_bolt
actions.single+=/flame_shock,moving=1,target_if=refreshable
actions.single+=/earth_shock,moving=1
]]

-- keywords: legion-dev::shaman::elemental
---- active_enemies
---- ascendance.cooldown_remains
---- ascendance.spell_duration
---- ascendance.spell_remains
---- ascendance.talent_enabled
---- bloodlust.spell_remains
---- cooldown_remains
---- echoes_of_the_great_sundering.spell_remains
---- elemental_focus.spell_remains
---- flame_shock.spell_duration
---- flame_shock.spell_remains
---- flame_shock.spell_ticking
---- health.target_percent
---- icefury.spell_duration
---- icefury.spell_remains
---- icefury.spell_stack
---- icefury.talent_enabled
---- lava_burst.cooldown_remains
---- lava_burst.spell_cast_time
---- lava_surge.spell_remains
---- maelstrom
---- power_of_the_maelstrom.spell_remains
---- raid_event.adds.count
---- raid_event.adds.in
---- raid_event.movement.in
---- resonance_totem.spell_remains
---- spell_haste
---- spell_targets
---- stormkeeper.spell_remains
---- target.time_to_die
---- time

internal.actions['legion-dev::shaman::elemental'] = {
    aoe = {
        {
            action = 'flame_shock',
            condition = 'spell_targets.chain_lightning=3&maelstrom>=20',
            condition_converted = '((((spell_targets) == (3))) and (((maelstrom_as_number) >= (20))))',
            condition_keywords = {
                'maelstrom',
                'spell_targets',
            },
            simc_line = 'actions.aoe+=/flame_shock,if=spell_targets.chain_lightning=3&maelstrom>=20,target_if=refreshable',
            target_if = 'refreshable',
        },
        {
            action = 'lava_burst',
            condition = 'buff.lava_surge.up&spell_targets.chain_lightning=3',
            condition_converted = '(((lava_surge.spell_remains_as_number > 0)) and (((spell_targets) == (3))))',
            condition_keywords = {
                'lava_surge.spell_remains',
                'spell_targets',
            },
            simc_line = 'actions.aoe+=/lava_burst,if=buff.lava_surge.up&spell_targets.chain_lightning=3',
        },
        {
            action = 'chain_lightning',
            simc_line = 'actions.aoe+=/chain_lightning,target_if=!debuff.lightning_rod.up',
            target_if = '!debuff.lightning_rod.up',
        },
        {
            action = 'lava_burst',
            moving = '1',
            simc_line = 'actions.aoe+=/lava_burst,moving=1',
        },
        {
            action = 'flame_shock',
            moving = '1',
            simc_line = 'actions.aoe+=/flame_shock,moving=1,target_if=refreshable',
            target_if = 'refreshable',
        },
    },
    default = {
        {
            action = 'bloodlust',
            condition = 'target.health.pct<25|time>0.500',
            condition_converted = '((((health.target_percent_as_number) < (25))) or (((time_as_number) > (0.500))))',
            condition_keywords = {
                'health.target_percent',
                'time',
            },
            simc_line = 'actions=bloodlust,if=target.health.pct<25|time>0.500',
        },
        {
            action = 'potion',
            condition = 'buff.ascendance.up|target.time_to_die<=30',
            condition_converted = '(((ascendance.spell_remains_as_number > 0)) or (((target.time_to_die_as_number) <= (30))))',
            condition_keywords = {
                'ascendance.spell_remains',
                'target.time_to_die',
            },
            name = 'deadly_grace',
            simc_line = 'actions+=/potion,name=deadly_grace,if=buff.ascendance.up|target.time_to_die<=30',
        },
        {
            action = 'totem_mastery',
            condition = 'buff.resonance_totem.remains<2',
            condition_converted = '((resonance_totem.spell_remains_as_number) < (2))',
            condition_keywords = {
                'resonance_totem.spell_remains',
            },
            simc_line = 'actions+=/totem_mastery,if=buff.resonance_totem.remains<2',
        },
        {
            action = 'blood_fury',
            condition = '!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50',
            condition_converted = '(((not ascendance.talent_enabled)) or ((((ascendance.spell_remains_as_number > 0)) or (((ascendance.cooldown_remains_as_number) > (50))))))',
            condition_keywords = {
                'ascendance.cooldown_remains',
                'ascendance.spell_remains',
                'ascendance.talent_enabled',
            },
            simc_line = 'actions+=/blood_fury,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50',
        },
        {
            action = 'berserking',
            condition = '!talent.ascendance.enabled|buff.ascendance.up',
            condition_converted = '(((not ascendance.talent_enabled)) or ((ascendance.spell_remains_as_number > 0)))',
            condition_keywords = {
                'ascendance.spell_remains',
                'ascendance.talent_enabled',
            },
            simc_line = 'actions+=/berserking,if=!talent.ascendance.enabled|buff.ascendance.up',
        },
        {
            action = 'run_action_list',
            condition = 'active_enemies>2&(spell_targets.chain_lightning>2|spell_targets.lava_beam>2)',
            condition_converted = '((((active_enemies_as_number) > (2))) and ((((((spell_targets_as_number) > (2))) or (((spell_targets_as_number) > (2)))))))',
            condition_keywords = {
                'active_enemies',
                'spell_targets',
            },
            name = 'aoe',
            simc_line = 'actions+=/run_action_list,name=aoe,if=active_enemies>2&(spell_targets.chain_lightning>2|spell_targets.lava_beam>2)',
        },
        {
            action = 'run_action_list',
            name = 'single',
            simc_line = 'actions+=/run_action_list,name=single',
        },
    },
    precombat = {
        {
            action = 'flask',
            simc_line = 'actions.precombat=flask,type=whispered_pact',
            type = 'whispered_pact',
        },
        {
            action = 'food',
            name = 'fishbrul_special',
            simc_line = 'actions.precombat+=/food,name=fishbrul_special',
        },
        {
            action = 'augmentation',
            simc_line = 'actions.precombat+=/augmentation,type=defiled',
            type = 'defiled',
        },
        {
            action = 'potion',
            name = 'deadly_grace',
            simc_line = 'actions.precombat+=/potion,name=deadly_grace',
        },
    },
    single = {
        {
            action = 'ascendance',
            condition = 'dot.flame_shock.remains>buff.ascendance.duration&(time>=60|buff.bloodlust.up)&cooldown.lava_burst.remains>0&!buff.stormkeeper.up',
            condition_converted = '((((flame_shock.spell_remains_as_number) > (ascendance.spell_duration_as_number))) and ((((((((time_as_number) >= (60))) or ((bloodlust.spell_remains_as_number > 0))))) and (((((lava_burst.cooldown_remains_as_number) > (0))) and ((not ((stormkeeper.spell_remains_as_number > 0)))))))))',
            condition_keywords = {
                'ascendance.spell_duration',
                'bloodlust.spell_remains',
                'flame_shock.spell_remains',
                'lava_burst.cooldown_remains',
                'stormkeeper.spell_remains',
                'time',
            },
            simc_line = 'actions.single=ascendance,if=dot.flame_shock.remains>buff.ascendance.duration&(time>=60|buff.bloodlust.up)&cooldown.lava_burst.remains>0&!buff.stormkeeper.up',
        },
        {
            action = 'flame_shock',
            condition = '!ticking',
            condition_converted = '(flame_shock.spell_remains == 0)',
            condition_keywords = {
                'flame_shock.spell_remains',
            },
            simc_line = 'actions.single+=/flame_shock,if=!ticking',
        },
        {
            action = 'flame_shock',
            condition = 'maelstrom>=20&remains<=buff.ascendance.duration&cooldown.ascendance.remains+buff.ascendance.duration<=duration',
            condition_converted = '((((maelstrom_as_number) >= (20))) and (((((flame_shock.spell_remains_as_number) <= (ascendance.spell_duration_as_number))) and ((((ascendance.cooldown_remains_as_number + ascendance.spell_duration_as_number)) <= (flame_shock.spell_duration_as_number))))))',
            condition_keywords = {
                'ascendance.cooldown_remains',
                'ascendance.spell_duration',
                'flame_shock.spell_duration',
                'flame_shock.spell_remains',
                'maelstrom',
            },
            simc_line = 'actions.single+=/flame_shock,if=maelstrom>=20&remains<=buff.ascendance.duration&cooldown.ascendance.remains+buff.ascendance.duration<=duration',
        },
        {
            action = 'earth_shock',
            condition = 'maelstrom>=92',
            condition_converted = '((maelstrom_as_number) >= (92))',
            condition_keywords = {
                'maelstrom',
            },
            simc_line = 'actions.single+=/earth_shock,if=maelstrom>=92',
        },
        {
            action = 'icefury',
            condition = 'raid_event.movement.in<5',
            condition_converted = '((raid_event.movement.in_as_number) < (5))',
            condition_keywords = {
                'raid_event.movement.in',
            },
            simc_line = 'actions.single+=/icefury,if=raid_event.movement.in<5',
        },
        {
            action = 'lava_burst',
            condition = 'dot.flame_shock.remains>cast_time&(cooldown_react|buff.ascendance.up)',
            condition_converted = '((((flame_shock.spell_remains_as_number) > (lava_burst.spell_cast_time_as_number))) and (((((cooldown_remains_as_number > 0)) or ((ascendance.spell_remains_as_number > 0))))))',
            condition_keywords = {
                'ascendance.spell_remains',
                'cooldown_remains',
                'flame_shock.spell_remains',
                'lava_burst.spell_cast_time',
            },
            simc_line = 'actions.single+=/lava_burst,if=dot.flame_shock.remains>cast_time&(cooldown_react|buff.ascendance.up)',
        },
        {
            action = 'earthquake',
            condition = 'buff.echoes_of_the_great_sundering.up',
            condition_converted = '(echoes_of_the_great_sundering.spell_remains_as_number > 0)',
            condition_keywords = {
                'echoes_of_the_great_sundering.spell_remains',
            },
            simc_line = 'actions.single+=/earthquake,if=buff.echoes_of_the_great_sundering.up',
        },
        {
            action = 'flame_shock',
            condition = 'maelstrom>=20&buff.elemental_focus.up',
            condition_converted = '((((maelstrom_as_number) >= (20))) and ((elemental_focus.spell_remains_as_number > 0)))',
            condition_keywords = {
                'elemental_focus.spell_remains',
                'maelstrom',
            },
            simc_line = 'actions.single+=/flame_shock,if=maelstrom>=20&buff.elemental_focus.up,target_if=refreshable',
            target_if = 'refreshable',
        },
        {
            action = 'frost_shock',
            condition = 'talent.icefury.enabled&buff.icefury.up&((maelstrom>=20&raid_event.movement.in>buff.icefury.remains)|buff.icefury.remains<(1.5*spell_haste*buff.icefury.stack))',
            condition_converted = '((icefury.talent_enabled) and ((((icefury.spell_remains_as_number > 0)) and (((((((((maelstrom_as_number) >= (20))) and (((raid_event.movement.in_as_number) > (icefury.spell_remains_as_number)))))) or (((icefury.spell_remains_as_number) < ((1.5 * spell_haste_as_number * icefury.spell_stack_as_number))))))))))',
            condition_keywords = {
                'icefury.spell_remains',
                'icefury.spell_stack',
                'icefury.talent_enabled',
                'maelstrom',
                'raid_event.movement.in',
                'spell_haste',
            },
            simc_line = 'actions.single+=/frost_shock,if=talent.icefury.enabled&buff.icefury.up&((maelstrom>=20&raid_event.movement.in>buff.icefury.remains)|buff.icefury.remains<(1.5*spell_haste*buff.icefury.stack))',
        },
        {
            action = 'frost_shock',
            condition = 'buff.icefury.up',
            condition_converted = '(icefury.spell_remains_as_number > 0)',
            condition_keywords = {
                'icefury.spell_remains',
            },
            moving = '1',
            simc_line = 'actions.single+=/frost_shock,moving=1,if=buff.icefury.up',
        },
        {
            action = 'earth_shock',
            condition = 'maelstrom>=86',
            condition_converted = '((maelstrom_as_number) >= (86))',
            condition_keywords = {
                'maelstrom',
            },
            simc_line = 'actions.single+=/earth_shock,if=maelstrom>=86',
        },
        {
            action = 'icefury',
            condition = 'maelstrom<=70&raid_event.movement.in>30&((talent.ascendance.enabled&cooldown.ascendance.remains>buff.icefury.duration)|!talent.ascendance.enabled)',
            condition_converted = '((((maelstrom_as_number) <= (70))) and (((((raid_event.movement.in_as_number) > (30))) and (((((((ascendance.talent_enabled) and (((ascendance.cooldown_remains_as_number) > (icefury.spell_duration_as_number)))))) or ((not ascendance.talent_enabled))))))))',
            condition_keywords = {
                'ascendance.cooldown_remains',
                'ascendance.talent_enabled',
                'icefury.spell_duration',
                'maelstrom',
                'raid_event.movement.in',
            },
            simc_line = 'actions.single+=/icefury,if=maelstrom<=70&raid_event.movement.in>30&((talent.ascendance.enabled&cooldown.ascendance.remains>buff.icefury.duration)|!talent.ascendance.enabled)',
        },
        {
            action = 'liquid_magma_totem',
            condition = 'raid_event.adds.count<3|raid_event.adds.in>50',
            condition_converted = '((((raid_event.adds.count_as_number) < (3))) or (((raid_event.adds.in_as_number) > (50))))',
            condition_keywords = {
                'raid_event.adds.count',
                'raid_event.adds.in',
            },
            simc_line = 'actions.single+=/liquid_magma_totem,if=raid_event.adds.count<3|raid_event.adds.in>50',
        },
        {
            action = 'stormkeeper',
            condition = '(talent.ascendance.enabled&cooldown.ascendance.remains>10)|!talent.ascendance.enabled',
            condition_converted = '(((((ascendance.talent_enabled) and (((ascendance.cooldown_remains_as_number) > (10)))))) or ((not ascendance.talent_enabled)))',
            condition_keywords = {
                'ascendance.cooldown_remains',
                'ascendance.talent_enabled',
            },
            simc_line = 'actions.single+=/stormkeeper,if=(talent.ascendance.enabled&cooldown.ascendance.remains>10)|!talent.ascendance.enabled',
        },
        {
            action = 'totem_mastery',
            condition = 'buff.resonance_totem.remains<10|(buff.resonance_totem.remains<(buff.ascendance.duration+cooldown.ascendance.remains)&cooldown.ascendance.remains<15)',
            condition_converted = '((((resonance_totem.spell_remains_as_number) < (10))) or ((((((resonance_totem.spell_remains_as_number) < ((ascendance.spell_duration_as_number + ascendance.cooldown_remains_as_number)))) and (((ascendance.cooldown_remains_as_number) < (15)))))))',
            condition_keywords = {
                'ascendance.cooldown_remains',
                'ascendance.spell_duration',
                'resonance_totem.spell_remains',
            },
            simc_line = 'actions.single+=/totem_mastery,if=buff.resonance_totem.remains<10|(buff.resonance_totem.remains<(buff.ascendance.duration+cooldown.ascendance.remains)&cooldown.ascendance.remains<15)',
        },
        {
            action = 'lava_beam',
            condition = 'active_enemies>1&spell_targets.lava_beam>1',
            condition_converted = '((((active_enemies_as_number) > (1))) and (((spell_targets_as_number) > (1))))',
            condition_keywords = {
                'active_enemies',
                'spell_targets',
            },
            simc_line = 'actions.single+=/lava_beam,if=active_enemies>1&spell_targets.lava_beam>1',
        },
        {
            action = 'lightning_bolt',
            condition = 'buff.power_of_the_maelstrom.up',
            condition_converted = '(power_of_the_maelstrom.spell_remains_as_number > 0)',
            condition_keywords = {
                'power_of_the_maelstrom.spell_remains',
            },
            simc_line = 'actions.single+=/lightning_bolt,if=buff.power_of_the_maelstrom.up,target_if=!debuff.lightning_rod.up',
            target_if = '!debuff.lightning_rod.up',
        },
        {
            action = 'lightning_bolt',
            condition = 'buff.power_of_the_maelstrom.up',
            condition_converted = '(power_of_the_maelstrom.spell_remains_as_number > 0)',
            condition_keywords = {
                'power_of_the_maelstrom.spell_remains',
            },
            simc_line = 'actions.single+=/lightning_bolt,if=buff.power_of_the_maelstrom.up',
        },
        {
            action = 'chain_lightning',
            condition = 'active_enemies>1&spell_targets.chain_lightning>1',
            condition_converted = '((((active_enemies_as_number) > (1))) and (((spell_targets_as_number) > (1))))',
            condition_keywords = {
                'active_enemies',
                'spell_targets',
            },
            simc_line = 'actions.single+=/chain_lightning,if=active_enemies>1&spell_targets.chain_lightning>1,target_if=!debuff.lightning_rod.up',
            target_if = '!debuff.lightning_rod.up',
        },
        {
            action = 'chain_lightning',
            condition = 'active_enemies>1&spell_targets.chain_lightning>1',
            condition_converted = '((((active_enemies_as_number) > (1))) and (((spell_targets_as_number) > (1))))',
            condition_keywords = {
                'active_enemies',
                'spell_targets',
            },
            simc_line = 'actions.single+=/chain_lightning,if=active_enemies>1&spell_targets.chain_lightning>1',
        },
        {
            action = 'lightning_bolt',
            simc_line = 'actions.single+=/lightning_bolt,target_if=!debuff.lightning_rod.up',
            target_if = '!debuff.lightning_rod.up',
        },
        {
            action = 'flame_shock',
            moving = '1',
            simc_line = 'actions.single+=/flame_shock,moving=1,target_if=refreshable',
            target_if = 'refreshable',
        },
        {
            action = 'earth_shock',
            moving = '1',
            simc_line = 'actions.single+=/earth_shock,moving=1',
        },
    },
}


