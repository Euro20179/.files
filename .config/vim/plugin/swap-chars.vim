func! Swapchars(line, col) abort
    "nothing to swap
    if a:col < 2
        return
    endif

    let l:lineText = getline(a:line)

    let l:pos = a:col - 1

    if a:col > len(l:lineText)
        let l:pos -= 1
    endif

    let l:lastChar = l:lineText[l:pos]
    let l:secondLast = l:lineText[l:pos - 1]

    let l:prefix = lineText[:l:pos - 2]

    if len(l:lineText) < 3
        let l:prefix = ""
    endif

    let l:suffix = lineText[l:pos + 1:]

    if a:col == 2
        let l:prefix = ""
    endif

    call setline(a:line, l:prefix . l:lastChar . l:secondLast . l:suffix)
endfun

