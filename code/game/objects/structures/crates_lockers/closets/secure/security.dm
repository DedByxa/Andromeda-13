/obj/structure/closet/secure_closet/captains
	name = "\proper шкаф капитана"
	req_access = list(ACCESS_CAPTAIN)
	icon_state = "cap"
/obj/structure/closet/secure_closet/captains/PopulateContents() //Excess clothing and such can be found in the Captain's Wardrobe. You can also find this file in code/modules/vending/wardrobes.
	..()
	new /obj/item/clothing/neck/petcollar(src) //I considered removing the pet stuff too but eh, who knows. We might get Renault back. Plus I guess you could use that collar for... other means. Aren't you supposed to be guarding the disk?
	new /obj/item/pet_carrier(src)
	new /obj/item/cartridge/captain(src)
	new /obj/item/storage/box/silver_ids(src)
	new /obj/item/radio/headset/heads/captain/alt(src)
	new /obj/item/radio/headset/heads/captain(src)
	new /obj/item/storage/belt/sabre(src)
	new /obj/item/gun/energy/e_gun(src)
	new /obj/item/door_remote/captain(src)
	new /obj/item/storage/photo_album/Captain(src)
	new /obj/item/mod/construction/armor/magnate(src)
	new /obj/item/mod/module/holster(src)
	new /obj/item/storage/garment_case/captain(src) //BLUEMOON add

/obj/structure/closet/secure_closet/hop
	name = "\proper шкаф главы персонала"
	req_access = list(ACCESS_HOP)
	icon_state = "hop"
/obj/structure/closet/secure_closet/hop/PopulateContents()
	..()
	new /obj/item/cartridge/hop(src)
	new /obj/item/radio/headset/heads/hop(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/storage/box/ids(src)
	new /obj/item/storage/box/ids(src)
	new /obj/item/storage/box/deviants(src) // bluemoon edit
	new /obj/item/storage/box/deviants(src)
	new /obj/item/megaphone/command(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/restraints/handcuffs/cable/zipties(src)
	new /obj/item/gun/energy/e_gun(src)
	new /obj/item/clothing/neck/petcollar(src)
	new /obj/item/pet_carrier(src)
	new /obj/item/door_remote/civillian(src)
	new /obj/item/circuitboard/machine/techfab/department/service(src)
	new /obj/item/storage/photo_album/HoP(src)
	new /obj/item/clothing/suit/hooded/wintercoat/hop(src)
	new /obj/item/clothing/head/hopcap/beret/white(src)
	new /obj/item/storage/garment_case/hop(src) // BLUEMOON add

/obj/structure/closet/secure_closet/hos
	name = "\proper шкаф главы службы безопасносит"
	req_access = list(ACCESS_HOS)
	icon_state = "hos"
/obj/structure/closet/secure_closet/hos/PopulateContents()
	..()
	new /obj/item/clothing/neck/cloak/hos(src)
	new /obj/item/clothing/suit/toggle/armor/hos/hos_formal(src)
	new /obj/item/cartridge/hos(src)
	new /obj/item/radio/headset/heads/hos(src)
	new /obj/item/clothing/under/rank/security/head_of_security/parade/female(src)
	new /obj/item/clothing/under/rank/security/head_of_security/parade(src)
	new /obj/item/clothing/under/rank/security/officer/blueshirt/seccorp/hoscorp(src)
	new /obj/item/clothing/suit/armor/vest/leather(src)
	new /obj/item/clothing/suit/armor/hos(src)
	new /obj/item/clothing/suit/armor/hos/platecarrier(src)
	new /obj/item/clothing/under/rank/security/head_of_security/skirt(src)
	new /obj/item/clothing/under/rank/security/head_of_security/alt(src)
	new /obj/item/clothing/under/rank/security/head_of_security/alt/skirt(src)
	new /obj/item/clothing/head/HoS(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses/eyepatch(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses/gars/supergars(src)
	new /obj/item/clothing/under/rank/security/head_of_security/grey(src)
	new /obj/item/storage/lockbox/medal/sec(src)
	new /obj/item/megaphone/sec(src)
	new /obj/item/holosign_creator/security(src)
	new /obj/item/storage/lockbox/loyalty(src)
	new /obj/item/clothing/mask/gas/sechailer/swat(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/shield/riot/tele(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/pinpointer/nuke(src)
	new /obj/item/circuitboard/machine/techfab/department/security(src)
	new /obj/item/storage/photo_album/HoS(src)
	new /obj/item/clothing/suit/hooded/wintercoat/hos(src)
	new /obj/item/mod/construction/armor/safeguard(src)
	new /obj/item/mod/module/jetpack(src)
	new /obj/item/mod/module/holster(src)

/obj/structure/closet/secure_closet/warden
	name = "\proper шкаф вардена"
	req_access = list(ACCESS_ARMORY)
	icon_state = "warden"
/obj/structure/closet/secure_closet/warden/PopulateContents()
	..()
	new /obj/item/radio/headset/headset_sec(src)
	new /obj/item/stamp/warden(src)
	new /obj/item/clothing/suit/armor/vest/warden(src)
	new /obj/item/clothing/head/warden(src)
	new /obj/item/clothing/head/warden/drill(src)
	new /obj/item/clothing/head/beret/sec/navywarden(src)
	new /obj/item/clothing/suit/armor/vest/warden/alt(src)
	new /obj/item/clothing/under/rank/security/officer/blueshirt/seccorp/wardencorp(src)
	new /obj/item/clothing/under/rank/security/warden/formal(src)
	new /obj/item/clothing/under/rank/security/warden/skirt(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/holosign_creator/security(src)
	new /obj/item/clothing/mask/gas/sechailer(src)
	new /obj/item/storage/box/body_camera(src)
	new /obj/item/storage/box/zipties(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/clothing/gloves/krav_maga/sec(src)
	new /obj/item/door_remote/head_of_security(src)
	new /obj/item/gun/ballistic/shotgun/automatic/combat/warden(src)
	new /obj/item/clothing/head/beret/sec/corporatewarden(src)

/obj/structure/closet/secure_closet/security
	name = "шкаф сотрудника безопасности"
	req_access = list(ACCESS_SECURITY)
	icon_state = "sec"
/obj/structure/closet/secure_closet/security/PopulateContents()
	..()
	new /obj/item/clothing/suit/armor/vest/alt(src)
	new /obj/item/clothing/head/helmet/sec(src)
	new /obj/item/radio/headset/headset_sec(src)
	new /obj/item/radio/headset/headset_sec/alt(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/holosign_creator/security(src)
	new /obj/item/flashlight/seclite(src)
/obj/structure/closet/secure_closet/security/sec
/obj/structure/closet/secure_closet/security/sec/PopulateContents()
	..()
	new /obj/item/storage/belt/security/full(src)
/obj/structure/closet/secure_closet/security/cargo
/obj/structure/closet/secure_closet/security/cargo/PopulateContents()
	..()
	new /obj/item/clothing/accessory/armband/cargo(src)
	new /obj/item/encryptionkey/headset_cargo(src)
/obj/structure/closet/secure_closet/security/engine
/obj/structure/closet/secure_closet/security/engine/PopulateContents()
	..()
	new /obj/item/clothing/accessory/armband/engine(src)
	new /obj/item/encryptionkey/headset_eng(src)
/obj/structure/closet/secure_closet/security/science
/obj/structure/closet/secure_closet/security/science/PopulateContents()
	..()
	new /obj/item/clothing/accessory/armband/science(src)
	new /obj/item/encryptionkey/headset_sci(src)
/obj/structure/closet/secure_closet/security/med
/obj/structure/closet/secure_closet/security/med/PopulateContents()
	..()
	new /obj/item/clothing/accessory/armband/medblue(src)
	new /obj/item/encryptionkey/headset_med(src)

/obj/structure/closet/secure_closet/detective
	name = "\improper шкаф детектива"
	req_access = list(ACCESS_FORENSICS_LOCKERS)
	icon_state = "cabinet"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	material_drop = /obj/item/stack/sheet/mineral/wood
	cutting_tool = TOOL_SCREWDRIVER
	door_anim_time = 0 // no animation

/obj/structure/closet/secure_closet/detective/PopulateContents()
	..()
	new /obj/item/storage/box/evidence(src)
	new /obj/item/radio/headset/headset_sec(src)
	new /obj/item/detective_scanner(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/holosign_creator/security(src)
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/clothing/suit/armor/vest/det_suit(src)
	new /obj/item/storage/belt/holster/full(src)
	new /obj/item/pinpointer/crew(src)

/obj/structure/closet/secure_closet/injection
	name = "шкаф с инъекциями"
	req_access = list(ACCESS_HOS)
/obj/structure/closet/secure_closet/injection/PopulateContents()
	..()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/syringe/lethal/execution(src)
/obj/structure/closet/secure_closet/brig
	name = "тюремный шкафчик"
	req_access = list(ACCESS_BRIG)
	anchored = TRUE
	var/id = null
/obj/structure/closet/secure_closet/evidence
	anchored = TRUE
	name = "шкаф для улик"
	req_access_txt = "0"
	req_one_access_txt = list(ACCESS_ARMORY, ACCESS_FORENSICS_LOCKERS)
/obj/structure/closet/secure_closet/brig/PopulateContents()
	..()
	new /obj/item/clothing/under/rank/prisoner( src )
	new /obj/item/clothing/under/rank/prisoner/skirt( src )
	new /obj/item/clothing/shoes/sneakers/orange( src )
	new /obj/item/radio/headset/headset_prisoner( src )

/obj/structure/closet/secure_closet/courtroom
	name = "судейский шкаф"
	req_access = list(ACCESS_COURT)
/obj/structure/closet/secure_closet/courtroom/PopulateContents()
	..()
	new /obj/item/clothing/shoes/sneakers/brown(src)
	for(var/i in 1 to 3)
		new /obj/item/paper/fluff/jobs/security/court_judgement (src)
	new /obj/item/pen (src)
	new /obj/item/clothing/suit/judgerobe (src)
	new /obj/item/clothing/head/powdered_wig (src)
	new /obj/item/storage/briefcase(src)
/obj/structure/closet/secure_closet/contraband/armory
	anchored = TRUE
	name = "шкаф для контрабанды"
	req_access = list(ACCESS_ARMORY)
/obj/structure/closet/secure_closet/contraband/heads
	anchored = TRUE
	name = "шкаф для контрабанды"
	req_access = list(ACCESS_HEADS)
/obj/structure/closet/secure_closet/armory1
	name = "шкаф с оружием"
	req_access = list(ACCESS_ARMORY)
	icon_state = "armory"
/obj/structure/closet/secure_closet/armory1/PopulateContents()
	..()
	new /obj/item/clothing/suit/hooded/ablative(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/armor/riot(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/helmet/riot(src)
	for(var/i in 1 to 3)
		new /obj/item/shield/riot(src)
/obj/structure/closet/secure_closet/armory2
	name = "armory ballistics locker"
	req_access = list(ACCESS_ARMORY)
	icon_state = "armory"
/obj/structure/closet/secure_closet/armory2/PopulateContents()
	..()
	new /obj/item/storage/box/firingpins(src)
	for(var/i in 1 to 3)
		new /obj/item/storage/box/rubbershot(src)
	for(var/i in 1 to 3)
		new /obj/item/gun/ballistic/shotgun/riot(src)
/obj/structure/closet/secure_closet/armory3
	name = "armory energy gun locker"
	req_access = list(ACCESS_ARMORY)
	icon_state = "armory"
/obj/structure/closet/secure_closet/armory3/PopulateContents()
	..()
	new /obj/item/storage/box/firingpins(src)
	new /obj/item/gun/energy/ionrifle(src)
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/e_gun(src)
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser(src)
/obj/structure/closet/secure_closet/tac
	name = "armory tac locker"
	req_access = list(ACCESS_ARMORY)
	icon_state = "tac"
/obj/structure/closet/secure_closet/tac/PopulateContents()
	..()
	new /obj/item/gun/ballistic/automatic/wt550(src)
	new /obj/item/clothing/head/helmet/alt(src)
	new /obj/item/clothing/mask/gas/sechailer(src)
	new /obj/item/clothing/suit/armor/bulletproof(src)

/obj/structure/closet/secure_closet/lethalshots
	name = "Lethal Ammunition and Riot Staves"
	req_access = list(ACCESS_ARMORY)
	storage_capacity = 50
	icon_state = "tac"
/obj/structure/closet/secure_closet/lethalshots/PopulateContents()
	..()
	new /obj/item/electrostaff(src)
	new /obj/item/electrostaff(src)
	for(var/i in 1 to 3)
		new /obj/item/storage/box/lethalshot(src)
	for(var/k in 1 to 9)
		new /obj/item/kitchen/knife/combat(src)

/obj/structure/closet/secure_closet/labor_camp_security
	name = "labor camp security locker"
	req_access = list(ACCESS_SECURITY)
	icon_state = "sec"

/obj/structure/closet/secure_closet/labor_camp_security/PopulateContents()
	..()
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/head/helmet/sec(src)
	new /obj/item/clothing/under/rank/security/officer(src)
	new /obj/item/clothing/under/rank/security/officer/skirt(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/flashlight/seclite(src)
