#define SLAM_COMBO "GH"
#define KICK_COMBO "HH"
#define RESTRAIN_COMBO "GG"
#define PRESSURE_COMBO "DG"
#define CONSECUTIVE_COMBO "DDH"

/datum/martial_art/cqc
	name = "CQC"
	id = MARTIALART_CQC
	help_verb = /mob/living/carbon/human/proc/CQC_help
	block_chance = 75
	pugilist = TRUE
	var/old_grab_state = null
	display_combos = TRUE

/datum/martial_art/cqc/reset_streak(mob/living/carbon/human/new_target)
	. = ..()
	restraining = FALSE

/datum/martial_art/cqc/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	if(findtext(streak,SLAM_COMBO))
		streak = ""
		Slam(A,D)
		return TRUE
	if(findtext(streak,KICK_COMBO))
		streak = ""
		Kick(A,D)
		return TRUE
	if(findtext(streak,RESTRAIN_COMBO))
		streak = ""
		Restrain(A,D)
		return TRUE
	if(findtext(streak,PRESSURE_COMBO))
		streak = ""
		Pressure(A,D)
		return TRUE
	if(findtext(streak,CONSECUTIVE_COMBO))
		streak = ""
		Consecutive(A,D)
	return FALSE

/datum/martial_art/cqc/proc/Slam(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	var/damage = (damage_roll(A,D) + 5)
	if(CHECK_MOBILITY(D, MOBILITY_STAND))
		D.visible_message("<span class='warning'>[A] slams [D] into the ground!</span>", \
						  	"<span class='userdanger'>[A] slams you into the ground!</span>")
		playsound(get_turf(A), 'sound/weapons/slam.ogg', 50, 1, -1)
		D.apply_damage(damage, BRUTE)
		D.Paralyze(12 SECONDS)
		log_combat(A, D, "slammed (CQC)")
	return TRUE


/datum/martial_art/cqc/proc/Kick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	var/damage = damage_roll(A,D)
	if(D.lying && !D.IsUnconscious() && D.getStaminaLoss() > 100)
		log_combat(A, D, "knocked out (Head kick)(CQC)")
		D.visible_message("<span class='warning'>[A] kicks [D]'s head, knocking [D.ru_na()] out!</span>", \
					  		"<span class='userdanger'>[A] kicks your head, knocking you out!</span>")
		playsound(get_turf(A), 'sound/weapons/genhit1.ogg', 50, 1, -1)
		D.Knockdown(20 SECONDS)
		D.Unconscious(10 SECONDS)
		D.adjustOrganLoss(ORGAN_SLOT_BRAIN, damage + 10, 150)
	else
		D.visible_message("<span class='warning'>[A] kicks [D]!</span>", \
							"<span class='userdanger'>[A] kicks you!</span>")
		playsound(get_turf(A), 'sound/weapons/cqchit1.ogg', 50, 1, -1)
		var/atom/throw_target = get_edge_target_turf(D, A.dir)
		D.throw_at(throw_target, 1, 14, A)
		D.apply_damage(damage + 15, BRUTE)
		if(D.lying && !D.IsUnconscious())
			D.adjustStaminaLoss(45)
		log_combat(A, D, "kicked (CQC)")
	
	return TRUE


/datum/martial_art/cqc/proc/Pressure(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	var/damage = (damage_roll(A,D) + 55)
	log_combat(A, D, "pressured (CQC)")
	D.visible_message("<span class='warning'>[A] punches [D]'s neck!</span>")
	D.apply_damage(damage, STAMINA)
	playsound(get_turf(A), 'sound/weapons/cqchit1.ogg', 50, 1, -1)
	return TRUE

/datum/martial_art/cqc/proc/Restrain(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(restraining)
		return
	if(!can_use(A))
		return FALSE
	var/damage = (damage_roll(A,D) + 15)
	if(!D.stat)
		log_combat(A, D, "restrained (CQC)")
		D.visible_message("<span class='warning'>[A] locks [D] into a restraining position!</span>", \
							"<span class='userdanger'>[A] locks you into a restraining position!</span>")
		D.apply_damage(damage, STAMINA)
		D.Stun(10 SECONDS)
		restraining = TRUE
		addtimer(VARSET_CALLBACK(src, restraining, FALSE), 50, TIMER_UNIQUE)
	return TRUE

/datum/martial_art/cqc/proc/Consecutive(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	var/damage = damage_roll(A,D)
	if(!D.stat)
		log_combat(A, D, "consecutive CQC'd (CQC)")
		D.visible_message("<span class='warning'>[A] strikes [D]'s abdomen, neck and back consecutively</span>", \
							"<span class='userdanger'>[A] strikes your abdomen, neck and back consecutively!</span>")
		playsound(get_turf(D), 'sound/weapons/cqchit2.ogg', 50, 1, -1)
		var/obj/item/I = D.get_active_held_item()
		if(I && D.temporarilyRemoveItemFromInventory(I))
			A.put_in_hands(I)
		D.apply_damage(damage + 45, STAMINA)
		D.apply_damage(damage + 20, BRUTE)
	return TRUE

/datum/martial_art/cqc/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(A.a_intent == INTENT_GRAB && A!=D && can_use(A)) // A!=D prevents grabbing yourself
		add_to_streak("G",D)
		if(check_streak(A,D)) //if a combo is made no grab upgrade is done
			return TRUE
		old_grab_state = A.grab_state
		D.grabbedby(A, 1)
		if(old_grab_state == GRAB_PASSIVE)
			D.drop_all_held_items()
			A.setGrabState(GRAB_AGGRESSIVE) //Instant agressive grab if on grab intent
			log_combat(A, D, "grabbed", addition="aggressively")
			D.visible_message("<span class='warning'>[A] violently grabs [D]!</span>", \
								"<span class='userdanger'>[A] violently grabs you!</span>")
		return TRUE
	return FALSE

/datum/martial_art/cqc/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	add_to_streak("H",D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "attacked (CQC)")
	A.do_attack_animation(D)
	var/picked_hit_type = pick("CQC'd", "Big Bossed")
	var/bonus_damage = (damage_roll(A,D) + 7)
	if(!CHECK_MOBILITY(D, MOBILITY_STAND))
		bonus_damage += 5
		picked_hit_type = "stomps on"
	D.apply_damage(bonus_damage, BRUTE)
	if(picked_hit_type == "kicks" || picked_hit_type == "stomps on")
		playsound(get_turf(D), 'sound/weapons/cqchit2.ogg', 50, 1, -1)
	else
		playsound(get_turf(D), 'sound/weapons/cqchit1.ogg', 50, 1, -1)
	D.visible_message("<span class='danger'>[A] [picked_hit_type] [D]!</span>", \
					  "<span class='userdanger'>[A] [picked_hit_type] you!</span>")
	log_combat(A, D, "[picked_hit_type] (CQC)")
	if(!CHECK_MOBILITY(A, MOBILITY_STAND) && !D.stat && CHECK_MOBILITY(D, MOBILITY_STAND))
		D.visible_message("<span class='warning'>[A] leg sweeps [D]!", \
							"<span class='userdanger'>[A] leg sweeps you!</span>")
		playsound(get_turf(A), 'sound/effects/hit_kick.ogg', 50, 1, -1)
		D.apply_damage(bonus_damage, BRUTE)
		D.DefaultCombatKnockdown(60)
		log_combat(A, D, "sweeped (CQC)")
	return TRUE

/datum/martial_art/cqc/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	add_to_streak("D",D)
	var/obj/item/I = null
	var/damage = damage_roll(A,D)
	var/stunthreshold = A.dna.species.punchstunthreshold
	if(check_streak(A,D))
		return TRUE
	if(CHECK_MOBILITY(D, MOBILITY_MOVE) || !restraining)
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		if(damage >= stunthreshold)
			I = D.get_active_held_item()
			D.visible_message("<span class='warning'>[A] strikes [D]'s jaw with their hand!</span>", \
							"<span class='userdanger'>[A] strikes your jaw, disorienting you!</span>")
			playsound(get_turf(D), 'sound/weapons/cqchit1.ogg', 50, 1, -1)
			D.drop_all_held_items()
			D.Jitter(2)
			D.Dizzy(damage)
			D.apply_damage(damage*2 + 20, STAMINA)
			D.apply_damage(damage*0.5, BRUTE)
		else
			D.visible_message("<span class='danger'>[A] strikes [D] in the chest!</span>", \
							"<span class='userdanger'>[A] strikes in chest!</span>")
			playsound(D, 'sound/weapons/cqchit1.ogg', 25, 1, -1)
			D.apply_damage(damage + 15, STAMINA)
			D.apply_damage(damage*0.5, BRUTE)
		log_combat(A, D, "disarmed (CQC)", "[I ? " grabbing \the [I]" : ""]")
	if(restraining && A.pulling == D)
		log_combat(A, D, "knocked out (Chokehold)(CQC)")
		D.visible_message("<span class='danger'>[A] puts [D] into a chokehold!</span>", \
							"<span class='userdanger'>[A] puts you into a chokehold!</span>")
		D.SetSleeping(40 SECONDS)
		restraining = FALSE
		if(A.grab_state < GRAB_NECK)
			A.setGrabState(GRAB_NECK)
	else
		restraining = FALSE
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/CQC_help()
	set name = "Remember The Basics"
	set desc = "You try to remember some of the basics of CQC."
	set category = "CQC"
	to_chat(usr, "<b><i>You try to remember some of the basics of CQC.</i></b>")

	to_chat(usr, "<span class='notice'>Slam</span>: Grab Harm. Slam opponent into the ground, knocking them down.")
	to_chat(usr, "<span class='notice'>CQC Kick</span>: Harm Harm. Knocks opponent away. Knocks out stunned or knocked down opponents.")
	to_chat(usr, "<span class='notice'>Restrain</span>: Grab Grab. Locks opponents into a restraining position, disarm to mute them with a chokehold.")
	to_chat(usr, "<span class='notice'>Pressure</span>: Disarm Grab. Decent stamina damage.")
	to_chat(usr, "<span class='notice'>Consecutive CQC</span>: Disarm Disarm Harm. Mainly offensive move, huge damage and decent stamina damage.")

	to_chat(usr, "<b><i>In addition, by having your throw mode on when being attacked, you enter an active defense mode where you have a chance to block and sometimes even counter attacks done to you.</i></b>")

///BLUEMOON CHANGE версия CQC с ограничением для использования в определённой зоне
///Subtype of CQC. Only used for the chef.
/datum/martial_art/cqc/restricted
	var/list/valid_areas = list()

/datum/martial_art/cqc/restricted/under_siege
	name = "Close Quarters Cooking"
	valid_areas = list(/area/service/kitchen)

///Prevents use if the cook is not in the kitchen.
/datum/martial_art/cqc/restricted/can_use(mob/living/owner) //this is used to make chef CQC only work in kitchen
	if(!is_type_in_list(get_area(owner), valid_areas))
		return FALSE
	return ..()
//BLUEMOON CHANGE END
