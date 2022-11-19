local GameDLC = require "necro.game.data.resource.GameDLC"

local PowerSettings = require "PowerSettings.PowerSettings"

local SDEnum = require "SpatialDistortions.Enum"

--------------
-- ENABLERS --
--#region-----

local function both(a, b)
  return function()
    return a() and b()
  end
end

local function either(a, b)
  return function()
    return a() or b()
  end
end

local function anti(a)
  return function()
    return not a()
  end
end

local function isAdvanced(exp)
  if exp == nil then exp = true end

  return function()
    return PowerSettings.get("config.showAdvanced") == exp
  end
end

local function isAmplified(exp)
  if exp == nil then exp = true end

  return function()
    return GameDLC.isAmplifiedLoaded() == exp
  end
end

local function isSynchrony(exp)
  if exp == nil then exp = true end

  return function()
    return GameDLC.isSynchronyLoaded()
  end
end

--#endregion Enablers
--#region-----
-- SETTINGS --
--------------

PowerSettings.autoRegister();

PowerSettings.shared.enum {
  name = "Floor order",
  desc = "What order should the floors of a single zone be in?",
  id = "floor",
  order = 1,
  enum = SDEnum.Order,
  default = SDEnum.Order.RANDOM
}

PowerSettings.shared.enum {
  name = "Zone order",
  desc = "What order should the zones of each level be in?",
  id = "zone",
  order = 2,
  enum = SDEnum.Order,
  default = SDEnum.Order.RANDOM,
  visibleIf = isAdvanced
}

PowerSettings.shared.enum {
  name = "Clustering",
  desc = "Should all floors of a zone (or all zones of a floor) be together?",
  id = "clustering",
  order = 3,
  enum = SDEnum.Clustering
}

PowerSettings.shared.bool {
  name = "Preserve boss alignment",
  desc = "Should bosses be kept in the same positions in a shuffle?",
  id = "alignment",
  order = 4,
  default = false
}

PowerSettings.shared.bool {
  name = "Force single final boss",
  desc = "If enabled, there can only be one final boss. This may be enabled automatically by other settings.",
  id = "singleBoss",
  order = 5,
  default = false
}

--#endregion Ordering settings
--#endregion Settings

return { get = function(node)
  return PowerSettings.get("mod.SpatialDistortions." .. node)
end }
