local M = {}
local db = require("projects.db")

local function normalize_path(path)
    return string.gsub(path, "\\", "/")
end

function M.add_project(name)
    local cwd = vim.fn.getcwd()
    local n_cwd = normalize_path(cwd)
    local data = db.read_db()

    if not data.projects then
        data.projects = {}
    end

    local project_name = name
    if not project_name or project_name == "" then
        project_name = vim.fn.fnamemodify(cwd, ":t")
    end

    -- Check if already exists
    local exists = false
    for i, p in ipairs(data.projects) do
        if normalize_path(p.path) == n_cwd then
            exists = true
            data.projects[i].name = project_name -- update name if provided
            data.projects[i].last_accessed = os.time()
            break
        end
    end

    if not exists then
        table.insert(data.projects, {
            name = project_name,
            path = cwd,
            added_at = os.time(),
            last_accessed = os.time(),
        })
    end

    db.write_db(data)
    vim.notify("Project added: " .. project_name, vim.log.levels.INFO, { title = "projects.nvim" })
end

function M.show_projects()
    local data = db.read_db()
    local projects = data.projects or {}
    if #projects == 0 then
        vim.notify("No projects registered.", vim.log.levels.WARN, { title = "projects.nvim" })
        return
    end

    -- Sort by last accessed descending
    table.sort(projects, function(a, b)
        return (a.last_accessed or 0) > (b.last_accessed or 0)
    end)

    vim.ui.select(projects, {
        prompt = "Select a Project:",
        format_item = function(item)
            return item.name .. " (" .. item.path .. ")"
        end,
    }, function(choice)
        if choice then
            -- Update last accessed
            for i, p in ipairs(data.projects) do
                if p.path == choice.path then
                    data.projects[i].last_accessed = os.time()
                    break
                end
            end
            db.write_db(data)

            -- Switch directory
            vim.api.nvim_set_current_dir(choice.path)
            vim.notify(
                "Switched to project: " .. choice.name .. ". Restarting Neovim...",
                vim.log.levels.INFO,
                { title = "projects.nvim" }
            )
            vim.cmd("restart")
        end
    end)
end

function M.remove_project()
    local data = db.read_db()
    local projects = data.projects or {}
    if #projects == 0 then
        vim.notify("No projects registered.", vim.log.levels.WARN, { title = "projects.nvim" })
        return
    end

    vim.ui.select(projects, {
        prompt = "Select a Project to Remove:",
        format_item = function(item)
            return item.name .. " (" .. item.path .. ")"
        end,
    }, function(choice)
        if choice then
            local new_projects = {}
            for _, p in ipairs(projects) do
                if p.path ~= choice.path then
                    table.insert(new_projects, p)
                end
            end
            data.projects = new_projects
            db.write_db(data)
            vim.notify("Removed project: " .. choice.name, vim.log.levels.INFO, { title = "projects.nvim" })
        end
    end)
end

function M.setup(opts)
    -- Placeholder for future options
end

return M
