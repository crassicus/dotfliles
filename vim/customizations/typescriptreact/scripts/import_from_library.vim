vim9script

import "./library.vim" as lib

python3 << EOF
import vim
from forge import build_paths

def command_complete(arg_lead: str, cmd_line: str, cursor_pos: int) -> list[str]:
    paths = build_paths(vim.eval('expand("%:p")'))

    library = paths \
        .components_complete_path \
        .parent \
        .joinpath("lib")

    suggestions: list[str] = []

    for item in library.rglob("*"):
        if item.is_file():
            sug = item.relative_to(library).with_suffix("")
            suggestions.append(str(sug))

    if arg_lead:
        matches = [s for s in suggestions if s.startswith(arg_lead)]
    else:
        matches = suggestions

    return matches

EOF


python3 << EOF
def import_from_lib(*args):
    if len(args) < 1 or len(args) > 2:
        print("Usage: ImportFromLib <relative_path> [--type]")
        print("Tip: Press <Tab> to get path suggestions.")
        return

    if len(args) == 2 and args[1] not in ("--type", "-t"):
        print(f"{args[1]} is an invalid flag.")
        return

    import_from = f"@/lib/{args[0]}"
    if len(args) == 2:
        vim.command(f"call lib.ImportTypeFrom('{import_from}')")
        pass
    else:
        vim.command(f"call lib.ImportStructureFrom('{import_from}')")
        pass
EOF


def PyCommandComplete(ArgLead: string, CmdLine: string, CursorPos: number): list<string>
    var arg = ArgLead
    var cmd = CmdLine
    var pos = CursorPos

    return py3eval($'command_complete("{arg}", "{cmd}", {pos})')
enddef


autocmd FileType typescriptreact command -nargs=* -complete=customlist,PyCommandComplete ImportFromLib :python3 import_from_lib(<f-args>)
