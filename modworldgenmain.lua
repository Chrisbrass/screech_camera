local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")

Layouts["MainCamp"] = StaticLayout.Get("map/static_layouts/ms")

Layouts["HeliPad"] = StaticLayout.Get("map/static_layouts/helipad")


AddRoom("WorldBG", {
	type = "background",
	value = GROUND.CHECKER,
	contents = {
		distributepercent = 1,
		distributeprefabs = {
			evergreen_border = 1,
		},
	},
	colour = {r=0,g=0.25,b=0,a=0.25},
})




AddRoom("Main_Campsite_Room", {
	value = GROUND.CARPET,
	contents = {
		countstaticlayouts = {
			MainCamp = 1,
		},
		countprefabs = {
			lootcontainer = 0,
		},
		distributepercent = 1.0,
		distributeprefabs = {
			ground_grass=4,
			--evergreen=1,
			--berrybush=0.2,
			--sapling=0.2,
			--houndbone=0.01,
			--pond=0.01,
		},
	},
	colour = {r=1.0,g=1.0,b=0.5,a=0.25},
})


AddTask("Main_Campsite_Task", {
	locks = LOCKS.NONE,
	keys_given = {KEYS.TIER1},
	room_choices = {
	},
	room_bg = GROUND.FOREST,
	background_room = "WorldBG",
	colour = {r=0.8,g=0.8,b=0.5,a=1},
	crosslink_factor = 0,
	make_loop = true,
})


AddLevel(LEVELTYPE.SURVIVAL, {
	id="SURVIVAL_DEFAULT",
	name="Scary Mod Level",
	desc="This is the island generator for the scary mod.",
	location = "forest",
	version = 3,
	overrides={
		start_taskset = "MainCamp",
		day = "onlynight",
		world_size = "tiny",
		waves = "off",
		start_node = "Main_Campsite_Room",

		-- We don't want any of the Don't Starve random setpieces appearing
		boons = "never",
		traps = "never",
		poi = "never",
		protected = "never",

		-- hub and spoke
		--{"branching",        "most"},

		-- ring
		--{"branching",        "never"},
		--{"loop",             "always"},

		-- line
		branching = "never",
		loop = "never",
	},
	tasks = {
		"Main_Campsite_Task",
	},
	nomaxwell = true,
	task_set = 0,
	task_set = {},
	required_prefabs = {
		"flashlightloot",
		"generator",
	},
	background_node_range = {2, 2},
	blocker_blank_room_name = "WorldBG",
})
































AddLevel(LEVELTYPE.SURVIVAL, {
	id="SCREECHER",
	name="Screecher Alone",
	location = "forest",
	version = 2,
	desc="This is the island generator for the scary mod.",
	overrides={
		start_location = "dark",
		day = "onlynight",
		world_size = "tiny",
		prefabswaps_start = "classic",
		winter = "noseason",
		spring = "noseason",
		summer = "noseason",
		rain = "none",
		
	},
})