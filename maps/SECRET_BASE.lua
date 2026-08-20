-- SECRET_BASE (register): exported from Tiled by gen1-mod-export.
-- Applied by main.lua; see the mod README.
return function(mod)
  mod.content.maps:register("SECRET_BASE", {
    id = "SECRET_BASE",
    label = "SECRET BASE",
    index = 1000,
    tileset = "CAVERN",
    palette = "CAVE",
    width = 11,
    height = 11,
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
    connections = {},
    warps = {},
    signs = {},
    objects = {
      {
        index = 1, x = 11, y = 1, sprite = "SPRITE_POKEDEX", movement = "STAY",
        range = "NONE", text = "CATALOGUE"
      },
    },
  })
end
