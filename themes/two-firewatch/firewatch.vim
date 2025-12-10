" =============================================================================
" Filename: autoload/lightline/colorscheme/one.vim
" Author: Zoltan Dalmadi
" License: MIT License
" Last Change: 2019/09/09 22:42:48.
" =============================================================================

" Common colors
let s:blue   = [ '#896724', 255 ]
let s:green  = [ '#896724', 255 ]
let s:purple = [ '#896724', 255 ]
let s:red1   = [ '#896724', 255 ]
let s:red2   = [ '#896724', 255 ]
let s:yellow = [ '#896724', 255 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

if lightline#colorscheme#background() ==# 'light'
  " Light variant
  let s:fg    = [ '#896724', 255 ]
  let s:bg    = [ '#FAF8F5', 255 ]
  let s:gray1 = [ '#FAF8F5', 255 ]
  let s:gray2 = [ '#FAF8F5', 255 ]
  let s:gray3 = [ '#FAF8F5', 255 ]
  let s:green = [ '#FAF8F5', 255 ]

"background = "#FAF8F5"
"foreground = "#896724"

  let s:p.inactive.left   = [ [ s:bg,  s:gray3 ], [ s:bg, s:gray3 ] ]
  let s:p.inactive.middle = [ [ s:gray3, s:gray2 ] ]
  let s:p.inactive.right  = [ [ s:bg, s:gray3 ] ]
else
  " Dark variant
  let s:fg    = [ '#abb2bf', 145 ]
  let s:bg    = [ '#282c34', 235 ]
  let s:gray1 = [ '#5c6370', 241 ]
  let s:gray2 = [ '#2c323d', 235 ]
  let s:gray3 = [ '#3e4452', 240 ]

  let s:p.inactive.left   = [ [ s:gray1,  s:bg ], [ s:gray1, s:bg ] ]
  let s:p.inactive.middle = [ [ s:gray1, s:gray2 ] ]
  let s:p.inactive.right  = [ [ s:gray1, s:bg ] ]
endif

" Common
let s:p.normal.left    = [ [ s:bg, s:purple, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.normal.middle  = [ [ s:fg, s:gray2 ] ]
let s:p.normal.right   = [ [ s:bg, s:purple, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.normal.error   = [ [ s:red2, s:bg ] ]
let s:p.normal.warning = [ [ s:yellow, s:bg ] ]
let s:p.insert.right   = [ [ s:bg, s:purple, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.insert.left    = [ [ s:bg, s:purple, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.replace.right  = [ [ s:bg, s:red1, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.replace.left   = [ [ s:bg, s:red1, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.visual.right   = [ [ s:bg, s:purple, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.visual.left    = [ [ s:bg, s:purple, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.tabline.left   = [ [ s:fg, s:gray3 ] ]
let s:p.tabline.tabsel = [ [ s:bg, s:purple, 'bold' ] ]
let s:p.tabline.middle = [ [ s:gray3, s:gray2 ] ]
let s:p.tabline.right  = copy(s:p.normal.right)

let g:lightline#colorscheme#tester#palette = lightline#colorscheme#flatten(s:p)
