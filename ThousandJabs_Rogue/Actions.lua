local _, internal = ...
internal.apls = internal.apls or {}

internal.apls['legion-dev::rogue::assassination'] = [[
actions.precombat=flask,name=flask_of_the_seventh_demon
actions.precombat+=/augmentation,name=defiled
actions.precombat+=/food,name=seedbattered_fish_plate
actions.precombat+=/snapshot_stats
actions.precombat+=/apply_poison
actions.precombat+=/stealth
actions.precombat+=/potion,name=old_war
actions.precombat+=/marked_for_death,if=raid_event.adds.in>40
actions=call_action_list,name=cds
actions+=/call_action_list,name=maintain
actions+=/call_action_list,name=finish,if=(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)&(!dot.rupture.refreshable|(dot.rupture.exsanguinated&dot.rupture.remains>=3.5)|target.time_to_die-dot.rupture.remains<=4)&active_dot.rupture>=spell_targets.rupture
actions+=/call_action_list,name=build,if=(combo_points.deficit>0|energy.time_to_max<1)
actions.build=hemorrhage,if=refreshable
actions.build+=/hemorrhage,cycle_targets=1,if=refreshable&dot.rupture.ticking&spell_targets.fan_of_knives<=3
actions.build+=/fan_of_knives,if=spell_targets>=3|buff.the_dreadlords_deceit.stack>=29
actions.build+=/mutilate,cycle_targets=1,if=(!talent.agonizing_poison.enabled&dot.deadly_poison_dot.refreshable)|(talent.agonizing_poison.enabled&debuff.agonizing_poison.remains<debuff.agonizing_poison.duration*0.3)|(set_bonus.tier19_2pc=1&dot.mutilated_flesh.refreshable)
actions.build+=/mutilate
actions.cds=potion,name=old_war,if=buff.bloodlust.react|target.time_to_die<=25|debuff.vendetta.up
actions.cds+=/blood_fury,if=debuff.vendetta.up
actions.cds+=/berserking,if=debuff.vendetta.up
actions.cds+=/arcane_torrent,if=debuff.vendetta.up&energy.deficit>50
actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|combo_points.deficit>=5
actions.cds+=/vendetta,if=talent.exsanguinate.enabled&cooldown.exsanguinate.remains<5&dot.rupture.ticking
actions.cds+=/vendetta,if=talent.exsanguinate.enabled&(artifact.master_assassin.rank>=4-equipped.convergence_of_fates|equipped.duskwalkers_footpads)&energy.deficit>=75&!(artifact.master_assassin.rank=5-equipped.convergence_of_fates&equipped.duskwalkers_footpads)
actions.cds+=/vendetta,if=!talent.exsanguinate.enabled&energy.deficit>=88-!talent.venom_rush.enabled*10
actions.cds+=/vanish,if=talent.nightstalker.enabled&combo_points>=cp_max_spend&((talent.exsanguinate.enabled&cooldown.exsanguinate.remains<1&(dot.rupture.ticking|time>10))|(!talent.exsanguinate.enabled&dot.rupture.refreshable))
actions.cds+=/vanish,if=talent.subterfuge.enabled&dot.garrote.refreshable&((spell_targets.fan_of_knives<=3&combo_points.deficit>=1+spell_targets.fan_of_knives)|(spell_targets.fan_of_knives>=4&combo_points.deficit>=4))
actions.cds+=/vanish,if=talent.shadow_focus.enabled&energy.time_to_max>=2&combo_points.deficit>=4
actions.cds+=/exsanguinate,if=prev_gcd.1.rupture&dot.rupture.remains>4+4*cp_max_spend
actions.finish=death_from_above,if=combo_points>=cp_max_spend
actions.finish+=/envenom,if=combo_points>=4|(talent.elaborate_planning.enabled&combo_points>=3+!talent.exsanguinate.enabled&buff.elaborate_planning.remains<0.1)
actions.maintain=rupture,if=(talent.nightstalker.enabled&stealthed.rogue)|(talent.exsanguinate.enabled&((combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1)|(!ticking&(time>10|combo_points>=2+artifact.urge_to_kill.enabled))))
actions.maintain+=/rupture,cycle_targets=1,if=combo_points>=cp_max_spend-talent.exsanguinate.enabled&refreshable&(!exsanguinated|remains<=1.5)&target.time_to_die-remains>4
actions.maintain+=/kingsbane,if=(talent.exsanguinate.enabled&dot.rupture.exsanguinated)|(!talent.exsanguinate.enabled&(debuff.vendetta.up|cooldown.vendetta.remains>10))
actions.maintain+=/pool_resource,for_next=1
actions.maintain+=/garrote,cycle_targets=1,if=refreshable&(!exsanguinated|remains<=1.5)&target.time_to_die-remains>4
]]

internal.apls['legion-dev::rogue::outlaw'] = [[
actions.precombat=flask,name=flask_of_the_seventh_demon
actions.precombat+=/augmentation,name=defiled
actions.precombat+=/food,name=seedbattered_fish_plate
actions.precombat+=/snapshot_stats
actions.precombat+=/stealth
actions.precombat+=/potion,name=old_war
actions.precombat+=/marked_for_death,if=raid_event.adds.in>40
actions.precombat+=/roll_the_bones,if=!talent.slice_and_dice.enabled
actions=variable,name=rtb_reroll,value=!talent.slice_and_dice.enabled&(rtb_buffs<=2&!rtb_list.any.6)
actions+=/variable,name=ss_useable_noreroll,value=(combo_points<5+talent.deeper_stratagem.enabled-(buff.broadsides.up|buff.jolly_roger.up)-(talent.alacrity.enabled&buff.alacrity.stack<=4))
actions+=/variable,name=ss_useable,value=(talent.anticipation.enabled&combo_points<4)|(!talent.anticipation.enabled&((variable.rtb_reroll&combo_points<4+talent.deeper_stratagem.enabled)|(!variable.rtb_reroll&variable.ss_useable_noreroll)))
actions+=/call_action_list,name=bf
actions+=/call_action_list,name=cds
actions+=/call_action_list,name=stealth,if=stealthed.rogue|cooldown.vanish.up|cooldown.shadowmeld.up
actions+=/death_from_above,if=energy.time_to_max>2&!variable.ss_useable_noreroll
actions+=/slice_and_dice,if=!variable.ss_useable&buff.slice_and_dice.remains<target.time_to_die&buff.slice_and_dice.remains<(1+combo_points)*1.8
actions+=/roll_the_bones,if=!variable.ss_useable&buff.roll_the_bones.remains<target.time_to_die&(buff.roll_the_bones.remains<=3|variable.rtb_reroll)
actions+=/killing_spree,if=energy.time_to_max>5|energy<15
actions+=/call_action_list,name=build
actions+=/call_action_list,name=finish,if=!variable.ss_useable
actions+=/gouge,if=talent.dirty_tricks.enabled&combo_points.deficit>=1
actions.bf=cancel_buff,name=blade_flurry,if=equipped.shivarran_symmetry&cooldown.blade_flurry.up&buff.blade_flurry.up&spell_targets.blade_flurry>=2|spell_targets.blade_flurry<2&buff.blade_flurry.up
actions.bf+=/blade_flurry,if=spell_targets.blade_flurry>=2&!buff.blade_flurry.up
actions.build=ghostly_strike,if=combo_points.deficit>=1+buff.broadsides.up&!buff.curse_of_the_dreadblades.up&(debuff.ghostly_strike.remains<debuff.ghostly_strike.duration*0.3|(cooldown.curse_of_the_dreadblades.remains<3&debuff.ghostly_strike.remains<14))&(combo_points>=3|(variable.rtb_reroll&time>=10))
actions.build+=/pistol_shot,if=combo_points.deficit>=1+buff.broadsides.up&buff.opportunity.up&(energy.time_to_max>2-talent.quick_draw.enabled|(buff.blunderbuss.up&buff.greenskins_waterlogged_wristcuffs.up))
actions.build+=/saber_slash,if=variable.ss_useable
actions.cds=potion,name=old_war,if=buff.bloodlust.react|target.time_to_die<=25|buff.adrenaline_rush.up
actions.cds+=/blood_fury
actions.cds+=/berserking
actions.cds+=/arcane_torrent,if=energy.deficit>40
actions.cds+=/cannonball_barrage,if=spell_targets.cannonball_barrage>=1
actions.cds+=/adrenaline_rush,if=!buff.adrenaline_rush.up&energy.deficit>0
actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|((raid_event.adds.in>40|buff.true_bearing.remains>15)&combo_points.deficit>=4+talent.deeper_strategem.enabled+talent.anticipation.enabled)
actions.cds+=/sprint,if=equipped.thraxis_tricksy_treads&!variable.ss_useable
actions.cds+=/curse_of_the_dreadblades,if=combo_points.deficit>=4&(!talent.ghostly_strike.enabled|debuff.ghostly_strike.up)
actions.finish=between_the_eyes,if=equipped.greenskins_waterlogged_wristcuffs&!buff.greenskins_waterlogged_wristcuffs.up
actions.finish+=/run_through,if=!talent.death_from_above.enabled|energy.time_to_max<cooldown.death_from_above.remains+3.5
actions.stealth=variable,name=stealth_condition,value=(combo_points.deficit>=2+2*(talent.ghostly_strike.enabled&!debuff.ghostly_strike.up)+buff.broadsides.up&energy>60&!buff.jolly_roger.up&!buff.hidden_blade.up&!buff.curse_of_the_dreadblades.up)
actions.stealth+=/ambush
actions.stealth+=/vanish,if=variable.stealth_condition
actions.stealth+=/shadowmeld,if=variable.stealth_condition
]]

internal.apls['legion-dev::rogue::subtlety'] = [[
actions.precombat=flask,name=flask_of_the_seventh_demon
actions.precombat+=/augmentation,name=defiled
actions.precombat+=/food,name=seedbattered_fish_plate
actions.precombat+=/snapshot_stats
actions.precombat+=/stealth
actions.precombat+=/potion,name=old_war
actions.precombat+=/marked_for_death,if=raid_event.adds.in>40
actions.precombat+=/variable,name=ssw_refund,value=equipped.shadow_satyrs_walk*(4+ssw_refund_offset)
actions.precombat+=/variable,name=stealth_threshold,value=(15+talent.vigor.enabled*35+talent.master_of_shadows.enabled*30+variable.ssw_refund)
actions.precombat+=/enveloping_shadows,if=combo_points>=5
actions.precombat+=/symbols_of_death
actions=call_action_list,name=cds
actions+=/run_action_list,name=stealthed,if=stealthed.all
actions+=/call_action_list,name=finish,if=combo_points>=5|(combo_points>=4&spell_targets.shuriken_storm>=3&spell_targets.shuriken_storm<=4)
actions+=/call_action_list,name=stealth_als,if=combo_points.deficit>=2+talent.premeditation.enabled
actions+=/call_action_list,name=build,if=energy.deficit<=variable.stealth_threshold
actions.build=shuriken_storm,if=spell_targets.shuriken_storm>=2
actions.build+=/gloomblade
actions.build+=/backstab
actions.cds=potion,name=old_war,if=buff.bloodlust.react|target.time_to_die<=25|buff.shadow_blades.up
actions.cds+=/blood_fury,if=stealthed.rogue
actions.cds+=/berserking,if=stealthed.rogue
actions.cds+=/arcane_torrent,if=stealthed.rogue&energy.deficit>70
actions.cds+=/shadow_blades,if=combo_points<=2|(equipped.denial_of_the_halfgiants&combo_points>=1)
actions.cds+=/goremaws_bite,if=!stealthed.all&cooldown.shadow_dance.charges_fractional<=2.45&((combo_points.deficit>=4-(time<10)*2&energy.deficit>50+talent.vigor.enabled*25-(time>=10)*15)|target.time_to_die<8)
actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|(raid_event.adds.in>40&combo_points.deficit>=4+talent.deeper_strategem.enabled+talent.anticipation.enabled)
actions.finish=enveloping_shadows,if=buff.enveloping_shadows.remains<target.time_to_die&buff.enveloping_shadows.remains<=combo_points*1.8
actions.finish+=/death_from_above,if=spell_targets.death_from_above>=6
actions.finish+=/nightblade,cycle_targets=1,if=target.time_to_die>8&((refreshable&(!finality|buff.finality_nightblade.up))|remains<tick_time)
actions.finish+=/death_from_above
actions.finish+=/eviscerate
actions.stealth_als=call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold&(!equipped.shadow_satyrs_walk|cooldown.shadow_dance.charges_fractional>=2.45|energy.deficit>=10)
actions.stealth_als+=/call_action_list,name=stealth_cds,if=spell_targets.shuriken_storm>=5
actions.stealth_als+=/call_action_list,name=stealth_cds,if=(cooldown.shadowmeld.up&!cooldown.vanish.up&cooldown.shadow_dance.charges<=1)
actions.stealth_als+=/call_action_list,name=stealth_cds,if=target.time_to_die<12*cooldown.shadow_dance.charges_fractional*(1+equipped.shadow_satyrs_walk*0.5)
actions.stealth_cds=shadow_dance,if=charges_fractional>=2.45
actions.stealth_cds+=/vanish
actions.stealth_cds+=/sprint_offensive
actions.stealth_cds+=/shadow_dance,if=charges>=2&combo_points<=1
actions.stealth_cds+=/pool_resource,for_next=1,extra_amount=40
actions.stealth_cds+=/shadowmeld,if=energy>=40&energy.deficit>=10+variable.ssw_refund
actions.stealth_cds+=/shadow_dance,if=combo_points<=1
actions.stealthed=symbols_of_death,if=(buff.symbols_of_death.remains<target.time_to_die-4&buff.symbols_of_death.remains<=buff.symbols_of_death.duration*0.3)|equipped.shadow_satyrs_walk&energy.time_to_max<0.25
actions.stealthed+=/call_action_list,name=finish,if=combo_points>=5
actions.stealthed+=/shuriken_storm,if=buff.shadowmeld.down&((combo_points.deficit>=3&spell_targets.shuriken_storm>=2+talent.premeditation.enabled+equipped.shadow_satyrs_walk)|buff.the_dreadlords_deceit.stack>=29)
actions.stealthed+=/shadowstrike
]]

