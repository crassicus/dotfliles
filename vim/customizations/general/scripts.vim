vim9script

# ==== General Scripts ====

# ==== Global variables ====
g:nerdtree_is_open = false
g:fugitive_is_open = false


# ------------------------------------------------
# Searches upward for patterns, moves the cursor to the
# match, and returns the line number if found or -1 otherwise.
# Stops at the first match in the given list.
# ------------------------------------------------
export def SearchUpwards(patterns: list<string>): number
    var original_position = getpos(".")
    var current_line_number = line(".")

    while current_line_number > 0
        var line_content = getline(current_line_number)

        for pattern in patterns
            if match(line_content, pattern) != -1
                cursor(current_line_number, 1)
                return 0
            endif
        endfor
        current_line_number -= 1
    endwhile

    return -1
enddef
command! -nargs=* SearchUpwards call SearchUpwards([<f-args>])

# ------------------------------------------------
# Searches downward for patterns, moves the cursor to the
# match, and returns the line number if found or -1 otherwise.
# Stops at the first match in the given list.
# ------------------------------------------------
export def SearchDownwards(patterns: list<string>): number
    var original_position = getpos(".")
    var current_line_number = line(".")

    while current_line_number <= line("$")
        var line_content = getline(current_line_number)

        for pattern in patterns
            if match(line_content, pattern) != -1
                cursor(current_line_number, 1)
                return 0
            endif
        endfor
        current_line_number += 1
    endwhile

    return -1
enddef
command! -nargs=* SearchDownwards call SearchDownwards([<f-args>])

# ------------------------------------------------
# Creates a file or directory within the ROOT folder
# as the base directory.
# ------------------------------------------------
def CreateEntry(entries: list<string>)
    g:entries = entries
    py3 << EOF

from swiss_knife import create_entry

for entry in vim.eval("g:entries"):
    try:
        create_entry(entry)
    except Exception as e:
        print(f"{e}")
EOF
enddef
command! -nargs=* CreateEntry call CreateEntry([<f-args>])

# ------------------------------------------------
#  Handle toggling for NerdTree
# ------------------------------------------------
def ToggleNerdTree(): void
  if g:nerdtree_is_open == true

    exec "silent normal! :NERDTreeClose\<cr>"
    # Mutate global state
    g:nerdtree_is_open = false

  else
    # Set nerdtree width
    if &columns > 88
        g:NERDTreeWinSize = float2nr(&columns * 0.25)
    else
        g:NERDTreeWinSize = float2nr(&columns * 0.30)
    endif

    exec "silent normal! :NERDTree\<cr>"
    # Give cursor to main buffer
    call feedkeys("\<C-w>w", 'n')

    # Mutate global state
    g:nerdtree_is_open = true
  endif
enddef
command! -nargs=0 ToggleNerdTree call ToggleNerdTree()


# ------------------------------------------------
#  Handle toggling for Fugitive
# ------------------------------------------------
def ToggleFugitive(): void
  if g:fugitive_is_open == true
      execute "normal! :quit\<cr>"
      g:fugitive_is_open = false
  else
      execute "normal! :leftabove Git\<cr>"
      g:fugitive_is_open = true
  endif
enddef
command! -nargs=0 ToggleFugitive call ToggleFugitive()


# ------------------------------------------------
# Add 10 empty lines to the end of the file
# ------------------------------------------------
def Spaces(): void
    var view = winsaveview()
    execute "normal! G"
    for _ in range(1, 11)
      append(line("."), "")
    endfor
    winrestview(view)
    execute "normal! zz"
enddef
command! -nargs=0 Spaces call Spaces()

# ------------------------------------------------
#  Vertical diff for current file.
#  You can pass a branch name or certain number of
#  commits ago
# ------------------------------------------------
def Gverdiff(parameter: string): void

  if parameter == ""
    execute "Gvdiffsplit HEAD~0:%"
    echo "Comparing with last commit." | return
  endif

  # This function returns 0 when is not able to parse
  # the given string into an integer number
  var argument = str2nr(parameter)

  if argument < 0
    echo "Number of commits ago must be >= 1"
    echo "Call this function with no arguments for the last commit." | return
  endif

  if argument >= 1
    execute $"Gvdiffsplit HEAD~{argument}:%"
    echo $"Comparing with {argument} commits ago." | return
  endif

  execute $"Gvdiffsplit {parameter}"
  echo $"Comparing with branch {parameter}."
enddef
command! -nargs=? Gverdiff call Gverdiff(<q-args>)

# ------------------------------------------------
#  Run a specified command in the terminal within
#  the ROOT directory.
# ------------------------------------------------
def CommandFromRoot(args: list<string>)
    var args_string = join(args, " ")
    var command = $"cd {expand('$ROOT')} && {args_string}"
    echo trim(system(command))
enddef
command! -nargs=* CommandFromRoot call CommandFromRoot([<f-args>])

# ------------------------------------------------
#  Add underscore at the beginning of the word the
#  cursor is on
# ------------------------------------------------
def CommentWord()
    var view = winsaveview()

    var current_word = expand("<cword>")
    var first_char = current_word[0]

    if first_char == '_'
        execute "normal! ebx"
    else
        execute "normal! ebi_"
    endif

    winrestview(view)
enddef
command! -nargs=0 CommentWord call CommentWord()

# ------------------------------------------------
#  Capitalize and Decapitalize current word
# ------------------------------------------------
def ToggleWord()
    var view = winsaveview()
    var word = expand("<cword>")
    if word == "" | return | endif

    var first_letter: string
    var rest_of_word = word[1 :]

    if match(word, '^[A-Z].*') != -1
        first_letter = tolower(word[0])
    else
        first_letter = toupper(word[0])
    endif
    execute "normal! ciw" .. first_letter .. rest_of_word
    winrestview(view)
enddef

command! -nargs=0 ToggleWord call ToggleWord()

# ------------------------------------------------
#  Breaks brackets
# ------------------------------------------------
def BreakBrackets()
    var line_content = getline(line("."))

    if match(line_content, '{}') != -1
        execute "normal! 0f}i\<cr>\<cr>\<esc>k"
        feedkeys('S')
        return
    endif

    echo 'Pattern {} not found.'
enddef
command! -nargs=0 BreakBracketst call BreakBrackets()

# ------------------------------------------------
# Counts the number of times an expression is found
# in a given line
# ------------------------------------------------
export def CountMatches(line: string, expresion: string): number
  var count = 0
  var position = 0
  var result = -1

  while position >= 0
    result = match(line, expresion, position)
    if result >= 0
      count = count + 1
    else
      break
    endif

    position = result + 1
  endwhile

  return count
enddef

# ------------------------------------------------
# Yank the current file's  path
# ------------------------------------------------
def YankCurrentPath(): void
    @+ = expand('%')
    if @+ == ""
        echom "❗ Current file seems to be nameless"
        return
    endif

    echo "🧭 " .. @+ .. " yanked"
enddef
command! -nargs=0 YankCurrentPath call YankCurrentPath()

# ------------------------------------------------
# Close NerdTree on quiting
# ------------------------------------------------
def CloseNerdTreeOnQuit(): void
    if winnr('$') == 2 && exists("t:NERDTreeBufName") == 1
        execute "NERDTreeClose"
    endif
enddef

augroup CloseOnExit
    autocmd!
    autocmd QuitPre * call CloseNerdTreeOnQuit()
augroup END

# ------------------------------------------------
# Open NerdTree automatically
# ------------------------------------------------
def StartNerdTree(): void
    if &columns > 88 && g:nerdtree_is_open == false
        execute "silent normal! :ToggleNerdTree\<cr>"
    endif
enddef
autocmd VimEnter * ++once call StartNerdTree()

# ------------------------------------------------
# Move between NerdTree and the current file
# ------------------------------------------------
def GoToNerdTreeWindow(): void
    execute "silent normal! :NERDTreeRefreshRoot\<cr>"
    call feedkeys("\<C-w>w", "n")
enddef
command! -nargs=0 GoToNerdTreeWindow call GoToNerdTreeWindow()

# ------------------------------------------------
# Switch buffer when it's not on nerdtree buffer
# ------------------------------------------------
def SwitchToBuffer(): void
    if bufname() !~ "NERD_tree_"
        call feedkeys("\<C-6>", "n")
    endif
enddef
command! -nargs=0 SwitchToBuffer call SwitchToBuffer()

# ------------------------------------------------
# Only close when out of nerdtree
# ------------------------------------------------
def CloseSaving(): void
    if bufname() !~ "NERD_tree_"
        call feedkeys("ZZ", "n")
    endif
enddef
command! -nargs=0 CloseSaving call CloseSaving()

# ------------------------------------------------
# Only close and save when out of nerdtree
# ------------------------------------------------
def CloseNotSaving(): void
    if bufname() !~ "NERD_tree_"
        call feedkeys("ZQ", "n")
    endif
enddef
command! -nargs=0 CloseNotSaving call CloseNotSaving()


# ------------------------------------------------
# Remove abbreviations extra space.
# ------------------------------------------------
export def Wrapper(input: string): string
    call feedkeys("\<BS>", "n")
    return input
enddef


# ------------------------------------------------
# Compile functions
# ------------------------------------------------
defcompile
