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

  mod.content.items:register("MYS_SHOVEL", {
    id = "MYS_SHOVEL", name = "MYSTIC SHOVEL", price = 0,
    tossable = false, effect = "MYS_SHOVEL_EFFECT",
  })

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
      end
      mod.world:warpTo(lastPC.map, lastPC.x, lastPC.y, "down",
        {arrive = "teleport"})
    else
      mod.world:warpTo("SECRET_BASE", 5, 5, "down",
        {arrive = "teleport"})
    end

    return "kept", {string.format("%s used the\n%s!",
      ctx.save.player.name, ctx.item.name)}
  end,
  })
end
