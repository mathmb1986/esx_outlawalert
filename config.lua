Config = {}

Config.Locale = 'fr'

-- Set the time (in minutes) during the player is outlaw
Config.Timer = 1

-- Set if show alert when player use gun
Config.GunshotAlert = true

-- Set if show when player do carjacking
Config.CarJackingAlert = true

-- Set if show when player fight in melee
Config.MeleeAlert = true

-- Set if show alert when cop steal vehicle 
Config.CopStealAlert = true

 -- Set if show alert when player do drug deal
 Config.DrugAlert = true

 -- Set if show alert when player speed
 Config.SpeedingAlert = true


--------------------------------------------------------------------


-- In seconds
Config.BlipGunTime = 5

-- Blip radius, in float value!
Config.BlipGunRadius = 50.0

-- In seconds
Config.BlipMeleeTime = 7

-- Blip radius, in float value!
Config.BlipMeleeRadius = 50.0

-- In seconds
Config.BlipJackingTime = 10

-- Blip radius, in float value!
Config.BlipJackingRadius = 50.0

-- Show notification when cops steal too?
Config.ShowCopsMisbehave = true

-- Jobs in this table are considered as cops
Config.WhitelistedCops = {
    'police'
}

--------------------------------------------------------------------
-- Intégration avec sd-aipolice
--------------------------------------------------------------------

-- Active / désactive le lien avec sd-aipolice
Config.UseSdAIPolice = true

-- Nom de la ressource sd-aipolice (pour l'export)
-- adapte si nécessaire
Config.SdAIPoliceResourceName = 'sd-aipolice'

-- Niveau d'étoiles à ajouter selon le délit
Config.WantedLevels = {
    CarJack = 2,   -- vol de véhicule
    Gunshot = 2,   -- coups de feu
    Melee   = 1,   -- bagarre
}
