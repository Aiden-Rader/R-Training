# RStudio Training

This is a small, self-contained RStudio practice project. Open **RStudio Training.Rproj** before running anything. Opening the project makes the project folder the starting point for relative paths, so the scripts can use paths such as `data/practice_measurements.csv` on this computer or another one.

## What is where

| Location | Purpose |
|---|---|
| `docs/markdown/Training Guide.md` | Main beginner-to-intermediate guide |
| `docs/markdown/RStudio Shortcuts.md` | Quick keyboard reference |
| `docs/markdown/Reproducible Reports and Obsidian.md` | R Markdown, Obsidian, seeds, and Git tutorial |
| `docs/html/` | Optional HTML copies of the documents |
| `scripts/basics/` | Short scripts for learning R syntax and analysis |
| `scripts/swirl-interactive/` | Interactive `swirl` lesson launcher |
| `scripts/data-workflow/` | Import, clean, plot, and export practice |
| `reports/` | R Markdown reports that combine text, code, tables, and plots |
| `data/` | Small practice data files supplied with this project |
| `outputs/` | Cleaned data, tables, and plots created by scripts |

The file in `data/` is simulated practice data. It is safe to edit a copy while learning. For real work, keep an untouched raw file and write cleaned data and results to `outputs/`.

## Suggested order

1. Read the first sections of the training guide.
2. Run `scripts/basics/01_simple_basics.R` one section at a time.
3. Run `scripts/basics/02_simple_analysis.R` and inspect the plot and model.
4. Run `scripts/data-workflow/03_import_clean_export.R` to practice a complete data workflow.
5. Run `scripts/swirl-interactive/01_swirl_start.R` for interactive exercises.
6. Use the shortcuts sheet while working, then return to the statistics and reliability sections of the guide.
7. Open `reports/example_report.Rmd`, click **Knit**, and read the generated report in Obsidian.

## Installing packages

Install a package once from the Console, then load it in scripts when needed:

```r
install.packages(c("tidyverse", "broom", "swirl", "rmarkdown", "knitr"))
```

The basic examples use base R. The workflow script uses `readr`, `dplyr`, `ggplot2`, and `broom` through the `tidyverse` and related packages.

## Where exported files go

The workflow script creates `outputs/clean_measurements.csv`, `outputs/summary_by_group.csv`, and `outputs/score_plot.png`. These are derived files and can be recreated by running the script again. Do not overwrite the original file in `data/`.
