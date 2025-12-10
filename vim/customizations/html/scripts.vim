vim9script

export def Write(method: string): string
    if method == "scaffold"
        var lines = [
            \ '<!doctype html>',
            \ '<html lang="en">',
            \ '<head>',
            \ '<meta charset="UTF-8">',
            \ '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
            \ '<title>Document</title>',
            \ '<link rel="stylesheet" href="style.css">',
            \ '</head>',
            \ '',
            \ '<body>',
            \ '<script type="module" src="script.js"></script>',
            \ '</body>',
            \ '</html>',
            \ ''
            \ ]

        return join(lines, "\n")
    endif

    if method == "table"
        var lines = [
            \ '<table>',
            \ '<thead>',
            \ '<tr>',
            \ '<th></th>',
            \ '</tr>',
            \ '</thead>',
            \ '<tbody>',
            \ '<tr>',
            \ '<td></td>',
            \ '</tr>',
            \ '</tbody>',
            \ '</table>'
        ]

        return join(lines, "\n")
    endif
    return ""
enddef

defcompile
