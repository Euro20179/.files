return {
    keymaps = {
        {
            mode = "n",
            keys = "d",
            action = "dismiss_notification",
        },
        {
            mode = "n",
            keys = "ge",
            action = "last_notification",
        }
    },
    styles = {
        {
            selector = "*",
            style = {
                border = {
                    color = {
                        urgency_critical = "#e78b69",
                        urgency_low = "#83b869",
                        urgency_normal = "#a39aef"
                    }
                },
                font = {
                    color = "#cdd6f4",
                    family = "DejaVu Sans",
                    size = 10
                }
            }
        },
        -- {
        --     selector = {
        --         "next_counter",
        --         "prev_counter",
        --         "notification",
        --         "hints"
        --     },
        --     style = {
        --         background = {
        --             urgency_critical = "#181825FF",
        --             urgency_low = "#1e1e2eFF",
        --             urgency_normal = "#181825FF"
        --         }
        --     }
        -- },
        -- {
        --     selector = "notification",
        --     state = "hover",
        --     style = {
        --         background = {
        --             urgency_critical = "#313244FF",
        --             urgency_low = "#313244FF",
        --             urgency_normal = "#313244FF"
        --         }
        --     }
        -- },
        -- {
        --     selector = "action",
        --     state = "hover",
        --     style = {
        --         background = {
        --             urgency_critical = "#f38ba8",
        --             urgency_low = "#f2cdcd",
        --             urgency_normal = "#f2cdcd"
        --         }
        --     }
        -- },
        -- {
        --     selector = "progress",
        --     style = {
        --         background = {
        --             urgency_critical = "#f38ba8",
        --             urgency_low = "#f2cdcd",
        --             urgency_normal = "#f2cdcd"
        --         }
        --     }
        -- },
        -- {
        --     selector = "dismiss",
        --     style = {
        --         font = {
        --             color = "#00000000"
        --         }
        --     }
        -- },
        -- {
        --     selector = "dismiss",
        --     state = "container_hover",
        --     style = {
        --         font = {
        --             color = "#000000"
        --         }
        --     }
        -- }
    }
}
