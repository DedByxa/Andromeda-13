/* Glass stack types
 * Contains:
 *		Glass sheets
 *		Plasma glass
 *		Reinforced glass sheets
 *		Reinforced plasma glass
 *		Titanium glass
 *		Plastitanium glass
 *		Glass shards - TODO: Move this into code/game/object/item/weapons
 */

/*
 * Glass sheets
 */
GLOBAL_LIST_INIT(glass_recipes, list ( \
	new/datum/stack_recipe("directional window", /obj/structure/window/unanchored, time = 10, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("fulltile window", /obj/structure/window/fulltile/unanchored, 2, time = 20, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("shard", /obj/item/shard, 1), \
	null, \
	new/datum/stack_recipe_list("glass working bases", list( \
		new/datum/stack_recipe("chem dish", /obj/item/glasswork/glass_base/dish, 10), \
		new/datum/stack_recipe("lens", /obj/item/glasswork/glass_base/glass_lens, 15), \
		new/datum/stack_recipe("spout flask", /obj/item/glasswork/glass_base/spouty, 20), \
		new/datum/stack_recipe("small bulb flask", /obj/item/glasswork/glass_base/flask_small, 5), \
		new/datum/stack_recipe("large bottle flask", /obj/item/glasswork/glass_base/flask_large, 15), \
		new/datum/stack_recipe("tea cup", /obj/item/glasswork/glass_base/tea_cup, 5), \
		new/datum/stack_recipe("ashtray", /obj/item/ashtray/glass, 1), \
		new/datum/stack_recipe("tea plate", /obj/item/glasswork/glass_base/tea_plate, 5), \
	)), \
))

/obj/item/stack/sheet/glass
	name = "стекло"
	desc = "СВЯТЫЕ УГОДНИКИ! Здесь слишком много стекла."
	singular_name = "glass sheet"
	icon_state = "sheet-glass"
	item_state = "sheet-glass"
	custom_materials = list(/datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/glass
	grind_results = list(/datum/reagent/silicon = 20)
	material_type = /datum/material/glass
	point_value = 1
	tableVariant = /obj/structure/table/glass
	matter_amount = 4
	cost = 500
	shard_type = /obj/item/shard

/obj/item/stack/sheet/glass/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins to slice [user.ru_ego()] neck with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS

/obj/item/stack/sheet/glass/cyborg
	custom_materials = null
	is_cyborg = TRUE
	source = /datum/robot_energy_storage/glass
	cost = MINERAL_MATERIAL_AMOUNT * 0.25

/obj/item/stack/sheet/glass/fifty
	amount = 50

/obj/item/stack/sheet/glass/five
	amount = 5

/obj/item/stack/sheet/glass/get_main_recipes()
	. = ..()
	. += GLOB.glass_recipes

/obj/item/stack/sheet/glass/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if (get_amount() < 1 || CC.get_amount() < 5)
			to_chat(user, "<span class='warning>You need five lengths of coil and one sheet of glass to make wired glass!</span>")
			return
		CC.use(5)
		use(1)
		to_chat(user, "<span class='notice'>You attach wire to the [name].</span>")
		var/obj/item/stack/light_w/new_tile = new(user.loc)
		new_tile.add_fingerprint(user)
		return
	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/V = W
		if (V.get_amount() >= 1 && get_amount() >= 1)
			var/obj/item/stack/sheet/rglass/RG = new (get_turf(user))
			RG.add_fingerprint(user)
			var/replace = user.get_inactive_held_item()==src
			V.use(1)
			use(1)
			if(QDELETED(src) && replace)
				user.put_in_hands(RG)
		else
			to_chat(user, "<span class='warning'>You need one rod and one sheet of glass to make reinforced glass!</span>")
		return
	return ..()



GLOBAL_LIST_INIT(pglass_recipes, list ( \
	new/datum/stack_recipe("directional window", /obj/structure/window/plasma/unanchored, time = 10, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("fulltile window", /obj/structure/window/plasma/fulltile/unanchored, 2, time = 20, on_floor = TRUE, window_checks = TRUE) \
))

/obj/item/stack/sheet/plasmaglass
	name = "plasma glass"
	desc = "A glass sheet made out of a plasma-silicate alloy. It looks extremely tough and heavily fire resistant."
	singular_name = "plasma glass sheet"
	icon_state = "sheet-pglass"
	item_state = "sheet-pglass"
	custom_materials = list(/datum/material/plasma=MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 75, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/plasmaglass
	grind_results = list(/datum/reagent/silicon = 20, /datum/reagent/toxin/plasma = 10)
	tableVariant = /obj/structure/table/plasmaglass
	shard_type = /obj/item/shard/plasma

/obj/item/stack/sheet/plasmaglass/fifty
	amount = 50

/obj/item/stack/sheet/plasmaglass/get_main_recipes()
	. = ..()
	. += GLOB.pglass_recipes

/obj/item/stack/sheet/plasmaglass/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)

	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/V = W
		if (V.get_amount() >= 1 && get_amount() >= 1)
			var/obj/item/stack/sheet/plasmarglass/RG = new (get_turf(user))
			RG.add_fingerprint(user)
			var/replace = user.get_inactive_held_item()==src
			V.use(1)
			use(1)
			if(QDELETED(src) && replace)
				user.put_in_hands(RG)
		else
			to_chat(user, "<span class='warning'>You need one rod and one sheet of plasma glass to make reinforced plasma glass!</span>")
			return
	else
		return ..()

/obj/item/stack/sheet/plasmaglass/on_solar_construction(obj/machinery/power/solar/S)
	S.max_integrity *= 1.2
	S.efficiency *= 1.2

/*
 * Reinforced glass sheets
 */
GLOBAL_LIST_INIT(reinforced_glass_recipes, list ( \
	new/datum/stack_recipe("windoor frame", /obj/structure/windoor_assembly, 5, time = 20, on_floor = TRUE, window_checks = TRUE), \
	null, \
	new/datum/stack_recipe("directional reinforced window", /obj/structure/window/reinforced/unanchored, time = 10, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("fulltile reinforced window", /obj/structure/window/reinforced/fulltile/unanchored, 2, time = 20, on_floor = TRUE, window_checks = TRUE) \
))


/obj/item/stack/sheet/rglass
	name = "армированное стекло"
	desc = "Стекло, в котором, кажется, застряли стержни или что-то еще."
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	item_state = "sheet-rglass"
	custom_materials = list(/datum/material/iron=MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 70, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/rglass
	grind_results = list(/datum/reagent/silicon = 20, /datum/reagent/iron = 10)
	point_value = 4
	matter_amount = 6
	shard_type = /obj/item/shard

/obj/item/stack/sheet/rglass/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	..()

/obj/item/stack/sheet/rglass/on_solar_construction(obj/machinery/power/solar/S)
	S.max_integrity *= 2

/obj/item/stack/sheet/rglass/cyborg
	custom_materials = null
	is_cyborg = TRUE
	source = /datum/robot_energy_storage/metal
	var/datum/robot_energy_storage/glasource = /datum/robot_energy_storage/glass
	var/metcost = MINERAL_MATERIAL_AMOUNT * 0.125
	var/glacost = MINERAL_MATERIAL_AMOUNT * 0.25

/obj/item/stack/sheet/rglass/cyborg/prepare_estorage(obj/item/robot_module/module)
	. = ..()
	if(glasource)
		glasource = module.get_or_create_estorage(glasource)

/obj/item/stack/sheet/rglass/cyborg/get_amount()
	return min(round(source.energy / metcost), round(glasource.energy / glacost))

/obj/item/stack/sheet/rglass/cyborg/use(used, transfer = FALSE) // Requires special checks, because it uses two storages
	source.use_charge(used * metcost)
	glasource.use_charge(used * glacost)
	update_icon()

/obj/item/stack/sheet/rglass/cyborg/add(amount)
	source.add_charge(amount * metcost)
	glasource.add_charge(amount * glacost)
	update_icon()

/obj/item/stack/sheet/rglass/get_main_recipes()
	. = ..()
	. += GLOB.reinforced_glass_recipes

GLOBAL_LIST_INIT(prglass_recipes, list ( \
	new/datum/stack_recipe("directional reinforced window", /obj/structure/window/plasma/reinforced/unanchored, time = 10, on_floor = TRUE, window_checks = TRUE), \
	new/datum/stack_recipe("fulltile reinforced window", /obj/structure/window/plasma/reinforced/fulltile/unanchored, 2, time = 20, on_floor = TRUE, window_checks = TRUE) \
))

/obj/item/stack/sheet/plasmarglass
	name = "reinforced plasma glass"
	desc = "A glass sheet made out of a plasma-silicate alloy and a rod matrix. It looks hopelessly tough and nearly fire-proof!"
	singular_name = "reinforced plasma glass sheet"
	icon_state = "sheet-prglass"
	item_state = "sheet-prglass"
	custom_materials = list(/datum/material/plasma=MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass=MINERAL_MATERIAL_AMOUNT, /datum/material/iron=MINERAL_MATERIAL_AMOUNT * 0.5,)
	armor = list(MELEE = 20, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/plasmarglass
	grind_results = list(/datum/reagent/silicon = 20, /datum/reagent/toxin/plasma = 10, /datum/reagent/iron = 10)
	point_value = 23
	matter_amount = 8
	shard_type = /obj/item/shard/plasma

/obj/item/stack/sheet/plasmarglass/get_main_recipes()
	. = ..()
	. += GLOB.prglass_recipes

/obj/item/stack/sheet/plasmarglass/on_solar_construction(obj/machinery/power/solar/S)
	S.max_integrity *= 2.2
	S.efficiency *= 1.2

GLOBAL_LIST_INIT(titaniumglass_recipes, list(
	new/datum/stack_recipe("shuttle window", /obj/structure/window/shuttle/unanchored, 2, time = 20, on_floor = TRUE, window_checks = TRUE)
	))

/obj/item/stack/sheet/titaniumglass
	name = "titanium glass"
	desc = "A glass sheet made out of a titanium-silicate alloy."
	singular_name = "titanium glass sheet"
	icon_state = "sheet-titaniumglass"
	item_state = "sheet-titaniumglass"
	custom_materials = list(/datum/material/titanium=MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/titaniumglass
	shard_type = /obj/item/shard

/obj/item/stack/sheet/titaniumglass/get_main_recipes()
	. = ..()
	. += GLOB.titaniumglass_recipes

/obj/item/stack/sheet/titaniumglass/on_solar_construction(obj/machinery/power/solar/S)
	S.max_integrity *= 2.5
	S.efficiency *= 1.5

GLOBAL_LIST_INIT(plastitaniumglass_recipes, list(
	new/datum/stack_recipe("plastitanium window", /obj/structure/window/plastitanium/unanchored, 2, time = 20, on_floor = TRUE, window_checks = TRUE)
	))

/obj/item/stack/sheet/plastitaniumglass
	name = "plastitanium glass"
	desc = "A glass sheet made out of a plasma-titanium-silicate alloy."
	singular_name = "plastitanium glass sheet"
	icon_state = "sheet-plastitaniumglass"
	item_state = "sheet-plastitaniumglass"
	custom_materials = list(/datum/material/titanium=MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/plasma=MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 100)
	resistance_flags = ACID_PROOF
	merge_type = /obj/item/stack/sheet/plastitaniumglass
	shard_type = /obj/item/shard/plastitanium

/obj/item/stack/sheet/plastitaniumglass/fifty
	amount = 50

/obj/item/stack/sheet/plastitaniumglass/get_main_recipes()
	. = ..()
	. += GLOB.plastitaniumglass_recipes

/obj/item/stack/sheet/plastitaniumglass/on_solar_construction(obj/machinery/power/solar/S)
	S.max_integrity *= 2
	S.efficiency *= 2

/obj/item/shard
	name = "shard"
	desc = "A nasty looking shard of glass."
	icon = 'icons/obj/shards.dmi'
	icon_state = "large"
	w_class = WEIGHT_CLASS_TINY
	force = 5
	throwforce = 10
	item_state = "shard-glass"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	custom_materials = list(/datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	resistance_flags = ACID_PROOF
	armor = list(MELEE = 100, BULLET = 0, LASER = 0, ENERGY = 100, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 100)
	max_integrity = 40
	sharpness = SHARP_EDGED
	var/icon_prefix
	var/shiv_type = /obj/item/kitchen/knife/shiv
	var/craft_time = 3.5 SECONDS
	var/obj/item/stack/sheet/weld_material = /obj/item/stack/sheet/glass
	embedding = list("embed_chance" = 65)

/obj/item/shard/plasma
	name = "purple shard"
	desc = "A nasty looking shard of plasma glass."
	force = 6
	throwforce = 11
	icon_state = "plasmalarge"
	item_state = "shard-plasma"
	custom_materials = list(/datum/material/alloy/plasmaglass=MINERAL_MATERIAL_AMOUNT)
	icon_prefix = "plasma"
	weld_material = /obj/item/stack/sheet/plasmaglass
	shiv_type = /obj/item/kitchen/knife/shiv/plasma
	craft_time = 7 SECONDS

/obj/item/shard/titanium
	name = "bright shard"
	desc = "A nasty looking shard of titanium infused glass."
	throwforce = 12
	icon_state = "titaniumlarge"
	item_state = "shard-titanium"
	custom_materials = list(/datum/material/alloy/titaniumglass=MINERAL_MATERIAL_AMOUNT)
	icon_prefix = "titanium"
	weld_material = /obj/item/stack/sheet/titaniumglass
	shiv_type = /obj/item/kitchen/knife/shiv/titanium
	craft_time = 7 SECONDS

/obj/item/shard/plastitanium
	name = "dark shard"
	desc = "A nasty looking shard of titanium infused plasma glass."
	force = 7
	throwforce = 12
	icon_state = "plastitaniumlarge"
	item_state = "shard-plastitanium"
	custom_materials = list(/datum/material/alloy/plastitaniumglass=MINERAL_MATERIAL_AMOUNT)
	icon_prefix = "plastitanium"
	weld_material = /obj/item/stack/sheet/plastitaniumglass
	shiv_type = /obj/item/kitchen/knife/shiv/plastitanium
	craft_time = 14 SECONDS


/obj/item/shard/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is slitting [user.ru_ego()] [pick("wrists", "throat")] with the shard of glass! It looks like [user.p_theyre()] trying to commit suicide.</span>")
	return (BRUTELOSS)


/obj/item/shard/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, force)
	AddComponent(/datum/component/butchering, 150, 65)
	icon_state = pick("large", "medium", "small")
	switch(icon_state)
		if("small")
			pixel_x = rand(-12, 12)
			pixel_y = rand(-12, 12)
		if("medium")
			pixel_x = rand(-8, 8)
			pixel_y = rand(-8, 8)
		if("large")
			pixel_x = rand(-5, 5)
			pixel_y = rand(-5, 5)
	if (icon_prefix)
		icon_state = "[icon_prefix][icon_state]"

	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_created", 1, name)

/obj/item/shard/Destroy()
	. = ..()

	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_destroyed", 1, name)

/obj/item/shard/afterattack(atom/A as mob|obj, mob/user, proximity)
	. = ..()
	if(!proximity || !(src in user))
		return
	if(isturf(A))
		return
	if(istype(A, /obj/item/storage))
		return
	var/hit_hand = ((user.active_hand_index % 2 == 0) ? "r_" : "l_") + "arm"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.gloves && !HAS_TRAIT(H, TRAIT_PIERCEIMMUNE)) // golems, etc
			to_chat(H, "<span class='warning'>[src] cuts into your hand!</span>")
			H.apply_damage(force*0.5, BRUTE, hit_hand)
	else if(ismonkey(user))
		var/mob/living/carbon/monkey/M = user
		if(!HAS_TRAIT(M, TRAIT_PIERCEIMMUNE))
			to_chat(M, "<span class='warning'>[src] cuts into your hand!</span>")
			M.apply_damage(force*0.5, BRUTE, hit_hand)


/obj/item/shard/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/lightreplacer))
		var/obj/item/lightreplacer/lightreplacer = item
		lightreplacer.attackby(src, user)
	else if(istype(item, /obj/item/stack/sheet/cloth))
		var/obj/item/stack/sheet/cloth/cloth = item
		to_chat(user, span_notice("You begin to wrap the [cloth] around the [src]..."))
		if(do_after(user, craft_time, target = src))
			var/obj/item/kitchen/knife/shiv/shiv = new shiv_type
			cloth.use(1)
			to_chat(user, span_notice("You wrap the [cloth] around the [src], forming a makeshift weapon."))
			remove_item_from_storage(src, user)
			qdel(src)
			user.put_in_hands(shiv)

	else
		return ..()

/obj/item/shard/welder_act(mob/living/user, obj/item/I)
	if(I.use_tool(src, user, 0, volume=50))
		var/obj/item/stack/sheet/new_glass = new weld_material
		to_chat(user, span_notice("You melt [src] down into [new_glass.name]."))
		new_glass.forceMove((Adjacent(user) ? user.drop_location() : loc)) //stack merging is handled automatically.
		qdel(src)
		return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/item/shard/Crossed(mob/living/L)
	if(istype(L) && has_gravity(loc))
		if(HAS_TRAIT(L, TRAIT_LIGHT_STEP))
			playsound(loc, 'sound/effects/glass_step.ogg', 30, 1)
		else
			playsound(loc, 'sound/effects/glass_step.ogg', 50, 1)
	return ..()

/obj/item/shard/plasma
	name = "purple shard"
	desc = "A nasty looking shard of plasma glass."
	force = 6
	throwforce = 11
	icon_state = "plasmalarge"
	item_state = "shard-plasma"
	custom_materials = list(/datum/material/plasma=MINERAL_MATERIAL_AMOUNT * 0.5, /datum/material/glass=MINERAL_MATERIAL_AMOUNT)
	icon_prefix = "plasma"

/obj/item/shard/plasma/alien
	name = "alien shard"
	desc = "A nasty looking shard of advanced alloy glass."

//Made ashtrays craftable. - Gardelin0
