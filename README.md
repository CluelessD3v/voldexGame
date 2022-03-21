# voldexGame

## DefaultProjectjson note
Project Json file was modified from the default configuration to one that uses absolute paths instead. This is simply for personal comfort reasons as it mimics a roblox studio file structure.


## Dependencies
This project has a single dependency:
Trove = "sleitnick/trove@0.3.0"	Trove class for tracking and cleaning up objects

Installing packages in ROBLOX requires [wally to be installed](https://wally.run/install) package manager,
Please visit the link provided and install it. Once that is done just run the command `wally install` to install the package


## Notes of caution
Each sound, animation and effect found is to be considered hard coded DO NOT move it or the structure of the code will break

<br>
## Controls
- WASD: Movement
- LeftShift: Sprinting
- 1-9: Equiping weapons in inventory
- Left Mouse Button: Attacking (when a weapon is equipped)\

<br>

## Enemies
There are two enemies in this test game, the Fire Dragon and the Frost Dragon. both posess the same abilities, but their stats differ and scale a bit different due to that.

### Abilities:
- Wing Beating: A melee attack where the dragon attacks his target by beating his wings against him
- Fire Breathing: A long range attack were the dragn will literally exhale fire, causes continous damage as long as the target stays close to it. 

### Arquetypes
- Frost Dragon : A tanquier enemy that hits harder and has a higher base health, Nonetheless, its fire damage is extremely weak!
<br>

- Fire Dragon: A weaker, more flimsy enemy with lower base health that hits softer... Nonetheless it compensates it with having devastating Fire Breathing damage!

## Dificulty scalling
The game dificulty is measured by how many levels the player has cleared. this is done through stats scalling, a property of the `DragonEntity` Class

the scalling formulas are the following

- MeleeDamage     --> Formula: BaseMeleeDamage * StatsScaling 
- FireDamage      --> Formula:  BaseFireDamage * StatsScaling
- AttackPrepareTime --> Formula:  math.sqrt(BaseAttackPrepareTime/StatsScaling) + 1
- MaxHealth --> Formula: BaseHealth * StatsScaling

visually, one can identify the dificulty of the dragon by its level on the HUD.

## Items
- Classic Sword: The default sword a player comes equipped with, does not do a whole lot of damage, and should be replaced as soon as possible
- Uber Classic Sword: An advanced version of the classic sword, it hits harder, but still, not really good or useful in the higher levels
- Sword Of Darkness: Extremely powerful sword that deals a lot of damage
- Sword Of Starlight: The most devastating sword in the game, it will one hit dragons even in the higher levels.

