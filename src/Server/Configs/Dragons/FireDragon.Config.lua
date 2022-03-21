local anims = workspace.DragonAnimations

return {
    ValidTargetTags = {
        "DragonTarget"
    },

    Name = "FrostDragon",
    BaseFireDamage        = 1.5,   --> keep this number low
    BaseMeleeDamge        = 6,
    BaseAttackPrepareTime = 1.8,
    BaseSpawnLocation     = nil, --> set this at run time
    BaseMaxhealth         = 220,
    DetectionAgro         = 75,
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