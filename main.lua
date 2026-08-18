-- secret_base: map changes authored in Tiled and exported by
-- gen1-mod-export.  Each file below returns function(mod) and is
-- applied in order, so tilesets land before the maps that use them.
--
-- mod:read + load is how a mod loads its own extra files (the same
-- shape mods/examples/example_jukebox uses for song.lua).
local FILES = {
  "maps/SECRET_BASE.lua",
}

return function(mod)
  for _, relative in ipairs(FILES) do
    local source = mod:read(relative)
    if not source then
      mod.log:error("%s missing from %s -- reinstall the mod",
        relative, mod.path)
    else
      local chunk, compileErr = load(source,
        "@" .. mod.path .. "/" .. relative)
      if not chunk then
        mod.log:error("%s did not compile: %s", relative,
          tostring(compileErr))
      else
        local ok, apply = pcall(chunk)
        if not ok or type(apply) ~= "function" then
          mod.log:error("%s must return function(mod): %s",
            relative, tostring(apply))
        else
          apply(mod)
        end
      end
    end
  end

  mod.content.map_songs:override("SECRET_BASE", "Music_OaksLab")

  local FURNITURE = {
    {
      id = "BOULDER", label = "BOULDER", index = 2, x = 19, y = 4,
      sprite = "SPRITE_BOULDER", movement = "STAY", range = "DOWN",
    },
  }

  local FURNITURE_BY_ID = {}
  for _, item in ipairs(FURNITURE) do FURNITURE_BY_ID[item.id] = item end

  local function flagFor(item) return "MOD_SECRET_BASE_HAS_" .. item.id end

  local function objectFor(item)
    return {
      index = item.index, x = item.x, y = item.y, sprite = item.sprite,
      movement = item.movement, range = item.range, text = item.label,
    }
  end

  local choiceLabels = {}
  for _, item in ipairs(FURNITURE) do
    choiceLabels[#choiceLabels + 1] = item.label
  end
  choiceLabels[#choiceLabels + 1] = "CANCEL"

  mod.content.map_scripts:register("SECRET_BASE", {
    talk = {
      ["CATALOGUE"] = {
	{"show_text", "Place furnishings?"},
        {"choice", choiceLabels},
	{"secretBase:furnish"},
      },
      ["BOULDER"] = {
	{"show_text", "It's not a boulder.\vIt's a rock!"},
      },
    },

    onEnter = function(game, ow)
      for _, item in ipairs(FURNITURE) do
        if mod.world:getFlag(flagFor(item)) then
          mod.world:spawnNpc("SECRET_BASE", objectFor(item))
        end
      end
    end,
  })

  mod.content.commands:register("secretBase:furnish", {
    foreground = true,
    fn = function(ctx)
      local item = FURNITURE_BY_ID[ctx.lastChoice and ctx.lastChoice.label]
      if not item then return end -- CANCEL
      if not mod.world:getFlag(flagFor(item)) then
        mod.world:setFlag(flagFor(item), true)
        mod.world:spawnNpc("SECRET_BASE", objectFor(item))
      end
    end,
  })

  -- Shovel Item Code
  -- -----------------
  mod.content.items:register("MYS_SHOVEL", {
    id = "MYS_SHOVEL", name = "MYSTIC SHOVEL", price = 0,
    tossable = false, effect = "MYS_SHOVEL_EFFECT",
  })


  mod.hooks:wrap("item.use", function(next, game, battle, id, target, list,
      moveIndex, picker)
    if id ~= "MYS_SHOVEL" or battle then
      return next(game, battle, id, target, list, moveIndex, picker)
    end
    local ow = game.overworld
    local atBase = ow and ow.map and ow.map.id == "SECRET_BASE"
    local question = atBase and "Leave your\nSecret Base?"
      or "Go to your\nSecret Base?"
    game.stack:push(mod.ui.TextBox.new(game, question, nil, {
      choice = function(yes)
        if not yes then return end
        list:close()
        next(game, battle, id, target, list, moveIndex, picker)
      end,
    }))
  end)

  mod.content.item_effects:register("MYS_SHOVEL_EFFECT", {
    field = true, battle = false,
    use = function(ctx)
      local ow = ctx.overworld
      if not ow or not ow.map then
        return "failed", {"It won't have\nany effect."}
      end

      if ow.map.id == "SECRET_BASE" then
        local lastPC = ctx.save.lastHeal
        if not lastPC then
          mod.world:warpTo("REDS_HOUSE_2F", 3, 6, "down",
            {arrive = "teleport"})
        else
          mod.world:warpTo(lastPC.map, lastPC.x, lastPC.y, "down",
            {arrive = "teleport"})
        end
      else
        mod.world:warpTo("SECRET_BASE", 10, 10, "down",
          {arrive = "teleport"})
      end

      return "kept", {string.format("%s used the\n%s!",
        ctx.save.player.name, ctx.item.name)}
    end,
  })
end
