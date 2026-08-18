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
    borderBlock = 0,
    blocks = {
      22, 28, 29, 29, 29, 29, 29, 29, 29, 30, 20,
      26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
      26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
      26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
      26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
      26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
      26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
      26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
      26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
      26,  1,  1,  1,  1,  1,  1,  1,  1,  1, 24,
      30, 20, 21, 21, 21, 21, 21, 21, 21, 22, 28,
    },
    connections = {},
    warps = {},
    signs = {},
    objects = {
      {
        index = 1, x = 19, y = 2, sprite = "SPRITE_POKEDEX", movement = "STAY",
	range = "DOWN", text = "CATALOGUE"
      },
    },
  })
end
