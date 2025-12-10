vim9script

export def Write(method: string): string
    if method == "scaffold"
        var lines = [
            \ '*,',
            \ '*::before,',
            \ '*::after {',
            \ 'margin: 0;',
            \ 'padding: 0;',
            \ 'box-sizing: border-box;',
            \ '}',
            \ '',
            \ ]

        return join(lines, "\n")
    endif

    if method == "property"
        var lines = [
            \ '@property --property-name {',
            \ "syntax: '<>'; /* number|length|percentage|angle|color|time */",
            \ 'inherits: false;',
            \ 'initial-value: ; /* 1 | 1rem | 1% | 1deg | teal | 1s */',
            \ '}'
            ]
        return join(lines, "\n")
    endif

    if method == "media_query"
        var lines = [
                    \ "@media (width >= px) {",
                    \ "}"
        ]
        return join(lines, "\n")
    endif

    return ""
enddef

defcompile
