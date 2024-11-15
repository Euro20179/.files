let g:gitStatsCache = {}

function s:calcGitStats()
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

augroup gitstats
    au!
    autocmd BufWritePost * call s:calcGitStats()
augroup END

let left = "%f%{&modified == v:true ? '*' : ''} %{%GetGitStats()%} %p%%"
let right = "%{&filetype}"
let center = ""

let &statusline = left .. "%=" .. center .. "%=" .. right
