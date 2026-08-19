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
      cost = 100
    },
  }

  local restoreActiveFurniture
  local inactiveFurnitureLabels, activeFurnitureLabels = {}, {}

  -- Secret base catalogue script
  -- ----------------------------
  mod.content.map_scripts:register("SECRET_BASE", {
    talk = {
      ["CATALOGUE"] = {
	{"show_text", "MYSTIC FURNITURE\nCATALOGUE:"},
	{"choice", {"Add Furniture", "Move Furniture", "Remove Furniture", "Buy Furniture", "Cancel"}},
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
	{"jump", "end"},

	{"label", "purchase"},
	{"secretBase:refreshUnsoldChoices"},
	{"secretBase:shopFurnitureList"},
	{"secretBase:purchaseFurniture"},
	{"jump", "purchase"},

	{"label", "cant_afford"},
	{"show_text", "You don't have\nenough money."},
	{"jump", "purchase"},
      },
      ["BOULDER"] = {
	{"show_text", "This rock is proof\vof item interaction."},
	{"fade", "out", "black"},
	{"heal_party"},
	{"play_once", "Music_PkmnHealed"},
	{"fade", "in", "white"},
	{"show_text", "Your POKEMON\nare fully healed!"},
      },
    },

    onEnter = function(game, ow) restoreActiveFurniture() end,
  })

  -- Map loading
  -- -----------
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

  -- Furniture system
  -- ----------------
  local FURNITURE_BY_ID = {}
  for _, item in ipairs(FURNITURE) do FURNITURE_BY_ID[item.id] = item end

  local function activeFlagFor(item) return "MOD_SECRET_BASE_HAS_" .. item.id end
  local function positionXFlagFor(item) return "MOD_SECRET_BASE_X_" .. item.id end
  local function positionYFlagFor(item) return "MOD_SECRET_BASE_Y_" .. item.id end
  local function purchasedFlagFor(item) return "MOD_SECRET_BASE_PURCHASED_" .. item.id end

  local function positionFor(item)
    local x = mod.world:getFlag(positionXFlagFor(item))
    local y = mod.world:getFlag(positionYFlagFor(item))
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

  local activeNpc = {}

  local function spawnFurniture(item)
    activeNpc[item.id] = mod.world:spawnNpc("SECRET_BASE", objectFor(item))
  end

  local function despawnFurniture(item)
    local npcId = activeNpc[item.id]
    if npcId then mod.world:removeNpc(npcId) end
    mod.world:setFlag(positionXFlagFor(item), nil)
    mod.world:setFlag(positionYFlagFor(item), nil)
    activeNpc[item.id] = nil
  end

  local function relocateFurniture(item, x, y)
    local wasActive = activeNpc[item.id] ~= nil
    if wasActive then despawnFurniture(item) end
    mod.world:setFlag(positionXFlagFor(item), x)
    mod.world:setFlag(positionYFlagFor(item), y)
    if wasActive then spawnFurniture(item) end
  end

  restoreActiveFurniture = function()
    for _, item in ipairs(FURNITURE) do
      if mod.world:getFlag(activeFlagFor(item)) and not activeNpc[item.id] then
        spawnFurniture(item)
      end
    end
  end

  -- Relocation System
  -- ------------------
  local function pickFromList(ctx, title, labels, opts)
    local items = {}
    for _, entry in ipairs(labels) do
      items[#items + 1] = type(entry) == "table" and entry or { label = entry }
    end
    local runner = ctx.runner
    local picked
    local menuOpts = { wrap = true }
    for k, v in pairs(opts or {}) do menuOpts[k] = v end
    menuOpts.onChoose = function(item, self)
      picked = item.label
      self:close()
      runner:resume()
    end
    menuOpts.onCancel = function() runner:resume() end
    local menu = mod.ui.ListMenu.new(ctx.game, title, items, menuOpts)
    ctx.game.stack:push(menu)
    runner:yield()
    return picked -- nil on cancel
  end

  local MOVE_X_LABELS = {}
  for x = 2, 19 do MOVE_X_LABELS[#MOVE_X_LABELS + 1] = tostring(x) end

  local MOVE_Y_LABELS = {}
  for y = 2, 19 do MOVE_Y_LABELS[#MOVE_Y_LABELS + 1] = tostring(y) end

  local itemWithCost = {}

  mod.content.commands:register("secretBase:refreshActiveChoices", {
    fn = function(ctx)
      for i = #activeFurnitureLabels, 1, -1 do
        activeFurnitureLabels[i] = nil
      end
      for _, item in ipairs(FURNITURE) do
        if mod.world:getFlag(activeFlagFor(item)) then
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
        if mod.world:getFlag(purchasedFlagFor(item))
            and not mod.world:getFlag(activeFlagFor(item)) then
          inactiveFurnitureLabels[#inactiveFurnitureLabels + 1] = item.label
        end
      end
      inactiveFurnitureLabels[#inactiveFurnitureLabels + 1] = "CANCEL"
    end,
  })

  mod.content.commands:register("secretBase:refreshUnsoldChoices", {
    fn = function(ctx)
      for i = #itemWithCost, 1, -1 do
        itemWithCost[i] = nil
      end
      for _, item in ipairs(FURNITURE) do
        if not mod.world:getFlag(purchasedFlagFor(item)) then
          itemWithCost[#itemWithCost + 1] = {
            label = item.label,
            right = ("¥%d"):format(item.cost),
          }
        end
      end
    end,
  })

  mod.content.commands:register("secretBase:catalogueChoice", {
    foreground = true,
    fn = function(ctx)
      local choice = ctx.lastChoice and ctx.lastChoice.label
      if choice == "Add Furniture" then return "add" end
      if choice == "Move Furniture" then return "move" end
      if choice == "Remove Furniture" then return "remove" end
      if choice == "Buy Furniture" then return "purchase" end
      return "end" -- Cancel (or menu cancel)
    end,
  })

  mod.content.commands:register("secretBase:addFurniture", {
    foreground = true,
    fn = function(ctx)
      local item = FURNITURE_BY_ID[ctx.lastChoice and ctx.lastChoice.label]
      if not item then return end -- CANCEL
      if not mod.world:getFlag(purchasedFlagFor(item)) then return end -- not owned
      if not mod.world:getFlag(activeFlagFor(item)) then
        mod.world:setFlag(activeFlagFor(item), true)
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

  mod.content.commands:register("secretBase:shopFurnitureList", {
    foreground = true,
    fn = function(ctx)
      local label = pickFromList(ctx, "FURNITURE SHOP", itemWithCost, {
        dialogue = true,
        footer = "Take your time.",
        money = function() return ctx.save.money end,
      })
      if not label then return "end" end -- CANCEL
      ctx.lastChoice = { label = label }
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
      if mod.world:getFlag(activeFlagFor(item)) then
        mod.world:setFlag(activeFlagFor(item), false)
        despawnFurniture(item)
      end
    end,
  })

  mod.content.commands:register("secretBase:purchaseFurniture", {
    fn = function(ctx)
      local item = FURNITURE_BY_ID[ctx.lastChoice and ctx.lastChoice.label]
      if not item then return end -- CANCEL
      if mod.world:getFlag(purchasedFlagFor(item)) then return end -- already owned

      if ctx.save.money < item.cost then return "cant_afford" end

      ctx.save.money = ctx.save.money - item.cost
      mod.world:setFlag(purchasedFlagFor(item), true)
    end,
  })

  -- Shovel item system
  -- ------------------
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

  -- Give player shovel
  -- --------------------
  mod.content.maps:patch("MT_MOON_POKECENTER", {
    objects = { __append = {
      {
        index = 1000, x = 5, y = 3,
        sprite = "SPRITE_SCIENTIST",
        movement = "STAY", range = "DOWN",
        text = "TEXT_OAK_AIDE_SHOVEL", name = "OAK_AIDE_SHOVEL"
      },
    }},
  })

  mod.content.map_scripts:register("MT_MOON_POKECENTER", {
    talk = {
      TEXT_OAK_AIDE_SHOVEL = {
	{"face_player"},
	{"check_item", "MYS_SHOVEL"},
	{"jump_if_true", "has_shovel"},

	{"give_item", "MYS_SHOVEL", 1,
	  "There you are!\vCheck out this\vweird shovel.\vYou can have it!"},
	{"jump", "end"},

	{"label", "has_shovel"},
	{"show_text", "I have tons\nof these things.\012If you lose yours,\vcome talk\vto me again."},
      },
    },
  })
end
