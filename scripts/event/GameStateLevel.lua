local CurrentLevel = require "necro.game.level.CurrentLevel"
local Entities     = require "system.game.Entities"
local Event        = require "necro.event.Event"
local Object       = require "necro.game.object.Object"

Event.gameStateLevel.add("updateLabels", { order = "introText", sequence = 1 }, function(ev)
  if CurrentLevel.isSafe() then return end

  -- Delete existing labels
  for i, v in ipairs(Entities.getEntitiesByType("LabelFadingIntroductory")) do
    Object.delete(v)
  end

  -- Set new labels
  -- Todo replace this with once per sub-run
  if CurrentLevel.getNumber() == 1 then
    Object.spawn("LabelFadingIntroductory", 0, -1, {
      worldLabel = {
        offsetY = 3,
        text = "Spatial Distortions!"
      },
      worldLabelFade = {
        maxDistance = 10
      }
    })

    Object.spawn("LabelFadingIntroductory", 0, 0, {
      worldLabel = {
        alignY = 0,
        offsetY = 11,
        text = "Floors occur in a\nrandomized order!"
      },
      worldLabelFade = {
        maxDistance = 10
      }
    })
  elseif CurrentLevel.isLoopFinal() then
    Object.spawn("SpatialDistortions_FinalFloorLabel", 0, -1, {
      worldLabel = {
        offsetY = 3,
        text = "Final floor!"
      },
      worldLabelFade = {
        maxDistance = 10
      }
    })

    local bottomText = "Complete this floor\nto win this loop!"
    if CurrentLevel.isRunFinal() then
      bottomText = "Complete this floor\nto win the run!"
    end

    Object.spawn("SpatialDistortions_FinalFloorLabel", 0, 0, {
      worldLabel = {
        alignY = 0,
        offsetY = 11,
        text = bottomText
      },
      worldLabelFade = {
        maxDistance = 10
      }
    })
  end
end)
