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
  Order = {
    Custom = L("Custom", "order.custom"),
    Normal = L("Forward", "order.normal"),
    Random = L("Random", "order.random"),
    Reversed = L("Reversed", "order.reversed")
  },
}
