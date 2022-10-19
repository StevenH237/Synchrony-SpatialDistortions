local CurrentLevel  = require "necro.game.level.CurrentLevel"
local Event         = require "necro.event.Event"
local GameSession   = require "necro.client.GameSession"
local HUD           = require "necro.render.hud.HUD"
local HUDLayout     = require "necro.render.hud.HUDLayout"
local LevelSequence = require "necro.game.level.LevelSequence"
local Localization  = require "system.i18n.Localization"
local UI            = require "necro.render.UI"

local Text = require "SpatialDistortions.i18n.Text"

Event.renderGlobalHUD.override("renderLevelCounter", 1, function(func, ev)
  local mode = GameSession.getCurrentModeID()

  local floor, total = CurrentLevel.getSequentialNumber(), LevelSequence.getLength()
  local text

  if mode == "AllZones" or mode == "AllZonesSeeded" or mode == "SingleZone" then
    local depth, level, boss = CurrentLevel.getDepth(), CurrentLevel.getFloor(), CurrentLevel.isBoss()

    text = Text.HUD.FloorNumber(Localization.format("render.levelCounterHUD.depthLevel",
      "Depth: %s  Level: %s",
      depth,
      boss and Localization.get("render.levelCounterHUD.boss") or level),
      floor,
      total)
  end

  if mode == "CustomDungeon" then
    text = Text.HUD.FloorNumberCustom(floor, total)
  end

  HUD.drawText {
    text = text,
    font = UI.Font.SMALL,
    element = HUDLayout.Element.LEVEL,
    alignX = 1,
    alignY = 1
  }
end)
