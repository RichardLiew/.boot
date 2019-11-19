" Copyright (c) 2017 Zichoole Inc.
" All rights reserved.
"
" "Zichoole Vim Color Scheme" version 1.0
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are
" met:
"
"    * Redistributions of source code must retain the above copyright
" notice, this list of conditions and the following disclaimer.
"    * Redistributions in binary form must reproduce the above
" copyright notice, this list of conditions and the following disclaimer
" in the documentation and/or other materials provided with the
" distribution.
"    * Neither the name of Zichoole Inc. nor the names of its
" contributors may be used to endorse or promote products derived from
" this software without specific prior written permission.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
" "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
" LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
" A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
" OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
" SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
" LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
" DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
" THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
" (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
" OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"
" ---
" Author: MrForever
" E-mail: zichoole@gmail.com
" Date  : 2017-05-27 12:20:00
"
" ---
" Description:
"   Zichoole vim color scheme.
"
"************************************************************************

"************************************************************************
"
" Introduction:
"
"************************************************************************
"
"    Item                         Description
"    ---------------------------------------------------------------
"    term                         Black-white terminal
"    cterm                        Colourful terminal
"    ctermfg                      Front-ground color for cterm
"    ctermbg                      Back-ground color for cterm
"    gui                          Gvim terminal
"    guifg                        Front-ground color for gvim
"    guibg                        Back-ground color for gvim
"
"************************************************************************

"************************************************************************
"
" Safety Colors:
"
"************************************************************************
"
"    Number                       Color
"    ---------------------------------------------------------------
"    0                            Black
"    1                            DarkBlue
"    2                            DarkGreen
"    3                            DarkCyan
"    4                            DarkRed
"    5                            DarkMagenta
"    6                            Brown, DarkYellow
"    7                            LightGray, LightGrey, Gray, Grey
"    8                            DarkGray, DarkGrey
"    9                            Blue, LightBlue
"    10                           Green, LightGreen
"    11                           Cyan, LightCyan
"    12                           Red, LightRed
"    13                           Magenta, LightMagenta
"    14                           Yellow, LightYellow
"    15                           White
"
"************************************************************************

"************************************************************************
"
" Descriptions:
"
"************************************************************************
"
"    Global Options               Description
"    ---------------------------------------------------------------
"    Normal                       Normal
"
"************************************************************************
"
"    Status Line Options          Description
"    ---------------------------------------------------------------
"    StatusLine                   Status line
"    StatusLineNC                 Not current status line
"    ErrorMsg                     Error messages
"    WarningMsg                   Warning messages
"    ModeMsg                      Current mode
"    MoreMsg                      Other messages
"    Question                     Questions for users
"    Error                        Error
"
"************************************************************************
"
"    Text Search Options          Description
"    ---------------------------------------------------------------
"    IncSearch                    Matched string of inc-search
"    Search                       Matched string
"
"************************************************************************
"
"    Pop Menu Options             Description
"    ---------------------------------------------------------------
"    Pmenu                        Pop menu
"    Tooltip                      Unknown
"    WildMenu                     Unknown
"    PmenuSel                     Current option of menu
"    PmenuSbar                    Scrollbar
"    Scrollbar                    Unknown
"    PmenuThumb                   PmenuThumb
"
"************************************************************************
"
"    Window Frame Options         Description
"    ---------------------------------------------------------------
"    VertSplit                    Edge of vertical window
"    LineNr                       Line number
"    Cursor                       Cursor
"    iCursor                      Unknown
"    CursorIM                     Unknown
"    CursorLine                   Line of cursor
"    CursorColumn                 Column of cursor
"    ColorColumn                  Ruler
"    NonText                      Hidden text
"    Visual                       Visual
"    VisualNOS                    Unknown
"
"************************************************************************
"
"    Diff Mode Options            Description
"    ---------------------------------------------------------------
"    DiffAdd                      Add line during diff mode
"    DiffChange                   Change line during diff mode
"    DiffDelete                   Delete line during diff mode
"    DiffText                     Insert text during diff mode
"
"************************************************************************
"
"    C/C++ Syntax Options         Description
"    ---------------------------------------------------------------
"    Comment                      Notes
"    PreProc                      Preprocess
"    Type                         Data type
"    Constant                     Constant variables
"    Statement                    Statement
"    Special                      Special character in string
"    String                       String
"    CppString                    String of C/C++
"    Number                       Number
"    Identifier                   Identifier
"    Todo                         Labels of TODO, HACK, FIXME
"
"************************************************************************
"
"    Browse Options               Description
"    ---------------------------------------------------------------
"    browseSynopsis               Browse synopsis
"    browseCurDir                 Browse current directory
"    favoriteDirectory            Favorite directory
"    browseDirectory              Browse directory
"    browseSuffixInfo             Browse suffixInfo
"    browseSortBy                 Browse sort by condition
"    browseFilter                 Browse filter
"    browseFiletime               Browse filetime
"    browseSuffixes               Browse suffixes
"
"************************************************************************
"
"    Taglist Options              Description
"    ---------------------------------------------------------------
"    TagListComment               TagList comment
"    TagListFileName              TagList filename
"    TagListTitle                 TagList title
"    TagListTagScope              TagList tagscope
"    TagListTagName               TagList tagname
"    Tag                          Tag
"
"************************************************************************
"
"    Other Options                Description
"    ---------------------------------------------------------------
"    Directory                    Directory
"    Folded                       Folded
"    FoldColumn                   FoldColumn
"    Underlined                   Underlined
"    Title                        Title
"    Ignore                       Ignore
"    SpecialKey                   Unknown
"
"************************************************************************

"************************************************************************
"
" Colorscheme settings:
"
"************************************************************************
" Global Options:
set background=dark
if version > 580
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="zichoole"
"************************************************************************

"--------------------------------------------------------------------------------------------------------------------------------------------------------------
" Status Line Options:
highlight Normal               cterm=NONE                ctermfg=white      ctermbg=black         gui=NONE          guifg=NONE              guibg=NONE
highlight StatusLine           cterm=bold,reverse        ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=black             guibg=#c2bfa5
highlight StatusLineNC         cterm=reverse             ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=grey50            guibg=#c2bfa5
highlight ErrorMsg             cterm=bold                ctermfg=7          ctermbg=1             gui=NONE          guifg=NONE              guibg=NONE
highlight WarningMsg           cterm=NONE                ctermfg=1          ctermbg=NONE          gui=NONE          guifg=salmon            guibg=NONE
highlight ModeMsg              cterm=NONE                ctermfg=brown      ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight MoreMsg              cterm=NONE                ctermfg=darkgreen  ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight Question             cterm=NONE                ctermfg=green      ctermbg=NONE          gui=NONE          guifg=springgreen       guibg=NONE
highlight Error                cterm=bold                ctermfg=7          ctermbg=1             gui=NONE          guifg=NONE              guibg=NONE
"--------------------------------------------------------------------------------------------------------------------------------------------------------------

"--------------------------------------------------------------------------------------------------------------------------------------------------------------
" Text Search Options:
highlight IncSearch            cterm=NONE                ctermfg=yellow     ctermbg=green         gui=NONE          guifg=slategrey         guibg=khaki
highlight Search               cterm=NONE                ctermfg=black      ctermbg=yellow        gui=NONE          guifg=wheat             guibg=peru
"--------------------------------------------------------------------------------------------------------------------------------------------------------------

"--------------------------------------------------------------------------------------------------------------------------------------------------------------
" Pop Menu Options:
highlight Pmenu                cterm=NONE                ctermfg=NONE       ctermbg=brown         gui=NONE          guifg=NONE              guibg=NONE
highlight PmenuSel             cterm=NONE                ctermfg=NONE       ctermbg=red           gui=NONE          guifg=NONE              guibg=NONE
highlight PmenuSbar            cterm=NONE                ctermfg=NONE       ctermbg=green         gui=NONE          guifg=NONE              guibg=NONE
highlight PmenuThumb           cterm=NONE                ctermfg=NONE       ctermbg=yellow        gui=NONE          guifg=NONE              guibg=NONE
highlight WildMenu             cterm=NONE                ctermfg=0          ctermbg=3             gui=NONE          guifg=NONE              guibg=NONE
highlight Scrollbar            cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight Tooltip              cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
"--------------------------------------------------------------------------------------------------------------------------------------------------------------

"--------------------------------------------------------------------------------------------------------------------------------------------------------------
"Window Frame Options:
highlight VertSplit            cterm=reverse             ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=grey50            guibg=#c2bfa5
highlight LineNr               cterm=NONE                ctermfg=3          ctermbg=NONE          gui=NONE          guifg=yellow            guibg=darkred
highlight Cursor               cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=slategrey         guibg=khaki
highlight iCursor              cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight CursorIM             cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight CursorLine           cterm=NONE                ctermfg=NONE       ctermbg=237           gui=NONE          guifg=NONE              guibg=NONE
highlight CursorColumn         cterm=NONE                ctermfg=NONE       ctermbg=237           gui=NONE          guifg=NONE              guibg=NONE
highlight ColorColumn          cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight NonText              cterm=bold                ctermfg=darkblue   ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight Visual               cterm=reverse             ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=khaki             guibg=olivedrab
highlight VisualNOS            cterm=bold,underline      ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
"--------------------------------------------------------------------------------------------------------------------------------------------------------------

"--------------------------------------------------------------------------------------------------------------------------------------------------------------
" Diff Mode Options:
highlight DiffAdd              cterm=NONE                ctermfg=NONE       ctermbg=4             gui=NONE          guifg=NONE              guibg=NONE
highlight DiffChange           cterm=NONE                ctermfg=NONE       ctermbg=5             gui=NONE          guifg=NONE              guibg=NONE
highlight DiffDelete           cterm=bold                ctermfg=4          ctermbg=6             gui=NONE          guifg=NONE              guibg=NONE
highlight DiffText             cterm=bold                ctermfg=NONE       ctermbg=1             gui=NONE          guifg=NONE              guibg=NONE
"--------------------------------------------------------------------------------------------------------------------------------------------------------------

"--------------------------------------------------------------------------------------------------------------------------------------------------------------
" C/C++ Syntax Options:
highlight Comment              cterm=NONE                ctermfg=darkcyan   ctermbg=NONE          gui=NONE          guifg=goldenrod         guibg=NONE
highlight PreProc              cterm=NONE                ctermfg=5          ctermbg=NONE          gui=NONE          guifg=#ffa0a0           guibg=NONE
highlight Type                 cterm=NONE                ctermfg=2          ctermbg=NONE          gui=NONE          guifg=darkkhaki         guibg=NONE
highlight Constant             cterm=NONE                ctermfg=brown      ctermbg=NONE          gui=NONE          guifg=#ffa0a0           guibg=NONE
highlight Statement            cterm=NONE                ctermfg=3          ctermbg=NONE          gui=NONE          guifg=khaki             guibg=NONE
highlight Special              cterm=NONE                ctermfg=5          ctermbg=NONE          gui=NONE          guifg=navajowhite       guibg=NONE
highlight SpecialKey           cterm=NONE                ctermfg=darkgreen  ctermbg=NONE          gui=NONE          guifg=yellowgreen       guibg=NONE
highlight String               cterm=NONE                ctermfg=brown      ctermbg=NONE          gui=NONE          guifg=blue              guibg=NONE
highlight CppString            cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight Number               cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight Identifier           cterm=NONE                ctermfg=6          ctermbg=NONE          gui=NONE          guifg=palegreen         guibg=NONE
highlight Todo                 cterm=NONE                ctermfg=black      ctermbg=green         gui=NONE          guifg=yellow            guibg=#003300
"--------------------------------------------------------------------------------------------------------------------------------------------------------------

"--------------------------------------------------------------------------------------------------------------------------------------------------------------
" Browse Options:
highlight browseSynopsis       cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight browseCurDir         cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight favoriteDirectory    cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight browseDirectory      cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight browseSuffixInfo     cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight browseSortBy         cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight browseFilter         cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight browseFiletime       cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight browseSuffixes       cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
"--------------------------------------------------------------------------------------------------------------------------------------------------------------

"--------------------------------------------------------------------------------------------------------------------------------------------------------------
" Taglist Options:
highlight TagListComment       cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight TagListFileName      cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight TagListTitle         cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight TagListTagScope      cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight TagListTagName       cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight Tag                  cterm=NONE                ctermfg=NONE       ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
"--------------------------------------------------------------------------------------------------------------------------------------------------------------

"--------------------------------------------------------------------------------------------------------------------------------------------------------------
" Other Options:
highlight Directory            cterm=NONE                ctermfg=darkcyan   ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight Folded               cterm=NONE                ctermfg=darkgrey   ctermbg=NONE          gui=NONE          guifg=gold              guibg=darkred
highlight FoldColumn           cterm=NONE                ctermfg=darkgrey   ctermbg=NONE          gui=NONE          guifg=tan               guibg=grey30
highlight Underlined           cterm=underline           ctermfg=5          ctermbg=NONE          gui=NONE          guifg=NONE              guibg=NONE
highlight Title                cterm=NONE                ctermfg=5          ctermbg=NONE          gui=NONE          guifg=indianred         guibg=NONE
highlight Ignore               cterm=NONE                ctermfg=darkgrey   ctermbg=NONE          gui=NONE          guifg=grey40            guibg=NONE
"--------------------------------------------------------------------------------------------------------------------------------------------------------------
