#define DEFAULT_SLOT_AMT	2
#define HANDS_SLOT_AMT		2
#define BACKPACK_SLOT_AMT	4

GLOBAL_LIST_EMPTY(preferences_datums)

/datum/preferences
	var/client/parent
//doohickeys for savefiles
	var/path
	var/vr_path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/max_save_slots = 40

	// Intra-round persistence begin
	/// Flags for admin mutes
	var/muted = NONE
	/// Last IP the person was seen on
	var/last_ip
	/// Last CID the person was seen on
	var/last_id
	/// Do we log their clicks to disk?
	var/log_clicks = FALSE
	/// Characters they have joined the round under - Lazylist of names
	var/list/characters_joined_as
	/// Slots they have joined the round under - Lazylist of numbers
	var/list/slots_joined_as
	/// Are we currently subject to respawn restrictions? Usually set by us using the "respawn" verb, but can be lifted by admins.
	var/respawn_restrictions_active = FALSE
	/// time of death we consider for respawns
	var/respawn_time_of_death = -INFINITY
	/// did they DNR? used to prevent respawns.
	var/dnr_triggered = FALSE
	/// did they cryo on their last ghost?
	var/respawn_did_cryo = FALSE

	// Intra-round persistence end

	var/icon/custom_holoform_icon
	var/list/cached_holoform_icons
	var/last_custom_holoform = 0

	//Cooldowns for saving/loading. These are four are all separate due to loading code calling these one after another
	COOLDOWN_DECLARE(saveprefcooldown)
	COOLDOWN_DECLARE(loadprefcooldown)
	COOLDOWN_DECLARE(savecharcooldown)
	COOLDOWN_DECLARE(loadcharcooldown)

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#c43b23"
	var/aooccolor = "#ce254f"
	var/enable_tips = TRUE
	var/tip_delay = 500 //tip delay in milliseconds

	//Antag preferences
	var/list/be_special = list()		//Special role selection. ROLE_INTEQ being missing means they will never be antag!
	var/tmp/old_be_special = 0			//Bitflag version of be_special, used to update old savefiles and nothing more
										//If it's 0, that's good, if it's anything but 0, the owner of this prefs file's antag choices were,
										//autocorrected this round, not that you'd need to check that.

	var/UI_style = null
	var/outline_enabled = TRUE
	var/outline_color = COLOR_THEME_MIDNIGHT
	var/screentip_pref = SCREENTIP_PREFERENCE_ENABLED
	var/screentip_color = "#ffd391"
	var/screentip_images = TRUE
	var/hotkeys = TRUE

	///Runechat preference. If true, certain messages will be displayed on the map, not ust on the chat area. Boolean.
	var/chat_on_map = TRUE
	///Limit preference on the size of the message. Requires chat_on_map to have effect.
	var/max_chat_length = CHAT_MESSAGE_MAX_LENGTH
	///Whether non-mob messages will be displayed, such as machine vendor announcements. Requires chat_on_map to have effect. Boolean.
	var/see_chat_non_mob = TRUE
	///Whether emotes will be displayed on runechat. Requires chat_on_map to have effect. Boolean.
	var/see_rc_emotes = TRUE

	/// Custom Keybindings
	var/list/key_bindings = list()
	/// List with a key string associated to a list of keybindings. Unlike key_bindings, this one operates on raw key, allowing for binding a key that triggers regardless of if a modifier is depressed as long as the raw key is sent.
	var/list/modless_key_bindings = list()

	var/tgui_fancy = TRUE
	var/tgui_lock = TRUE
	var/tgui_input_mode = TRUE			// All the Input Boxes (Text,Number,List,Alert)
	var/tgui_large_buttons = TRUE
	var/tgui_swapped_buttons = FALSE
	var/windowflashing = TRUE
	var/windownoise = TRUE
	var/toggles = TOGGLES_DEFAULT
	/// A separate variable for deadmin toggles, only deals with those.
	var/deadmin = NONE
	var/db_flags
	var/chat_toggles = TOGGLES_DEFAULT_CHAT
	var/ghost_form = "ghost"
	var/ghost_orbit = GHOST_ORBIT_CIRCLE
	var/ghost_accs = GHOST_ACCS_DEFAULT_OPTION
	var/ghost_others = GHOST_OTHERS_DEFAULT_OPTION
	var/ghost_hud = 1
	var/inquisitive_ghost = 1
	var/allow_midround_antag = 1
	var/preferred_map = null
	var/preferred_chaos = null
	var/be_victim = null
	var/use_new_playerpanel = TRUE // BLUEMOON - ENABELING-MODERN-PLAYER-PANEL-AS-DEFAULT
	var/disable_combat_cursor = FALSE
	var/tg_playerpanel = "TG"
	var/pda_style = MONO
	var/pda_color = "#808000"
	var/pda_skin = PDA_SKIN_ALT
	var/pda_ringtone = "beep"
	var/list/alt_titles_preferences = list()

	var/hardsuit_tail_style = null // Пока не используется. Вскоре нужно будет бахнуть новых спрайтов.
	var/custom_blood_color = FALSE
	var/blood_color = BLOOD_COLOR_UNIVERSAL

	var/uses_glasses_colour = 0

	//character preferences
	var/real_name							//our character's name
	var/nameless = FALSE					//whether or not our character is nameless
	var/be_random_name = FALSE				//whether we'll have a random name every round
	var/be_random_body = FALSE				//whether we'll have a random body every round
	var/gender = MALE						//gender of character (well duh)
	var/age = 30							//age of character
	//Sandstorm CHANGES BEGIN
	var/erppref = "Ask"
	var/nonconpref = "Ask"
	var/vorepref = "Ask"
	var/mobsexpref = "No" 					//Added by Gardelin0 - Sex(mostly non-con) with hostile mobs(tentacles)
	var/hornyantagspref = "No" 				//Added by Gardelin0 - Interactions(mostly non-con) with horny antags(Qareen)
	var/extremepref = "No" 					//This is for extreme shit, maybe even literal shit, better to keep it on no by default
	var/extremeharm = "No" 					//If "extreme content" is enabled, this option serves as a toggle for the related interactions to cause damage or not
	var/see_chat_emotes = TRUE
	var/view_pixelshift = FALSE
	var/eorg_enabled = TRUE
	var/enable_personal_chat_color = FALSE
	var/personal_chat_color = "#ffffff"
	var/lust_tolerance = 100
	var/sexual_potency = 15
	//Sandstorm CHANGES END
	var/underwear = "Nude"				//underwear type
	var/undie_color = "FFFFFF"
	var/undershirt = "Nude"				//undershirt type
	var/shirt_color = "FFFFFF"
	var/socks = "Nude"					//socks type
	var/socks_color = "FFFFFF"
	var/backbag = DBACKPACK				//backpack type
	var/jumpsuit_style = PREF_SUIT		//suit/skirt
	var/hair_style = "Bald"				//Hair type
	var/hair_color = "000000"				//Hair color
	var/facial_hair_style = "Shaved"	//Face hair type
	var/facial_hair_color = "000000"		//Facial hair color
	var/grad_style						//Hair gradient style
	var/grad_color = "FFFFFF"			//Hair gradient color
	var/skin_tone = "caucasian1"		//Skin color
	var/use_custom_skin_tone = FALSE
	var/left_eye_color = "000000"		//Eye color
	var/right_eye_color = "000000"
	var/eye_type = DEFAULT_EYES_TYPE	//Eye type
	var/split_eye_colors = FALSE
	var/datum/species/pref_species = new /datum/species/human()	//Mutant race
	var/list/features = list(
"mcolor" = "FFFFFF",
"mcolor2" = "FFFFFF",
"mcolor3" = "FFFFFF",
"tail_lizard" = "Smooth",
"tail_human" = "None",
"snout" = "Round",
"horns" = "None",
"horns_color" = "85615a",
"ears" = "None",
"wings" = "None",
"wings_color" = "FFF",
"frills" = "None",
"deco_wings" = "None",
"spines" = "None",
"legs" = "Plantigrade",
"insect_wings" = "Plain",
"insect_fluff" = "None",
"insect_markings" = "None",
"arachnid_legs" = "Plain",
"arachnid_spinneret" = "Plain",
"arachnid_mandibles" = "Plain",
"mam_body_markings" = list(),
"mam_ears" = "None",
"mam_snouts" = "None",
"mam_tail" = "None",
"mam_tail_animated" = "None",
"xenodorsal" = "Standard",
"xenohead" = "Standard",
"xenotail" = "Xenomorph Tail",
"taur" = "None",
"hardsuit_with_tail" = FALSE,
"genitals_use_skintone" = FALSE,
"has_cock" = FALSE,
"cock_shape" = DEF_COCK_SHAPE,
"cock_length" = COCK_SIZE_DEF,
"cock_diameter_ratio" = COCK_DIAMETER_RATIO_DEF,
"cock_color" = "ffffff",
"cock_taur" = FALSE,
"has_balls" = FALSE,
"balls_color" = "ffffff",
"balls_shape" = DEF_BALLS_SHAPE,
"balls_size" = BALLS_SIZE_DEF,
"balls_cum_rate" = CUM_RATE,
"balls_cum_mult" = CUM_RATE_MULT,
"balls_fluid" = /datum/reagent/consumable/semen,
"balls_efficiency" = CUM_EFFICIENCY,
"has_breasts" = FALSE,
"breasts_color" = "ffffff",
"breasts_size" = BREASTS_SIZE_DEF,
"breasts_shape" = DEF_BREASTS_SHAPE,
"breasts_fluid" = /datum/reagent/consumable/milk,
"breasts_producing" = FALSE,
"has_vag" = FALSE,
"vag_shape" = DEF_VAGINA_SHAPE,
"vag_color" = "ffffff",
"has_womb" = FALSE,
"womb_fluid" = /datum/reagent/consumable/semen/femcum,
"has_butt" = FALSE,
"butt_color" = "ffffff",
"butt_size" = BUTT_SIZE_DEF,
"has_belly" = FALSE,
"has_anus" = FALSE,
"anus_color" = "ffffff",
"anus_shape" = DEF_ANUS_SHAPE,
"belly_color" = "ffffff",
"belly_size" = BELLY_SIZE_DEF,
"balls_visibility"  = GEN_VISIBLE_NO_UNDIES,
"breasts_visibility"= GEN_VISIBLE_NO_UNDIES,
"cock_visibility" = GEN_VISIBLE_NO_UNDIES,
"vag_visibility"   = GEN_VISIBLE_NO_UNDIES,
"butt_visibility" = GEN_VISIBLE_NO_UNDIES,
"belly_visibility" = GEN_VISIBLE_NO_UNDIES,
"anus_visibility" = GEN_VISIBLE_NO_UNDIES,
"breasts_accessible" = FALSE,
"cock_accessible" = FALSE,
"balls_accessible" = FALSE,
"vag_accessible" = FALSE,
"butt_accessible" = FALSE,
"anus_accessible" = FALSE,
"belly_accessible" = FALSE,
"cock_stuffing" = FALSE,
"balls_stuffing" = FALSE,
"vag_stuffing" = FALSE,
"breasts_stuffing" = FALSE,
"butt_stuffing" = FALSE,
"belly_stuffing" = FALSE,
"anus_stuffing" = FALSE,
"inert_eggs" = FALSE,
"ipc_screen" = "Sunburst",
"ipc_antenna" = "None",
"flavor_text" = "",
"naked_flavor_text" = "", //SPLURT edit
"silicon_flavor_text" = "",
"custom_species_lore" = "",
"custom_deathgasp" = "застывает и падает без сил, глаза мертвы и безжизненны...", // BLUEMOON ADD - пользовательский эмоут смерти
"custom_deathsound" = "По умолчанию", // BLUEMOON ADD - пользовательский эмоут смерти
"ooc_notes" = "",
"meat_type" = "Mammalian",
"body_model" = MALE,
"body_size" = RESIZE_DEFAULT_SIZE,
"fuzzy" = FALSE,
"color_scheme" = OLD_CHARACTER_COLORING,
"neckfire" = FALSE,
"neckfire_color" = "ffffff",
"puddle_slime_fea" = FALSE
)

	var/list/custom_emote_panel = list() //user custom emote panel

	var/custom_speech_verb = "default" //if your say_mod is to be something other than your races
	var/custom_tongue = "default" //if your tongue is to be something other than your races
	var/list/language = list() //additional language your character has
	var/modified_limbs = list() //prosthetic/amputated limbs
	var/chosen_limb_id //body sprite selected to load for the users limbs, null means default, is sanitized when loaded

	// Vocal bark prefs
	var/bark_id = "mutedc3"
	var/bark_speed = 4
	var/bark_pitch = 1
	var/bark_variance = 0.2
	COOLDOWN_DECLARE(bark_previewing)
	COOLDOWN_DECLARE(deathsound_preview) // BLUEMOON ADD - пользовательский эмоут смерти

	/// Security record note section
	var/security_records
	/// Medical record note section
	var/medical_records

	var/list/custom_names = list()
	var/preferred_ai_core_display = "Blue"
	var/prefered_security_department = SEC_DEPT_RANDOM
	var/custom_species = null

	//Quirk list
	var/list/all_quirks = list()

	//Quirk category currently selected
	var/quirk_category = QUIRK_POSITIVE // defaults to positive, the first tab!

	//Job preferences 2.0 - indexed by job title , no key or value implies never
	var/list/job_preferences = list()

	// Want randomjob if preferences already filled - Donkie
	var/joblessrole = RETURNTOLOBBY  //defaults to 1 for fewer assistants // BLUEMOON EDIT - было BERANDOMJOB, выставил возвращение в лобби, чтобы не ливали в крио

	// 0 = character settings, 1 = game preferences
	var/current_tab = SETTINGS_TAB

	var/unlock_content = 0

	var/list/ignoring = list()

	var/clientfps = 120

	var/parallax = PARALLAX_INSANE

	var/fullscreen = TRUE

	var/ambientocclusion = TRUE
	///Should we automatically fit the viewport?
	var/auto_fit_viewport = FALSE
	///Should we be in the widescreen mode set by the config?
	var/widescreenpref = TRUE
	///Strip menu style
	var/long_strip_menu = TRUE
	///What size should pixels be displayed as? 0 is strech to fit
	var/pixel_size = 0
	///What scaling method should we use?
	var/scaling_method = "normal"
	var/uplink_spawn_loc = UPLINK_PDA
	///The playtime_reward_cloak variable can be set to TRUE from the prefs menu only once the user has gained over 5K playtime hours. If true, it allows the user to get a cool looking roundstart cloak.
	var/playtime_reward_cloak = FALSE

	var/hud_toggle_flash = TRUE
	var/hud_toggle_color = "#ffffff"

	var/list/exp = list()
	var/list/menuoptions

	var/action_buttons_screen_locs = list()

	//bad stuff
	var/vore_flags = 0
	var/list/belly_prefs = list()
	var/vore_taste = "nothing in particular"
	var/vore_smell = null
	var/toggleeatingnoise = TRUE
	var/toggledigestionnoise = TRUE
	var/hound_sleeper = TRUE
	var/cit_toggles = TOGGLES_CITADEL

	//backgrounds
	var/mutable_appearance/character_background
	var/icon/bgstate = "steel"
	var/list/bgstate_options = list("000", "midgrey", "FFF", "white", "steel", "techmaint", "dark", "plating", "reinforced")

	var/show_mismatched_markings = FALSE //determines whether or not the markings lists should show markings that don't match the currently selected species. Intentionally left unsaved.

	var/character_settings_tab = GENERAL_CHAR_TAB
	var/preferences_tab = GAME_PREFS_TAB
	var/preview_pref = PREVIEW_PREF_JOB

	var/no_tetris_storage = FALSE

	///loadout stuff
	var/gear_points = 20 // Больше очков - сочнее персонажи.
	var/list/gear_categories
	var/list/loadout_data
	var/list/unlockable_loadout_data = list()
	var/loadout_slot = 1 //goes from 1 to MAXIMUM_LOADOUT_SAVES
	var/gear_category
	var/gear_subcategory

	var/screenshake = 100
	var/damagescreenshake = 2
	var/recoil_screenshake = 100
	var/arousable = TRUE
	var/autostand = TRUE
	var/auto_ooc = FALSE

	///This var stores the amount of points the owner will get for making it out alive.
	var/hardcore_survival_score = 0

	///Someone thought we were nice! We get a little heart in OOC until we join the server past the below time (we can keep it until the end of the round otherwise)
	var/hearted
	///If we have a hearted commendations, we honor it every time the player loads preferences until this time has been passed
	var/hearted_until
	/// If we have persistent scars enabled
	var/persistent_scars = TRUE
	///If we want to broadcast deadchat connect/disconnect messages
	var/broadcast_login_logout = TRUE
	///What outfit typepaths we've favorited in the SelectEquipment menu
	var/list/favorite_outfits = list()
	/// We have 5 slots for persistent scars, if enabled we pick a random one to load (empty by default) and scars at the end of the shift if we survived as our original person
	var/list/scars_list = list("1" = "", "2" = "", "3" = "", "4" = "", "5" = "")
	/// Which of the 5 persistent scar slots we randomly roll to load for this round, if enabled. Actually rolled in [/datum/preferences/proc/load_character(slot)]
	var/scars_index = 1

	var/hide_ckey = FALSE //pref for hiding if your ckey shows round-end or not

	var/list/tcg_cards = list()
	var/list/tcg_decks = list()

	//SPLURT EDIT - gregnancy
	/// Does john spaceman's cum actually impregnate people?
	var/virility = 0
	/// Can john spaceman get gregnant if all conditions are right? (has a womb and is not on contraceptives)
	var/fertility = 0
	/// Does john spaceman look like a gluttonous slob if he pregent?
	var/pregnancy_inflation = FALSE
	/// Self explanitory
	var/pregnancy_breast_growth = FALSE

	var/egg_shell = "chicken"
	//SPLURT END

	var/loadout_errors = 0

	var/pref_queue
	var/char_queue

	var/silicon_lawset

/datum/preferences/New(client/C)
	parent = C

	for(var/custom_name_id in GLOB.preferences_custom_names)
		custom_names[custom_name_id] = get_default_name(custom_name_id)

	UI_style = GLOB.available_ui_styles[1]
	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			unlock_content = C.IsByondMember() || IS_CKEY_DONATOR_GROUP(C.key, DONATOR_GROUP_TIER_1)
			if(unlock_content)
				max_save_slots += 8 //SPLURT EDIT
	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			return
	//we couldn't load character data so just randomize the character appearance + name
	random_character()		//let's create a random character then - rather than a fat, bald and naked man.
	key_bindings = deepCopyList(GLOB.hotkey_keybinding_list_by_key) // give them default keybinds and update their movement keys
	C?.ensure_keys_set(src)
	real_name = pref_species.random_name(gender,1)
	if(!loaded_preferences_successfully)
		save_preferences()
	save_character()		//let's save this new random character so it doesn't keep generating new ones.
	menuoptions = list()
	return

#define SETUP_START_NODE(L)  		  	 		 	 		"<div class='csetup_character_node'><div class='csetup_character_label'>[L]</div><div class='csetup_character_input'>"

#define SETUP_GET_LINK(pref, task, task_type, value) 		"<a href='?_src_=prefs;preference=[pref][task ? ";[task_type]=[task]" : ""]'>[value]</a>"
#define SETUP_GET_LINK_RANDOM(random_type) 		  	 		"<a href='?_src_=prefs;preference=toggle_random;random_type=[random_type]'>[randomise[random_type] ? "🎲" : "🔒"]</a>"
#define SETUP_COLOR_BOX(color) 				  	 	 		"<span style='border: 1px solid #161616; background-color: #[color];'>&nbsp;&nbsp;&nbsp;</span>"

#define SETUP_NODE_SWITCH(label, pref, value)		  		"[SETUP_START_NODE(label)][SETUP_GET_LINK(pref, null, null, value)][SETUP_CLOSE_NODE]"
#define SETUP_NODE_INPUT(label, pref, value)		  		"[SETUP_START_NODE(label)][SETUP_GET_LINK(pref, "input", "task", value)][SETUP_CLOSE_NODE]"
#define SETUP_NODE_COLOR(label, pref, color, random)  		"[SETUP_START_NODE(label)][SETUP_COLOR_BOX(color)][SETUP_GET_LINK(pref, "input", "task", "Изменить")][random ? "[SETUP_GET_LINK_RANDOM(random)]" : ""][SETUP_CLOSE_NODE]"
#define SETUP_NODE_RANDOM(label, random)		  	  		"[SETUP_START_NODE(label)][SETUP_GET_LINK_RANDOM(random)][SETUP_CLOSE_NODE]"
#define SETUP_NODE_INPUT_RANDOM(label, pref, value, random) "[SETUP_START_NODE(label)][SETUP_GET_LINK(pref, "input", "task", value)][SETUP_GET_LINK_RANDOM(random)][SETUP_CLOSE_NODE]"
#define SETUP_NODE_COLOR_RANDOM(label, pref, color, random) "[SETUP_START_NODE(label)][SETUP_COLOR_BOX(color)][SETUP_GET_LINK(pref, "input", "task", "Изменить")][SETUP_GET_LINK_RANDOM(random)][SETUP_CLOSE_NODE]"

#define SETUP_CLOSE_NODE 	  			  			  		"</div></div>"

#define APPEARANCE_CATEGORY_COLUMN "<td valign='top' width='17%'>"
#define MAX_MUTANT_ROWS 5

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)
		return
	update_preview_icon(current_tab)
	var/list/dat = list("<center>")

	dat += "<a href='?_src_=prefs;preference=tab;tab=[SETTINGS_TAB]' [current_tab == SETTINGS_TAB ? "class='linkOn'" : ""]>Персонаж</a>"
	dat += "<a href='?_src_=prefs;preference=tab;tab=[PREFERENCES_TAB]' [current_tab == PREFERENCES_TAB ? "class='linkOn'" : ""]>Предпочтения</a>"
	dat += "<a href='?_src_=prefs;preference=tab;tab=[KEYBINDINGS_TAB]' [current_tab == KEYBINDINGS_TAB ? "class='linkOn'" : ""]>Назначение кнопок</a>"

	if(!path)
		dat += "<div class='notice'>Please create an account to save your preferences</div>"

	dat += "</center>"

	dat += "<HR>"

	switch(current_tab)
		if(SETTINGS_TAB) // Character Settings#
			if(path)
				var/savefile/S = new /savefile(path)
				if(S)
					dat += "<center>"
					var/name
					var/unspaced_slots = 0
					for(var/i=1, i<=max_save_slots, i++)
						unspaced_slots++
						if(unspaced_slots > 4)
							dat += "<br>"
							unspaced_slots = 0
						S.cd = "/character[i]"
						S["real_name"] >> name
						if(!name)
							name = "Слот[i]"
						dat += "<a style='white-space:nowrap;' href='?_src_=prefs;preference=changeslot;num=[i];' [i == default_slot ? "class='linkOn'" : ""]>[name]</a> "
					dat += "</center>"

			dat += "<HR>"

			dat += "<center>"
			var/savefile/client_file = new(user.client.Import())
			var/savefile_name
			if(istype(client_file, /savefile))
				if(!client_file["deleted"] || savefile_needs_update(client_file) != -2)
					client_file["real_name"] >> savefile_name
			dat += "Локальное хранилище: [savefile_name ? savefile_name : "Пусто"]"
			dat += "<br />"
			dat += "<a href='?_src_=prefs;preference=export_slot'>Экспорт из текущего слота</a>"
			dat += "<a [savefile_name ? "href='?_src_=prefs;preference=import_slot' style='white-space:normal;'" : "class='linkOff'"]>Импорт в текущий слот</a>"
			dat += "<a href='?_src_=prefs;preference=delete_local_copy' style='white-space:normal;background:#eb2e2e;'>Удалить сохранённый экспорт</a>"
			dat += "<br />"
			dat += "<a href='?_src_=prefs;preference=give_slot' [offer ? "style='white-space:normal;background:#eb2e2e;'" : ""]>[offer ? "Cancel offer" : "Offer slot"]</a>"
			dat += "<a href='?_src_=prefs;preference=retrieve_slot'>Retrieve offered character</a>"
			if(offer)
				dat += "<br />"
				dat += "The redemption code is <b>[offer.redemption_code]</b>"
				dat += "<br />"
				dat += "The offer will automatically be cancelled if there is an error, or if someone takes it"

			dat += "</center>"

			dat += "<HR>"

			dat += "<center>"
			dat += "<a href='?_src_=prefs;preference=character_tab;tab=[GENERAL_CHAR_TAB]' [character_settings_tab == GENERAL_CHAR_TAB ? "class='linkOn'" : ""]>Общее</a>"
			dat += "<a href='?_src_=prefs;preference=character_tab;tab=[BACKGROUND_CHAR_TAB]' [character_settings_tab == BACKGROUND_CHAR_TAB ? "class='linkOn'" : ""]>Описание</a>"
			dat += "<a href='?_src_=prefs;preference=character_tab;tab=[APPEARANCE_CHAR_TAB]' [character_settings_tab == APPEARANCE_CHAR_TAB ? "class='linkOn'" : ""]>Внешность</a>"
			dat += "<a href='?_src_=prefs;preference=character_tab;tab=[MARKINGS_CHAR_TAB]' [character_settings_tab == MARKINGS_CHAR_TAB ? "class='linkOn'" : ""]>Тату</a>"
			dat += "<a href='?_src_=prefs;preference=character_tab;tab=[SPEECH_CHAR_TAB]' [character_settings_tab == SPEECH_CHAR_TAB ? "class='linkOn'" : ""]>Голос</a>"
			dat += "<a href='?_src_=prefs;preference=character_tab;tab=[LOADOUT_CHAR_TAB]' [character_settings_tab == LOADOUT_CHAR_TAB ? "class='linkOn'" : ""]>Раундстарт вещи</a>" //If you change the index of this tab, change all the logic regarding tab
			dat += "</center>"

			dat += "<HR>"
			dat += "<center>"
			dat += "<table width='100%'>"
			dat += "<tr>"
			dat += "<td width=35% style=\"line-height:5px\">"
			dat += "<center><b>Предварительный просмотр:</b></center><br>"
			dat += "<center style=\"line-height:20px\">"
			dat += "<a href='?_src_=prefs;preference=character_preview;tab=[PREVIEW_PREF_JOB]' [preview_pref == PREVIEW_PREF_JOB ? "class='linkOn'" : ""]>[PREVIEW_PREF_JOB]</a>"
			dat += "<a href='?_src_=prefs;preference=character_preview;tab=[PREVIEW_PREF_LOADOUT]' [preview_pref == PREVIEW_PREF_LOADOUT ? "class='linkOn'" : ""]>[PREVIEW_PREF_LOADOUT]</a>"
			dat += "<a href='?_src_=prefs;preference=character_preview;tab=[PREVIEW_PREF_NAKED]' [preview_pref == PREVIEW_PREF_NAKED ? "class='linkOn'" : ""]>[PREVIEW_PREF_NAKED]</a>"
			dat += "<br>"
			dat += "<a href='?_src_=prefs;preference=character_preview;tab=[PREVIEW_PREF_NAKED_AROUSED]' [preview_pref == PREVIEW_PREF_NAKED_AROUSED ? "class='linkOn'" : ""]>[PREVIEW_PREF_NAKED_AROUSED]</a>"
			dat += "</center>"
			dat += "</td>"
			if(character_settings_tab == LOADOUT_CHAR_TAB) //if loadout
				//calculate your gear points from the chosen item
				gear_points = CONFIG_GET(number/initial_gear_points)
				var/list/chosen_gear = loadout_data["SAVE_[loadout_slot]"]
				if(islist(chosen_gear))
					loadout_errors = 0
					for(var/loadout_item in chosen_gear)
						var/loadout_item_path = loadout_item[LOADOUT_ITEM]
						if(!loadout_item_path)
							loadout_errors++
							continue
						var/datum/gear/loadout_gear = text2path(loadout_item_path)
						if(!loadout_gear)
							loadout_errors++
							continue
						gear_points -= initial(loadout_gear.cost)
				else
					chosen_gear = list()

				dat += "<td width=65% style=\"line-height:10px\">"
				dat += "<center><b><font color='[gear_points == 0 ? "#E62100" : "#CCDDFF"]'>[gear_points]</font> Поинты для стартовых[gear_points == 1 ? "" : "s"] вещей</center><br>"
				dat += "<center><a href='?_src_=prefs;preference=gear;clear_loadout=1'>Очистить стартовые вещи</a></b></center>"
				dat += "</td>"
			else
				dat += "<td width=35% style=\"line-height:10px\">"
				dat += "<center><b>Несовпадающие детали:</b></center><br>"
				dat += "<center><a href='?_src_=prefs;preference=mismatched_markings;task=input'>[(show_mismatched_markings) ? "Включено" : "Отключено"]</a></center>"
				dat += "</td>"

				dat += "<td width=30% style=\"line-height:10px\">"
				dat += "<center><b>Расширенные цвета:</b></center><br>"
				dat += "<center><a href='?_src_=prefs;preference=color_scheme;task=input'>[(features["color_scheme"] == ADVANCED_CHARACTER_COLORING) ? "Включено" : "Отключено"]</a></center>"
				dat += "</td>"

			dat += "</tr>"
			dat += "</table>"
			dat += "</center>"
			dat += "<HR>"
			switch(character_settings_tab)
				//General
				if(GENERAL_CHAR_TAB)
					dat += "<center><h2>Выбор профессии</h2>"
					dat += "<a href='?_src_=prefs;preference=job;task=menu'>Установить желаемую должность</a><br></center>"
					if(CONFIG_GET(flag/roundstart_traits))
						dat += "<center><h2>Навыки персонажа ([GetQuirkBalance(user)] points left)</h2>"
						dat += "<a href='?_src_=prefs;preference=trait;task=menu'>Настройка навыков</a><br></center>"
						dat += "<center><b>Очки для навыков:</b> [english_list(all_quirks, "Нету")]</center>"
					dat += "<h2>Идентификация</h2>"
					dat += "<table width='100%'><tr><td width='30%' valign='top'>"
					if(jobban_isbanned(user, "appearance"))
						dat += "<b>Вам запрещено использовать пользовательские имена и внешность. Вы можете продолжать настраивать своих персонажей, но как только вы присоединитесь к игре, вы будете выбраны случайным образом.</b><br>"

					dat += "<b>[nameless ? "Обозначение по умолчанию" : "Никнейм"]:</b><br>"
					dat += "<a href='?_src_=prefs;preference=name;task=input'>[real_name]</a><BR>"
					dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=name;task=random'>Рандомный ник</a><br>"
					dat += "<a href='?_src_=prefs;preference=nameless'>Быть безымянным: [nameless ? "Да" : "Нет"]</a><BR>"
					dat += "<b>Всегда случайное имя:</b><a style='display:block;width:30px' href='?_src_=prefs;preference=name'>[be_random_name ? "Да" : "Нет"]</a><BR>"
					dat += "<b>Жесткий костюм с Хвостом:</b><a style='display:block;width:30px' href='?_src_=prefs;preference=hardsuit_with_tail'>[features["hardsuit_with_tail"] == TRUE ? "Да" : "Нет"]</a><BR>"

					dat += "<b>Сколько лет:</b> <a style='display:block;width:30px' href='?_src_=prefs;preference=age;task=input'>[age]</a><BR>"
					dat += "<b>Кастомный цвет крови:</b>"
					dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=toggle_custom_blood_color;task=input'>[custom_blood_color ? "Включено" : "Отключено"]</a><BR>"
					if(custom_blood_color)
						dat += "<b>Цвет крови:</b> <span style='border:1px solid #161616; background-color: [blood_color];'><font color='[color_hex2num(blood_color) < 200 ? "FFFFFF" : "000000"]'>[blood_color]</font></span> <a href='?_src_=prefs;preference=blood_color;task=input'>Изменить</a><BR>"
					dat += "</td>"

					dat += "<td valign='top'>"
					dat += "<b>Специальные ники:</b><BR>"
					var/old_group
					for(var/custom_name_id in GLOB.preferences_custom_names)
						var/namedata = GLOB.preferences_custom_names[custom_name_id]
						if(!old_group)
							old_group = namedata["group"]
						else if(old_group != namedata["group"])
							old_group = namedata["group"]
							dat += "<br>"
						dat += "<a href ='?_src_=prefs;preference=[custom_name_id];task=input'><b>[namedata["pref_name"]]:</b> [custom_names[custom_name_id]]</a> "
					dat += "<br><br>"

					dat += "<b>Кастомные предпочтения профессии:</b><BR>"
					dat += "<a href='?_src_=prefs;preference=ai_core_icon;task=input'><b>Предпочтительный дисплей ядра ИИ:</b> [preferred_ai_core_display]</a><br>"
					dat += "<a href='?_src_=prefs;preference=sec_dept;task=input'><b>Предпочитаемый отдел безопасности:</b> [prefered_security_department]</a><BR></td>"
					dat += "<br><a href='?_src_=prefs;preference=hide_ckey;task=input'><b>Скрыть сикей: [hide_ckey ? "Включено" : "Отключено"]</b></a><br>"
					dat += "</td>"

					dat += "<td valign='top'>"
					dat += "<h2>Предпочтения ПДА</h2>"
					dat += "<b>PDA Цвет:</b> <span style='border:1px solid #161616; background-color: [pda_color];'><font color='[color_hex2num(pda_color) < 200 ? "FFFFFF" : "000000"]'>[pda_color]</font></span> <a href='?_src_=prefs;preference=pda_color;task=input'>Change</a><BR>"
					dat += "<b>PDA Стиль:</b> <a href='?_src_=prefs;task=input;preference=pda_style'>[pda_style]</a><br>"
					dat += "<b>PDA Скин:</b> <a href='?_src_=prefs;task=input;preference=pda_skin'>[pda_skin]</a><br>"
					dat += "<b>PDA Рингтон:</b> <a href='?_src_=prefs;task=input;preference=pda_ringtone'>[pda_ringtone]</a><br>"

					dat += "<h2>Предпочтения законов у юнитов</h2>"
					if(!CONFIG_GET(flag/allow_silicon_choosing_laws))
						dat += "<i>Сервер отключил выбор ваших собственных законов, вы все еще можете выбирать и сохранять их, но это ничего не изменит в игре.</i><br>"
					dat += "<b>Начальный набор законов:</b> <a href='?_src_=prefs;task=input;preference=silicon_lawset'>[silicon_lawset ? silicon_lawset : "Server Default"]</a><br>"

					if(silicon_lawset)
						var/list/config_laws = CONFIG_GET(keyed_list/choosable_laws)
						var/datum/ai_laws/law_datum = GLOB.all_law_datums[config_laws[silicon_lawset]]
						if(law_datum)
							dat += "<i>[law_datum]</i><br>"
							dat += english_list(law_datum.get_law_list(TRUE),
								"I was unable to find the laws for your lawset, sorry  <font style='translate: rotate(90deg)'>:(</font>",
								"<br>", "<br>")

					dat += "</td></tr></table>"
				//Character background
				if(BACKGROUND_CHAR_TAB)
					dat += "<table width='100%'><tr><td width='30%' valign='top'>"

					dat += "<h2>Описание персонажа</h2>"
					dat += "<a href='?_src_=prefs;preference=flavor_text;task=input'><b>Изменить описание персонажаt</b></a><br>"
					if(length(features["flavor_text"]) <= MAX_FLAVOR_PREVIEW_LEN)
						if(!length(features["flavor_text"]))
							dat += "\[...\]"
						else
							dat += "[features["flavor_text"]]"
					else
						dat += "[TextPreview(features["flavor_text"])]..."
					//SPLURT edit - naked flavor text
					dat += "<h2>Описание голого персонажа</h2>"
					dat += "<a href='?_src_=prefs;preference=naked_flavor_text;task=input'><b>Изменить описание голого персонажа</b></a><br>"
					if(length(features["naked_flavor_text"]) <= MAX_FLAVOR_PREVIEW_LEN)
						if(!length(features["naked_flavor_text"]))
							dat += "\[...\]<BR>"
						else
							dat += "[html_encode(features["naked_flavor_text"])]<BR>"
					else
						dat += "[TextPreview(html_encode(features["naked_flavor_text"]))]...<BR>"
					//SPLURT edit end
					// BLUEMOON ADD START - пользовательский эмоут смерти
					dat += "<h2>Сообщение о смерти</h2>"
					dat += "<a href='?_src_=prefs;preference=custom_deathgasp;task=input'><b>Изменить сообщение о смерти</b></a><br>"
					if(length(features["custom_deathgasp"]) <= MAX_FLAVOR_PREVIEW_LEN)
						if(!length(features["custom_deathgasp"]))
							dat += "\[...\]<BR>"
						else
							dat += "[html_encode(features["custom_deathgasp"])]<BR>"
					else
						dat += "[TextPreview(html_encode(features["custom_deathgasp"]))]...<BR>"
					dat += "<h2>Звук смерти</h2>"
					dat += "<a href='?_src_=prefs;preference=custom_deathsound;task=input'><b>Изменить звук смерти</b></a><br>"
					dat += "[features["custom_deathsound"]]<BR>"
					dat += "<BR><a href='?_src_=prefs;preference=deathsoundpreview;task=input''>Проиграть звук смерти</a><BR>"
					// BLUEMOON ADD END
					dat += "<h2>Описание синтетика</h2>"
					dat += "<a href='?_src_=prefs;preference=silicon_flavor_text;task=input'><b>Изменить описание синтетика</b></a><br>"
					if(length(features["silicon_flavor_text"]) <= MAX_FLAVOR_PREVIEW_LEN)
						if(!length(features["silicon_flavor_text"]))
							dat += "\[...\]"
						else
							dat += "[features["silicon_flavor_text"]]"
					else
						dat += "[TextPreview(features["silicon_flavor_text"])]...<BR>"
					dat += "<h2>Описание лора</h2>"
					dat += "<a href='?_src_=prefs;preference=custom_species_lore;task=input'><b>Изменить описание лора</b></a><br>"
					if(length(features["custom_species_lore"]) <= MAX_FLAVOR_PREVIEW_LEN)
						if(!length(features["custom_species_lore"]))
							dat += "\[...\]<BR>"
						else
							dat += "[features["custom_species_lore"]]<BR>"
					else
						dat += "[TextPreview(features["custom_species_lore"])]...<BR>"
					dat += "<h2>OOC заметки</h2>"
					dat += "<a href='?_src_=prefs;preference=ooc_notes;task=input'><b>Изменить OOC заметки</b></a><br>"
					var/ooc_notes_len = length(features["ooc_notes"])
					if(ooc_notes_len <= MAX_FLAVOR_PREVIEW_LEN)
						if(!ooc_notes_len)
							dat += "\[...\]"
						else
							dat += "[features["ooc_notes"]]"
					else
						dat += "[TextPreview(features["ooc_notes"])]..."
					//SPLURT EDIT
					// BLUEMOON REMOVE
					/*
					dat += "<h2>Headshot Image</h2>"
					dat += "<a href='?_src_=prefs;preference=headshot'><b>Set Headshot Image</b></a><br>"
					if(features["headshot_link"])
						dat += "<img src='[features["headshot_link"]]' width='160px' height='120px'>"
					dat += "<br><br>"
					*/
					// BLUEMOON REMOVE END
					//SPLURT EDIT END
					dat += "</td>"

					dat += "<td valign='top'>"
					dat += "<h2>Заметки</h2>"
					dat += "<a href='?_src_=prefs;preference=security_records;task=input'><b>Служебные заметки</b></a><br>"
					if(length_char(security_records) <= 40)
						if(!length(security_records))
							dat += "\[...\]"
						else
							dat += "[security_records]"
					else
						dat += "[TextPreview(security_records)]..."

					dat += "<br><a href='?_src_=prefs;preference=medical_records;task=input'><b>Медицинские заметки</b></a><br>"
					if(length_char(medical_records) <= 40)
						if(!length(medical_records))
							dat += "\[...\]"
						else
							dat += "[medical_records]"
					else
						dat += "[TextPreview(medical_records)]..."

					// BLUEMOON ADD
					dat += "<h2>Изображение персонажа 1</h2>"
					dat += "<a href='?_src_=prefs;preference=headshot'><b>Изменить изображение персонажа 1</b></a><br>"
					if(features["headshot_link"])
						dat += "<img src='[features["headshot_link"]]' style='border: 1px solid black' width='140px' height='140px'>"
					dat += "<br><br>"

					dat += "<h2>Изображение персонажа 2</h2>"
					dat += "<a href='?_src_=prefs;preference=headshot1'><b>Изменить изображение персонажа 2</b></a><br>"
					if(features["headshot_link1"])
						dat += "<img src='[features["headshot_link1"]]' style='border: 1px solid black' width='140px' height='140px'>"
					dat += "<br><br>"

					dat += "<h2>Изображение персонажа 3</h2>"
					dat += "<a href='?_src_=prefs;preference=headshot2'><b>Изменить изображение персонажа 3</b></a><br>"
					if(features["headshot_link2"])
						dat += "<img src='[features["headshot_link2"]]' style='border: 1px solid black' width='140px' height='140px'>"
					dat += "<br><br>"
					// BLUEMOON ADD END
					dat += "</td></tr></table>"
				//Character Appearance
				if(APPEARANCE_CHAR_TAB)
					dat += "<table><tr><td width='20%' height='300px' valign='top'>"

					dat += "<h2>Тело</h2>"
					dat += "<b>Гендер:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=gender;task=input'>[gender == MALE ? "Мужчина" : (gender == FEMALE ? "Женщина" : (gender == PLURAL ? "Небинарный" : "Object"))]</a><BR>"
					if(pref_species.sexes)
						dat += "<b>Тип тела:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=body_model'>[features["body_model"] == MALE ? "Мужеподобный" : "Женоподобный"]</a><BR>"
					dat += "<b>Модификация конечностей:</b><BR>"
					dat += "<a href='?_src_=prefs;preference=modify_limbs;task=input'>Изменить конечности</a><BR>"
					for(var/modification in modified_limbs)
						if(modified_limbs[modification][1] == LOADOUT_LIMB_PROSTHETIC)
							dat += "<b>[modification]: [modified_limbs[modification][2]]</b><BR>"
						else
							dat += "<b>[modification]: [modified_limbs[modification][1]]</b><BR>"
					dat += "<BR>"
					dat += "<b>Раса:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=species;task=input'>[pref_species.name]</a><BR>"
					dat += "<b>Особая раса:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=custom_species;task=input'>[custom_species ? custom_species : "Нету"]</a><BR>"
					dat += "<b>Случайное тело:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=all;task=random'>Рандом!</A><BR>"
					dat += "<b>Всегда случайное тело:</b><a href='?_src_=prefs;preference=all'>[be_random_body ? "Да" : "Нет"]</A><BR>"
					dat += "<br><b>Задний фон:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=cycle_bg;task=input'>[bgstate]</a><BR>"

					dat += "</td>"

					var/use_skintones = pref_species.use_skintones
					if(use_skintones)
						dat += APPEARANCE_CATEGORY_COLUMN

						dat += "<h3>Тон кожи</h3>"

						dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=s_tone;task=input'>[use_custom_skin_tone ? "custom: <span style='border:1px solid #161616; background-color: [skin_tone];'><font color='[color_hex2num(skin_tone) < 200 ? "FFFFFF" : "000000"]'>[skin_tone]</font></span>" : skin_tone]</a><BR>"

					var/mutant_colors
					if((MUTCOLORS in pref_species.species_traits) || (MUTCOLORS_PARTSONLY in pref_species.species_traits))
						if(!use_skintones)
							dat += APPEARANCE_CATEGORY_COLUMN

						dat += "<h2>Цвета тела</h2>"

						dat += "<b>Основной цвет:</b><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[features["mcolor"]];'><font color='[color_hex2num(features["mcolor"]) < 200 ? "FFFFFF" : "000000"]'>#[features["mcolor"]]</font></span> <a href='?_src_=prefs;preference=mutant_color;task=input'>Изменить</a><BR>"

						dat += "<b>Вторичный цвет:</b><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[features["mcolor2"]];'><font color='[color_hex2num(features["mcolor2"]) < 200 ? "FFFFFF" : "000000"]'>#[features["mcolor2"]]</font></span> <a href='?_src_=prefs;preference=mutant_color2;task=input'>Изменить</a><BR>"

						dat += "<b>Третичный цвет:</b><BR>"
						dat += "<span style='border: 1px solid #161616; background-color: #[features["mcolor3"]];'><font color='[color_hex2num(features["mcolor3"]) < 200 ? "FFFFFF" : "000000"]'>#[features["mcolor3"]]</font></span> <a href='?_src_=prefs;preference=mutant_color3;task=input'>Изменить</a><BR>"
						mutant_colors = TRUE

						dat += "<b>Размер спрайта:</b> <a href='?_src_=prefs;preference=body_size;task=input'>[features["body_size"]*100]%</a><br>"
						dat += "<b>Scaled Appearance:</b> <a href='?_src_=prefs;preference=toggle_fuzzy;task=input'>[fuzzy ? "Fuzzy" : "Sharp"]</a><br>"

					if(!(NOEYES in pref_species.species_traits))
						dat += "<h3>Тип глаза</h3>"
						dat += "</b><a style='display:block;width:100px' href='?_src_=prefs;preference=eye_type;task=input'>[eye_type]</a><BR>"
						if((EYECOLOR in pref_species.species_traits))
							if(!use_skintones && !mutant_colors)
								dat += APPEARANCE_CATEGORY_COLUMN
							if(left_eye_color != right_eye_color)
								split_eye_colors = TRUE
							dat += "<h3>Гетерохромия</h3>"
							dat += "<i>Eyes with special heterochromia: wide, big, bigcyclops, skrell, third, thirdbig.</i>"
							dat += "</b><a style='display:block;width:100px' href='?_src_=prefs;preference=toggle_split_eyes;task=input'>[split_eye_colors ? "Enabled" : "Disabled"]</a>"
							if(!split_eye_colors)
								dat += "<h3>Цвет глаз</h3>"
								dat += "<span style='border: 1px solid #161616; background-color: #[left_eye_color];'><font color='[color_hex2num(left_eye_color) < 200 ? "FFFFFF" : "000000"]'>#[left_eye_color]</font></span> <a href='?_src_=prefs;preference=eyes;task=input'>Изменить</a>"
							else
								dat += "<h3>Цвет левого глаза</h3>"
								dat += "<span style='border: 1px solid #161616; background-color: #[left_eye_color];'><font color='[color_hex2num(left_eye_color) < 200 ? "FFFFFF" : "000000"]'>#[left_eye_color]</font></span> <a href='?_src_=prefs;preference=eye_left;task=input'>Изменить</a>"
								dat += "<h3>Цвет правого глаза</h3>"
								dat += "<span style='border: 1px solid #161616; background-color: #[right_eye_color];'><font color='[color_hex2num(right_eye_color) < 200 ? "FFFFFF" : "000000"]'>#[right_eye_color]</font></span> <a href='?_src_=prefs;preference=eye_right;task=input'>Изменить</a><BR>"

					if(HAIR in pref_species.species_traits)

						dat += APPEARANCE_CATEGORY_COLUMN

						dat += "<h3>Причёска</h3>"

						dat += "<a style='display:block;width:180px' href='?_src_=prefs;preference=hair_style;task=input'>[hair_style]</a>" // BLUEMOON EDIT - увеличена ширина со 100 до 180
						dat += "<a href='?_src_=prefs;preference=previous_hair_style;task=input'>&lt;</a> <a href='?_src_=prefs;preference=next_hair_style;task=input'>&gt;</a><BR>"
						dat += "<span style='border:1px solid #161616; background-color: #[hair_color];'><font color='[color_hex2num(hair_color) < 200 ? "FFFFFF" : "000000"]'>#[hair_color]</font></span> <a href='?_src_=prefs;preference=hair;task=input'>Изменить</a><BR>"

						dat += "<h3>Растительность на лице</h3>"

						dat += "<a style='display:block;width:180px' href='?_src_=prefs;preference=facial_hair_style;task=input'>[facial_hair_style]</a>" // BLUEMOON EDIT - увеличена ширина со 100 до 180
						dat += "<a href='?_src_=prefs;preference=previous_facehair_style;task=input'>&lt;</a> <a href='?_src_=prefs;preference=next_facehair_style;task=input'>&gt;</a><BR>"
						dat += "<span style='border:1px solid #161616; background-color: #[facial_hair_color];'><font color='[color_hex2num(facial_hair_color) < 200 ? "FFFFFF" : "000000"]'>#[facial_hair_color]</font></span> <a href='?_src_=prefs;preference=facial;task=input'>Изменить</a><BR>"

						dat += "<h3>Градиент волос</h3>"

						dat += "<a style='display:block;width:180px' href='?_src_=prefs;preference=grad_style;task=input'>[grad_style]</a>"
						dat += "<a href='?_src_=prefs;preference=previous_grad_style;task=input'>&lt;</a> <a href='?_src_=prefs;preference=next_grad_style;task=input'>&gt;</a><BR>" // BLUEMOON EDIT - увеличена ширина со 100 до 180
						dat += "<span style='border:1px solid #161616; background-color: #[grad_color];'><font color='[color_hex2num(grad_color) < 200 ? "FFFFFF" : "000000"]'>#[grad_color]</font></span> <a href='?_src_=prefs;preference=grad_color;task=input'>Изменить</a><BR>"

						dat += "</td>"

					//Mutant stuff
					var/mutant_category = 0

					for(var/mutant_part in GLOB.all_mutant_parts)
						if(mutant_part == "mam_body_markings")
							continue
						if(parent.can_have_part(mutant_part))
							if(!mutant_category)
								dat += APPEARANCE_CATEGORY_COLUMN
							dat += "<h3>[GLOB.all_mutant_parts[mutant_part]]</h3>"
							dat += "<a style='display:block;width:180px' href='?_src_=prefs;preference=[mutant_part];task=input'>[features[mutant_part]]</a>" // BLUEMOON EDIT - увеличена ширина со 100 до 180
							// BLUEMOON ADD START - <_AND_>_FOR_CHARACTER_REDACTOR
							dat += "<a href='?_src_=prefs;preference=previous_[mutant_part]_style;task=input'>&lt;</a> <a href='?_src_=prefs;preference=next_[mutant_part]_style;task=input'>&gt;</a><BR>"
							// BLUEMOON ADD END
							var/color_type = GLOB.colored_mutant_parts[mutant_part] //if it can be coloured, show the appropriate button
							if(color_type)
								dat += "<span style='border:1px solid #161616; background-color: #[features[color_type]];'><font color='[color_hex2num(features[color_type]) < 200 ? "FFFFFF" : "000000"]'>#[features[color_type]]</font></span> <a href='?_src_=prefs;preference=[color_type];task=input'>Change</a><BR>"
							else
								if(features["color_scheme"] == ADVANCED_CHARACTER_COLORING) //advanced individual part colouring system
									//is it matrixed or does it have extra parts to be coloured?
									var/find_part = features[mutant_part] || pref_species.mutant_bodyparts[mutant_part]
									var/find_part_list = GLOB.mutant_reference_list[mutant_part]
									if(find_part && find_part != "None" && find_part_list)
										var/datum/sprite_accessory/accessory = find_part_list[find_part]
										if(accessory)
											if(accessory.color_src == MATRIXED || accessory.color_src == MUTCOLORS || accessory.color_src == MUTCOLORS2 || accessory.color_src == MUTCOLORS3) //mutcolors1-3 are deprecated now, please don't rely on these in the future
												var/mutant_string = accessory.mutant_part_string
												var/primary_feature = "[mutant_string]_primary"
												var/secondary_feature = "[mutant_string]_secondary"
												var/tertiary_feature = "[mutant_string]_tertiary"
												if(!features[primary_feature])
													features[primary_feature] = features["mcolor"]
												if(!features[secondary_feature])
													features[secondary_feature] = features["mcolor2"]
												if(!features[tertiary_feature])
													features[tertiary_feature] = features["mcolor3"]

												var/matrixed_sections = accessory.matrixed_sections
												if(accessory.color_src == MATRIXED && !matrixed_sections)
													message_admins("Sprite Accessory Failure (customization): Accessory [accessory.type] is a matrixed item without any matrixed sections set!")
													continue
												else if(accessory.color_src == MATRIXED)
													switch(matrixed_sections)
														if(MATRIX_GREEN) //only composed of a green section
															primary_feature = secondary_feature //swap primary for secondary, so it properly assigns the second colour, reserved for the green section
														if(MATRIX_BLUE)
															primary_feature = tertiary_feature //same as above, but the tertiary feature is for the blue section
														if(MATRIX_RED_BLUE) //composed of a red and blue section
															secondary_feature = tertiary_feature //swap secondary for tertiary, as blue should always be tertiary
														if(MATRIX_GREEN_BLUE) //composed of a green and blue section
															primary_feature = secondary_feature //swap primary for secondary, as first option is green, which is linked to the secondary
															secondary_feature = tertiary_feature //swap secondary for tertiary, as second option is blue, which is linked to the tertiary
												dat += "<b>Primary Color</b><BR>"
												dat += "<span style='border:1px solid #161616; background-color: #[features[primary_feature]];'><font color='[color_hex2num(features[primary_feature]) < 200 ? "FFFFFF" : "000000"]'>#[features[primary_feature]]</font></span> <a href='?_src_=prefs;preference=[primary_feature];task=input'>Change</a><BR>"
												if((accessory.color_src == MATRIXED && (matrixed_sections == MATRIX_RED_BLUE || matrixed_sections == MATRIX_GREEN_BLUE || matrixed_sections == MATRIX_RED_GREEN || matrixed_sections == MATRIX_ALL)) || (accessory.extra && (accessory.extra_color_src == MUTCOLORS || accessory.extra_color_src == MUTCOLORS2 || accessory.extra_color_src == MUTCOLORS3)))
													dat += "<b>Secondary Color</b><BR>"
													dat += "<span style='border:1px solid #161616; background-color: #[features[secondary_feature]];'><font color='[color_hex2num(features[secondary_feature]) < 200 ? "FFFFFF" : "000000"]'>#[features[secondary_feature]]</font></span> <a href='?_src_=prefs;preference=[secondary_feature];task=input'>Change</a><BR>"
													if((accessory.color_src == MATRIXED && matrixed_sections == MATRIX_ALL) || (accessory.extra2 && (accessory.extra2_color_src == MUTCOLORS || accessory.extra2_color_src == MUTCOLORS2 || accessory.extra2_color_src == MUTCOLORS3)))
														dat += "<b>Tertiary Color</b><BR>"
														dat += "<span style='border:1px solid #161616; background-color: #[features[tertiary_feature]];'><font color='[color_hex2num(features[tertiary_feature]) < 200 ? "FFFFFF" : "000000"]'>#[features[tertiary_feature]]</font></span> <a href='?_src_=prefs;preference=[tertiary_feature];task=input'>Change</a><BR>"

							mutant_category++
							if(mutant_category >= MAX_MUTANT_ROWS)
								dat += "</td>"
								mutant_category = 0

					if(length(pref_species.allowed_limb_ids))
						if(!chosen_limb_id || !(chosen_limb_id in pref_species.allowed_limb_ids))
							chosen_limb_id = pref_species.limbs_id || pref_species.id
						if(!mutant_category)
							dat += APPEARANCE_CATEGORY_COLUMN
						dat += "<h3>Body sprite</h3>"
						dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=bodysprite;task=input'>[chosen_limb_id]</a>"

					//BLUEMOON edit start
					if(pref_species.type == /datum/species/jelly/roundstartslime)
						dat += APPEARANCE_CATEGORY_COLUMN
						dat += "<h3>be a slime?</h3>"
						dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=puddle_slime_task;task=input'>[features["puddle_slime_fea"] ? "Yes" : "No"]</a>"
						dat += "</td>"
					//BLUEMOON edit end

					if(mutant_category)
						dat += "</td>"
						mutant_category = 0

					dat += "</tr></table>"

					dat += "</td>"
					dat += "<table><tr><td width='340px' height='300px' valign='top'>"
					dat += "<h2>Clothing & Equipment</h2>"

					dat += "<b>Backpack:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=bag;task=input'>[backbag]</a>"
					dat += "<b>Jumpsuit:</b><BR><a href ='?_src_=prefs;preference=suit;task=input'>[jumpsuit_style]</a><BR>"
					if((HAS_FLESH in pref_species.species_traits) || (HAS_BONE in pref_species.species_traits))
						dat += "<BR><b>Temporal Scarring:</b><BR><a href='?_src_=prefs;preference=persistent_scars'>[(persistent_scars) ? "Enabled" : "Disabled"]</A>"
						dat += "<a href='?_src_=prefs;preference=clear_scars'>Clear scar slots</A>"
					dat += "<b>Uplink Location:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=uplink_loc;task=input'>[uplink_spawn_loc]</a>"

					dat += "<h2>Consent preferences</h2>"
					dat += "ERP : <a href='?_src_=prefs;preference=erp_pref'>[erppref]</a><br>"
					dat += "Non-Con : <a href='?_src_=prefs;preference=noncon_pref'>[nonconpref]</a><br>"
					dat += "Vore : <a href='?_src_=prefs;preference=vore_pref'>[vorepref]</a><br>"
					dat += "Mob-Sex : <a href='?_src_=prefs;preference=mobsex_pref'>[mobsexpref]</a><br>"
					dat += "Horny Antags : <a href='?_src_=prefs;preference=hornyantags_pref'>[hornyantagspref]</a><br>"

					dat += "<h2>Lewd preferences</h2>"
					dat += "<b>Lust tolerance:</b><a href='?_src_=prefs;preference=lust_tolerance;task=input'>[lust_tolerance]</a><br>"
					dat += "<b>Sexual potency:</b><a href='?_src_=prefs;preference=sexual_potency;task=input'>[sexual_potency]</a>"
					dat += "</td>"

					//SPLURT EDIT BEGIN - gregnancy preferences
					dat += "<td width='220px' height='300px' valign='top'>"
					dat += "<h3>Pregnancy preferences</h3>"
					dat += "<b>Chance of impregnation:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=virility;task=input'>[virility ? virility : "Disabled"]</a>"
					dat += "<b>Chance of getting pregnant:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=fertility;task=input'>[fertility ? fertility : "Disabled"]</a>"
					dat += "<b>Lay inert eggs:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=inert_eggs'>[features["inert_eggs"] == TRUE ? "Enabled" : "Disabled"]</a>"
					if(fertility)
						dat += "<b>Pregnancy inflation:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=pregnancy_inflation;task=input'>[pregnancy_inflation ? "Enabled" : "Disabled"]</a>"
						dat += "<b>Pregnancy breast growth:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=pregnancy_breast_growth;task=input'>[pregnancy_breast_growth ? "Enabled" : "Disabled"]</a>"
					if(fertility || features["inert_eggs"])
						dat += "<b>Egg shell:</b><a style='display:block;width:100px' href ='?_src_=prefs;preference=egg_shell;task=input'>[egg_shell]</a>"
					dat += "</td>"
					//SPLURT EDIT END
					dat += APPEARANCE_CATEGORY_COLUMN

					if(NOGENITALS in pref_species.species_traits)
						dat += "<b>Your species ([pref_species.name]) does not support genitals!</b><br>"
					else
						if(pref_species.use_skintones)
							dat += "<b>Genitals use skintone:</b><a href='?_src_=prefs;preference=genital_colour'>[features["genitals_use_skintone"] == TRUE ? "Yes" : "No"]</a>"
						dat += "<h3>Penis</h3>"
						dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_cock'>[features["has_cock"] == TRUE ? "Yes" : "No"]</a>"
						if(features["has_cock"])
							if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
								dat += "<b>Penis Color:</b></a><BR>"
								dat += "<span style='border: 1px solid #161616; background-color: [SKINTONE2HEX(skin_tone)];'><font color='[color_hex2num(SKINTONE2HEX(skin_tone)) < 200 ? "FFFFFF" : "000000"]'>[SKINTONE2HEX(skin_tone)]</font></span>(Skin tone overriding)</a><br>"
							else
								dat += "<b>Penis Color:</b></a><BR>"
								dat += "<span style='border: 1px solid #161616; background-color: #[features["cock_color"]];'><font color='[color_hex2num(features["cock_color"]) < 200 ? "FFFFFF" : "000000"]'>#[features["cock_color"]]</font></span> <a href='?_src_=prefs;preference=cock_color;task=input'>Change</a><br>"
							var/tauric_shape = FALSE
							if(features["cock_taur"])
								var/datum/sprite_accessory/penis/P = GLOB.cock_shapes_list[features["cock_shape"]]
								if(P.taur_icon && parent.can_have_part("taur"))
									var/datum/sprite_accessory/taur/T = GLOB.taur_list[features["taur"]]
									if(T.taur_mode & P.accepted_taurs)
										tauric_shape = TRUE
							dat += "<b>Penis Shape:</b> <a style='display:block;width:120px' href='?_src_=prefs;preference=cock_shape;task=input'>[features["cock_shape"]][tauric_shape ? " (Taur)" : ""]</a>"
							dat += "<b>Penis Length:</b> <a style='display:block;width:120px' href='?_src_=prefs;preference=cock_length;task=input'>[features["cock_length"]] centimeter(-s)</a>"
							dat += "<b>Max Length:</b><a style='display:block;width:120px' href='?_src_=prefs;preference=cock_max_length;task=input'>[features["cock_max_length"] ? features["cock_max_length"] : "Disabled"]</a>"
							dat += "<b>Min Length:</b><a style='display:block;width:120px' href='?_src_=prefs;preference=cock_min_length;task=input'>[features["cock_min_length"] ? features["cock_min_length"] : "Disabled"]</a>"
							dat += "<b>Diameter Ratio:</b> <a style='display:block;width:120px' href='?_src_=prefs;preference=cock_diameter_ratio;task=input'>[features["cock_diameter_ratio"]]</a>" //SPLURT Edit
							dat += "<b>Penis Visibility:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=cock_visibility;task=input'>[features["cock_visibility"]]</a>"
							dat += "<b>Penis Always Accessible:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=cock_accessible'>[features["cock_accessible"] ? "Yes" : "No"]</a>"
							dat += "<b>Toys and Egg Stuffing:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=cock_stuffing'>[features["cock_stuffing"] == TRUE ? "Yes" : "No"]</a>" //SPLURT Edit
							dat += "<b>Has Testicles:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=has_balls'>[features["has_balls"] == TRUE ? "Yes" : "No"]</a>"
							if(features["has_balls"])
								if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
									dat += "<b>Testicles Color:</b></a><BR>"
									dat += "<span style='border: 1px solid #161616; background-color: [SKINTONE2HEX(skin_tone)];'><font color='[color_hex2num(SKINTONE2HEX(skin_tone)) < 200 ? "FFFFFF" : "000000"]'>[SKINTONE2HEX(skin_tone)]</font></span>(Skin tone overriding)<br>"
								else
									dat += "<b>Testicles Color:</b></a><BR>"
									dat += "<span style='border: 1px solid #161616; background-color: #[features["balls_color"]];'><font color='[color_hex2num(features["balls_color"]) < 200 ? "FFFFFF" : "000000"]'>#[features["balls_color"]]</font></span> <a href='?_src_=prefs;preference=balls_color;task=input'>Change</a><br>"
								dat += "<b>Testicles Shape:</b> <a style='display:block;width:120px' href='?_src_=prefs;preference=balls_shape;task=input'>[features["balls_shape"]]</a>"
								dat += "<b>Testicles Visibility:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=balls_visibility;task=input'>[features["balls_visibility"]]</a>"
								dat += "<b>Testicles Always Accessible:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=balls_accessible'>[features["balls_accessible"] ? "Yes" : "No"]</a>"

								//SPLURT Edit
								dat += "<b>Toys and Egg Stuffing:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=balls_stuffing'>[features["balls_stuffing"] == TRUE ? "Yes" : "No"]</a>"
								dat += "<b>Max Size:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=balls_max_size;task=input'>[features["balls_max_size"] ? features["balls_max_size"] : "Disabled"]</a>"
								dat += "<b>Min Size:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=balls_min_size;task=input'>[features["balls_min_size"] ? features["balls_min_size"] : "Disabled"]</a>"
								dat += "<b>Produces:</b>"
								var/datum/reagent/balls_fluid = find_reagent_object_from_type(features["balls_fluid"])
								if(balls_fluid && (balls_fluid in GLOB.genital_fluids_list))
									dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=balls_fluid;task=input'>[balls_fluid.name]</a>"
								else
									dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=balls_fluid;task=input'>Nothing?</a>"
								//SPLURT Edit end

						dat += "</td>"
						dat += APPEARANCE_CATEGORY_COLUMN
						dat += "<h3>Vagina</h3>"
						dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_vag'>[features["has_vag"] == TRUE ? "Yes" : "No"]</a>"
						if(features["has_vag"])
							dat += "<b>Vagina Type:</b> <a style='display:block;width:100px' href='?_src_=prefs;preference=vag_shape;task=input'>[features["vag_shape"]]</a>"
							if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
								dat += "<b>Vagina Color:</b></a><BR>"
								dat += "<span style='border: 1px solid #161616; background-color: [SKINTONE2HEX(skin_tone)];'><font color='[color_hex2num(SKINTONE2HEX(skin_tone)) < 200 ? "FFFFFF" : "000000"]'>[SKINTONE2HEX(skin_tone)]</font></span>(Skin tone overriding)<br>"
							else
								dat += "<b>Vagina Color:</b></a><BR>"
								dat += "<span style='border: 1px solid #161616; background-color: #[features["vag_color"]];'><font color='[color_hex2num(features["vag_color"]) < 200 ? "FFFFFF" : "000000"]'>#[features["vag_color"]]</font></span> <a href='?_src_=prefs;preference=vag_color;task=input'>Change</a><br>"
							dat += "<b>Vagina Visibility:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=vag_visibility;task=input'>[features["vag_visibility"]]</a>"
							dat += "<b>Vagina Always Accessible:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=vag_accessible'>[features["vag_accessible"] ? "Yes" : "No"]</a>"
							dat += "<b>Toys and Egg Stuffing:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=vag_stuffing'>[features["vag_stuffing"] == TRUE ? "Yes" : "No"]</a>" //SPLURT Edit
							dat += "<b>Vagina Always Accessible:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=vag_accessible'>[features["vag_accessible"] ? "Yes" : "No"]</a>"
							dat += "<b>Has Womb:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=has_womb'>[features["has_womb"] == TRUE ? "Yes" : "No"]</a>"
							//SPLURT Edit
							if(features["has_womb"] == TRUE)
								dat += "<b>Produces:</b>"
								var/datum/reagent/womb_fluid = find_reagent_object_from_type(features["womb_fluid"])
								if(womb_fluid && (womb_fluid in GLOB.genital_fluids_list))
									dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=womb_fluid;task=input'>[womb_fluid.name]</a>"
								else
									dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=womb_fluid;task=input'>Nothing?</a>"
							//SPLURT Edit end
						dat += "</td>"
						dat += APPEARANCE_CATEGORY_COLUMN
						dat += "<h3>Breasts</h3>"
						dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_breasts'>[features["has_breasts"] == TRUE ? "Yes" : "No"]</a>"
						if(features["has_breasts"])
							if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
								dat += "<b>Color:</b></a><BR>"
								dat += "<span style='border: 1px solid #161616; background-color: [SKINTONE2HEX(skin_tone)];'><font color='[color_hex2num(SKINTONE2HEX(skin_tone)) < 200 ? "FFFFFF" : "000000"]'>[SKINTONE2HEX(skin_tone)]</font></span>(Skin tone overriding)<br>"
							else
								dat += "<b>Color:</b></a><BR>"
								dat += "<span style='border: 1px solid #161616; background-color: #[features["breasts_color"]];'><font color='[color_hex2num(features["breasts_color"]) < 200 ? "FFFFFF" : "000000"]'>#[features["breasts_color"]]</font></span> <a href='?_src_=prefs;preference=breasts_color;task=input'>Change</a><br>"
							dat += "<b>Cup Size:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_size;task=input'>[features["breasts_size"]]</a>"
							dat += "<b>Breasts Shape:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_shape;task=input'>[features["breasts_shape"]]</a>"
							dat += "<b>Breasts Visibility:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=breasts_visibility;task=input'>[features["breasts_visibility"]]</a>"
							dat += "<b>Breasts Always Accessible:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=breasts_accessible'>[features["breasts_accessible"] ? "Yes" : "No"]</a>"
							dat += "<b>Lactates:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_producing'>[features["breasts_producing"] == TRUE ? "Yes" : "No"]</a>"
							//SPLURT Edit
							dat += "<b>Toys and Egg Stuffing:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_stuffing'>[features["breasts_stuffing"] == TRUE ? "Yes" : "No"]</a>"
							dat += "<b>Max Size:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_max_size;task=input'>[features["breasts_max_size"] ? features["breasts_max_size"] : "Disabled"]</a>"
							dat += "<b>Min Size:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_min_size;task=input'>[features["breasts_min_size"] ? features["breasts_min_size"] : "Disabled"]</a>"
							if(features["breasts_producing"] == TRUE)
								dat += "<b>Produces:</b>"
								var/datum/reagent/breasts_fluid = find_reagent_object_from_type(features["breasts_fluid"])
								if(breasts_fluid && (breasts_fluid in GLOB.genital_fluids_list))
									dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_fluid;task=input'>[breasts_fluid.name]</a>"
								else
									dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=breasts_fluid;task=input'>Nothing?</a>"
							//SPLURT Edit end
						dat += "</td>"
						dat += APPEARANCE_CATEGORY_COLUMN
						dat += "<h3>Butt</h3>"
						dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_butt'>[features["has_butt"] == TRUE ? "Yes" : "No"]</a>"
						if(features["has_butt"])
							if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
								dat += "<b>Color:</b></a><BR>"
								dat += "<span style='border: 1px solid #161616; background-color: [SKINTONE2HEX(skin_tone)];'><font color='[color_hex2num(SKINTONE2HEX(skin_tone)) < 200 ? "FFFFFF" : "000000"]'>[SKINTONE2HEX(skin_tone)]</font></span>(Skin tone overriding)<br>"
							else
								dat += "<b>Color:</b></a><BR>"
								dat += "<span style='border: 1px solid #161616; background-color: #[features["butt_color"]];'><font color='[color_hex2num(features["butt_color"]) < 200 ? "FFFFFF" : "000000"]'>#[features["butt_color"]]</font></span> <a href='?_src_=prefs;preference=butt_color;task=input'>Change</a><br>"
							dat += "<b>Butt Size:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=butt_size;task=input'>[features["butt_size"]]</a>"
							dat += "<b>Butt Visibility:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=butt_visibility;task=input'>[features["butt_visibility"]]</a>"
							dat += "<b>Butt Always Accessible:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=butt_accessible'>[features["butt_accessible"] ? "Yes" : "No"]</a>"
						//SPLURT Edit
							dat += "<b>Toys and Egg Stuffing:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=butt_stuffing'>[features["butt_stuffing"] == TRUE ? "Yes" : "No"]</a>"
							dat += "<b>Max Size:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=butt_max_size;task=input'>[features["butt_max_size"] ? features["butt_max_size"] : "Disabled"]</a>"
							dat += "<b>Min Size:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=butt_min_size;task=input'>[features["butt_min_size"] ? features["butt_min_size"] : "Disabled"]</a>"
							dat += "<b>Has Anus:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=has_anus'>[features["has_anus"] == TRUE ? "Yes" : "No"]</a>"
							if(features["has_anus"])
								dat += "<b>Butthole Color:</b></a><BR>"
								if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
									dat += "<span style='border: 1px solid #161616; background-color: [SKINTONE2HEX(skin_tone)];'><font color='[color_hex2num(SKINTONE2HEX(skin_tone)) < 200 ? "FFFFFF" : "000000"]'>[SKINTONE2HEX(skin_tone)]</font></span>(Skin tone overriding)<br>"
								else
									dat += "<span style='border: 1px solid #161616; background-color: #[features["anus_color"]];'><font color='[color_hex2num(features["anus_color"]) < 200 ? "FFFFFF" : "000000"]'>#[features["anus_color"]]</font></span> <a href='?_src_=prefs;preference=anus_color;task=input'>Change</a><br>"
									dat += "<b>Butthole Shape:</b> <a style='display:block;width:120px' href='?_src_=prefs;preference=anus_shape;task=input'>[features["anus_shape"]]</a>"
								dat += "<b>Butthole Visibility:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=anus_visibility;task=input'>[features["anus_visibility"]]</a>"
								dat += "<b>Butthole Always Accessible:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=anus_accessible'>[features["anus_accessible"] ? "Yes" : "No"]</a>"
								dat += "<b>Toys and Egg Stuffing:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=anus_stuffing'>[features["anus_stuffing"] == TRUE ? "Yes" : "No"]</a>"

							dat += "<b>Butt Always Accessible:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=butt_accessible'>[features["butt_accessible"] ? "Yes" : "No"]</a>"
						dat += "<h3>Anus</h3>"
						dat += "<b>Anus Always Accessible:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=anus_accessible'>[features["anus_accessible"] ? "Yes" : "No"]</a>"
						dat += "</td>"
						dat += APPEARANCE_CATEGORY_COLUMN
						dat += "<h3>Belly</h3>"
						dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_belly'>[features["has_belly"] == TRUE ? "Yes" : "No"]</a>"
						if(features["has_belly"])
							if(pref_species.use_skintones && features["genitals_use_skintone"] == TRUE)
								dat += "<b>Color:</b></a><BR>"
								dat += "<span style='border: 1px solid #161616; background-color: [SKINTONE2HEX(skin_tone)];'><font color='[color_hex2num(SKINTONE2HEX(skin_tone)) < 200 ? "FFFFFF" : "000000"]'>[SKINTONE2HEX(skin_tone)]</font></span>(Skin tone overriding)<br>"
							else
								dat += "<b>Color:</b></a><BR>"
								dat += "<span style='border: 1px solid #161616; background-color: #[features["belly_color"]];'><font color='[color_hex2num(features["belly_color"]) < 200 ? "FFFFFF" : "000000"]'>#[features["belly_color"]]</font></span> <a href='?_src_=prefs;preference=belly_color;task=input'>Change</a><br>"
							dat += "<b>Belly Size:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=belly_size;task=input'>[features["belly_size"]]</a>"
							dat += "<b>Max Size:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=belly_max_size;task=input'>[features["belly_max_size"] ? features["belly_max_size"] : "Disabled" ]</a>"
							dat += "<b>Min Size:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=belly_min_size;task=input'>[features["belly_min_size"] ? features["belly_min_size"] : "Disabled" ]</a>"
							dat += "<b>Belly Visibility:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=belly_visibility;task=input'>[features["belly_visibility"]]</a>"
							dat += "<b>Toys and Egg Stuffing:</b><a style='display:block;width:50px' href='?_src_=prefs;preference=belly_stuffing'>[features["belly_stuffing"] == TRUE ? "Yes" : "No"]</a>"
							dat += "<b>Belly Always Accessible:</b><a style='display:block;width:100px' href='?_src_=prefs;preference=belly_accessible'>[features["belly_accessible"] ? "Yes" : "No"]</a>"
						dat += "</td>"
						if(all_quirks.Find("Дуллахан"))
							dat += APPEARANCE_CATEGORY_COLUMN
							dat += "<h3>Neckfire</h3>"
							dat += "<a style='display:block;width:50px' href='?_src_=prefs;preference=has_neckfire;task=input'>[features["neckfire"] ? "Yes" : "No"]</a>"
							if(features["neckfire"])
								dat += "<b>Color:</b></a><BR>"
								dat += "<span style='border: 1px solid #161616; background-color: #[features["neckfire_color"]];'><font color='[color_hex2num(features["neckfire_color"]) < 200 ? "FFFFFF" : "000000"]'>#[features["neckfire_color"]]</font></span><a href='?_src_=prefs;preference=has_neckfire_color;task=input'>Change</a><br>"

							dat += "</td>"
						//SPLURT Edit end
					dat += "</td>"
					dat += "</tr></table>"
				//Markings
				if(MARKINGS_CHAR_TAB)
					var/iterated_markings = 0
					var/total_pages = 0
					// rp marking selection
					// assume you can only have mam markings or regular markings or none, never both
					var/marking_type
					if(parent.can_have_part("mam_body_markings"))
						marking_type = "mam_body_markings"
					if(marking_type)
						dat += APPEARANCE_CATEGORY_COLUMN
						dat += "<center>"
						dat += "<h3>[GLOB.all_mutant_parts[marking_type]]</h3>" // give it the appropriate title for the type of marking
						dat += "<a href='?_src_=prefs;preference=marking_add;marking_type=[marking_type];task=input'>Add marking</a>"
						dat += "</center>"

						dat += "<table width=100%><tr>"

						for(var/limb in GLOB.bodypart_values)
							if(length(GLOB.bodypart_values) % 3 != 0)
								continue
							total_pages++

						for(var/limb in GLOB.bodypart_values)
							if(!iterated_markings)
								dat += "<td width=[(100 / total_pages)]%>"
							dat += "<h3><center>[limb]</center></h3>"
							dat += "<table align='center'; width='100%'; height='100px'; style='background-color:#13171C'>"
							dat += "<td width=4%><font size=2> </font></td>"
							dat += "<td width=10%><font size=2> </font></td>"
							dat += "<td width=6%><font size=2> </font></td>"
							dat += "<td width=25%><font size=2> </font></td>"
							dat += "<td width=40%><font size=2> </font></td>"
							dat += "<td width=15%><font size=2> </font></td>"
							dat += "</tr>"

							// list out the current markings you have
							if(length(features[marking_type]))
								var/list/markings = features[marking_type]
								if(!islist(markings))
									// something went terribly wrong
									markings = list()

								for(var/list/marking_list in markings)
									var/marking_index = markings.Find(marking_list) // consider changing loop to go through indexes over lists instead of using Find here
									var/limb_value = marking_list[1]
									var/actual_name = GLOB.bodypart_names[num2text(limb_value)] // get the actual name from the bitflag representing the part the marking is applied to
									if(actual_name != limb)
										continue
									var/color_marking_dat = ""
									var/number_colors = 1
									var/datum/sprite_accessory/mam_body_markings/S = GLOB.mam_body_markings_list[marking_list[2]]
									var/matrixed_sections = S.covered_limbs[actual_name]
									if(S && matrixed_sections)
										// if it has nothing initialize it to white
										if(length(marking_list) == 2)
											var/first = "#FFFFFF"
											var/second = "#FFFFFF"
											var/third = "#FFFFFF"
											if(features["mcolor"])
												first = "#[features["mcolor"]]"
											if(features["mcolor2"])
												second = "#[features["mcolor2"]]"
											if(features["mcolor3"])
												third = "#[features["mcolor3"]]"
											marking_list += list(list(first, second, third)) // just assume its 3 colours if it isnt it doesnt matter we just wont use the other values
										// index magic
										var/primary_index = 1
										var/secondary_index = 2
										var/tertiary_index = 3
										switch(matrixed_sections)
											if(MATRIX_GREEN)
												primary_index = 2
											if(MATRIX_BLUE)
												primary_index = 3
											if(MATRIX_RED_BLUE)
												secondary_index = 2
											if(MATRIX_GREEN_BLUE)
												primary_index = 2
												secondary_index = 3

										// we know it has one matrixed section at minimum
										color_marking_dat += "<a href='?_src_=prefs;preference=marking_color_specific;marking_index=[marking_index];marking_type=[marking_type];number_color=[number_colors];task=input'><span style='border: 1px solid #161616; background-color: [marking_list[3][primary_index]];'><font color='[color_hex2num(marking_list[3][primary_index]) < 200 ? "FFFFFF" : "000000"]'>[marking_list[3][primary_index]]</font></span></a>"
										// if it has a second section, add it
										if(matrixed_sections == MATRIX_RED_BLUE || matrixed_sections == MATRIX_GREEN_BLUE || matrixed_sections == MATRIX_RED_GREEN || matrixed_sections == MATRIX_ALL)
											number_colors = 2
											color_marking_dat += "<a href='?_src_=prefs;preference=marking_color_specific;marking_index=[marking_index];marking_type=[marking_type];number_color=[number_colors];task=input'><span style='border: 1px solid #161616; background-color: [marking_list[3][secondary_index]];'><font color='[color_hex2num(marking_list[3][secondary_index]) < 200 ? "FFFFFF" : "000000"]'>[marking_list[3][secondary_index]]</font></span></a>"
										// if it has a third section, add it
										if(matrixed_sections == MATRIX_ALL)
											number_colors = 3
											color_marking_dat += "<a href='?_src_=prefs;preference=marking_color_specific;marking_index=[marking_index];marking_type=[marking_type];number_color=[number_colors];task=input'><span style='border: 1px solid #161616; background-color: [marking_list[3][tertiary_index]];'><font color='[color_hex2num(marking_list[3][tertiary_index]) < 200 ? "FFFFFF" : "000000"]'>[marking_list[3][tertiary_index]]</font></span></a>"
									dat += "<tr style='vertical-align:top;'>"
									dat += "<td>[marking_index]</td>"
									dat += "<td><a href='?_src_=prefs;preference=marking_up;task=input;marking_index=[marking_index];marking_type=[marking_type]'>&#709;</a></td>"
									dat += "<td><a href='?_src_=prefs;preference=marking_down;task=input;marking_index=[marking_index];marking_type=[marking_type];'>&#708;</a></td>"
									dat += "<td>[marking_list[2]]</td>"
									dat += "<td>[color_marking_dat]</td>"
									dat += "<td><a href='?_src_=prefs;preference=marking_remove;task=input;marking_index=[marking_index];marking_type=[marking_type]'>X</a></td>"
									dat += "</tr>"

							else
								dat += "<tr style='vertical-align:top;'>"
								dat += "<td> </td>"
								dat += "<td> </td>"
								dat += "<td> </td>"
								dat += "<td> </td>"
								dat += "<td> </td>"
								dat += "<td> </td>"
								dat += "</tr>"

							dat += "</table>"

							iterated_markings++
							if(iterated_markings >= 3)
								dat += "</td>"
								iterated_markings = 0
						dat += "</tr></table>"
						// BLUEMOON ADD START - кнопка для удаления всех маркингов на персонаже
						dat += "<center>"
						dat += "<h3>Danger Zone</h3>"
						dat += "<a href='?_src_=prefs;preference=markings_remove;task=input'>Remove All Markings</a>"
						dat += "</center>"
						// BLUEMOON ADD END

				if(SPEECH_CHAR_TAB)
					dat += "<table><tr><td width='340px' height='300px' valign='top'>"
					dat += "<h2>Речевые предпочтения</h2>"
					dat += "<b>Кастомный речевой глагол:</b><BR>"
					dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=speech_verb;task=input'>[custom_speech_verb]</a><BR>"
					dat += "<b>Кастомный язык:</b><BR>"
					dat += "<a style='display:block;width:100px' href='?_src_=prefs;preference=tongue;task=input'>[custom_tongue]</a><BR>"
					//SANDSTORM EDIT - additional language + runechat color
					dat += "<b>Дополнительный язык</b><br>"
					dat += "<a href='?_src_=prefs;preference=language;task=menu'>[english_list(language, "None")]</a></center><br>"
					dat += "<b>Кастомный цвет рунного чата:</b> <a href='?_src_=prefs;preference=enable_personal_chat_color'>[enable_personal_chat_color ? "Enabled" : "Disabled"]</a><br> [enable_personal_chat_color ? "<span style='border: 1px solid #161616; background-color: [personal_chat_color];'><font color='[color_hex2num(personal_chat_color) < 200 ? "FFFFFF" : "000000"]'>[personal_chat_color]</font></span> <a href='?_src_=prefs;preference=personal_chat_color;task=input'>Change</a>" : ""]<br>"
					dat += "</td>"
					//END OF SANDSTORM EDIT
					dat += "<td width='340px' height='300px' valign='top'>"
					dat += "<h2>Настройка интонации</h2>"
					var/datum/bark/B = GLOB.bark_list[bark_id]
					dat += "<b>Тип голоса:</b><BR>"
					dat += "<a style='display:block;width:200px' href='?_src_=prefs;preference=barksound;task=input'>[B ? initial(B.name) : "INVALID"]</a><BR>"
					dat += "<b>Скорость голоса:</b> <a href='?_src_=prefs;preference=barkspeed;task=input'>[bark_speed]</a><BR>"
					dat += "<b>Низкий / Высокий голос:</b> <a href='?_src_=prefs;preference=barkpitch;task=input'>[bark_pitch]</a><BR>"
					dat += "<b>Vocal Bark Variance:</b> <a href='?_src_=prefs;preference=barkvary;task=input'>[bark_variance]</a><BR>"
					dat += "<BR><a href='?_src_=prefs;preference=barkpreview'>Проверить звучание голоса</a><BR>"
					dat += "</td>"
					dat += "</tr></table>"
				if(LOADOUT_CHAR_TAB)
					dat += "<table align='center' width='100%'>"
					dat += "<tr><td colspan=4><center><b>Раундстарт слоты</b></center></td></tr>"
					dat += "<tr><td colspan=4><center>"
					for(var/iteration in 1 to MAXIMUM_LOADOUT_SAVES)
						dat += "<a [loadout_slot == iteration ? "class='linkOn'" : "href='?_src_=prefs;preference=gear;select_slot=[iteration]'"]>[iteration]</a>"
					dat += "</center></td></tr>"
					dat += "<tr><td colspan=4><center><i style=\"color: grey;\">Игроки: Вы можете выбрать только один предмет в каждой категории, если только это не тот предмет, который появляется у вас в рюкзаке или в руках.</center></td></tr>"
					dat += "<tr><td colspan=4><center><b>"

					if(!length(GLOB.loadout_items))
						dat += "<center>ERROR: No loadout categories - something is horribly wrong!"
					else
						if(!GLOB.loadout_categories[gear_category])
							gear_category = GLOB.loadout_categories[1]
						var/firstcat = TRUE
						for(var/category in GLOB.loadout_categories)
							if(firstcat)
								firstcat = FALSE
							else
								dat += " |"
							if(category == gear_category)
								dat += " <span class='linkOn'>[(category == LOADOUT_CATEGORY_ERROR && loadout_errors) ? "[category] (<font color=\"red\">!</font>)" : category]</span> "
							else
								dat += " <a href='?_src_=prefs;preference=gear;select_category=[html_encode(category)]'>[(category == LOADOUT_CATEGORY_ERROR && loadout_errors) ? "[category] (<font color=\"red\">!</font>)" : category]</a> "

						dat += "</b></center></td></tr>"
						dat += "<tr><td colspan=4><hr></td></tr>"

						dat += "<tr><td colspan=4><center><b>"

						if(!length(GLOB.loadout_categories[gear_category]))
							dat += "No subcategories detected. Something is horribly wrong!"
						else
							var/list/subcategories = GLOB.loadout_categories[gear_category]
							if(!subcategories.Find(gear_subcategory))
								gear_subcategory = subcategories[1]

							var/firstsubcat = TRUE
							for(var/subcategory in subcategories)
								if(firstsubcat)
									firstsubcat = FALSE
								else
									dat += " |"
								if(gear_subcategory == subcategory)
									dat += " <span class='linkOn'>[subcategory]</span> "
								else
									dat += " <a href='?_src_=prefs;preference=gear;select_subcategory=[html_encode(subcategory)]'>[subcategory]</a> "
							dat += "</b></center></td></tr>"

							var/even = FALSE
							if(gear_category != LOADOUT_CATEGORY_ERROR)
								dat += "<table align='center'; width='100%'; height='100%'; style='background-color:#13171C'>"
								dat += "<center>"
								dat += "<tr width=10% style='vertical-align:top;'><td width=15%><b>Название</b></td>"
								dat += "<td style='vertical-align:top'><b>Стоимость</b></td>"
								dat += "<td width=10%><font size=2><b>Ограничения</b></font></td>"
								dat += "<td width=80%><font size=2><b>Описание</b></font></td></tr>"
								dat += "</center>"

								for(var/name in GLOB.loadout_items[gear_category][gear_subcategory])
									var/datum/gear/gear = GLOB.loadout_items[gear_category][gear_subcategory][name]
									var/donoritem = gear.donoritem
									if(donoritem && !gear.donator_ckey_check(user.ckey))
										continue
									var/background_cl = "#23273C"
									if(even)
										background_cl = "#17191C"
									even = !even
									var/class_link = ""
									var/list/loadout_item = has_loadout_gear(loadout_slot, "[gear.type]")
									var/extra_loadout_data = ""
									if(gear.base64icon)
										extra_loadout_data += "<center><img src=data:image/jpeg;base64,[gear.base64icon]></center>"
									if(loadout_item)
										class_link = "style='white-space:normal;' class='linkOn' href='?_src_=prefs;preference=gear;toggle_gear_path=[html_encode(name)];toggle_gear=0'"
										if(gear.loadout_flags & LOADOUT_CAN_COLOR_POLYCHROMIC)
											extra_loadout_data += "<BR><a href='?_src_=prefs;preference=gear;loadout_color_polychromic=1;loadout_gear_name=[html_encode(gear.name)];'>Color</a>"
											for(var/loadout_color in loadout_item[LOADOUT_COLOR])
												extra_loadout_data += "<span style='border: 1px solid #161616; background-color: [loadout_color];'><font color='[color_hex2num(loadout_color) < 200 ? "FFFFFF" : "000000"]'>[loadout_color]</font></span>"
										else
											var/loadout_color_non_poly = "#FFFFFF"
											if(length(loadout_item[LOADOUT_COLOR]))
												loadout_color_non_poly = loadout_item[LOADOUT_COLOR][1]
											extra_loadout_data += "<BR><a href='?_src_=prefs;preference=gear;loadout_color=1;loadout_gear_name=[html_encode(gear.name)];'>Color</a>"
											extra_loadout_data += "<span style='border: 1px solid #161616; background-color: [loadout_color_non_poly];'><font color='[color_hex2num(loadout_color_non_poly) < 200 ? "FFFFFF" : "000000"]'>[loadout_color_non_poly]</font></span>"
											extra_loadout_data += "<BR><a href='?_src_=prefs;preference=gear;loadout_color_HSV=1;loadout_gear_name=[html_encode(gear.name)];'>HSV Color</a>" // SPLURT EDIT
										if(gear.loadout_flags & LOADOUT_CAN_NAME)
											extra_loadout_data += "<BR><a href='?_src_=prefs;preference=gear;loadout_rename=1;loadout_gear_name=[html_encode(gear.name)];'>Name</a> [loadout_item[LOADOUT_CUSTOM_NAME] ? loadout_item[LOADOUT_CUSTOM_NAME] : "N/A"]"
										if(gear.loadout_flags & LOADOUT_CAN_DESCRIPTION)
											extra_loadout_data += "<BR><a href='?_src_=prefs;preference=gear;loadout_redescribe=1;loadout_gear_name=[html_encode(gear.name)];'>Description</a>"
										else
											extra_loadout_data += "<BR><a href='?_src_=prefs;preference=gear;loadout_addheirloom=1;loadout_gear_name=[html_encode(gear.name)];'>Select as Heirloom</a><BR>"
										// BLUEMOON ADD START - выбор вещей из лодаута как family heirloom
										if(loadout_item[LOADOUT_IS_HEIRLOOM])
											extra_loadout_data += "<BR><a class='linkOn' href='?_src_=prefs;preference=gear;loadout_removeheirloom=1;loadout_gear_name=[html_encode(gear.name)];'>Select as Heirloom</a><BR>"
										else
											extra_loadout_data += "<BR><a href='?_src_=prefs;preference=gear;loadout_addheirloom=1;loadout_gear_name=[html_encode(gear.name)];'>Select as Heirloom</a><BR>"
										if(ispath(gear.path, /obj/item/clothing/neck/petcollar)) //"name tag" sounds better for me, but in petcollar code "tagname" is used so let it be.
											extra_loadout_data += "<BR><a href='?_src_=prefs;preference=gear;loadout_tagname=1;loadout_gear_name=[html_encode(gear.name)];'>Name tag</a> [loadout_item["loadout_custom_tagname"] ? loadout_item["loadout_custom_tagname"] : "Name tag is visible for everyone looking at wearer."]"
									  // BLUEMOON ADD END
									else if((gear_points - gear.cost) < 0)
										class_link = "style='white-space:normal;' class='linkOff'"
									else if(donoritem)
										class_link = "style='white-space:normal;background:#ebc42e;' href='?_src_=prefs;preference=gear;toggle_gear_path=[html_encode(name)];toggle_gear=1'"
									else if(!istype(gear, /datum/gear/unlockable) || can_use_unlockable(gear))
										class_link = "style='white-space:normal;' href='?_src_=prefs;preference=gear;toggle_gear_path=[html_encode(name)];toggle_gear=1'"
									else
										class_link = "style='white-space:normal;background:#eb2e2e;' class='linkOff'"
									dat += "<tr style='vertical-align:top; background-color: [background_cl];'><td width=15%><a [class_link]>[name]</a>[extra_loadout_data]</td>"
									dat += "<td width = 5% style='vertical-align:top'>[gear.cost]</td><td>"
									if(islist(gear.restricted_roles))
										if(gear.restricted_roles.len)
											if(gear.restricted_desc)
												dat += "<font size=2>"
												dat += gear.restricted_desc
												dat += "</font>"
											else
												dat += "<font size=2>"
												dat += gear.restricted_roles.Join(";")
												dat += "</font>"
									if(!istype(gear, /datum/gear/unlockable))
										var/is_heirloom_string = loadout_item ? (loadout_item[LOADOUT_IS_HEIRLOOM] ? "<br><br><center><b>Ваша семейная реликвия!</b></center>" : "") : "" // BLUEMOON EDIT - выбор вещей из лодаута как family heirloom
										// the below line essentially means "if the loadout item is picked by the user and has a custom description, give it the custom description, otherwise give it the default description"
										dat += "</td><td><font size=2><i>[loadout_item ? (loadout_item[LOADOUT_CUSTOM_DESCRIPTION] ? loadout_item[LOADOUT_CUSTOM_DESCRIPTION] : gear.description) : gear.description]</i> [is_heirloom_string]</font></td></tr>" // BLUEMOON EDIT - выбор вещей из лодаута как family heirloom
									else
										//we add the user's progress to the description assuming they have progress
										var/datum/gear/unlockable/unlockable = gear
										var/progress_made = unlockable_loadout_data[unlockable.progress_key]
										if(!progress_made)
											progress_made = 0
										dat += "</td><td><font size=2><i>[loadout_item ? (loadout_item[LOADOUT_CUSTOM_DESCRIPTION] ? loadout_item[LOADOUT_CUSTOM_DESCRIPTION] : gear.description) : gear.description] Progress: [min(progress_made, unlockable.progress_required)]/[unlockable.progress_required]</i></font></td></tr>"
								dat += "</table>"
							else
								dat += "<table align='center'; width='100%'; height='100%'; style='background-color:#13171C'>"
								dat += "<center>"
								dat += "<tr width=10% style='vertical-align:top;'><td width=15%><b>Item type</b></td>"
								dat += "<td><font size=2><b>Data contained</b></font></td></tr>"
								dat += "</center>"
								var/list/sanitize_current_slot = loadout_data["SAVE_[loadout_slot]"]
								for(var/list/entry in sanitize_current_slot)
									var/test_item = entry["loadout_item"]
									if(text2path(test_item))
										continue
									var/background_cl = "#23273C"
									if(even)
										background_cl = "#17191C"
									even = !even
									dat += "<tr style='vertical-align:top; background-color: [background_cl];'><td width=15%><a \
										\"style='white-space:normal;' href='?_src_=prefs;preference=gear;clear_invalid_gear=[html_encode(test_item)];'\" \
											>[test_item ? test_item : "no path!!?! Report to an admin!"]</a></td>"
									dat += "<td style='vertical-align:top'>"
									var/list/other_data = entry["loadout_item"] ? entry - "loadout_item" : entry
									dat += json_encode(other_data)
									dat += "</td></tr>"
					dat += "</table>"
		if(PREFERENCES_TAB) // Game Preferences
			dat += "<center>"
			dat += "<a href='?_src_=prefs;preference=preferences_tab;tab=[GAME_PREFS_TAB]' [preferences_tab == GAME_PREFS_TAB ? "class='linkOn'" : ""]>General</a>"
			dat += "<a href='?_src_=prefs;preference=preferences_tab;tab=[OOC_PREFS_TAB]' [preferences_tab == OOC_PREFS_TAB ? "class='linkOn'" : ""]>OOC</a>"
			dat += "<a href='?_src_=prefs;preference=preferences_tab;tab=[CONTENT_PREFS_TAB]' [preferences_tab == CONTENT_PREFS_TAB ? "class='linkOn'" : ""]>Content</a>"
			dat += "</center>"

			dat += "<HR>"

			switch(preferences_tab)
				if(GAME_PREFS_TAB)
					dat += "<table><tr><td width='340px' height='300px' valign='top'>"
					dat += "<h2>General Settings</h2>"
					dat += "<b>UI Style:</b> <a href='?_src_=prefs;task=input;preference=ui'>[UI_style]</a><br>"
					dat += "<b>Outline:</b> <a href='?_src_=prefs;preference=outline_enabled'>[outline_enabled ? "Enabled" : "Disabled"]</a><br>"
					dat += "<b>Outline Color:</b> [outline_color ? "<span style='border:1px solid #161616; background-color: [outline_color];'>" : "Theme-based (null)"]<font color='[color_hex2num(outline_color) < 200 ? "FFFFFF" : "000000"]'>[outline_color]</font></span> <a href='?_src_=prefs;preference=outline_color'>Change</a><BR>"
					dat += "<b>Screentip:</b> <a href='?_src_=prefs;preference=screentip_pref'>[screentip_pref]</a><br>"
					dat += "<b>Screentip Color:</b> <span style='border:1px solid #161616; background-color: [screentip_color];'><font color='[color_hex2num(screentip_color) < 200 ? "FFFFFF" : "000000"]'>[screentip_color]</font></span> <a href='?_src_=prefs;preference=screentip_color'>Change</a><BR>"
					dat += "<font style='border-bottom:2px dotted white; cursor:help;'\
						title=\"This is an accessibility preference, if disabled, fallbacks to only text which colorblind people can understand better\">\
						<b>Screentip context with images:</b></font> <a href='?_src_=prefs;preference=screentip_images'>[screentip_images ? "Allowed" : "Disallowed"]</a><br>"
					dat += "<b>tgui Monitors:</b> <a href='?_src_=prefs;preference=tgui_lock'>[(tgui_lock) ? "Primary" : "All"]</a><br>"
					dat += "<b>tgui Style:</b> <a href='?_src_=prefs;preference=tgui_fancy'>[(tgui_fancy) ? "Fancy" : "No Frills"]</a><br>"
					dat += "<b>Show Runechat Chat Bubbles:</b> <a href='?_src_=prefs;preference=chat_on_map'>[chat_on_map ? "Enabled" : "Disabled"]</a><br>"
					dat += "<b>Runechat message char limit:</b> <a href='?_src_=prefs;preference=max_chat_length;task=input'>[max_chat_length]</a><br>"
					dat += "<b>See Runechat for non-mobs:</b> <a href='?_src_=prefs;preference=see_chat_non_mob'>[see_chat_non_mob ? "Enabled" : "Disabled"]</a><br>"
					//SANDSTORM CHANGES BEGIN
					dat += "<b>See Runechat for emotes:</b> <a href='?_src_=prefs;preference=see_chat_emotes'>[see_chat_emotes ? "Enabled" : "Disabled"]</a><br>"
					//SANDSTORM CHANGES END
					dat += "<b>Shift view when pixelshifting:</b> <a href='?_src_=prefs;preference=view_pixelshift'>[view_pixelshift ? "Enabled" : "Disabled"]</a><br>" //SPLURT Edit
					dat += "<br>"
					dat += "<b>Ghost Ears:</b> <a href='?_src_=prefs;preference=ghost_ears'>[(chat_toggles & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures"]</a><br>"
					dat += "<b>Ghost Radio:</b> <a href='?_src_=prefs;preference=ghost_radio'>[(chat_toggles & CHAT_GHOSTRADIO) ? "All Messages":"No Messages"]</a><br>"
					dat += "<b>Ghost Sight:</b> <a href='?_src_=prefs;preference=ghost_sight'>[(chat_toggles & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures"]</a><br>"
					dat += "<b>Ghost Whispers:</b> <a href='?_src_=prefs;preference=ghost_whispers'>[(chat_toggles & CHAT_GHOSTWHISPER) ? "All Speech" : "Nearest Creatures"]</a><br>"
					dat += "<b>Ghost PDA:</b> <a href='?_src_=prefs;preference=ghost_pda'>[(chat_toggles & CHAT_GHOSTPDA) ? "All Messages" : "Nearest Creatures"]</a><br>"

					dat += "</td>"

					dat += "<td width='300px' height='300px' valign='top'>"

					dat += "<h2>Special Role Settings</h2>"

					if(jobban_isbanned(user, ROLE_INTEQ))
						dat += "<font color=red><b>You are banned from antagonist roles.</b></font>"
						src.be_special = list()

					dat += "<b>DISABLE ALL ANTAGONISM</b> <a href='?_src_=prefs;preference=disable_antag'>[(toggles & NO_ANTAG) ? "YES" : "NO"]</a><br>"

					for (var/i in GLOB.special_roles)
						if(jobban_isbanned(user, i))
							dat += "<b>Be [capitalize(i)]:</b> <a href='?_src_=prefs;jobbancheck=[i]'>BANNED</a><br>"
						else
							var/days_remaining = null
							if(ispath(GLOB.special_roles[i]) && CONFIG_GET(flag/use_age_restriction_for_jobs)) //If it's a game mode antag, check if the player meets the minimum age
								var/mode_path = GLOB.special_roles[i]
								var/datum/game_mode/temp_mode = new mode_path
								days_remaining = temp_mode.get_remaining_days(user.client)

							if(days_remaining)
								dat += "<b>Be [capitalize(i)]:</b> <font color=red> \[IN [days_remaining] DAYS\]</font><br>"
							else
								var/enabled_text = ""
								if(i in be_special)
									if(be_special[i] >= 1)
										enabled_text = "Enabled"
									else
										enabled_text = "Low"
								else
									enabled_text = "Disabled"
								dat += "<b>Be [capitalize(i)]:</b> <a href='?_src_=prefs;preference=be_special;be_special_type=[i]'>[enabled_text]</a><br>"
					dat += "<b>Allow Midround Antagonist Roll:</b> <a href='?_src_=prefs;preference=allow_midround_antag'>[(toggles & MIDROUND_ANTAG) ? "Enabled" : "Disabled"]</a><br>"

					dat += "</td></tr></table>"

				if(OOC_PREFS_TAB)
					dat += "<table>"
					dat += "<tr><td width='340px' height='300px' valign='top'>"
					dat += "<h2>OOC Settings</h2>"
					dat += "<b>Window Flashing:</b> <a href='?_src_=prefs;preference=winflash'>[(windowflashing) ? "Enabled":"Disabled"]</a><br>"
					dat += "<b>Window Noise:</b> <a href='?_src_=prefs;preference=winnoise'>[(windownoise) ? "Enabled":"Disabled"]</a><br>"
					dat += "<br>"
					dat += "<b>Play Admin MIDIs:</b> <a href='?_src_=prefs;preference=hear_midis'>[(toggles & SOUND_MIDI) ? "Enabled":"Disabled"]</a><br>"
					dat += "<b>Play Lobby Music:</b> <a href='?_src_=prefs;preference=lobby_music'>[(toggles & SOUND_LOBBY) ? "Enabled":"Disabled"]</a><br>"
					dat += "<b>See Pull Requests:</b> <a href='?_src_=prefs;preference=pull_requests'>[(chat_toggles & CHAT_PULLR) ? "Enabled":"Disabled"]</a><br>"
					dat += "<br>"
					if(user.client)
						if(unlock_content)
							dat += "<b>BYOND Membership Publicity:</b> <a href='?_src_=prefs;preference=publicity'>[(toggles & MEMBER_PUBLIC) ? "Public" : "Hidden"]</a><br>"
						if(unlock_content || check_rights_for(user.client, R_ADMIN))
							dat += "<b>OOC Color:</b> <span style='border: 1px solid #161616; background-color: [ooccolor ? ooccolor : GLOB.normal_ooc_colour];'><font color='[color_hex2num(ooccolor ? ooccolor : GLOB.normal_ooc_colour) < 200 ? "FFFFFF" : "000000"]'>[ooccolor ? ooccolor : GLOB.normal_ooc_colour]</font></span> <a href='?_src_=prefs;preference=ooccolor;task=input'>Change</a><br>"
							dat += "<b>Antag OOC Color:</b> <span style='border: 1px solid #161616; background-color: [aooccolor ? aooccolor : GLOB.normal_aooc_colour];'><font color='[color_hex2num(aooccolor ? aooccolor : GLOB.normal_aooc_colour) < 200 ? "FFFFFF" : "000000"]'>[aooccolor ? aooccolor : GLOB.normal_aooc_colour]</font></span> <a href='?_src_=prefs;preference=aooccolor;task=input'>Change</a><br>"

					if(user.client.holder)
						dat += "<h2>Admin Settings</h2>"
						dat += "<b>Adminhelp Sounds:</b> <a href='?_src_=prefs;preference=hear_adminhelps'>[(toggles & SOUND_ADMINHELP)?"Enabled":"Disabled"]</a><br>"
						dat += "<b>Announce Login:</b> <a href='?_src_=prefs;preference=announce_login'>[(toggles & ANNOUNCE_LOGIN)?"Enabled":"Disabled"]</a><br>"
						dat += "<br>"
						dat += "<b>Combo HUD Lighting:</b> <a href = '?_src_=prefs;preference=combohud_lighting'>[(toggles & COMBOHUD_LIGHTING)?"Full-bright":"No Change"]</a><br>"
						dat += "<b>Use Modern Player Panel:</b> <a href='?_src_=prefs;preference=use_new_playerpanel'>[use_new_playerpanel ? "Yes" : "No"]</a><br>" //SPLURT Edit

						//deadmin
						dat += "<h2>Deadmin While Playing</h2>"
						if(CONFIG_GET(flag/auto_deadmin_players))
							dat += "<b>Always Deadmin:</b> FORCED</a><br>"
						else
							dat += "<b>Always Deadmin:</b> <a href = '?_src_=prefs;preference=toggle_deadmin_always'>[(deadmin & DEADMIN_ALWAYS)?"Enabled":"Disabled"]</a><br>"
							if(!(deadmin & DEADMIN_ALWAYS))
								dat += "<br>"
								if(!CONFIG_GET(flag/auto_deadmin_antagonists))
									dat += "<b>As Antag:</b> <a href = '?_src_=prefs;preference=toggle_deadmin_antag'>[(deadmin & DEADMIN_ANTAGONIST)?"Deadmin":"Keep Admin"]</a><br>"
								else
									dat += "<b>As Antag:</b> FORCED<br>"

								if(!CONFIG_GET(flag/auto_deadmin_heads))
									dat += "<b>As Command:</b> <a href = '?_src_=prefs;preference=toggle_deadmin_head'>[(deadmin & DEADMIN_POSITION_HEAD)?"Deadmin":"Keep Admin"]</a><br>"
								else
									dat += "<b>As Command:</b> FORCED<br>"

								if(!CONFIG_GET(flag/auto_deadmin_security))
									dat += "<b>As Security:</b> <a href = '?_src_=prefs;preference=toggle_deadmin_security'>[(deadmin & DEADMIN_POSITION_SECURITY)?"Deadmin":"Keep Admin"]</a><br>"
								else
									dat += "<b>As Security:</b> FORCED<br>"

								if(!CONFIG_GET(flag/auto_deadmin_silicons))
									dat += "<b>As Silicon:</b> <a href = '?_src_=prefs;preference=toggle_deadmin_silicon'>[(deadmin & DEADMIN_POSITION_SILICON)?"Deadmin":"Keep Admin"]</a><br>"
								else
									dat += "<b>As Silicon:</b> FORCED<br>"

					dat += "</td>"

					dat += "<td width='300px' height='300px' valign='top'>"

					dat += "<h2>Citadel Preferences</h2>" //Because fuck me if preferences can't be fucking modularized and expected to update in a reasonable timeframe.
					dat += "<b>Widescreen:</b> <a href='?_src_=prefs;preference=widescreenpref'>[widescreenpref ? "Enabled ([CONFIG_GET(string/default_view)])" : "Disabled (15x15)"]</a><br>"
					dat += "<b>Fullscreen:</b> <a href='?_src_=prefs;preference=fullscreen'>[fullscreen ? "Enabled" : "Disabled"]</a><br>"
					dat += "<b>Long strip menu:</b> <a href='?_src_=prefs;preference=long_strip_menu'>[long_strip_menu ? "Enabled" : "Disabled"]</a><br>"
					dat += "<b>Auto stand:</b> <a href='?_src_=prefs;preference=autostand'>[autostand ? "Enabled" : "Disabled"]</a><br>"
					dat += "<b>Auto OOC:</b> <a href='?_src_=prefs;preference=auto_ooc'>[auto_ooc ? "Enabled" : "Disabled"]</a><br>"
					dat += "<b>Force Slot Storage HUD:</b> <a href='?_src_=prefs;preference=no_tetris_storage'>[no_tetris_storage ? "Enabled" : "Disabled"]</a><br>"
					dat += "<b>Screen Shake:</b> <a href='?_src_=prefs;preference=screenshake'>[(screenshake==100) ? "Full" : ((screenshake==0) ? "None" : "[screenshake]")]</a><br>"
					if (user && user.client && !user.client.prefs.screenshake==0)
						dat += "<b>Damage Screen Shake:</b> <a href='?_src_=prefs;preference=damagescreenshake'>[(damagescreenshake==1) ? "On" : ((damagescreenshake==0) ? "Off" : "Only when down")]</a><br>"
					dat += "<b>Recoil Screen Push:</b> <a href='?_src_=prefs;preference=recoil_screenshake'>[(recoil_screenshake==100) ? "Full" : ((recoil_screenshake==0) ? "None" : "[screenshake]")]</a><br>"
					var/p_chaos
					if (!preferred_chaos)
						p_chaos = "No preference"
					else
						p_chaos = preferred_chaos
					dat += "<b>Preferred Chaos Amount:</b> <a href='?_src_=prefs;preference=preferred_chaos;task=input'>[p_chaos]</a><br>"

					//SPLURT Edit
					dat += "<h2>S.P.L.U.R.T. Preferences</h2>"
					dat += "<b>Be Antagonist Victim:</b> <a href='?_src_=prefs;preference=be_victim;task=input'>[be_victim ? be_victim : BEVICTIM_ASK]</a><br>"
					dat += "<b>Disable combat mode cursor:</b> <a href='?_src_=prefs;preference=disable_combat_cursor'>[disable_combat_cursor?"Yes":"No"]</a><br>"
					dat += "<b>Splashscreen Player Panel Style:</b> <a href='?_src_=prefs;preference=tg_playerpanel'>[(toggles & TG_PLAYER_PANEL)?"TG":"Old"]</a><br>"
					dat += "<b>Character Creation Menu Style:</b> <a href='?_src_=prefs;preference=charcreation_style'>[new_character_creator ? "New" : "Old"]</a><br>"
					//SPLURT Edit end

					dat += "<br>"

					if(unlock_content)
						dat += "<b>Ghost Form:</b> <a href='?_src_=prefs;task=input;preference=ghostform'>[ghost_form]</a><br>"
						dat += "<B>Ghost Orbit: </B> <a href='?_src_=prefs;task=input;preference=ghostorbit'>[ghost_orbit]</a><br>"
					var/button_name = "If you see this something went wrong."
					switch(ghost_accs)
						if(GHOST_ACCS_FULL)
							button_name = GHOST_ACCS_FULL_NAME
						if(GHOST_ACCS_DIR)
							button_name = GHOST_ACCS_DIR_NAME
						if(GHOST_ACCS_NONE)
							button_name = GHOST_ACCS_NONE_NAME

					dat += "<b>Ghost Accessories:</b> <a href='?_src_=prefs;task=input;preference=ghostaccs'>[button_name]</a><br>"
					switch(ghost_others)
						if(GHOST_OTHERS_THEIR_SETTING)
							button_name = GHOST_OTHERS_THEIR_SETTING_NAME
						if(GHOST_OTHERS_DEFAULT_SPRITE)
							button_name = GHOST_OTHERS_DEFAULT_SPRITE_NAME
						if(GHOST_OTHERS_SIMPLE)
							button_name = GHOST_OTHERS_SIMPLE_NAME

					dat += "<b>Ghosts of Others:</b> <a href='?_src_=prefs;task=input;preference=ghostothers'>[button_name]</a><br>"
					dat += "<br>"

					dat += "<b>FPS:</b> <a href='?_src_=prefs;preference=clientfps;task=input'>[clientfps]</a><br>"

					dat += "<b>Income Updates:</b> <a href='?_src_=prefs;preference=income_pings'>[(chat_toggles & CHAT_BANKCARD) ? "Allowed" : "Muted"]</a><br>"
					dat += "<br>"

					dat += "<b>Parallax (Fancy Space):</b> <a href='?_src_=prefs;preference=parallaxdown' oncontextmenu='window.location.href=\"?_src_=prefs;preference=parallaxup\";return false;'>"
					switch (parallax)
						if (PARALLAX_LOW)
							dat += "Low"
						if (PARALLAX_MED)
							dat += "Medium"
						if (PARALLAX_INSANE)
							dat += "Insane"
						if (PARALLAX_DISABLE)
							dat += "Disabled"
						else
							dat += "High"
					dat += "</a><br>"
					dat += "<b>Ambient Occlusion:</b> <a href='?_src_=prefs;preference=ambientocclusion'>[ambientocclusion ? "Enabled" : "Disabled"]</a><br>"
					dat += "<b>Fit Viewport:</b> <a href='?_src_=prefs;preference=auto_fit_viewport'>[auto_fit_viewport ? "Auto" : "Manual"]</a><br>"
					dat += "<b>HUD Button Flashes:</b> <a href='?_src_=prefs;preference=hud_toggle_flash'>[hud_toggle_flash ? "Enabled" : "Disabled"]</a><br>"
					dat += "<b>HUD Button Flash Color:</b> <span style='border: 1px solid #161616; background-color: [hud_toggle_color];'><font color='[color_hex2num(hud_toggle_color) < 200 ? "FFFFFF" : "000000"]'>[hud_toggle_color]</font></span> <a href='?_src_=prefs;preference=hud_toggle_color;task=input'>Change</a><br>"


					if (CONFIG_GET(flag/maprotation) && CONFIG_GET(flag/tgstyle_maprotation))
						var/p_map = preferred_map
						if (!p_map)
							p_map = "Default"
							if (config.defaultmap)
								p_map += " ([config.defaultmap.map_name])"
						else
							if (p_map in config.maplist)
								var/datum/map_config/VM = config.maplist[p_map]
								if (!VM)
									p_map += " (No longer exists)"
								else
									p_map = VM.map_name
							else
								p_map += " (No longer exists)"
						if(CONFIG_GET(flag/allow_map_voting))
							dat += "<b>Preferred Map:</b> <a href='?_src_=prefs;preference=preferred_map;task=input'>[p_map]</a><br>"

					dat += "</td></tr></table>"

				if(CONTENT_PREFS_TAB)
					dat += "<table><tr><td width='340px' height='300px' valign='top'>"
					dat += "<h2>Fetish content prefs</h2>"
					dat += "<b>Allow Lewd Verbs:</b> <a href='?_src_=prefs;preference=verb_consent'>[(toggles & VERB_CONSENT) ? "Yes":"No"]</a><br>" // Skyrat - ERP Mechanic Addition
					dat += "<b>Lewd Verb Sounds:</b> <a href='?_src_=prefs;preference=lewd_verb_sounds'>[(toggles & LEWD_VERB_SOUNDS) ? "Yes":"No"]</a><br>" // Sandstorm - ERP Mechanic Addition
					dat += "<b>Arousal:</b><a href='?_src_=prefs;preference=arousable'>[arousable == TRUE ? "Enabled" : "Disabled"]</a><BR>"
					dat += "<b>Genital examine text</b>:<a href='?_src_=prefs;preference=genital_examine'>[(cit_toggles & GENITAL_EXAMINE) ? "Enabled" : "Disabled"]</a><BR>"
					dat += "<b>Vore examine text</b>:<a href='?_src_=prefs;preference=vore_examine'>[(cit_toggles & VORE_EXAMINE) ? "Enabled" : "Disabled"]</a><BR>"
					dat += "<b>Voracious MediHound sleepers:</b> <a href='?_src_=prefs;preference=hound_sleeper'>[(cit_toggles & MEDIHOUND_SLEEPER) ? "Yes" : "No"]</a><br>"
					dat += "<b>Hear Vore Sounds:</b> <a href='?_src_=prefs;preference=toggleeatingnoise'>[(cit_toggles & EATING_NOISES) ? "Yes" : "No"]</a><br>"
					dat += "<b>Hear Vore Digestion Sounds:</b> <a href='?_src_=prefs;preference=toggledigestionnoise'>[(cit_toggles & DIGESTION_NOISES) ? "Yes" : "No"]</a><br>"
					dat += "<b>Allow trash forcefeeding (requires Trashcan quirk)</b> <a href='?_src_=prefs;preference=toggleforcefeedtrash'>[(cit_toggles & TRASH_FORCEFEED) ? "Yes" : "No"]</a><br>"
					dat += "<b>Forced Feminization:</b> <a href='?_src_=prefs;preference=feminization'>[(cit_toggles & FORCED_FEM) ? "Allowed" : "Disallowed"]</a><br>"
					dat += "<b>Forced Masculinization:</b> <a href='?_src_=prefs;preference=masculinization'>[(cit_toggles & FORCED_MASC) ? "Allowed" : "Disallowed"]</a><br>"
					dat += "<b>Lewd Hypno:</b> <a href='?_src_=prefs;preference=hypno'>[(cit_toggles & HYPNO) ? "Allowed" : "Disallowed"]</a><br>"
					dat += "<b>Bimbofication:</b> <a href='?_src_=prefs;preference=bimbo'>[(cit_toggles & BIMBOFICATION) ? "Allowed" : "Disallowed"]</a><br>"
					dat += "</td>"
					dat +="<td width='300px' height='300px' valign='top'>"
					dat += "<h2>Other content prefs</h2>"
					dat += "<b>Breast Enlargement:</b> <a href='?_src_=prefs;preference=breast_enlargement'>[(cit_toggles & BREAST_ENLARGEMENT) ? "Allowed" : "Disallowed"]</a><br>"
					dat += "<b>Penis Enlargement:</b> <a href='?_src_=prefs;preference=penis_enlargement'>[(cit_toggles & PENIS_ENLARGEMENT) ? "Allowed" : "Disallowed"]</a><br>"
					dat += "<b>Butt Enlargement:</b> <a href='?_src_=prefs;preference=butt_enlargement'>[(cit_toggles & BUTT_ENLARGEMENT) ? "Allowed" : "Disallowed"]</a><br>"
					dat += "<b>Belly Inflation:</b> <a href='?_src_=prefs;preference=belly_inflation'>[(cit_toggles & BELLY_INFLATION) ? "Allowed" : "Disallowed"]</a><br>" //SPLURT Edit
					dat += "<b>Hypno:</b> <a href='?_src_=prefs;preference=never_hypno'>[(cit_toggles & NEVER_HYPNO) ? "Disallowed" : "Allowed"]</a><br>"
					dat += "<b>Aphrodisiacs:</b> <a href='?_src_=prefs;preference=aphro'>[(cit_toggles & NO_APHRO) ? "Disallowed" : "Allowed"]</a><br>"
					dat += "<b>Ass Slapping:</b> <a href='?_src_=prefs;preference=ass_slap'>[(cit_toggles & NO_ASS_SLAP) ? "Disallowed" : "Allowed"]</a><br>"
					//Gardelin0 EDIT
					dat += "<b>Sex Jitter:</b> <a href='?_src_=prefs;preference=sex_jitter'>[(cit_toggles & SEX_JITTER) ? "Allowed" : "Disallowed"]</a><br>"
					//SPLURT EDIT
					dat += "<b>Chastity Interactions :</b> <a href='?_src_=prefs;preference=chastitypref'>[(cit_toggles & CHASTITY) ? "Allowed" : "Disallowed"]</a><br>"
					dat += "<b>Genital Stimulation Modifiers :</b> <a href='?_src_=prefs;preference=stimulationpref'>[(cit_toggles & STIMULATION) ? "Allowed" : "Disallowed"]</a><br>"
					dat += "<b>Edging :</b> <a href='?_src_=prefs;preference=edgingpref'>[(cit_toggles & EDGING) ? "Allowed" : "Disallowed"]</a><br>"
					dat += "<b>Receive Cum Covering :</b> <a href='?_src_=prefs;preference=cumontopref'>[(cit_toggles & CUM_ONTO) ? "Allowed" : "Disallowed"]</a><br>"
					dat += "<span style='border-radius: 2px;border:1px dotted white;cursor:help;' title='Enables verbs involving farts, shit and piss.'>?</span> "
					dat += "<b>Unholy ERP verbs :</b> <a href='?_src_=prefs;preference=unholypref'>[unholypref]</a><br>" //https://www.youtube.com/watch?v=OHKARc-GObU
					dat += "<span style='border-radius: 2px;border:1px dotted white;cursor:help;' title='Enables macro / micro stepping and stomping interactions.'>?</span> "
//					dat += "<b>Stomping Interactions :</b> <a href='?_src_=prefs;preference=stomppref'>[stomppref ? "Yes" : "No"]</a><br>"
					//END OF SPLURT EDIT
					dat += "<span style='border-radius: 2px;border:1px dotted white;cursor:help;' title='Enables verbs involving ear/brain fucking.'>?</span> " //SPLURT Edit (wow! editception???)
					//SANDSTORM EDIT
					dat += 	"<b>Extreme ERP verbs :</b> <a href='?_src_=prefs;preference=extremepref'>[extremepref]</a><br>" // https://youtu.be/0YrU9ASVw6w
					if(extremepref != "No")
						dat += "<span style='border-radius: 2px;border:1px dotted white;cursor:help;' title='Enables verbs involving ear/brain fucking.'>?</span> " //SPLURT Edit
						dat += "<b><span style='color: #e60000;'>Harmful ERP verbs :</b> <a href='?_src_=prefs;preference=extremeharm'>[extremeharm]</a><br>"
					//END OF SANDSTORM EDIT
					dat += "<b>Automatic Wagging:</b> <a href='?_src_=prefs;preference=auto_wag'>[(cit_toggles & NO_AUTO_WAG) ? "Disabled" : "Enabled"]</a><br>"
					dat += "<b>Dance Near Disco Ball:</b> <a href='?_src_=prefs;preference=disco_dance'>[(cit_toggles & NO_DISCO_DANCE) ? "Disabled" : "Enabled"]</a><br>"
					dat += "<span style='border-radius: 2px;border:1px dotted white;cursor:help;' title='If anyone cums a blacklisted fluid into you, it uses the default fluid for that genital.'>?</span> "
					dat += "<b><a href='?_src_=prefs;preference=gfluid_black;task=input'>Genital Fluid Blacklist</a></b><br>"
					if(gfluid_blacklist?.len)
						dat += "<span style='border-radius: 2px;border:1px dotted white;cursor:help;' title='Remove a genital fluid from your blacklist.'>?</span> "
						dat += "<b><a href='?_src_=prefs;preference=gfluid_unblack;task=input'>Genital Fluid Un-Blacklist</a></b><br>"
					//SPLURT Edit end
					dat += "</tr></table>"

		if(KEYBINDINGS_TAB) // Custom keybindings
			dat += "<b>Keybindings:</b> <a href='?_src_=prefs;preference=hotkeys'>[(hotkeys) ? "Hotkeys" : "Input"]</a><br>"
			dat += "Keybindings mode controls how the game behaves with tab and map/input focus.<br>If it is on <b>Hotkeys</b>, the game will always attempt to force you to map focus, meaning keypresses are sent \
			directly to the map instead of the input. You will still be able to use the command bar, but you need to tab to do it every time you click on the game map.<br>\
			If it is on <b>Input</b>, the game will not force focus away from the input bar, and you can switch focus using TAB between these two modes: If the input bar is pink, that means that you are in non-hotkey mode, sending all keypresses of the normal \
			alphanumeric characters, punctuation, spacebar, backspace, enter, etc, typing keys into the input bar. If the input bar is white, you are in hotkey mode, meaning all keypresses go into the game's keybind handling system unless you \
			manually click on the input bar to shift focus there.<br>\
			Input mode is the closest thing to the old input system.<br>\
			<b>IMPORTANT:</b> While in input mode's non hotkey setting (tab toggled), Ctrl + KEY will send KEY to the keybind system as the key itself, not as Ctrl + KEY. This means Ctrl + T/W/A/S/D/all your familiar stuff still works, but you \
			won't be able to access any regular Ctrl binds.<br>"
			dat += "<br><b>Modifier-Independent binding</b> - This is a singular bind that works regardless of if Ctrl/Shift/Alt are held down. For example, if combat mode is bound to C in modifier-independent binds, it'll trigger regardless of if you are \
			holding down shift for sprint. <b>Each keybind can only have one independent binding, and each key can only have one keybind independently bound to it.</b>"
			// Create an inverted list of keybindings -> key
			var/list/user_binds = list()
			var/list/user_modless_binds = list()
			for (var/key in key_bindings)
				for(var/kb_name in key_bindings[key])
					user_binds[kb_name] += list(key)
			for (var/key in modless_key_bindings)
				user_modless_binds[modless_key_bindings[key]] = key

			var/list/kb_categories = list()
			// Group keybinds by category
			for (var/name in GLOB.keybindings_by_name)
				var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
				kb_categories[kb.category] += list(kb)

			dat += {"
			<style>
			span.bindname { display: inline-block; position: absolute; width: 20% ; left: 5px; padding: 5px; } \
			span.bindings { display: inline-block; position: relative; width: auto; left: 20%; width: auto; right: 20%; padding: 5px; } \
			span.independent { display: inline-block; position: absolute; width: 20%; right: 5px; padding: 5px; } \
			</style><body>
			"}

			for (var/category in kb_categories)
				dat += "<h3>[category]</h3>"
				for (var/i in kb_categories[category])
					var/datum/keybinding/kb = i
					var/current_independent_binding = user_modless_binds[kb.name] || "Unbound"
					if(!length(user_binds[kb.name]))
						dat += "<span class='bindname'>[kb.full_name]</span><span class='bindings'><a href ='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=["Unbound"]'>Unbound</a>"
						var/list/default_keys = hotkeys ? kb.hotkey_keys : kb.classic_keys
						if(LAZYLEN(default_keys))
							dat += "| Default: [default_keys.Join(", ")]"
						dat += "</span>"
						if(!kb.special && !kb.clientside)
							dat += "<span class='independent'>Independent Binding: <a href='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=[current_independent_binding];independent=1'>[current_independent_binding]</a></span>"
						dat += "<br>"
					else
						var/bound_key = user_binds[kb.name][1]
						dat += "<span class='bindname'l>[kb.full_name]</span><span class='bindings'><a href ='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
						for(var/bound_key_index in 2 to length(user_binds[kb.name]))
							bound_key = user_binds[kb.name][bound_key_index]
							dat += " | <a href ='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
						if(length(user_binds[kb.name]) < MAX_KEYS_PER_KEYBIND)
							dat += "| <a href ='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name]'>Add Secondary</a>"
						var/list/default_keys = hotkeys ? kb.classic_keys : kb.hotkey_keys
						if(LAZYLEN(default_keys))
							dat += "| Default: [default_keys.Join(", ")]"
						dat += "</span>"
						if(!kb.special && !kb.clientside)
							dat += "<span class='independent'>Independent Binding: <a href='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=[current_independent_binding];independent=1'>[current_independent_binding]</a></span>"
						dat += "<br>"

			dat += "<br><br>"
			dat += "<a href ='?_src_=prefs;preference=keybindings_reset'>\[Reset to default\]</a>"
			dat += "</body>"


	dat += "<hr><center>"

	if(!IsGuestKey(user.key))
		dat += "<a href='?_src_=prefs;preference=load'>Отменить</a> "
		dat += "<a href='?_src_=prefs;preference=save'>Сохранить изминения</a> "

	dat += "<a href='?_src_=prefs;preference=reset_all'>Сбросить изминения</a>"
	dat += "</center>"

	winshow(user, "preferences_window", TRUE)
	var/datum/browser/popup = new(user, "preferences_browser", "<div align='center'>Настройка персонажа</div>", 640, 770)
	popup.set_content(dat.Join())
	popup.open(FALSE)
	onclose(user, "preferences_window", src)

#undef SETUP_START_NODE
#undef SETUP_GET_LINK
#undef SETUP_GET_LINK_RANDOM
#undef SETUP_COLOR_BOX
#undef SETUP_NODE_SWITCH
#undef SETUP_NODE_INPUT
#undef SETUP_NODE_COLOR
#undef SETUP_NODE_RANDOM
#undef SETUP_NODE_INPUT_RANDOM
#undef SETUP_NODE_COLOR_RANDOM
#undef SETUP_CLOSE_NODE

#undef APPEARANCE_CATEGORY_COLUMN
#undef MAX_MUTANT_ROWS

/datum/preferences/proc/CaptureKeybinding(mob/user, datum/keybinding/kb, old_key, independent = FALSE, special = FALSE)
	var/HTML = {"
	<div id='focus' style="outline: 0;" tabindex=0>Keybinding: [kb.full_name]<br>[kb.description]<br><br><b>Press any key to change<br>Press ESC to clear</b></div>
	<script>
	var deedDone = false;
	document.onkeyup = function(e) {
		if(deedDone){ return; }
		var alt = e.altKey ? 1 : 0;
		var ctrl = e.ctrlKey ? 1 : 0;
		var shift = e.shiftKey ? 1 : 0;
		var numpad = (95 < e.keyCode && e.keyCode < 112) ? 1 : 0;
		var escPressed = e.keyCode == 27 ? 1 : 0;
		var url = 'byond://?_src_=prefs;preference=keybindings_set;keybinding=[kb.name];old_key=[old_key];[independent?"independent=1;":""][special?"special=1;":""]clear_key='+escPressed+';key='+e.key+';alt='+alt+';ctrl='+ctrl+';shift='+shift+';numpad='+numpad+';key_code='+e.keyCode;
		window.location=url;
		deedDone = true;
	}
	document.getElementById('focus').focus();
	</script>
	"}
	winshow(user, "capturekeypress", TRUE)
	var/datum/browser/popup = new(user, "capturekeypress", "<div align='center'>Keybindings</div>", 350, 300)
	popup.set_content(HTML)
	popup.open(FALSE)
	onclose(user, "capturekeypress", src)

/datum/preferences/proc/SetChoices(mob/user, limit = 17, list/splitJobs = list("Research Director", "Head of Personnel"), widthPerColumn = 295, height = 620) // BLUEMOON CHANGES - splitjob
	if(!SSjob)
		return

	//limit - The amount of jobs allowed per column. Defaults to 17 to make it look nice.
	//splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
	//widthPerColumn - Screen's width for every column.
	//height - Screen's height.

	var/width = widthPerColumn

	var/HTML = "<center>"
	if(SSjob.occupations.len <= 0)
		HTML += "The job SSticker is not yet finished creating jobs, please try again later"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Сохранить</a></center><br>" // Easier to press up here.

	else
		HTML += "<b>Приоритеты профессий</b><br>"
		HTML += "<div align='center'>Щелкните левой кнопкой мыши, чтобы повысить уровень предпочтения профессии, и правой кнопкой мыши, чтобы понизить его.<br></div>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Сохранить</a></center><br>" // Easier to press up here.
		HTML += "<script type='text/javascript'>function setJobPrefRedirect(level, rank) { window.location.href='?_src_=prefs;preference=job;task=setJobLevel;level=' + level + ';text=' + encodeURIComponent(rank); return false; }</script>"
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
		var/index = -1

		//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
		var/datum/job/lastJob

		for(var/datum/job/job in sort_list(SSjob.occupations, GLOBAL_PROC_REF(cmp_job_display_asc)))

			index += 1
			if((index >= limit) || (job.title in splitJobs))
				width += widthPerColumn
				if((index < limit) && (lastJob != null))
					//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
					//the last job's selection color. Creating a rather nice effect.
					for(var/i = 0, i < (limit - index), i += 1)
						HTML += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"
				HTML += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
				index = 0

			HTML += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
			var/rank = job.title
			var/displayed_rank = rank
			if(job.alt_titles.len && (rank in alt_titles_preferences))
				displayed_rank = alt_titles_preferences[rank]
			lastJob = job
			if(jobban_isbanned(user, rank))
				HTML += "<font color=\"#000000\">[rank]</font></td><td><a href='?_src_=prefs;bancheck=[rank]'> BANNED</a></td></tr>"
				continue
			var/required_playtime_remaining = job.required_playtime_remaining(user.client)
			if(required_playtime_remaining)
				HTML += "<font color=\"#000000\">[rank]</font></td><td><font color=\"#000000\"> \[ [get_exp_format(required_playtime_remaining)] as [job.get_exp_req_type()] \] </font></td></tr>"
				continue
			if(!job.player_old_enough(user.client))
				var/available_in_days = job.available_in_days(user.client)
				HTML += "<font color=\"#000000\">[rank]</font></td><td><font color=\"#000000\"> \[IN [(available_in_days)] DAYS\]</font></td></tr>"
				continue
			if(!user.client.prefs.pref_species.qualifies_for_rank(rank, user.client.prefs.features))
				if(user.client.prefs.pref_species.id == "human")
					HTML += "<font color=\"#000000\">[rank]</font></td><td><font color=\"#000000\"><b> \[MUTANT\]</b></font></td></tr>"
				else
					HTML += "<font color=\"#000000\">[rank]</font></td><td><font color=\"#000000\"><b> \[NON-HUMAN\]</b></font></td></tr>"
				continue
			//BLUE MOON ADDITION - XENO SUPREMACY - START
			if(job.is_species_blacklisted(user.client))
				HTML += "<font color=\"#000000\">[rank]</font></td><td><font color=\"#000000\"><b> \[SPECIES BLACKLISTED\]</b></font></td></tr>"
				continue
			//BLUE MOON ADDITION - XENO SUPREMACY - END
			if((job_preferences["[SSjob.overflow_role]"] == JP_LOW) && (rank != SSjob.overflow_role) && !jobban_isbanned(user, SSjob.overflow_role))
				HTML += "<font color=\"#000000\">[rank]</font></td><td></td></tr>"
				continue
			var/rank_title_line = "[displayed_rank]"
			if((rank in GLOB.command_positions) || (rank == "AI"))//Bold head jobs
				rank_title_line = "<b>[rank_title_line]</b>"
			if(job.alt_titles.len)
				rank_title_line = "<a href='?_src_=prefs;preference=job;task=alt_title;job_title=[job.title]'>[rank_title_line]</a>"

			else
				rank_title_line = "<span class='dark'>[rank_title_line]</span>" //Make it dark if we're not adding a button for alt titles
			HTML += rank_title_line

			HTML += "</td><td width='40%'>"

			var/prefLevelLabel = "ERROR"
			var/prefLevelColor = "pink"
			var/prefUpperLevel = -1 // level to assign on left click
			var/prefLowerLevel = -1 // level to assign on right click

			switch(job_preferences["[job.title]"])
				if(JP_HIGH)
					prefLevelLabel = "Высокий"
					prefLevelColor = "slateblue"
					prefUpperLevel = 4
					prefLowerLevel = 2
				if(JP_MEDIUM)
					prefLevelLabel = "Средний"
					prefLevelColor = "green"
					prefUpperLevel = 1
					prefLowerLevel = 3
				if(JP_LOW)
					prefLevelLabel = "Низкий"
					prefLevelColor = "orange"
					prefUpperLevel = 2
					prefLowerLevel = 4
				else
					prefLevelLabel = "Никогда"
					prefLevelColor = "red"
					prefUpperLevel = 3
					prefLowerLevel = 1

			HTML += "<a class='white' href='?_src_=prefs;preference=job;task=setJobLevel;level=[prefUpperLevel];text=[rank]' oncontextmenu='javascript:return setJobPrefRedirect([prefLowerLevel], \"[rank]\");'>"

			if(rank == SSjob.overflow_role)//Overflow is special
				if(job_preferences["[SSjob.overflow_role]"] == JP_LOW)
					HTML += "<font color=green>Yes</font>"
				else
					HTML += "<font color=red>No</font>"
				HTML += "</a></td></tr>"
				continue

			HTML += "<font color=[prefLevelColor]>[prefLevelLabel]</font>"
			HTML += "</a></td></tr>"

		for(var/i = 1, i < (limit - index), i += 1) // Finish the column so it is even
			HTML += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"

		HTML += "</td'></tr></table>"
		HTML += "</center></table>"

		var/message = "Станьте [SSjob.overflow_role], если настройки недоступны"
		if(joblessrole == BERANDOMJOB)
			message = "Получить случайную профессию, если настройки недоступны"
		else if(joblessrole == RETURNTOLOBBY)
			message = "Вернится в лобби, если настройки недоступны"
		HTML += "<center><br><a href='?_src_=prefs;preference=job;task=random'>[message]</a></center>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=reset'>Сбросить предпочтения</a></center>"

	var/datum/browser/popup = new(user, "mob_occupation", "<div align='center'>Occupation Preferences</div>", width, height)
	popup.set_window_options("can_close=0")
	popup.set_content(HTML)
	popup.open(FALSE)

/datum/preferences/proc/SetJobPreferenceLevel(datum/job/job, level)
	if (!job)
		return FALSE

	if (level == JP_HIGH) // to high
		//Set all other high to medium
		for(var/j in job_preferences)
			if(job_preferences["[j]"] == JP_HIGH)
				job_preferences["[j]"] = JP_MEDIUM
				//technically break here

	job_preferences["[job.title]"] = level
	return TRUE

/datum/preferences/proc/UpdateJobPreference(mob/user, role, desiredLvl)
	if(!SSjob || SSjob.occupations.len <= 0)
		return
	var/datum/job/job = SSjob.GetJob(role)

	if(!job)
		user << browse(null, "window=mob_occupation")
		ShowChoices(user)
		return

	if (!isnum(desiredLvl))
		to_chat(user, "<span class='danger'>UpdateJobPreference - desired level was not a number. Please notify coders!</span>")
		ShowChoices(user)
		return

	var/jpval = null
	switch(desiredLvl)
		if(3)
			jpval = JP_LOW
		if(2)
			jpval = JP_MEDIUM
		if(1)
			jpval = JP_HIGH

	if(role == SSjob.overflow_role)
		if(job_preferences["[job.title]"] == JP_LOW)
			jpval = null
		else
			jpval = JP_LOW

	SetJobPreferenceLevel(job, jpval)
	SetChoices(user)

	return TRUE


/datum/preferences/proc/ResetJobs()
	job_preferences = list()

/datum/preferences/proc/SetQuirks(mob/user)
	if(!SSquirks)
		to_chat(user, "<span class='danger'>The quirk subsystem is still initializing! Try again in a minute.</span>")
		return

	var/list/dat = list()
	if(!SSquirks.quirks.len)
		dat += "The quirk subsystem hasn't finished initializing, please hold..."
		dat += "<center><a href='?_src_=prefs;preference=trait;task=close'>Done</a></center><br>"

	else
		dat += "<center><b>Выбирайте навыки</b></center><br>"
		// BLUEMOON ADD START - настройки для отдельных квирков
		dat += "Настройки для отдельных квирков. Если нужный квирк не будет выставлен, то они работать не будут.<br>"
		dat += "<a href='?_src_=prefs;preference=traits_setup;task=change_shriek_option'>([BLUEMOON_TRAIT_NAME_SHRIEK]) Тип Крика: [shriek_type]</a>"
		dat += "<a href='?_src_=prefs;preference=traits_setup;task=lewd_summon_nickname'>([TRAIT_LEWD_SUMMON]) Прозвище для призываемого[summon_nickname ? ": ": ""][summon_nickname]</a>"
		dat += "<hr>"
		// BLUEMOON ADD END
		dat += "<div align='center'>Щелкните левой кнопкой мыши, чтобы добавить или удалить навык.<br>\
		Навыки применяются в начале раунда и обычно не могут быть удалены в ходе раунда.</div>"
		dat += "<center><a href='?_src_=prefs;preference=trait;task=close'>Сохранить</a></center>"
		dat += "<hr>"
		dat += "<center><b>Текущие навыки:</b> [all_quirks.len ? all_quirks.Join(", ") : "Нету"]</center>"
		dat += "<center>[GetPositiveQuirkCount()] / [MAX_QUIRKS] максимум положительных навыков<br>\
		<b>Количество очков для навыков:</b> [GetQuirkBalance(user)]<br>"
		dat += " <a href='?_src_=prefs;quirk_category=[QUIRK_POSITIVE]' [quirk_category == QUIRK_POSITIVE ? "class='linkOn'" : ""]>[QUIRK_POSITIVE]</a> "
		dat += " <a href='?_src_=prefs;quirk_category=[QUIRK_NEUTRAL]' [quirk_category == QUIRK_NEUTRAL ? "class='linkOn'" : ""]>[QUIRK_NEUTRAL]</a> "
		dat += " <a href='?_src_=prefs;quirk_category=[QUIRK_NEGATIVE]' [quirk_category == QUIRK_NEGATIVE ? "class='linkOn'" : ""]>[QUIRK_NEGATIVE]</a> "
		dat += "</center><br>"
		for(var/V in SSquirks.quirks)
			var/datum/quirk/T = SSquirks.quirks[V]
			var/value = initial(T.value)
			if((value > 0 && quirk_category != QUIRK_POSITIVE) || (value < 0 && quirk_category != QUIRK_NEGATIVE) || (value == 0 && quirk_category != QUIRK_NEUTRAL))
				continue

			var/quirk_name = initial(T.name)
			var/has_quirk
			var/quirk_cost = initial(T.value) * -1
			var/lock_reason = "This trait is unavailable."
			var/quirk_conflict = FALSE
			for(var/_V in all_quirks)
				if(_V == quirk_name)
					has_quirk = TRUE
			if(initial(T.mood_quirk) && CONFIG_GET(flag/disable_human_mood))
				lock_reason = "Mood is disabled."
				quirk_conflict = TRUE
			if(has_quirk)
				if(quirk_conflict)
					all_quirks -= quirk_name
					has_quirk = FALSE
				else
					quirk_cost *= -1 //invert it back, since we'd be regaining this amount
			if(quirk_cost > 0)
				quirk_cost = "+[quirk_cost]"
			var/font_color = "#AAAAFF"
			if(initial(T.value) != 0)
				font_color = value > 0 ? "#AAFFAA" : "#FFAAAA"
			if(quirk_conflict)
				dat += "<font color='[font_color]'>[quirk_name]</font> - [initial(T.desc)] \
				<font color='red'><b>LOCKED: [lock_reason]</b></font><br>"
			else
				if(has_quirk)
					dat += "<a href='?_src_=prefs;preference=trait;task=update;trait=[quirk_name]'>[has_quirk ? "Сбросить" : "Взять"] ([quirk_cost] pts.)</a> \
					<b><font color='[font_color]'>[quirk_name]</font></b> - [initial(T.desc)]<br>"
				else
					dat += "<a href='?_src_=prefs;preference=trait;task=update;trait=[quirk_name]'>[has_quirk ? "Сбросить" : "Взять"] ([quirk_cost] pts.)</a> \
					<font color='[font_color]'>[quirk_name]</font> - [initial(T.desc)]<br>"
		dat += "<br><center><a href='?_src_=prefs;preference=trait;task=reset'>Сброс навыков</a></center>"

	var/datum/browser/popup = new(user, "mob_occupation", "<div align='center'>Предпочтения навыков</div>", 900, 600) //no reason not to reuse the occupation window, as it's cleaner that way
	popup.set_window_options("can_close=0")
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/GetQuirkBalance(mob/user)
	var/bal = 0
	for(var/V in all_quirks)
		var/datum/quirk/T = SSquirks.quirks[V]
		bal -= initial(T.value)
	for(var/modification in modified_limbs)
		if(modified_limbs[modification][1] == LOADOUT_LIMB_PROSTHETIC)
			bal += 1 //max 1 point regardless of how many prosthetics
	if(bal < 0)
		all_quirks = list()
		return FALSE
	return bal

/datum/preferences/proc/GetPositiveQuirkCount()
	. = 0
	for(var/q in all_quirks)
		if(SSquirks.quirk_points[q] > 0)
			.++

/datum/preferences/Topic(href, href_list, hsrc)			//yeah, gotta do this I guess..
	. = ..()
	if(href_list["close"])
		var/client/C = usr.client
		if(C)
			C.clear_character_previews()

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(href_list["jobbancheck"])
		var/job = href_list["jobbancheck"]
		var/datum/db_query/query_get_jobban = SSdbcore.NewQuery({"
			SELECT reason, bantime, duration, expiration_time, IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].a_ckey), a_ckey)
			FROM [format_table_name("ban")] WHERE ckey = :ckey AND (bantype = 'JOB_PERMABAN'  OR (bantype = 'JOB_TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned) AND job = :job
			"}, list("ckey" = user.ckey, "job" = job))
		if(!query_get_jobban.warn_execute())
			qdel(query_get_jobban)
			return
		if(query_get_jobban.NextRow())
			var/reason = query_get_jobban.item[1]
			var/bantime = query_get_jobban.item[2]
			var/duration = query_get_jobban.item[3]
			var/expiration_time = query_get_jobban.item[4]
			var/admin_key = query_get_jobban.item[5]
			var/text
			text = "<span class='redtext'>You, or another user of this computer, ([user.key]) is banned from playing [job]. The ban reason is:<br>[reason]<br>This ban was applied by [admin_key] on [bantime]"
			if(text2num(duration) > 0)
				text += ". The ban is for [duration] minutes and expires on [expiration_time] (server time)"
			text += ".</span>"
			to_chat(user, text, confidential = TRUE)
		qdel(query_get_jobban)
		return

	if(href_list["preference"] == "job")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				ShowChoices(user)
			if("reset")
				ResetJobs()
				SetChoices(user)
			if("random")
				switch(joblessrole)
					if(RETURNTOLOBBY)
						if(jobban_isbanned(user, SSjob.overflow_role))
							joblessrole = BERANDOMJOB
						else
							joblessrole = BEOVERFLOW
					if(BEOVERFLOW)
						joblessrole = BERANDOMJOB
					if(BERANDOMJOB)
						joblessrole = RETURNTOLOBBY
				SetChoices(user)
			if("setJobLevel")
				UpdateJobPreference(user, href_list["text"], text2num(href_list["level"]))
			if("alt_title")
				var/job_title = href_list["job_title"]
				var/titles_list = list(job_title)
				var/datum/job/J = SSjob.GetJob(job_title)
				for(var/i in J.alt_titles)
					titles_list += i
				var/chosen_title
				chosen_title = tgui_input_list(user, "Choose your job's title:", "Job Preference", titles_list)
				if(chosen_title)
					if(chosen_title == job_title)
						if(alt_titles_preferences[job_title])
							alt_titles_preferences.Remove(job_title)
					else
						alt_titles_preferences[job_title] = chosen_title
				SetChoices(user)
			else
				SetChoices(user)
		return TRUE

	else if(href_list["preference"] == "trait")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				ShowChoices(user)
			if("update")
				var/quirk = href_list["trait"]
				if(!SSquirks.quirks[quirk])
					return
				for(var/V in SSquirks.quirk_blacklist) //V is a list
					var/list/L = V
					for(var/Q in all_quirks)
						if((quirk in L) && (Q in L) && !(Q == quirk)) //two quirks have lined up in the list of the list of quirks that conflict with each other, so return (see quirks.dm for more details)
							to_chat(user, "<span class='danger'>[quirk] имеет несовместимость с квирком [Q].</span>") //BLUEMOON EDIT перевод
							return
				var/value = SSquirks.quirk_points[quirk]
				var/balance = GetQuirkBalance(user)
				if(quirk in all_quirks)
					if(balance + value < 0)
						to_chat(user, "<span class='warning'>Возврат этой суммы приведет к тому, что ваш баланс будет ниже!</span>")
						return
					all_quirks -= quirk
				else
					if(GetPositiveQuirkCount() >= MAX_QUIRKS && value > 0)
						to_chat(user, "<span class='warning'>У вас не может быть более [MAX_QUIRKS] положительных навыков!</span>")
						return
					if(balance - value < 0)
						to_chat(user, "<span class='warning'>Вам не хватает очков, чтобы получить этот навык!</span>")
						return
					all_quirks += quirk
				SetQuirks(user)
			if("reset")
				all_quirks = list()
				SetQuirks(user)
			else
				SetQuirks(user)
	// BLUEMOON ADD START - возможность настраивать квирки
	else if(href_list["preference"] == "traits_setup")
		switch(href_list["task"])
			if("change_shriek_option") // изменение вида крика от квирка крикуна
				var/client/C = usr.client
				if(C)
					var/new_shriek_type = tgui_input_list(user, "Choose your character's shriek type.", "Character Preference", GLOB.shriek_types)
					if(new_shriek_type)
						shriek_type = new_shriek_type
						SetQuirks(user)
			if("lewd_summon_nickname")
				var/client/C = usr.client
				if(C)
					var/new_summon_nickname = input(user, "Задайте прозвище во время призыва вашего персонажа:", "Character Preference")  as text|null
					if(new_summon_nickname)
						new_summon_nickname = reject_bad_name(new_summon_nickname, allow_numbers = TRUE)
						if(new_summon_nickname)
							summon_nickname = new_summon_nickname
							SetQuirks(user)
						else
							to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, А-Я, а-я, -, ' and .</font>")

	// BLUEMOON ADD END
		return TRUE

	else if(href_list["quirk_category"])
		var/temp_quirk_category = href_list["quirk_category"]
		if(temp_quirk_category == QUIRK_POSITIVE || temp_quirk_category == QUIRK_NEUTRAL || temp_quirk_category == QUIRK_NEGATIVE)
			quirk_category = temp_quirk_category
			SetQuirks(user)

	else if(href_list["preference"] == "language")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				ShowChoices(user)
				return TRUE
			if("update")
				var/lang = href_list["language"]
				if(!SSlanguage.languages_by_name[lang])
					return
				if(!toggle_language(lang))
					return
				language = sort_list(language)
			if("reset")
				language = list()
		SetLanguage(user)
		return TRUE

	switch(href_list["task"])
		if("random")
			switch(href_list["preference"])
				if("name")
					real_name = pref_species.random_name(gender,1)
				if("age")
					age = rand(AGE_MIN, AGE_MAX)
				if("hair")
					hair_color = random_short_color()
				if("hair_style")
					hair_style = random_hair_style(gender)
				if("facial")
					facial_hair_color = random_short_color()
				if("facial_hair_style")
					facial_hair_style = random_facial_hair_style(gender)
				/*
				if("underwear")
					underwear = random_underwear(gender)
					undie_color = random_short_color()
				if("undershirt")
					undershirt = random_undershirt(gender)
					shirt_color = random_short_color()
				if("socks")
					socks = random_socks()
					socks_color = random_short_color()
				*/
				if(BODY_ZONE_PRECISE_EYES)
					var/random_eye_color = random_eye_color()
					left_eye_color = random_eye_color
					right_eye_color = random_eye_color
				if("s_tone")
					skin_tone = random_skin_tone()
					use_custom_skin_tone = null
				if("bag")
					backbag = pick(GLOB.backbaglist)
				if("suit")
					jumpsuit_style = pick(GLOB.jumpsuitlist)
				if("all")
					random_character()

		if("input")

			if(href_list["preference"] in GLOB.preferences_custom_names)
				ask_for_custom_name(user,href_list["preference"])


			switch(href_list["preference"])
				if("ghostform")
					if(unlock_content)
						var/new_form = tgui_input_list(user, "Thanks for supporting BYOND - Choose your ghostly form:","Thanks for supporting BYOND", GLOB.ghost_forms, null)
						if(new_form)
							ghost_form = new_form
				if("ghostorbit")
					if(unlock_content)
						var/new_orbit = tgui_input_list(user, "Thanks for supporting BYOND - Choose your ghostly orbit:","Thanks for supporting BYOND",  GLOB.ghost_orbits, null)
						if(new_orbit)
							ghost_orbit = new_orbit

				if("ghostaccs")
					var/new_ghost_accs = alert("Do you want your ghost to show full accessories where possible, hide accessories but still use the directional sprites where possible, or also ignore the directions and stick to the default sprites?",,GHOST_ACCS_FULL_NAME, GHOST_ACCS_DIR_NAME, GHOST_ACCS_NONE_NAME)
					switch(new_ghost_accs)
						if(GHOST_ACCS_FULL_NAME)
							ghost_accs = GHOST_ACCS_FULL
						if(GHOST_ACCS_DIR_NAME)
							ghost_accs = GHOST_ACCS_DIR
						if(GHOST_ACCS_NONE_NAME)
							ghost_accs = GHOST_ACCS_NONE

				if("ghostothers")
					var/new_ghost_others = alert("Do you want the ghosts of others to show up as their own setting, as their default sprites or always as the default white ghost?",,GHOST_OTHERS_THEIR_SETTING_NAME, GHOST_OTHERS_DEFAULT_SPRITE_NAME, GHOST_OTHERS_SIMPLE_NAME)
					switch(new_ghost_others)
						if(GHOST_OTHERS_THEIR_SETTING_NAME)
							ghost_others = GHOST_OTHERS_THEIR_SETTING
						if(GHOST_OTHERS_DEFAULT_SPRITE_NAME)
							ghost_others = GHOST_OTHERS_DEFAULT_SPRITE
						if(GHOST_OTHERS_SIMPLE_NAME)
							ghost_others = GHOST_OTHERS_SIMPLE

				if("name")
					var/new_name = input(user, "Задайте имя вашего персонажа:", "Character Preference")  as text|null
					if(new_name)
						new_name = reject_bad_name(new_name, allow_numbers = TRUE)
						if(new_name)
							real_name = new_name
						else
							to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, А-Я, а-я, -, ' and .</font>")

				if("age")
					var/new_age = tgui_input_number(user, "Задайте возраст вашего персонажа:\n([AGE_MIN]-[AGE_MAX_INPUT])", "Character Preference", null, AGE_MAX_INPUT, AGE_MIN)
					if(new_age)
						age = max(min( round(text2num(new_age)), AGE_MAX_INPUT),AGE_MIN)

				if("security_records")
					var/rec = stripped_multiline_input(usr, "Напишите заметки службы безопасности о вашем персонаже.", "Служебные заметки", html_decode(security_records), MAX_FLAVOR_LEN, TRUE)
					if(!isnull(rec))
						security_records = rec

				if("medical_records")
					var/rec = stripped_multiline_input(usr, "Напишите медицинские заметки о вашем персонаже.", "Медицинские заметки", html_decode(medical_records), MAX_FLAVOR_LEN, TRUE)
					if(!isnull(rec))
						medical_records = rec

				if("flavor_text")
					var/msg = input(usr, "Задайте внешнее описание вашего персонажа.", "Описание Bнешности Персонажа", features["flavor_text"]) as message|null //Skyrat edit, removed stripped_multiline_input()
					if(!isnull(msg))
						features["flavor_text"] = strip_html_simple(msg, MAX_FLAVOR_LEN, TRUE) //Skyrat edit, removed strip_html_simple()

				//SPLURT edit
				if("naked_flavor_text")
					var/msg = input(usr, "Задайте описание вашего персонажа без одежды.", "Описание Bнешности Голого Персонажа", features["naked_flavor_text"]) as message|null
					if(!isnull(msg))
						features["naked_flavor_text"] = strip_html_simple(msg, MAX_FLAVOR_LEN, TRUE)

				//SPLURT edit end
				if("silicon_flavor_text")
					var/msg = input(usr, "Задайте особые признаки внешности своего синтетического (борга) персонажа!", "Описание Борга", features["silicon_flavor_text"]) as message|null //Skyrat edit, removed stripped_multiline_input()
					if(!isnull(msg))
						features["silicon_flavor_text"] = strip_html_simple(msg, MAX_FLAVOR_LEN, TRUE) //Skyrat edit, uses strip_html_simple()

				if("custom_species_lore")
					var/msg = input(usr, "Задайте особую предысторию расы своего персонажа!", "Предыстория Расы Bашего Персонажа", features["silicon_flavor_text"]) as message|null //Skyrat edit, removed stripped_multiline_input()
					if(!isnull(msg))
						features["custom_species_lore"] = strip_html_simple(msg, MAX_FLAVOR_LEN, TRUE)
				// BLUEMOON ADD START - пользовательский эмоут смерти
				if("custom_deathgasp")
					var/msg = input(usr, "Задайте эмоцию, которая будет проигрываться при смерти вашего персонажа!", "Сообщение О Смерти", features["custom_deathgasp"]) as message|null
					if(!isnull(msg))
						features["custom_deathgasp"] = strip_html_simple(msg, MAX_DEATHGASP_LEN, TRUE)
				if("custom_deathsound")
					var/sound_name = tgui_input_list(user, "Выберите звук смерти персонажа!", "Звук Смерти", GLOB.deathgasp_sounds)
					if(sound_name)
						features["custom_deathsound"] = sound_name
				if("deathsoundpreview")
					if(SSticker.current_state == GAME_STATE_STARTUP) //Timers don't tick at all during game startup, so let's just give an error message
						to_chat(user, "<span class='warning'>Deathgasp sound previews can't play during initialization!</span>")
						return
					if(!COOLDOWN_FINISHED(src, deathsound_preview))
						return
					if(!user)
						return
					COOLDOWN_START(src, deathsound_preview, (3 SECONDS))
					var/picked_deathsound_name = features["custom_deathsound"]
					var/picked_deathsound_path
					if(picked_deathsound_name)
						if(picked_deathsound_name == "По умолчанию")
							picked_deathsound_path = pick('sound/voice/deathgasp1.ogg', 'sound/voice/deathgasp2.ogg')
						if(picked_deathsound_name == "Беззвучный")
							picked_deathsound_path = 0
						if(GLOB.deathgasp_sounds[picked_deathsound_name])
							picked_deathsound_path = GLOB.deathgasp_sounds[picked_deathsound_name]
					if(picked_deathsound_path)
						user.playsound_local(user, picked_deathsound_path, 60)
					else
						to_chat(user, "<span class='warning'>Вы выбрали беззвучный deathgasp или выбранный вами звук отсутствует!</span>")
				// BLUEMOON ADD END
				if("ooc_notes")
					var/msg = stripped_multiline_input(usr, "Установите всегда видимые OOC-заметки, связанные с вашими предпочтениями.", "ООС-Заметки", html_decode(features["ooc_notes"]), MAX_FLAVOR_LEN, TRUE)
					if(!isnull(msg))
						features["ooc_notes"] = msg

				if("hide_ckey")
					hide_ckey = !hide_ckey
					if(user)
						user.mind?.hide_ckey = hide_ckey

				//SPLURT EDIT BEGIN - gregnancy
				if("virility")
					var/viri = input(user, "Set the chance of you impregnating something (set to 0 to disable). \n(0 = minimum, 100 = maximum)", "Character Preference", virility) as num|null
					virility = clamp(viri, 0, 100)

				if("fertility")
					var/fert = input(user, "Set the chance of you getting impregnated (set to 0 to disable). \n(0 = minimum, 100 = maximum)", "Character Preference", fertility) as num|null
					fertility = clamp(fert, 0, 100)

				if("egg_shell")
					var/shell = tgui_input_list(user, "Pick a shell for your eggs", "Character Preferences", GLOB.egg_skins)
					if(shell)
						egg_shell = shell

				if("pregnancy_inflation")
					pregnancy_inflation = !pregnancy_inflation

				if("pregnancy_breast_growth")
					pregnancy_breast_growth = !pregnancy_breast_growth

				//SPLURT EDIT END

				if("hair")
					var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference","#"+hair_color) as color|null
					if(new_hair)
						hair_color = sanitize_hexcolor(new_hair, 6)

				if("hair_style")
					var/new_hair_style
					new_hair_style = tgui_input_list(user, "Choose your character's hair style:", "Character Preference", GLOB.hair_styles_list)
					if(new_hair_style)
						hair_style = new_hair_style

				if("next_hair_style")
					hair_style = next_list_item(hair_style, GLOB.hair_styles_list)

				if("previous_hair_style")
					hair_style = previous_list_item(hair_style, GLOB.hair_styles_list)

				if("facial")
					var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference","#"+facial_hair_color) as color|null
					if(new_facial)
						facial_hair_color = sanitize_hexcolor(new_facial, 6)

				if("facial_hair_style")
					var/new_facial_hair_style
					new_facial_hair_style = tgui_input_list(user, "Choose your character's facial-hair style:", "Character Preference", GLOB.facial_hair_styles_list)
					if(new_facial_hair_style)
						facial_hair_style = new_facial_hair_style

				if("next_facehair_style")
					facial_hair_style = next_list_item(facial_hair_style, GLOB.facial_hair_styles_list)

				if("previous_facehair_style")
					facial_hair_style = previous_list_item(facial_hair_style, GLOB.facial_hair_styles_list)

				if("grad_color")
					var/new_grad_color = input(user, "Choose your character's gradient colour:", "Character Preference","#"+grad_color) as color|null
					if(new_grad_color)
						grad_color = sanitize_hexcolor(new_grad_color, 6)

				if("grad_style")
					var/new_grad_style
					new_grad_style = tgui_input_list(user, "Choose your character's hair gradient style:", "Character Preference", GLOB.hair_gradients_list)
					if(new_grad_style)
						grad_style = new_grad_style

				if("next_grad_style")
					grad_style = next_list_item(grad_style, GLOB.hair_gradients_list)

				if("previous_grad_style")
					grad_style = previous_list_item(grad_style, GLOB.hair_gradients_list)

				// BLUEMOON ADD START - <_AND_>_FOR_CHARACTER_REDACTOR

				// HORNS
				if("next_horns_style")
					features["horns"] = next_list_item(features["horns"], GLOB.horns_list)

				if("previous_horns_style")
					features["horns"] = previous_list_item(features["horns"], GLOB.horns_list)

				// MEAT TYPE
				if("next_meat_type_style")
					features["meat_type"] = next_list_item(features["meat_type"], GLOB.meat_types)

				if("previous_meat_type_style")
					features["meat_type"] = previous_list_item(features["meat_type"], GLOB.meat_types)

				// IPC ANTENNA
				if("next_ipc_antenna_style")
					features["ipc_antenna"] = next_list_item(features["ipc_antenna"], GLOB.ipc_antennas_list)

				if("previous_ipc_antenna_style")
					features["ipc_antenna"] = previous_list_item(features["ipc_antenna"], GLOB.ipc_antennas_list)

				// IPC SCREENS
				if("next_ipc_screen_style")
					features["ipc_screen"] = next_list_item(features["ipc_screen"], GLOB.ipc_screens_list)

				if("previous_ipc_screen_style")
					features["ipc_screen"] = previous_list_item(features["ipc_screen"], GLOB.ipc_screens_list)

				// XENO DORSALS
				if("next_xenodorsal_style")
					features["xenodorsal"] = next_list_item(features["xenodorsal"], GLOB.xeno_dorsal_list)

				if("previous_xenodorsal_style")
					features["xenodorsal"] = previous_list_item(features["xenodorsal"], GLOB.xeno_dorsal_list)

				// XENO TAILS
				if("next_xenotail_style")
					features["xenotail"] = next_list_item(features["xenotail"], GLOB.xeno_tail_list)

				if("previous_xenotail_style")
					features["xenotail"] = previous_list_item(features["xenotail"], GLOB.xeno_tail_list)

				// XENO HEADS
				if("next_xenohead_style")
					features["xenohead"] = next_list_item(features["xenohead"], GLOB.xeno_head_list)

				if("previous_xenohead_style")
					features["xenohead"] = previous_list_item(features["xenohead"], GLOB.xeno_head_list)

				// ARACHNIDS MANDIBLES
				if("next_arachnid_mandibles_style")
					features["arachnid_mandibles"] = next_list_item(features["arachnid_mandibles"], GLOB.arachnid_mandibles_list)

				if("previous_arachnid_mandibles_style")
					features["arachnid_mandibles"] = previous_list_item(features["arachnid_mandibles"], GLOB.arachnid_mandibles_list)

				// ARACHINDS SPHINNERET
				if("next_arachnid_spinneret_style")
					features["arachnid_spinneret"] = next_list_item(features["arachnid_spinneret"], GLOB.arachnid_spinneret_list)

				if("previous_arachnid_spinneret_style")
					features["arachnid_spinneret"] = previous_list_item(features["arachnid_spinneret"], GLOB.arachnid_spinneret_list)

				// ARACHNIDS LEGS
				if("next_arachnid_legs_style")
					features["arachnid_legs"] = next_list_item(features["arachnid_legs"], GLOB.arachnid_legs_list)

				if("previous_arachnid_legs_style")
					features["arachnid_legs"] = previous_list_item(features["arachnid_legs"], GLOB.arachnid_legs_list)

				// WINGS
				if("next_wings_style")
					features["wings"] = next_list_item(features["wings"], GLOB.wings_list)

				if("previous_wings_style")
					features["wings"] = previous_list_item(features["wings"], GLOB.wings_list)

				// TAUR BODY
				if("next_taur_style")
					features["taur"] = next_list_item(features["taur"], GLOB.taur_list)

				if("previous_taur_style")
					features["taur"] = previous_list_item(features["taur"], GLOB.taur_list)

				// INSECT FLUFF (NECK AND SPINE)
				if("next_insect_fluff_style")
					features["insect_fluff"] = next_list_item(features["insect_fluff"], GLOB.insect_fluffs_list)

				if("previous_insect_fluff_style")
					features["insect_fluff"] = previous_list_item(features["insect_fluff"], GLOB.insect_fluffs_list)

				// INSECT WINGS
				if("next_insect_wings_style")
					features["insect_wings"] = next_list_item(features["insect_wings"], GLOB.insect_wings_list)

				if("previous_insect_wings_style")
					features["insect_wings"] = previous_list_item(features["insect_wings"], GLOB.insect_wings_list)

				// DECO WINGS
				if("next_deco_wings_style")
					features["deco_wings"] = next_list_item(features["deco_wings"], GLOB.deco_wings_list)

				if("previous_deco_wings_style")
					features["deco_wings"] = previous_list_item(features["deco_wings"], GLOB.deco_wings_list)

				// LEGS
				if("next_legs_style")
					features["legs"] = next_list_item(features["legs"], GLOB.legs_list)

				if("previous_legs_style")
					features["legs"] = previous_list_item(features["legs"], GLOB.legs_list)

				// MAMMAL SNOUTS
				if("next_mam_snouts_style")
					features["mam_snouts"] = next_list_item(features["mam_snouts"], GLOB.mam_snouts_list)

				if("previous_mam_snouts_style")
					features["mam_snouts"] = previous_list_item(features["mam_snouts"], GLOB.mam_snouts_list)

				// EARS
				if("next_ears_style")
					features["ears"] = next_list_item(features["ears"], GLOB.ears_list)

				if("previous_ears_style")
					features["ears"] = previous_list_item(features["ears"], GLOB.ears_list)

				// MAMMAL EARS
				if("next_mam_ears_style")
					features["mam_ears"] = next_list_item(features["mam_ears"], GLOB.mam_ears_list)

				if("previous_mam_ears_style")
					features["mam_ears"] = previous_list_item(features["mam_ears"], GLOB.mam_ears_list)

				// LIZARDS SPINES
				if("next_spines_style")
					features["spines"] = next_list_item(features["spines"], GLOB.spines_list)

				if("previous_spines_style")
					features["spines"] = previous_list_item(features["spines"], GLOB.spines_list)

				// LIZARDS FRILLS
				if("next_frills_style")
					features["frills"] = next_list_item(features["frills"], GLOB.frills_list)

				if("previous_frills_style")
					features["frills"] = previous_list_item(features["frills"], GLOB.frills_list)

				// LIZARDS SNOUTS
				if("next_snout_style")
					features["snout"] = next_list_item(features["snout"], GLOB.snouts_list)

				if("previous_snout_style")
					features["snout"] = previous_list_item(features["snout"], GLOB.snouts_list)

				// HUMAN TAILS
				if("next_tail_human_style")
					features["tail_human"] = next_list_item(features["tail_human"], GLOB.tails_list_human)

				if("previous_tail_human_style")
					features["tail_human"] = previous_list_item(features["tail_human"], GLOB.tails_list_human)

				// LIZARDS TAILS
				if("next_tail_lizard_style")
					features["tail_lizard"] = next_list_item(features["tail_lizard"], GLOB.tails_list_lizard)

				if("previous_tail_lizard_style")
					features["tail_lizard"] = previous_list_item(features["tail_lizard"], GLOB.tails_list_lizard)

				// MAMMAL TAILS
				if("next_mam_tail_style")
					features["mam_tail"] = next_list_item(features["mam_tail"], GLOB.mam_tails_list)

				if("previous_mam_tail_style")
					features["mam_tail"] = previous_list_item(features["mam_tail"], GLOB.mam_tails_list)
				// BLUEMOON ADD END

				if("cycle_bg")
					bgstate = next_list_item(bgstate, bgstate_options)

				if("modify_limbs")
					var/limb_type = tgui_input_list(user, "Choose the limb to modify:", "Character Preference", LOADOUT_ALLOWED_LIMB_TARGETS)
					if(limb_type)
						var/modification_type = tgui_input_list(user, "Choose the modification to the limb:", "Character Preference", LOADOUT_LIMBS)
						if(modification_type)
							if(modification_type == LOADOUT_LIMB_PROSTHETIC)
								var/prosthetic_type = tgui_input_list(user, "Choose the type of prosthetic", "Character Preference", (list("prosthetic") + GLOB.prosthetic_limb_types))
								if(prosthetic_type)
									var/number_of_prosthetics = 0
									for(var/modified_limb in modified_limbs)
										if(modified_limbs[modified_limb][1] == LOADOUT_LIMB_PROSTHETIC && modified_limb != limb_type)
											number_of_prosthetics += 1
									if(number_of_prosthetics == MAXIMUM_LOADOUT_PROSTHETICS)
										to_chat(user, "<span class='danger'>You can only have up to two prosthetic limbs!</span>")
									else
										//save the actual prosthetic data
										modified_limbs[limb_type] = list(modification_type, prosthetic_type)
							else
								if(modification_type == LOADOUT_LIMB_NORMAL)
									modified_limbs -= limb_type
								else
									modified_limbs[limb_type] = list(modification_type)

				/*
				if("underwear")
					var/new_underwear = input(user, "Choose your character's underwear:", "Character Preference")  as null|anything in GLOB.underwear_list
					if(new_underwear)
						underwear = new_underwear

				if("undie_color")
					var/n_undie_color = input(user, "Choose your underwear's color.", "Character Preference", "#[undie_color]") as color|null
					if(n_undie_color)
						undie_color = sanitize_hexcolor(n_undie_color, 6)

				if("undershirt")
					var/new_undershirt = input(user, "Choose your character's undershirt:", "Character Preference") as null|anything in GLOB.undershirt_list
					if(new_undershirt)
						undershirt = new_undershirt

				if("shirt_color")
					var/n_shirt_color = input(user, "Choose your undershirt's color.", "Character Preference", "#[shirt_color]") as color|null
					if(n_shirt_color)
						shirt_color = sanitize_hexcolor(n_shirt_color, 6)

				if("socks")
					var/new_socks = input(user, "Choose your character's socks:", "Character Preference") as null|anything in GLOB.socks_list
					if(new_socks)
						socks = new_socks

				if("socks_color")
					var/n_socks_color = input(user, "Choose your socks' color.", "Character Preference", "#[socks_color]") as color|null
					if(n_socks_color)
						socks_color = sanitize_hexcolor(n_socks_color, 6)
				*/

				if("eyes")
					var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference","#"+left_eye_color) as color|null
					if(new_eyes)
						left_eye_color = sanitize_hexcolor(new_eyes, 6)
						right_eye_color = sanitize_hexcolor(new_eyes, 6)

				if("eye_left")
					var/new_eyes = input(user, "Choose your character's left eye colour:", "Character Preference","#"+left_eye_color) as color|null
					if(new_eyes)
						left_eye_color = sanitize_hexcolor(new_eyes, 6)

				if("eye_right")
					var/new_eyes = input(user, "Choose your character's right eye colour:", "Character Preference","#"+right_eye_color) as color|null
					if(new_eyes)
						right_eye_color = sanitize_hexcolor(new_eyes, 6)

				if("eye_type")
					var/new_eye_type = tgui_input_list(user, "Choose your character's eye type.", "Character Preference", GLOB.eye_types)
					if(new_eye_type)
						eye_type = new_eye_type

				if("toggle_split_eyes")
					split_eye_colors = !split_eye_colors
					right_eye_color = left_eye_color

				if("species")
					var/result = tgui_input_list(user, "Select a species", "Species Selection", GLOB.roundstart_race_names)
					if(result)
						var/newtype = GLOB.species_list[GLOB.roundstart_race_names[result]]
						pref_species = new newtype()
						//let's ensure that no weird shit happens on species swapping.
						custom_species = null
						if(!parent.can_have_part("mam_body_markings"))
							features["mam_body_markings"] = list()
						if(parent.can_have_part("mam_body_markings"))
							if(features["mam_body_markings"] == "None")
								features["mam_body_markings"] = list()
						if(parent.can_have_part("tail_lizard"))
							features["tail_lizard"] = "Smooth"
						if(pref_species.id == "felinid")
							features["mam_tail"] = "Cat"
							features["mam_ears"] = "Cat"

						//Now that we changed our species, we must verify that the mutant colour is still allowed.
						var/temp_hsv = RGBtoHSV(features["mcolor"])
						if(features["mcolor"] == "#000000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#202020")[3]))
							features["mcolor"] = pref_species.default_color
						if(features["mcolor2"] == "#000000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#202020")[3]))
							features["mcolor2"] = pref_species.default_color
						if(features["mcolor3"] == "#000000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#202020")[3]))
							features["mcolor3"] = pref_species.default_color

						//switch to the type of eyes the species uses
						eye_type = pref_species.eye_type

				if("custom_species")
					var/new_species = reject_bad_name(input(user, "Выберите особую расу персонажа, если он уникален. Это будет отображаться при осмотре и сканировании здоровья. Не злоупотребляйте этим:", "Character Preference", custom_species) as null|text, TRUE)
					if(new_species)
						custom_species = new_species
					else
						custom_species = null

				if("mutant_color")
					var/new_mutantcolor = input(user, "Choose your character's alien/mutant color:", "Character Preference","#"+features["mcolor"]) as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000" && features["mcolor"] != pref_species.default_color) //SPLURT EDIT
							features["mcolor"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) // mutantcolors must be bright, but only if they affect the skin //SPLURT EDIT
							features["mcolor"] = sanitize_hexcolor(new_mutantcolor, 6)
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("mutant_color2")
					var/new_mutantcolor = input(user, "Choose your character's secondary alien/mutant color:", "Character Preference","#"+features["mcolor2"]) as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000" && features["mcolor2"] != pref_species.default_color) //SPLURT EDIT
							features["mcolor2"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) // mutantcolors must be bright, but only if they affect the skin //SPLURT EDIT
							features["mcolor2"] = sanitize_hexcolor(new_mutantcolor, 6)
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("mutant_color3")
					var/new_mutantcolor = input(user, "Choose your character's tertiary alien/mutant color:", "Character Preference","#"+features["mcolor3"]) as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000" && features["mcolor3"] != pref_species.default_color) //SPLURT EDIT
							features["mcolor3"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) // mutantcolors must be bright, but only if they affect the skin //SPLURT EDIT
							features["mcolor3"] = sanitize_hexcolor(new_mutantcolor, 6)
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("mismatched_markings")
					show_mismatched_markings = !show_mismatched_markings

				if("puddle_slime_task")
					features["puddle_slime_fea"] = !features["puddle_slime_fea"]

				if("has_neckfire")
					features["neckfire"] = !features["neckfire"]
				if("has_neckfire_color")
					var/new_neckfire_color = input(user, "Choose your fire's color:", "Character Preference", "#"+features["neckfire_color"]) as color|null
					if(new_neckfire_color)
						var/temp_hsv = RGBtoHSV(new_neckfire_color)
						if(new_neckfire_color == "#000000" && features["neckfire_color"] != pref_species.default_color) //SPLURT EDIT
							features["neckfire_color"] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) //SPLURT EDIT
							features["neckfire_color"] = sanitize_hexcolor(new_neckfire_color, 6)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("ipc_screen")
					var/new_ipc_screen
					new_ipc_screen = tgui_input_list(user, "Choose your character's screen:", "Character Preference", GLOB.ipc_screens_list)
					if(new_ipc_screen)
						features["ipc_screen"] = new_ipc_screen

				if("ipc_antenna")
					var/list/snowflake_antenna_list = list()
					//Potential todo: turn all of THIS into a define to reduce copypasta.
					for(var/path in GLOB.ipc_antennas_list)
						var/datum/sprite_accessory/antenna/instance = GLOB.ipc_antennas_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_antenna_list[S.name] = path
					var/new_ipc_antenna
					new_ipc_antenna = tgui_input_list(user, "Choose your character's antenna:", "Character Preference", snowflake_antenna_list)
					if(new_ipc_antenna)
						features["ipc_antenna"] = new_ipc_antenna

				if("arachnid_legs")
					var/new_arachnid_legs
					new_arachnid_legs = tgui_input_list(user, "Choose your character's variant of arachnid legs:", "Character Preference", GLOB.arachnid_legs_list)
					if(new_arachnid_legs)
						features["arachnid_legs"] = new_arachnid_legs

				if("arachnid_spinneret")
					var/new_arachnid_spinneret
					new_arachnid_spinneret = tgui_input_list(user, "Choose your character's spinneret markings:", "Character Preference", GLOB.arachnid_spinneret_list)
					if(new_arachnid_spinneret)
						features["arachnid_spinneret"] = new_arachnid_spinneret

				if("arachnid_mandibles")
					var/new_arachnid_mandibles
					new_arachnid_mandibles = tgui_input_list(user, "Choose your character's variant of mandibles:", "Character Preference", GLOB.arachnid_mandibles_list)
					if (new_arachnid_mandibles)
						features["arachnid_mandibles"] = new_arachnid_mandibles

				if("tail_lizard")
					var/new_tail
					new_tail = tgui_input_list(user, "Choose your character's tail:", "Character Preference", GLOB.tails_list_lizard)
					if(new_tail)
						features["tail_lizard"] = new_tail
						if(new_tail != "None")
							features["taur"] = "None"
							features["tail_human"] = "None"
							features["mam_tail"] = "None"

				if("tail_human")
					var/list/snowflake_tails_list = list()
					for(var/path in GLOB.tails_list_human)
						var/datum/sprite_accessory/tails/human/instance = GLOB.tails_list_human[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_tails_list[S.name] = path
					var/new_tail
					new_tail = tgui_input_list(user, "Choose your character's tail:", "Character Preference", snowflake_tails_list)
					if(new_tail)
						features["tail_human"] = new_tail
						if(new_tail != "None")
							features["taur"] = "None"
							features["tail_lizard"] = "None"
							features["mam_tail"] = "None"

				if("mam_tail")
					var/list/snowflake_tails_list = list()
					for(var/path in GLOB.mam_tails_list)
						var/datum/sprite_accessory/tails/mam_tails/instance = GLOB.mam_tails_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_tails_list[S.name] = path
					var/new_tail
					new_tail = tgui_input_list(user, "Choose your character's tail:", "Character Preference", snowflake_tails_list)
					if(new_tail)
						features["mam_tail"] = new_tail
						if(new_tail != "None")
							features["taur"] = "None"
							features["tail_human"] = "None"
							features["tail_lizard"] = "None"

				if("meat_type")
					var/new_meat
					new_meat = tgui_input_list(user, "Choose your character's meat type:", "Character Preference", GLOB.meat_types)
					if(new_meat)
						features["meat_type"] = new_meat

				if("snout")
					var/list/snowflake_snouts_list = list()
					for(var/path in GLOB.snouts_list)
						var/datum/sprite_accessory/snouts/mam_snouts/instance = GLOB.snouts_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_snouts_list[S.name] = path
					var/new_snout
					new_snout = tgui_input_list(user, "Choose your character's snout:", "Character Preference", snowflake_snouts_list)
					if(new_snout)
						features["snout"] = new_snout
						features["mam_snouts"] = "None"


				if("mam_snouts")
					var/list/snowflake_mam_snouts_list = list()
					for(var/path in GLOB.mam_snouts_list)
						var/datum/sprite_accessory/snouts/mam_snouts/instance = GLOB.mam_snouts_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_mam_snouts_list[S.name] = path
					var/new_mam_snouts
					new_mam_snouts = tgui_input_list(user, "Choose your character's snout:", "Character Preference", snowflake_mam_snouts_list)
					if(new_mam_snouts)
						features["mam_snouts"] = new_mam_snouts
						features["snout"] = "None"

				if("horns")
					var/new_horns
					new_horns = tgui_input_list(user, "Choose your character's horns:", "Character Preference", GLOB.horns_list)
					if(new_horns)
						features["horns"] = new_horns

				if("horns_color")
					var/new_horn_color = input(user, "Choose your character's horn colour:", "Character Preference","#"+features["horns_color"]) as color|null
					if(new_horn_color)
						if (new_horn_color == "#000000" && features["horns_color"] != "85615A") //SPLURT EDIT
							features["horns_color"] = "85615A"
						else
							features["horns_color"] = sanitize_hexcolor(new_horn_color, 6)

				if("wings")
					var/new_wings
					new_wings = tgui_input_list(user, "Choose your character's wings:", "Character Preference", GLOB.r_wings_list)
					if(new_wings)
						features["wings"] = new_wings

				if("wings_color")
					var/new_wing_color = input(user, "Choose your character's wing colour:", "Character Preference","#"+features["wings_color"]) as color|null
					if(new_wing_color)
						if (new_wing_color == "#000000" && features["wings_color"] != "#FFFFFF") //SPLURT EDIT
							features["wings_color"] = "#FFFFFF"
						else
							features["wings_color"] = sanitize_hexcolor(new_wing_color, 6)

				if("frills")
					var/new_frills
					new_frills = tgui_input_list(user, "Choose your character's frills:", "Character Preference", GLOB.frills_list)
					if(new_frills)
						features["frills"] = new_frills

				if("spines")
					var/new_spines
					new_spines = tgui_input_list(user, "Choose your character's spines:", "Character Preference", GLOB.spines_list)
					if(new_spines)
						features["spines"] = new_spines

				if("legs")
					var/new_legs
					new_legs = tgui_input_list(user, "Choose your character's legs:", "Character Preference", GLOB.legs_list)
					if(new_legs)
						features["legs"] = new_legs

				if("insect_wings")
					var/new_insect_wings
					new_insect_wings = tgui_input_list(user, "Choose your character's wings:", "Character Preference", GLOB.insect_wings_list)
					if(new_insect_wings)
						features["insect_wings"] = new_insect_wings

				if("deco_wings")
					var/new_deco_wings
					new_deco_wings = tgui_input_list(user, "Choose your character's wings:", "Character Preference", GLOB.deco_wings_list)
					if(new_deco_wings)
						features["deco_wings"] = new_deco_wings

				if("insect_fluff")
					var/new_insect_fluff
					new_insect_fluff = tgui_input_list(user, "Choose your character's wings:", "Character Preference", GLOB.insect_fluffs_list)
					if(new_insect_fluff)
						features["insect_fluff"] = new_insect_fluff

				if("insect_markings")
					var/new_insect_markings
					new_insect_markings = tgui_input_list(user, "Choose your character's markings:", "Character Preference", GLOB.insect_markings_list)
					if(new_insect_markings)
						features["insect_markings"] = new_insect_markings

				if("arachnid_legs")
					var/new_arachnid_legs
					new_arachnid_legs = tgui_input_list(user, "Choose your character's variant of arachnid legs:", "Character Preference", GLOB.arachnid_legs_list)
					if(new_arachnid_legs)
						features["arachnid_legs"] = new_arachnid_legs

				if("arachnid_spinneret")
					var/new_arachnid_spinneret
					new_arachnid_spinneret = tgui_input_list(user, "Choose your character's spinneret markings:", "Character Preference", GLOB.arachnid_spinneret_list)
					if(new_arachnid_spinneret)
						features["arachnid_spinneret"] = new_arachnid_spinneret

				if("arachnid_mandibles")
					var/new_arachnid_mandibles
					new_arachnid_mandibles = tgui_input_list(user, "Choose your character's variant of mandibles:", "Character Preference", GLOB.arachnid_mandibles_list)
					if (new_arachnid_mandibles)
						features["arachnid_mandibles"] = new_arachnid_mandibles

				if("s_tone")
					var/list/choices = GLOB.skin_tones - GLOB.nonstandard_skin_tones
					if(CONFIG_GET(flag/allow_custom_skintones))
						choices += "custom"
					var/new_s_tone = tgui_input_list(user, "Choose your character's skin tone:", "Character Preference", choices)
					if(new_s_tone)
						if(new_s_tone == "custom")
							var/default = use_custom_skin_tone ? skin_tone : null
							var/custom_tone = input(user, "Choose your custom skin tone:", "Character Preference", default) as color|null
							if(custom_tone)
								var/temp_hsv = RGBtoHSV(custom_tone)
								if(ReadHSV(temp_hsv)[3] < ReadHSV("#333333")[3] && CONFIG_GET(flag/character_color_limits)) // rgb(50,50,50) //SPLURT EDIT
									to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")
								else
									use_custom_skin_tone = TRUE
									skin_tone = custom_tone
						else
							use_custom_skin_tone = FALSE
							skin_tone = new_s_tone

				if("taur")
					var/list/snowflake_taur_list = list()
					for(var/path in GLOB.taur_list)
						var/datum/sprite_accessory/taur/instance = GLOB.taur_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if(S.ignore)
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_taur_list[S.name] = path
					var/new_taur
					new_taur = tgui_input_list(user, "Choose your character's tauric body:", "Character Preference", snowflake_taur_list)
					if(new_taur)
						features["taur"] = new_taur
						if(new_taur != "None")
							features["mam_tail"] = "None"
							features["xenotail"] = "None"
							features["tail_human"] = "None"
							features["tail_lizard"] = "None"
							features["arachnid_spinneret"] = "None"

				if("ears")
					var/list/snowflake_ears_list = list()
					for(var/path in GLOB.ears_list)
						var/datum/sprite_accessory/ears/instance = GLOB.ears_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_ears_list[S.name] = path
					var/new_ears
					new_ears = tgui_input_list(user, "Choose your character's ears:", "Character Preference", snowflake_ears_list)
					if(new_ears)
						features["ears"] = new_ears

				if("mam_ears")
					var/list/snowflake_ears_list = list()
					for(var/path in GLOB.mam_ears_list)
						var/datum/sprite_accessory/ears/mam_ears/instance = GLOB.mam_ears_list[path]
						if(istype(instance, /datum/sprite_accessory))
							var/datum/sprite_accessory/S = instance
							if(!show_mismatched_markings && S.recommended_species && !S.recommended_species.Find(pref_species.id))
								continue
							if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
								snowflake_ears_list[S.name] = path
					var/new_ears
					new_ears = tgui_input_list(user, "Choose your character's ears:", "Character Preference", snowflake_ears_list)
					if(new_ears)
						features["mam_ears"] = new_ears

				//Xeno Bodyparts
				if("xenohead")//Head or caste type
					var/new_head
					new_head = tgui_input_list(user, "Choose your character's caste:", "Character Preference", GLOB.xeno_head_list)
					if(new_head)
						features["xenohead"] = new_head

				if("xenotail")//Currently one one type, more maybe later if someone sprites them. Might include animated variants in the future.
					var/new_tail
					new_tail = tgui_input_list(user, "Choose your character's tail:", "Character Preference", GLOB.xeno_tail_list)
					if(new_tail)
						features["xenotail"] = new_tail
						if(new_tail != "None")
							features["mam_tail"] = "None"
							features["taur"] = "None"
							features["tail_human"] = "None"
							features["tail_lizard"] = "None"

				if("xenodorsal")
					var/new_dors
					new_dors = tgui_input_list(user, "Choose your character's dorsal tube type:", "Character Preference", GLOB.xeno_dorsal_list)
					if(new_dors)
						features["xenodorsal"] = new_dors

				//every single primary/secondary/tertiary colouring done at once
				if("xenodorsal_primary","xenodorsal_secondary","xenodorsal_tertiary","xhead_primary","xhead_secondary","xhead_tertiary","tail_primary","tail_secondary","tail_tertiary","insect_markings_primary","insect_markings_secondary","insect_markings_tertiary","insect_fluff_primary","insect_fluff_secondary","insect_fluff_tertiary","ears_primary","ears_secondary","ears_tertiary","frills_primary","frills_secondary","frills_tertiary","ipc_antenna_primary","ipc_antenna_secondary","ipc_antenna_tertiary","taur_primary","taur_secondary","taur_tertiary","snout_primary","snout_secondary","snout_tertiary","spines_primary","spines_secondary","spines_tertiary", "mam_body_markings_primary", "mam_body_markings_secondary", "mam_body_markings_tertiary")
					var/the_feature = features[href_list["preference"]]
					if(!the_feature)
						features[href_list["preference"]] = "FFFFFF"
						the_feature = "FFFFFF"
					var/new_feature_color = input(user, "Choose your character's mutant part colour:", "Character Preference","#"+features[href_list["preference"]]) as color|null
					if(new_feature_color)
						var/temp_hsv = RGBtoHSV(new_feature_color)
						if(new_feature_color == "#000000" && features[href_list["preference"]] != pref_species.default_color) //SPLURT EDIT
							features[href_list["preference"]] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) //SPLURT EDIT
							features[href_list["preference"]] = sanitize_hexcolor(new_feature_color, 6)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")


				//advanced color mode toggle
				if("color_scheme")
					if(features["color_scheme"] == ADVANCED_CHARACTER_COLORING)
						features["color_scheme"] = OLD_CHARACTER_COLORING
					else
						features["color_scheme"] = ADVANCED_CHARACTER_COLORING

				//Genital code
				if("lust_tolerance")
					var/lust_tol = input(user, "Set how long you can last without climaxing. \n(25 = minimum, 200 = maximum.)", "Character Preference", lust_tolerance) as num|null
					if(lust_tol)
						lust_tolerance = clamp(lust_tol, 25, 200)
				if("sexual_potency")
					var/sexual_pot = input(user, "Set your sexual potency. \n(-1 = minimum, 25 = maximum.) This determines the number of times your character can orgasm before becoming impotent, use -1 for no impotency.", "Character Preference", sexual_potency) as num|null
					if(sexual_pot)
						sexual_potency = clamp(sexual_pot, -1, 25)

				if("cock_color")
					var/new_cockcolor = input(user, "Penis color:", "Character Preference","#"+features["cock_color"]) as color|null
					if(new_cockcolor)
						var/temp_hsv = RGBtoHSV(new_cockcolor)
						if(new_cockcolor == "#000000" && features["cock_color"] != pref_species.default_color) //SPLURT EDIT
							features["cock_color"] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) //SPLURT EDIT
							features["cock_color"] = sanitize_hexcolor(new_cockcolor, 6)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("cock_length")
					var/min_D = CONFIG_GET(number/penis_min_inches_prefs)
					var/max_D = CONFIG_GET(number/penis_max_inches_prefs)
					var/new_length = input(user, "Penis length in centimeters:\n([min_D]-[max_D])\nReminder that your sprite size will affect this.", "Character Preference") as num|null
					if(new_length)
						features["cock_length"] = clamp(round(new_length), min_D, max_D)

				if("cock_shape")
					var/new_shape
					var/list/hockeys = list()
					if(parent.can_have_part("taur"))
						var/datum/sprite_accessory/taur/T = GLOB.taur_list[features["taur"]]
						for(var/A in GLOB.cock_shapes_list)
							var/datum/sprite_accessory/penis/P = GLOB.cock_shapes_list[A]
							if(P.taur_icon && T.taur_mode & P.accepted_taurs)
								LAZYSET(hockeys, "[A] (Taur)", A)
					new_shape = tgui_input_list(user, "Penis shape:", "Character Preference", (GLOB.cock_shapes_list + hockeys))
					if(new_shape)
						features["cock_taur"] = FALSE
						if(hockeys[new_shape])
							new_shape = hockeys[new_shape]
							features["cock_taur"] = TRUE
						features["cock_shape"] = new_shape

				if("cock_diameter_ratio")
					var/min_diameter_ratio = CONFIG_GET(number/diameter_ratio_min_size_prefs)
					var/max_diameter_ratio = CONFIG_GET(number/diameter_ratio_max_size_prefs)
					var/new_ratio = input(user, "Penis diameter ratio:\n([min_diameter_ratio]-[max_diameter_ratio])\nReminder that your sprite size will affect this.", "Character Preference") as num|null
					if(new_ratio)
						features["cock_diameter_ratio"] = clamp(round(new_ratio, 0.01), min_diameter_ratio, max_diameter_ratio)

				if("cock_visibility")
					var/n_vis = tgui_input_list(user, "Penis Visibility", "Character Preference", CONFIG_GET(str_list/safe_visibility_toggles))
					if(n_vis)
						features["cock_visibility"] = n_vis

				if("balls_color")
					var/new_ballscolor = input(user, "Testicles Color:", "Character Preference","#"+features["balls_color"]) as color|null
					if(new_ballscolor)
						var/temp_hsv = RGBtoHSV(new_ballscolor)
						if(new_ballscolor == "#000000" && features["balls_color"] != pref_species.default_color) //SPLURT EDIT
							features["balls_color"] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) //SPLURT EDIT
							features["balls_color"] = sanitize_hexcolor(new_ballscolor, 6)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("balls_shape")
					var/new_shape
					new_shape = tgui_input_list(user, "Testicle Shape", "Character Preference", GLOB.balls_shapes_list)
					if(new_shape)
						features["balls_shape"] = new_shape

				if("balls_visibility")
					var/n_vis = tgui_input_list(user, "Testicles Visibility", "Character Preference", CONFIG_GET(str_list/safe_visibility_toggles))
					if(n_vis)
						features["balls_visibility"] = n_vis

				if("balls_fluid")
					var/datum/reagent/new_fluid
					var/list/full_options = list()
					LAZYADD(full_options, GLOB.genital_fluids_list)
					LAZYREMOVE(full_options, find_reagent_object_from_type(/datum/reagent/consumable/semen))
					full_options = list(find_reagent_object_from_type(/datum/reagent/consumable/semen)) + full_options
					new_fluid = tgui_input_list(user, "Balls Fluid", "Character Preference", full_options)
					if(new_fluid)
						features["balls_fluid"] = new_fluid.type

				if("breasts_size")
					var/new_size = tgui_input_list(user, "Breast Size", "Character Preference", CONFIG_GET(keyed_list/breasts_cups_prefs))
					if(new_size)
						features["breasts_size"] = new_size

				if("breasts_shape")
					var/new_shape
					new_shape = tgui_input_list(user, "Breast Shape", "Character Preference", GLOB.breasts_shapes_list)
					if(new_shape)
						features["breasts_shape"] = new_shape

				if("breasts_color")
					var/new_breasts_color = input(user, "Breast Color:", "Character Preference","#"+features["breasts_color"]) as color|null
					if(new_breasts_color)
						var/temp_hsv = RGBtoHSV(new_breasts_color)
						if(new_breasts_color == "#000000" && features["breasts_color"] != pref_species.default_color) //SPLURT EDIT
							features["breasts_color"] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) //SPLURT EDIT
							features["breasts_color"] = sanitize_hexcolor(new_breasts_color, 6)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("breasts_visibility")
					var/n_vis = tgui_input_list(user, "Breasts Visibility", "Character Preference", CONFIG_GET(str_list/safe_visibility_toggles))
					if(n_vis)
						features["breasts_visibility"] = n_vis

				if("breasts_fluid")
					var/datum/reagent/new_fluid
					var/list/full_options = list()
					LAZYADD(full_options, GLOB.genital_fluids_list)
					LAZYREMOVE(full_options, find_reagent_object_from_type(/datum/reagent/consumable/milk))
					full_options = list(find_reagent_object_from_type(/datum/reagent/consumable/milk)) + full_options
					new_fluid = tgui_input_list(user, "Breast Fluid", "Character Preference", full_options)
					if(new_fluid)
						features["breasts_fluid"] = new_fluid.type

				if("vag_shape")
					var/new_shape
					new_shape = tgui_input_list(user, "Vagina Type", "Character Preference", GLOB.vagina_shapes_list)
					if(new_shape)
						features["vag_shape"] = new_shape

				if("vag_color")
					var/new_vagcolor = input(user, "Vagina color:", "Character Preference","#"+features["vag_color"]) as color|null
					if(new_vagcolor)
						var/temp_hsv = RGBtoHSV(new_vagcolor)
						if(new_vagcolor == "#000000" && features["vag_color"] != pref_species.default_color) //SPLURT EDIT
							features["vag_color"] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) //SPLURT EDIT
							features["vag_color"] = sanitize_hexcolor(new_vagcolor, 6)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("vag_visibility")
					var/n_vis = tgui_input_list(user, "Vagina Visibility", "Character Preference", CONFIG_GET(str_list/safe_visibility_toggles))
					if(n_vis)
						features["vag_visibility"] = n_vis

				if("womb_fluid")
					var/datum/reagent/new_fluid
					var/list/full_options = list()
					LAZYADD(full_options, GLOB.genital_fluids_list)
					LAZYREMOVE(full_options, find_reagent_object_from_type(/datum/reagent/consumable/semen/femcum))
					full_options = list(find_reagent_object_from_type(/datum/reagent/consumable/semen/femcum)) + full_options
					new_fluid = tgui_input_list(user, "Womb Fluid", "Character Preference", full_options)
					if(new_fluid)
						features["womb_fluid"] = new_fluid.type

				if("belly_color")
					var/new_bellycolor = input(user, "Belly Color:", "Character Preference", "#"+features["belly_color"]) as color|null
					if(new_bellycolor)
						var/temp_hsv = RGBtoHSV(new_bellycolor)
						if(new_bellycolor == "#000000" && features["belly_color"] != pref_species.default_color) //SPLURT EDIT
							features["belly_color"] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) //SPLURT EDIT
							features["belly_color"] = sanitize_hexcolor(new_bellycolor, 6)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("butt_color")
					var/new_buttcolor = input(user, "Butt color:", "Character Preference","#"+features["butt_color"]) as color|null
					if(new_buttcolor)
						var/temp_hsv = RGBtoHSV(new_buttcolor)
						if(new_buttcolor == "#000000" && features["butt_color"] != pref_species.default_color) //SPLURT EDIT
							features["butt_color"] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) //SPLURT EDIT
							features["butt_color"] = sanitize_hexcolor(new_buttcolor, 6)
						else
							to_chat(user,"<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("anus_color")
					var/new_anuscolor = input(user, "Butthole color:", "Character Preference", "#"+features["anus_color"]) as color|null
					if(new_anuscolor)
						var/temp_hsv = RGBtoHSV(new_anuscolor)
						if(new_anuscolor == "#000000" && features["anus_color"] != pref_species.default_color) //SPLURT EDIT
							features["anus_color"] = pref_species.default_color
						else if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) //SPLURT EDIT
							features["anus_color"] = sanitize_hexcolor(new_anuscolor, 6)
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("anus_shape")
					var/new_shape
					new_shape = tgui_input_list(user, "Butthole Shape", "Character Preference", GLOB.anus_shapes_list)
					if(new_shape)
						features["anus_shape"] = new_shape

				if("belly_size")
					var/min_belly = CONFIG_GET(number/belly_min_size_prefs)
					var/max_belly = CONFIG_GET(number/belly_max_size_prefs)
					var/new_bellysize = input(user, "Belly size :\n([min_belly]-[max_belly])", "Character Preference") as num|null
					if(!isnull(new_bellysize))
						features["belly_size"] = clamp(new_bellysize, min_belly, max_belly)

				if("butt_size")
					var/min_B = CONFIG_GET(number/butt_min_size_prefs)
					var/max_B = CONFIG_GET(number/butt_max_size_prefs)
					var/new_length = input(user, "Butt size:\n([min_B]-[max_B])", "Character Preference") as num|null
					if(new_length)
						features["butt_size"] = clamp(round(new_length), min_B, max_B)

				if("butt_visibility")
					var/n_vis = tgui_input_list(user, "Butt Visibility", "Character Preference", CONFIG_GET(str_list/safe_visibility_toggles))
					if(n_vis)
						features["butt_visibility"] = n_vis

				if("anus_visibility")
					var/n_vis = tgui_input_list(user, "Butthole Visibility", "Character Preference", CONFIG_GET(str_list/safe_visibility_toggles))
					if(n_vis)
						features["anus_visibility"] = n_vis

				if("belly_visibility")
					var/n_vis = tgui_input_list(user, "Belly Visibility", "Character Preference", CONFIG_GET(str_list/safe_visibility_toggles))
					if(n_vis)
						features["belly_visibility"] = n_vis

				if("cock_max_length")
					var/max_B = CONFIG_GET(number/penis_max_inches_prefs)
					var/new_size = input(user, "Max size:\n([features["cock_length"]]-[max_B])(0 = disabled)", "Character Preference") as num|null
					if(new_size)
						features["cock_max_length"] = clamp(round(new_size), features["cock_length"], max_B)
					else
						features -= "cock_max_length"

				if("balls_max_size")
					var/new_size = input(user, "Max size:\n([BALLS_SIZE_MIN]-[BALLS_SIZE_MAX])(0 = disabled)", "Character Preference") as num|null
					if(new_size)
						features["balls_max_size"] = clamp(round(new_size), BALLS_SIZE_MIN, BALLS_SIZE_MAX)
					else
						features -= "balls_max_size"

				if("breasts_max_size")
					var/new_size = tgui_input_list(user, "Breast Max Size (cancel to disable)", "Character Preference", GLOB.breast_values)
					if(new_size)
						features["breasts_max_size"] = new_size
					else
						features -= "breasts_max_size"

				if("belly_max_size")
					var/max_B = CONFIG_GET(number/belly_max_size_prefs)
					var/new_size = input(user, "Max size:\n([features["belly_size"]]-[max_B])(0 = disabled)", "Character Preference") as num|null
					if(new_size)
						features["belly_max_size"] = clamp(round(new_size), features["belly_size"], max_B)
					else
						features -= "belly_max_size"

				if("butt_max_size")
					var/max_B = CONFIG_GET(number/butt_max_size_prefs)
					var/new_size = input(user, "Max size:\n([features["butt_size"]]-[max_B])(0 = disabled)", "Character Preference") as num|null
					if(new_size)
						features["butt_max_size"] = clamp(round(new_size), features["butt_size"], max_B)
					else
						features -= "butt_max_size"

				if("cock_min_length")
					var/min_B = CONFIG_GET(number/penis_min_inches_prefs)
					var/new_size = input(user, "Min size:\n([min_B]-[features["cock_length"]])(0 = disabled)", "Character Preference") as num|null
					if(new_size)
						features["cock_min_length"] = clamp(round(new_size), min_B, features["cock_length"])
					else
						features -= "cock_min_length"

				if("balls_min_size")
					var/new_size = input(user, "Min size:\n([BALLS_SIZE_MIN]-[BALLS_SIZE_MAX])(0 = disabled)", "Character Preference") as num|null
					if(new_size)
						features["balls_min_size"] = clamp(round(new_size), BALLS_SIZE_MIN, BALLS_SIZE_MAX)
					else
						features -= "balls_min_size"

				if("breasts_min_size")
					var/new_size = tgui_input_list(user, "Breast Min Size (cancel to disable)", "Character Preference", GLOB.breast_values)
					if(new_size)
						features["breasts_min_size"] = new_size
					else
						features -= "breasts_min_size"

				if("belly_min_size")
					var/min_B = CONFIG_GET(number/belly_min_size_prefs)
					var/new_size = input(user, "Min size:\n([min_B]-[features["belly_size"]])(0 = disabled)", "Character Preference") as num|null
					if(new_size)
						features["belly_min_size"] = clamp(round(new_size), min_B, features["belly_size"])
					else
						features -= "belly_min_size"

				if("butt_min_size")
					var/min_B = CONFIG_GET(number/butt_min_size_prefs)
					var/new_size = input(user, "Min size:\n([min_B]-[features["butt_size"]])(0 = disabled)", "Character Preference") as num|null
					if(new_size)
						features["butt_min_size"] = clamp(round(new_size), min_B, features["butt_size"])
					else
						features -= "butt_min_size"

				if("ooccolor")
					var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference",ooccolor) as color|null
					if(new_ooccolor)
						ooccolor = sanitize_ooccolor(new_ooccolor)

				if("aooccolor")
					var/new_aooccolor = input(user, "Choose your Antag OOC colour:", "Game Preference",ooccolor) as color|null
					if(new_aooccolor)
						aooccolor = sanitize_ooccolor(new_aooccolor)

				if("bag")
					var/new_backbag = tgui_input_list(user, "Choose your character's style of bag:", "Character Preference", GLOB.backbaglist)
					if(new_backbag)
						backbag = new_backbag

				if("suit")
					if(jumpsuit_style == PREF_SUIT)
						jumpsuit_style = PREF_SKIRT
					else
						jumpsuit_style = PREF_SUIT


				if("uplink_loc")
					var/new_loc = tgui_input_list(user, "Choose your character's traitor uplink spawn location:", "Character Preference", GLOB.uplink_spawn_loc_list)
					if(new_loc)
						uplink_spawn_loc = new_loc

				if("ai_core_icon")
					var/ai_core_icon = tgui_input_list(user, "Выберите предпочитаемый вами экран отображения ядра ИИ:", "Экран ИИ", GLOB.ai_core_display_screens)
					if(ai_core_icon)
						preferred_ai_core_display = ai_core_icon

				if("sec_dept")
					var/department = tgui_input_list(user, "Выберите предпочитаемый вами отдел:", "Предпочитаемые отделы", GLOB.security_depts_prefs)
					if(department)
						prefered_security_department = department

				if ("preferred_map")
					var/maplist = list()
					var/default = "Default"
					if (config.defaultmap)
						default += " ([config.defaultmap.map_name])"
					for (var/M in config.maplist)
						var/datum/map_config/VM = config.maplist[M]
						var/friendlyname = "[VM.map_name] "
						if (VM.voteweight <= 0)
							friendlyname += " (disabled)"
						maplist[friendlyname] = VM.map_name
					maplist[default] = null
					var/pickedmap = tgui_input_list(user, "Choose your preferred map. This will be used to help weight random map selection.", "Character Preference", maplist)
					if (pickedmap)
						preferred_map = maplist[pickedmap]

				if ("preferred_chaos")
					var/pickedchaos = tgui_input_list(user, "Choose your preferred level of chaos. This will help with dynamic threat level ratings.", "Character Preference", list(CHAOS_NONE,CHAOS_LOW,CHAOS_MED,CHAOS_HIGH,CHAOS_MAX))
					preferred_chaos = pickedchaos
				if ("be_victim")
					var/pickedvictim = tgui_input_list(user, "Are you ok with antagonists interacting with you (e.g. kidnapping)? ERP consent is seperate: This setting does NOT mean they are allowed to rape you.", "Antag Victim Consent", list(BEVICTIM_NO,BEVICTIM_ASK,BEVICTIM_YES))
					be_victim = pickedvictim
				if ("clientfps")
					var/desiredfps = input(user, "Choose your desired fps. (0 = synced with server tick rate (currently:[world.fps]))", "Character Preference", clientfps)  as null|num
					if (!isnull(desiredfps))
						clientfps = desiredfps
						parent.fps = desiredfps
				if("ui")
					var/pickedui = tgui_input_list(user, "Choose your UI style.", "Character Preference", GLOB.available_ui_styles, UI_style)
					if(pickedui)
						UI_style = pickedui
						if (pickedui && parent && parent.mob && parent.mob.hud_used)
							QDEL_NULL(parent.mob.hud_used)
							parent.mob.create_mob_hud()
							parent.mob.hud_used.show_hud(1, parent.mob)
				if("toggle_custom_blood_color")
					custom_blood_color = !custom_blood_color
				if("blood_color")
					var/pickedBloodColor = input(user, "Выбирайте цвет крови своего персонажа.", "Character Preference", blood_color) as color|null
					if(!pickedBloodColor)
						return
					if(pickedBloodColor)
						blood_color = sanitize_hexcolor(pickedBloodColor, 6, 1, initial(blood_color))
						if(!custom_blood_color)
							custom_blood_color = TRUE
				///
				if("pda_style")
					var/pickedPDAStyle = tgui_input_list(user, "Выбирайте стиль своего КПК.", "Character Preference", GLOB.pda_styles, pda_style)
					if(pickedPDAStyle)
						pda_style = pickedPDAStyle
				if("pda_color")
					var/pickedPDAColor = input(user, "Выбирайте цвет интерфейса своего КПК.", "Character Preference", pda_color) as color|null
					if(pickedPDAColor)
						pda_color = pickedPDAColor
				if("pda_skin")
					var/pickedPDASkin = tgui_input_list(user, "Выбирайте модель своего КПК.", "Character Preference", GLOB.pda_reskins, pda_skin)
					if(pickedPDASkin)
						pda_skin = pickedPDASkin
				if("pda_ringtone")
					var/pickedPDARingtone = reject_bad_name(input(user, "Выбирайте рингтон своего КПК.", "Character Preference", pda_ringtone) as null|text, TRUE)
					if(pickedPDARingtone)
						pda_ringtone = pickedPDARingtone
				if("silicon_lawset")
					var/picked_lawset = tgui_input_list(user, "Выбирайте предпочитаемый список законов", "Silicon preference", list("None") + CONFIG_GET(keyed_list/choosable_laws), silicon_lawset)
					if(picked_lawset)
						if(picked_lawset == "None")
							picked_lawset = null
						silicon_lawset = picked_lawset
				if ("max_chat_length")
					var/desiredlength = input(user, "Choose the max character length of shown Runechat messages. Valid range is 1 to [CHAT_MESSAGE_MAX_LENGTH] (default: [initial(max_chat_length)]))", "Character Preference", max_chat_length)  as null|num
					if (!isnull(desiredlength))
						max_chat_length = clamp(desiredlength, 1, CHAT_MESSAGE_MAX_LENGTH)

				//Sandstorm changes begin
				if("personal_chat_color")
					var/new_chat_color = input(user, "Choose your character's runechat color:", "Character Preference",personal_chat_color) as color|null
					if(new_chat_color)
						if(color_hex2num(new_chat_color) > 200)
							personal_chat_color = sanitize_hexcolor(new_chat_color, 6, TRUE)
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")
				//End of sandstorm changes

				if("hud_toggle_color")
					var/new_toggle_color = input(user, "Choose your HUD toggle flash color:", "Game Preference",hud_toggle_color) as color|null
					if(new_toggle_color)
						hud_toggle_color = new_toggle_color

				if("gender")
					var/chosengender = tgui_input_list(user, "Select your character's gender.", "Gender Selection", list(MALE,FEMALE,"nonbinary","object"), gender)
					if(!chosengender)
						return
					switch(chosengender)
						if("nonbinary")
							chosengender = PLURAL
							features["body_model"] = pick(MALE, FEMALE)
						if("object")
							chosengender = NEUTER
							features["body_model"] = MALE
						else
							features["body_model"] = chosengender
					gender = chosengender

				if("body_size")
					var/new_body_size = input(user, "Choose your desired sprite size: ([CONFIG_GET(number/body_size_min)*100]-[CONFIG_GET(number/body_size_max)*100]%)\nWarning: This may make your character look distorted. Additionally, any size affects speed and max health", "Character Preference", features["body_size"]*100) as num|null
					if(new_body_size)
						features["body_size"] = clamp(new_body_size * 0.01, CONFIG_GET(number/body_size_min), CONFIG_GET(number/body_size_max))

				if("toggle_fuzzy")
					fuzzy = !fuzzy

				if("tongue")
					var/selected_custom_tongue = tgui_input_list(user, "Выберите желаемый язык (NONE означает язык вашего вида).", "Предпочтения", GLOB.roundstart_tongues)
					if(selected_custom_tongue)
						custom_tongue = selected_custom_tongue
				if("speech_verb")
					var/selected_custom_speech_verb = tgui_input_list(user, "Выберите желаемый речевой глагол (NONE означает ваш вид речевого глагола)", "Предпочтения", GLOB.speech_verbs)
					if(selected_custom_speech_verb)
						custom_speech_verb = selected_custom_speech_verb

				if("barksound")
					var/list/woof_woof = list()
					for(var/path in GLOB.bark_list)
						var/datum/bark/B = GLOB.bark_list[path]
						if(initial(B.ignore))
							continue
						if(initial(B.ckeys_allowed))
							var/list/allowed = initial(B.ckeys_allowed)
							if(!allowed.Find(user.client.ckey))
								continue
						woof_woof[initial(B.name)] = initial(B.id)
					var/new_bork = tgui_input_list(user, "Выберите желаемый вокальный голос", "Предпочтения", woof_woof)
					if(new_bork)
						bark_id = woof_woof[new_bork]
						var/datum/bark/B = GLOB.bark_list[bark_id] //Now we need sanitization to take into account bark-specific min/max values
						bark_speed = round(clamp(bark_speed, initial(B.minspeed), initial(B.maxspeed)), 1)
						bark_pitch = clamp(bark_pitch, initial(B.minpitch), initial(B.maxpitch))
						bark_variance = clamp(bark_variance, initial(B.minvariance), initial(B.maxvariance))

				if("barkspeed")
					var/datum/bark/B = GLOB.bark_list[bark_id]
					var/borkset = input(user, "Choose your desired bark speed (Higher is slower, lower is faster). Min: [initial(B.minspeed)]. Max: [initial(B.maxspeed)]", "Character Preference") as null|num
					if(!isnull(borkset))
						bark_speed = round(clamp(borkset, initial(B.minspeed), initial(B.maxspeed)), 1)

				if("barkpitch")
					var/datum/bark/B = GLOB.bark_list[bark_id]
					var/borkset = input(user, "Choose your desired baseline bark pitch. Min: [initial(B.minpitch)]. Max: [initial(B.maxpitch)]", "Character Preference") as null|num
					if(!isnull(borkset))
						bark_pitch = clamp(borkset, initial(B.minpitch), initial(B.maxpitch))

				if("barkvary")
					var/datum/bark/B = GLOB.bark_list[bark_id]
					var/borkset = input(user, "Choose your desired baseline bark pitch. Min: [initial(B.minvariance)]. Max: [initial(B.maxvariance)]", "Character Preference") as null|num
					if(!isnull(borkset))
						bark_variance = clamp(borkset, initial(B.minvariance), initial(B.maxvariance))

				if("bodysprite")
					var/selected_body_sprite = tgui_input_list(user, "Choose your desired body sprite", "Character Preference", pref_species.allowed_limb_ids)
					if(selected_body_sprite)
						chosen_limb_id = selected_body_sprite //this gets sanitized before loading

				if("marking_down")
					// move the specified marking down
					var/index = text2num(href_list["marking_index"])
					var/marking_type = href_list["marking_type"]
					if(index && marking_type && features[marking_type] && index != length(features[marking_type]))
						var/index_down = index + 1
						var/markings = features[marking_type]
						var/first_marking = markings[index]
						var/second_marking = markings[index_down]
						markings[index] = second_marking
						markings[index_down] = first_marking

				if("marking_up")
					// move the specified marking up
					var/index = text2num(href_list["marking_index"])
					var/marking_type = href_list["marking_type"]
					if(index && marking_type && features[marking_type] && index != 1)
						var/index_up = index - 1
						var/markings = features[marking_type]
						var/first_marking = markings[index]
						var/second_marking = markings[index_up]
						markings[index] = second_marking
						markings[index_up] = first_marking

				if("marking_remove")
					// move the specified marking up
					var/index = text2num(href_list["marking_index"])
					var/marking_type = href_list["marking_type"]
					if(index && marking_type && features[marking_type])
						// because linters are just absolutely awful:
						var/list/L = features[marking_type]
						L.Cut(index, index + 1)

				if("marking_add")
					// add a marking
					var/marking_type = href_list["marking_type"]
					if(marking_type && features[marking_type])
						var/selected_limb = tgui_input_list(user, "Choose the limb to apply to.", "Character Preference", list("Head", "Chest", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "All"))
						if(selected_limb)
							var/list/marking_list = GLOB.mam_body_markings_list
							var/list/snowflake_markings_list = list()
							for(var/path in marking_list)
								var/datum/sprite_accessory/S = marking_list[path]
								if(istype(S))
									if(istype(S, /datum/sprite_accessory/mam_body_markings))
										var/datum/sprite_accessory/mam_body_markings/marking = S
										if(!(selected_limb in marking.covered_limbs) && selected_limb != "All")
											continue

									if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(user.client.ckey)))
										snowflake_markings_list[S.name] = path
							var/selected_marking = tgui_input_list(user, "Select the marking to apply to the limb.", "Character Preference", snowflake_markings_list)
							if(selected_marking)
								if(selected_limb != "All")
									var/limb_value = text2num(GLOB.bodypart_values[selected_limb])
									features[marking_type] += list(list(limb_value, selected_marking))
								else
									var/datum/sprite_accessory/mam_body_markings/S = marking_list[selected_marking]
									for(var/limb in S.covered_limbs)
										var/limb_value = text2num(GLOB.bodypart_values[limb])
										features[marking_type] += list(list(limb_value, selected_marking))

				// BLUEMOON ADD START - кнопка для удаления всех маркингов на персонаже
				if("markings_remove")
					var/are_you_sure_about_that = tgalert(parent.mob, "Это действие удалит все татуировки с персонажа. Вы уверены, что хотите сделать это?", "Удаление всех маркингов" ,"Да", "Нет")
					if(are_you_sure_about_that == "Да")
						clearlist(features["mam_body_markings"])
				// BLUEMOON ADD END
				if("marking_color_specific")
					var/index = text2num(href_list["marking_index"])
					var/marking_type = href_list["marking_type"]
					var/color_number = text2num(href_list["number_color"])
					if(index && marking_type && color_number && features[marking_type])
						// perform some magic on the color number
						var/list/marking_list = features[marking_type][index]
						var/datum/sprite_accessory/mam_body_markings/S = GLOB.mam_body_markings_list[marking_list[2]]
						var/matrixed_sections = S.covered_limbs[GLOB.bodypart_names[num2text(marking_list[1])]]
						if(color_number == 1)
							switch(matrixed_sections)
								if(MATRIX_GREEN)
									color_number = 2
								if(MATRIX_BLUE)
									color_number = 3
						else if(color_number == 2)
							switch(matrixed_sections)
								if(MATRIX_RED_BLUE)
									color_number = 3
								if(MATRIX_GREEN_BLUE)
									color_number = 3

						var/color_list = features[marking_type][index][3]
						var/new_marking_color = input(user, "Choose your character's marking color:", "Character Preference","#"+color_list[color_number]) as color|null
						if(new_marking_color)
							var/temp_hsv = RGBtoHSV(new_marking_color)
							if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) // mutantcolors must be bright, but only if they affect the skin //SPLURT EDIT
								color_list[color_number] = "#[sanitize_hexcolor(new_marking_color, 6)]"
							else
								to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")
				//SPLURT Edit
				if("gfluid_black")
					var/list/datum/reagent/fluid_list = GLOB.genital_fluids_list.Copy()
					var/list/blacklisted = list()
					for(var/r in gfluid_blacklist)
						LAZYADD(blacklisted, find_reagent_object_from_type(r))
					LAZYREMOVE(fluid_list, GLOB.default_genital_fluids + blacklisted) //these are already blacklisted/are defaults
					var/datum/reagent/selected = tgui_input_list(user, "Blacklist a fluid:", "Genital Fluid Blacklist", fluid_list)
					if(selected)
						LAZYADD(gfluid_blacklist, selected.type)
				if("gfluid_unblack")
					var/list/datum/reagent/fluid_list
					for(var/r in gfluid_blacklist)
						LAZYADD(fluid_list, find_reagent_object_from_type(r))
					if(fluid_list)
						var/datum/reagent/selected = tgui_input_list(user, "Remove a fluid from your blacklist:", "Genital Fluid Blacklist", fluid_list)
						if(selected)
							LAZYREMOVE(gfluid_blacklist, selected.type)
					else
						to_chat(user, span_warning("You do not have blacklisted reagents!"))
				//SPLURT Edit end
		else
			switch(href_list["preference"])
				if("disable_combat_cursor")
					disable_combat_cursor = !disable_combat_cursor
				if("tg_playerpanel")
					toggles ^= TG_PLAYER_PANEL
					to_chat(user, span_warning("Please relog in order to apply the changes"))
					save_preferences()
				//CITADEL PREFERENCES EDIT - I can't figure out how to modularize these, so they have to go here. :c -Pooj
				if("genital_colour")
					features["genitals_use_skintone"] = !features["genitals_use_skintone"]
				if("arousable")
					arousable = !arousable
				if("hardsuit_with_tail")
					features["hardsuit_with_tail"] = !features["hardsuit_with_tail"]
				if("has_cock")
					features["has_cock"] = !features["has_cock"]
					if(features["has_cock"] == FALSE)
						features["has_balls"] = FALSE
				if("cock_accessible")
					features["cock_accessible"] = !features["cock_accessible"]
				if("has_belly")
					features["has_belly"] = !features["has_belly"]
					if(features["has_belly"] == FALSE)
						features["belly_size"] = 1
				if("has_balls")
					features["has_balls"] = !features["has_balls"]
				if("balls_accessible")
					features["balls_accessible"] = !features["balls_accessible"]
				if("has_breasts")
					features["has_breasts"] = !features["has_breasts"]
					if(features["has_breasts"] == FALSE)
						features["breasts_producing"] = FALSE
				if("breasts_producing")
					features["breasts_producing"] = !features["breasts_producing"]
				if("breasts_accessible")
					features["breasts_accessible"] = !features["breasts_accessible"]
				if("has_vag")
					features["has_vag"] = !features["has_vag"]
					if(features["has_vag"] == FALSE)
						features["has_womb"] = FALSE
				if("vag_accessible")
					features["vag_accessible"] = !features["vag_accessible"]
				if("has_womb")
					features["has_womb"] = !features["has_womb"]
				if("has_butt")
					features["has_butt"] = !features["has_butt"]
					if(features["has_butt"] == FALSE)
						features["has_anus"] = FALSE
				if("butt_accessible")
					features["butt_accessible"] = !features["butt_accessible"]
				if("anus_accessible")
					features["anus_accessible"] = !features["anus_accessible"]
				if("has_anus")
					features["has_anus"] = !features["has_anus"]
				if("butt_accessible")
					features["butt_accessible"] = !features["butt_accessible"]
				if("anus_accessible")
					features["anus_accessible"] = !features["anus_accessible"]
				if("belly_accessible")
					features["belly_accessible"] = !features["belly_accessible"]
				if("widescreenpref")
					widescreenpref = !widescreenpref
					user.client.view_size.setDefault(getScreenSize(widescreenpref))
				if("fullscreen")
					fullscreen = !fullscreen
					parent.ToggleFullscreen()
				if("long_strip_menu")
					long_strip_menu = !long_strip_menu
				if("cock_stuffing")
					features["cock_stuffing"] = !features["cock_stuffing"]
				if("balls_stuffing")
					features["balls_stuffing"] = !features["balls_stuffing"]
				if("vag_stuffing")
					features["vag_stuffing"] = !features["vag_stuffing"]
				if("breasts_stuffing")
					features["breasts_stuffing"] = !features["breasts_stuffing"]
				if("butt_stuffing")
					features["butt_stuffing"] = !features["butt_stuffing"]
				if("anus_stuffing")
					features["anus_stuffing"] = !features["anus_stuffing"]
				if("belly_stuffing")
					features["belly_stuffing"] = !features["belly_stuffing"]
				if("inert_eggs")
					features["inert_eggs"] = !features["inert_eggs"]
				if("pixel_size")
					switch(pixel_size)
						if(PIXEL_SCALING_AUTO)
							pixel_size = PIXEL_SCALING_1X
						if(PIXEL_SCALING_1X)
							pixel_size = PIXEL_SCALING_1_2X
						if(PIXEL_SCALING_1_2X)
							pixel_size = PIXEL_SCALING_2X
						if(PIXEL_SCALING_2X)
							pixel_size = PIXEL_SCALING_3X
						if(PIXEL_SCALING_3X)
							pixel_size = PIXEL_SCALING_AUTO
					user.client.view_size.apply() //Let's winset() it so it actually works

				if("scaling_method")
					switch(scaling_method)
						if(SCALING_METHOD_NORMAL)
							scaling_method = SCALING_METHOD_DISTORT
						if(SCALING_METHOD_DISTORT)
							scaling_method = SCALING_METHOD_BLUR
						if(SCALING_METHOD_BLUR)
							scaling_method = SCALING_METHOD_NORMAL
					user.client.view_size.setZoomMode()

				if("autostand")
					autostand = !autostand
				if("auto_ooc")
					auto_ooc = !auto_ooc
				if("no_tetris_storage")
					no_tetris_storage = !no_tetris_storage
				if ("screenshake")
					var/desiredshake = input(user, "Set the amount of screenshake you want. \n(0 = disabled, 100 = full, no maximum (at your own risk).)", "Character Preference", screenshake)  as null|num
					if (!isnull(desiredshake))
						screenshake = desiredshake
				if("damagescreenshake")
					switch(damagescreenshake)
						if(0)
							damagescreenshake = 1
						if(1)
							damagescreenshake = 2
						if(2)
							damagescreenshake = 0
						else
							damagescreenshake = 1
				if ("recoil_screenshake")
					var/desiredshake = input(user, "Set the amount of recoil screenshake/push you want. \n(0 = disabled, 100 = full, no maximum (at your own risk).)", "Character Preference", screenshake)  as null|num
					if (!isnull(desiredshake))
						recoil_screenshake = desiredshake
				if("nameless")
					nameless = !nameless

				//Skyrat begin
				if("erp_pref")
					switch(erppref)
						if("Yes")
							erppref = "Ask"
						if("Ask")
							erppref = "No"
						if("No")
							erppref = "Yes"
				if("noncon_pref")
					switch(nonconpref)
						if("Yes")
							nonconpref = "Ask"
						if("Ask")
							nonconpref = "No"
						if("No")
							nonconpref = "Yes"
				if("vore_pref")
					switch(vorepref)
						if("Yes")
							vorepref = "Ask"
						if("Ask")
							vorepref = "No"
						if("No")
							vorepref = "Yes"
				if("unholypref") //...
					switch(unholypref)
						if("Yes")
							unholypref = "Ask"
						if("Ask")
							unholypref = "No"
						if("No")
							unholypref = "Yes"
				//Gardelin0 Addoon
				if("mobsex_pref") //...
					switch(mobsexpref)
						if("Yes")
							mobsexpref = "No"
						if("No")
							mobsexpref = "Yes"
				if("hornyantags_pref") //...
					switch(hornyantagspref)
						if("Yes")
							hornyantagspref = "No"
						if("No")
							hornyantagspref = "Yes"
//				if("stomppref") // What the fuck is this?
//					stomppref = !stomppref
				//Skyrat edit - *someone* offered me actual money for this shit
				if("extremepref") //i hate myself for doing this
					switch(extremepref) //why the fuck did this need to use cycling instead of input from a list
						if("Yes")		//seriously this confused me so fucking much
							extremepref = "Ask"
						if("Ask")
							extremepref = "No"
							extremeharm = "No"
						if("No")
							extremepref = "Yes"
				if("extremeharm")
					switch(extremeharm)
						if("Yes")	//this is cursed code
							extremeharm = "No"
						if("No")
							extremeharm = "Yes"
					if(extremepref == "No")
						extremeharm = "No"
				//END CITADEL EDIT
				if("publicity")
					if(unlock_content)
						toggles ^= MEMBER_PUBLIC

				if("body_model")
					features["body_model"] = features["body_model"] == MALE ? FEMALE : MALE

				if("hotkeys")
					hotkeys = !hotkeys
					user.client.ensure_keys_set(src)

				if("keybindings_capture")
					var/datum/keybinding/kb = GLOB.keybindings_by_name[href_list["keybinding"]]
					CaptureKeybinding(user, kb, href_list["old_key"], text2num(href_list["independent"]), kb.special || kb.clientside)
					return

				if("keybindings_set")
					var/kb_name = href_list["keybinding"]
					if(!kb_name)
						user << browse(null, "window=capturekeypress")
						ShowChoices(user)
						return

					var/independent = href_list["independent"]

					var/clear_key = text2num(href_list["clear_key"])
					var/old_key = href_list["old_key"]
					if(clear_key)
						if(independent)
							modless_key_bindings -= old_key
						else
							if(key_bindings[old_key])
								key_bindings[old_key] -= kb_name
								LAZYADD(key_bindings["Unbound"], kb_name)
								if(!length(key_bindings[old_key]))
									key_bindings -= old_key
						user << browse(null, "window=capturekeypress")
						if(href_list["special"])		// special keys need a full reset
							user.client.ensure_keys_set(src)
						save_preferences()
						ShowChoices(user)
						return

					var/new_key = uppertext(href_list["key"])
					var/AltMod = text2num(href_list["alt"]) ? "Alt" : ""
					var/CtrlMod = text2num(href_list["ctrl"]) ? "Ctrl" : ""
					var/ShiftMod = text2num(href_list["shift"]) ? "Shift" : ""
					var/numpad = text2num(href_list["numpad"]) ? "Numpad" : ""
					// var/key_code = text2num(href_list["key_code"])

					if(GLOB._kbMap[new_key])
						new_key = GLOB._kbMap[new_key]

					var/full_key
					switch(new_key)
						if("Alt")
							full_key = "[new_key][CtrlMod][ShiftMod]"
						if("Ctrl")
							full_key = "[AltMod][new_key][ShiftMod]"
						if("Shift")
							full_key = "[AltMod][CtrlMod][new_key]"
						else
							full_key = "[AltMod][CtrlMod][ShiftMod][numpad][new_key]"
					if(independent)
						modless_key_bindings -= old_key
						modless_key_bindings[full_key] = kb_name
					else
						if(key_bindings[old_key])
							key_bindings[old_key] -= kb_name
							if(!length(key_bindings[old_key]))
								key_bindings -= old_key
						key_bindings[full_key] += list(kb_name)
						key_bindings[full_key] = sort_list(key_bindings[full_key])
					if(href_list["special"])		// special keys need a full reset
						user.client.ensure_keys_set(src)
					user << browse(null, "window=capturekeypress")
					save_preferences()

				if("keybindings_reset")
					var/choice = tgalert(user, "Would you prefer 'hotkey' or 'classic' defaults?", "Setup keybindings", "Hotkey", "Classic", "Cancel")
					if(choice == "Cancel")
						ShowChoices(user)
						return
					hotkeys = (choice == "Hotkey")
					key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)
					modless_key_bindings = list()
					user.client.ensure_keys_set(src)

				if("chat_on_map")
					chat_on_map = !chat_on_map
				if("see_chat_non_mob")
					see_chat_non_mob = !see_chat_non_mob
				//Sandstorm changes begin
				if("see_chat_emotes")
					see_chat_emotes = !see_chat_emotes
				if("enable_personal_chat_color")
					enable_personal_chat_color = !enable_personal_chat_color
				//End of sandstorm changes
				if("view_pixelshift") //SPLURT Edit
					view_pixelshift = !view_pixelshift
				if("tgui_fancy")
					tgui_fancy = !tgui_fancy
				if("tgui_input_mode")
					tgui_input_mode = !tgui_input_mode
				if("tgui_large_buttons")
					tgui_large_buttons = !tgui_large_buttons
				if("tgui_swapped_buttons")
					tgui_swapped_buttons = !tgui_swapped_buttons
				if("outline_enabled")
					outline_enabled = !outline_enabled
				if("outline_color")
					var/pickedOutlineColor = input(user, "Choose your outline color.", "General Preference", outline_color) as color|null
					if(pickedOutlineColor != outline_color)
						outline_color = pickedOutlineColor // nullable
				if("screentip_pref")
					var/choice = tgui_input_list(user, "Choose your screentip preference", "Screentipping?", GLOB.screentip_pref_options, screentip_pref)
					if(choice)
						screentip_pref = choice
				if("screentip_color")
					var/pickedScreentipColor = input(user, "Choose your screentip color.", "General Preference", screentip_color) as color|null
					if(pickedScreentipColor)
						screentip_color = pickedScreentipColor
				if("screentip_images")
					screentip_images = !screentip_images
				if("tgui_lock")
					tgui_lock = !tgui_lock
				if("winflash")
					windowflashing = !windowflashing
				if("winnoise")
					windownoise = !windownoise
				if("hear_adminhelps")
					toggles ^= SOUND_ADMINHELP
				if("announce_login")
					toggles ^= ANNOUNCE_LOGIN
				if("combohud_lighting")
					toggles ^= COMBOHUD_LIGHTING
				if("use_new_playerpanel")
					use_new_playerpanel = !use_new_playerpanel

				// Deadmin preferences
				if("toggle_deadmin_always")
					deadmin ^= DEADMIN_ALWAYS
				if("toggle_deadmin_antag")
					deadmin ^= DEADMIN_ANTAGONIST
				if("toggle_deadmin_head")
					deadmin ^= DEADMIN_POSITION_HEAD
				if("toggle_deadmin_security")
					deadmin ^= DEADMIN_POSITION_SECURITY
				if("toggle_deadmin_silicon")
					deadmin ^= DEADMIN_POSITION_SILICON
				//

				if("disable_antag")
					toggles ^= NO_ANTAG

				if("be_special")
					var/be_special_type = href_list["be_special_type"]
					if(be_special_type in be_special)
						if(be_special[be_special_type] >= 1)
							be_special -= be_special_type
						else
							be_special[be_special_type] = 1
					else
						be_special += be_special_type
						be_special[be_special_type] = 0

				if("name")
					be_random_name = !be_random_name

				if("all")
					be_random_body = !be_random_body

				if("hear_midis")
					toggles ^= SOUND_MIDI

				if("verb_consent") // Skyrat - ERP Mechanic Addition
					toggles ^= VERB_CONSENT // Skyrat - ERP Mechanic Addition

				if("lewd_verb_sounds") // Skyrat - ERP Mechanic Addition
					toggles ^= LEWD_VERB_SOUNDS // Skyrat - ERP Mechanic Addition

				if("persistent_scars")
					persistent_scars = !persistent_scars

				if("clear_scars")
					to_chat(user, "<span class='notice'>All scar slots cleared. Please save character to confirm.</span>")
					scars_list["1"] = ""
					scars_list["2"] = ""
					scars_list["3"] = ""
					scars_list["4"] = ""
					scars_list["5"] = ""

				if("lobby_music")
					toggles ^= SOUND_LOBBY
					if((toggles & SOUND_LOBBY) && user.client && isnewplayer(user))
						user.client.playtitlemusic()
					else
						user.stop_sound_channel(CHANNEL_LOBBYMUSIC)

				if("ghost_ears")
					chat_toggles ^= CHAT_GHOSTEARS

				if("ghost_sight")
					chat_toggles ^= CHAT_GHOSTSIGHT

				if("ghost_whispers")
					chat_toggles ^= CHAT_GHOSTWHISPER

				if("ghost_radio")
					chat_toggles ^= CHAT_GHOSTRADIO

				if("ghost_pda")
					chat_toggles ^= CHAT_GHOSTPDA

				if("income_pings")
					chat_toggles ^= CHAT_BANKCARD

				if("pull_requests")
					chat_toggles ^= CHAT_PULLR

				if("allow_midround_antag")
					toggles ^= MIDROUND_ANTAG

				if("parallaxup")
					parallax = WRAP(parallax + 1, PARALLAX_DISABLE, PARALLAX_INSANE + 1)
					parent?.parallax_holder?.Reset()

				if("parallaxdown")
					parallax = WRAP(parallax - 1, PARALLAX_DISABLE, PARALLAX_INSANE + 1)
					parent?.parallax_holder?.Reset()

				// Citadel edit - Prefs don't work outside of this. :c

				if("genital_examine")
					cit_toggles ^= GENITAL_EXAMINE

				if("vore_examine")
					cit_toggles ^= VORE_EXAMINE

				if("hound_sleeper")
					cit_toggles ^= MEDIHOUND_SLEEPER

				if("toggleeatingnoise")
					cit_toggles ^= EATING_NOISES

				if("toggledigestionnoise")
					cit_toggles ^= DIGESTION_NOISES

				if("toggleforcefeedtrash")
					cit_toggles ^= TRASH_FORCEFEED

				if("breast_enlargement")
					cit_toggles ^= BREAST_ENLARGEMENT

				if("penis_enlargement")
					cit_toggles ^= PENIS_ENLARGEMENT

				if("butt_enlargement")
					cit_toggles ^= BUTT_ENLARGEMENT

				if("belly_inflation")
					cit_toggles ^= BELLY_INFLATION

				if("feminization")
					cit_toggles ^= FORCED_FEM

				if("masculinization")
					cit_toggles ^= FORCED_MASC

				if("hypno")
					cit_toggles ^= HYPNO

				if("never_hypno")
					cit_toggles ^= NEVER_HYPNO

				if("aphro")
					cit_toggles ^= NO_APHRO

				if("ass_slap")
					cit_toggles ^= NO_ASS_SLAP

				if("bimbo")
					cit_toggles ^= BIMBOFICATION

				if("auto_wag")
					cit_toggles ^= NO_AUTO_WAG

				if("disco_dance")
					cit_toggles ^= NO_DISCO_DANCE

				//END CITADEL EDIT

				if("sex_jitter") //By Gardelin0
					cit_toggles ^= SEX_JITTER

				if("ambientocclusion")
					ambientocclusion = !ambientocclusion
					if(parent && parent.screen && parent.screen.len)
						var/atom/movable/screen/plane_master/game_world/G = parent.mob.hud_used.plane_masters["[GAME_PLANE]"]
						var/atom/movable/screen/plane_master/above_wall/A = parent.mob.hud_used.plane_masters["[ABOVE_WALL_PLANE]"]
						var/atom/movable/screen/plane_master/wall/W = parent.mob.hud_used.plane_masters["[WALL_PLANE]"]
						G.backdrop(parent.mob)
						A.backdrop(parent.mob)
						W.backdrop(parent.mob)

				if("auto_fit_viewport")
					auto_fit_viewport = !auto_fit_viewport
					if(auto_fit_viewport && parent)
						parent.fit_viewport()

				if("hud_toggle_flash")
					hud_toggle_flash = !hud_toggle_flash

				if("barkpreview")
					if(SSticker.current_state == GAME_STATE_STARTUP) //Timers don't tick at all during game startup, so let's just give an error message
						to_chat(user, "<span class='warning'>Bark previews can't play during initialization!</span>")
						return
					if(!COOLDOWN_FINISHED(src, bark_previewing))
						return
					if(!parent || !parent.mob)
						return
					COOLDOWN_START(src, bark_previewing, (5 SECONDS))
					var/atom/movable/barkbox = new(get_turf(parent.mob))
					barkbox.set_bark(bark_id)
					var/total_delay
					for(var/i in 1 to (round((32 / bark_speed)) + 1))
						addtimer(CALLBACK(barkbox, TYPE_PROC_REF(/atom/movable, bark), list(parent.mob), 7, 70, BARK_DO_VARY(bark_pitch, bark_variance)), total_delay)
						total_delay += rand(DS2TICKS(bark_speed/4), DS2TICKS(bark_speed/4) + DS2TICKS(bark_speed/4)) TICKS
					QDEL_IN(barkbox, total_delay)

				if("save")
					save_preferences()
					save_character()

				if("load")
					load_preferences()
					load_character()

				if("changeslot")
					if(char_queue)
						deltimer(char_queue) // Do not dare.
					if(!load_character(text2num(href_list["num"])))
						random_character()
						real_name = random_unique_name(gender)
						save_character()
					if(user.client?.prefs) //custom emote panel is attached to the character
						var/list/payload = user.client.prefs.custom_emote_panel
						user.client.tgui_panel?.window.send_message("emotes/setList", payload)

				if("tab")
					if(href_list["tab"])
						current_tab = text2num(href_list["tab"])
				//SPLURT edit
				// BLUEMOON REMOVE - Ищи в `modular_bluemoon/code/modules/client/preferences.dm`
				/*
				if("headshot")
					var/usr_input = input(user, "Input the image link: (For Discord links, try putting the file's type at the end of the link, after the '&'. for example '&.jpg/.png/.jpeg')", "Headshot Image", features["headshot_link"]) as text|null
					if(isnull(usr_input))
						return
					if(!usr_input)
						features["headshot_link"] = null
						return

					var/static/link_regex = regex("https://i.gyazo.com|https://static1.e621.net") //Do not touch the damn duplicates.
					var/static/end_regex = regex(".jpg|.jpg|.png|.jpeg|.jpeg") //Regex is terrible, don't touch the duplicate extensions

					if(!findtext(usr_input, link_regex))
						to_chat(usr, span_warning("You need a valid link!"))
						return
					if(!findtext(usr_input, end_regex))
						to_chat(usr, span_warning("You need either \".png\", \".jpg\", or \".jpeg\" in the link!"))
						return

					if(features["headshot_link"] != usr_input)
						to_chat(usr, span_notice("If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser."))
						to_chat(usr, span_notice("Keep in mind that the photo will be downsized to 250x250 pixels, so the more square the photo, the better it will look."))
					features["headshot_link"] = usr_input
				*/
				// BLUEMOON REMOVE END

				if("character_preview")
					preview_pref = href_list["tab"]

				if("character_tab")
					if(href_list["tab"])
						character_settings_tab = text2num(href_list["tab"])

				if("preferences_tab")
					if(href_list["tab"])
						preferences_tab = text2num(href_list["tab"])

				if("chastitypref")
					cit_toggles ^= CHASTITY
				if("stimulationpref")
					cit_toggles ^= STIMULATION
				if("edgingpref")
					cit_toggles ^= EDGING
				if("cumontopref")
					cit_toggles ^= CUM_ONTO
				//
				if("export_slot")
					var/savefile/S = save_character(export = TRUE)
					if(istype(S, /savefile))
						user.client.Export(S)
						tgui_alert_async(user, "Successfully saved character slot")
					else
						tgui_alert_async(user, "Failed saving character slot")
						return

				if("import_slot")
					var/savefile/S = new(user.client.Import())
					if(istype(S, /savefile))
						if(load_character(provided = S))
							tgui_alert_async(user, "Successfully loaded character slot.")
							save_character(TRUE)
						else
							tgui_alert_async(user, "Failed loading character slot")
							return
					else
						tgui_alert_async(user, "Failed loading character slot")
						return

				if("delete_local_copy")
					user.client.clear_export()
					tgui_alert_async(user, "Local save data erased.")

				if("give_slot")
					if(!QDELETED(offer))
						var/datum/character_offer_instance/offer_datum = LAZYACCESS(GLOB.character_offers, offer.redemption_code)
						if(!offer_datum)
							return
						qdel(offer_datum)
					else
						var/savefile/S = save_character(export = TRUE)
						if(istype(S, /savefile))
							var/datum/character_offer_instance/offer_datum = new(usr.ckey, S)
							if(QDELETED(offer_datum))
								tgui_alert_async(usr, "Could not set up offer, try again later")
								return
							offer_datum.RegisterSignal(usr, COMSIG_MOB_CLIENT_LOGOUT, TYPE_PROC_REF(/datum/character_offer_instance, on_quit))
							offer = offer_datum
							tgui_alert_async(usr, "The redemption code is [offer_datum.redemption_code], give it to the receiver")

				if("retrieve_slot")
					if(!LAZYLEN(GLOB.character_offers))
						tgui_alert_async(usr, "There are no active offers")
						return
					var/retrieve_code = input(usr, "Input the 5 digit redemption code") as text|null
					if(!retrieve_code)
						return
					if(!text2num(retrieve_code))
						tgui_alert_async(usr, "Only numbers allowed")
						return
					if(length(retrieve_code) != 5)
						tgui_alert_async(usr, "Exactly 5 digits, no less, no more, try again")
						return
					var/datum/character_offer_instance/offer_datum = LAZYACCESS(GLOB.character_offers, retrieve_code)
					if(!offer_datum)
						tgui_alert_async(usr, "This is an invalid code!")
						return
					if(offer == offer_datum)
						tgui_alert_async(usr, "You cannot accept your own offer")
						return
					var/savefile/savefile = offer_datum.character_savefile
					var/mob/living/the_owner = get_mob_by_ckey(offer_datum.owner_ckey)
					if(savefile_needs_update(savefile) == -2)
						tgui_alert_async(usr, "Something's wrong, this savefile is corrupted.")
						to_chat(the_owner, span_boldwarning("Something went wrong with the trade, it's been canceled."))
						qdel(offer_datum)
						return
					var/character_name = savefile["real_name"]
					if(alert(usr, "You are overwriting the currently selected slot with the character [character_name]", "Are you sure?", "Yes, load this character deleting the currently selected slot", "No") == "No")
						return
					if(QDELETED(offer_datum))
						tgui_alert_async(usr, "This character is no longer available, such a shame!")
						return
					to_chat(the_owner, span_boldwarning("[usr.key] has retrieved your character, [character_name]!"))
					if(!load_character(provided = savefile))
						tgui_alert_async(usr, "Something went wrong loading the savefile, even though it has already been checked, please report this issue!")
						to_chat(the_owner, span_boldwarning("Something went wrong at the final step of the trade, report this."))
						qdel(offer_datum)
						return
					tgui_alert_async(usr, "Successfully received [character_name]!")
					save_character(TRUE)
					qdel(offer_datum)

	if(href_list["preference"] == "gear")
		if(href_list["select_slot"])
			var/chosen = text2num(href_list["select_slot"])
			if(!chosen)
				return
			chosen = floor(chosen)
			if(chosen > MAXIMUM_LOADOUT_SAVES || chosen < 1)
				return
			loadout_slot = chosen
		if(href_list["clear_loadout"])
			loadout_data["SAVE_[loadout_slot]"] = list()
			save_preferences()
		if(href_list["select_category"])
			gear_category = html_decode(href_list["select_category"])
			gear_subcategory = GLOB.loadout_categories[gear_category][1]
		if(href_list["select_subcategory"])
			gear_subcategory = html_decode(href_list["select_subcategory"])
		if(href_list["toggle_gear_path"])
			var/name = html_decode(href_list["toggle_gear_path"])
			var/datum/gear/G = GLOB.loadout_items[gear_category][gear_subcategory][name]
			if(!G)
				return
			var/toggle = text2num(href_list["toggle_gear"])
			if(!toggle && has_loadout_gear(loadout_slot, "[G.type]"))//toggling off and the item effectively is in chosen gear)
				var/gear = has_loadout_gear(loadout_slot, "[G.type]")
				// BLUEMOON EDIT START - выбор вещей из лодаута как family heirloom
				if (gear[LOADOUT_IS_HEIRLOOM])
					gear[LOADOUT_IS_HEIRLOOM] = FALSE
				// BLUEMOON EDIT END - выбор вещей из лодаута как family heirloom
				remove_gear_from_loadout(loadout_slot, "[G.type]")
			else if(toggle && !(has_loadout_gear(loadout_slot, "[G.type]")))
				if(!is_loadout_slot_available(G.category))
					to_chat(user, "<span class='danger'>You cannot take this loadout, as you've already chosen too many of the same category!</span>")
					return
				if(G.donoritem && !G.donator_ckey_check(user.ckey))
					to_chat(user, "<span class='danger'>This is an item intended for donator use only. You are not authorized to use this item.</span>")
					return
				if(istype(G, /datum/gear/unlockable) && !can_use_unlockable(G))
					to_chat(user, "<span class='danger'>To use this item, you need to meet the defined requirements!</span>")
					return
				if(gear_points >= initial(G.cost))
					var/list/new_loadout_data = list(LOADOUT_ITEM = "[G.type]")
					if(length(G.loadout_initial_colors))
						new_loadout_data[LOADOUT_COLOR] = G.loadout_initial_colors
					else
						new_loadout_data[LOADOUT_COLOR] = list("#FFFFFF")
					if(loadout_data["SAVE_[loadout_slot]"])
						loadout_data["SAVE_[loadout_slot]"] += list(new_loadout_data) //double packed because it does the union of the CONTENTS of the lists
					else
						loadout_data["SAVE_[loadout_slot]"] = list(new_loadout_data) //double packed because you somehow had no save slot in your loadout?
		if(href_list["clear_invalid_gear"])
			var/thing_to_remove = html_decode(href_list["clear_invalid_gear"])
			if(!thing_to_remove)
				return
			var/list/sanitize_current_slot = loadout_data["SAVE_[loadout_slot]"]
			for(var/list/entry in sanitize_current_slot)
				if(entry["loadout_item"] == thing_to_remove)
					sanitize_current_slot.Remove(list(entry))
					break

		if(href_list["loadout_color"] || href_list["loadout_color_polychromic"] || href_list["loadout_color_HSV"] || href_list["loadout_rename"] || href_list["loadout_redescribe"] || href_list["loadout_addheirloom"] || href_list["loadout_removeheirloom"] || href_list["loadout_tagname"])

			//if the gear doesn't exist, or they don't have it, ignore the request
			var/name = html_decode(href_list["loadout_gear_name"])
			var/datum/gear/G = GLOB.loadout_items[gear_category][gear_subcategory][name]
			if(!G)
				return
			var/user_gear = has_loadout_gear(loadout_slot, "[G.type]")
			if(!user_gear)
				return

			//possible requests: recolor, recolor (polychromic), rename, redescribe
			//always make sure the gear allows said request before proceeding

			//non-poly coloring can only be done by non-poly items
			if(href_list["loadout_color"] && !(G.loadout_flags & LOADOUT_CAN_COLOR_POLYCHROMIC))
				if(!length(user_gear[LOADOUT_COLOR]))
					user_gear[LOADOUT_COLOR] = list("#FFFFFF")
				var/current_color = user_gear[LOADOUT_COLOR][1]
				var/new_color = input(user, "Polychromic options", "Choose Color", current_color) as color|null
				user_gear[LOADOUT_COLOR][1] = sanitize_hexcolor(new_color, 6, TRUE, current_color)

			// HSV Coloring (SPLURT EDIT)
			if(href_list["loadout_color_HSV"] && !(G.loadout_flags & LOADOUT_CAN_COLOR_POLYCHROMIC))
				var/hue = input(user, "Enter Hue (0-360)", "HSV options") as num|null
				var/saturation = input(user, "Enter Saturation (-10 to 10)", "HSV options") as num|null
				var/value = input(user, "Enter Value (-10 to 10)", "HSV options") as num|null
				if(hue && saturation && value)
					saturation = clamp(saturation, -10, 10)
					value = clamp(value, -10, 10)
					var/color_to_use = color_matrix_hsv(hue, saturation, value)
					user_gear[LOADOUT_COLOR][1] = color_to_use

			//poly coloring can only be done by poly items
			if(href_list["loadout_color_polychromic"] && (G.loadout_flags & LOADOUT_CAN_COLOR_POLYCHROMIC))
				var/list/color_options = list()
				for(var/i=1, i<=length(G.loadout_initial_colors), i++)
					color_options += "Color [i]"
				var/color_to_change = tgui_input_list(user, "Polychromic options", "Recolor [name]", color_options)
				if(color_to_change)
					var/color_index = text2num(copytext(color_to_change, 7))
					var/current_color = user_gear[LOADOUT_COLOR][color_index]
					var/new_color = input(user, "Polychromic options", "Choose [color_to_change] Color", current_color) as color|null
					if(new_color)
						user_gear[LOADOUT_COLOR][color_index] = sanitize_hexcolor(new_color, 6, TRUE, current_color)

			//both renaming and redescribing strip the input to stop html injection

			//renaming is only allowed if it has the flag for it
			if(href_list["loadout_rename"] && (G.loadout_flags & LOADOUT_CAN_NAME))
				var/new_name = stripped_input(user, "Enter new name for item. Maximum [MAX_NAME_LEN] characters.", "Loadout Item Naming", null,  MAX_NAME_LEN)
				if(new_name)
					user_gear[LOADOUT_CUSTOM_NAME] = new_name

			//redescribing is only allowed if it has the flag for it
			if(href_list["loadout_redescribe"] && (G.loadout_flags & LOADOUT_CAN_DESCRIPTION)) //redescribe isnt a real word but i can't think of the right term to use
				var/new_description = stripped_input(user, "Enter new description for item. Maximum 500 characters.", "Loadout Item Redescribing", null, 500)
				if(new_description)
					user_gear[LOADOUT_CUSTOM_DESCRIPTION] = new_description
			// BLUEMOON ADD START - выбор вещей из лодаута как family heirloom
			if(href_list["loadout_addheirloom"])
				// Выбран ли какой-либо другой предмет как семейная реликвия, и если да, то какой?
				var/existing = find_gear_with_property(loadout_slot, LOADOUT_IS_HEIRLOOM, TRUE)
				if(!existing)
					user_gear[LOADOUT_IS_HEIRLOOM] = TRUE
				else
					to_chat(user, "<font color='red'>У вас уже выбрана ваша семейная реликвия!</font>")
			if(href_list["loadout_removeheirloom"])
				user_gear[LOADOUT_IS_HEIRLOOM] = FALSE
			// BLUEMOON ADD END

			//for collars with tagnames
			if(href_list["loadout_tagname"])
				var/new_tagname = stripped_input(user, "Would you like to change the name on the tag?", "Name your new pet", null, MAX_NAME_LEN)
				if(new_tagname)
					user_gear["loadout_custom_tagname"] = new_tagname

	ShowChoices(user)
	return TRUE

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = 1, roundstart_checks = TRUE, initial_spawn = FALSE)
	if(be_random_name)
		real_name = pref_species.random_name(gender)

	if(be_random_body)
		random_character(gender)

	if(roundstart_checks)
		if(CONFIG_GET(flag/humans_need_surnames) && (pref_species.id == "human"))
			var/firstspace = findtext(real_name, " ")
			var/name_length = length(real_name)
			if(!firstspace)	//we need a surname
				real_name += " [pick(GLOB.last_names)]"
			else if(firstspace == name_length)
				real_name += "[pick(GLOB.last_names)]"

	//reset size if applicable
	if(character.dna.features["body_size"])
		var/initial_old_size = character.dna.features["body_size"]
		character.update_size(RESIZE_DEFAULT_SIZE, initial_old_size)

	character.real_name = nameless ? "[real_name] #[rand(10000, 99999)]" : real_name
	character.name = character.real_name
	character.nameless = nameless
	character.custom_species = custom_species

	character.gender = gender
	character.age = age

	character.fuzzy = fuzzy

	character.left_eye_color = left_eye_color
	character.right_eye_color = right_eye_color
	var/obj/item/organ/eyes/organ_eyes = character.getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		if(!initial(organ_eyes.left_eye_color))
			organ_eyes.left_eye_color = left_eye_color
			organ_eyes.right_eye_color = right_eye_color
		organ_eyes.old_left_eye_color = left_eye_color
		organ_eyes.old_right_eye_color = right_eye_color
	character.hair_color = hair_color
	character.facial_hair_color = facial_hair_color
	character.skin_tone = skin_tone
	character.dna.skin_tone_override = use_custom_skin_tone ? skin_tone : null
	character.hair_style = hair_style
	character.facial_hair_style = facial_hair_style
	character.grad_style = grad_style
	character.grad_color = grad_color
	/* skyrat edit
	character.underwear = underwear

	character.saved_underwear = underwear
	character.undershirt = undershirt
	character.saved_undershirt = undershirt
	character.socks = socks
	character.saved_socks = socks
	*/
	character.undie_color = undie_color
	character.shirt_color = shirt_color
	character.socks_color = socks_color

	var/datum/species/chosen_species
	if(!roundstart_checks || (pref_species.id in GLOB.roundstart_races))
		chosen_species = pref_species.type
	else
		chosen_species = /datum/species/human
		pref_species = new /datum/species/human
		save_character()

	character.dna.features = features.Copy()

	character.set_species(chosen_species, icon_update = FALSE, pref_load = TRUE)
	character.dna.species.eye_type = eye_type
	if(chosen_limb_id && (chosen_limb_id in character.dna.species.allowed_limb_ids))
		character.dna.species.mutant_bodyparts["limbs_id"] = chosen_limb_id
	character.dna.real_name = character.real_name
	character.dna.nameless = character.nameless
	// BLUEMOON EDIT START - привязка флавора и лора кастомных рас к ДНК
	character.dna.custom_species = character.custom_species
	character.dna.custom_species_lore = features["custom_species_lore"]
	character.dna.flavor_text = features["flavor_text"]
	character.dna.naked_flavor_text = features["naked_flavor_text"]
	character.dna.headshot_links.Cut()
	if (features["headshot_link"])
		character.dna.headshot_links.Add(features["headshot_link"])
	if (features["headshot_link1"])
		character.dna.headshot_links.Add(features["headshot_link1"])
	if (features["headshot_link2"])
		character.dna.headshot_links.Add(features["headshot_link2"])
	character.dna.ooc_notes = features["ooc_notes"]
	if(custom_blood_color)
		character.dna.species.exotic_blood_color = blood_color //а раньше эта строчка была немного выше и всё ломалось, думайте, когда делаете врезки
	// BLUEMOON EDIT END

	var/old_size = RESIZE_DEFAULT_SIZE
	if(isdwarf(character))
		character.dna.features["body_size"] = RESIZE_DEFAULT_SIZE

	if((parent && parent.can_have_part("meat_type")) || pref_species.mutant_bodyparts["meat_type"])
		character.type_of_meat = GLOB.meat_types[features["meat_type"]]

	if(((parent && parent.can_have_part("legs")) || pref_species.mutant_bodyparts["legs"])  && (character.dna.features["legs"] == "Digitigrade" || character.dna.features["legs"] == "Avian"))
		pref_species.species_traits |= DIGITIGRADE
	else
		pref_species.species_traits -= DIGITIGRADE

	if(DIGITIGRADE in pref_species.species_traits)
		character.Digitigrade_Leg_Swap(FALSE)
	else
		character.Digitigrade_Leg_Swap(TRUE)

	character.dna.features["lust_tolerance"] = lust_tolerance
	character.dna.features["sexual_potency"] = sexual_potency

	if(features["anus_accessible"])
		character.toggle_anus_always_accessible(TRUE)

	character.give_genitals(TRUE) //character.update_genitals() is already called on genital.update_appearance()

	character.update_size(get_size(character), old_size)

	//speech stuff
	if(custom_tongue != "default")
		var/new_tongue = GLOB.roundstart_tongues[custom_tongue]
		if(new_tongue)
			character.dna.species.mutanttongue = new_tongue //this means we get our tongue when we clone
			var/obj/item/organ/tongue/T = character.getorganslot(ORGAN_SLOT_TONGUE)
			if(T)
				qdel(T)
			var/obj/item/organ/tongue/new_custom_tongue = new new_tongue
			new_custom_tongue.Insert(character)
	if(custom_speech_verb != "default")
		character.dna.species.say_mod = custom_speech_verb

	character.set_bark(bark_id)
	character.vocal_speed = bark_speed
	character.vocal_pitch = bark_pitch
	character.vocal_pitch_range = bark_variance

	//limb stuff, only done when initially spawning in
	if(initial_spawn)
		//delete any existing prosthetic limbs to make sure no remnant prosthetics are left over - But DO NOT delete those that are species-related
		for(var/obj/item/bodypart/part in character.bodyparts)
			if(part.is_robotic_limb(FALSE))
				qdel(part)
		character.regenerate_limbs() //regenerate limbs so now you only have normal limbs
		for(var/modified_limb in modified_limbs)
			var/modification = modified_limbs[modified_limb][1]
			var/obj/item/bodypart/old_part = character.get_bodypart(modified_limb)
			if(modification == LOADOUT_LIMB_PROSTHETIC)
				var/obj/item/bodypart/new_limb
				switch(modified_limb)
					if(BODY_ZONE_L_ARM)
						new_limb = new/obj/item/bodypart/l_arm/robot/surplus(character)
					if(BODY_ZONE_R_ARM)
						new_limb = new/obj/item/bodypart/r_arm/robot/surplus(character)
					if(BODY_ZONE_L_LEG)
						new_limb = new/obj/item/bodypart/l_leg/robot/surplus(character)
					if(BODY_ZONE_R_LEG)
						new_limb = new/obj/item/bodypart/r_leg/robot/surplus(character)
				var/prosthetic_type = modified_limbs[modified_limb][2]
				if(prosthetic_type != "prosthetic") //lets just leave the old sprites as they are
					new_limb.icon = file("icons/mob/augmentation/cosmetic_prosthetic/[prosthetic_type].dmi")
				new_limb.replace_limb(character)
			qdel(old_part)

	SEND_SIGNAL(character, COMSIG_HUMAN_PREFS_COPIED_TO, src, icon_updates, roundstart_checks)

	//let's be sure the character updates
	if(icon_updates)
		character.update_body()
		character.update_hair()

/datum/preferences/proc/post_copy_to(mob/living/carbon/human/character)
	//if no legs, and not a paraplegic or a slime, give them a free wheelchair
	if(modified_limbs[BODY_ZONE_L_LEG] == LOADOUT_LIMB_AMPUTATED && modified_limbs[BODY_ZONE_R_LEG] == LOADOUT_LIMB_AMPUTATED && !character.has_quirk(/datum/quirk/paraplegic) && !isjellyperson(character))
		if(character.buckled)
			character.buckled.unbuckle_mob(character)
		var/turf/T = get_turf(character)
		var/obj/structure/chair/spawn_chair = locate() in T
		var/obj/vehicle/ridden/wheelchair/wheels = new(T)
		if(spawn_chair) // Makes spawning on the arrivals shuttle more consistent looking
			wheels.setDir(spawn_chair.dir)
		wheels.buckle_mob(character)

/datum/preferences/proc/get_default_name(name_id)
	switch(name_id)
		if("human")
			return random_unique_name()
		if("ai")
			return pick(GLOB.ai_names)
		if("cyborg")
			return DEFAULT_CYBORG_NAME
		if("clown")
			return pick(GLOB.clown_names)
		if("mime")
			return pick(GLOB.mime_names)
	return random_unique_name()

/datum/preferences/proc/ask_for_custom_name(mob/user,name_id)
	var/namedata = GLOB.preferences_custom_names[name_id]
	if(!namedata)
		return

	var/raw_name = input(user, "Choose your character's [namedata["qdesc"]]:","Character Preference") as text|null
	if(!raw_name)
		if(namedata["allow_null"])
			custom_names[name_id] = get_default_name(name_id)
		else
			return
	else
		var/sanitized_name = reject_bad_name(raw_name,namedata["allow_numbers"])
		if(!sanitized_name)
			to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z,[namedata["allow_numbers"] ? ",0-9," : ""] -, ' and .</font>")
			return
		else
			custom_names[name_id] = sanitized_name

/datum/preferences/proc/get_filtered_holoform(filter_type)
	if(!custom_holoform_icon)
		return
	LAZYINITLIST(cached_holoform_icons)
	if(!cached_holoform_icons[filter_type])
		cached_holoform_icons[filter_type] = process_holoform_icon_filter(custom_holoform_icon, filter_type)
	return cached_holoform_icons[filter_type]

/// Resets the client's keybindings. Asks them for which
/datum/preferences/proc/force_reset_keybindings()
	var/choice = tgalert(parent.mob, "Your basic keybindings need to be reset, emotes will remain as before. Would you prefer 'hotkey' or 'classic' mode?", "Reset keybindings", "Hotkey", "Classic")
	hotkeys = (choice != "Classic")
	force_reset_keybindings_direct(hotkeys)

/// Does the actual reset
/datum/preferences/proc/force_reset_keybindings_direct(hotkeys = TRUE)
	var/list/oldkeys = key_bindings
	key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)

	for(var/key in oldkeys)
		if(!key_bindings[key])
			key_bindings[key] = oldkeys[key]
	parent?.ensure_keys_set(src)

/datum/preferences/proc/is_loadout_slot_available(slot)
	var/list/L
	LAZYINITLIST(L)
	for(var/i in loadout_data["SAVE_[loadout_slot]"])
		var/datum/gear/G = i[LOADOUT_ITEM]
		var/occupied_slots = L[initial(G.category)] ? L[initial(G.category)] + 1 : 1
		LAZYSET(L, initial(G.category), occupied_slots)
	switch(slot)
		if(ITEM_SLOT_BACKPACK)
			if(L[LOADOUT_CATEGORY_BACKPACK] < BACKPACK_SLOT_AMT)
				return TRUE
		if(ITEM_SLOT_HANDS)
			if(L[LOADOUT_CATEGORY_HANDS] < HANDS_SLOT_AMT)
				return TRUE
		else
			if(L[slot] < DEFAULT_SLOT_AMT)
				return TRUE

// BLUEMOON ADD START - выбор вещей из лодаута как семейной реликвии
///Searching for loadout item which `property` ([LOADOUT_ITEM], [LOADOUT_COLOR], etc) equals to `value`; returns this items, or FALSE if no gear matched conditions
/datum/preferences/proc/find_gear_with_property(save_slot, property, value)
	var/list/gear_list = loadout_data["SAVE_[save_slot]"]
	for(var/loadout_gear in gear_list)
		if(loadout_gear[property] == value)
			return loadout_gear
	return FALSE

/datum/preferences/proc/has_loadout_gear(save_slot, gear_type)
	var/list/gear_list = loadout_data["SAVE_[save_slot]"]
	for(var/loadout_gear in gear_list)
		if(loadout_gear[LOADOUT_ITEM] == gear_type)
			return loadout_gear
	return FALSE

/datum/preferences/proc/remove_gear_from_loadout(save_slot, gear_type)
	var/find_gear = has_loadout_gear(save_slot, gear_type)
	if(find_gear)
		loadout_data["SAVE_[save_slot]"] -= list(find_gear)

/datum/preferences/proc/can_use_unlockable(datum/gear/unlockable/unlockable_gear)
	if(unlockable_loadout_data[unlockable_gear.progress_key] >= unlockable_gear.progress_required)
		return TRUE
	return FALSE

/**
 * Get the given client's chat toggle prefs.
 *
 * Getter function for prefs.chat_toggles which guards against null client and null prefs.
 * The client object is fickle and can go null at times, so use this instead of directly accessing the var
 * if you want to ensure no runtimes.
 *
 * returns client.prefs.chat_toggles or FALSE if something went wrong.
 *
 * Arguments:
 * * client/prefs_holder - the client to get the chat_toggles pref from.
 */
/proc/get_chat_toggles(client/prefs_holder)
	if(!prefs_holder)
		return FALSE
	if(prefs_holder && !prefs_holder?.prefs)
		stack_trace("[prefs_holder?.mob] ([prefs_holder?.ckey]) had null prefs, which shouldn't be possible!")
		return FALSE

	return prefs_holder?.prefs.chat_toggles

#undef DEFAULT_SLOT_AMT
#undef HANDS_SLOT_AMT
#undef BACKPACK_SLOT_AMT
