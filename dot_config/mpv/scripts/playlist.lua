local cursor_pos = -1

local display_list = function(offset)
	local playlist = mp.get_property_native("playlist")
	local playlist_pos = mp.get_property_number("playlist-pos")
	local upper_pos = 0
	local lower_pos = #playlist - 1
	if #playlist > 7 then
		if cursor_pos < 3 then
			upper_pos = 0
			lower_pos = 6
		elseif cursor_pos > #playlist - 4 then
			upper_pos = #playlist - 7
			lower_pos = #playlist - 1
		else
			upper_pos = cursor_pos - 3
			lower_pos = cursor_pos + 3
		end
	end
	local lines = {}
	for i = upper_pos, lower_pos do
		if i == upper_pos and upper_pos ~= 0 then
			table.insert(lines, "-- " .. (upper_pos+1) .. " items --")
		elseif i == lower_pos and lower_pos ~= #playlist - 1 then
			table.insert(lines, "-- " .. (#playlist-lower_pos) .. " items --")
		elseif playlist[i+1].current then
			if i == cursor_pos then
				table.insert(lines, "▶ " .. playlist[i+1].filename)
			else
				table.insert(lines, "▷ " .. playlist[i+1].filename)
			end
		else
			if i == cursor_pos then
				table.insert(lines, "● " .. playlist[i+1].filename)
			else
				table.insert(lines, "○ " .. playlist[i+1].filename)
			end
		end
	end
	mp.osd_message(table.concat(lines, "\n"), 3600)
end

mp.add_key_binding("", "show", function()
	if mp.get_property_number("playlist-count") == 0 then return end
	if cursor_pos ~= -1 then return end

	mp.commandv("cycle", "pause")
	cursor_pos = mp.get_property_number("playlist-pos")
	if cursor_pos == -1 then cursor_pos = 0 end
	display_list()
	mp.add_forced_key_binding("j", "scrolldown", function()
		cursor_pos = cursor_pos + 1
		if cursor_pos == mp.get_property_number("playlist-count") then
			cursor_pos = 0
		end
		display_list()
	end, "repeatable")
	mp.add_forced_key_binding("k", "scrollup", function()
		cursor_pos = cursor_pos - 1
		if cursor_pos == -1 then
			cursor_pos = mp.get_property_number("playlist-count") - 1
		end
		display_list()
	end, "repeatable")
	mp.add_forced_key_binding("ENTER", "selectitem", function()
		mp.commandv("playlist-play-index", cursor_pos)
		cursor_pos = -1
		mp.remove_key_binding("scrollup")
		mp.remove_key_binding("scrolldown")
		mp.remove_key_binding("selectitem")
		mp.remove_key_binding("exitlist")
		mp.osd_message("", 0)
		mp.commandv("cycle", "pause")
	end, "repeatable")
	mp.add_forced_key_binding("ESC", "exitlist", function()
		cursor_pos = -1
		mp.remove_key_binding("scrollup")
		mp.remove_key_binding("scrolldown")
		mp.remove_key_binding("selectitem")
		mp.remove_key_binding("exitlist")
		mp.osd_message("", 0)
		mp.commandv("cycle", "pause")
	end, "repeatable")
end)

