if select(3, UnitClass('player')) ~= 8 then return end

local TJ = LibStub('AceAddon-3.0'):GetAddon('ThousandJabs')

TJ:RegisterActionProfileList('simc::mage::arcane', 'Simulationcraft Mage Profile: Arcane', 8, 1, [[
actions.precombat=flask
actions.precombat+=/food
actions.precombat+=/augmentation,type=defiled
actions.precombat+=/summon_arcane_familiar
actions.precombat+=/snapshot_stats
actions.precombat+=/mirror_image
actions.precombat+=/potion
actions.precombat+=/arcane_blast
actions=counterspell,if=target.debuff.casting.react
actions+=/time_warp,if=(buff.bloodlust.down)&((time=0)|(equipped.132410&buff.arcane_power.up&prev_off_gcd.arcane_power)|(target.time_to_die<40))
actions+=/mirror_image,if=buff.arcane_power.down
actions+=/stop_burn_phase,if=prev_gcd.1.evocation&burn_phase_duration>gcd.max
actions+=/mark_of_aluneth,if=cooldown.arcane_power.remains>20
actions+=/call_action_list,name=build,if=buff.arcane_charge.stack<4
actions+=/call_action_list,name=init_burn,if=buff.arcane_power.down&buff.arcane_charge.stack=4&(cooldown.mark_of_aluneth.remains=0|cooldown.mark_of_aluneth.remains>20)&(!talent.rune_of_power.enabled|(cooldown.arcane_power.remains<=action.rune_of_power.cast_time|action.rune_of_power.recharge_time<cooldown.arcane_power.remains))|target.time_to_die<45
actions+=/call_action_list,name=burn,if=burn_phase
actions+=/call_action_list,name=rop_phase,if=buff.rune_of_power.up&!burn_phase
actions+=/call_action_list,name=conserve
actions.build=charged_up,if=buff.arcane_charge.stack<=1
actions.build+=/arcane_missiles,if=buff.arcane_missiles.react=3
actions.build+=/arcane_orb
actions.build+=/arcane_explosion,if=active_enemies>1
actions.build+=/arcane_blast
actions.burn=call_action_list,name=cooldowns
actions.burn+=/charged_up,if=(equipped.132451&buff.arcane_charge.stack<=1)
actions.burn+=/arcane_missiles,if=buff.arcane_missiles.react=3
actions.burn+=/nether_tempest,if=dot.nether_tempest.remains<=2|!ticking
actions.burn+=/arcane_explosion,if=active_enemies>1&mana.pct%10*execute_time>target.time_to_die
actions.burn+=/presence_of_mind,if=buff.rune_of_power.remains<=2*action.arcane_blast.execute_time
actions.burn+=/arcane_missiles,if=buff.arcane_missiles.react>1
actions.burn+=/arcane_explosion,if=active_enemies>1&buff.arcane_power.remains>cast_time
actions.burn+=/arcane_blast,if=buff.presence_of_mind.up|buff.arcane_power.remains>cast_time
actions.burn+=/supernova,if=mana.pct<100
actions.burn+=/arcane_missiles,if=mana.pct>10&(talent.overpowered.enabled|buff.arcane_power.down)
actions.burn+=/arcane_explosion,if=active_enemies>1
actions.burn+=/arcane_barrage,if=talent.charged_up.enabled&(equipped.132451&cooldown.charged_up.remains=0&mana.pct<(100-(buff.arcane_charge.stack*0.03)))
actions.burn+=/arcane_blast
actions.burn+=/evocation,interrupt_if=mana.pct>99
actions.conserve=arcane_missiles,if=buff.arcane_missiles.react=3
actions.conserve+=/arcane_blast,if=mana.pct>99
actions.conserve+=/nether_tempest,if=(refreshable|!ticking)
actions.conserve+=/arcane_blast,if=buff.rhonins_assaulting_armwraps.up&equipped.132413
actions.conserve+=/arcane_missiles
actions.conserve+=/supernova,if=mana.pct<100
actions.conserve+=/arcane_explosion,if=mana.pct>=82&equipped.132451&active_enemies>1
actions.conserve+=/arcane_blast,if=mana.pct>=82&equipped.132451
actions.conserve+=/arcane_barrage,if=mana.pct<100&cooldown.arcane_power.remains>5
actions.conserve+=/arcane_explosion,if=active_enemies>1
actions.conserve+=/arcane_blast
actions.cooldowns=rune_of_power,if=mana.pct>45&buff.arcane_power.down
actions.cooldowns+=/arcane_power
actions.cooldowns+=/blood_fury
actions.cooldowns+=/berserking
actions.cooldowns+=/arcane_torrent
actions.cooldowns+=/potion,if=buff.arcane_power.up
actions.init_burn=mark_of_aluneth
actions.init_burn+=/nether_tempest,if=dot.nether_tempest.remains<10&(prev_gcd.1.mark_of_aluneth|(talent.rune_of_power.enabled&cooldown.rune_of_power.remains<gcd.max))
actions.init_burn+=/rune_of_power
actions.init_burn+=/start_burn_phase,if=((cooldown.evocation.remains-(2*burn_phase_duration))%2<burn_phase_duration)|cooldown.arcane_power.remains=0|target.time_to_die<55
actions.rop_phase=arcane_missiles,if=buff.arcane_missiles.react=3
actions.rop_phase+=/nether_tempest,if=dot.nether_tempest.remains<=2|!ticking
actions.rop_phase+=/arcane_missiles,if=buff.arcane_charge.stack=4
actions.rop_phase+=/arcane_explosion,if=active_enemies>1
actions.rop_phase+=/arcane_blast,if=mana.pct>45
actions.rop_phase+=/arcane_barrage
]])

TJ:RegisterActionProfileList('simc::mage::fire', 'Simulationcraft Mage Profile: Fire', 8, 2, [[
actions.precombat=flask
actions.precombat+=/food
actions.precombat+=/augmentation,type=defiled
actions.precombat+=/snapshot_stats
actions.precombat+=/mirror_image
actions.precombat+=/potion
actions.precombat+=/pyroblast
actions=counterspell,if=target.debuff.casting.react
actions+=/time_warp,if=(time=0&buff.bloodlust.down)|(buff.bloodlust.down&equipped.132410&(cooldown.combustion.remains<1|target.time_to_die.remains<50))
actions+=/mirror_image,if=buff.combustion.down
actions+=/rune_of_power,if=cooldown.combustion.remains>40&buff.combustion.down&!talent.kindling.enabled|target.time_to_die.remains<11|talent.kindling.enabled&(charges_fractional>1.8|time<40)&cooldown.combustion.remains>40
actions+=/call_action_list,name=combustion_phase,if=cooldown.combustion.remains<=action.rune_of_power.cast_time+(!talent.kindling.enabled*gcd)|buff.combustion.up
actions+=/call_action_list,name=rop_phase,if=buff.rune_of_power.up&buff.combustion.down
actions+=/call_action_list,name=standard_rotation
actions.active_talents=blast_wave,if=(buff.combustion.down)|(buff.combustion.up&action.fire_blast.charges<1&action.phoenixs_flames.charges<1)
actions.active_talents+=/meteor,if=cooldown.combustion.remains>15|(cooldown.combustion.remains>target.time_to_die)|buff.rune_of_power.up
actions.active_talents+=/cinderstorm,if=cooldown.combustion.remains<cast_time&(buff.rune_of_power.up|!talent.rune_on_power.enabled)|cooldown.combustion.remains>10*spell_haste&!buff.combustion.up
actions.active_talents+=/dragons_breath,if=equipped.132863|(talent.alexstraszas_fury.enabled&buff.hot_streak.down)
actions.active_talents+=/living_bomb,if=active_enemies>1&buff.combustion.down
actions.combustion_phase=rune_of_power,if=buff.combustion.down
actions.combustion_phase+=/call_action_list,name=active_talents
actions.combustion_phase+=/combustion
actions.combustion_phase+=/potion
actions.combustion_phase+=/blood_fury
actions.combustion_phase+=/berserking
actions.combustion_phase+=/arcane_torrent
actions.combustion_phase+=/pyroblast,if=buff.kaelthas_ultimate_ability.react&buff.combustion.remains>execute_time
actions.combustion_phase+=/pyroblast,if=buff.hot_streak.up
actions.combustion_phase+=/fire_blast,if=buff.heating_up.up
actions.combustion_phase+=/phoenixs_flames
actions.combustion_phase+=/scorch,if=buff.combustion.remains>cast_time
actions.combustion_phase+=/dragons_breath,if=buff.hot_streak.down&action.fire_blast.charges<1&action.phoenixs_flames.charges<1
actions.combustion_phase+=/scorch,if=target.health.pct<=30&equipped.132454
actions.rop_phase=rune_of_power
actions.rop_phase+=/flamestrike,if=((talent.flame_patch.enabled&active_enemies>1)|(active_enemies>3))&buff.hot_streak.up
actions.rop_phase+=/pyroblast,if=buff.hot_streak.up
actions.rop_phase+=/call_action_list,name=active_talents
actions.rop_phase+=/pyroblast,if=buff.kaelthas_ultimate_ability.react&execute_time<buff.kaelthas_ultimate_ability.remains
actions.rop_phase+=/fire_blast,if=!prev_off_gcd.fire_blast
actions.rop_phase+=/phoenixs_flames,if=!prev_gcd.1.phoenixs_flames
actions.rop_phase+=/scorch,if=target.health.pct<=30&equipped.132454
actions.rop_phase+=/dragons_breath,if=active_enemies>2
actions.rop_phase+=/flamestrike,if=(talent.flame_patch.enabled&active_enemies>2)|active_enemies>5
actions.rop_phase+=/fireball
actions.standard_rotation=flamestrike,if=((talent.flame_patch.enabled&active_enemies>1)|active_enemies>3)&buff.hot_streak.up
actions.standard_rotation+=/pyroblast,if=buff.hot_streak.up&buff.hot_streak.remains<action.fireball.execute_time
actions.standard_rotation+=/phoenixs_flames,if=charges_fractional>2.7&active_enemies>2
actions.standard_rotation+=/pyroblast,if=buff.hot_streak.up&!prev_gcd.1.pyroblast
actions.standard_rotation+=/pyroblast,if=buff.hot_streak.react&target.health.pct<=30&equipped.132454
actions.standard_rotation+=/pyroblast,if=buff.kaelthas_ultimate_ability.react&execute_time<buff.kaelthas_ultimate_ability.remains
actions.standard_rotation+=/call_action_list,name=active_talents
actions.standard_rotation+=/fire_blast,if=!talent.kindling.enabled&buff.heating_up.up&(!talent.rune_of_power.enabled|charges_fractional>1.4|cooldown.combustion.remains<40)&(3-charges_fractional)*(12*spell_haste)<cooldown.combustion.remains+3|target.time_to_die.remains<4
actions.standard_rotation+=/fire_blast,if=talent.kindling.enabled&buff.heating_up.up&(!talent.rune_of_power.enabled|charges_fractional>1.5|cooldown.combustion.remains<40)&(3-charges_fractional)*(18*spell_haste)<cooldown.combustion.remains+3|target.time_to_die.remains<4
actions.standard_rotation+=/phoenixs_flames,if=(buff.combustion.up|buff.rune_of_power.up|buff.incanters_flow.stack>3|talent.mirror_image.enabled)&artifact.phoenix_reborn.enabled&(4-charges_fractional)*13<cooldown.combustion.remains+5|target.time_to_die.remains<10
actions.standard_rotation+=/phoenixs_flames,if=(buff.combustion.up|buff.rune_of_power.up)&(4-charges_fractional)*30<cooldown.combustion.remains+5
actions.standard_rotation+=/flamestrike,if=(talent.flame_patch.enabled&active_enemies>1)|active_enemies>5
actions.standard_rotation+=/scorch,if=target.health.pct<=30&equipped.132454
actions.standard_rotation+=/fireball
]])

TJ:RegisterActionProfileList('simc::mage::frost', 'Simulationcraft Mage Profile: Frost', 8, 3, [[
actions.precombat=flask
actions.precombat+=/food
actions.precombat+=/augmentation,type=defiled
actions.precombat+=/water_elemental
actions.precombat+=/snapshot_stats
actions.precombat+=/mirror_image
actions.precombat+=/potion
actions.precombat+=/frostbolt
actions=counterspell,if=target.debuff.casting.react
actions+=/variable,name=time_until_fof,value=10-(time-variable.iv_start-floor((time-variable.iv_start)%10)*10)
actions+=/variable,name=fof_react,value=buff.fingers_of_frost.react
actions+=/variable,name=fof_react,value=buff.fingers_of_frost.stack,if=equipped.lady_vashjs_grasp&buff.icy_veins.up&variable.time_until_fof>9|prev_off_gcd.freeze
actions+=/ice_lance,if=variable.fof_react=0&prev_gcd.1.flurry
actions+=/time_warp,if=(time=0&buff.bloodlust.down)|(buff.bloodlust.down&equipped.132410&(cooldown.icy_veins.remains<1|target.time_to_die<50))
actions+=/call_action_list,name=cooldowns
actions+=/call_action_list,name=aoe,if=active_enemies>=4
actions+=/call_action_list,name=single
actions.aoe=frostbolt,if=prev_off_gcd.water_jet
actions.aoe+=/frozen_orb
actions.aoe+=/blizzard
actions.aoe+=/comet_storm
actions.aoe+=/ice_nova
actions.aoe+=/water_jet,if=prev_gcd.1.frostbolt&buff.fingers_of_frost.stack<(2+artifact.icy_hand.enabled)&buff.brain_freeze.react=0
actions.aoe+=/flurry,if=prev_gcd.1.ebonbolt|prev_gcd.1.frostbolt&buff.brain_freeze.react
actions.aoe+=/frost_bomb,if=debuff.frost_bomb.remains<action.ice_lance.travel_time&variable.fof_react>0
actions.aoe+=/ice_lance,if=variable.fof_react>0
actions.aoe+=/ebonbolt,if=buff.brain_freeze.react=0
actions.aoe+=/glacial_spike
actions.aoe+=/frostbolt
actions.cooldowns=rune_of_power,if=cooldown.icy_veins.remains<cast_time|charges_fractional>1.9&cooldown.icy_veins.remains>10|buff.icy_veins.up|target.time_to_die.remains+5<charges_fractional*10
actions.cooldowns+=/potion,if=cooldown.icy_veins.remains<1
actions.cooldowns+=/variable,name=iv_start,value=time,if=cooldown.icy_veins.ready&buff.icy_veins.down
actions.cooldowns+=/icy_veins,if=buff.icy_veins.down
actions.cooldowns+=/mirror_image
actions.cooldowns+=/blood_fury
actions.cooldowns+=/berserking
actions.cooldowns+=/arcane_torrent
actions.single=ice_nova,if=debuff.winters_chill.up
actions.single+=/frostbolt,if=prev_off_gcd.water_jet
actions.single+=/water_jet,if=prev_gcd.1.frostbolt&buff.fingers_of_frost.stack<(2+artifact.icy_hand.enabled)&buff.brain_freeze.react=0
actions.single+=/ray_of_frost,if=buff.icy_veins.up|(cooldown.icy_veins.remains>action.ray_of_frost.cooldown&buff.rune_of_power.down)
actions.single+=/flurry,if=prev_gcd.1.ebonbolt|prev_gcd.1.frostbolt&buff.brain_freeze.react
actions.single+=/blizzard,if=cast_time=0&active_enemies>1&variable.fof_react<3
actions.single+=/frost_bomb,if=debuff.frost_bomb.remains<action.ice_lance.travel_time&variable.fof_react>0
actions.single+=/ice_lance,if=variable.fof_react>0&cooldown.icy_veins.remains>10|variable.fof_react>2
actions.single+=/frozen_orb
actions.single+=/ice_nova
actions.single+=/comet_storm
actions.single+=/blizzard,if=active_enemies>2|active_enemies>1&!(talent.glacial_spike.enabled&talent.splitting_ice.enabled)|(buff.zannesu_journey.stack=5&buff.zannesu_journey.remains>cast_time)
actions.single+=/ebonbolt,if=buff.brain_freeze.react=0
actions.single+=/glacial_spike
actions.single+=/frostbolt
]])

