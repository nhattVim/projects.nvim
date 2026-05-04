local M = {}

local data_path = vim.fn.stdpath("data") .. "/project_registry.json"

function M.read_db()
    local f = io.open(data_path, "r")
    if not f then
        return { projects = {} }
    end
    local content = f:read("*a")
    f:close()
    if content == "" then
        return { projects = {} }
    end
    local ok, parsed = pcall(vim.fn.json_decode, content)
    if not ok or type(parsed) ~= "table" then
        return { projects = {} }
    end
    return parsed
end

function M.write_db(data)
    local f = io.open(data_path, "w")
    if not f then
        vim.notify("Could not open project registry for writing", vim.log.levels.ERROR, { title = "projects.nvim" })
        return
    end
    local encoded = vim.fn.json_encode(data)
    f:write(encoded)
    f:close()
end

return M
