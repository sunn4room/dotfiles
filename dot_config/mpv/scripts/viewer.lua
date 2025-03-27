local watching = false

local display_state = function()
	mp.osd_message(string.format(
		"zoom: %f\nx: %f  y: %f",
		mp.get_property_number("video-zoom"),
		mp.get_property_number("video-pan-x"),
		mp.get_property_number("video-pan-y")
	), 3600)
end

mp.add_key_binding("", "toggle", function()
	if not watching then
		mp.commandv("cycle", "pause")
		display_state()
		mp.add_forced_key_binding("h", "moveleft", function()
			mp.commandv("add", "video-pan-x", 0.1/math.pow(2, mp.get_property_number("video-zoom")))
			display_state()
		end, "repeatable")
		mp.add_forced_key_binding("l", "moveright", function()
			mp.commandv("add", "video-pan-x", -0.1/math.pow(2, mp.get_property_number("video-zoom")))
			display_state()
		end, "repeatable")
		mp.add_forced_key_binding("k", "moveup", function()
			mp.commandv("add", "video-pan-y", 0.1/math.pow(2, mp.get_property_number("video-zoom")))
			display_state()
		end, "repeatable")
		mp.add_forced_key_binding("j", "movedown", function()
			mp.commandv("add", "video-pan-y", -0.1/math.pow(2, mp.get_property_number("video-zoom")))
			display_state()
		end, "repeatable")
		mp.add_forced_key_binding("i", "zoomin", function()
			mp.commandv("add", "video-zoom", 0.1)
			display_state()
		end, "repeatable")
		mp.add_forced_key_binding("o", "zoomout", function()
			mp.commandv("add", "video-zoom", -0.1)
			display_state()
		end, "repeatable")
		watching = true
	else
		watching = false
		mp.commandv("set", "video-zoom", 0)
		mp.commandv("set", "video-pan-x", 0)
		mp.commandv("set", "video-pan-y", 0)
		mp.remove_key_binding("moveleft")
		mp.remove_key_binding("moveright")
		mp.remove_key_binding("moveup")
		mp.remove_key_binding("movedown")
		mp.remove_key_binding("zoomin")
		mp.remove_key_binding("zoomout")
		mp.osd_message("", 0)
		mp.commandv("cycle", "pause")
	end
end)
