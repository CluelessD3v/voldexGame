return {
    SwordType = {
        ClassicSword = {
            Weight = 100,
            DisplayItem = {
                Name       = "ClassicSword",
                Instance   = workspace.DisplayItems.ClassicSwordDisplay,
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
                Instance   = workspace.ToolItems.ClassicSword,
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