# RStudio shortcuts worth memorizing

These are the Windows/Linux shortcuts. On macOS, use `Cmd` in place of `Ctrl` and `Option` in place of `Alt` where appropriate. If you forget a shortcut, press `Alt+Shift+K` to open RStudio's shortcut reference.

## The everyday essentials

| Shortcut | What it does |
|---|---|
| `Ctrl+Enter` | Run the current line or selected code |
| `Alt+-` | Insert the assignment arrow `<-` |
| `Ctrl+Shift+M` | Insert the native pipe `|>` |
| `Ctrl+S` | Save the current script |
| `Ctrl+Z` / `Ctrl+Shift+Z` | Undo / redo |
| `Ctrl+F` | Find text in the current file |
| `Ctrl+H` | Find and replace |
| `Tab` | Autocomplete a function, object, or file name |
| `F1` | Open help for the function under the cursor |

Select several lines before pressing `Ctrl+Enter` to run them together. This is usually safer than sending an entire script while learning.

## Moving around RStudio

| Shortcut | What it does |
|---|---|
| `Ctrl+1` | Move focus to the Source editor |
| `Ctrl+2` | Move focus to the Console |
| `Ctrl+L` | Clear the visible Console text |
| `Ctrl+Shift+F10` | Restart the R session |
| `Esc` | Interrupt a running command |
| `Up` in the Console | Recall an earlier command |
| `Ctrl+PageUp` / `Ctrl+PageDown` | Move between open source tabs |
| `Ctrl+Shift+N` | Create a new R script |
| `Ctrl+O` | Open a file |

Clearing the Console with `Ctrl+L` does not delete objects. Restarting R with `Ctrl+Shift+F10` does clear the current session, so use it when you want to check that a script works from a clean start.

## Editing code quickly

| Shortcut | What it does |
|---|---|
| `Ctrl+/` | Comment or uncomment selected lines |
| `Ctrl+D` | Delete the current line or selection |
| `Alt+Up` / `Alt+Down` | Move the current line or selection up/down |
| `Shift+Alt+Up` / `Shift+Alt+Down` | Copy the current line or selection up/down |
| `Ctrl+Shift+A` | Reformat the selected code |
| `Home` / `End` | Move to the beginning/end of a line |
| `Ctrl+Home` / `Ctrl+End` | Move to the beginning/end of a file |
| `Shift+Arrow` | Select text one character at a time |
| `Ctrl+Shift+Arrow` | Select text one word at a time |

Commenting a block is useful for temporarily turning off a step while keeping it in the script. Add comments that explain why a step exists, not only what the function is called.

## Help and discovery

| Shortcut or command | What it does |
|---|---|
| `F1` | Help for the function under the cursor |
| `Tab` | Show possible completions |
| `?mean` | Open help for `mean()` |
| `??regression` | Search installed help pages |
| `example(mean)` | Run the examples from a help page |
| `Alt+Shift+K` | Show the full RStudio shortcut list |

Try `?function_name` whenever you are unsure about an argument. Read the Usage and Examples sections first.

## Plots and projects

| Action | Quick way |
|---|---|
| Show the previous plot | Use the back arrow in the Plots pane |
| Save the current plot | Plots pane → Export, or use `ggsave()` in code |
| Open the project | Double-click its `.Rproj` file |
| Find a file in the project | `Ctrl+.` and type its name |
| Render an R Markdown/Quarto document | Click **Knit** or **Render** |

For repeatable work, save plots and tables from code. The Export button is handy while learning; `ggsave()` records exactly how a figure was created.

## A small workflow to practice

1. Open the project and a script.
2. Press `Ctrl+2`, type `1 + 1`, and press Enter to try the Console.
3. Return to the script with `Ctrl+1` and run a selected line with `Ctrl+Enter`.
4. Select several lines and press `Ctrl+/` to comment them out.
5. Put the cursor on `mean`, press `F1`, and read the examples.
6. Press `Ctrl+Shift+F10`, then rerun the script from the top.

Learning these few keys will make RStudio feel much faster. The complete shortcut list is always available with `Alt+Shift+K`.
