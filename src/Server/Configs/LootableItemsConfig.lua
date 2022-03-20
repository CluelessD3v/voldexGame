return {
    SwordType = {
        ClassicSword = {
            Lootable = false, 
            Weight = 100,
            DisplayItem = {
                Name       = "ClassicSword",
                Instance   = workspace.DisplayItems.ClassicSword,
                Attributes = {
                    Damage   = 25,
                    ItemType = "SwordType",
                    Owner    = " ",
                    ItemName = "ClassicSword"
                },
                Tags = {"SwordType", "LootableItem"},
            },

            ToolItem = {
                Name       = "ClassicSword",
                Instance   = workspace.ToolItems.ClassicSword,
                Tags       = {"SwordType", "Weapon"},
                Attributes = {
                    Damage   = 25,
                    ItemType = "SwordType",
                    ItemName = "ClassicSword",
                }
            },
        },

        UberClassicSword = {
            Lootable = true,
            Weight = 100,
            DisplayItem = {
                Name       = "UberClassicSword",
                Instance   = workspace.DisplayItems.ClassicSword,
                Attributes = {
                    Damage   = 50,
                    ItemType = "SwordType",
                    Owner    = " ",
                    ItemName = "UberClassicSword"
                },
                Tags = {"SwordType", "LootableItem"},
            },

            ToolItem = {
                Name       = "UberClassicSword",
                Instance   = workspace.ToolItems.ClassicSword,
                Tags       = {"SwordType", "Weapon"},
                Attributes = {
                    Damage   = 50,
                    ItemType = "SwordType",
                    ItemName = "UberClassicSword",
                }
            },
        },

        SwordOfDarkness = {
            Lootable = true,
            Weight = 50,
            DisplayItem = {
                Name       = "SwordOfDarkness",
                Instance   = workspace.DisplayItems.SwordOfDarkness,
                Attributes = {
                    Damage   = 100,
                    ItemType = "SwordType",
                    Owner    = " ",
                    ItemName = "SwordOfDarkness"
                },
                Tags = {"SwordType", "LootableItem"},
            },

            ToolItem = {
                Name       = "SwordOfDarkness",
                Instance   = workspace.ToolItems.SwordOfDarkness,
                Tags       = {"SwordType", "Weapon"},
                Attributes = {
                    Damage   = 100,
                    ItemType = "SwordType",
                    ItemName = "SwordOfDarkness",
                }
            },
        },

        SwordofStarlight = {
            Lootable = true,
            Weight = 25,
            DisplayItem = {
                Name       = "SwordofStarlight",
                Instance   = workspace.DisplayItems.SwordofStarlight,
                Attributes = {
                    Damage   = 200,
                    ItemType = "SwordType",
                    Owner    = " ",
                    ItemName = "SwordofStarlight"
                },
                Tags = {"SwordType", "LootableItem"},
            },

            ToolItem = {
                Name       = "SwordofStarlight",
                Instance   = workspace.ToolItems.SwordofStarlight,
                Tags       = {"SwordType", "Weapon"},
                Attributes = {
                    Damage   = 200,
                    ItemType = "SwordType",
                    ItemName = "SwordofStarlight",
                }
            },
        },
    },

    

    
}