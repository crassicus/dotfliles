vim9script

import "../general/scripts.vim" as gen

# Toggle the return type of a function
def ToggleFnReturnType(): void
    var view = winsaveview()
    var result = gen.SearchUpwards(['def\s.*'])

    if result == -1
        echo "Failed to find function pattern."
        winrestview(view)
        return
    endif

    var line_content = getline('.')

    if match(line_content, ')') == -1
        exe "normal! /^).*:\<cr>"
        line_content = getline('.')
    endif

    if match(line_content, '\->.*:$') != -1
        exe "normal! $F-\<left>dt:"
        winrestview(view)
        return
    endif

    if match(line_content, '\->') != -1
      exe "normal! ^f)d/:\<cr>"
      winrestview(view)

    else
      exe "normal! $F)a\<space>->\<space>\<right>"
      startinsert
    endif

enddef
autocmd FileType python command! -nargs=0 ToggleFnReturnType call ToggleFnReturnType()
