local Event       = require "necro.event.Event"
local GameSession = require "necro.client.GameSession"
local RNG         = require "necro.game.system.RNG"
local Utilities   = require "system.utils.Utilities"

local SDEnum     = require "SpatialDistortions.Enum"
local SDSettings = require "SpatialDistortions.Settings"

local function shouldSelectOneFinalBoss()
  if SDSettings.get("singleBoss") then return true end
  if SDSettings.get("zone") ~= SDEnum.Order.RANDOM then return true end
  if SDSettings.get("clustering") == SDEnum.Clustering.LEVEL then return true end
  if SDSettings.get("clustering") == SDEnum.Clustering.ZONE and SDSettings.get("alignment") then return true end

  return false
end

local function selectOneFinalBoss(levelDeck, channel)
  -- This assumes (and breaks if wrong):
  -- • There are at least two depths.
  -- • All depths except the final are consistent in length.
  -- • The final depth is longer than the rest.
  -- • Floors in each depth are consecutive from 1 to n.

  -- Get the length and last floor of the dungeon
  local length = #levelDeck
  local last = levelDeck[#levelDeck]

  -- Get the length of the final zone
  local floorsInFinal = last.floor

  -- Get the length of the semifinal zone
  local semifinal = levelDeck[#levelDeck - floorsInFinal]
  local floorsInSemifinal = semifinal.floor

  -- Determine the last guaranteed level
  local lastGuaranteed = length - (floorsInFinal - floorsInSemifinal + 1)
  local lengthInQuestion = length - lastGuaranteed

  -- Pick one of the levels in question
  local whichLevel = RNG.int(lengthInQuestion, channel) + 1

  -- Now make that the chosen level
  levelDeck[lastGuaranteed + 1] = levelDeck[lastGuaranteed + whichLevel]
  lastGuaranteed = lastGuaranteed + 1

  -- Remove the other levels
  while #levelDeck > lastGuaranteed do
    table.remove(levelDeck)
  end

  -- And while we're at it we should update the number
  levelDeck[lastGuaranteed].floor = floorsInSemifinal
end

local function getBossAlignment(levelDeck)
  if not SDSettings.get("alignment") then return {} end

  local out = {}

  for i, v in ipairs(levelDeck) do
    out[i] = v.boss ~= nil
  end

  return out
end

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
      placed = false
    }
  end

  return levels
end

local function getFloorOrdering(levels)
  local order = SDSettings.get("floor")

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
  local order = SDSettings.get("zone")

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
  end

  -- TODO code for custom orders
end

local function canBePlaced(levels, draw, alignToBoss)
  local info = levels[draw.depth][draw.floor]

  if alignToBoss ~= nil then
    if alignToBoss ~= (draw.boss ~= nil) then
      return false
    end
  end

  for i, v in ipairs(info.prereq) do
    -- print("Prerequisite: " .. v.depth .. "-" .. v.floor)
    if not levels[v.depth][v.floor].placed then
      -- print("Not satisfied.")
      return false
    else
      -- print("Satisfied.")
    end
  end

  return true
end

-- returns main deck with sub-deck levels removed
-- followed by sub-deck
local function splitDecks(inputDeck, draw)
  local levelDeck = Utilities.fastCopy(inputDeck)

  local clusterSetting = SDSettings.get("clustering")

  if clusterSetting == SDEnum.Clustering.NONE then return levelDeck, {} end

  -- print("Creating a sub-deck...")

  local clusterKey
  if clusterSetting == SDEnum.Clustering.ZONE then
    clusterKey = "depth"
  elseif clusterSetting == SDEnum.Clustering.LEVEL then
    clusterKey = "floor"
  end

  local clusterValue = draw[clusterKey]

  local i = 1
  local subDeck = {}
  local mainDeck = {}

  while #levelDeck > 0 do
    local card = table.remove(levelDeck, 1)

    if card[clusterKey] == clusterValue then
      table.insert(subDeck, card)
      -- print("Added " .. card.depth .. "-" .. card.floor .. " to sub-deck.")
    else
      table.insert(mainDeck, card)
      -- print("Skipped " ..
      --   card.depth .. "-" .. card.floor .. " because " .. clusterKey .. " was not " .. clusterValue .. ".")
    end
  end

  return mainDeck, subDeck
end

local function shuffleLevels(inputDeck, levels, randomState, alignment)
  local levelDeck = Utilities.fastCopy(inputDeck)

  local levelSequence = {}

  local subDeck = {}

  while #levelDeck > 0 or #subDeck > 0 do
    -- Pick a deck
    -- (it's always the sub-deck if that's not empty)
    local activeDeck = levelDeck
    if #subDeck > 0 then activeDeck = subDeck end

    -- Shuffle that deck
    RNG.shuffle(activeDeck, randomState)

    -- Check the cards in order
    local draw
    local index

    -- This will check alignments
    local alignedIndex
    local alignedDraw
    local alignToBoss = table.remove(alignment, 1)

    -- We'll place either the first one that can be placed,
    -- or the last if all of them fail the checks.
    for i = 1, #activeDeck do
      index = i
      draw = activeDeck[i]

      if alignToBoss == (draw.boss ~= nil) then
        alignedIndex = i
        alignedDraw = draw
      end

      -- print("Attempting to place " .. draw.depth .. "-" .. draw.floor)
      if canBePlaced(levels, draw, alignToBoss) then
        break
      end

      if i == #activeDeck then
        -- print("All levels unplaceable. Initiating fallback (last drawn level).")
        if alignedDraw then
          index = alignedIndex
          draw = alignedDraw
        end
      end
    end

    levelSequence[#levelSequence + 1] = draw

    levels[draw.depth][draw.floor].placed = true

    -- print("Placed level " .. draw.depth .. "-" .. draw.floor)

    if #subDeck == 0 then
      table.remove(activeDeck, index)
      levelDeck, subDeck = splitDecks(levelDeck, draw)
    else
      table.remove(activeDeck, index)
    end
  end

  return levelSequence
end

Event.levelSequenceUpdate.add("randomize", { order = "shuffle", sequence = 0 }, function(ev)
  -- print("Begin level shuffling")

  local mode = GameSession.getCurrentModeID()
  if not (mode == "AllZones" or mode == "AllZonesSeeded" or mode == "SingleZone" or mode == "CustomDungeon") then return end

  local randomState = Utilities.fastCopy(ev.rng)
  local levelDeck = Utilities.fastCopy(ev.sequence)

  -- I'm gonna spur these off into subroutines just for organization

  -- Should we rectangularize?
  if shouldSelectOneFinalBoss() then
    selectOneFinalBoss(levelDeck, randomState)
  end

  local bossAlignment = getBossAlignment(levelDeck)

  local levels = createLevelGrid(levelDeck)

  getFloorOrdering(levels)
  getZoneOrdering(levels)

  ev.sequence = shuffleLevels(levelDeck, levels, randomState, bossAlignment)

  -- print("Printing new level sequence...")
  -- for i, v in ipairs(ev.sequence) do
  --   print(v.depth .. "-" .. v.floor)
  -- end
end)
