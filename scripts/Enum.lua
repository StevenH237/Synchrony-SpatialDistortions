local Enum = require "system.utils.Enum"

local Text = require "SpatialDistortions.i18n.Text"

--#region------
-- FUNCTIONS --
---------------
local function entry(value, name, data)
  data = data or {}
  data.name = name
  return Enum.entry(value, data)
end

--#endregion Functions

--#region---
-- VALUES --
------------

local module = {}

module.Order = Enum.sequence {
  REVERSED = entry(-1, Text.Order.Reversed),
  RANDOM = entry(0, Text.Order.Random),
  NORMAL = entry(1, Text.Order.Normal),
  -- CUSTOM = entry(2, Text.Order.Custom)
}

module.Clustering = Enum.sequence {
  NONE = entry(0, Text.Clustering.None),
  ZONE = entry(1, Text.Clustering.Zone),
  LEVEL = entry(2, Text.Clustering.Level)
}

--#endregion Values

return module
