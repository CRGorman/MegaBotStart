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
        type = "string-setting",
        name = "mbs-quality",
        setting_type = "runtime-global",
        default_value = "normal",
        allowed_values = { "normal", "uncommon", "rare", "epic", "legendary" },
        hidden = not (mods["quality"] and true or false),
        order = "03"
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
