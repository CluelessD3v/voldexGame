local anims = workspace.DragonAnimations

return {
    ValidTargetTags = {
        "DragonTarget"
    },

    Name = "FrostDragon",
    BaseFireDamage        = .3,  --> keep this number low, the fire hitbox is not debounced!
    BaseMeleeDamge        = 10, 
    BaseAttackPrepareTime = 1.5,
    BaseSpawnLocation     = nil, --> set this at run time if needed to set a custom spawn location
    BaseMaxhealth         = 250,
    DetectionAgro         = 70,
    AttackAgro            = 25,
    BaseGoldCoinsDropped  = 5,
    MaxGoldCoinsDropped   = 20,


    Instance = workspace.FrostDragon,
    
    Animations = {
        Death = anims.Death,
        Walk = anims.Walk,
        Idle = anims.Idle,
        FireBreath = anims.FireBreath,
        WingBeat = anims.WingBeat,
    } 


}