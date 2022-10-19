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

PowerSettings.group {
  name = "Ordering settings",
  desc = "Settings that control how SpatialDistortions orders floors",
  id = "ordering",
  order = 1
}

--#region Ordering settings

PowerSettings.shared.enum {
  name = "Floor order",
  desc = "What order should the floors of a single zone be in?",
  id = "ordering.floor",
  order = 1,
  enum = SDEnum.Order,
  default = SDEnum.Order.RANDOM
}

PowerSettings.shared.enum {
  name = "Zone order",
  desc = "What order should the zones of each level be in?",
  id = "ordering.zone",
  order = 2,
  enum = SDEnum.Order,
  default = SDEnum.Order.RANDOM,
  visibleIf = isAdvanced
}

PowerSettings.shared.enum {
  name = "Clustering",
  desc = "Should all floors of a zone (or all zones of a floor) be together?",
  id = "ordering.clustering",
  order = 3,
  enum = SDEnum.Clustering
}

--#endregion Ordering settings
--#endregion Settings

return { get = function(node)
  return PowerSettings.get("mod.SpatialDistortions." .. node)
end }
