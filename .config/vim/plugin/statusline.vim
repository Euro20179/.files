let g:gitStatsCache = {}
let g:_starttime = str2nr(strftime("%s"))

hi! link User1 Label
hi! link User2 Special
if has("nvim")
    hi! link User3 @property
endif
hi! link User4 Number
hi! link User5 Error
hi! link User6 WarningMsg


function s:calcGitStats()
    if !exists("b:statusline_has_git") 
        let b:statusline_has_git = finddir("./.git")
    endif

    if b:statusline_has_git == ""
        return [0, 0]
    endif
    ":silent prevents the terminal from going into 'cooked mode'
    "whatever the hell that is, the end effect is it prevents
    "garbled ansi codes from appearing in vim on the first draw
    silent let l:gitOut = system("git diff --numstat " .. expand("%"))

    if l:gitOut == ""
        let g:gitStatsCache["add"] = "0"
        let g:gitStatsCache["sub"] = "0"
        return [0, 0]
    endif

    let l:data = split(l:gitOut, '\s')->filter('v:val != ""')

    if len(l:data) == 0 
        let g:gitStatsCache["add"] = "0"
        let g:gitStatsCache["sub"] = "0"
        return [0, 0]
    endif

    let l:add = l:data[0]
    let l:sub = l:data[1]
    let g:gitStatsCache["add"] = l:add
    let g:gitStatsCache["sub"] = l:sub

    return [l:add, l:sub]
endfun

function GetGitStats()
    if !has_key(g:gitStatsCache, "add")
        let l:data = s:calcGitStats()
        let l:add = l:data[0]
        let l:sub = l:data[1]
    else
        let l:add = g:gitStatsCache['add']
        let l:sub = g:gitStatsCache['sub']
    endif

    if l:add == "0" && l:sub == "0"
        return ""
    endif

    return " (%#DiffAdd#+" .. l:add .. " %#DiffDelete#-" .. sub .. "%*)"
endfun

lua <<EOF
function FormatstatuslineDiag()
    local text = ""
    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    if errors ~= 0 then
        text = text .. "%5*" .. tostring(errors) .. "%*"
    end
    if warnings ~= 0 then
        text = text .. ' %6*⚠' .. tostring(warnings) .. '%*'
    end
    return text
end
EOF

function! Secs2HMS(secs)
    let hours = a:secs / 3600
    let mins = (a:secs % 3600) / 60
    let secs = a:secs % 60
    return printf("%02d:%02d:%02d", hours, mins, secs)
endfun

augroup gitstats
    au!
    autocmd BufWritePost * call s:calcGitStats()
augroup END

let left = "%1*%f%2*%{&modified == v:true ? '*' : ''} %{%GetGitStats()%} %4*[%l:%v] %p%%%* %{%has('nvim') ? v:lua.FormatstatuslineDiag() : ''%}"
let right = "%{%Secs2HMS(str2nr(strftime('%s')) - g:_starttime)%} %{&filetype}"
let center = has("nvim")
            \ ? '%3*%{v:lua.GetLspNames()}%*'
            \ : ""

let &statusline = left .. "%=" .. center .. "%=" .. right
