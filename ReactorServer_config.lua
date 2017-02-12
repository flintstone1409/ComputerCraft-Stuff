-- ReactorServer_config
-- Pastebin ID is XCJUA6NS

autodetect = 1 -- Autodetect scans network for devices. Change to 0 if you have more peripherals connected than you want to use.
napDuration = 0.5
ignoredPercentage = 20 -- number between 1 and 100, how much percent should be ignored while calculating

reactors = { -- don't forget ";" behind each line!
	r1 = "BigReactors-Reactor_0";
	r2 = "BigReactors-Reactor_1";
}

capacitors = { -- don't forget ";" behind each line!
	c1 = "capacitor_bank_0";
	c2 = "capacitor_bank_1";
}

monitors = { -- don't forget ";" behind each line!
	m1 = "monitor_0";
	m2 = "monitor_1";
}