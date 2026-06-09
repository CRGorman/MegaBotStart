data:extend({
    {
        type = "int-setting",
        name = "starting-robot-count",
        setting_type = "runtime-global",
        default_value = 50,
        minimum_value = 50,
        maximum_value = 500,
        order = "01"
    },
    {
        type = "int-setting",
        name = "faster-robots",
        setting_type = "runtime-global",
        default_value = 0,
        minimum_value = 0,
        maximum_value = 6,
        order = "02"
    },
    {
        type = "bool-setting",
        name = "shield-start",
        setting_type = "runtime-global",
        default_value = false,
        order = "04"
    },
    {
        type = "bool-setting",
        name = "defense-start",
        setting_type = "runtime-global",
        default_value = false,
        order = "05"
    }
})

local has_quality = mods["quality"] and true or false
data:extend{
  -- Other settings
  {
    type = "string-setting",
    name = "mbs-quality",
    setting_type = "runtime-global",
    default_value = "normal",
    allowed_values = has_quality and { "normal", "uncommon", "rare", "epic", "legendary" } or {"normal"},
    hidden = not has_quality,
    order = "03"
  },
}