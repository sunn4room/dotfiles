mp.add_key_binding("", "click", function()
	local mouse_pos = mp.get_property_native("mouse-pos")
	local hp = mouse_pos.x / mp.get_property_number("osd-width")
	local vp = mouse_pos.y / mp.get_property_number("osd-height")
	if vp > 0.7 then
		mp.commandv("seek", (hp * 100), "absolute-percent")
		mp.commandv("show-progress")
	else
		if hp < 0.2 then
			mp.commandv("playlist-prev")
		elseif hp < 0.5 then
			mp.commandv("seek", -30)
			mp.commandv("show-progress")
		elseif hp < 0.8 then
			mp.commandv("seek", 30)
			mp.commandv("show-progress")
		else
			mp.commandv("playlist-next")
		end
	end
end)
