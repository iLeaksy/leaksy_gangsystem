Config = Config or {}

Config.Fuel = 'LegacyFuel' --ps-fuel, lj-fuel, LegacyFuel

Config.stash ={
    ["ballas"] = vector3(111.63, -1978.63, 20.98),
    ["vagos"] = vector3(334.24, -2020.66, 21.89),
    ["families"] = vector3(-147.33, -1596.62, 34.83),
    ["cartel"] = vector3(1406.15, 1137.58, 114.44),
    ["triads"] = vector3(-689.25, -876.57, 24.5),
    ["lostmc"] = vector3(986.17, -115.59, 73.86),
}

Config.ReketIznos = math.random(1000,2500)

Config.Protection = {
    ["families"] = {
        ["PedLocation"] = vector4(-19.32, -1483.51, 30.64, 9.06),
        ["Width"] = 190.0,
        ["Height"] = 350.0,
        ["ProtectionPayout"] = 'cash',
    },
    ["ballas"] = {
        ["PedLocation"] = vector4(-41.98, -1749.0, 29.42, 132.04),
        ["Width"] = 190.0,
        ["Height"] = 350.0,
        ["ProtectionPayout"] = 'weapons',
    },
}

Config.Blips = {
    ["ballas"] = {
        ["Location"] = vector3(41.25, -1821.12, 24.46),
        ["Width"] = 190.0,
        ["Height"] = 350.0,
        ["Color"] = 27,
        ["Rotation"] = 90.00,
    },
    ["vagos"] = {
        ["Location"] = vector3(296.56, -2008.3, 19.62),
        ["Width"] = 250.0,
        ["Height"] = 250.0,
        ["Color"] = 33,
        ["Rotation"] = 90.00,
    },
    ["families"] = {
        ["Location"] = vector3(-119.23, -1529.47, 34.0),
        ["Width"] = 425.0,
        ["Height"] = 250.0,
        ["Color"] = 43,
        ["Rotation"] = 90.00,
    },
    ["cartel"] = {
        ["Location"] = vector3(1408.54, 1122.2, 114.84),
        ["Width"] = 250.0,
        ["Height"] = 250.0,
        ["Color"] = 65,
        ["Rotation"] = 0.00,
    },
    ["triads"] = {
        ["Location"] = vector3(-640.14, -894.46, 24.62),
        ["Width"] = 250.0,
        ["Height"] = 150.0,
        ["Color"] = 1,
        ["Rotation"] = 0.00,
    },
    ["lostmc"] = {
        ["Location"] = vector3(974.95, -112.25, 74.35),
        ["Width"] = 150.0,
        ["Height"] = 100.0,
        ["Color"] = 68,
        ["Rotation"] = 160.00,
    },
}



Config.Gangs = {
    ["ballas"] = {
        ["VehicleSpawner"] = vector4(115.28, -1950.2, 20.7, 348.51),
        ["GarageLocation"] = vector4(112.79, -1948.22, 20.18, 313.85),
        ["colors"] = { 145, 0 }, ---  primary and secondary colors id https://wiki.rage.mp/index.php?title=Vehicle_Colors
        ["vehicles"] = {
            ["benzc32"] = "Merkedes C32",
            ["rumpo3"] = "RumpoXL",
            ["manchez"] = "Manchez",
        },
    },
    ["vagos"] = {
        ["VehicleSpawner"] = vector4(336.68, -2028.67, 21.65, 151.9),
        ["GarageLocation"] = vector4(332.84, -2031.22, 21.23, 137.6),
        ["colors"] = { 89, 0 }, ---  primary and secondary colors id https://wiki.rage.mp/index.php?title=Vehicle_Colors
        ["vehicles"] = {
            ["benzc32"] = "Merkedes C32",
            ["rumpo3"] = "RumpoXL",
            ["manchez"] = "Manchez",
        },
    },
    ["families"] = {
        ["VehicleSpawner"] = vector4(-154.74, -1579.15, 34.7, 55.06),
        ["GarageLocation"] = vector4(-157.95, -1577.23, 34.75, 319.09),
        ["colors"] = { 125, 0}, ---  primary and secondary colors id https://wiki.rage.mp/index.php?title=Vehicle_Colors
        ["vehicles"] = {
            ["benzc32"] = "Merkedes C32",
            ["rumpo3"] = "RumpoXL",
            ["manchez"] = "Manchez",
        },
    }, 
    ["cartel"] = {
        ["VehicleSpawner"] =vector4(1408.54, 1122.2, 114.84, 184.36),
        ["GarageLocation"] = vector4(1406.52, 1118.82, 114.84, 91.46),
        ["colors"] = { 134, 0 }, ---  primary and secondary colors id https://wiki.rage.mp/index.php?title=Vehicle_Colors
        ["vehicles"] = {
            ["benzc32"] = "Merkedes C32",
            ["rumpo3"] = "RumpoXL",
            ["manchez"] = "Manchez",
        },
    }, 
    ["triads"] = {
        ["VehicleSpawner"] = vector4(-680.77, -877.22, 24.5, 93.0),
        ["GarageLocation"] = vector4(-678.92, -880.57, 24.49, 162.06),
        ["colors"] = { 44, 0 }, ---  primary and secondary colors id https://wiki.rage.mp/index.php?title=Vehicle_Colors
        ["vehicles"] = {
            ["benzc32"] = "Merkedes C32",
            ["rumpo3"] = "RumpoXL",
            ["manchez"] = "Manchez",
        },
    }, 
    ["lostmc"] = {
        ["VehicleSpawner"] = vector4(974.95, -112.25, 74.35, 191.45),
        ["GarageLocation"] = vector4(977.8, -117.51, 74.18, 144.82),
        ["colors"] = { 68, 0 }, ---  primary and secondary colors id https://wiki.rage.mp/index.php?title=Vehicle_Colors
        ["vehicles"] = {
            ["benzc32"] = "Merkedes C32",
            ["rumpo3"] = "RumpoXL",
            ["manchez"] = "Manchez",
        },
    }, 
}
