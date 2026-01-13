require "mini.move".setup {
    mappings = {
        left = "<a-h>",
        right = "<a-l>",
        down = "<a-j>",
        up = "<a-k>",

        line_left = "<Plug>",
        line_right = "<plug>",
        line_down = "<plug>",
        line_up = "<plug>",
    }
}

require "mini.surround".setup {
    custom_surroundings = {
        T = {
            output = function()
                local name = require "mini.surround".user_input("Name of template type")
                return { left = name .. "<", right = ">" }
            end
        },
    },
    mappings = {
        add = '<leader>s',
        delete = 'ds',
        find = '<plug>',
        find_left = '<plug>',
        highlight = '<plug>',
        replace = 'cs',
        update_n_lines = '<plug>'
    }
}

require "mini.splitjoin".setup {}

require "mini.operators".setup {
    exchange = {
        prefix = "<leader>x"
    },
    multiply = {
        prefix = "<Plug>" --also disable, never use it
    },
    replace = {
        prefix = "<leader>r"
        --more portable, possibly make own version to use <reg>yr<motion>
    },
    sort = {
        prefix = '<Plug>' --disable sort feature, by setting an inacessable key
    }
}

require "mini.pick".setup {
    window = {
        config = function()
            return {
                width = vim.o.columns - 30
            }
        end
    }
}
