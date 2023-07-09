return {
  Clustering = {
    Level = L("Level", "clumping.level"),
    None = L("None", "clumping.none"),
    Zone = L("Zone", "clumping.zone")
  },
  HUD = {
    FloorNumber = function(...) return L.formatKey("%s  (%d/%d)", "hud.floorNumber", ...) end,
    FloorNumberCustom = function(...) return L.formatKey("Floor %d of %d", "hud.floorNumberCustom", ...) end
  },
  InGame = {
    First = {
      Above = L("Spatial distortions!", "inGame.first.above"),
      Below = L("Floors occur in a\nrandomized order!", "inGame.first.below")
    },
    Last = {
      Above = L("Final floor!", "inGame.last.above"),
      BelowLoop = L("Complete this floor\nto win this loop!", "inGame.last.belowLoop"),
      BelowRun = L("Complete this floor\nto win the run!", "inGame.last.belowRun")
    }
  },
  Order = {
    Custom = L("Custom", "order.custom"),
    Normal = L("Forward", "order.normal"),
    Random = L("Random", "order.random"),
    Reversed = L("Reversed", "order.reversed")
  },
}
