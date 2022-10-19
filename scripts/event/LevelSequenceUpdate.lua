local Event       = require "necro.event.Event"
local GameSession = require "necro.client.GameSession"
local RNG         = require "necro.game.system.RNG"
local Utilities   = require "system.utils.Utilities"

local SDEnum     = require "SpatialDistortions.Enum"
local SDSettings = require "SpatialDistortions.Settings"

local function createLevelGrid(levelDeck)
  local levels = {}

  -- This creates an array of which depth-level orders exist
  for i, v in ipairs(levelDeck) do
    local d, f = v.depth, v.floor
    if not levels[d] then levels[d] = {} end
    levels[d][f] = {
      depth = d,
      floor = f,
      exists = true,
      prereq = {},
      original = i,
      placed = false,
      count = math.huge
    }
  end

  return levels
end

local function getFloorOrdering(levels)
  local order = SDSettings.get("ordering.floor")

  if order == SDEnum.Order.RANDOM then return end

  local isReverse = (order == SDEnum.Order.REVERSED)

  if true then -- if order ~= SDEnum.Order.CUSTOM then
    for d, v in ipairs(levels) do
      for f = 1, #v - 1 do
        if isReverse then
          table.insert(v[f].prereq, { depth = d, floor = f + 1 })
        else
          table.insert(v[f + 1].prereq, { depth = d, floor = f })
        end
      end
    end
  end

  -- TODO code for custom orders
end

local function getZoneOrdering(levels)
  local order = SDSettings.get("ordering.zone")

  if order == SDEnum.Order.RANDOM then return end

  local isReverse = (order == SDEnum.Order.REVERSED)

  if true then -- if order ~= SDEnum.Order.CUSTOM then
    for d = 1, #levels - 1 do
      local z = levels[d]
      local zn = levels[d + 1]

      for f = 1, math.min(#z, #zn) do
        if isReverse then
          table.insert(z[f].prereq, { depth = d + 1, floor = f })
        else
          table.insert(zn[f].prereq, { depth = d, floor = f })
        end
      end
    end

    -- This little bit makes 5-5 (or 4-5 in non-AMP) always succeed 5-4
    if not isReverse then
      local lastZone = levels[#levels]
      local lastFloor = lastZone[#lastZone]

      if lastFloor.floor >= 5 and #(lastFloor.prereq) == 0 then
        lastFloor.prereq = { { depth = lastFloor.depth, floor = lastFloor.floor - 1 } }
      end
    else
      local lastZone = levels[#levels]
      local penultimateFloor = lastZone[#lastZone - 1]

      if penultimateFloor.floor >= 4 and #(penultimateFloor.prereq) == 0 then
        penultimateFloor.prereq = { { depth = penultimateFloor.depth, floor = penultimateFloor.floor + 1 } }
      end
    end
  end

  -- TODO code for custom orders
end

local function shuffleLevels(levelDeck, levels, randomState)
  -- Create a shuffled deck to draw from
  RNG.shuffle(levelDeck, randomState)

  local levelSequence = {}

  while #levelDeck > 0 do
    local draw = table.remove(levelDeck, 1)

    local canBePlaced = true

    local info = levels[draw.depth][draw.floor]

    if #levelDeck == info.count then
      -- we've done a whole loop without placing anything
      -- so just place this one and move on
      goto justPlace
    end

    info.count = #levelDeck

    -- Check that all prerequisite levels have been placed first
    for i, v in ipairs(info.prereq) do
      if not levels[v.depth][v.floor].placed then
        canBePlaced = false
        break
      end
    end

    ::justPlace::
    -- If placeable, place
    if canBePlaced then
      levelSequence[#levelSequence + 1] = draw
      info.placed = true
    else
      levelDeck[#levelDeck + 1] = draw
    end

    ::continueLevelDeck::
  end

  return levelSequence
end

Event.levelSequenceUpdate.add("randomize", { order = "shuffle", sequence = 0 }, function(ev)
  local mode = GameSession.getCurrentModeID()
  if not (mode == "AllZones" or mode == "AllZonesSeeded" or mode == "SingleZone" or mode == "CustomDungeon") then return end

  local randomState = Utilities.fastCopy(ev.rng)
  local levelDeck = Utilities.fastCopy(ev.sequence)

  -- I'm gonna spur these off into subroutines just for organization
  local levels = createLevelGrid(levelDeck)

  getFloorOrdering(levels)
  getZoneOrdering(levels)

  ev.sequence = shuffleLevels(levelDeck, levels, randomState)
end)
