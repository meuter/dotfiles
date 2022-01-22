M = {}

function M.get_selected_lines()
    local start_row = vim.fn.line("'<")
    local start_col = vim.fn.col("'<")
    local end_row = vim.fn.line("'>")
    local end_col = vim.fn.col("'>")
    local buffer = 0
    local text = vim.api.nvim_buf_get_lines(buffer, start_row-1, end_row, false)
    local text_length = #text

    end_col = math.min(#text[text_length], end_col)

    local end_idx = vim.str_byteindex(text[text_length], end_col)
    local start_idx = vim.str_byteindex(text[1], start_col)

    text[text_length] = text[text_length]:sub(1, end_idx)
    text[1] = text[1]:sub(start_idx)

    return text
end

function M.get_current_line()
    return vim.api.nvim_get_current_line()
end

function M.get_current_mode()
    return vim.api.get_selected_lines()
end

function M.print_selected_lines()
    local text = M.get_selected_lines()
    print(vim.inspect(text))
end

function M.replace_current_line_with(lines_to_insert)
    local current_position = vim.api.nvim_win_get_cursor(0)
    local current_line_index = current_position[1] -- lua table are 1-indexed!
    vim.api.nvim_buf_set_lines(0, current_line_index-1, current_line_index, true, lines_to_insert)
end

function M.replace_selection_with(lines_to_insert)
    -- TODO(cme): for now replace entire line
    local current_position = vim.api.nvim_win_get_cursor(0)
    local current_line_index = current_position[1] -- lua table are 1-indexed!
    vim.api.nvim_buf_set_lines(0, current_line_index-1, current_line_index, true, lines_to_insert)
end

return M
