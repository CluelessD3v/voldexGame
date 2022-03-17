return {
    SwordType = {
        ClassicSword = {
            Weight = 100,
            DisplayItem = {
                Name       = "ClassicSword",
                Instance   = workspace.ClassicSword,
                Attributes = {
                    Damage   = 25,
                    ItemType = "SwordType",
                },
                Tags = {"SwordType", "LootableItem"},

                ObjectValues = {
                    Owner = {
                        Type = "ObjectValue",
                        
                    }
                },
            },

            ToolItem = {
                Name       = "ClassicSword",
                Instance   = workspace.Swords.ClassicSword,
                Tags       = {"SwordType", "Weapon"},
                Attributes = {
                    Damage   = 25,
                    ItemType = "SwordType",
                    ItemName = "ClassicSword",
                }
            },
        },
    },
}