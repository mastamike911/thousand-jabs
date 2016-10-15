local _, internal = ...
internal.apls = internal.apls or {}

internal.apls["legion-dev::Tier19P::Warrior_Arms_T19P"] = [[
actions.precombat=flask,type=countless_armies
actions.precombat+=/food,type=nightborne_delicacy_platter
actions.precombat+=/augmentation,type=defiled
actions.precombat+=/snapshot_stats
actions.precombat+=/potion,name=old_war
actions=charge
actions+=/auto_attack
actions+=/potion,name=old_war,if=(target.health.pct<20&buff.battle_cry.up)|target.time_to_die<=26
actions+=/blood_fury,if=buff.battle_cry.up|target.time_to_die<=16
actions+=/berserking,if=buff.battle_cry.up|target.time_to_die<=11
actions+=/arcane_torrent,if=buff.battle_cry_deadly_calm.down&rage.deficit>40
actions+=/battle_cry,if=(buff.bloodlust.up|time>=1)&!gcd.remains&(buff.shattered_defenses.up|(cooldown.colossus_smash.remains&cooldown.warbreaker.remains))|target.time_to_die<=10
actions+=/avatar,if=(buff.bloodlust.up|time>=1)
actions+=/use_item,name=gift_of_radiance
actions+=/hamstring,if=!ptr&buff.battle_cry_deadly_calm.remains>cooldown.hamstring.remains
actions+=/heroic_leap,if=debuff.colossus_smash.up
actions+=/rend,if=remains<gcd
actions+=/focused_rage,if=buff.battle_cry_deadly_calm.remains>cooldown.focused_rage.remains&(buff.focused_rage.stack<3|!cooldown.mortal_strike.up)&((!buff.focused_rage.react&prev_gcd.mortal_strike)|!prev_gcd.mortal_strike)
actions+=/colossus_smash,if=debuff.colossus_smash.down
actions+=/warbreaker,if=debuff.colossus_smash.down
actions+=/ravager
actions+=/overpower,if=buff.overpower.react
actions+=/run_action_list,name=cleave,if=spell_targets.whirlwind>=2&talent.sweeping_strikes.enabled
actions+=/run_action_list,name=aoe,if=spell_targets.whirlwind>=2&!talent.sweeping_strikes.enabled
actions+=/run_action_list,name=execute,if=target.health.pct<=20
actions+=/run_action_list,name=single,if=target.health.pct>20
actions.aoe=mortal_strike
actions.aoe+=/execute,if=buff.stone_heart.react
actions.aoe+=/colossus_smash,if=buff.shattered_defenses.down&buff.precise_strikes.down
actions.aoe+=/warbreaker,if=buff.shattered_defenses.down
actions.aoe+=/whirlwind,if=talent.fervor_of_battle.enabled&(debuff.colossus_smash.up|rage.deficit<50)&(!talent.focused_rage.enabled|buff.battle_cry_deadly_calm.up|buff.cleave.up)
actions.aoe+=/rend,if=remains<=duration*0.3
actions.aoe+=/bladestorm
actions.aoe+=/cleave
actions.aoe+=/whirlwind,if=rage>=60
actions.aoe+=/shockwave
actions.aoe+=/storm_bolt
actions.cleave=mortal_strike
actions.cleave+=/execute,if=buff.stone_heart.react
actions.cleave+=/colossus_smash,if=buff.shattered_defenses.down&buff.precise_strikes.down
actions.cleave+=/warbreaker,if=buff.shattered_defenses.down
actions.cleave+=/focused_rage,if=buff.shattered_defenses.down
actions.cleave+=/whirlwind,if=talent.fervor_of_battle.enabled&(debuff.colossus_smash.up|rage.deficit<50)&(!talent.focused_rage.enabled|buff.battle_cry_deadly_calm.up|buff.cleave.up)
actions.cleave+=/rend,if=remains<=duration*0.3
actions.cleave+=/bladestorm
actions.cleave+=/cleave
actions.cleave+=/whirlwind,if=rage>=100|buff.focused_rage.stack=3
actions.cleave+=/shockwave
actions.cleave+=/storm_bolt
actions.execute=mortal_strike,if=buff.battle_cry.up&buff.focused_rage.stack=3
actions.execute+=/execute,if=buff.battle_cry_deadly_calm.up
actions.execute+=/colossus_smash,if=buff.shattered_defenses.down
actions.execute+=/warbreaker,if=buff.shattered_defenses.down&rage<=30
actions.execute+=/execute,if=buff.shattered_defenses.up&rage>22|buff.shattered_defenses.down
actions.execute+=/bladestorm,interrupt=1,if=raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets
actions.single=mortal_strike,if=buff.battle_cry.up&buff.focused_rage.stack>=1&buff.battle_cry.remains<gcd
actions.single+=/colossus_smash,if=buff.shattered_defenses.down
actions.single+=/warbreaker,if=buff.shattered_defenses.down&cooldown.mortal_strike.remains<gcd
actions.single+=/focused_rage,if=(((!buff.focused_rage.react&prev_gcd.mortal_strike)|!prev_gcd.mortal_strike)&buff.focused_rage.stack<3&(buff.shattered_defenses.up|cooldown.colossus_smash.remains))&rage>60
actions.single+=/mortal_strike
actions.single+=/execute,if=buff.stone_heart.react
actions.single+=/slam
actions.single+=/execute,if=equipped.archavons_heavy_hand
actions.single+=/focused_rage,if=equipped.archavons_heavy_hand
actions.single+=/bladestorm,interrupt=1,if=raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets
]]

internal.apls["legion-dev::Tier19P::Warrior_Fury_T19P"] = [[
actions.precombat=flask,type=countless_armies
actions.precombat+=/food,type=nightborne_delicacy_platter
actions.precombat+=/augmentation,type=defiled
actions.precombat+=/snapshot_stats
actions.precombat+=/potion,name=old_war
actions=auto_attack
actions+=/charge
actions+=/run_action_list,name=movement,if=movement.distance>5
actions+=/heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
actions+=/use_item,name=faulty_countermeasure,if=(spell_targets.whirlwind>1|!raid_event.adds.exists)&((talent.bladestorm.enabled&cooldown.bladestorm.remains=0)|buff.battle_cry.up|target.time_to_die<25)
actions+=/potion,name=old_war,if=(target.health.pct<20&buff.battle_cry.up)|target.time_to_die<30
actions+=/battle_cry,if=(cooldown.odyns_fury.remains=0&(cooldown.bloodthirst.remains=0|(buff.enrage.remains>cooldown.bloodthirst.remains)))
actions+=/avatar,if=buff.battle_cry.up|(target.time_to_die<(cooldown.battle_cry.remains+10))
actions+=/bloodbath,if=buff.dragon_roar.up|(!talent.dragon_roar.enabled&(buff.battle_cry.up|cooldown.battle_cry.remains>10))
actions+=/blood_fury,if=buff.battle_cry.up
actions+=/berserking,if=buff.battle_cry.up
actions+=/arcane_torrent,if=rage<rage.max-40
actions+=/call_action_list,name=two_targets,if=spell_targets.whirlwind=2|spell_targets.whirlwind=3
actions+=/call_action_list,name=aoe,if=spell_targets.whirlwind>3
actions+=/call_action_list,name=single_target
actions.aoe=bloodthirst,if=buff.enrage.down|rage<50
actions.aoe+=/call_action_list,name=bladestorm
actions.aoe+=/odyns_fury,if=buff.battle_cry.up&buff.enrage.up
actions.aoe+=/whirlwind,if=buff.enrage.up
actions.aoe+=/dragon_roar
actions.aoe+=/rampage,if=buff.meat_cleaver.up
actions.aoe+=/bloodthirst
actions.aoe+=/whirlwind
actions.bladestorm=bladestorm,if=buff.enrage.remains>2&(raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets)
actions.movement=heroic_leap
actions.single_target=bloodthirst,if=buff.fujiedas_fury.up&buff.fujiedas_fury.remains<2
actions.single_target+=/execute,if=(artifact.juggernaut.enabled&(!buff.juggernaut.up|buff.juggernaut.remains<2))|buff.stone_heart.react
actions.single_target+=/rampage,if=rage=100&(target.health.pct>20|target.health.pct<20&!talent.massacre.enabled)|buff.massacre.react&buff.enrage.remains<1
actions.single_target+=/berserker_rage,if=talent.outburst.enabled&cooldown.odyns_fury.remains=0&buff.enrage.down
actions.single_target+=/dragon_roar,if=cooldown.odyns_fury.remains>=10|cooldown.odyns_fury.remains<=3
actions.single_target+=/odyns_fury,if=buff.battle_cry.up&buff.enrage.up
actions.single_target+=/rampage,if=buff.enrage.down&buff.juggernaut.down
actions.single_target+=/furious_slash,if=talent.frenzy.enabled&(buff.frenzy.down|buff.frenzy.remains<=3)
actions.single_target+=/raging_blow,if=buff.juggernaut.down&buff.enrage.up
actions.single_target+=/whirlwind,if=buff.wrecking_ball.react&buff.enrage.up
actions.single_target+=/execute,if=talent.inner_rage.enabled|!talent.inner_rage.enabled&rage>50
actions.single_target+=/bloodthirst,if=buff.enrage.down
actions.single_target+=/raging_blow,if=buff.enrage.down
actions.single_target+=/execute,if=artifact.juggernaut.enabled
actions.single_target+=/raging_blow
actions.single_target+=/bloodthirst
actions.single_target+=/furious_slash
actions.single_target+=/call_action_list,name=bladestorm
actions.single_target+=/bloodbath,if=buff.frothing_berserker.up|(rage>80&!talent.frothing_berserker.enabled)
actions.two_targets=whirlwind,if=buff.meat_cleaver.down
actions.two_targets+=/call_action_list,name=bladestorm
actions.two_targets+=/rampage,if=buff.enrage.down|(rage=100&buff.juggernaut.down)|buff.massacre.up
actions.two_targets+=/bloodthirst,if=buff.enrage.down
actions.two_targets+=/odyns_fury,if=buff.battle_cry.up&buff.enrage.up
actions.two_targets+=/raging_blow,if=talent.inner_rage.enabled&spell_targets.whirlwind=2
actions.two_targets+=/whirlwind,if=spell_targets.whirlwind>2
actions.two_targets+=/dragon_roar
actions.two_targets+=/bloodthirst
actions.two_targets+=/whirlwind
]]

internal.apls["legion-dev::Tier19P::Warrior_Protection_T19P"] = [[
actions.precombat=flask,type=countless_armies
actions.precombat+=/food,type=seedbattered_fish_plate
actions.precombat+=/augmentation,type=defiled
actions.precombat+=/snapshot_stats
actions.precombat+=/potion,name=unbending_potion
actions=intercept
actions+=/auto_attack
actions+=/blood_fury
actions+=/berserking
actions+=/arcane_torrent
actions+=/call_action_list,name=prot
actions.prot=shield_block,if=!buff.neltharions_fury.up&((cooldown.shield_slam.remains<6&!buff.shield_block.up)|(cooldown.shield_slam.remains<6+buff.shield_block.remains&buff.shield_block.up))
actions.prot+=/ignore_pain,if=(rage>=60&!talent.vengeance.enabled)|(buff.vengeance_ignore_pain.up&buff.ultimatum.up)|(buff.vengeance_ignore_pain.up&rage>=39)|(talent.vengeance.enabled&!buff.ultimatum.up&!buff.vengeance_ignore_pain.up&!buff.vengeance_focused_rage.up&rage<30)
actions.prot+=/focused_rage,if=(buff.vengeance_focused_rage.up&!buff.vengeance_ignore_pain.up)|(buff.ultimatum.up&buff.vengeance_focused_rage.up&!buff.vengeance_ignore_pain.up)|(talent.vengeance.enabled&buff.ultimatum.up&!buff.vengeance_ignore_pain.up&!buff.vengeance_focused_rage.up)|(talent.vengeance.enabled&!buff.vengeance_ignore_pain.up&!buff.vengeance_focused_rage.up&rage>=30)|(buff.ultimatum.up&buff.vengeance_ignore_pain.up&cooldown.shield_slam.remains=0&rage<10)|(rage>=100)
actions.prot+=/demoralizing_shout,if=incoming_damage_2500ms>health.max*0.20
actions.prot+=/shield_wall,if=incoming_damage_2500ms>health.max*0.50
actions.prot+=/last_stand,if=incoming_damage_2500ms>health.max*0.50&!cooldown.shield_wall.remains=0
actions.prot+=/potion,name=unbending_potion,if=(incoming_damage_2500ms>health.max*0.15&!buff.potion.up)|target.time_to_die<=25
actions.prot+=/call_action_list,name=prot_aoe,if=spell_targets.neltharions_fury>=2
actions.prot+=/focused_rage,if=talent.ultimatum.enabled&buff.ultimatum.up&!talent.vengeance.enabled
actions.prot+=/battle_cry,if=(talent.vengeance.enabled&talent.ultimatum.enabled&cooldown.shield_slam.remains<=5-gcd.max-0.5)|!talent.vengeance.enabled
actions.prot+=/demoralizing_shout,if=talent.booming_voice.enabled&buff.battle_cry.up
actions.prot+=/ravager,if=talent.ravager.enabled&buff.battle_cry.up
actions.prot+=/neltharions_fury,if=incoming_damage_2500ms>health.max*0.20&!buff.shield_block.up
actions.prot+=/shield_slam,if=!(cooldown.shield_block.remains<=gcd.max*2&!buff.shield_block.up&talent.heavy_repercussions.enabled)
actions.prot+=/revenge,if=cooldown.shield_slam.remains<=gcd.max*2
actions.prot+=/devastate
actions.prot_aoe=focused_rage,if=talent.ultimatum.enabled&buff.ultimatum.up&!talent.vengeance.enabled
actions.prot_aoe+=/battle_cry,if=(talent.vengeance.enabled&talent.ultimatum.enabled&cooldown.shield_slam.remains<=5-gcd.max-0.5)|!talent.vengeance.enabled
actions.prot_aoe+=/demoralizing_shout,if=talent.booming_voice.enabled&buff.battle_cry.up
actions.prot_aoe+=/ravager,if=talent.ravager.enabled&buff.battle_cry.up
actions.prot_aoe+=/neltharions_fury,if=buff.battle_cry.up
actions.prot_aoe+=/shield_slam,if=!(cooldown.shield_block.remains<=gcd.max*2&!buff.shield_block.up&talent.heavy_repercussions.enabled)
actions.prot_aoe+=/revenge
actions.prot_aoe+=/thunder_clap,if=spell_targets.thunder_clap>=3
actions.prot_aoe+=/devastate
]]

internal.apls["legion-dev::Tier19H::Warrior_Arms_T19H"] = [[
actions.precombat=flask,type=countless_armies
actions.precombat+=/food,type=nightborne_delicacy_platter
actions.precombat+=/augmentation,type=defiled
actions.precombat+=/snapshot_stats
actions.precombat+=/potion,name=old_war
actions=charge
actions+=/auto_attack
actions+=/potion,name=old_war,if=(target.health.pct<20&buff.battle_cry.up)|target.time_to_die<=26
actions+=/blood_fury,if=buff.battle_cry.up|target.time_to_die<=16
actions+=/berserking,if=buff.battle_cry.up|target.time_to_die<=11
actions+=/arcane_torrent,if=buff.battle_cry_deadly_calm.down&rage.deficit>40
actions+=/battle_cry,if=(buff.bloodlust.up|time>=1)&!gcd.remains&(buff.shattered_defenses.up|(cooldown.colossus_smash.remains&cooldown.warbreaker.remains))|target.time_to_die<=10
actions+=/avatar,if=(buff.bloodlust.up|time>=1)
actions+=/hamstring,if=!ptr&buff.battle_cry_deadly_calm.remains>cooldown.hamstring.remains
actions+=/heroic_leap,if=debuff.colossus_smash.up
actions+=/rend,if=remains<gcd
actions+=/focused_rage,if=buff.battle_cry_deadly_calm.remains>cooldown.focused_rage.remains&(buff.focused_rage.stack<3|!cooldown.mortal_strike.up)&((!buff.focused_rage.react&prev_gcd.mortal_strike)|!prev_gcd.mortal_strike)
actions+=/colossus_smash,if=debuff.colossus_smash.down
actions+=/warbreaker,if=debuff.colossus_smash.down
actions+=/ravager
actions+=/overpower,if=buff.overpower.react
actions+=/run_action_list,name=cleave,if=spell_targets.whirlwind>=2&talent.sweeping_strikes.enabled
actions+=/run_action_list,name=aoe,if=spell_targets.whirlwind>=2&!talent.sweeping_strikes.enabled
actions+=/run_action_list,name=execute,if=target.health.pct<=20
actions+=/run_action_list,name=single,if=target.health.pct>20
actions.aoe=mortal_strike
actions.aoe+=/execute,if=buff.stone_heart.react
actions.aoe+=/colossus_smash,if=buff.shattered_defenses.down&buff.precise_strikes.down
actions.aoe+=/warbreaker,if=buff.shattered_defenses.down
actions.aoe+=/whirlwind,if=talent.fervor_of_battle.enabled&(debuff.colossus_smash.up|rage.deficit<50)&(!talent.focused_rage.enabled|buff.battle_cry_deadly_calm.up|buff.cleave.up)
actions.aoe+=/rend,if=remains<=duration*0.3
actions.aoe+=/bladestorm
actions.aoe+=/cleave
actions.aoe+=/whirlwind,if=rage>=60
actions.aoe+=/shockwave
actions.aoe+=/storm_bolt
actions.cleave=mortal_strike
actions.cleave+=/execute,if=buff.stone_heart.react
actions.cleave+=/colossus_smash,if=buff.shattered_defenses.down&buff.precise_strikes.down
actions.cleave+=/warbreaker,if=buff.shattered_defenses.down
actions.cleave+=/focused_rage,if=buff.shattered_defenses.down
actions.cleave+=/whirlwind,if=talent.fervor_of_battle.enabled&(debuff.colossus_smash.up|rage.deficit<50)&(!talent.focused_rage.enabled|buff.battle_cry_deadly_calm.up|buff.cleave.up)
actions.cleave+=/rend,if=remains<=duration*0.3
actions.cleave+=/bladestorm
actions.cleave+=/cleave
actions.cleave+=/whirlwind,if=rage>=100|buff.focused_rage.stack=3
actions.cleave+=/shockwave
actions.cleave+=/storm_bolt
actions.execute=mortal_strike,if=buff.battle_cry.up&buff.focused_rage.stack=3
actions.execute+=/execute,if=buff.battle_cry_deadly_calm.up
actions.execute+=/colossus_smash,if=buff.shattered_defenses.down
actions.execute+=/warbreaker,if=buff.shattered_defenses.down&rage<=30
actions.execute+=/execute,if=buff.shattered_defenses.up&rage>22|buff.shattered_defenses.down
actions.execute+=/bladestorm,interrupt=1,if=raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets
actions.single=mortal_strike,if=buff.battle_cry.up&buff.focused_rage.stack>=1&buff.battle_cry.remains<gcd
actions.single+=/colossus_smash,if=buff.shattered_defenses.down
actions.single+=/warbreaker,if=buff.shattered_defenses.down&cooldown.mortal_strike.remains<gcd
actions.single+=/focused_rage,if=(((!buff.focused_rage.react&prev_gcd.mortal_strike)|!prev_gcd.mortal_strike)&buff.focused_rage.stack<3&(buff.shattered_defenses.up|cooldown.colossus_smash.remains))&rage>60
actions.single+=/mortal_strike
actions.single+=/execute,if=buff.stone_heart.react
actions.single+=/slam
actions.single+=/execute,if=equipped.archavons_heavy_hand
actions.single+=/focused_rage,if=equipped.archavons_heavy_hand
actions.single+=/bladestorm,interrupt=1,if=raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets
]]

internal.apls["legion-dev::Tier19H::Warrior_Fury_T19H"] = [[
actions.precombat=flask,type=countless_armies
actions.precombat+=/food,type=nightborne_delicacy_platter
actions.precombat+=/augmentation,type=defiled
actions.precombat+=/snapshot_stats
actions.precombat+=/potion,name=old_war
actions=auto_attack
actions+=/charge
actions+=/run_action_list,name=movement,if=movement.distance>5
actions+=/heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
actions+=/use_item,name=faulty_countermeasure,if=(spell_targets.whirlwind>1|!raid_event.adds.exists)&((talent.bladestorm.enabled&cooldown.bladestorm.remains=0)|buff.battle_cry.up|target.time_to_die<25)
actions+=/potion,name=old_war,if=(target.health.pct<20&buff.battle_cry.up)|target.time_to_die<30
actions+=/battle_cry,if=(cooldown.odyns_fury.remains=0&(cooldown.bloodthirst.remains=0|(buff.enrage.remains>cooldown.bloodthirst.remains)))
actions+=/avatar,if=buff.battle_cry.up|(target.time_to_die<(cooldown.battle_cry.remains+10))
actions+=/bloodbath,if=buff.dragon_roar.up|(!talent.dragon_roar.enabled&(buff.battle_cry.up|cooldown.battle_cry.remains>10))
actions+=/blood_fury,if=buff.battle_cry.up
actions+=/berserking,if=buff.battle_cry.up
actions+=/arcane_torrent,if=rage<rage.max-40
actions+=/call_action_list,name=two_targets,if=spell_targets.whirlwind=2|spell_targets.whirlwind=3
actions+=/call_action_list,name=aoe,if=spell_targets.whirlwind>3
actions+=/call_action_list,name=single_target
actions.aoe=bloodthirst,if=buff.enrage.down|rage<50
actions.aoe+=/call_action_list,name=bladestorm
actions.aoe+=/odyns_fury,if=buff.battle_cry.up&buff.enrage.up
actions.aoe+=/whirlwind,if=buff.enrage.up
actions.aoe+=/dragon_roar
actions.aoe+=/rampage,if=buff.meat_cleaver.up
actions.aoe+=/bloodthirst
actions.aoe+=/whirlwind
actions.bladestorm=bladestorm,if=buff.enrage.remains>2&(raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets)
actions.movement=heroic_leap
actions.single_target=bloodthirst,if=buff.fujiedas_fury.up&buff.fujiedas_fury.remains<2
actions.single_target+=/execute,if=(artifact.juggernaut.enabled&(!buff.juggernaut.up|buff.juggernaut.remains<2))|buff.stone_heart.react
actions.single_target+=/rampage,if=rage=100&(target.health.pct>20|target.health.pct<20&!talent.massacre.enabled)|buff.massacre.react&buff.enrage.remains<1
actions.single_target+=/berserker_rage,if=talent.outburst.enabled&cooldown.odyns_fury.remains=0&buff.enrage.down
actions.single_target+=/dragon_roar,if=cooldown.odyns_fury.remains>=10|cooldown.odyns_fury.remains<=3
actions.single_target+=/odyns_fury,if=buff.battle_cry.up&buff.enrage.up
actions.single_target+=/rampage,if=buff.enrage.down&buff.juggernaut.down
actions.single_target+=/furious_slash,if=talent.frenzy.enabled&(buff.frenzy.down|buff.frenzy.remains<=3)
actions.single_target+=/raging_blow,if=buff.juggernaut.down&buff.enrage.up
actions.single_target+=/whirlwind,if=buff.wrecking_ball.react&buff.enrage.up
actions.single_target+=/execute,if=talent.inner_rage.enabled|!talent.inner_rage.enabled&rage>50
actions.single_target+=/bloodthirst,if=buff.enrage.down
actions.single_target+=/raging_blow,if=buff.enrage.down
actions.single_target+=/execute,if=artifact.juggernaut.enabled
actions.single_target+=/raging_blow
actions.single_target+=/bloodthirst
actions.single_target+=/furious_slash
actions.single_target+=/call_action_list,name=bladestorm
actions.single_target+=/bloodbath,if=buff.frothing_berserker.up|(rage>80&!talent.frothing_berserker.enabled)
actions.two_targets=whirlwind,if=buff.meat_cleaver.down
actions.two_targets+=/call_action_list,name=bladestorm
actions.two_targets+=/rampage,if=buff.enrage.down|(rage=100&buff.juggernaut.down)|buff.massacre.up
actions.two_targets+=/bloodthirst,if=buff.enrage.down
actions.two_targets+=/odyns_fury,if=buff.battle_cry.up&buff.enrage.up
actions.two_targets+=/raging_blow,if=talent.inner_rage.enabled&spell_targets.whirlwind=2
actions.two_targets+=/whirlwind,if=spell_targets.whirlwind>2
actions.two_targets+=/dragon_roar
actions.two_targets+=/bloodthirst
actions.two_targets+=/whirlwind
]]

internal.apls["legion-dev::Tier19H::Warrior_Protection_T19H"] = [[
actions.precombat=flask,type=countless_armies
actions.precombat+=/food,type=seedbattered_fish_plate
actions.precombat+=/augmentation,type=defiled
actions.precombat+=/snapshot_stats
actions.precombat+=/potion,name=unbending_potion
actions=intercept
actions+=/auto_attack
actions+=/blood_fury
actions+=/berserking
actions+=/arcane_torrent
actions+=/call_action_list,name=prot
actions.prot=shield_block,if=!buff.neltharions_fury.up&((cooldown.shield_slam.remains<6&!buff.shield_block.up)|(cooldown.shield_slam.remains<6+buff.shield_block.remains&buff.shield_block.up))
actions.prot+=/ignore_pain,if=(rage>=60&!talent.vengeance.enabled)|(buff.vengeance_ignore_pain.up&buff.ultimatum.up)|(buff.vengeance_ignore_pain.up&rage>=39)|(talent.vengeance.enabled&!buff.ultimatum.up&!buff.vengeance_ignore_pain.up&!buff.vengeance_focused_rage.up&rage<30)
actions.prot+=/focused_rage,if=(buff.vengeance_focused_rage.up&!buff.vengeance_ignore_pain.up)|(buff.ultimatum.up&buff.vengeance_focused_rage.up&!buff.vengeance_ignore_pain.up)|(talent.vengeance.enabled&buff.ultimatum.up&!buff.vengeance_ignore_pain.up&!buff.vengeance_focused_rage.up)|(talent.vengeance.enabled&!buff.vengeance_ignore_pain.up&!buff.vengeance_focused_rage.up&rage>=30)|(buff.ultimatum.up&buff.vengeance_ignore_pain.up&cooldown.shield_slam.remains=0&rage<10)|(rage>=100)
actions.prot+=/demoralizing_shout,if=incoming_damage_2500ms>health.max*0.20
actions.prot+=/shield_wall,if=incoming_damage_2500ms>health.max*0.50
actions.prot+=/last_stand,if=incoming_damage_2500ms>health.max*0.50&!cooldown.shield_wall.remains=0
actions.prot+=/potion,name=unbending_potion,if=(incoming_damage_2500ms>health.max*0.15&!buff.potion.up)|target.time_to_die<=25
actions.prot+=/call_action_list,name=prot_aoe,if=spell_targets.neltharions_fury>=2
actions.prot+=/focused_rage,if=talent.ultimatum.enabled&buff.ultimatum.up&!talent.vengeance.enabled
actions.prot+=/battle_cry,if=(talent.vengeance.enabled&talent.ultimatum.enabled&cooldown.shield_slam.remains<=5-gcd.max-0.5)|!talent.vengeance.enabled
actions.prot+=/demoralizing_shout,if=talent.booming_voice.enabled&buff.battle_cry.up
actions.prot+=/ravager,if=talent.ravager.enabled&buff.battle_cry.up
actions.prot+=/neltharions_fury,if=incoming_damage_2500ms>health.max*0.20&!buff.shield_block.up
actions.prot+=/shield_slam,if=!(cooldown.shield_block.remains<=gcd.max*2&!buff.shield_block.up&talent.heavy_repercussions.enabled)
actions.prot+=/revenge,if=cooldown.shield_slam.remains<=gcd.max*2
actions.prot+=/devastate
actions.prot_aoe=focused_rage,if=talent.ultimatum.enabled&buff.ultimatum.up&!talent.vengeance.enabled
actions.prot_aoe+=/battle_cry,if=(talent.vengeance.enabled&talent.ultimatum.enabled&cooldown.shield_slam.remains<=5-gcd.max-0.5)|!talent.vengeance.enabled
actions.prot_aoe+=/demoralizing_shout,if=talent.booming_voice.enabled&buff.battle_cry.up
actions.prot_aoe+=/ravager,if=talent.ravager.enabled&buff.battle_cry.up
actions.prot_aoe+=/neltharions_fury,if=buff.battle_cry.up
actions.prot_aoe+=/shield_slam,if=!(cooldown.shield_block.remains<=gcd.max*2&!buff.shield_block.up&talent.heavy_repercussions.enabled)
actions.prot_aoe+=/revenge
actions.prot_aoe+=/thunder_clap,if=spell_targets.thunder_clap>=3
actions.prot_aoe+=/devastate
]]

