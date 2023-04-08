# `levelDeck`
The `levelDeck` list is a single ordered list that contains level objects, which have the following parameters:

* `boss`: Which boss is on the floor, if applicable
* `depth`: The depth of the floor, usually matches zone except for Aria or modded characters; controls bossfight strength.
* `floor`: The floor within a zone.
* `type`: The level generator used for the level.
* `zone`: The environment used for the level.


# `levelGrid`
The `levelGrid` is a list of lists of levels (depth first, then floor), with levels with the following parameters:

* `depth`: Same meaning as in `levelDeck`.
* `exists`: Always `true`.
* `floor`: Same meaning as in `levelDeck`.
* `original`: The original position in the sequence.
* `placed`: Whether or not the level has already been placed from the deck.
* `prereq`: A list of `{depth=1, floor=1}` objects of levels that have to be placed before this one.


# `levelSequenceUpdate`
The format of a `levelSequenceUpdate` event's `ev` parameter is as follows:

```lua
{
  characterBitmask = 1,
  characterPrototypes = { { --[[Cadence#0]] } },
  mode = {
    bossFlawlesses = true,
    cutscenes = true,
    diamondCounter = false,
    extraEnemiesPerFloor = 3,
    generatorOptions = {
      type = "Necro"
    },
    id = "AllZones",
    introText = true,
    multiCharEnabled = true,
    name = "All Zones",
    progressionUnlockCharacters = true,
    resetDiamonds = true,
    statisticsEnabled = true,
    statisticsTrackHardcoreClears = true,
    timerHUD = true,
    timerName = "Speedrun"
  },
  modeID = "AllZones",
  offset = 0,
  options = {
    initialCharacters = { "Cadence" },
    loopID = 1,
    modeID = "AllZones",
    seed = 1140480089,
    type = "Necro"
  },
  rng = {
    random = {
      state1 = 1226653138,
      state2 = 289581390,
      state3 = 989447177
    }
  },
  runState = {},
  sequence = { {
      depth = 1,
      floor = 1,
      type = "Necro",
      zone = 1
    }, {
      depth = 1,
      floor = 2,
      type = "Necro",
      zone = 1
    }, {
      depth = 1,
      floor = 3,
      type = "Necro",
      zone = 1
    }, {
      boss = 1,
      depth = 1,
      floor = 4,
      type = "Boss",
      zone = 1
    }, {
      depth = 2,
      floor = 1,
      type = "Necro",
      zone = 2
    }, {
      depth = 2,
      floor = 2,
      type = "Necro",
      zone = 2
    }, {
      depth = 2,
      floor = 3,
      type = "Necro",
      zone = 2
    }, {
      boss = 2,
      depth = 2,
      floor = 4,
      type = "Boss",
      zone = 2
    }, {
      depth = 3,
      floor = 1,
      type = "Necro",
      zone = 3
    }, {
      depth = 3,
      floor = 2,
      type = "Necro",
      zone = 3
    }, {
      depth = 3,
      floor = 3,
      type = "Necro",
      zone = 3
    }, {
      boss = 4,
      depth = 3,
      floor = 4,
      type = "Boss",
      zone = 3
    }, {
      depth = 4,
      floor = 1,
      type = "Necro",
      zone = 4
    }, {
      depth = 4,
      floor = 2,
      type = "Necro",
      zone = 4
    }, {
      depth = 4,
      floor = 3,
      type = "Necro",
      zone = 4
    }, {
      boss = 3,
      depth = 4,
      floor = 4,
      type = "Boss",
      zone = 4
    }, {
      depth = 5,
      floor = 1,
      type = "Necro",
      zone = 5
    }, {
      depth = 5,
      floor = 2,
      type = "Necro",
      zone = 5
    }, {
      depth = 5,
      floor = 3,
      type = "Necro",
      zone = 5
    }, {
      boss = 5,
      depth = 5,
      floor = 4,
      type = "Boss",
      zone = 5
    }, {
      boss = 6,
      depth = 5,
      floor = 5,
      type = "Boss",
      zone = 5
    } }
}
```