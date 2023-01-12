rule = {
	matches = {
		{
			{ "node.name", "matches", "alsa_output.usb-GuangZhou_FiiO_Electronics_Co._Ltd_FiiO_K5_Pro-00.iec958-stereo" },
		},
	},
	apply_properties = {
		["audio.format"] = "S32_LE",
		["audio.rate"] = 48000
	},
}

table.insert(alsa_monitor.rules, rule)
