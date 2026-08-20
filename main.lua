local FILES = {
  "maps/SECRET_BASE.lua",
}

return function(mod)
  local modOptions = require("mods.secret-base.modOptions")
  modOptions.init(mod)


  -- Define available furniture items
  -- -----------------------------------
  
  -- Set's the item's anchor point to the top left
  -- --------------------------------------------
  local TOPLEFT_ANCHOR_X, TOPLEFT_ANCHOR_Y = 8, 12

  -- Set's the collision detection range for items based
  -- how many tiles it's made of horizontally and vertically
  -- ----------------------------------------------
  local function footprintFor(tilesWide, tilesTall)
    local offsets = {}
    for dy = 0, tilesTall - 1 do
      for dx = 0, tilesWide - 1 do
        if dx ~= 0 or dy ~= 0 then
          offsets[#offsets + 1] = { dx, dy }
        end
      end
    end
    return offsets
  end

  mod.content.sprites:register("SPRITE_BED", {
    image = mod.assets:path("assets/bed.png"), frames = 1,
    frameWidth = 32, frameHeight = 32, trueColor = true,
    anchorX = TOPLEFT_ANCHOR_X, anchorY = TOPLEFT_ANCHOR_Y,
  })

  mod.content.sprites:register("SPRITE_TABLE_SQUARE", {
    image = mod.assets:path("assets/square_table.png"), frames = 1,
    frameWidth = 34, frameHeight = 35, trueColor = true,
    anchorX = TOPLEFT_ANCHOR_X, anchorY = TOPLEFT_ANCHOR_Y,
  })

  mod.content.sprites:register("SPRITE_CHAIR_RIGHT", {
    image = mod.assets:path("assets/chair_right.png"), frames = 1,
    trueColor = true,
  })

  mod.content.sprites:register("SPRITE_CHAIR_LEFT", {
    image = mod.assets:path("assets/chair_left.png"), frames = 1,
    trueColor = true,
  })

  mod.content.sprites:register("SPRITE_MIKU", {
    image = mod.assets:path("assets/miku.png"), frames = 6,
    walker = true, trueColor = true,
  })

  mod.content.sprites:register("SPRITE_INVISIBLE", {
    image = mod.assets:path("assets/invisible.png"), frames = 1,
  })

  -- Anything bigger than one tile needs the footprint attribute
  -- use footprintFor(NUMBER-OF-TILES-IN-X-DIRECTION, NUMBER-OF-TILES-IN-Y-DIRECTION)
  -- to determine the footprint locations automatically.
  -- -----------------------------------------------------

  local FURNITURE = {
    {
      id = "BED", label = "Bed", index = 2, x = 10, y = 10,
      sprite = "SPRITE_BED", movement = "STAY", range = "DOWN",
      cost = 1000,
      footprint = footprintFor(2, 2), -- 32x32 = 2x2 tiles
    },
    {
      id = "TABLE_SQUARE", label = "Square Table", index = 3, x = 10, y =10,
      sprite = "SPRITE_TABLE_SQUARE", movement = "STAY", range = "NONE",
      cost = 500, footprint = footprintFor(2, 2),
    },
    {
      id = "CHAIR_RIGHT", label = "Chair-Right", index = 4, x = 10, y = 10,
      sprite = "SPRITE_CHAIR_RIGHT", movement = "STAY", range = "NONE",
      cost = 250, footprint = footprintFor(1, 1),
    },
    {
      id = "CHAIR_LEFT", label = "Chair-Left", index = 5, x = 10, y = 10,
      sprite = "SPRITE_CHAIR_LEFT", movement = "STAY", range = "NONE",
      cost = 250, footprint = footprintFor(1, 1),
    },
    {
      id = "MIKU", label = "Miku", index = 6, x = 10, y = 10,
      sprite = "SPRITE_MIKU", movement = "WALK", range = 2,
      cost = 25000, footprint = footprintFor(1, 1),
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
      ["Bed"] = {
	{"ask", "Take a rest?"},
	{"jump_if_false", "end"},
	{"fade", "out", "black"},
	{"heal_party"},
	{"play_once", "Music_PkmnHealed"},
	{"fade", "in", "black"},
	{"show_text", "Your POKEMON\nare fully healed!"},
      },
      ["Square Table"] = {
        {"show_text", "It's a table."},
      },
      ["Chair-Right"] = {
        {"show_text", "It's a chair."},
      },
      ["Chair-Left"] = {
        {"show_text", "It's a chair."},
      },
      ["Miku"] = {
        {"show_text", "Have you heard\nof Farfetch'd?\012It's my favorite\vPokemon!"},
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
  local FURNITURE_BY_LABEL = {}
  for _, item in ipairs(FURNITURE) do FURNITURE_BY_LABEL[item.label] = item end

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

  local function footprintObjectsFor(item, x, y)
    local objs = {}
    for _, offset in ipairs(item.footprint or {}) do
      objs[#objs + 1] = {
        x = x + offset[1], y = y + offset[2],
        sprite = "SPRITE_INVISIBLE", movement = "STAY", range = "DOWN",
        text = item.label,
      }
    end
    return objs
  end

  local function spawnFurniture(item)
    local x, y = positionFor(item)
    local npcId = mod.world:spawnNpc("SECRET_BASE", objectFor(item))
    local blockers = {}
    for _, objDef in ipairs(footprintObjectsFor(item, x, y)) do
      blockers[#blockers + 1] = mod.world:spawnNpc("SECRET_BASE", objDef)
    end
    activeNpc[item.id] = { npc = npcId, blockers = blockers }
  end

  local function despawnFurniture(item)
    local entry = activeNpc[item.id]
    if entry then
      mod.world:removeNpc(entry.npc)
      for _, blockerId in ipairs(entry.blockers) do
        mod.world:removeNpc(blockerId)
      end
    end
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
      local item = FURNITURE_BY_LABEL[ctx.lastChoice and ctx.lastChoice.label]
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
      local item = FURNITURE_BY_LABEL[ctx.lastChoice and ctx.lastChoice.label]
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
      local item = FURNITURE_BY_LABEL[ctx.lastChoice and ctx.lastChoice.label]
      if not item then return end -- CANCEL
      if mod.world:getFlag(activeFlagFor(item)) then
        mod.world:setFlag(activeFlagFor(item), false)
        despawnFurniture(item)
      end
    end,
  })

  mod.content.commands:register("secretBase:purchaseFurniture", {
    fn = function(ctx)
      local item = FURNITURE_BY_LABEL[ctx.lastChoice and ctx.lastChoice.label]
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
