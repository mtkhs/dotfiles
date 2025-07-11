return {
  "echasnovski/mini.starter",
  config = function()
	local pad = string.rep(" ", 0)
	local new_section = function(name, action, section)
		return { name = name, action = action, section = pad .. section }
	end
	local starter = require("mini.starter")
	local config = {
		evaluate_single = true,
		items = {
            starter.sections.recent_files(16, false),
			starter.sections.telescope(),
            starter.sections.builtin_actions(),
		},
		content_hooks = {
			starter.gen_hook.adding_bullet(pad .. "░ ", false),
			starter.gen_hook.aligning("center", "center"),
		},
	}
	starter.setup(config)
  end
}
