
sound.Add( {
	name = "LVS.ION_CANNON_FIRE",
	channel = CHAN_STATIC,
	volume = 1,
	level = 120,
	pitch = {98, 102},
	sound = {
		"^lvs/tournament/weapons/laserrifle/ion_cannon_shot1.wav",
		"^lvs/tournament/weapons/laserrifle/ion_cannon_shot2.wav",
		"^lvs/tournament/weapons/laserrifle/ion_cannon_shot3.wav",
	}
} )

if CLIENT then return end

resource.AddWorkshop( "3317866011" )