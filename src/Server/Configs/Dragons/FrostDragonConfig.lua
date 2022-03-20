local anims = workspace.DragonAnimations

return {
    ValidTargetTags = {
        "DragonTarget"
    },

    BaseFireDamage        = 1,   --> keep this number low
    BaseMeleeDamge        = 10,
    BaseAttackPrepareTime = 1.5,
    BaseSpawnLocation = nil,  --> set this at run time
    BaseMaxhealth = 200,
    DetectionAgro = 60,
    AttackAgro = 25,
    
    Animations = {
        Death = anims.Death,
        Walk = anims.Walk,
        Idle = anims.Idle,
        FireBreath = anims.FireBreath,
        WingBeat = anims.WingBeat,
    } 


}