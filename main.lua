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

  mod.content.sprites:register("SPRITE_LAMP_OFF", {
    image = mod.assets:path("assets/lamp_off.png"), frames = 1,
    frameWidth = 15, frameHeight = 32, trueColor = true,
    anchorX = TOPLEFT_ANCHOR_X, anchorY = 32,
  })

  mod.content.sprites:register("SPRITE_LAMP_ON", {
    image = mod.assets:path("assets/lamp_on.png"), frames = 1,
    frameWidth = 33, frameHeight = 32, trueColor = true,
    anchorY = 32,
  })

  mod.content.sprites:register("SPRITE_TV", {
    image = mod.assets:path("assets/tv.png"), frames = 1,
    frameWidth = 23, frameHeight = 24, trueColor = true,
  })

  ---------------------------------------------------------------
  mod.content.sprites:register("SPRITE_INVISIBLE", {
    image = mod.assets:path("assets/invisible.png"), frames = 1,
  })

  local MIKU_FRONT = mod.assets:path("assets/mikuFront.png")

  mod.content.trainers:register("OPP_MIKU", {
    id = "OPP_MIKU", name = "HATSUNE MIKU", baseMoney = 99, pic = MIKU_FRONT, trueColor = true,
    parties = {
      {{level = 10, species = "PIKACHU"}, {level = 10, species = "PIDGEY"}, {level = 10, species = "CHARMANDER"}, {level = 10, species = "LAPRAS"}, {level = 10, species = "JIGGLYPUFF"}, {level = 10, species = "FARFETCHD"}},
      {{level = 25, species = "PIKACHU"}, {level = 25, species = "PIDGEOTTO"}, {level = 25, species = "CHARMELEON"}, {level = 25, species = "LAPRAS"}, {level = 25, species = "JIGGLYPUFF"}, {level = 25, species = "FARFETCHD"}},
      {{level = 50, species = "PIKACHU"}, {level = 50, species = "PIDGEOT"}, {level = 50, species = "CHARIZARD"}, {level = 50, species = "LAPRAS"}, {level = 50, species = "WIGGLYTUFF"}, {level = 50, species = "FARFETCHD"}},
      {{level = 100, species = "RAICHU"}, {level = 100, species = "PIDGEOT"}, {level = 100, species = "CHARIZARD"}, {level = 100, species = "LAPRAS"}, {level = 100, species = "WIGGLYTUFF"}, {level = 100, species = "FARFETCHD"}},      
    },
  })


  -- Anything bigger than one tile needs the footprint attribute
  -- use footprintFor(NUMBER-OF-TILES-IN-X-DIRECTION, NUMBER-OF-TILES-IN-Y-DIRECTION)
  -- to determine the footprint locations automatically.
  -- -----------------------------------------------------

  local FURNITURE_CATEGORIES = { "DECORATIONS", "FUNCTIONAL", "TRAINERS" }

  -- current index 15

  local FURNITURE = {
    DECORATIONS = {
      {
        id = "CHAIR_LEFT_1", label = "Chair L. 1", index = 5, x = 10, y = 10,
        sprite = "SPRITE_CHAIR_LEFT", movement = "STAY", range = "NONE",
        cost = 250, footprint = footprintFor(1, 1),
      },
      {
        id = "CHAIR_LEFT_2", label = "Chair L. 2", index = 14, x = 10, y = 10,
        sprite = "SPRITE_CHAIR_LEFT", movement = "STAY", range = "NONE",
        cost = 250, footprint = footprintFor(1, 1),
      },     
      {
        id = "CHAIR_RIGHT_1", label = "Chair R. 1", index = 4, x = 10, y = 10,
        sprite = "SPRITE_CHAIR_RIGHT", movement = "STAY", range = "NONE",
        cost = 250, footprint = footprintFor(1, 1),
      },
      {
        id = "CHAIR_RIGHT_2", label = "Chair R. 2", index = 15, x = 10, y = 10,
        sprite = "SPRITE_CHAIR_RIGHT", movement = "STAY", range = "NONE",
        cost = 250, footprint = footprintFor(1, 1),
      },
      {
        id = "LAMP", label = "Lamp", index = 11, x = 10, y = 10,
        sprite = "SPRITE_LAMP_OFF", movement = "STAY", range = "NONE",
        cost = 250, footprint = footprintFor(1, 1),
      },
      {
        id = "TABLE_SQUARE", label = "Square Table", index = 3, x = 10, y =10,
        sprite = "SPRITE_TABLE_SQUARE", movement = "STAY", range = "NONE",
        cost = 500, footprint = footprintFor(2, 2),
      },
      {
        id = "TV", label = "TV", index = 12, x = 10, y = 10,
        sprite = "SPRITE_TV", movement = "STAY", range = "NONE",
        cost = 2000, footprint = footprintFor(1, 1),
      },
    },
    FUNCTIONAL = {
      {
        id = "BED", label = "Bed", index = 2, x = 10, y = 10,
        sprite = "SPRITE_BED", movement = "STAY", range = "DOWN",
        cost = 1000,
        footprint = footprintFor(2, 2), -- 32x32 = 2x2 tiles
      },
      {
        id = "CREDITS", label = "Credits", index = 10, x = 19, y = 2,
        sprite = "SPRITE_CLIPBOARD", movement = "STAY", range = "NONE",
        free = true, default = true, footprint = footprintFor(1, 1),
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
        id = "RECORD_PLAYER", label = "Music Player", index = 7, x = 10, y = 10,
        sprite = "SPRITE_RECORD_PLAYER", movement = "STAY", range = "NONE",
        cost = 15000, footprint = footprintFor(1, 1),
      },
      {
        id = "RENO_MACHOP", label = "Reno. Machop", index = 13, x =10, y = 10,
        sprite = "SPRITE_MONSTER", movement = "WALK", range = 2,
        cost = 50000, footprint = footprintFor(1, 1),
      },
    },
    TRAINERS = {
      {
        id = "MIKU", label = "Miku", index = 6, x = 10, y = 10,
        sprite = "SPRITE_MIKU", movement = "WALK", range = 2,
        cost = 25000, footprint = footprintFor(1, 1),
      },
      {
        id = "OAK", label = "Prof. Oak", index = 16, x = 10, y =10,
        sprite = "SPRITE_OAK", movement = "WALK", range = 2,
        cost = 25000, footprint = footprintFor(1, 1),
      },
    },
  }

  local restoreActiveFurniture
  local applyTileset

  -- TV Lines
  -- --------
  local showList = {
    "A strange blue\nPokemon is looking\vfor clues?",
    "..........\v..........\012I hope Mom doesn't\nsee this on the\vcable bill.",
    "A man complains\nabout a 5 dollar\vshake.",
    "She could fit Jack\non that door...",
    "I could've sworn\nhe said Luke...",
    "Somehow he\ndisarmed a bomb\vwith a ballpoint\vpen and gum.",
    "He insists the car\nis a time machine\012but only if you\ndrive crazy fast.",
    "He should've got a\nbigger boat...",
    "That aerodactyl is\na clever girl.",
    "A man holds a blue\nand a red pill.",
    "You miss 100% of\nthe shots you\vdon't take.\012...\012-Wayne Gretsky\012-Michael Scott",
    "A polite painter\nassures you that\vthe tree should be\vthere.",
    "A metal trash can\nis shouting.\012EXTERMINATE!\nEXTERMINATE!",
    "A disembodied hand\ncrosses the room\vcarrying the mail.",
    "Four Squirtles in\nmasks are eating\vpizza.",
  }

  local function buildTvTalk()
    local talk = {
      {"secretBase:pickShow"},
      {"jump", "end"},
    }
    for i, line in ipairs(showList) do
      talk[#talk + 1] = {"label", tostring(i)}
      talk[#talk + 1] = {"show_text", line}
      talk[#talk + 1] = {"jump", "end"}
    end
    return talk
  end

  -- Secret base catalogue script
  -- ----------------------------
  mod.content.map_scripts:register("SECRET_BASE", {
    talk = {
      ["CATALOGUE"] = {
  	    {"show_text", "MYSTIC FURNITURE\nCATALOGUE:"},
	      {"choice", {"Add Furniture", "Move Furniture", "Remove Furniture", "Buy Furniture", "Call Oak's Aid", "Cancel"}},
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

        {"label", "call_aid"},
        {"show_text", "..................\n..................\012Hey, how's it\ngoing?\012Did you need\nsomething?"},
        {"choice", {"New Shovel", "New Watch"}},
        {"secretBase:oaksAidChoice"},
        {"jump","end"},

        {"label", "shovel"},
        {"check_item", "MYS_SHOVEL"},
        {"jump_if_true", "has_shovel"},
        {"give_item", "MYS_SHOVEL", 1, "Oh did you lose\nyour shovel?\012I'll mail it to\nyou."},
        {"jump", "end"},

        {"label", "has_shovel"},
        {"show_text", "You already have a\nshovel..."},
        {"jump", "end"},

        {"label", "watch"},
        {"check_item", "MYSTIC_WATCH"},
        {"jump_if_true", "has_watch"},
        {"give_item", "MYSTIC_WATCH", 1, "Dang you lost your\nwatch?\012I'll mail you a\nnew one."},
        {"jump", "end"},

        {"label", "has_watch"},
        {"show_text", "You already have a\nwatch..."},

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
      ["Chair R. 1"] = {
        {"show_text", "It's a chair."},
      },
      ["Chair L. 1"] = {
        {"show_text", "It's a chair."},
      },
      ["Chair R. 2"] = {
        {"show_text", "It's a chair."},
      },
      ["Chair L. 2"] = {
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
      ["Lamp"] = {
        {"ask", "Pull the cord?"},
        {"jump_if_false", "end"},
        {"secretBase:swapLampStatus"},
      },
      ["TV"] = buildTvTalk(),
      ["Reno. Machop"] = {
        {"show_text", "The Machop yearns\nto renovate."},
        {"ask", "Change the tileset?"},
        {"jump_if_false", "end"},
        {"choice", {"Cave", "Cemetery", "Forest", "House"}},
        {"secretBase:changeTileset"},
      },
      ["Prof. Oak"] = {
        {"show_text", "How's your Pokedex\ncoming along?"},
        {"choice", {"Rate Pokedex", "Battle"}},
        {"secretBase:chooseOakOption"},
        {"jump", "end"},

        {"label", "Rate Pokedex"},
        {"dex_rating"},
        {"jump", "end"},

        {"label", "Battle"},
        {"secretBase:chooseOakBattle"},
        {"jump", "end"},

        {"label", "1"},
        {"start_battle", "trainer", "OPP_PROF_OAK", 1},
        {"jump", "end"},

        {"label", "2"},
        {"start_battle", "trainer", "OPP_PROF_OAK", 2},
        {"jump", "end"},

        {"label", "3"},
        {"start_battle", "trainer", "OPP_PROF_OAK", 3},
      },
    },
  

    onEnter = function(game, ow) restoreActiveFurniture() applyTileset() end,
  })


  -- Tilesets
  ---------------------------
  local TILESET_FLAG = "MOD_SECRET_BASE_TILESET"

  local TILESET_BY_CHOICE = {
    Cave = {
      tileset = "CAVERN",
      palette = "CAVE",
      borderBlock = 25,
      blocks = {
        25, 29, 29, 29, 30, 85, 28, 29, 29, 29, 25,
        26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
        26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
        26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
        26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
        26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
        26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
        26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
        26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
        26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
        25, 21, 21, 21, 21, 21, 21, 21, 21, 21, 25,
      },
    },
    Cemetery = {
      tileset = "CEMETERY",
      palette = "MEWMON",
      borderBlock = 82,
      blocks = {
        82, 82, 82, 82, 82, 76, 82, 82, 82, 82, 82,
        82, 54, 54, 54, 54, 54, 54, 54, 54, 54, 82,
        82, 54, 54, 54, 54, 54, 54, 54, 54, 54, 82,
        82, 54, 54, 54, 54, 54, 54, 54, 54, 54, 82,
        82, 54, 54, 54, 54, 54, 54, 54, 54, 54, 82,
        82, 54, 54, 54, 54, 54, 54, 54, 54, 54, 82,
        82, 54, 54, 54, 54, 54, 54, 54, 54, 54, 82,
        82, 54, 54, 54, 54, 54, 54, 54, 54, 54, 82,
        82, 54, 54, 54, 54, 54, 54, 54, 54, 54, 82,
        82, 54, 54, 54, 54, 54, 54, 54, 54, 54, 82,
        82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82,
      },
    },
    Forest = {
      tileset = "GYM",
      palette = "CELADON",
      borderBlock = 52,
      blocks = {
        52, 52, 52, 52, 52, 58, 52, 52, 52, 52, 52,
        52, 51, 51, 51, 51, 51, 51, 51, 51, 51, 52,
        52, 51, 51, 51, 51, 51, 51, 51, 51, 51, 52,
        52, 51, 51, 51, 51, 51, 51, 51, 51, 51, 52,
        52, 51, 51, 51, 51, 51, 51, 51, 51, 51, 52,
        52, 51, 51, 51, 51, 51, 51, 51, 51, 51, 52,
        52, 51, 51, 51, 51, 51, 51, 51, 51, 51, 52,
        52, 51, 51, 51, 51, 51, 51, 51, 51, 51, 52,
        52, 51, 51, 51, 51, 51, 51, 51, 51, 51, 52,
        52, 51, 51, 51, 51, 51, 51, 51, 51, 51, 52,
        52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
      },
    },
    House = {
      tileset = "CEMETERY",
      palette = "GRAYMON",
      borderBlock = 1,
      blocks = {
        2,  2,  2,  2,  2,  6,  2,  2,  2,  2,  2,
        2, 14, 14, 14, 14, 14, 14, 14, 14, 14,  2,
        2, 14, 14, 14, 14, 14, 14, 14, 14, 14,  2,
        2, 14, 14, 14, 14, 14, 14, 14, 14, 14,  2,
        2, 14, 14, 14, 14, 14, 14, 14, 14, 14,  2,
        2, 14, 14, 14, 14, 14, 14, 14, 14, 14,  2,
        2, 14, 14, 14, 14, 14, 14, 14, 14, 14,  2,
        2, 14, 14, 14, 14, 14, 14, 14, 14, 14,  2,
        2, 14, 14, 14, 14, 14, 14, 14, 14, 14,  2,
        2, 14, 14, 14, 14, 14, 14, 14, 14, 14,  2,
        2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,
      },      
    },
  }



  local function applyTilesetChoice(choice)
    local tileset = choice and TILESET_BY_CHOICE[choice]
    if not tileset then return end
    local game = mod.game
    local def = game and game.data and game.data.maps
      and game.data.maps["SECRET_BASE"]
    if not def then return end
    def.tileset = tileset.tileset
    def.palette = tileset.palette
    def.borderBlock = tileset.borderBlock
    def.blocks = tileset.blocks
    mod.world:invalidateMap("SECRET_BASE")
  end

  applyTileset = function()
    local choice = mod.world:getFlag(TILESET_FLAG)
    if choice then applyTilesetChoice(choice) end
  end

 

  -- Art Credits
  -- -------------
  local creditsList = {
    {item = "This mod made by:", artist = "Team Kris"},
    {item = "Miku", artist = "MoonLightLass"},
    {item = "Music Player", artist = "7dollar24cent"},
    {item = "TV Lines", artist = "Elvie"},
    {item = "TV Lines", artist = "Sanura"},
    {item = "TV Lines", artist = "ZephyrraDawn"},
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
  for _, category in ipairs(FURNITURE_CATEGORIES) do
    for _, item in ipairs(FURNITURE[category]) do
      FURNITURE_BY_LABEL[item.label] = item
    end
  end

  local function activeFlagFor(item) return "MOD_SECRET_BASE_HAS_" .. item.id end
  local function positionXFlagFor(item) return "MOD_SECRET_BASE_X_" .. item.id end
  local function positionYFlagFor(item) return "MOD_SECRET_BASE_Y_" .. item.id end
  local function purchasedFlagFor(item) return "MOD_SECRET_BASE_PURCHASED_" .. item.id end

  local function isPurchased(item)
    return item.free or mod.world:getFlag(purchasedFlagFor(item))
  end

  local LAMP_ON_FLAG = "MOD_SECRET_BASE_LAMP_ON"
  local PUSH_MODE_FLAG = "MOD_SECRET_BASE_PUSH_MODE"

  local function spriteFor(item)
    if item.id == "LAMP" and mod.world:getFlag(LAMP_ON_FLAG) then
      return "SPRITE_LAMP_ON"
    end
    return item.sprite
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
      index = item.index, x = x, y = y, sprite = spriteFor(item),
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
    for _, category in ipairs(FURNITURE_CATEGORIES) do
      for _, item in ipairs(FURNITURE[category]) do
        if isActive(item) and not activeNpc[item.id] then
          spawnFurniture(item)
        end
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
  local DIR_DELTA = {
    up = {0, -1}, down = {0, 1}, left = {-1, 0}, right = {1, 0},
  }
  
  local function pushableItemAt(x, y)
    for _, category in ipairs(FURNITURE_CATEGORIES) do
      for _, item in ipairs(FURNITURE[category]) do
        if item.movement == "STAY" and not item.noPush
            and #(item.footprint or {}) == 0 and isActive(item) then
          local ix, iy = positionFor(item)
          if ix == x and iy == y then return item end
        end
      end
    end
  end

  mod.hooks:wrap("movement.collision", function(next, allowed, ctx)
    if allowed or ctx.reason ~= "entity" then return next(allowed, ctx) end
    if not mod.world:getFlag(PUSH_MODE_FLAG) then return next(allowed, ctx) end

    local ow = mod.world:overworld()
    if not ow or ctx.mover ~= ow.player or not ow.map
        or ow.map.id ~= "SECRET_BASE" then
      return next(allowed, ctx)
    end

    local item = pushableItemAt(ctx.toX, ctx.toY)
    local entry = item and activeNpc[item.id]
    local handle = entry and mod.world:npc("SECRET_BASE", entry.npc)
    if not handle or handle:isMoving() or not handle:canStep(ctx.dir) then
      return next(allowed, ctx) -- something's in the way; stays blocked
    end

    handle:stepNow(ctx.dir) -- animated slide, same timing as the player's step
    local d = DIR_DELTA[ctx.dir]
    mod.world:setFlag(positionXFlagFor(item), ctx.toX + d[1])
    mod.world:setFlag(positionYFlagFor(item), ctx.toY + d[2])

    return next(true, ctx) -- let the player step into the vacated tile
  end)

  local function pickFromCategories(ctx, title, categorized, opts)
    local available = {}
    for _, category in ipairs(FURNITURE_CATEGORIES) do
      if categorized[category] and #categorized[category] > 0 then
        available[#available + 1] = category
      end
    end
    while true do
      local category = pickFromList(ctx, title, available)
      if not category then return nil end -- backed out entirely
      local label = pickFromList(ctx, category, categorized[category], opts)
      if label then return label end
    end
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

  -- Talk Script Helper Functions
  ---------------------------------


  mod.content.commands:register("secretBase:chooseOakOption", {
    foreground = true,
    fn = function(ctx)
      local choice = ctx.lastChoice and ctx.lastChoice.label
      if choice == "Rate Pokedex" then return "Rate Pokedex" end
      if choice == "Battle" then return "Battle" end
      return "end" -- Cancel (or menu cancel)
    end,
  })

  mod.content.commands:register("secretBase:chooseOakBattle", {
    fn = function(ctx)
      return tostring(math.random(1, 3))
    end,
  })

  mod.content.commands:register("secretBase:swapLampStatus", {
    fn = function(ctx)
      local lamp = FURNITURE_BY_LABEL["Lamp"]
      local x, y = positionFor(lamp)
      mod.world:setFlag(LAMP_ON_FLAG, not mod.world:getFlag(LAMP_ON_FLAG))
      despawnFurniture(lamp)
      mod.world:setFlag(positionXFlagFor(lamp), x)
      mod.world:setFlag(positionYFlagFor(lamp), y)
      spawnFurniture(lamp)
    end,
  })

  mod.content.commands:register("secretBase:pickShow", {
    fn = function(ctx)
      return tostring(math.random(#showList))
    end,
  })

  mod.content.commands:register("secretBase:openPC", {
    foreground = true,
    fn = function(ctx) ctx.overworld:openPC() end,
  })

  mod.content.commands:register("secretBase:inactiveFurnitureList", {
    foreground = true,
    fn = function(ctx, title)
      local categorized = {}
      for _, category in ipairs(FURNITURE_CATEGORIES) do
        categorized[category] = {}
        for _, item in ipairs(FURNITURE[category]) do
          if isPurchased(item) and not isActive(item) then
            table.insert(categorized[category], item.label)
          end
        end
      end
      local label = pickFromCategories(ctx, title or "ADD FURNITURE", categorized)
      if not label then return "end" end -- CANCEL
      ctx.lastChoice = { label = label }
    end,
  })

  mod.content.commands:register("secretBase:activeFurnitureList", {
    foreground = true,
    fn = function(ctx, title)
      local categorized = {}
      for _, category in ipairs(FURNITURE_CATEGORIES) do
        categorized[category] = {}
        for _, item in ipairs(FURNITURE[category]) do
          if isActive(item) then
            table.insert(categorized[category], item.label)
          end
        end
      end
      local label = pickFromCategories(ctx, title or "SELECT FURNITURE", categorized)
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
      if choice == "Call Oak's Aid" then return "call_aid" end
      return "end" -- Cancel (or menu cancel)
    end,
  })

  mod.content.commands:register("secretBase:oaksAidChoice", {
    foreground = true,
    fn = function(ctx)
      local choice = ctx.lastChoice and ctx.lastChoice.label
      if choice == "New Shovel" then return "shovel" end
      if choice == "New Watch" then return "watch" end
      return "end"
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

  mod.content.commands:register("secretBase:changeTileset", {
    fn = function(ctx)
      local choice = ctx.lastChoice and ctx.lastChoice.label
      if not choice or not TILESET_BY_CHOICE[choice] then return end
      mod.world:setFlag(TILESET_FLAG, choice)
      applyTilesetChoice(choice)
    end,
  })


  mod.content.commands:register("secretBase:forceSave", {
    fn = function(ctx) ctx.game:writeSave() end,
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
      local categorized = {}
      for _, category in ipairs(FURNITURE_CATEGORIES) do
        categorized[category] = {}
        for _, item in ipairs(FURNITURE[category]) do
          if not isPurchased(item) then
            table.insert(categorized[category], {
              label = item.label,
              right = ("¥%d"):format(item.cost),
            })
          end
        end
      end
      local label = pickFromCategories(ctx, "FURNITURE SHOP", categorized, {
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
        local lastOutdoor = ctx.save.lastOutdoor
        if not lastOutdoor then
          mod.world:warpTo("REDS_HOUSE_2F", 3, 6, "down",
            {arrive = "teleport"})
        else
          mod.world:warpTo(lastOutdoor.id, lastOutdoor.x, lastOutdoor.y, "down",
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

  -- Mystic Watch item system
  -- ------------------------
  mod.content.items:register("MYSTIC_WATCH", {
    id = "MYSTIC_WATCH", name = "MYSTIC WATCH", price = 0,
    tossable = false, effect = "MYS_WATCH_EFFECT",
  })

  mod.content.item_effects:register("MYS_WATCH_EFFECT", {
    field = true, battle = false,
    use = function(ctx)
      local on = not mod.world:getFlag(PUSH_MODE_FLAG)
      mod.world:setFlag(PUSH_MODE_FLAG, on)
      return "kept", {on
        and "You suddenly feel\nvery strong!\012Try pushing some\nfurniture."
        or "You feel weak like\nsomeone that can't\vmove furniture."}
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

  local shovelGiverScript = {
    {"face_player"},
    {"check_item", "MYS_SHOVEL"},
    {"jump_if_true", "has_shovel"},
    {"give_item", "MYS_SHOVEL", 1, 
      "There you are!\012Check out this\nweird shovel.\012You can have it!"},

    {"label", "has_shovel"},
    {"check_item", "MYSTIC_WATCH"},
    {"jump_if_true", "has_watch"},
    {"give_item", "MYSTIC_WATCH", 1,
      "Oh, and take this\nwatch, too.\012It'll make you\nstrong!"},
    {"jump", "end"},

    {"label", "has_watch"},
    {"show_text", "I have tons\nof these things.\012If you lose yours,\vcome talk\vto me again."},
  }

  mod.content.map_scripts:register("MT_MOON_POKECENTER", {
    talk = {
      TEXT_OAK_AIDE_SHOVEL = shovelGiverScript,
    },
  })
end
