local function append_all(list, list1)
	for _, v in ipairs(list1) do
		table.insert(list, v)
	end
end

local function merge_all(table, table1)
	for k, v in pairs(table1) do
		if type(k) == "number" and k % 1 == 0 then
			table[#table + 1] = v
		elseif table[k] and type(table[k]) == "table" and type(v) == "table" then
			merge_all(table[k], v)
		else
			table[k] = v
		end
	end
	return table
end

local function deepcopy(original)
	local copy
	if type(original) == "table" then
		copy = {}
		for k, v in pairs(original) do
			copy[deepcopy(k)] = deepcopy(v)
		end
		setmetatable(copy, deepcopy(getmetatable(original)))
	else
		copy = original
	end
	return copy
end

local property = {
	playSide = {
		name = "Play Side",
		item = {
			_1p = {name = "1P", op = 900},
			_2p = {name = "2P", op = 901},
		}
	},
	stratchSide = {
		name = "Scratch Side",
		item = {
			default = {name = "Default", op = 902},
			left = {name = "Left", op = 903},
			right = {name = "Right", op = 904}
		}
	},
	scoreGraph = {
		name = "Score Graph",
		item = {
			off = {name = "Off", op = 905},
			normal = {name = "Normal", op = 906},
			slim = {name = "Slim", op = 907},
		}
	},
	scoreGraphPosition = {
		name = "Score Graph Position",
		item = {
			near = {name = "Near", op = 910},
			far = {name = "Far", op = 911},
		}
	},
	judgeDetail = {
		name = "Judge Detail",
		item = {
			off = {name = "Off", op = 912},
			fastSlow = {name = "FAST/SLOW", op = 913},
			ms = {name = "+-ms", op = 914}
		}
	},
	judgeDetailPosition = {
		name = "Judge Detail Position",
		item = {
			typeA = {name = "Type A (on judge)", op = 915},
			typeB = {name = "Type B (side of judge)", op = 916},
			typeC = {name = "Type C (side of judgeline)", op = 917},
		}
	},
	ghostScore = {
		name = "Ghost Score",
		item = {
			off = {name = "Off", op = 920},
			target = {name = "Target", op = 921},
			mybest = {name = "Mybest", op = 922}
		}
	},
	ghostScorePosition = {
		name = "Ghost Score Position",
		item = {
			typeA = {name = "Type A (on judge)", op = 925},
			typeB = {name = "Type B (side of judge)", op = 926},
			typeC = {name = "Type C (side of judgeline)", op = 927},
		}
	},
	ghostScoreColor = {
		name = "Ghost Score Color",
		item = {
			white = {name = "White", op = 930},
			red = {name = "Red When Losing", op = 931},
		}
	},
	playInfo = {
		name = "Play Info",
		item = {
			off = {name = "Off", op = 932},
			normal = {name = "Normal", op = 933},
			slim = {name = "Slim", op = 934},
		}
	},
	notesGraph = {
		name = "Notes Graph",
		item = {
			off = {name = "Off", op = 940},
			notesType = {name = "Notes Type", op = 941},
			judge = {name = "Judge", op = 942},
			fastSlow = {name = "FAST/SLOW", op = 943},
		}
	},
	timingVisualizer = {
		name = "Timing Visualizer",
		item = {
			off = {name = "Off", op = 945},
			on = {name = "On", op = 946}
		}
	},
	lowerLaneArea = {
		name = "Lower Lane Area",
		item = {
			notesGraphNotesType = {name = "Notesgraph Notes Type", op = 950},
			notesGraphJudge = {name = "Notesgraph Judge", op = 951},
			notesGraphFastSlow = {name = "Notesgraph FAST/SLOW", op = 952},
			timingVisualizer = {name = "Timing Visualizer", op = 953},
			customizedImage = {name = "Customized Image", op = 954},
			banner = {name = "Banner", op = 955},
		}
	},
	failedAnimation = {
		name = "Failed Animation",
		item = {
			fall = {name = "Fall", op = 960},
			verticalClose = {name = "Vertical Close", op = 961},
			horizontalClose = {name = "Horizontal Close", op = 962},
		}
	},
	hideFrames = { -- laneborderwhiteline,musicprogressbar,BGA,BPM,playinfoが対象 STAGEFILEは非対象
		name = "Hide Frames",
		item = {
			off = {name = "Off", op = 965},
			on = {name = "On", op = 966},
		}
	},
	total = {
		name = "Display #TOTAL",
		item = {
			off = {name = "Off", op = 967},
			on = {name = "On", op = 968},
		}
	},
}
local property_order = {
	"playSide",
	"stratchSide",
	"scoreGraph",
	"scoreGraphPosition",
	"judgeDetail",
	"judgeDetailPosition",
	"ghostScore",
	"ghostScorePosition",
	"ghostScoreColor",
	"playInfo",
	"notesGraph",
	"timingVisualizer",
	"lowerLaneArea",
	"failedAnimation",
	"hideFrames",
	"total"
}
-- 全itemに、そのオプションが選択中か返すisSelected()をセットする
for property_key, property_value in pairs(property) do
	for item_key, item_value in pairs(property_value.item) do
		property[property_key].item[item_key].isSelected = function()
			return skin_config.option[property_value.name] == item_value.op
		end
	end
end
-- skinセット用のpropertyテーブルを生成
local function skin_property()
	local result_property = {}
	for _, property_key in ipairs(property_order) do
		local p = {name = property[property_key].name, item = {}}
		for _, item_value in pairs(property[property_key].item) do
			table.insert(p.item, item_value)
		end
		table.sort(p.item, function(a, b) return (a.op < b.op) end)
		table.insert(result_property, p)
	end
	return result_property
end

local function is1P()
	return property.playSide.item._1p.isSelected()
end
local function is2P()
	return property.playSide.item._2p.isSelected()
end
local function isLeftScratch()
	return property.stratchSide.item.left.isSelected() or
		(property.playSide.item._1p.isSelected() and not property.stratchSide.item.right.isSelected())
end
local function isRightScratch()
	return property.stratchSide.item.right.isSelected() or
		(property.playSide.item._2p.isSelected() and not property.stratchSide.item.left.isSelected())
end
local function isScoreGraph()
	return not property.scoreGraph.item.off.isSelected()
end
local function isScoreGraphNormal()
	return property.scoreGraph.item.normal.isSelected()
end
local function isScoreGraphSlim()
	return property.scoreGraph.item.slim.isSelected()
end
local function isScoreGraphNear()
	return property.scoreGraphPosition.item.near.isSelected()
end
local function isScoreGraphFar()
	return property.scoreGraphPosition.item.far.isSelected()
end

local filepath = {
	{name = "Background", path = "customize/background/*.png", def = "gray"},
	{name = "Failed", path = "customize/failed/*.png", def = "black"},
	{name = "Notes", path = "customize/notes/*.png", def = "default"},
	{name = "Mine", path = "customize/mine/*.png", def = "red"},
	{name = "Glow", path = "customize/glow/*.png", def = "default"},
	{name = "Judge", path = "customize/judge/*.png", def = "SquadaOne"},
	{name = "Keybeam", path = "customize/keybeam/*.png", def = "default"},
	{name = "Bomb", path = "customize/bomb/*.png", def = "explosion"},
	{name = "LaneCover", path = "customize/lanecover/*.png", def = "default"},
	{name = "HiddenCover", path = "customize/hiddencover/*.png", def = "default"},
	{name = "LiftCover", path = "customize/liftcover/*.png", def = "default"},
	{name = "Gauge", path = "customize/gauge/*.png", def = "dotgradation"},
	{name = "LowerLaneArea Image", path = "customize/lowerlanearea/*.png"},
	{name = "ScoreGraph Background", path = "customize/scoregraph/*.png", def = "default"},
}

local offset_source = {
	{key = "lane", name = "Lane offset(%)", id = 40, w = true},
	{key = "lane_darkness", name = "Lane darkness(0~255)", id = 41, a = true},
	{key = "keybeam", name = "Keybeam offset", id = 42, h = true, a = true},
	{key = "judge", name = "Judge size offset", id = 43, w = true},
	{key = "bomb", name = "Bomb size offset", id = 44, w = true},
	{key = "bga", name = "BGA offset", id = 45, x = true, y = true, w = true, h = true--[[, a = true]]},
	{key = "bga_darkness", name = "BGA darkness(0~255)", id = 46, a = true},
	{key = "bga_header", name = "BGA Header offset", id = 47, a = true},
	{key = "bpm", name = "BPM offset", id = 48, x = true, y = true, a = true},
	{key = "notesgraph", name = "NotesGraph offset", id = 49, x = true, y = true, w = true, h = true, a = true},
	{key = "timingvisualizer", name = "Timing Visualizer offset", id = 50, x = true, y = true, w = true, h = true, a = true},
	{key = "lowerlanearea_darkness", name = "LowerLaneArea darkness(0~255)", id = 51, a = true},
	{key = "scoregraph", name = "ScoreGraph offset", id = 52, w = true, a = true},
	{key = "scoregraph_darkness", name = "ScoreGraph darkness(0~255)", id = 53, a = true},
	{key = "playinfo", name = "PlayInfo offset", id = 54, x = true, y = true, --[[w = true,]] a = true}
}

local header = {
	type = 0,
	name = "GenericTheme",
	w = 1920,
	h = 1080,
	loadend = 3000,
	playstart = 1000,
	scene = 3600000,
	input = 500,
	close = 1500,
	fadeout = 1000,
	property = skin_property(),
	filepath = filepath,
	offset = offset_source
}

local function main(keysNumber)
	if keysNumber == 7 then
		header.name = header.name.." 7keys"
	elseif keysNumber == 5 then
		header.type = 1
		header.name = header.name.." 5keys"
		table.insert(header.filepath, {name = "5keysCover", path = "customize/5keyscover/*.png", def = "gradation"})
	end

	-- for header loading
	if not skin_config then
		return {
			skin = {},
			header = header
		}
	end

	local main_state = require("main_state")

	local skin = {}
	for k, v in pairs(header) do
		skin[k] = v
	end

	local offset = {}
	for i, v in ipairs(offset_source) do
		offset[v.key] = skin_config.offset[v.name]
		offset[v.key].id = v.id
	end

	-- geometry(ジオメトリ) 位置、サイズ等
	local geo = {}

	-- note geometry
	geo.note = {}
	geo.note.base_white_w = 60
	geo.note.base_black_w = 48
	geo.note.base_scratch_w = 108
	geo.note.scale_w = 1 + offset.lane.w / 100
	geo.note.white_w = geo.note.base_white_w * geo.note.scale_w
	geo.note.black_w = geo.note.base_black_w * geo.note.scale_w
	geo.note.scratch_w = geo.note.base_scratch_w * geo.note.scale_w

	-- lane and lanearea geometry
	geo.lanearea = {}
	geo.lanearea.x = 0
	geo.lanearea.padding_left = 54
	geo.lanearea.padding_right = 14
	if is2P() then
		geo.lanearea.padding_left, geo.lanearea.padding_right = geo.lanearea.padding_right, geo.lanearea.padding_left
	end

	geo.lane = {}
	geo.lane.separateline_w = 3
	geo.lane.y = 226
	geo.lane.w = geo.note.scratch_w + geo.note.white_w * 4 + geo.note.black_w * 3 + geo.lane.separateline_w * 7
	geo.lanearea.w = geo.lane.w + geo.lanearea.padding_left + geo.lanearea.padding_right
	geo.lane.h = header.h - geo.lane.y
	if is2P() then
		geo.lanearea.x = header.w - geo.lanearea.w
	end
	geo.lane.x = geo.lanearea.x + geo.lanearea.padding_left
	geo.lane.center_x = geo.lane.x + geo.lane.w / 2
	geo.lane.fivekeycover_w = geo.note.white_w + geo.note.black_w + geo.lane.separateline_w * 2

	geo.lane.order = {8, 1, 2, 3, 4, 5, 6, 7}
	if keysNumber == 5 then
		geo.lane.order = {6, 1, 2, 3, 4, 5}
	end
	if isRightScratch() then
		geo.lane.order = {1, 2, 3, 4, 5, 6, 7, 8}
		if keysNumber == 5 then
			geo.lane.order = {1, 2, 3, 4, 5, 6}
		end
	end

	geo.lane.each_w = {geo.note.white_w, geo.note.black_w, geo.note.white_w, geo.note.black_w, geo.note.white_w, geo.note.black_w, geo.note.white_w, geo.note.scratch_w}
	if keysNumber == 5 then
		geo.lane.each_w = {geo.note.white_w, geo.note.black_w, geo.note.white_w, geo.note.black_w, geo.note.white_w, geo.note.scratch_w}
	end

	geo.lane.each_x = {}
	geo.lane.each_x[geo.lane.order[1]] = geo.lane.x
	if keysNumber == 5 and isRightScratch() then
		geo.lane.each_x[geo.lane.order[1]] = geo.lane.x + geo.note.white_w + geo.note.black_w + geo.lane.separateline_w
	end
	for i = 2, #geo.lane.order do
		geo.lane.each_x[geo.lane.order[i]] = geo.lane.each_x[geo.lane.order[i-1]] + geo.lane.each_w[geo.lane.order[i-1]] + geo.lane.separateline_w
	end

	-- scoregraph geometry
	geo.scoregrapharea = {}
	geo.scoregrapharea.w = 0
	if isScoreGraph() then
		geo.scoregraph = {}
		if isScoreGraphNormal() then
			geo.scoregraph.bar_w = 58
		else
			geo.scoregraph.bar_w = 28
		end
		geo.scoregraph.bar_w = geo.scoregraph.bar_w + offset.scoregraph.w
		geo.scoregraph.bar_h = 740
		geo.scoregraph.bar_space = 4
		geo.scoregraph.w = geo.scoregraph.bar_w * 4 + geo.scoregraph.bar_space * 3
		geo.scoregraph.h = geo.scoregraph.bar_h + 20

		local scoregraph_margin_x = 6

		geo.scoregrapharea.w = geo.scoregraph.w + scoregraph_margin_x * 2
		if is1P() then
			if isScoreGraphNear() then
				geo.scoregrapharea.x = geo.lanearea.x + geo.lanearea.w
			else
				geo.scoregrapharea.x = header.w - geo.scoregrapharea.w
			end
		else
			if isScoreGraphNear() then
				geo.scoregrapharea.x = geo.lanearea.x - geo.scoregrapharea.w
			else
				geo.scoregrapharea.x = 0
			end
		end

		geo.scoregraph.x = geo.scoregrapharea.x + scoregraph_margin_x
		geo.scoregraph.y = 220
	end

	-- bga and bgaarea geometry
	geo.bgaarea = {}
	if is1P() then
		geo.bgaarea.x = geo.lanearea.x + geo.lanearea.w
		if isScoreGraph() and isScoreGraphNear() then
			geo.bgaarea.x = geo.bgaarea.x + geo.scoregrapharea.w
		end
	else
		geo.bgaarea.x = 0
		if isScoreGraph() and isScoreGraphFar() then
			geo.bgaarea.x = geo.bgaarea.x + geo.scoregrapharea.w
		end
	end
	geo.bgaarea.w = header.w - (geo.lanearea.w + geo.scoregrapharea.w)
	geo.bgaarea.center_x = geo.bgaarea.x + geo.bgaarea.w / 2

	geo.bga = {}
	geo.bga.frame_w = 10
	geo.bga.frame_h = 8
	geo.bga.w = 1152
	if geo.bgaarea.w - geo.bga.frame_w * 2 < geo.bga.w then
		geo.bga.w = geo.bgaarea.w - geo.bga.frame_w * 2
	end
	geo.bga.h = 864
	geo.bga.x = geo.bgaarea.center_x - geo.bga.w / 2
	geo.bga.y = 108
	geo.bga.center_x = geo.bga.x + geo.bga.w / 2
	geo.bga.center_y = geo.bga.y + geo.bga.h / 2

  skin.source = {
		{id = "src_background", path = "customize/background/*.png"},
		{id = "src_failed", path = "customize/failed/*.png"},
		{id = "src_notes", path = "customize/notes/*.png"},
		{id = "src_mine", path = "customize/mine/*.png"},
		{id = "src_gauge", path = "customize/gauge/*.png"},
		{id = "src_glow", path = "customize/glow/*.png"},
		{id = "src_judge", path = "customize/judge/*.png"},
		{id = "src_keybeam", path = "customize/keybeam/*.png"},
		{id = "src_bomb", path = "customize/bomb/*.png"},
		{id = "src_lanecover", path = "customize/lanecover/*.png"},
		{id = "src_hiddencover", path = "customize/hiddencover/*.png"},
		{id = "src_liftcover", path = "customize/liftcover/*.png"},
		{id = "src_lowerlanearea_customizedimage", path = "customize/lowerlanearea/*.png"},
		{id = "src_scoregraph_background", path = "customize/scoregraph/*.png"},

		{id = "src_number_newtown", path = "parts/number/newtown.png"},
		{id = "src_number_kenney_future", path = "parts/number/kenney_future_custom.png"},
		{id = "src_number_genshin_monospace_border", path = "parts/number/genshin_monospace_border.png"},
		{id = "src_number_genshin_monospace_border_red", path = "parts/number/genshin_monospace_border_red.png"},
		{id = "src_number_dot", path = "parts/number/dot.png"},
		{id = "src_rank_random", path = "parts/rank_random.png"},

		{id = "src_frame_lane", path = "parts/frame_lane.png"},
		{id = "src_frame_bga", path = "parts/frame_bga.png"},
		{id = "src_frame_bpm", path = "parts/frame_bpm.png"},

		{id = "src_titlegradation_header", path = "parts/titlegradation_header.png"},
		{id = "src_titlegradation_standby", path = "parts/titlegradation_standby.png"},

		{id = "src_fullcombo_glow", path = "parts/fullcombo/glow.png"},
		{id = "src_fullcombo_circle", path = "parts/fullcombo/circle.png"},
		{id = "src_fullcombo_ring", path = "parts/fullcombo/ring.png"},
		{id = "src_fullcombo_text", path = "parts/fullcombo/text.png"},

		{id = "src_judgeline", path = "parts/judgeline.png"},
		{id = "src_progress", path = "parts/progress.png"},
		{id = "src_difficulty", path = "parts/difficulty.png"},
		{id = "src_white1dot", path = "parts/white1dot.png"},
		{id = "src_stagetext", path = "parts/stagetext.png"},
		{id = "src_othertexts", path = "parts/othertexts.png"},
		{id = "src_scoregraph_text", path = "parts/scoregraph_text.png"},
		{id = "src_fastslow", path = "parts/fast_slow.png"},
		{id = "src_ready_finish", path = "parts/ready_finish.png"},
	}
	if keysNumber == 5 then
		table.insert(skin.source, {id = "src_5keyscover", path = "customize/5keyscover/*.png"})
	end

  skin.font = {
		{id = "genshin_bold", path = "../common/font/GenShinGothic-Bold.ttf"},
		{id = "newtown", path = "../common/font/Newtown-8e6M.ttf"},
  }

  skin.image = {
		{id = "text_image_dot", src = "src_othertexts", x = 0, y = 0, w = 70, h = 70},
		{id = "text_image_%", src = "src_othertexts", x = 0, y = 70 * 2, w = 80, h = 70},
	}

	local function number(t)
		local number_size = {
			src_number_newtown = {w = 70, h = 70},
			src_number_kenney_future = {w = 70, h = 70},
			src_number_genshin = {w = 50, h = 70},
			src_number_genshin_monospace_border = {w = 45, h = 70},
			src_number_genshin_monospace_border_red = {w = 45, h = 70},
			src_number_dot = {w = 16, h = 19},
		}
		local number_y = 0
		local size = number_size[t.src]

		local divx = 10 local divy = 1
		if t.divx then
			divx = t.divx
		end
		if t.divy then
			divy = t.divy
		end
		return merge_all(t, {x = 0, y = number_y, w = size.w * divx, h = size.h * divy})
	end
	skin.value = {}

	skin.text = {}
	skin.imageset = {}
	skin.slider = {}
	skin.liftCover = {}
	skin.hiddenCover = {}
	skin.graph = {}
	skin.bga = {id = "bga"}
	skin.judgegraph = {}
	skin.bpmgraph = {}
	skin.timingvisualizer = {}

	do
		local white_x = 216	local black_x = 276	local scratch_x = 108
		local note_y = 0
		local lne_y = 36 local lns_y = 72 local lnb_y = 108 local lna_y = 144
		local hcne_y = 216 local hcns_y = 252 local hcnb_y = 288 local hcna_y = 306 local hcnr_y = 306 local hcnd_y = 342
		--[[if isModernChic then
			hcne_y = 216 hcns_y = 252 hcnb_y = 108 hcna_y = 288 hcnr_y = 288 hcnd_y = 324
		end]]
		local ln_cycle = 256
		append_all(skin.image, {
			-- normal note
			{id = "note_w", src = "src_notes", x = white_x, y = note_y, w = geo.note.base_white_w, h = 36},
			{id = "note_b", src = "src_notes", x = black_x, y = note_y, w = geo.note.base_black_w, h = 36},
			{id = "note_s", src = "src_notes", x = scratch_x, y = note_y, w = geo.note.base_scratch_w, h = 36},
			-- ln end
			{id = "lne_w", src = "src_notes", x = white_x, y = lne_y, w = geo.note.base_white_w, h = 36},
			{id = "lne_b", src = "src_notes", x = black_x, y = lne_y, w = geo.note.base_black_w, h = 36},
			{id = "lne_s", src = "src_notes", x = scratch_x, y = lne_y, w = geo.note.base_scratch_w, h = 36},
			-- ln start
			{id = "lns_w", src = "src_notes", x = white_x, y = lns_y, w = geo.note.base_white_w, h = 36},
			{id = "lns_b", src = "src_notes", x = black_x, y = lns_y, w = geo.note.base_black_w, h = 36},
			{id = "lns_s", src = "src_notes", x = scratch_x, y = lns_y, w = geo.note.base_scratch_w, h = 36},
			-- ln body (inactive/未入力)
			{id = "lnb_w", src = "src_notes", x = white_x, y = lnb_y, w = geo.note.base_white_w, h = 36},
			{id = "lnb_b", src = "src_notes", x = black_x, y = lnb_y, w = geo.note.base_black_w, h = 36},
			{id = "lnb_s", src = "src_notes", x = scratch_x, y = lnb_y, w = geo.note.base_scratch_w, h = 36},
			-- ln body (active/入力中)
			{id = "lna_w", src = "src_notes", x = white_x, y = lna_y, w = geo.note.base_white_w, h = 72, divy = 2, cycle = ln_cycle},
			{id = "lna_b", src = "src_notes", x = black_x, y = lna_y, w = geo.note.base_black_w, h = 72, divy = 2, cycle = ln_cycle},
			{id = "lna_s", src = "src_notes", x = scratch_x, y = lna_y, w = geo.note.base_scratch_w, h = 72, divy = 2, cycle = ln_cycle},
			-- hcn end
			{id = "hcne_w", src = "src_notes", x = white_x, y = hcne_y, w = geo.note.base_white_w, h = 36},
			{id = "hcne_b", src = "src_notes", x = black_x, y = hcne_y, w = geo.note.base_black_w, h = 36},
			{id = "hcne_s", src = "src_notes", x = scratch_x, y = hcne_y, w = geo.note.base_scratch_w, h = 36},
			-- hcn start
			{id = "hcns_w", src = "src_notes", x = white_x, y = hcns_y, w = geo.note.base_white_w, h = 36},
			{id = "hcns_b", src = "src_notes", x = black_x, y = hcns_y, w = geo.note.base_black_w, h = 36},
			{id = "hcns_s", src = "src_notes", x = scratch_x, y = hcns_y, w = geo.note.base_scratch_w, h = 36},
			-- hcn body (inactive)
			{id = "hcnb_w", src = "src_notes", x = white_x, y = hcnb_y, w = geo.note.base_white_w, h = 18},
			{id = "hcnb_b", src = "src_notes", x = black_x, y = hcnb_y, w = geo.note.base_black_w, h = 18},
			{id = "hcnb_s", src = "src_notes", x = scratch_x, y = hcnb_y, w = geo.note.base_scratch_w, h = 18},
			-- hcn body (active)
			{id = "hcna_w", src = "src_notes", x = white_x, y = hcna_y, w = geo.note.base_white_w, h = 36, divy = 2, cycle = ln_cycle},
			{id = "hcna_b", src = "src_notes", x = black_x, y = hcna_y, w = geo.note.base_black_w, h = 36, divy = 2, cycle = ln_cycle},
			{id = "hcna_s", src = "src_notes", x = scratch_x, y = hcna_y, w = geo.note.base_scratch_w, h = 36, divy = 2, cycle = ln_cycle},
			-- hcn body (reactive/途中から入力)
			{id = "hcnr_w", src = "src_notes", x = white_x, y = hcnr_y, w = geo.note.base_white_w, h = 36, divy = 2, cycle = ln_cycle},
			{id = "hcnr_b", src = "src_notes", x = black_x, y = hcnr_y, w = geo.note.base_black_w, h = 36, divy = 2, cycle = ln_cycle},
			{id = "hcnr_s", src = "src_notes", x = scratch_x, y = hcnr_y, w = geo.note.base_scratch_w, h = 36, divy = 2, cycle = ln_cycle},
			-- hcn damage (miss)
			{id = "hcnd_w", src = "src_notes", x = white_x, y = hcnd_y, w = geo.note.base_white_w, h = 36, divy = 2, cycle = ln_cycle / 2},
			{id = "hcnd_b", src = "src_notes", x = black_x, y = hcnd_y, w = geo.note.base_black_w, h = 36, divy = 2, cycle = ln_cycle / 2},
			{id = "hcnd_s", src = "src_notes", x = scratch_x, y = hcnd_y, w = geo.note.base_scratch_w, h = 36, divy = 2, cycle = ln_cycle / 2},
			-- mine
			{id = "mine_w", src = "src_mine", x = white_x, y = 0, w = geo.note.base_white_w, h = 36},
			{id = "mine_b", src = "src_mine", x = black_x, y = 0, w = geo.note.base_black_w, h = 36},
			{id = "mine_s", src = "src_mine", x = scratch_x, y = 0, w = geo.note.base_scratch_w, h = 36},

			{id = "section_line", src = "src_white1dot", x = 0, y = 0, w = 1, h = 1},
		})

		local sectionline_h = 3
		skin.note = {
			id = "notes",
			note = {"note_w", "note_b", "note_w", "note_b", "note_w", "note_b", "note_w", "note_s"},
			lnend = {"lne_w", "lne_b", "lne_w", "lne_b", "lne_w", "lne_b", "lne_w", "lne_s"},
			lnstart = {"lns_w", "lns_b", "lns_w", "lns_b", "lns_w", "lns_b", "lns_w", "lns_s"},
			lnbody = {"lnb_w", "lnb_b", "lnb_w", "lnb_b", "lnb_w", "lnb_b", "lnb_w", "lnb_s"},
			lnbodyActive = {"lna_w", "lna_b", "lna_w", "lna_b", "lna_w", "lna_b", "lna_w", "lna_s"},
			hcnend = {"hcne_w", "hcne_b", "hcne_w", "hcne_b", "hcne_w", "hcne_b", "hcne_w", "hcne_s"},
			hcnstart = {"hcns_w", "hcns_b", "hcns_w", "hcns_b", "hcns_w", "hcns_b", "hcns_w", "hcns_s"},
			hcnbody = {"hcnb_w", "hcnb_b", "hcnb_w", "hcnb_b", "hcnb_w", "hcnb_b", "hcnb_w", "hcnb_s"},
			hcnbodyActive = {"hcna_w", "hcna_b", "hcna_w", "hcna_b", "hcna_w", "hcna_b", "hcna_w", "hcna_s"},
			hcnbodyMiss = {"hcnd_w", "hcnd_b", "hcnd_w", "hcnd_b", "hcnd_w", "hcnd_b", "hcnd_w", "hcnd_s"},
			hcnbodyReactive = {"hcnr_w", "hcnr_b", "hcnr_w", "hcnr_b", "hcnr_w", "hcnr_b", "hcnr_w", "hcnr_s"},
			mine = {"mine_w", "mine_b", "mine_w", "mine_b", "mine_w", "mine_b", "mine_w", "mine_s"},

			hidden = {},
			processed = {},
			size = {},
			dst = {
				{x = geo.lane.each_x[1], y = geo.lane.y - 12, w = geo.note.white_w, h = geo.lane.h},
				{x = geo.lane.each_x[2], y = geo.lane.y - 12, w = geo.note.black_w, h = geo.lane.h},
				{x = geo.lane.each_x[3], y = geo.lane.y - 12, w = geo.note.white_w, h = geo.lane.h},
				{x = geo.lane.each_x[4], y = geo.lane.y - 12, w = geo.note.black_w, h = geo.lane.h},
				{x = geo.lane.each_x[5], y = geo.lane.y - 12, w = geo.note.white_w, h = geo.lane.h},
				{x = geo.lane.each_x[6], y = geo.lane.y - 12, w = geo.note.black_w, h = geo.lane.h},
				{x = geo.lane.each_x[7], y = geo.lane.y - 12, w = geo.note.white_w, h = geo.lane.h},
				{x = geo.lane.each_x[8], y = geo.lane.y - 12, w = geo.note.scratch_w, h = geo.lane.h},
			},
			-- idにdestinationの特殊番号(-111など)は使えないっぽい(NPEになる)
			-- h = 1だとHD画質などの低解像度で描画されない場合がある。
			group = {
				{id = "section_line", offset = 3, dst = {
					{x = geo.lane.x, y = geo.lane.y, w = geo.lane.w, h = sectionline_h, r = 128, g = 128, b = 128}
				}}
			},
			time = {
				{id = "section_line", offset = 3, dst = {
					{x = geo.lane.x, y = geo.lane.y, w = geo.lane.w, h = sectionline_h, r = 64, g = 192, b = 192}
				}}
			},
			bpm = {
				{id = "section_line", offset = 3, dst = {
					{x = geo.lane.x, y = geo.lane.y, w = geo.lane.w, h = sectionline_h, r = 0, g = 192, b = 0}
				}}
			},
			stop = {
				{id = "section_line", offset = 3, dst = {
					{x = geo.lane.x, y = geo.lane.y, w = geo.lane.w, h = sectionline_h, r = 192, g = 192, b = 0}
				}}
			},
		}
		if keysNumber == 5 then
			skin.note.note = {"note_w", "note_b", "note_w", "note_b", "note_w", "note_s"}
			skin.note.lnend = {"lne_w", "lne_b", "lne_w", "lne_b", "lne_w", "lne_s"}
			skin.note.lnstart = {"lns_w", "lns_b", "lns_w", "lns_b", "lns_w", "lns_s"}
			skin.note.lnbody = {"lnb_w", "lnb_b", "lnb_w", "lnb_b", "lnb_w", "lnb_s"}
			skin.note.lnbodyActive = {"lna_w", "lna_b", "lna_w", "lna_b", "lna_w", "lna_s"}
			skin.note.hcnend = {"hcne_w", "hcne_b", "hcne_w", "hcne_b", "hcne_w", "hcne_s"}
			skin.note.hcnstart = {"hcns_w", "hcns_b", "hcns_w", "hcns_b", "hcns_w", "hcns_s"}
			skin.note.hcnbody = {"hcnb_w", "hcnb_b", "hcnb_w", "hcnb_b", "hcnb_w", "hcnb_s"}
			skin.note.hcnbodyActive = {"hcna_w", "hcna_b", "hcna_w", "hcna_b", "hcna_w", "hcna_s"}
			skin.note.hcnbodyMiss = {"hcnd_w", "hcnd_b", "hcnd_w", "hcnd_b", "hcnd_w", "hcnd_s"}
			skin.note.hcnbodyReactive = {"hcnr_w", "hcnr_b", "hcnr_w", "hcnr_b", "hcnr_w", "hcnr_s"}
			skin.note.mine = {"mine_w", "mine_b", "mine_w", "mine_b", "mine_w", "mine_s"}

			skin.note.dst = {
				{x = geo.lane.each_x[1], y = geo.lane.y - 12, w = geo.note.white_w, h = geo.lane.h},
				{x = geo.lane.each_x[2], y = geo.lane.y - 12, w = geo.note.black_w, h = geo.lane.h},
				{x = geo.lane.each_x[3], y = geo.lane.y - 12, w = geo.note.white_w, h = geo.lane.h},
				{x = geo.lane.each_x[4], y = geo.lane.y - 12, w = geo.note.black_w, h = geo.lane.h},
				{x = geo.lane.each_x[5], y = geo.lane.y - 12, w = geo.note.white_w, h = geo.lane.h},
				{x = geo.lane.each_x[6], y = geo.lane.y - 12, w = geo.note.scratch_w, h = geo.lane.h},
			}
		end
	end

	do
		local w = 8 local h = 35
		append_all(skin.image, {
			{id = "gauge_r1", src = "src_gauge", x = 0, y = 0, w = w, h = h},
			{id = "gauge_r2", src = "src_gauge", x = 0 + 16, y = 0, w = w, h = h},

			{id = "gauge_b1", src = "src_gauge", x = 8, y = 0, w = w, h = h},
			{id = "gauge_b2", src = "src_gauge", x = 8 + 16, y = 0, w = w, h = h},

			{id = "gauge_g1", src = "src_gauge", x = 32, y = 0, w = w, h = h},
			{id = "gauge_g2", src = "src_gauge", x = 32 + 16, y = 0, w = w, h = h},

			{id = "gauge_p1", src = "src_gauge", x = 40, y = 0, w = w, h = h},
			{id = "gauge_p2", src = "src_gauge", x = 40 + 16, y = 0, w = w, h = h},

			{id = "gauge_y1", src = "src_gauge", x = 0, y = 35, w = w, h = h},
			{id = "gauge_y2", src = "src_gauge", x = 0 + 16, y = 35, w = w, h = h},

			{id = "gauge_h1", src = "src_gauge", x = 64, y = 0, w = w, h = h},
			{id = "gauge_h2", src = "src_gauge", x = 64 + 16, y = 0, w = w, h = h},
		})

		skin.gauge = {
			id = "gauge",
			nodes = {
				-- overclear(light), underclear(light), overclear(dark), underclear(dark), overclear(top), underclear(top)
				-- assisted easy
				"gauge_r1", "gauge_p1", "gauge_r2", "gauge_p2", "gauge_r1", "gauge_p1",
				-- easy
				"gauge_r1", "gauge_g1", "gauge_r2", "gauge_g2", "gauge_r1", "gauge_g2",
				-- normal
				"gauge_r1", "gauge_b1", "gauge_r2", "gauge_b2", "gauge_r1", "gauge_b1",
				-- hard
				"gauge_r1", "gauge_r1", "gauge_r2", "gauge_r2", "gauge_r1", "gauge_r1",
				-- exhard
				"gauge_y1", "gauge_y1", "gauge_y2", "gauge_y2", "gauge_y1", "gauge_y1",
				-- hazard
				"gauge_h1", "gauge_h1", "gauge_h2", "gauge_h2", "gauge_h1", "gauge_h1",
			}
		}
	end

	geo.judge = {}
	geo.judge.scale = 1 + offset.judge.w / 100
	geo.judge.y = geo.lane.y + 140
	geo.judge.h = 84 * geo.judge.scale
	do
		local offset_x, num_space = 0, 0
		local between_space = 10
		local path = string.match(skin_config.get_path("customize/judge/" .. skin_config.file_path["Judge"]), "(.+)%.png$") .. ".lua"
		local exist, setting = pcall(dofile, path)
		if exist and setting then
			if setting.offset_x then offset_x = setting.offset_x end
			if setting.num_space then num_space = setting.num_space end
			if setting.between_space then between_space = setting.between_space end
		end

		local f_w = 227
		append_all(skin.image, {
			{id = "judge_f_pg", src = "src_judge", x = 0, y = 0, w = f_w, h = 252, divy = 3, cycle = 120},
			{id = "judge_f_gr", src = "src_judge", x = 0, y = 252, w = f_w, h = 168, divy = 2, cycle = 80},
			{id = "judge_f_gd", src = "src_judge", x = 0, y = 420, w = f_w, h = 168, divy = 2, cycle = 80},
			{id = "judge_f_bd", src = "src_judge", x = 227, y = 420, w = f_w, h = 168, divy = 2, cycle = 80},
			{id = "judge_f_pr", src = "src_judge", x = 454, y = 420, w = f_w, h = 168, divy = 2, cycle = 80},
			{id = "judge_f_ms", src = "src_judge", x = 454, y = 420, w = f_w, h = 168, divy = 2, cycle = 80},
		})

		local n_w = 55
		local n_total_w = n_w * 10
		num_space = num_space * geo.judge.scale
		append_all(skin.value, {
			{id = "judge_n_pg", src = "src_judge", x = 227, y = 0, w = n_total_w, h = 252, divx = 10, divy = 3, digit = 6, ref = 75, cycle = 120, space = num_space},
			{id = "judge_n_gr", src = "src_judge", x = 227, y = 252, w = n_total_w, h = 168, divx = 10, divy = 2, digit = 6, ref = 75, cycle = 80, space = num_space},
			{id = "judge_n_gd", src = "src_judge", x = 227, y = 252, w = n_total_w, h = 168, divx = 10, divy = 2, digit = 6, ref = 75, cycle = 80, space = num_space},
			{id = "judge_n_bd", src = "src_judge", x = 227, y = 252, w = n_total_w, h = 168, divx = 10, divy = 2, digit = 6, ref = 75, cycle = 80, space = num_space},
			{id = "judge_n_pr", src = "src_judge", x = 227, y = 252, w = n_total_w, h = 168, divx = 10, divy = 2, digit = 6, ref = 75, cycle = 80, space = num_space},
			{id = "judge_n_ms", src = "src_judge", x = 227, y = 252, w = n_total_w, h = 168, divx = 10, divy = 2, digit = 6, ref = 75, cycle = 80, space = num_space},
		})
		
		f_w = f_w * geo.judge.scale
		n_w = n_w * geo.judge.scale
		offset_x = offset_x * geo.judge.scale
		between_space = between_space * geo.judge.scale

		local f_x = geo.lane.center_x -(f_w + between_space - num_space * 1.5) / 2 + offset_x -- why 1.5?
		if keysNumber == 5 then
			if isLeftScratch() then
				f_x = f_x - geo.lane.fivekeycover_w / 2
			else
				f_x = f_x + geo.lane.fivekeycover_w / 2
			end
		end
		local n_x = f_w + between_space - num_space * 4.5 -- why 4.5?
		local n_y = 0
    local looptime = 500
		skin.judge = {
			{
				id = "judge",
				index = 0,
				images = {
					{id = "judge_f_pg", loop = -1, timer = 46, offsets = {3, 32}, dst = {
						{time = 0, x = f_x, y = geo.judge.y, w = f_w, h = geo.judge.h},
						{time = looptime}
					}},
					{id = "judge_f_gr", loop = -1, timer = 46, offsets = {3, 32}, dst = {
						{time = 0, x = f_x, y = geo.judge.y, w = f_w, h = geo.judge.h},
						{time = looptime}
					}},
					{id = "judge_f_gd", loop = -1, timer = 46, offsets = {3, 32}, dst = {
						{time = 0, x = f_x, y = geo.judge.y, w = f_w, h = geo.judge.h},
						{time = looptime}
					}},
					{id = "judge_f_bd", loop = -1, timer = 46, offsets = {3, 32}, dst = {
						{time = 0, x = f_x, y = geo.judge.y, w = f_w, h = geo.judge.h},
						{time = looptime}
					}},
					{id = "judge_f_pr", loop = -1, timer = 46, offsets = {3, 32}, dst = {
						{time = 0, x = f_x, y = geo.judge.y, w = f_w, h = geo.judge.h},
						{time = looptime}
					}},
					{id = "judge_f_ms", loop = -1, timer = 46, offsets = {3, 32}, dst = {
						{time = 0, x = f_x, y = geo.judge.y, w = f_w, h = geo.judge.h},
						{time = looptime}
					}}
				},
				numbers = {
					{id = "judge_n_pg", loop = -1, offset = 32, timer = 46, dst = {
						{time = 0, x = n_x, y = n_y, w = n_w, h = geo.judge.h},
						{time = looptime}
					}},
					{id = "judge_n_gr", loop = -1, offset = 32, timer = 46, dst = {
						{time = 0, x = n_x, y = n_y, w = n_w, h = geo.judge.h},
						{time = looptime}
					}},
					{id = "judge_n_gd", loop = -1, offset = 32, timer = 46, dst = {
						{time = 0, x = n_x, y = n_y, w = n_w, h = geo.judge.h},
						{time = looptime}
					}},
					{id = "judge_n_bd", loop = -1, offset = 32, timer = 46, dst = {
						{time = 0, x = n_x, y = n_y, w = n_w, h = geo.judge.h},
						{time = looptime}
					}},
					{id = "judge_n_pr", loop = -1, offset = 32, timer = 46, dst = {
						{time = 0, x = n_x, y = n_y, w = n_w, h = geo.judge.h},
						{time = looptime}
					}},
					{id = "judge_n_ms", loop = -1, offset = 32, timer = 46, dst = {
						{time = 0, x = n_x, y = n_y, w = n_w, h = geo.judge.h},
						{time = looptime}
					}}
				},
				shift = true
			}
		}
	end

	skin.destination = {}

	local function frame_dst(x, y, w, h, a, thickness_w, thickness_h, dst_additional_params)
		x = math.floor(x) y = math.floor(y) -- 小数による座標ズレ防止
		w = math.floor(w)	h = math.floor(h)
		thickness_w = math.floor(thickness_w)	thickness_h = math.floor(thickness_h)
		local frame_id = "_"..x..y..w..h..thickness_w..thickness_h
		local src = "src_frame_bga"
		local img_w = 1182 local img_h = 880
		local img_thickness_w = thickness_w + 4 local img_thickness_h = thickness_h + 4 -- コーナーのぼかしを上手く入れる調整
		append_all(skin.image, {
			{id = "frame_corner_upperleft"..frame_id, src = src, x = 0, y = 0, w = img_thickness_w, h = img_thickness_h},
			{id = "frame_corner_upperright"..frame_id, src = src, x = img_w - img_thickness_w, y = 0, w = img_thickness_w, h = img_thickness_h},
			{id = "frame_corner_lowerleft"..frame_id, src = src, x = 0, y = img_h - img_thickness_h, w = img_thickness_w, h = img_thickness_h},
			{id = "frame_corner_lowerright"..frame_id, src = src, x = img_w - img_thickness_w, y = img_h - img_thickness_h, w = img_thickness_w, h = img_thickness_h},

			{id = "frame_straight_upper"..frame_id, src = src, x = img_thickness_w, y = 0, w = img_w - img_thickness_w * 2, h = img_thickness_h},
			{id = "frame_straight_lower"..frame_id, src = src, x = img_thickness_w, y = img_h - img_thickness_h, w = img_w - img_thickness_w * 2, h = img_thickness_h},
			{id = "frame_straight_left"..frame_id, src = src, x = 0, y = img_thickness_h, w = img_thickness_w, h = img_h - img_thickness_h * 2},
			{id = "frame_straight_right"..frame_id, src = src, x = img_w - img_thickness_w, y = img_thickness_h, w = img_thickness_w, h = img_h - img_thickness_h * 2},
		})

		local dst = {
			{id = "frame_corner_upperleft"..frame_id, dst = {
				{x = x, y = y + h - thickness_h, w = thickness_w, h = thickness_h}
			}},
			{id = "frame_corner_upperright"..frame_id, dst = {
				{x = x + w - thickness_w, y = y + h - thickness_h, w = thickness_w, h = thickness_h}
			}},
			{id = "frame_corner_lowerleft"..frame_id, dst = {
				{x = x, y = y, w = thickness_w, h = thickness_h}
			}},
			{id = "frame_corner_lowerright"..frame_id, dst = {
				{x = x + w - thickness_w, y = y, w = thickness_w, h = thickness_h}
			}},

			{id = "frame_straight_upper"..frame_id, dst = {
				{x = x + thickness_w, y = y + h - thickness_h, w = w - thickness_w * 2, h = thickness_h}
			}},
			{id = "frame_straight_lower"..frame_id, dst = {
				{x = x + thickness_w, y = y, w = w - thickness_w * 2, h = thickness_h}
			}},
			{id = "frame_straight_left"..frame_id, dst = {
				{x = x, y = y + thickness_h, w = thickness_w, h = h - thickness_h * 2}
			}},
			{id = "frame_straight_right"..frame_id, dst = {
				{x = x + w - thickness_w, y = y + thickness_h, w = thickness_w, h = h - thickness_h * 2}
			}},
		}
		for i, v in ipairs(dst) do
			dst[i] = merge_all(v, dst_additional_params)
			dst[i].dst[1].a = a
		end

		return dst
	end

	geo.playinfo = {}
	geo.playinfo.line_h = 22
	geo.playinfo.separateline_h = 4
	geo.playinfo.h = geo.playinfo.line_h * 9 + geo.playinfo.separateline_h
	local playinfo_defined = false
	-- playinfo表示関数
	local function playinfo_dst(x, y, w, a, isSimple, dst_additional_params)
		local text_img_w = 114 local text_img_h = 70
		if not playinfo_defined then
			local number_src = "src_number_genshin_monospace_border"
			append_all(skin.value, {
				number({id = "count_pg", src = number_src, divx = 10, digit = 4, ref = 110}),
				number({id = "count_gr", src = number_src, divx = 10, digit = 4, ref = 111}),
				number({id = "count_gd", src = number_src, divx = 10, digit = 4, ref = 112}),
				number({id = "count_bd", src = number_src, divx = 10, digit = 4, ref = 113}),
				number({id = "count_pr", src = number_src, divx = 10, digit = 4, ref = 114}),
				number({id = "count_kp", src = number_src, divx = 10, digit = 4, ref = 420}),
				number({id = "count_cb", src = number_src, divx = 10, digit = 4, ref = 425}),

				number({id = "count_fast_pg", src = number_src, divx = 10, digit = 4, ref = 410}),
				number({id = "count_fast_gr", src = number_src, divx = 10, digit = 4, ref = 412}),
				number({id = "count_fast_gd", src = number_src, divx = 10, digit = 4, ref = 414}),
				number({id = "count_fast_bd", src = number_src, divx = 10, digit = 4, ref = 416}),
				number({id = "count_fast_pr", src = number_src, divx = 10, digit = 4, ref = 418}),
				number({id = "count_fast_kp", src = number_src, divx = 10, digit = 4, ref = 421}),

				number({id = "count_slow_pg", src = number_src, divx = 10, digit = 4, ref = 411}),
				number({id = "count_slow_gr", src = number_src, divx = 10, digit = 4, ref = 413}),
				number({id = "count_slow_gd", src = number_src, divx = 10, digit = 4, ref = 415}),
				number({id = "count_slow_bd", src = number_src, divx = 10, digit = 4, ref = 417}),
				number({id = "count_slow_pr", src = number_src, divx = 10, digit = 4, ref = 419}),
				number({id = "count_slow_kp", src = number_src, divx = 10, digit = 4, ref = 422}),

				number({id = "timeleft_m", src = number_src, divx = 10, digit = 2, ref = 163}),
				number({id = "timeleft_s", src = number_src, divx = 10, digit = 2, padding = 1, ref = 164}),
				number({id = "songlength_m", src = number_src, divx = 10, digit = 2, ref = 1163}),
				number({id = "songlength_s", src = number_src, divx = 10, digit = 2, padding = 1, ref = 1164}),

				number({id = "notesleft", src = number_src, divx = 10, digit = 5, value = function()
					return main_state.number(74) - (main_state.judge(0) + main_state.judge(1) + main_state.judge(2) + main_state.judge(3) + main_state.judge(4)) end}),
				number({id = "totalnotes", src = number_src, divx = 10, digit = 5, ref = 74}),
			})

			append_all(skin.image, {
				{id = "text_pg", src = "src_scoregraph_text", x = 0, y = text_img_h * 9, w = text_img_w, h = text_img_h},
				{id = "text_gr", src = "src_scoregraph_text", x = 0, y = text_img_h * 10, w = text_img_w, h = text_img_h},
				{id = "text_gd", src = "src_scoregraph_text", x = 0, y = text_img_h * 11, w = text_img_w, h = text_img_h},
				{id = "text_bd", src = "src_scoregraph_text", x = 0, y = text_img_h * 12, w = text_img_w, h = text_img_h},
				{id = "text_pr", src = "src_scoregraph_text", x = 0, y = text_img_h * 13, w = text_img_w, h = text_img_h},
				{id = "text_kp", src = "src_scoregraph_text", x = 0, y = text_img_h * 14, w = text_img_w, h = text_img_h},
				{id = "text_cb", src = "src_scoregraph_text", x = 0, y = text_img_h * 15, w = text_img_w, h = text_img_h},

				{id = "text_tl", src = "src_scoregraph_text", x = 0, y = text_img_h * 20, w = text_img_w, h = text_img_h},
				{id = "text_nl", src = "src_scoregraph_text", x = 0, y = text_img_h * 21, w = text_img_w, h = text_img_h},
			})
			local num_img_w = 45 local num_img_h = 70
			append_all(skin.image, {
				{id = "text_colon", src = "src_number_genshin_monospace_border", x = num_img_w * 2, y = num_img_h * 2, w = num_img_w, h = num_img_h},
			})

			playinfo_defined = true
		end

		local dst = {}
		local line_h = geo.playinfo.line_h
		local info_h = geo.playinfo.h
		-- background
		append_all(dst, {
			{id = -110, dst = {
				{x = x, y = y, w = w, h = line_h * 7, a = a}
			}},
			{id = -110, dst = {
				{x = x, y = y + line_h * 7 + geo.playinfo.separateline_h, w = w, h = line_h * 2, a = a}
			}}
		})

		local text_x = x
		local text_w = text_img_w * line_h / text_img_h
		local num_w = 15
		local padding_right = 4

		-- timeleft and notesleft
		do
			local left_x = x + text_w + (w - text_w - padding_right) / 3 - num_w * 4
			if isSimple then
				left_x = x + w - num_w * 5 - padding_right
			end
			local total_x = x + w - num_w * 5 - padding_right

			local gray_color = {r = 150, g = 150, b = 150}
			local time_y = y + info_h - line_h
			append_all(dst, {
				{id = "text_tl", filter = 1, dst = {
					{x = text_x, y = time_y, w = text_w, h = line_h}
				}},

				{id = "timeleft_m", filter = 1, dst = {
					{x = left_x, y = time_y, w = num_w, h = line_h}
				}},
				{id = "text_colon", filter = 1, dst = {
					{x = left_x + num_w * 2, y = time_y, w = num_w, h = line_h}
				}},
				{id = "timeleft_s", filter = 1, dst = {
					{x = left_x + num_w * 3, y = time_y, w = num_w, h = line_h}
				}},
			})
			if not isSimple then
				append_all(dst, {
					{id = "songlength_m", filter = 1, dst = {
						merge_all({x = total_x, y = time_y, w = num_w, h = line_h}, gray_color)
					}},
					{id = "text_colon", filter = 1, dst = {
						merge_all({x = total_x + num_w * 2, y = time_y, w = num_w, h = line_h}, gray_color)
					}},
					{id = "songlength_s", filter = 1, dst = {
						merge_all({x = total_x + num_w * 3, y = time_y, w = num_w, h = line_h}, gray_color)
					}}
				})
			end

			local notes_y = y + info_h - line_h * 2
			append_all(dst, {
				{id = "text_nl", filter = 1, dst = {
					{x = text_x, y = notes_y, w = text_w, h = line_h}
				}},
				{id = "notesleft", filter = 1, dst = {
					{x = left_x, y = notes_y, w = num_w, h = line_h}
				}},
			})
			if not isSimple then
				append_all(dst, {
					{id = "totalnotes", filter = 1, dst = {
						merge_all({x = total_x, y = notes_y, w = num_w, h = line_h}, gray_color)
					}},
				})
			end
		end

		-- judge counts
		local judge = {"pg", "gr", "gd", "bd", "pr", "kp", "cb"}
		for i = 1, 7 do
			local judge_y = y + info_h - line_h * (i + 2) - geo.playinfo.separateline_h
			append_all(dst, {
				{id = "text_"..judge[i], filter = 1, dst = {
					{x = text_x, y = judge_y, w = text_w, h = line_h}
				}}
			})
			if isSimple then
				local num_x = x + w - num_w * 4 - padding_right
				append_all(dst, {
					{id = "count_"..judge[i], filter = 1, dst = {
						{x = num_x, y = judge_y, w = num_w, h = line_h}
					}}
				})
			else
				local num_area_x = text_x + text_w
				local num_area_w = w - (text_w + padding_right)
				append_all(dst, {
					{id = "count_"..judge[i], filter = 1, dst = {
						{x = num_area_x + num_area_w * 1 / 3 - num_w * 4, y = judge_y, w = num_w, h = line_h}
					}},
					{id = "count_fast_"..judge[i], filter = 1, dst = {
						{x = num_area_x + num_area_w * 2 / 3 - num_w * 4, y = judge_y, w = num_w, h = line_h, r = 50, g = 50, b = 255}
					}},
					{id = "count_slow_"..judge[i], filter = 1, dst = {
						{x = num_area_x + num_area_w * 3 / 3 - num_w * 4, y = judge_y, w = num_w, h = line_h, r = 255, g = 50, b = 50}
					}}
				})
			end
		end

		for i, v in ipairs(dst) do
			dst[i] = merge_all(dst[i], dst_additional_params)
		end

		return dst
	end

	-- background
	do
		table.insert(skin.image,
			{id = "background", src = "src_background", x = 0, y = 0, w = -1, h = -1}
		)
		table.insert(skin.destination,
			{id = "background", dst = {
				{x = 0, y = 0, w = header.w, h = header.h}
			}}
		)
	end

	-- bga
	do
		local real_bga_w = geo.bga.w + offset.bga.w
		local real_bga_h = geo.bga.h + offset.bga.h
		local real_bga_x = geo.bga.center_x - real_bga_w / 2 + offset.bga.x
		local real_bga_y = geo.bga.center_y - real_bga_h / 2 + offset.bga.y
		local real_bga_center_x = real_bga_x + real_bga_w / 2

		-- bga
		do
			local dst = {}

			-- frame
			if property.hideFrames.item.off.isSelected() then
				table.insert(skin.image,
					{id = "frame_bga", src = "src_frame_bga", x = 0, y = 0, w = -1, h = -1}
				)	
				append_all(dst, {
					{id = "frame_bga", dst = {
						{x = real_bga_x - geo.bga.frame_w, y = real_bga_y - geo.bga.frame_h, w = real_bga_w + geo.bga.frame_w * 2, h = real_bga_h + geo.bga.frame_h * 2}
					}},
					{id = -110, dst = {
						{x = real_bga_x - 3, y = real_bga_y - 3, w = real_bga_w + 3 * 2, h = real_bga_h + 3 * 2}
					}},
				})
			end

			append_all(dst, {
				-- background black
				{id = -110, dst = {
					{x = real_bga_x, y = real_bga_y, w = real_bga_w, h = real_bga_h}
				}},
				-- bga fullsize (not effective?)
				--[[{id = "bga", op = {41}, stretch = 3, dst = {
					{x = real_bga_x, y = real_bga_y, w = real_bga_w, h = real_bga_h, a = 100}
				}},]]
				-- bga
				{id = "bga", op = {41}, dst = {
					{x = real_bga_x, y = real_bga_y, w = real_bga_w, h = real_bga_h}
				}},
				-- bga darkness
				{id = -110, op = {41}, dst = {
					{x = real_bga_x, y = real_bga_y, w = real_bga_w, h = real_bga_h, a = offset.bga_darkness.a}
				}}
			})

			-- BGA透過 TODO BGAのフレームや背景の黒が混ざって透過するので一旦無効化
			--[[for i, v in ipairs(dst) do
				if dst[i].dst[1].a == nil then
					dst[i].dst[1].a = 255 + offset.bga.a
				else
					dst[i].dst[1].a = dst[i].dst[1].a + offset.bga.a
				end
			end]]
			append_all(skin.destination, dst)
		end

		-- genre,title,artist
		do
			table.insert(skin.image,
				{id = "titlegradation_standby", src = "src_titlegradation_standby", x = 0, y = 0, w = -1, h = -1}
			)

			local title_h = 80 local genre_h = 30 local artist_h = 30
			append_all(skin.text, {
				{id = "standby_title", font = "genshin_bold", size = title_h, align = 1, overflow = 1, ref = 12},
				{id = "standby_genre", font = "genshin_bold", size = genre_h, align = 1, overflow = 1, ref = 13},
				{id = "standby_artist", font = "genshin_bold", size = artist_h, align = 1, overflow = 1, ref = 16},
			})

			-- スタンバイ時のフェードイン、フェードアウトのアニメーション作成関数
			local function fade_in_and_out(dst, animation)
				local fade_in_start = 200 local fade_in_end = 700 local fade_out_end = 500
				local fadein = {loop = fade_in_end, op = {80}, dst = {
					{time = fade_in_start, a = 0},
					{time = fade_in_end, a = 255}
				}}
				local fadeout = {timer = 40, loop = -1, op = {81}, dst = {
					{time = 0, a = 255},
					{time = fade_out_end, a = 0}
				}}
				merge_all(fadein, dst)
				merge_all(fadein.dst[1], animation)
				merge_all(fadeout, dst)
				merge_all(fadeout.dst[1], animation)
				append_all(skin.destination, {fadein, fadeout})
			end
			-- standby song info
			local standby_w = real_bga_w * 0.95
			fade_in_and_out({id = "standby_title", op = {194}, filter = 1},
				{x = real_bga_center_x, y = real_bga_y + real_bga_h * 0.55, w = standby_w, h = title_h})
			fade_in_and_out({id = "standby_genre", op = {194}, filter = 1},
				{x = real_bga_center_x, y = real_bga_y + real_bga_h * 0.75, w = standby_w, h = genre_h})
			fade_in_and_out({id = "standby_artist", op = {194}, filter = 1},
				{x = real_bga_center_x, y = real_bga_y + real_bga_h * 0.2, w = standby_w, h = artist_h})
			-- backbmp
			fade_in_and_out({id = -101, op = {195}, stretch = 1},
				{x = real_bga_x, y = real_bga_y, w = real_bga_w, h = real_bga_h})

			-- title gradation
			fade_in_and_out({id = "titlegradation_standby", op = {194}, blend = 4},
				{x = real_bga_x, y = real_bga_y + real_bga_h * 0.55, w = standby_w, h = 80})
		end
	end
	-- bpm
	do
		table.insert(skin.image,
			{id = "frame_bpm", src = "src_frame_bpm", x = 0, y = 0, w = -1, h = -1}
		)
		local bpm_center_x = geo.bga.center_x + offset.bpm.x
		local bpm_y = 19 + offset.bpm.y local bpm_w = 420 local bpm_h = 64
		local frame_w = 8 local frame_h = 8
		append_all(skin.destination, {
			-- background black
			{id = -110, dst = {
				{x = bpm_center_x - bpm_w / 2 - 4, y = bpm_y - 4, w = bpm_w + 8, h = bpm_h + 8, a = 200 + offset.bpm.a}
			}},
		})
		if property.hideFrames.item.off.isSelected() then
			append_all(skin.destination, {
				{id = "frame_bpm", dst = {
					{x = bpm_center_x - bpm_w / 2 - frame_w, y = bpm_y - frame_h, w = bpm_w + frame_w * 2, h = bpm_h + frame_h * 2, a = 245 + offset.bpm.a}
				}},
			})
		end

		append_all(skin.value, {
			number({id = "bpm_min", src = "src_number_kenney_future", divx = 10, digit = 4, align = 2, ref = 91}),
			number({id = "bpm_now", src = "src_number_kenney_future", divx = 10, digit = 4, align = 2, ref = 160}),
			number({id = "bpm_max", src = "src_number_kenney_future", divx = 10, digit = 4, align = 2, ref = 90}),
		})
		local num_y = bpm_y + 6 local num_w = 38 local num_h = 26
		local sideNumRate = 0.7
		append_all(skin.destination, {
			{id = "bpm_min", op = {177}, filter = 1, dst = {
				{x = bpm_center_x - 144 - (num_w * 2 * sideNumRate), y = num_y, w = num_w * sideNumRate, h = num_h * sideNumRate}
			}},
			{id = "bpm_now", filter = 1, dst = {
				{x = bpm_center_x - num_w * 2, y = num_y, w = num_w, h = num_h}
			}},
			{id = "bpm_max", op = {177}, filter = 1, dst = {
				{x = bpm_center_x + 144 - (num_w * 2 * sideNumRate), y = num_y, w = num_w * sideNumRate, h = num_h * sideNumRate}
			}},
		})

		local text_img_w = 205 local text_img_h = 70
		append_all(skin.image, {
			{id = "text_image_bpm", src = "src_othertexts", x = 0, y = text_img_h * 9, w = text_img_w, h = text_img_h},
			{id = "text_image_min", src = "src_othertexts", x = 0, y = text_img_h * 10, w = text_img_w, h = text_img_h},
			{id = "text_image_max", src = "src_othertexts", x = 0, y = text_img_h * 11, w = text_img_w, h = text_img_h},
		})
		local text_y = num_y + num_h + 8 local text_w = 20 local text_h = 18
		local imgRate = text_h / text_img_h * 0.9
		local sideTextRate = 0.85
		append_all(skin.destination, {
			{id = "text_image_min", filter = 1, dst = {
				{x = bpm_center_x - 144 - text_img_w * imgRate * sideTextRate / 2, y = text_y + 2, w = text_img_w * imgRate * sideTextRate, h = text_img_h * imgRate * sideTextRate}
			}},
			{id = "text_image_bpm", filter = 1, dst = {
				{x = bpm_center_x - text_img_w * imgRate / 2, y = text_y + 2, w = text_img_w * imgRate, h = text_img_h * imgRate}
			}},
			{id = "text_image_max", filter = 1, dst = {
				{x = bpm_center_x + 144 - text_img_w * imgRate * sideTextRate / 2, y = text_y + 2, w = text_img_w * imgRate * sideTextRate, h = text_img_h * imgRate * sideTextRate}
			}},
		})
	end
	-- header
	do
		-- background black
		do
			local x = geo.lanearea.x + geo.lanearea.w - geo.lanearea.padding_right
			local w = header.w - x
			if is2P() then
				x = 0
				w = geo.lanearea.x + geo.lanearea.padding_left
			end
			local y = geo.bga.y + geo.bga.h + geo.bga.frame_h
			local h = header.h - (geo.bga.y + geo.bga.h + geo.bga.frame_h)
			table.insert(skin.destination,
				{id = -110, dst = {
					{x = x, y = y, w = w, h = h, a = 200 + offset.bga_header.a}
				}}
			)
		end

		-- title & artist(table)
		table.insert(skin.image,
			{id = "titlegradation_header", src = "src_titlegradation_header", x = 0, y = 0, w = -1, h = -1}
		)

		local title_size = 33 local artist_size = 26
		append_all(skin.text, {
			{id = "header_title", font = "genshin_bold", size = title_size, align = 1, overflow = 1, ref = 12},
			{id = "header_artist", font = "genshin_bold", size = artist_size, align = 1, overflow = 1, ref = 16},
			{id = "header_table", font = "genshin_bold", size = artist_size, align = 1, overflow = 1, ref = 1003},
		})

		local header_padding_x = 158
		local header_center_x = geo.bga.center_x local header_y = geo.bga.y + geo.bga.h + 23 local header_w = geo.bga.w - header_padding_x * 2
		append_all(skin.destination, {
			{id = "header_title", filter = 1, dst = {
				{x = header_center_x, y = header_y + artist_size + 4, w = header_w, h = title_size}
			}},
			{id = "header_artist", filter = 1, op = {-1008}, dst = {
				{x = header_center_x, y = header_y - 4, w = header_w, h = artist_size}
			}},
			-- artist & table lotate animation
			{id = "header_artist", filter = 1, op = {1008}, dst = {
				{time = 0, x = header_center_x, y = header_y - 4, w = header_w, h = artist_size, a = 255},
				{time = 4000, a = 255},
				{time = 6000, a = 0},
				{time = 14000, a = 0},
				{time = 16000, a = 255}
			}},
			{id = "header_table", filter = 1, op = {1008}, dst = {
				{time = 0, x = header_center_x, y = header_y - 4, w = header_w, h = artist_size, a = 0, r = 229, g = 153, b = 255},
				{time = 6000, a = 0},
				{time = 8000, a = 255},
				{time = 12000, a = 255},
				{time = 14000, a = 0},
				{time = 16000, a = 0}
			}},
			-- title gradation
			-- artistの後に描画するとartistが黒箱にならない
			{id = "titlegradation_header", blend = 4, dst = {
				{x = geo.bga.x + 158, y = header_y + artist_size + 4, w = header_w, h = title_size + 4}
			}},
		})
		-- difficulty
		local margin_outside_x = 0
		if geo.bga.w + geo.bga.frame_w * 2 == geo.bgaarea.w then -- BGAと他のエリアが接する場合は、headerの両サイドにマージンを設ける
			margin_outside_x = 4
		end
		local difficulty_w = 145
		local difficulty_x = geo.bga.x - geo.bga.frame_w + margin_outside_x
		if is2P() then
			difficulty_x = geo.bga.x + geo.bga.w + geo.bga.frame_w - difficulty_w - margin_outside_x
		end
		do
			local img_w = 220 local img_h = 40
			for i = 1, 6 do
				table.insert(skin.image, {
					id = "difficulty_"..i, src = "src_difficulty", x = 0, y = img_h * (i - 1), w = img_w, h = img_h
				})
			end
			local h = img_h * difficulty_w / img_w
			for i = 1, 6 do
				table.insert(skin.destination, {id = "difficulty_"..i, op = {149 + i}, filter = 1, dst = {
					{x = difficulty_x, y = header_y + 32, w = difficulty_w, h = h},
				}})
			end
		end
		-- level
		do
			do
				table.insert(skin.image,
					{id = "text_image_lv", src = "src_othertexts", x = 0, y = 70, w = 100, h = 70}
				)
				table.insert(skin.value,
					number({id = "level", src = "src_number_newtown", divx = 10, digit = 2, align = 1, ref = 96})
				)
			end
			local y = header_y + 3 local h = 18 local text_w = 38 local num_w = 23 local space_x = 4
			local x = difficulty_x + (difficulty_w - (text_w + num_w + space_x)) / 2
			-- 中央寄せになるようにレベルの桁によって位置を調整
			if main_state.number(96) >= 10 then
				x = x - num_w / 2
			end
			append_all(skin.destination, {
				-- playlevel
				{id = "text_image_lv", filter = 1, dst = {
					{x = x, y = y, w = text_w, h = h}
				}},
				{id = "level", filter = 1, dst = {
					{x = x + text_w + space_x, y = y, w = num_w, h = h}
				}},
			})
		end
		-- stage
		do
			local img_w = 563 local img_h = 80
			append_all(skin.image, {
				{id = "stage_1st", src = "src_stagetext", x = 0, y = 0, w = img_w, h = img_h},
				{id = "stage_2nd", src = "src_stagetext", x = 0, y = img_h, w = img_w, h = img_h},
				{id = "stage_3rd", src = "src_stagetext", x = 0, y = img_h * 2, w = img_w, h = img_h},
				{id = "stage_final", src = "src_stagetext", x = 0, y = img_h * 3, w = img_w, h = img_h},
				{id = "stage_extra", src = "src_stagetext", x = 0, y = img_h * 4, w = img_w, h = img_h},
				{id = "stage_beatoraja", src = "src_stagetext", x = 0, y = img_h * 5, w = img_w, h = img_h},
			})

			local w = 147 local h = img_h * w / img_w
			local x = geo.bga.x + geo.bga.w + geo.bga.frame_w - w - margin_outside_x
			if is2P() then
				x = geo.bga.x - geo.bga.frame_w + margin_outside_x
			end
			local y = header_y + 25
			local stage_id = "stage_beatoraja"
			-- grade stage (beatoraja未対応)
			--[[if main_state.option(293) then
				if main_state.option(280) then
					stage_id = "stage_1st"
				elseif main_state.option(281) then
					stage_id = "stage_2nd"
				elseif main_state.option(282) then
					stage_id = "stage_3rd"
				elseif main_state.option(289) then
					stage_id = "stage_final"
				else
					stage_id = "stage_extra"
				end
			end]]
			table.insert(skin.destination,
				{id = stage_id, filter = 1, dst = {
					{time = 0, x = x, y = y, w = w, h = h},
					{time = 3000, a = 255},
					{time = 4000, a = 20},
					{time = 5000, a = 255},
				}}
			)
		end
	end

	-- notesgraph and timingVisualizer (in bga area)
	do
		local w = geo.bga.w / 2 - 20
		local h = 130
		local x = geo.bga.center_x
		if is2P() then
			x = geo.bga.x + 20
		end
		-- notesgraph
		do
			append_all(skin.judgegraph, {
				{id = "notesgraph_notestype", type = 0, backTexOff = 1},
				{id = "notesgraph_judge", type = 1, backTexOff = 1},
				{id = "notesgraph_fastslow", type = 2, backTexOff = 1}
			})
			table.insert(skin.bpmgraph,
				{id = "bpmgraph"}
			)
			local y = geo.bga.y + 20
			if property.notesGraph.item.notesType.isSelected() then
				table.insert(skin.destination, {id = "notesgraph_notestype", timer = 41, offset = offset.notesgraph.id, dst = {
					{x = x, y = y, w = w, h = h}
				}})
			elseif property.notesGraph.item.judge.isSelected() then
				table.insert(skin.destination, {id = "notesgraph_judge", timer = 41, offset = offset.notesgraph.id, dst = {
					{x = x, y = y, w = w, h = h}
				}})
			elseif property.notesGraph.item.fastSlow.isSelected() then
				table.insert(skin.destination, {id = "notesgraph_fastslow", timer = 41, offset = offset.notesgraph.id, dst = {
					{x = x, y = y, w = w, h = h}
				}})
			end
			if not property.notesGraph.item.off.isSelected() then
				table.insert(skin.destination, {id = "bpmgraph", timer = 41, offset = offset.notesgraph.id, op = {177}, dst = {
					{x = x, y = y, w = w, h = h}
				}})
			end
		end
		-- timingVisualizer
		if property.timingVisualizer.item.on.isSelected() then
			table.insert(skin.timingvisualizer,
				{id = "timingvisualizer"}
			)
			local y = geo.bga.y + h + 20
			table.insert(skin.destination, {id = "timingvisualizer", timer = 41, offset = offset.timingvisualizer.id, op = {32}, dst = {
				{x = x, y = y, w = w, h = h}
			}})
		end
	end
	-- playinfo (in bga area)
	if not property.playInfo.item.off.isSelected() then
		local w = 240
		if property.playInfo.item.slim.isSelected() then
			w = 130
		end
		local x = geo.bga.x + 20
		if is2P() then
			x = geo.bga.x + geo.bga.w - w - 20
		end
		local y = geo.bga.y + 20
		local timer = 41

		x = x + offset.playinfo.x
		y = y + offset.playinfo.y
		--w = w + offset.playinfo.w
		a = 255 + offset.playinfo.a
		local p_dst = playinfo_dst(x, y, w, a, property.playInfo.item.slim.isSelected(), {timer = timer})
		append_all(skin.destination, p_dst)

		if property.hideFrames.item.off.isSelected() then
			-- playinfo separate line
			table.insert(skin.destination,
				{id = -111, timer = timer, dst = {
					{x = x, y = y + geo.playinfo.line_h * 7, w = w, h = geo.playinfo.separateline_h, r = 60, g = 60, b = 60, a = a}
				}}
			)

			local frame_thickness = 5
			local f_dst = frame_dst(x - frame_thickness, y - frame_thickness, w + frame_thickness * 2, geo.playinfo.h + frame_thickness * 2, a, frame_thickness, frame_thickness, {timer = timer})
			append_all(skin.destination, f_dst)
		end
	end

	-- scoregraph
	if isScoreGraph() then
		-- background
		do
			table.insert(skin.image,
				{id = "scoregraph_background", src = "src_scoregraph_background", x = 0, y = 0, w = -1, h = -1}
			)
			table.insert(skin.destination,
				{id = "scoregraph_background", dst = {
					{x = geo.scoregraph.x, y = geo.scoregraph.y, w = geo.scoregraph.w, h = geo.scoregraph.h, a = 255 + offset.scoregraph.a}
				}}
			)
		end
		-- rank lines
		do
			local text_img_base_w = 135 local text_img_h = 70
			local text_img_a_x = 85 local text_img_a_w = text_img_base_w - text_img_a_x
			local text_img_aa_x = 45 local text_img_aa_w = text_img_base_w - text_img_aa_x
			local text_img_aaa_x = 5 local text_img_aaa_w = text_img_base_w - text_img_aaa_x
			local text_img_max_x = 5 local text_img_max_w = text_img_base_w - text_img_max_x
			append_all(skin.image, {
				{id = "text_scoregraph_A", src = "src_scoregraph_text", x = text_img_a_x, y = text_img_h * 5, w = text_img_a_w, h = text_img_h},
				{id = "text_scoregraph_AA", src = "src_scoregraph_text", x = text_img_aa_x, y = text_img_h * 6, w = text_img_aa_w, h = text_img_h},
				{id = "text_scoregraph_AAA", src = "src_scoregraph_text", x = text_img_aaa_x, y = text_img_h * 7, w = text_img_aaa_w, h = text_img_h},
				{id = "text_scoregraph_MAX", src = "src_scoregraph_text", x = text_img_max_x, y = text_img_h * 8, w = text_img_max_w, h = text_img_h},
			})

			local max_timer = (function()
				local state = main_state.timer_off_value
				local number_point = 100
				return function()
					if state == main_state.timer_off_value and main_state.number(number_point) == 200000 then
						state = main_state.time()
					end
					return state
				end
			end)()

			local function rank_dst(line_y, timer, text_id, text_img_w)
				local line_h = 2
				local outline_h = 2
				local line_color = {r = 100, g = 100, b = 200} local reach_color = {r = 150, g = 150, b = 0}

				local text_h = 16
				local text_w = text_img_w * text_h / text_img_h
				if isScoreGraphNormal() then
					text_w = text_w * 1.25
				end
				local text_x = geo.scoregraph.x
				local text_y = line_y + 2
				if is2P() then
					text_x = geo.scoregraph.x + geo.scoregraph.w - text_w
				end

				append_all(skin.destination, {
					{id = -110, dst = {
						{x = geo.scoregraph.x, y = line_y - outline_h, w = geo.scoregraph.w, h = line_h + outline_h * 2, a = 150}
					}},
					{id = -111, dst = {
						merge_all({x = geo.scoregraph.x, y = line_y, w = geo.scoregraph.w, h = line_h}, line_color)
					}},
					{id = -111, timer = timer, dst = {
						merge_all({x = geo.scoregraph.x, y = line_y, w = geo.scoregraph.w, h = line_h}, reach_color)
					}},
					{id = text_id, filter = 1, dst = {
						merge_all({x = text_x, y = text_y, w = text_w, h = text_h}, line_color)
					}},
					{id = text_id, filter = 1, timer = timer, dst = {
						merge_all({x = text_x, y = text_y, w = text_w, h = text_h}, reach_color)
					}},
				})
			end
			-- rank A line
			local A_y = geo.scoregraph.y + geo.scoregraph.bar_h * 6/9
			rank_dst(A_y, 348, "text_scoregraph_A", text_img_a_w)
			-- rank AA line
			local AA_y = geo.scoregraph.y + geo.scoregraph.bar_h * 7/9
			rank_dst(AA_y, 349, "text_scoregraph_AA", text_img_aa_w)
			-- rank AAA line
			local AAA_y = geo.scoregraph.y + geo.scoregraph.bar_h * 8/9
			rank_dst(AAA_y, 350, "text_scoregraph_AAA", text_img_aaa_w)
			-- rank MAX line
			local MAX_y = geo.scoregraph.y + geo.scoregraph.bar_h
			rank_dst(MAX_y, max_timer, "text_scoregraph_MAX", text_img_max_w)
		end
		-- bar graph
		do
			append_all(skin.graph, {
				{id = "graph_now", src = "src_white1dot", x = 0, y = 0, w = 1, h = 1, type = 110},
				{id = "graph_best", src = "src_white1dot", x = 0, y = 0, w = 1, h = 1, type = 112},
				{id = "graph_best_final", src = "src_white1dot", x = 0, y = 0, w = 1, h = 1, type = 113},
				{id = "graph_target", src = "src_white1dot", x = 0, y = 0, w = 1, h = 1, type = 114},
				{id = "graph_target_final", src = "src_white1dot", x = 0, y = 0, w = 1, h = 1, type = 115},
			})

			local bar_now_x = geo.scoregraph.x + geo.scoregraph.bar_w
			local bar_best_x = geo.scoregraph.x + geo.scoregraph.bar_w * 2 + geo.scoregraph.bar_space
			local bar_target_x = geo.scoregraph.x + geo.scoregraph.bar_w * 3 + geo.scoregraph.bar_space * 2
			if is2P() then
				bar_now_x = geo.scoregraph.x + geo.scoregraph.bar_w * 2 + geo.scoregraph.bar_space * 3
				bar_best_x = geo.scoregraph.x + geo.scoregraph.bar_w + geo.scoregraph.bar_space * 2
				bar_target_x = geo.scoregraph.x + geo.scoregraph.bar_space
			end
			local bar_a = 240
			local now_color = {r = 50, g = 50, b = 200, a = bar_a}
			local best_color = {r = 50, g = 200, b = 50, a = bar_a}
			local target_color = {r = 200, g = 50, b = 50, a = bar_a}
			local final_color = {r = 40, g = 40, b = 40, a = 160}
			append_all(skin.destination, {
				{id = "graph_now", dst = {
					merge_all({x = bar_now_x, y = geo.scoregraph.y, w = geo.scoregraph.bar_w, h = geo.scoregraph.bar_h}, now_color)
				}},
				{id = "graph_best_final", dst = {
					merge_all({x = bar_best_x, y = geo.scoregraph.y, w = geo.scoregraph.bar_w, h = geo.scoregraph.bar_h}, final_color)
				}},
				{id = "graph_best", dst = {
					merge_all({x = bar_best_x, y = geo.scoregraph.y, w = geo.scoregraph.bar_w, h = geo.scoregraph.bar_h}, best_color)
				}},
				{id = "graph_target_final", dst = {
					merge_all({x = bar_target_x, y = geo.scoregraph.y, w = geo.scoregraph.bar_w, h = geo.scoregraph.bar_h}, final_color)
				}},
				{id = "graph_target", dst = {
					merge_all({x = bar_target_x, y = geo.scoregraph.y, w = geo.scoregraph.bar_w, h = geo.scoregraph.bar_h}, target_color)
				}},
			})
		end
		-- darkness
		table.insert(skin.destination,
			{id = -110, dst = {
				{x = geo.scoregraph.x, y = geo.scoregraph.y, w = geo.scoregraph.w, h = geo.scoregraph.h, a = offset.scoregraph_darkness.a} -- TODO offset.scoregraph.aとdarknessの両立
			}}
		)
		-- score ghost
		do
			local num_img_w = 45 local num_img_h = 70
			local diff_src = "src_number_genshin_monospace_border"
			if property.ghostScoreColor.item.red.isSelected() then
				diff_src = "src_number_genshin_monospace_border_red"
			end
			append_all(skin.value, {
				number({id = "diff_best", src = diff_src, divx = 12, divy = 2, digit = 5, ref = 152}),
				number({id = "diff_target", src = diff_src, divx = 12, divy = 2, digit = 5, ref = 153}),
				number({id = "diff_nextrank", src = diff_src, divx = 10, divy = 1, digit = 4, ref = 154}),

				number({id = "scorerate", src = "src_number_genshin_monospace_border", divx = 10, digit = 3, ref = 102}),
				number({id = "scorerate_ad", src = "src_number_genshin_monospace_border", divx = 10, digit = 2, padding = 1, ref = 103})
			})
			local text_img_rank_w = 135 local text_img_diff_w = 114 local text_img_h = 70
			local text_img_diff_wide_w = 275
			append_all(skin.image, {
				{id = "text_nextrank_minus", src = "src_number_genshin_monospace_border", x = num_img_w * 11, y = num_img_h, w = num_img_w, h = num_img_h},
				{id = "text_rank_dot", src = "src_number_genshin_monospace_border", x = 0, y = num_img_h * 2, w = num_img_w, h = num_img_h},
				{id = "text_rank_%", src = "src_number_genshin_monospace_border", x = num_img_w, y = num_img_h * 2, w = num_img_w, h = num_img_h},

				{id = "text_rank_f", src = "src_scoregraph_text", x = 0, y = 0, w = text_img_rank_w, h = text_img_h},
				{id = "text_rank_e", src = "src_scoregraph_text", x = 0, y = text_img_h, w = text_img_rank_w, h = text_img_h},
				{id = "text_rank_d", src = "src_scoregraph_text", x = 0, y = text_img_h * 2, w = text_img_rank_w, h = text_img_h},
				{id = "text_rank_c", src = "src_scoregraph_text", x = 0, y = text_img_h * 3, w = text_img_rank_w, h = text_img_h},
				{id = "text_rank_b", src = "src_scoregraph_text", x = 0, y = text_img_h * 4, w = text_img_rank_w, h = text_img_h},
				{id = "text_rank_a", src = "src_scoregraph_text", x = 0, y = text_img_h * 5, w = text_img_rank_w, h = text_img_h},
				{id = "text_rank_aa", src = "src_scoregraph_text", x = 0, y = text_img_h * 6, w = text_img_rank_w, h = text_img_h},
				{id = "text_rank_aaa", src = "src_scoregraph_text", x = 0, y = text_img_h * 7, w = text_img_rank_w, h = text_img_h},
				{id = "text_rank_max", src = "src_scoregraph_text", x = 0, y = text_img_h * 8, w = text_img_rank_w, h = text_img_h},

				{id = "text_diff_best_short", src = "src_scoregraph_text", x = 0, y = text_img_h * 17, w = text_img_diff_w, h = text_img_h},
				{id = "text_diff_target_short", src = "src_scoregraph_text", x = 0, y = text_img_h * 16, w = text_img_diff_w, h = text_img_h},
				{id = "text_diff_best", src = "src_scoregraph_text", x = 0, y = text_img_h * 19, w = text_img_diff_wide_w, h = text_img_h},
				{id = "text_diff_target", src = "src_scoregraph_text", x = 0, y = text_img_h * 18, w = text_img_diff_wide_w, h = text_img_h},
			})

			local h = 22
			local num_w = 15
			local rank_text_w = text_img_rank_w * h / text_img_h

			local padding_right = 4
			local scoregraph_rightend_x = geo.scoregraph.x + geo.scoregraph.w - padding_right
			local num_x = scoregraph_rightend_x - num_w * 5
			local best_y = geo.scoregraph.y
			local target_y = geo.scoregraph.y + h
			local scorerate_y = geo.scoregraph.y + h * 2
			local nowrank_y = geo.scoregraph.y + h * 3
			local nextrank_y = geo.scoregraph.y + h * 4

			if isScoreGraphNormal() then
				local diff_text_w = text_img_diff_wide_w * h / text_img_h
				local text_x = num_x - diff_text_w - padding_right
				append_all(skin.destination, {
					{id = "text_diff_best", filter = 1, dst = {
						{x = text_x, y = best_y, w = diff_text_w, h = h}
					}},
					{id = "text_diff_target", filter = 1, dst = {
						{x = text_x, y = target_y, w = diff_text_w, h = h}
					}},
				})
			elseif isScoreGraphSlim() then
				local diff_text_w = text_img_diff_w * h / text_img_h
				local text_x = num_x - diff_text_w - padding_right
				append_all(skin.destination, {
					{id = "text_diff_best_short", filter = 1, dst = {
						{x = text_x, y = best_y, w = diff_text_w, h = h}
					}},
					{id = "text_diff_target_short", filter = 1, dst = {
						{x = text_x, y = target_y, w = diff_text_w, h = h}
					}},
				})
			end

			local nextrank_x = scoregraph_rightend_x - num_w * 5 - rank_text_w
			local function nextrank(id, op)
				append_all(skin.destination, {
					{id = id, op = op, filter = 1, timer = 143, dst = {
						{x = nextrank_x, y = nextrank_y, w = rank_text_w, h = h}
					}}
				})
			end
			nextrank("text_rank_e", {227, -226})
			nextrank("text_rank_d", {226, -225})
			nextrank("text_rank_c", {225, -224})
			nextrank("text_rank_b", {224, -223})
			nextrank("text_rank_a", {223, -222})
			nextrank("text_rank_aa", {222, -221})
			nextrank("text_rank_aaa", {221, -220})
			nextrank("text_rank_max", {220})
			append_all(skin.destination, {
				{id = "text_nextrank_minus", filter = 1, timer = 143, dst = {
					{x = nextrank_x + rank_text_w, y = nextrank_y, w = num_w, h = h}
				}},
			})

			append_all(skin.destination, {
				{id = "diff_best", filter = 1, dst = {
					{x = num_x, y = best_y, w = num_w, h = h}
				}},
				{id = "diff_target", filter = 1, dst = {
					{x = num_x, y = target_y, w = num_w, h = h}
				}},
				{id = "diff_nextrank", filter = 1, timer = 143, dst = {
					{x = num_x + num_w, y = nextrank_y, w = num_w, h = h}
				}},
			})

			local rate_x = scoregraph_rightend_x - num_w * 7
			append_all(skin.destination, {
				{id = "scorerate", filter = 1, dst = {
					{x = rate_x, y = scorerate_y, w = num_w, h = h}
				}},
				{id = "text_rank_dot", filter = 1, dst = {
					{x = rate_x + num_w * 3, y = scorerate_y, w = num_w, h = h}
				}},
				{id = "scorerate_ad", filter = 1, dst = {
					{x = rate_x + num_w * 4, y = scorerate_y, w = num_w, h = h}
				}},
				{id = "text_rank_%", filter = 1, dst = {
					{x = rate_x + num_w * 6, y = scorerate_y, w = num_w, h = h}
				}},
			})

			local ranks = {"aaa", "aa", "a", "b", "c", "d", "e", "f"}
			for i, v in ipairs(ranks) do
				append_all(skin.destination, {
					{id = "text_rank_"..v, op = {199 + i}, filter = 1, dst = {
						{x = geo.scoregraph.x + geo.scoregraph.w - rank_text_w - padding_right, y = nowrank_y, w = rank_text_w, h = h}
					}},
				})
			end
		end
		-- header scores
		do
			append_all(skin.value, {
				number({id = "mybest_exscore", src = "src_number_newtown", divx = 10, digit = 5, ref = 150}),
				number({id = "target_exscore", src = "src_number_newtown", divx = 10, digit = 5, ref = 121})
			})

			local text_size = 18
			append_all(skin.text, {
				{id = "text_scoregraph_mybest", font = "newtown", size = text_size, constantText = "MYBEST"},
				{id = "text_scoregraph_target", font = "newtown", size = text_size, constantText = "TARGET"},
			})

			local num_size = 20
			local num_x = geo.scoregraph.x + geo.scoregraph.w - num_size * 5 - 4
			local text_x = geo.scoregraph.x + 4
			local base_y = geo.scoregraph.y + geo.scoregraph.h + 6

			local target_color = {r = 255, g = 200, b = 200}
			local mybest_color = {r = 200, g = 255, b = 200}
			append_all(skin.destination, {
				{id = -110, dst = { -- background
					{x = geo.scoregraph.x, y = base_y, w = geo.scoregraph.w, h = header.h - base_y, a = 255 + offset.scoregraph.a}
				}},
				{id = "text_scoregraph_target", filter = 1, dst = {
					merge_all({x = text_x, y = base_y + num_size * 2 + text_size + 2 + 4 + 2, w = text_size, h = text_size}, target_color)
				}},
				{id = "target_exscore", filter = 1, dst = {
					merge_all({x = num_x, y = base_y + num_size + text_size + 2 + 4, w = num_size, h = num_size}, target_color)
				}},
				{id = "text_scoregraph_mybest", filter = 1, dst = {
					merge_all({x = text_x, y = base_y + num_size + 2, w = text_size, h = text_size}, mybest_color)
				}},
				{id = "mybest_exscore", filter = 1, dst = {
					merge_all({x = num_x, y = base_y, w = num_size, h = num_size}, mybest_color)
				}},
			})
		end

		-- playinfo
		append_all(skin.destination, playinfo_dst(geo.scoregraph.x, 12, geo.scoregraph.w, 255 + offset.scoregraph.a, isScoreGraphSlim(), {}))
	end

	-- lane
	-- laneAreaBackground
	--[[do
		table.insert(skin.image,
			{id = "frame_lanearia", src = "src_frame_lane", x = 0, y = 0, w = -1, h = -1}
		)
		local padding_left = 40 local padding_right = 16
		table.insert(skin.destination, {id = "frame_lanearia", dst = {
			{x = geo.lane.x - padding_left, y = 0, w = padding_left + geo.lane.w + padding_right, h = header.h},
		}})
	end]]
	-- musicProgressBar
	do
		local w = 10 local slider_h = 20
		table.insert(skin.slider,
			{id = "musicprogress", src = "src_progress", x = 0, y = 0, w = w, h = slider_h, angle = 2, range = geo.lane.h - slider_h - 30 * 2, type = 6}
		)
		local margin_y = 34
		local bar_h = geo.lane.h - margin_y * 2
		local x = geo.lanearea.x + 24
		if is2P() then
			x = geo.lanearea.x + geo.lanearea.w - 24 - w
		end
		local y = geo.lane.y + margin_y
		if property.hideFrames.item.off.isSelected() then
			append_all(skin.destination, {
				{id = -111, dst = {
					{x = x - 3, y = y - 8, w = w + 3 * 2, h = bar_h + 8 * 2, r = 40, g = 40, b = 40}
				}},
			})
		end
		append_all(skin.destination, {
			{id = -110, dst = {
				{x = x, y = y, w = w, h = bar_h}
			}},
			{id = "musicprogress", dst = {
				{time = 0, x = x, y = y + bar_h - slider_h, w = w, h = slider_h},
				{time = 1000, a = 100},
			}},
		})
	end
	-- lane border white line レーン周りの白線
	if property.hideFrames.item.off.isSelected() then
		local w = 3
		table.insert(skin.destination, {id = -110, dst = {
			{x = geo.lane.x - (w + 1), y = geo.lane.y - (w + 1), w = geo.lane.w + (w + 1) * 2, h = geo.lane.h + (w + 1) * 2},
		}})
		local rgb = 200
		table.insert(skin.destination, {id = -111, dst = {
			{x = geo.lane.x - w, y = geo.lane.y - w, w = geo.lane.w + w * 2, h = geo.lane.h + w * 2, r = rgb, g = rgb, b = rgb},
		}})
	end
	-- lanebg
	table.insert(skin.destination, {id = -110, dst = {
		{x = geo.lane.x, y = geo.lane.y, w = geo.lane.w, h = geo.lane.h},
	}})
	-- lanecolor
	do
		local rgb = 5
		for i = 1, keysNumber, 2 do
			table.insert(skin.destination, {id = -111, offset = 3, dst = {
				{x = geo.lane.each_x[i], y = geo.lane.y, w = geo.lane.each_w[i], h = geo.lane.h, r = rgb, g = rgb, b = rgb}
			}})
		end
	end
	-- laneSeparateLine
	do
		local rgb = 30
		for i = 2, #geo.lane.order do
			table.insert(skin.destination, {id = -111, offset = 3, dst = {
				{x = geo.lane.each_x[geo.lane.order[i]] - geo.lane.separateline_w, y = geo.lane.y, w = geo.lane.separateline_w, h = geo.lane.h, r = rgb, g = rgb, b = rgb}
			}})
		end
	end
	-- laneDarkness
	do
		table.insert(skin.destination, {id = -110, offset = 3, dst = {
			{x = geo.lane.x, y = geo.lane.y, w = geo.lane.w, h = geo.lane.h, a = offset.lane_darkness.a},
		}})
	end
	-- glow
	table.insert(skin.image,
		{id = "glow", src = "src_glow", x = 0, y = 0, w = 492, h = 48}
	)
	do
		local h = 50 local loading_a = 180 local playing_dark_a = 80
		-- loading
		table.insert(skin.destination, {id = "glow", op = {80}, offset = 3, blend = 2, dst = {
			{x = geo.lane.x, y = geo.lane.y, w = geo.lane.w, h = h, a = loading_a},
		}})
		-- loaded ~ playstart
		table.insert(skin.destination, {id = "glow", timer = 40, loop = -1, offset = 3, blend = 2, dst = {
			{time = 0, x = geo.lane.x, y = geo.lane.y, w = geo.lane.w, h = h, a = loading_a},
			{time = header.playstart, a = playing_dark_a}
		}})
		-- playing
		table.insert(skin.destination, {id = "glow", timer = 140, offset = 3, blend = 2, dst = {
			{time = 0, x = geo.lane.x, y = geo.lane.y, w = geo.lane.w, h = h, acc = 2},
			{time = 1000, a = playing_dark_a},
		}})
	end
	-- judgeline
	table.insert(skin.destination, {id = -111, offset = 3, dst = {
		{x = geo.lane.x, y = geo.lane.y, w = geo.lane.w, h = 10, r = 255, g = 0, b = 0},
	}})
	-- keybeam
	do
		do
			local h = 564
			append_all(skin.image, {
				{id = "keybeam_s", src = "src_keybeam", x = 0, y = 0, w = 108, h = h},
				{id = "keybeam_w", src = "src_keybeam", x = 108, y = 0, w = 60, h = h},
				{id = "keybeam_b", src = "src_keybeam", x = 108 + 60, y = 0, w = 48, h = h},
			})
		end

		local kind = {"w", "b", "w", "b", "w", "b", "w", "s"}
		local timer = {101, 102, 103, 104, 105, 106, 107, 100}
		if keysNumber == 5 then
			kind = {"w", "b", "w", "b", "w", "s"}
			timer = {101, 102, 103, 104, 105, 100}
		end
		local h = geo.lane.h / 2 + offset.keybeam.h
		local a = 255 + offset.keybeam.a
		-- push
		do
			for i = 1, keysNumber do
				table.insert(skin.destination, {
					id = "keybeam_"..kind[i], offset = 3, timer = timer[i], brend = 1, dst = {
						{x = geo.lane.each_x[i], y = geo.lane.y, w = geo.lane.each_w[i], h = h, a = a}
					}
				})
			end
			-- スクラッチのキービームのみ伸びるアニメーションをする(オートプレイではオフ)
			local scratch_ontime = 40
			table.insert(skin.destination, {
				id = "keybeam_s", offset = 3, timer = timer[keysNumber + 1], op = {32}, brend = 1, loop = scratch_ontime, dst = {
					{time = 0, x = geo.lane.each_x[keysNumber + 1], y = geo.lane.y, w = geo.lane.each_w[keysNumber + 1], h = 0, a = a},
					{time = scratch_ontime, h = h}
				}
			})
			table.insert(skin.destination, {
				id = "keybeam_s", offset = 3, timer = timer[keysNumber + 1], op = {33}, brend = 1, dst = {
					{x = geo.lane.each_x[keysNumber + 1], y = geo.lane.y, w = geo.lane.each_w[keysNumber + 1], h = h, a = a}
				}
			})
		end
		-- away
		local key_offtime = 100
		for i = 1, keysNumber + 1 do
			table.insert(skin.destination, {
				id = "keybeam_"..kind[i], offset = 3, timer = timer[i] + 20, brend = 1, loop = key_offtime, acc = 2, dst = {
					{time = 0, x = geo.lane.each_x[i], y = geo.lane.y, w = geo.lane.each_w[i], h = h, a = a},
					{time = key_offtime, x = geo.lane.each_x[i] + geo.lane.each_w[i] / 2, w = 0, a = 0}
				}
			})
		end
	end
	-- notes
	table.insert(skin.destination, {id = "notes", offset = 30})
	-- 5keyscover
	if keysNumber == 5 then
		table.insert(skin.image,
			{id = "5keyscover", src = "src_5keyscover", x = 0, y = 0, w = -1, h = -1}
		)
		local x = geo.lane.each_x[keysNumber] + geo.lane.each_w[keysNumber]
		if isRightScratch() then
			x = geo.lane.x
		end
		table.insert(skin.destination, {id = "5keyscover", dst = {
			{x = x, y = geo.lane.y, w = geo.lane.fivekeycover_w, h = geo.lane.h}
		}})
	end
	-- lanecover/liftcover
	do
		table.insert(skin.slider,
			{id = "lanecover", src = "src_lanecover", x = 0, y = 0, w = -1, h = -1, angle = 2, range = geo.lane.h, type = 4}
		)
		table.insert(skin.hiddenCover,
			{id = "hiddencover", src = "src_hiddencover", x = 0, y = 0, w = -1, h = -1, disapearLine = geo.lane.y}
		)
		table.insert(skin.liftCover,
			{id = "liftcover", src = "src_liftcover", x = 0, y = 0, w = -1, h = -1, disapearLine = geo.lane.y}
		)
		table.insert(skin.image,
			{id = "duration_text_minus", src = "src_number_genshin_monospace_border", x = 45 * 11, y = 70, w = 45, h = 70}
		)
		append_all(skin.value, {
			number({id = "duration", src = "src_number_genshin_monospace_border", divx = 10, digit = 4, ref = 313}),
			number({id = "duration_min", src = "src_number_genshin_monospace_border", divx = 10, digit = 4, ref = 1320}),
			number({id = "duration_max", src = "src_number_genshin_monospace_border", divx = 10, digit = 4, ref = 1324}),
			number({id = "num_lanecover", src = "src_number_genshin_monospace_border", divx = 10, digit = 4, ref = 14}),
			number({id = "num_lift", src = "src_number_genshin_monospace_border", divx = 10, digit = 4, ref = 314}),
		})

		local cover_h = geo.lane.h
		local num_w = 18 local num_h = 28 local num_margin_y = 8
		local minmaxrate = 0.8

		-- duration(green number)
		local function duration_dst(_offset, op_additional, y, min_max_y)
			local duration_x = geo.lane.x + geo.lane.w * 0.55
			local duration_center_x = duration_x + num_w * 3 / 2
			local duration_color = {r = 100, g = 235, b = 100}
			return {
				{id = "duration", offset = _offset, op = merge_all({270}, op_additional), filter = 1, dst = {
					merge_all({x = duration_x, y = y, w = num_w, h = num_h}, duration_color)
				}},
				{id = "duration_min", offset = _offset, op = merge_all({270, 177}, op_additional), filter = 1, dst = {
					merge_all({x = duration_center_x - num_w * minmaxrate * 3.5, y = min_max_y, w = num_w * minmaxrate, h = num_h * minmaxrate}, duration_color)
				}},
				{id = "duration_text_minus", offset = _offset, op = merge_all({270, 177}, op_additional), filter = 1, dst = {
					merge_all({x = duration_center_x + num_w * minmaxrate * 1, y = min_max_y, w = num_w * minmaxrate, h = num_h * minmaxrate}, duration_color)
				}},
				{id = "duration_max", offset = _offset, op = merge_all({270, 177}, op_additional), filter = 1, dst = {
					merge_all({x = duration_center_x + num_w * minmaxrate * 1.5, y = min_max_y, w = num_w * minmaxrate, h = num_h * minmaxrate}, duration_color)
				}}
			}
		end

		-- hiddencover
		append_all(skin.destination, {
			{id = "hiddencover", dst = {
				{x = geo.lane.x, y = geo.lane.y - cover_h, w = geo.lane.w, h = cover_h},
			}},
		})

		-- liftcover
		append_all(skin.destination, {
			{id = "liftcover", dst = {
				{x = geo.lane.x, y = geo.lane.y - cover_h, w = geo.lane.w, h = cover_h},
			}},
			{id = "num_lift", offset = 3, op = {270, 272}, filter = 1, dst = {
				{x = geo.lane.x + geo.lane.w * 0.25, y = geo.lane.y - num_h - num_margin_y, w = num_w, h = num_h},
			}},
		})
		append_all(skin.destination, duration_dst(3, {272}, geo.lane.y - (num_h + num_margin_y), geo.lane.y - (num_h + num_h * minmaxrate + num_margin_y * 2)))

		-- lanecover(sudden)
		append_all(skin.destination, {
			{id = "lanecover", dst = {
				{x = geo.lane.x, y = header.h, w = geo.lane.w, h = cover_h},
			}},
			{id = "num_lanecover", offset = 4, op = {270}, filter = 1, dst = {
				{x = geo.lane.x + geo.lane.w * 0.25, y = header.h + num_margin_y, w = num_w, h = num_h},
			}},
		})
		append_all(skin.destination, duration_dst(4, {}, header.h + num_margin_y, header.h + num_h + num_margin_y * 2))

		-- duration without lanecover
		append_all(skin.destination, duration_dst(0, {-271}, header.h - (num_h + num_margin_y), header.h - (num_h + num_h * minmaxrate + num_margin_y * 2)))
	end
	-- judge
	table.insert(skin.destination, {id = "judge"})
	-- judgeDetail and ghostScore
	do
		local judge_y = geo.judge.y -- TODO 初期位置をjudgeのoffset("Judge offset")と連動したい
		local judge_h = geo.judge.h
		local h = 28
		local num_w = 18
		local display_time = 500

		local function position(total_w, isJudgeDetail)
			local position, anotherTypeAIsOn
			if isJudgeDetail then
				position = property.judgeDetailPosition.item
				anotherIsOnAndTypeA = not property.ghostScore.item.off.isSelected() and property.ghostScorePosition.item.typeA.isSelected()
			else -- ghostScore
				position = property.ghostScorePosition.item
				anotherIsOnAndTypeA = not property.judgeDetail.item.off.isSelected() and property.judgeDetailPosition.item.typeA.isSelected()
			end

			local x, y
			if position.typeA.isSelected() then
				if anotherIsOnAndTypeA then
					local between_space = 15
					if isJudgeDetail then
						x = geo.lane.center_x + between_space
					else
						x = geo.lane.center_x - (total_w + between_space)
					end
				else
					x = geo.lane.center_x - total_w / 2
				end
				y = judge_y + judge_h
			else
				local lane_side_margin = 8
				if is1P() then
					x = geo.lane.x + geo.lane.w + lane_side_margin
				else
					x = geo.lane.x - (total_w + lane_side_margin)
				end	
				if position.typeB.isSelected() then
					y = judge_y
				elseif position.typeC.isSelected() then
					y = geo.lane.y
				end
				if isJudgeDetail then
					y = y + h + 4
				end
			end
			return x, y
		end

		-- judge detail
		if not property.judgeDetail.item.off.isSelected() then
			-- fast/slow
			if property.judgeDetail.item.fastSlow.isSelected() then
				local w = 70
				append_all(skin.image, {
					{id = "image_fast", src = "src_fastslow", x = 0, y = 0, w = w, h = h},
					{id = "image_slow", src = "src_fastslow", x = 0, y = h, w = w, h = h},
				})
				local x, y = position(w, true)
				append_all(skin.destination, {
					{id = "image_fast", offsets = {3, 33}, op = {1242, 32}, loop = -1, timer = 46, filter = 1, dst = {
						{time = 0, x = x, y = y, w = w, h = h},
						{time = display_time}
					}},
					{id = "image_slow", offsets = {3, 33}, op = {1243, 32}, loop = -1, timer = 46, filter = 1, dst = {
						{time = 0, x = x, y = y, w = w, h = h},
						{time = display_time}
					}},
				})
			-- +-ms
			elseif property.judgeDetail.item.ms.isSelected() then
				local digit = 4
				local align = 0
				if not property.ghostScorePosition.item.typeA.isSelected() and is1P() then
					align = 1
				end
				append_all(skin.value, {
					number({id = "judge_diff_ms", src = "src_number_genshin_monospace_border", divx = 12, divy = 2, digit = digit, align = align, ref = 525}),
				})

				local total_w = num_w * digit
				local x, y = position(total_w, true)
				append_all(skin.destination, {
					{id = "judge_diff_ms", offsets = {3, 33}, draw = function() return main_state.number(525) >= 0 and main_state.option(32) end,
						loop = -1, timer = 46, filter = 1, dst = {
						{time = 0, x = x, y = y, w = num_w, h = h, r = 0, g = 0, b = 255},
						{time = display_time}
					}},
					{id = "judge_diff_ms", offsets = {3, 33}, draw = function() return main_state.number(525) < 0 and main_state.option(32) end,
						loop = -1, timer = 46, filter = 1, dst = {
						{time = 0, x = x, y = y, w = num_w, h = h, r = 255, g = 0, b = 0},
						{time = display_time}
					}},
				})
			end
		end

		-- ghost score
		if not property.ghostScore.item.off.isSelected() then
			local ref
			if property.ghostScore.item.target.isSelected() then ref = 153
			elseif property.ghostScore.item.mybest.isSelected() then ref = 152
			end
			local digit = 5
			local align = 0
			if not property.ghostScorePosition.item.typeA.isSelected() and is1P() then
				align = 1
			end

			local src = "src_number_genshin_monospace_border"
			if property.ghostScoreColor.item.red.isSelected() then
				src = "src_number_genshin_monospace_border_red"
			end
			append_all(skin.value, {
				number({id = "ghostscore", src = src, divx = 12, divy = 2, digit = digit, align = align, ref = ref}),
			})

			local total_w = num_w * digit
			local x, y = position(total_w, false)
			append_all(skin.destination, {
				{id = "ghostscore", offsets = {3, 33}, op = {32}, loop = -1, timer = 46, filter = 1, dst = {
					{time = 0, x = x, y = y, w = num_w, h = h},
					{time = display_time}
				}},
			})
		end
	end
	-- loading progress & stagefile
	do
		table.insert(skin.value,
			number({id = "loading_progress_number", src = "src_number_kenney_future", divx = 10, digit = 3, ref = 165})
		)
		table.insert(skin.graph,
			{id = "graph_loading_progress", src = "src_white1dot", x = 0, y = 0, w = 400, h = 10, angle = 0, type = 102}
		)

		local y = geo.lane.y + 180
		local graph_h = 24 local number_w = 22 local number_h = 20
		local space_h = 4
		local stagefile_w = geo.lane.w * 0.75 local stagefile_h = stagefile_w * 3 / 4
		local stagefile_x = geo.lane.center_x - stagefile_w / 2 local stagefile_y = y + graph_h + space_h
		local frame_w = 5 local frame_h = 5
		local dst = {
			-- stagefile
			{id = -110, op = {80}, dst = {
				{x = stagefile_x, y = stagefile_y, w = stagefile_w, h = stagefile_h},
			}},
			{id = -100, op = {80}, stretch = 1, dst = {
				{x = stagefile_x, y = stagefile_y, w = stagefile_w, h = stagefile_h},
			}},
			-- loading progress
			{id = -110, op = {80}, dst = {
				{x = stagefile_x, y = y, w = stagefile_w, h = graph_h},
			}},
			{id = "loading_progress_number", op = {80}, filter = 1, dst = {
				{x = geo.lane.center_x - number_w * 3 / 2, y = y + 2, w = number_w, h = number_h},
			}},
			{id = "text_image_%", op = {80}, filter = 1, dst = {
				{x = geo.lane.center_x + number_w * 3 / 2 + 2, y = y + 2, w = number_w, h = number_h},
			}},
			{id = "graph_loading_progress", op = {80}, blend = 9, dst = {
				{x = stagefile_x, y = y, w = stagefile_w, h = graph_h, r = 220, g = 220, b = 220},
			}},
			-- stagefileとprogressの間のスペースの穴埋め
			{id = -111, op = {80}, dst = {
				{x = stagefile_x, y = y + graph_h, w = stagefile_w, h = space_h, r = 100, g = 100, b = 100},
			}},
		}
		dst = merge_all(dst, frame_dst(stagefile_x - frame_w, y - frame_h, stagefile_w + frame_w * 2, stagefile_h + graph_h + space_h + frame_h * 2, 255, frame_w, frame_h, {op = {80}}))
		-- レーンカバー変更中は透過(緑数字が見えるようにするため)
		local dst_default = deepcopy(dst)
		for i, v in ipairs(dst_default) do
			table.insert(dst_default[i].op, -270)
		end
		append_all(skin.destination, dst_default)
		local dst_lanecover_changing = deepcopy(dst)
		for i, v in ipairs(dst_lanecover_changing) do
			table.insert(dst_lanecover_changing[i].op, 270)
			dst_lanecover_changing[i].dst[1].a = 100
		end
		append_all(skin.destination, dst_lanecover_changing)
	end
	-- ready and finish display
	do
		local image_w = 400 local image_h = 60
		append_all(skin.image, {
			{id = "image_ready", src = "src_ready_finish", x = 0, y = 0, w = image_w, h = image_h},
			{id = "image_finish", src = "src_ready_finish", x = 0, y = image_h, w = image_w, h = image_h}
		})

		local x = geo.lane.center_x - image_w / 2
		local ready_y = geo.lane.y + 200
		local finish_y = geo.lane.y + 350 -- fullcombo textと同じ
		local w = image_w local h = image_h
		append_all(skin.destination, {
			{id = "image_ready", timer = 40, loop = -1, dst = {
				-- 透明から現れて、落ちて消える
				{time = 0, x = x, y = ready_y, w = w, h = h, a = 0},
				{time = 200, a = 255},
				{time = 500},
				{time = 1000, y = ready_y - 40, a = 0}
			}},
			{id = "image_finish", timer = 143,
				draw = function() return main_state.timer(48) == main_state.timer_off_value end, loop = -1, dst = {
				-- 透明から現れて横長に消える
				{time = 0, x = x, y = finish_y, w = w, h = h, a = 0},
				{time = 200, a = 255},
				{time = 1000},
				{time = 1250, x = x - 100, y = finish_y + h * 0.25, w = w + 100 * 2, h = h * 0.5, a = 0}
			}},
		})
	end

	-- gaugearea
	geo.gaugearea = {}
	geo.gaugearea.protrude_x = 30
	geo.gaugearea.padding_x = 8
	geo.gaugearea.x = geo.lane.x - geo.gaugearea.protrude_x
	if is2P() then
		geo.gaugearea.x = geo.lane.x - geo.gaugearea.padding_x
	end
	geo.gaugearea.w = geo.lane.w + geo.gaugearea.protrude_x + geo.gaugearea.padding_x

	geo.gauge = {}
	geo.gauge.x = geo.gaugearea.x + geo.gaugearea.padding_x
	if is2P() then
		geo.gauge.x = geo.gaugearea.x + geo.gaugearea.padding_x
	end
	geo.gauge.y = 138
	geo.gauge.w = geo.gaugearea.w - geo.gaugearea.padding_x * 2
	geo.gauge.h = 35
	-- gauge area background
	table.insert(skin.destination, {id = -110, dst = {
		{x = geo.gaugearea.x, y = 0, w = geo.gaugearea.w, h = header.h - geo.lane.h - 4, a = 240},
	}})
	-- gauge
	do
		local x = geo.gauge.x local w = geo.gauge.w
		if is2P() then
			x = geo.gauge.x + geo.gauge.w
			w = -geo.gauge.w
		end
		table.insert(skin.destination, {id = "gauge", dst = {
			{x = x, y = geo.gauge.y, w = w, h = geo.gauge.h},
		}})
	end
	-- gaugevalue
	do
		append_all(skin.value, {
			number({id = "gaugevalue", src = "src_number_newtown", divx = 10, digit = 3, ref = 107}),
			number({id = "gaugevalue_ad", src = "src_number_newtown", divx = 10, digit = 1, ref = 407}),
		})
		local y = geo.gauge.y + geo.gauge.h + 7 local w = 35 local h = 35
		local x = geo.lane.x + geo.lane.w - w * 5
		if is2P() then
			x = geo.lane.x
		end
		append_all(skin.destination, {
			{id = "gaugevalue", dst = {
				{x = x, y = y, w = w, h = h},
			}},
			{id = "text_image_dot", dst = {
				{x = x + w * 3 + 1, y = y, w = w, h = h},
			}},
			{id = "gaugevalue_ad", dst = {
				{x = x + w * 3 + 10, y = y, w = w, h = h},
			}},
			{id = "text_image_%", dst = {
				{x = x + w * 4 + 12, y = y, w = 24, h = 20},
			}},
		})
	end
	-- judgerank & ramdom
	do
		local h = 18 local y = geo.gauge.y + geo.gauge.h + 6
		-- judgerank
		local judgerank_image_w = 183 local judgerank_image_h = 36
		for i = 1, 5 do
			table.insert(skin.image, {
				id = "judgerank_"..i, src = "src_rank_random", x = 0, y = judgerank_image_h * (i - 1), w = judgerank_image_w, h = judgerank_image_h
			})
		end
		local judgerank_w = judgerank_image_w * h / judgerank_image_h
		local judgerank_x = geo.lane.x
		if is2P() then
			judgerank_x = geo.lane.x + geo.lane.w - judgerank_w
		end
		for i = 1, 5 do
			table.insert(skin.destination, {id = "judgerank_"..i, op = {185 - i}, filter = 1, dst = {
				{x = judgerank_x, y = y, w = judgerank_w, h = h},
			}})
		end
		-- random
		local random_image_w = 192 local random_image_h = 36
		table.insert(skin.image, {
			id = "random", src = "src_rank_random", x = 200, y = 0, w = random_image_w, h = random_image_h * 10, divy = 10, len = 10, ref = 42
		})
		local random_w = random_image_w * h / random_image_h
		local space_x = 15
		local random_x = geo.lane.x + judgerank_w + space_x
		if is2P() then
			random_x = geo.lane.x + geo.lane.w - (judgerank_w + space_x + random_w)
		end
		table.insert(skin.destination, {id = "random", filter = 1, dst = {
			{x = random_x, y = y, w = random_w, h = h},
		}})
	end
	-- cleared lamp display
	do
		local text_size = 15
		local text_align = 2
		if is2P() then
			text_align = 0
		end
		append_all(skin.text, {
			{id = "text_MAX", font = "genshin_bold", size = text_size, align = text_align, constantText = "MAX"},
			{id = "text_PERFECT", font = "genshin_bold", size = text_size, align = text_align, constantText = "PERFECT"},
			{id = "text_FULLCOMBO", font = "genshin_bold", size = text_size, align = text_align, constantText = "FULLCOMBO"},
			{id = "text_AUTOPLAY", font = "genshin_bold", size = text_size, align = text_align, constantText = "AUTOPLAY"},
		})

		local line_x = geo.gauge.x local line_y = geo.lane.y - 8 local line_w = geo.gauge.w * 0.6 local line_h = 2
		local text_x = line_x + line_w local text_y = line_y - text_size - 3
		if is2P() then
			line_x = geo.gauge.x + geo.gauge.w - line_w
			text_x = line_x
		end
		local cycle = 80
		local op_gr = 2242 local op_gd = 2243 local op_bd = 2244 local op_pr = 2245
		local op_auto = 33
		local auto_color = {{r = 200, g = 200, b = 200}, {a = 220}}
		local max_color = {{r = 255, g = 255, b = 255}, {r = 255, g = 200, b = 100}}
		local perfect_color = {{r = 100, g = 255, b = 255}, {r = 255, g = 255, b = 100}}
		local fullcombo_color = {{r = 255, g = 255, b = 255}, {r = 100, g = 255, b = 255}}
		local missed_color = {r = 200, g = 200, b = 0}
		append_all(skin.destination, {
			-- autoplay
			{id = -111, op = {op_auto}, dst = {
				merge_all({x = line_x, y = line_y, w = line_w, h = line_h}, auto_color[1]),
				merge_all({time = cycle}, auto_color[2])
			}},
			{id = "text_AUTOPLAY", op = {op_auto}, filter = 1, dst = {
				merge_all({x = text_x, y = text_y, w = text_size, h = text_size}, auto_color[1]),
				merge_all({time = cycle}, auto_color[2])
			}},
			-- max
			{id = -111, op = {-op_auto, -op_gr, -op_gd, -op_bd, -op_pr}, dst = {
				merge_all({x = line_x, y = line_y, w = line_w, h = line_h}, max_color[1]),
				merge_all({time = cycle}, max_color[2])
			}},
			{id = "text_MAX", op = {-op_auto, -op_gr, -op_gd, -op_bd, -op_pr}, filter = 1, dst = {
				merge_all({x = text_x, y = text_y, w = text_size, h = text_size}, max_color[1]),
				merge_all({time = cycle}, max_color[2])
			}},
			-- perfect
			{id = -111, op = {op_gr, -op_gd, -op_bd, -op_pr}, dst = {
				merge_all({x = line_x, y = line_y, w = line_w, h = line_h}, perfect_color[1]),
				merge_all({time = cycle}, perfect_color[2])
			}},
			{id = "text_PERFECT", op = {op_gr, -op_gd, -op_bd, -op_pr}, filter = 1, dst = {
				merge_all({x = text_x, y = text_y, w = text_size, h = text_size}, perfect_color[1]),
				merge_all({time = cycle}, perfect_color[2])
			}},
			-- fullcombo
			{id = -111, op = {op_gd, -op_bd, -op_pr}, dst = {
				merge_all({x = line_x, y = line_y, w = line_w, h = line_h}, fullcombo_color[1]),
				merge_all({time = cycle}, fullcombo_color[2])
			}},
			{id = "text_FULLCOMBO", op = {op_gd, -op_bd, -op_pr}, filter = 1, dst = {
				merge_all({x = text_x, y = text_y, w = text_size, h = text_size}, fullcombo_color[1]),
				merge_all({time = cycle}, fullcombo_color[2])
			}},
			-- missed
			{id = -111, draw = function()
				return main_state.option(op_bd) or main_state.option(op_pr)
				end, dst = {
					merge_all({x = line_x, y = line_y, w = line_w, h = line_h}, missed_color),
				}
			},
		})
	end
	-- score
	do
		table.insert(skin.value,
			number({id = "exscore", src = "src_number_newtown", divx = 10, digit = 5, ref = 71})
		)
		local image_w = 430 local image_h = 70
		table.insert(skin.image,
			{id = "text_image_exscore", src = "src_othertexts", x = 0, y = image_h * 3, w = image_w, h = image_h}
		)

		local x = geo.gauge.x local y = geo.gauge.y - 32
		local text_size = 16
		table.insert(skin.destination, {id = "text_image_exscore", filter = 1, dst = {
			{x = x + 4, y = y, w = image_w * text_size / image_h * 1.06, h = text_size},
		}})
		local num_size = 20
		table.insert(skin.destination, {id = "exscore", dst = {
			{x = x + geo.gauge.w * 0.5 - num_size * 6, y = y, w = num_size, h = num_size},
		}})
	end
	-- hispeed
	do
		append_all(skin.value, {
			number({id = "hispeed", src = "src_number_newtown", divx = 10, digit = 2, ref = 310}),
			number({id = "hispeed_ad", src = "src_number_newtown", divx = 10, digit = 2, padding = 1, ref = 311}),
		})
		local image_w = 450 local image_h = 70
		table.insert(skin.image,
			{id = "text_images_hispeed", src = "src_othertexts", x = 0, y = image_h * 4, w = image_w, h = image_h * 5, divy = 5, len = 5, ref = 55}
		)
		local text_x = geo.gauge.x + geo.gauge.w * 0.56 local y = geo.gauge.y - 32 local w = 18 local h = 18
		local num_x = geo.gauge.x + geo.gauge.w - w * 5
		local text_images_h = 16
		append_all(skin.destination, {
			{id = "text_images_hispeed", filter = 1, dst = {
				{x = text_x, y = y, w = image_w * text_images_h / image_h * 1.06, h = text_images_h}, -- 1.06は横幅調整
			}},
			{id = "hispeed", dst = {
				{x = num_x, y = y, w = w, h = h},
			}},
			{id = "text_image_dot", dst = {
				{x = num_x + w * 2 + 4, y = y, w = w, h = h},
			}},
			{id = "hispeed_ad", dst = {
				{x = num_x + w * 3 - 6, y = y, w = w, h = h},
			}},
		})
	end
	-- lowerLaneArea
	do
		append_all(skin.judgegraph, {
			{id = "lla_notesgraph_notestype", type = 0, backTexOff = 1},
			{id = "lla_notesgraph_judge", type = 1, backTexOff = 1},
			{id = "lla_notesgraph_fastslow", type = 2, backTexOff = 1}
		})
		table.insert(skin.bpmgraph,
			{id = "lla_bpmgraph"}
		)
		table.insert(skin.timingvisualizer,
			{id = "lla_timingvisualizer"}
		)
		table.insert(skin.image,
			{id = "lla_customizedimage", src = "src_lowerlanearea_customizedimage", x = 0, y = 0, w = -1, h = -1}
		)

		local x = geo.gauge.x local y = 11 local w = geo.gauge.w local h = 80
		local lla_id
		if property.lowerLaneArea.item.notesGraphNotesType.isSelected() then
			lla_id = "lla_notesgraph_notestype"
		elseif property.lowerLaneArea.item.notesGraphJudge.isSelected() then
			lla_id = "lla_notesgraph_judge"
		elseif property.lowerLaneArea.item.notesGraphFastSlow.isSelected() then
			lla_id = "lla_notesgraph_fastslow"
		elseif property.lowerLaneArea.item.timingVisualizer.isSelected() then
			lla_id = "lla_timingvisualizer"
		elseif property.lowerLaneArea.item.customizedImage.isSelected() then
			lla_id = "lla_customizedimage"
		elseif property.lowerLaneArea.item.banner.isSelected() then
			lla_id = -102
		end
		table.insert(skin.destination,
			{id = lla_id, dst = {
				{x = x, y = y, w = w, h = h},
			}}
		)
		if string.match(lla_id, "notesgraph") then
			table.insert(skin.destination,
				{id = "bpmgraph", op = {177}, dst = {
					{x = x, y = y, w = w, h = h},
				}}
			)
		end
		-- darkness
		local darkness_a = 0
		if property.lowerLaneArea.item.notesGraphNotesType.isSelected() or property.lowerLaneArea.item.notesGraphJudge.isSelected() or property.lowerLaneArea.item.notesGraphFastSlow.isSelected() then
			darkness_a = 130
		end
		table.insert(skin.destination,
			{id = -110, dst = {
				{x = x, y = y, w = w, h = h, a = darkness_a + offset.lowerlanearea_darkness.a},
			}}
		)
	end
	-- total
	if property.total.item.on.isSelected() then
		local align = 0
		if is2P() then
			align = 2
		end
		append_all(skin.text, {
			{id = "gaugetotal", font = "genshin_bold", size = 18, align = align, value = function()
				local total = main_state.number(368)
				local totalnotes = main_state.number(74)
				local base_total = math.max(260.0, 7.605 * totalnotes / (0.01 * totalnotes + 6.5))
				local total_percentage = total / base_total * 100
				total_percentage = math.ceil(total_percentage * 100) / 100 -- string.format("%.2f", total_percentage) が機能しない代わり
				return total .. " (" .. total_percentage .. "%)"  end},
		})
		local w = 11 local h = 16
		local x = geo.lane.x
		if is2P() then
			x = geo.lane.x + geo.lane.w
		end
		table.insert(skin.destination,
			{id = "gaugetotal", dst = {
				{x = x, y = 196, w = w, h = h, r = 100, g = 100, b = 100},
			}}
		)
	end
	-- bomb
	do
		local w local h
		local divx = 4 local divy = 4

		-- get bomb settings from <bomb_image_filename>.lua
		local path = string.match(skin_config.get_path("customize/bomb/" .. skin_config.file_path["Bomb"]), "(.+)%.png$") .. ".lua"
		local exist, setting = pcall(dofile, path)
		if exist and setting then
			if setting.w then w = setting.w end
			if setting.h then h = setting.h end
			if setting.divx then divx = setting.divx end
			if setting.divy then divy = setting.divy end
		end
		local is16x4 = divx == 16 and divy == 4 and w and h

		local function bombTimer(i) return 50 + i % (keysNumber + 1) end
		local function lnBombTimer(i) return 70 + i % (keysNumber + 1) end

		local normal_cycle = 250 local ln_cycle = 160
		if is16x4 then
			local function lnpos_y(i)
				if i == keysNumber + 1 then
					return h * 3
				elseif i % 2 == 1 then
					return h
				else
					return h * 2
				end
			end
			for i = 1, keysNumber + 1 do
				append_all(skin.image, {
					{id = "bomb_"..i, src = "src_bomb", x = 0, y = 0, w = -1, h = h, divx = 16, timer = bombTimer(i), cycle = normal_cycle},
					{id = "lnbomb_"..i, src = "src_bomb", x = 0, y = lnpos_y(i), w = w * 8, h = h, divx = 8, timer = lnBombTimer(i), cycle = ln_cycle},
					{id = "slowbomb_"..i, src = "src_bomb", x = 0, y = h, w = -1, h = h, divx = 16, timer = bombTimer(i), cycle = normal_cycle},
					{id = "fastbomb_"..i, src = "src_bomb", x = 0, y = h * 2, w = -1, h = h, divx = 16, timer = bombTimer(i), cycle = normal_cycle}
				})
			end
		else
			for i = 1, keysNumber + 1 do
				if w and h then
					table.insert(skin.image, {
						id = "bomb_"..i, src = "src_bomb", x = 0, y = 0, w = w * divx, h = h * divy, divx = divx, divy = divy, timer = bombTimer(i), cycle = normal_cycle
					})
					local _divx = divx local _divy = divy / 2
					if divy == 1 then
						_divx = divx / 2
						_divy = divy
					end
					table.insert(skin.image, {
						id = "lnbomb_"..i, src = "src_bomb", x = 0, y = 0, w = w * _divx, h = h * _divy, divx = _divx, divy = _divy, lnBombTimer(i), cycle = ln_cycle
					})
				else
					table.insert(skin.image, {
						id = "bomb_"..i, src = "src_bomb", x = 0, y = 0, w = -1, h = -1, divx = divx, divy = divy, timer = bombTimer(i), cycle = normal_cycle
					})
					table.insert(skin.image, {
						id = "lnbomb_"..i, src = "src_bomb", x = 0, y = 0, w = -1, h = -1, divx = divx, divy = divy, timer = lnBombTimer(i), cycle = ln_cycle
					})
				end
			end
		end

		-- TODO fast/slowボムのON/OFF作る？
		local size_w = geo.lane.each_w[keysNumber + 1] * 2 + offset.bomb.w
		local size_h = size_w
		if w and h then
			if w < h then
				size_h = h * size_w / w
			else
				size_w = w * size_h / h
			end
		end
		local y = geo.lane.y - size_h / 2 + 10 / 2 -- judgelineのh / 2を足す
		for i = 1, keysNumber + 1 do
			local x = geo.lane.each_x[i] + geo.lane.each_w[i] / 2 - size_w / 2
			if is16x4 then
				append_all(skin.destination, {
					{id = "bomb_"..i, offset = 3, loop = -1, filter = 1, timer = bombTimer(i), op = {-1242, -1243}, blend = 2, dst = {
						{time = 0, x = x, y = y, w = size_w, h = size_h},
						{time = normal_cycle - 1}
					}},
					{id = "fastbomb_"..i, offset = 3, loop = -1, filter = 1, timer = bombTimer(i), op = {1242}, blend = 2, dst = {
						{time = 0, x = x, y = y, w = size_w, h = size_h},
						{time = normal_cycle - 1}
					}},
					{id = "slowbomb_"..i, offset = 3, loop = -1, filter = 1, timer = bombTimer(i), op = {1243}, blend = 2, dst = {
						{time = 0, x = x, y = y, w = size_w, h = size_h},
						{time = normal_cycle - 1}
					}},
					{id = "lnbomb_"..i, offset = 3, loop = ln_cycle, filter = 1, timer = lnBombTimer(i), blend = 2, dst = {
						{time = 0, x = x, y = y, w = size_w, h = size_h},
						{time = ln_cycle - 1}
					}}
				})
			else
				append_all(skin.destination, {
					{id = "bomb_"..i, offset = 3, loop = -1, filter = 1, timer = bombTimer(i), blend = 2, dst = {
						{time = 0, x = x, y = y, w = size_w, h = size_h},
						{time = normal_cycle - 1}
					}},
					{id = "lnbomb_"..i, offset = 3, loop = ln_cycle, filter = 1, timer = lnBombTimer(i), blend = 2, dst = {
						{time = 0, x = x, y = y, w = size_w, h = size_h},
						{time = ln_cycle - 1}
					}}
				})
			end
		end
	end
	-- fullcombo effect
	do
		local color = {r = 255, g = 255, b = 255}

		-- glow
		do
			append_all(skin.image, {
				{id = "fullcombo_glow", src = "src_fullcombo_glow", x = 0, y = 0, w = -1, h = -1},
			})
			append_all(skin.destination, {
				{id = "fullcombo_glow", timer = 48, loop = -1, dst = {
					-- 下から伸びて、細くなって消える
					merge_all({time = 0, x = geo.lane.x, y = geo.lane.y, w = geo.lane.w, h = 0}, color),
					{time = 100, h = geo.lane.h, acc = 2},
					{time = 1000, x = geo.lane.x + geo.lane.w / 2 - 10, w = 20, a = 230},
					{time = 1400, x = geo.lane.x + geo.lane.w / 2, w = 0, a = 0}
				}},
			})
		end

		-- circle
		do
			append_all(skin.image, {
				{id = "fullcombo_circle", src = "src_fullcombo_circle", x = 0, y = 0, w = -1, h = -1},
			})
			local size = geo.lane.w * 1.2
			append_all(skin.destination, {
				{id = "fullcombo_circle", timer = 48, loop = -1, dst = {
					merge_all({time = 0, x = geo.lane.center_x, y = geo.lane.y, w = 0, h = 0, acc = 2}, color),
					{time = 250, x = geo.lane.center_x - size / 2, y = geo.lane.y - size / 2, w = size, h = size},
					{time = 500, x = geo.lane.center_x - size * 1.2 / 2, y = geo.lane.y - size * 1.2 / 2, w = size * 1.2, h = size * 1.2, a = 0}
				}},
			})
		end

		-- ring
		do
			append_all(skin.image, {
				{id = "fullcombo_ring", src = "src_fullcombo_ring", x = 0, y = 0, w = -1, h = -1},
			})
			local size = 2500
			append_all(skin.destination, {
				{id = "fullcombo_ring", timer = 48, loop = -1, dst = {
					merge_all({time = 0, x = geo.lane.center_x, y = geo.lane.y, w = 0, h = 0, acc = 2}, color),
					{time = 600, x = geo.lane.center_x - size / 2, y = geo.lane.y - size / 2, w = size, h = size, a = 0}
				}},
			})
		end

		-- text
		do
			local text_h = 60 local text_w = 400
			append_all(skin.image, {
				{id = "fullcombo_glow", src = "src_fullcombo_glow", x = 0, y = 0, w = -1, h = -1},

				{id = "fullcombo_text_full", src = "src_fullcombo_text", x = 0, y = 0, w = text_w, h = text_h},
				{id = "fullcombo_text_combo", src = "src_fullcombo_text", x = 0, y = text_h, w = text_w, h = text_h}
			})

			local text_y = geo.lane.y + 350 local text_base_x = geo.lane.center_x - text_w / 2
			local move_x = 300
			local appear_time = 500
			append_all(skin.destination, {
				{id = "fullcombo_text_full", timer = 48, loop = -1, filter = 1, dst = {
					{time = 0, x = text_base_x - move_x, y = text_y + text_h, w = text_w, h = text_h, a = 0},
					{time = appear_time},
					{time = appear_time + 300, x = text_base_x - 10, a = 255},
					{time = appear_time + 1300, x = text_base_x + 10},
					{time = appear_time + 1600, x = text_base_x + move_x, a = 0}
				}},
				{id = "fullcombo_text_combo", timer = 48, loop = -1, filter = 1, dst = {
					{time = 0, x = text_base_x + move_x, y = text_y, w = text_w, h = text_h, a = 0},
					{time = appear_time},
					{time = appear_time + 300, x = text_base_x + 10, a = 255},
					{time = appear_time + 1300, x = text_base_x - 10},
					{time = appear_time + 1600, x = text_base_x - move_x, a = 0}
				}},
			})
		end
	end

	-- failed animation
	-- fall
	if property.failedAnimation.item.fall.isSelected() then
		table.insert(skin.image,
			{id = "failed", src = "src_failed", x = 0, y = 0, w = -1, h = -1}
		)
		table.insert(skin.destination, {id = "failed", timer = 3, loop = 500, dst = {
			{time = 0, x = 0, y = header.h, w = header.w, h = header.h, acc = 2},
			{time = 500, y = 0}
		}})
	end
	-- vertical close
	if property.failedAnimation.item.verticalClose.isSelected() then
		append_all(skin.image, {
			{id = "failed_upper", src = "src_failed", x = 0, y = 0, w = header.w, h = header.h / 2},
			{id = "failed_lower", src = "src_failed", x = 0, y = header.h / 2, w = header.w, h = header.h / 2}
		})
		append_all(skin.destination, {
			{id = "failed_upper", timer = 3, loop = 500, dst = {
				{time = 0, x = 0, y = header.h, w = header.w, h = header.h / 2, acc = 2},
				{time = 500, y = header.h / 2}
			}},
			{id = "failed_lower", timer = 3, loop = 500, dst = {
				{time = 0, x = 0, y = -header.h / 2, w = header.w, h = header.h / 2, acc = 2},
				{time = 500, y = 0}
			}},
		})
	end
	-- horizontal close
	if property.failedAnimation.item.horizontalClose.isSelected() then
		append_all(skin.image, {
			{id = "failed_left", src = "src_failed", x = 0, y = 0, w = header.w / 2, h = header.h},
			{id = "failed_right", src = "src_failed", x = header.w / 2, y = 0, w = header.w / 2, h = header.h}
		})
		append_all(skin.destination, {
			{id = "failed_left", timer = 3, loop = 500, dst = {
				{time = 0, x = -header.w / 2, y = 0, w = header.w / 2, h = header.h, acc = 2},
				{time = 500, x = 0}
			}},
			{id = "failed_right", timer = 3, loop = 500, dst = {
				{time = 0, x = header.w, y = 0, w = header.w / 2, h = header.h, acc = 2},
				{time = 500, x = header.w / 2}
			}},
		})
	end

	-- fadeout
	table.insert(skin.destination, {id = -110, timer = 2, loop = 500, dst = {
		{time = 0, x = 0, y = 0, w = header.w, h = header.h, a = 0},
		{time = 500, a = 255}
	}})

	return {
		header = header,
		skin = skin
	}
end

return main