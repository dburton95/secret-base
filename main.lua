local FILES = {
  "maps/SECRET_BASE.lua",
}

return function(mod)


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

  mod.content.sprites:register("SPRITE_RECORD_PLAYER", {
    image = mod.assets:path("assets/record_player.png"), frames = 1,
    trueColor = true,
  })

  mod.content.sprites:register("SPRITE_PC", {
    image = mod.assets:path("assets/pc.png"), frames = 1,
    frameWidth = 16, frameHeight = 24, trueColor = true,
    anchorX = TOPLEFT_ANCHOR_X, anchorY = TOPLEFT_ANCHOR_Y,
  })

  mod.content.sprites:register("SPRITE_INVISIBLE", {
    image = mod.assets:path("assets/invisible.png"), frames = 1,
  })

  local MIKU_FRONT = mod.assets:path("assets/mikuFront.png")

  mod.content.trainers:register("OPP_MIKU", {
    id = "OPP_MIKU", name = "HATSUNE MIKU", baseMoney = 75, pic = MIKU_FRONT, trueColor = true,
    parties = {
      {{level = 10, species = "FARFETCHD"}, {level = 10, species = "FARFETCHD"}, {level = 10, species = "FARFETCHD"}, {level = 10, species = "FARFETCHD"}, {level = 10, species = "FARFETCHD"}, {level = 10, species = "FARFETCHD"}},
      {{level = 25, species = "FARFETCHD"}, {level = 25, species = "FARFETCHD"}, {level = 25, species = "FARFETCHD"}, {level = 25, species = "FARFETCHD"}, {level = 25, species = "FARFETCHD"}, {level = 25, species = "FARFETCHD"}},
      {{level = 50, species = "FARFETCHD"}, {level = 50, species = "FARFETCHD"}, {level = 50, species = "FARFETCHD"}, {level = 50, species = "FARFETCHD"}, {level = 50, species = "FARFETCHD"}, {level = 50, species = "FARFETCHD"}},
      {{level = 100, species = "FARFETCHD"}, {level = 100, species = "FARFETCHD"}, {level = 100, species = "FARFETCHD"}, {level = 100, species = "FARFETCHD"}, {level = 100, species = "FARFETCHD"}, {level = 100, species = "FARFETCHD"}},      
    },
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
    {
      id = "RECORD_PLAYER", label = "Music Player", index = 7, x = 10, y = 10,
      sprite = "SPRITE_RECORD_PLAYER", movement = "STAY", range = "NONE",
      cost = 15000, footprint = footprintFor(1, 1),
    },
    {
      id = "GACHA_BALL", label = "Gacha Ball", index = 8, x = 10, y = 10,
      sprite = "SPRITE_POKE_BALL", movement = "STAY", range = "NONE",
      cost = 1000, footprint = footprintFor(1,1),
    },
    {
      id = "PC", label = "PC", index = 9, x =10, y =10,
      sprite = "SPRITE_PC", movement = "STAY", range = "NONE",
      cost = 10000, footprint = footprintFor(1, 1),
    },
    {
      id = "CREDITS", label = "Credits", index = 10, x = 19, y = 2,
      sprite = "SPRITE_CLIPBOARD", movement = "STAY", range = "NONE",
      free = true, default = true, footprint = footprintFor(1, 1),
    },
  }

  local restoreActiveFurniture

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
	{"secretBase:inactiveFurnitureList", "ADD FURNITURE"},
	{"secretBase:addFurniture"},
	{"jump", "end"},

	{"label", "move"},
	{"secretBase:activeFurnitureList", "MOVE FURNITURE"},
	{"secretBase:pickMoveItem"},
	{"secretBase:pickMoveX"},
	{"secretBase:pickMoveY"},
	{"secretBase:moveFurniture"},
	{"jump", "end"},

	{"label", "remove"},
	{"secretBase:activeFurnitureList", "REMOVE FURNITURE"},
	{"secretBase:removeFurniture"},
	{"jump", "end"},

	{"label", "purchase"},
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
	{"secretBase:resumeMusic"},
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
        {"show_text", "Have you heard\nof Farfetch'd?\012It's my favorite\nPokemon!"},
	{"ask", "How about a battle?"},
	{"jump_if_false", "end"},
	{"show_text", "What's your power level?"},
	{"choice", {"Level 10", "Level 25", "Level 50", "Level 100"}},
	{"secretBase:mikuChoice"},
	{"jump", "end"},

	{"label", "10"},
        {"start_battle", "trainer", "OPP_MIKU", 1},
	{"secretBase:resumeMusic"},
	{"jump", "end"},

	{"label", "25"},
	{"start_battle", "trainer", "OPP_MIKU", 2},
	{"secretBase:resumeMusic"},
	{"jump", "end"},

	{"label", "50"},
	{"start_battle", "trainer", "OPP_MIKU", 3},
	{"secretBase:resumeMusic"},
	{"jump", "end"},

	{"label", "100"},
	{"start_battle", "trainer", "OPP_MIKU", 4},
	{"secretBase:resumeMusic"},
      },
      ["Music Player"] = {
        {"ask", "Change the music?"},
	{"jump_if_false", "end"},
	{"secretBase:musicList"},
	{"secretBase:changeMusic"},
	{"show_text", "The mood shifts..."},
      },
      ["Gacha Ball"] = {
        {"ask", "Play the gacha?\nCosts 500"},
	{"jump_if_false", "end"},
	{"secretBase:rollGachaBall"},
	{"jump", "end"},

	{"label", "cant_afford"},
	{"show_text", "You don't have\nenough money."},
      },
      ["PC"] = {
        {"secretBase:openPC"},
      },
      ["Credits"] = {
        {"secretBase:showCredits"},
      },
    },
    

    onEnter = function(game, ow) restoreActiveFurniture() end,
  })


  -- Art Credits
  -- -------------
  local creditsList = {
    {item = "Miku", artist = "MoonLightLass"},
    {item = "Music Player", artist = "7dollar24cent"},
  }


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
  
  -- Gacha Ball
  -- -------------
  local GACHA_TIERS = {
    {id = "COMMON", weight = 70, items = {
      "POTION", 
      "POKE_BALL", 
      "ETHER", 
      "ANTIDOTE", 
      "AWAKENING", 
      "BURN_HEAL", 
      "ICE_HEAL",
      "REPEL",
      "PARLYZ_HEAL",
      "X_ACCURACY",
      "X_ATTACK",
      "X_DEFEND",
      "X_SPECIAL",
      "X_SPEED",
      "DIRE_HIT",
      }
    },
    {id = "UNCOMMON", weight = 25, items = {
      "CALCIUM",
      "CARBOS",
      "ELIXER",
      "ESCAPE_ROPE",
      "FRESH_WATER",
      "FULL_HEAL",
      "GREAT_BALL",
      "HP_UP",
      "IRON",
      "LEMONADE",
      "MAX_ETHER",
      "PP_UP",
      "PROTEIN",
      "REVIVE",
      "SODA_POP",
      "SUPER_POTION",
      "SUPER_REPEL",
      }
    },
    {id = "RARE", weight = 10, items = {
      "FIRE_STONE",
      "FULL_RESTORE",
      "HYPER_POTION",
      "LEAF_STONE",
      "MAX_POTION",
      "MAX_REPEL",
      "MAX_REVIVE",
      "MOON_STONE",
      "MAX_ELIXER",
      "ULTRA_BALL",
      "WATER_STONE",
      }
    },
    {id = "SUPER_RARE", weight = 1, items = {
      "DOME_FOSSIL",
      "HELIX_FOSSIL",
      "NUGGET",
      "OLD_AMBER",
      "RARE_CANDY",
      }
    },
    {id = "MYTHIC", weight = 0.25, items = {
      "MASTER_BALL",
      }
    },
  }

  local function rollGacha(tiers)
    local total = 0
    for _, tier in ipairs(tiers) do total = total + tier.weight end
    local roll, running = math.random() * total, 0
    for _, tier in ipairs(tiers) do
      running = running + tier.weight
      if roll < running then
        local items = tier.items
	return items[math.random(1, #items)], tier.id
      end
    end
    local last = tiers[#tiers]
    return last.items[math.random(1, #last.items)], last.id
  end

  -- Record player
  -- -------------
  mod.content.map_songs:override("SECRET_BASE", "Music_OaksLab")

  local RECORD_PLAYER_MUSIC_FLAG = "MOD_SECRET_BASE_MUSIC"

  mod.hooks:wrap("music.select", function(next, chosen, ctx)
    if ctx and ctx.reason == "map" and ctx.mapId == "SECRET_BASE" then
      local picked = mod.world:getFlag(RECORD_PLAYER_MUSIC_FLAG)
      if picked then return next(picked, ctx) end
    end
    return next(chosen, ctx)
  end)

  -- Furniture system
  -- ----------------
  local FURNITURE_BY_LABEL = {}
  for _, item in ipairs(FURNITURE) do FURNITURE_BY_LABEL[item.label] = item end

  local function activeFlagFor(item) return "MOD_SECRET_BASE_HAS_" .. item.id end
  local function positionXFlagFor(item) return "MOD_SECRET_BASE_X_" .. item.id end
  local function positionYFlagFor(item) return "MOD_SECRET_BASE_Y_" .. item.id end
  local function purchasedFlagFor(item) return "MOD_SECRET_BASE_PURCHASED_" .. item.id end

  local function isPurchased(item)
    return item.free or mod.world:getFlag(purchasedFlagFor(item))
  end

  local function isActive(item)
    local flag = mod.world:getFlag(activeFlagFor(item))
    if flag == nil then return item.default == true end
    return flag
  end

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
      if isActive(item) and not activeNpc[item.id] then
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

  local function musicChoicesFor(data)
    local seen, labels = {}, {}
    for _, song in pairs(data.audio.mapSongs) do
      if song and not seen[song] then
        seen[song] = true
        labels[#labels + 1] = song
      end
    end
    table.sort(labels)
    return labels
  end

  local MOVE_X_LABELS = {}
  for x = 2, 19 do MOVE_X_LABELS[#MOVE_X_LABELS + 1] = tostring(x) end

  local MOVE_Y_LABELS = {}
  for y = 2, 19 do MOVE_Y_LABELS[#MOVE_Y_LABELS + 1] = tostring(y) end

  mod.content.commands:register("secretBase:openPC", {
    foreground = true,
    fn = function(ctx) ctx.overworld:openPC() end,
  })

  mod.content.commands:register("secretBase:inactiveFurnitureList", {
    foreground = true,
    fn = function(ctx, title)
      local labels = {}
      for _, item in ipairs(FURNITURE) do
        if isPurchased(item) and not isActive(item) then
          labels[#labels + 1] = item.label
        end
      end
      local label = pickFromList(ctx, title or "ADD FURNITURE", labels)
      if not label then return "end" end -- CANCEL
      ctx.lastChoice = { label = label }
    end,
  })

  mod.content.commands:register("secretBase:activeFurnitureList", {
    foreground = true,
    fn = function(ctx, title)
      local labels = {}
      for _, item in ipairs(FURNITURE) do
        if isActive(item) then
          labels[#labels + 1] = item.label
        end
      end
      local label = pickFromList(ctx, title or "SELECT FURNITURE", labels)
      if not label then return "end" end -- CANCEL
      ctx.lastChoice = { label = label }
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

  mod.content.commands:register("secretBase:mikuChoice", {
    foreground = true,
    fn = function(ctx)
      local choice = ctx.lastChoice and ctx.lastChoice.label
      if choice == "Level 10" then return "10" end
      if choice == "Level 25" then return "25" end
      if choice == "Level 50" then return "50" end
      if choice == "Level 100" then return "100" end
      return "end"
    end,
  })

  mod.content.commands:register("secretBase:addFurniture", {
    foreground = true,
    fn = function(ctx)
      local item = FURNITURE_BY_LABEL[ctx.lastChoice and ctx.lastChoice.label]
      if not item then return end -- CANCEL
      if not isPurchased(item) then return end -- not owned
      if not isActive(item) then
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
      local itemWithCost = {}
      for _, item in ipairs(FURNITURE) do
        if not isPurchased(item) then
          itemWithCost[#itemWithCost + 1] = {
            label = item.label,
            right = ("¥%d"):format(item.cost),
          }
        end
      end
      local label = pickFromList(ctx, "FURNITURE SHOP", itemWithCost, {
        dialogue = true,
        footer = "Take your time.",
        money = function() return ctx.save.money end,
      })
      if not label then return "end" end -- CANCEL
      ctx.lastChoice = { label = label }
    end,
  })
  
  mod.content.commands:register("secretBase:musicList", {
    foreground = true,
    fn = function(ctx)
      local label = pickFromList(ctx, "CHANGE MUSIC", musicChoicesFor(ctx.game.data))
      if not label then return "end" end
      ctx.lastChoice = {label = label}
    end,
  })

  mod.content.commands:register("secretBase:showCredits", {
    foreground = true,
    fn = function(ctx)
      local Font = mod.ui.Font
      local runner = ctx.runner
      local LINE_HEIGHT = 16
      local ENTRY_GAP = 8 
      local ENTRY_HEIGHT = LINE_HEIGHT * 2 + ENTRY_GAP
      local TOP, BOTTOM = 24, 136
      local rows = math.max(1, math.floor((BOTTOM - TOP) / ENTRY_HEIGHT))
      local scroll = 0 
      local box = {
        isOpaque = true,
        draw = function()
          love.graphics.setColor(1, 1, 1, 1)
          love.graphics.rectangle("fill", 0, 0, 160, 144)
          love.graphics.setColor(0, 0, 0, 1)
          Font.draw("ART CREDITS", 8, 4)
          local n = #creditsList
          if n > 0 then
            local y = TOP
            for row = 0, rows - 1 do
              local entry = creditsList[((scroll + row) % n) + 1]
              Font.draw(entry.item, 16, y)
              Font.draw(entry.artist, 160 - 8 - Font.width(entry.artist), y + LINE_HEIGHT)
              y = y + ENTRY_HEIGHT
            end
          end
          love.graphics.setColor(1, 1, 1, 1)
        end,
        update = function()
          local input = ctx.game.input
          local n = #creditsList
          if n > 0 then
            if input:wasPressed("down") then
              scroll = (scroll + 1) % n
            elseif input:wasPressed("up") then
              scroll = (scroll - 1) % n
            end
          end
          if input:wasPressed("a") or input:wasPressed("b") then
            ctx.game.stack:pop()
            runner:resume()
          end
        end,
      }
      ctx.game.stack:push(box)
      runner:yield()
    end
  })

  mod.content.commands:register("secretBase:changeMusic", {
    fn = function(ctx)
      local song = ctx.lastChoice and ctx.lastChoice.label
      if not song then return end
      mod.world:setFlag(RECORD_PLAYER_MUSIC_FLAG, song)
      pcall(function()
        require("src.core.Music").playMap(ctx.game.data, "SECRET_BASE")
      end)
    end,
  })

  mod.content.commands:register("secretBase:resumeMusic", {
    fn = function(ctx)
      local song = mod.world:getFlag(RECORD_PLAYER_MUSIC_FLAG)
      pcall(function()
        require("src.core.Music").playMap(ctx.game.data, "SECRET_BASE")
      end)
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
      if isActive(item) then
        mod.world:setFlag(activeFlagFor(item), false)
        despawnFurniture(item)
      end
    end,
  })

  mod.content.commands:register("secretBase:purchaseFurniture", {
    fn = function(ctx)
      local item = FURNITURE_BY_LABEL[ctx.lastChoice and ctx.lastChoice.label]
      if not item then return end -- CANCEL
      if isPurchased(item) then return end -- already owned, or free

      if ctx.save.money < item.cost then return "cant_afford" end

      ctx.save.money = ctx.save.money - item.cost
      mod.world:setFlag(purchasedFlagFor(item), true)
    end,
  })

  mod.content.commands:register("secretBase:rollGachaBall", {
    foreground = true,
    fn = function(ctx)
      if ctx.save.money < 500 then return "cant_afford" end
      ctx.save.money = ctx.save.money - 500

      local itemId = rollGacha(GACHA_TIERS)
      require("src.script.Commands").give_item(ctx, itemId)
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
      foreground = true,
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
        mod.world:warpTo("SECRET_BASE", 10, 1, "down",
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
