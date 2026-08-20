local modOptions = {}

local CREDITS = {
  {key = "credit_creator", label = "MOD CREATOR", name = "Dgray66"},
  {key = "credit_miku", label = "MIKU SPRITE", name = "MoonLightLass"},
}

function modOptions.init(mod)
  local schema = {}
  for _, entry in ipairs(CREDITS) do
    table.insert(schema, {
      key = entry.key,
      type = "choice",
      label = entry.label,
      choices = { { entry.name, entry.key } },
      default = entry.key,
    })
  end
  mod.options:define(schema)
end

return modOptions
