local FILES = {
  "maps/SECRET_BASE.lua",
}

return function(mod)
  -- Define available furniture items
  -- -----------------------------------
  local FURNITURE = {
    {
      id = "BOULDER", label = "BOULDER", index = 2, x = 19, y = 4,
      sprite = "SPRITE_BOULDER", movement = "STAY", range = "DOWN",
    },
  }

  -- Define secret base map
  -- ---------------------
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

  local FURNITURE_BY_ID = {}
  for _, item in ipairs(FURNITURE) do FURNITURE_BY_ID[item.id] = item end

  local function flagFor(item) return "MOD_SECRET_BASE_HAS_" .. item.id end
  local function xFlagFor(item) return "MOD_SECRET_BASE_X_" .. item.id end
  local function yFlagFor(item) return "MOD_SECRET_BASE_Y_" .. item.id end

  local function positionFor(item)
    local x = mod.world:getFlag(xFlagFor(item))
    local y = mod.world:getFlag(yFlagFor(item))
    if x == nil or y == nil then return item.x, item.y end
    return x, y
  end

  local function objectFor(item)
    local x, y = positionFor(item)
    return {
      index = item.index, x = x, y = y, sprite = item.sprite,
      movement = item.movement, range = item.range, text = item.label,
    }
  end

  -- Track active furniture item IDs
  -- ------------------------------
  local activeNpc = {}

  local function spawnFurniture(item)
    activeNpc[item.id] = mod.world:spawnNpc("SECRET_BASE", objectFor(item))
  end

  local function despawnFurniture(item)
    local npcId = activeNpc[item.id]
    if npcId then mod.world:removeNpc(npcId) end
    mod.world:setFlag(xFlagFor(item), nil)
    mod.world:setFlag(yFlagFor(item), nil)
    activeNpc[item.id] = nil
  end

  local function relocateFurniture(item, x, y)
    local wasActive = activeNpc[item.id] ~= nil
    if wasActive then despawnFurniture(item) end
    mod.world:setFlag(xFlagFor(item), x)
    mod.world:setFlag(yFlagFor(item), y)
    if wasActive then spawnFurniture(item) end
  end

  -- Relocation coordinates have too many options.
  -- This defines a list similar to the shop or bag UI.
  -- ----------------------------
  local function pickFromList(ctx, title, labels)
    local items = {}
    for _, label in ipairs(labels) do
      items[#items + 1] = { label = label }
    end
    local runner = ctx.runner
    local picked
    local menu = mod.ui.ListMenu.new(ctx.game, title, items, {
      wrap = true,
      onChoose = function(item, self)
        picked = item.label
        self:close()
        runner:resume()
      end,
      onCancel = function() runner:resume() end,
    })
    ctx.game.stack:push(menu)
    runner:yield()
    return picked -- nil on cancel
  end

  local inactiveFurnitureLabels = {}
  local activeFurnitureLabels = {}

  local MOVE_X_LABELS = {}
  for x = 2, 19 do MOVE_X_LABELS[#MOVE_X_LABELS + 1] = tostring(x) end

  local MOVE_Y_LABELS = {}
  for y = 2, 19 do MOVE_Y_LABELS[#MOVE_Y_LABELS + 1] = tostring(y) end

  mod.content.map_scripts:register("SECRET_BASE", {
    talk = {
      ["CATALOGUE"] = {
	{"show_text", "MYSTIC FURNITURE\nCATALOGUE:"},
	{"choice", {"Add Furniture", "Move Furniture", "Remove Furniture", "Cancel"}},
	{"secretBase:catalogueChoice"},
	{"jump", "end"},

	{"label", "add"},
	{"secretBase:refreshInactiveChoices"},
	{"choice", inactiveFurnitureLabels},
	{"secretBase:addFurniture"},
	{"jump", "end"},

	{"label", "move"},
	{"secretBase:refreshActiveChoices"},
	{"choice", activeFurnitureLabels},
	{"secretBase:pickMoveItem"},
	{"secretBase:pickMoveX"},
	{"secretBase:pickMoveY"},
	{"secretBase:moveFurniture"},
	{"jump", "end"},

	{"label", "remove"},
	{"secretBase:refreshActiveChoices"},
	{"choice", activeFurnitureLabels},
	{"secretBase:removeFurniture"},
      },
      ["BOULDER"] = {
	{"show_text", "It's not a boulder.\vIt's a rock!"},
      },
    },

    onEnter = function(game, ow)
      for _, item in ipairs(FURNITURE) do
        if mod.world:getFlag(flagFor(item)) and not activeNpc[item.id] then
          spawnFurniture(item)
        end
      end
    end,
  })

  mod.content.commands:register("secretBase:refreshActiveChoices", {
    fn = function(ctx)
      for i = #activeFurnitureLabels, 1, -1 do
        activeFurnitureLabels[i] = nil
      end
      for _, item in ipairs(FURNITURE) do
        if mod.world:getFlag(flagFor(item)) then
          activeFurnitureLabels[#activeFurnitureLabels + 1] = item.label
        end
      end
      activeFurnitureLabels[#activeFurnitureLabels + 1] = "CANCEL"
    end,
  })

  mod.content.commands:register("secretBase:refreshInactiveChoices", {
    fn = function(ctx)
      for i = #inactiveFurnitureLabels, 1, -1 do
        inactiveFurnitureLabels[i] = nil
      end
      for _, item in ipairs(FURNITURE) do
        if not mod.world:getFlag(flagFor(item)) then
          inactiveFurnitureLabels[#inactiveFurnitureLabels + 1] = item.label
        end
      end
      inactiveFurnitureLabels[#inactiveFurnitureLabels + 1] = "CANCEL"
    end,
  })

  mod.content.commands:register("secretBase:catalogueChoice", {
    foreground = true,
    fn = function(ctx)
      local choice = ctx.lastChoice and ctx.lastChoice.label
      if choice == "Add Furniture" then return "add" end
      if choice == "Move Furniture" then return "move" end
      if choice == "Remove Furniture" then return "remove" end
      return "end" -- Cancel (or menu cancel)
    end,
  })

  mod.content.commands:register("secretBase:addFurniture", {
    foreground = true,
    fn = function(ctx)
      local item = FURNITURE_BY_ID[ctx.lastChoice and ctx.lastChoice.label]
      if not item then return end -- CANCEL
      if not mod.world:getFlag(flagFor(item)) then
        mod.world:setFlag(flagFor(item), true)
        spawnFurniture(item)
      end
    end,
  })

  mod.content.commands:register("secretBase:pickMoveItem", {
    fn = function(ctx)
      local item = FURNITURE_BY_ID[ctx.lastChoice and ctx.lastChoice.label]
      if not item then return "end" end -- CANCEL
      ctx.moveItem = item
    end,
  })

  mod.content.commands:register("secretBase:pickMoveX", {
    foreground = true,
    fn = function(ctx)
      local x = tonumber(pickFromList(ctx, "CHOOSE X POSITION", MOVE_X_LABELS))
      if not x then return "end" end -- CANCEL
      ctx.moveX = x
    end,
  })

  mod.content.commands:register("secretBase:pickMoveY", {
    foreground = true,
    fn = function(ctx)
      local y = tonumber(pickFromList(ctx, "CHOOSE Y POSITION", MOVE_Y_LABELS))
      if not y then return "end" end -- CANCEL
      ctx.moveY = y
    end,
  })

  mod.content.commands:register("secretBase:moveFurniture", {
    foreground = true,
    fn = function(ctx)
      if not ctx.moveItem or not ctx.moveX or not ctx.moveY then return end
      relocateFurniture(ctx.moveItem, ctx.moveX, ctx.moveY)
    end,
  })

  mod.content.commands:register("secretBase:removeFurniture", {
    fn = function(ctx)
      local item = FURNITURE_BY_ID[ctx.lastChoice and ctx.lastChoice.label]
      if not item then return end -- CANCEL
      if mod.world:getFlag(flagFor(item)) then
        mod.world:setFlag(flagFor(item), false)
        despawnFurniture(item)
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
