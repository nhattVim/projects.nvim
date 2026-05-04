if vim.g.loaded_projects_nvim then
  return
end
vim.g.loaded_projects_nvim = true

vim.api.nvim_create_user_command("ProjectAdd", function(opts)
  require("projects").add_project(opts.args)
end, { nargs = "?", desc = "Add current directory to projects registry" })

vim.api.nvim_create_user_command("ProjectList", function()
  require("projects").show_projects()
end, { desc = "Show and switch to a registered project" })

vim.api.nvim_create_user_command("ProjectRemove", function()
  require("projects").remove_project()
end, { desc = "Remove a project from the registry" })
