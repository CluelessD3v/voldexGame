local anims = workspace.DragonAnimations

return {
    ValidTargetTags = {
        "DragonTarget"
    },

    Name = "FireDragon",
    BaseFireDamage        = 1.5,   --> keep this number low, the fire hitbox is not debounced!
    BaseMeleeDamge        = 5,
    BaseAttackPrepareTime = 1.8,
    BaseSpawnLocation     = nil, --> set this at run time if needed to set a custom spawn location
    BaseMaxhealth         = 200,
    DetectionAgro         = 80,
    AttackAgro            = 30,
    BaseGoldCoinsDropped  = 5,
    MaxGoldCoinsDropped   = 15,

    Instance = workspace.FireDragon,
    
    Animations = {
        Death = anims.Death,
        Walk = anims.Walk,
        Idle = anims.Idle,
        FireBreath = anims.FireBreath,
        WingBeat = anims.WingBeat,
    } 


}