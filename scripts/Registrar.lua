local Components     = require "necro.game.data.Components"
local CustomEntities = require "necro.game.data.CustomEntities"

local SDEnum = require "SpatialDistortions.Enum"

CustomEntities.register {
  name = "SpatialDistortions_FinalFloorLabel",
  despawnOnBossFightStart = {
    active = true
  },
  gameObject = {
    active = true,
    despawned = false,
    persist = false,
    tangible = true
  },
  position = {
    x = 0,
    y = 0
  },
  worldLabel = {
    alignY = 1,
    offsetX = 0,
    offsetY = -15,
    offsetZ = -48,
    spacingY = 0,
    text = ""
  },
  worldLabelFade = {
    factor = 1,
    falloff = 0.1,
    maxDistance = 5
  },
  worldLabelMaxWidth = {
    width = 120
  },
  worldLabelVisibleBySetting = {
    option = SDEnum.Ext.VisibilityOption.FINAL_FLOOR
  }
}