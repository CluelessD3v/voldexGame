return {
    SwordType = {
        ClassicSword = {
            DisplayItem = {
                Name       = "ClassicSword",
                Instance   = workspace.ClassicSword,
                Attributes = {
                    Damage = 25
                },
                ObjectValue = {
                    Owner = Instance.new("ObjectValue")
                }
            },

            ToolItem = {
                Name       = "ClassicSword",
                Instance   = workspace.Swords.ClassicSword,
                Attributes = {
                    Damage = 25
                }
            },

            Name                 = "ClassicSword",
            LootableInstance     = workspace.ClassicSword,
            ToolInstance         = workspace.Swords.ClassicSword,
            LootableInstanceTags = {},
            ToolInstanceTags     = {},
            
            Attributes = {
                Damage = 25
            },
        },


    },

}