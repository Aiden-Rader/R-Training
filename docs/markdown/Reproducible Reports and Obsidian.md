# Reproducible reports with R Markdown and Obsidian

R scripts are excellent for building and checking an analysis. R Markdown adds the explanation around the code, then runs the code and places the results into one report. A report can contain headings, normal paragraphs, equations, tables, plots, and executable R chunks.

Obsidian is a great place to keep the written notes and links between ideas. The useful division is simple:

- Keep the source report as an `.Rmd` file in the RStudio project.
- Use RStudio's **Knit** button to run the code and generate a report.
- Open the generated Markdown file in Obsidian when you want to read, annotate, or link it to other notes.
- Edit the `.Rmd` source, then render it again. Treat the generated report as an output.

Open `reports/example_report.Rmd` in RStudio. Click **Knit**, choose the Markdown output if prompted, and then open the generated `.md` file in Obsidian. The report uses built-in `iris` data, so it can run without a personal data file.

## The basic pieces of an R Markdown file

The YAML block at the top gives the report a title and output format. Text is ordinary Markdown. An R chunk starts with ```` ```{r} ```` and ends with ```` ``` ````. Code inside a chunk runs when the report is rendered.

Useful chunk options include:

```r
echo = TRUE       # show the code
message = FALSE   # hide package messages
warning = FALSE   # hide warnings in a polished report
include = FALSE   # run code but show neither code nor output
fig.width = 7     # figure width in inches
fig.height = 5    # figure height in inches
```

Use `echo = TRUE` while learning. Hide code only in a final report when the reader does not need to inspect the implementation.

## Why `set.seed()` matters

Random functions such as `runif()`, `rnorm()`, and `sample()` use a stream of pseudo-random numbers. `set.seed()` chooses the starting point of that stream. The result is still simulated, but another person can rerun the code and obtain the same example.

```r
set.seed(42)
sample(1:10, 5)

set.seed(42)
sample(1:10, 5) # exactly the same five values
```

Use a seed for simulations, examples, random train/test splits, bootstrapping, and randomized procedures. Record the seed in the script or report. A seed does not make a small or biased dataset more trustworthy; it makes a random computational step repeatable.

## Moving results into Obsidian

Obsidian reads Markdown directly. A rendered report can be linked from a larger note with a normal Markdown link such as `[analysis report](../reports/example_report.md)`. Obsidian also supports internal links, so a note can link to `[[RStudio Shortcuts]]` or `[[Training Guide]]` when those files are in the same vault.

Keep raw data, source reports, generated reports, and exported figures distinguishable. If a report contains private or identifying data, keep it out of a public Obsidian vault or public Git repository.

## Turning the project into a Git repository

Git records changes to text files, scripts, reports, and documentation. From the project root, the first setup is:

```text
git init
git add README.md docs scripts data reports
git commit -m "Start RStudio training project"
```

Add a `.gitignore` before committing generated files, private data, and RStudio's `.Rproj.user/` folder. A later update is usually:

```text
git add .
git commit -m "Add analysis example"
```

Git is especially useful here because the `.Rmd` source, data-cleaning script, and rendered report can be compared over time. Do not commit confidential data or passwords.
