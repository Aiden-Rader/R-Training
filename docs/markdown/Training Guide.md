# A guide to R and RStudio

This guide follows the path through R that I took in my classes: first learning R itself, then organizing, cleaning, summarizing, plotting, and analyzing data, and finally exploring reliability models. The examples use small, generic measurements so the same ideas can transfer to any field.

## 1. R and RStudio

R is the language that runs calculations and analyses. RStudio is an editor that makes it easier to write R scripts, inspect data, see plots, and organize a project. In RStudio, an `.R` script lives in the Source pane; the Console runs commands. Save work in a script so you can rerun and explain it later. Run a selected line with **Ctrl+Enter**.

Start by making an RStudio Project in a new folder for one study. Open its `.Rproj` file whenever you work on that study. Keep the original data in `data_raw/`, derived data in `data_clean/`, scripts in `scripts/`, and figures or tables in `outputs/`. Project-relative paths such as `"data_raw/measurements.csv"` work on another computer too. Avoid `setwd()` and personal absolute paths. Do not edit the only copy of the raw data.

The Console is a scratchpad; a saved script is the recipe. Restarting R clears the current session, which is useful for checking that a script really contains the steps it needs. You usually do not need `rm(list = ls())`; it can erase objects unexpectedly. R is case-sensitive, uses `#` for comments, and counts vector positions starting at 1. Use `<-` to assign a value.

```r
# A comment explains why a step is here.
measurements <- c(4, 7, 5, 8)
mean(measurements)
sd(measurements)
measurements[1]                 # first value
measurements[measurements > 5] # values meeting a condition
```

R has useful built-in help: `?mean`, `?read.csv`, and `help.search("t test")`. Use `str(data)` and `summary(data)` to get oriented before analyzing anything.

### How variables and objects work

Everything you create in R is an object with a name. A name can point to a single value, a vector, a data frame, a function, or a model result. Assignment stores the result on the right in the name on the left. R does not require you to declare a type first, but each object has a type that affects what operations mean.

```r
number <- 12                 # one numeric value
label <- "control"           # one character value
is_valid <- TRUE              # one logical value
values <- c(2, 4, 6, 8)      # a numeric vector
values * 2                   # vectorized arithmetic
values[values > 4]           # logical filtering

class(values)
length(values)
exists("values")
ls()                         # objects currently in the workspace
```

R commonly uses numeric, character, logical, factor, Date, list, matrix, and data-frame objects. A data frame is a collection of equal-length columns, so `df$score` is a vector and `df[1, ]` is a one-row data frame. Functions return objects too: `fit <- lm(...)` stores a model that can later be passed to `summary(fit)`, `coef(fit)`, or `plot(fit)`. Use clear names and avoid relying on objects left over from an earlier session.

RStudio's Environment pane shows objects, the History pane shows commands, the Files pane shows project files, and the Plots pane holds graphics. The Console is useful for quick experiments; scripts and Quarto or R Markdown documents are better for reproducible work. Restart R from the Session menu when you want to check that a script runs from a clean session.

## 2. Packages and data frames

Base R already has vectors, data frames, statistical tests, plots, and models. Packages add tools. Install a package once on your computer; load it with `library()` each new session. `install.packages()` belongs in the Console or a setup step, not repeatedly inside analysis code.

```r
install.packages(c("tidyverse", "readxl", "haven")) # run once
library(tidyverse) # readr, dplyr, tidyr, ggplot2, and more
library(readxl)    # Excel files
library(haven)     # SPSS and SAS files
```

Useful packages to learn over time include `dplyr` and `tidyr` for data manipulation, `ggplot2` for graphics, `readr` and `readxl` for imports, `haven` for SAS/SPSS files, `lubridate` for dates, `janitor` for cleaning column names, `broom` for turning model output into tables, `modelr` for model workflows, `lme4` for mixed-effects models, `MASS` for several classical models and transformations, `survival` for censored time-to-event data, and `swirl` for interactive lessons. Install with `install.packages()` once, then load with `library()` when needed. `package::function()` calls one function without attaching the whole package, such as `readr::read_csv()`.

A data frame is a rectangular table: each row is an observation and each column is a variable. Keep one kind of observation per row. Record identifiers and conditions in their own columns. Categorical variables such as group or batch are usually factors; measurements such as length and counts should be numeric.

```r
df <- data.frame(
  person_id = c("P01", "P02", "P03", "P04"),
  group = factor(c("A", "A", "B", "B")),
  week = c(1, 2, 1, 2),
  score = c(6, 8, 5, 11),
  minutes = c(100, 120, 90, 110)
)

nrow(df)             # rows
ncol(df)             # columns
names(df)            # column names
head(df)             # first observations
str(df)              # column types and structure
summary(df)          # quick summaries
df$score             # a column
df[1:2, ]            # first two rows; blank after comma means all columns
```

R also supports `matrix()`, `list()`, `cbind()`, and `rbind()`. Use a data frame for most datasets: different columns can hold different types. Use `expand.grid()` to construct combinations in a planned design. `set.seed()` makes simulated examples repeatable; it does not make fake data real evidence.

## 3. Import and check data

Use a project-relative path, check that the file is the one you meant to open, then inspect its dimensions, names, types, and missing values. CSV and Excel are common data formats. Preserve IDs as text when leading zeroes or letter codes matter.

```r
df <- read_csv("data_raw/measurements.csv")
# For an Excel workbook: df <- read_excel("data_raw/measurements.xlsx", sheet = 1)
# For SPSS: df <- read_sav("data_raw/measurements.sav")       # package haven

dim(df)
names(df)
glimpse(df)
colSums(is.na(df))
```

Base R also offers `read.csv()` and `write.csv()`. The matching tidyverse helpers are `readr::read_csv()` and `readr::write_csv()`. Inspect column types after import: dates, IDs, categorical labels, and missing-value codes can be misread. Do not convert every ID to a number simply because it looks numeric.

## 4. Clean and summarize with dplyr

The pipe `|>` (or `%>%`) passes a result to the next step. The main dplyr verbs are `filter()` for rows, `select()` for columns, `mutate()` for new columns, `arrange()` for sorting, and `group_by()` plus `summarise()` for group summaries. `count()` gives group frequencies. `left_join()` adds matching columns while retaining rows from the left table; check whether the join keys are unique first.

```r
df_clean <- df |>
  filter(!is.na(score), minutes > 0) |>
  mutate(score_per_minute = score / minutes)

group_summary <- df_clean |>
  group_by(group, week) |>
  summarise(
    n_people = n_distinct(person_id),
    mean_score = mean(score),
    sd_score = sd(score),
    .groups = "drop"
  )
```

`NA` means unknown or unrecorded; it is not zero. `mean(x)` returns `NA` if values are missing; `mean(x, na.rm = TRUE)` ignores them. Decide why a value is missing before choosing what to do. Keep an audit trail of excluded observations and reasons. Check ranges, impossible values, duplicate IDs, group sizes, and whether joins unexpectedly add or drop rows.

Repeated observations from the same person, machine, site, or batch are often correlated. They are not automatically independent observations. Identify the experimental unit and summarize at that level for a simple analysis, or use a repeated-measures or mixed-effects model that represents the hierarchy. Ask a statistician about the design before choosing a test.

## 5. Plot before testing

Plots help reveal outliers, uneven group sizes, skew, and changes within subjects. Show individual observations when possible. A bar with only a mean can hide the data distribution.

```r
  ggplot(df_clean, aes(group, score, color = group)) +
  geom_point(position = position_jitter(width = 0.08), alpha = 0.8) +
  labs(x = "Group", y = "Score") +
  theme_minimal()
```

Other useful starting plots include `geom_boxplot()`, `geom_histogram()`, and `geom_line()` for repeated measurements connected by ID. Save a named plot with `ggsave("outputs/scores.png", width = 7, height = 5)`. Label units, groups, time points, and the number of observations.

### Exporting cleaned data and results

Keep the raw import unchanged. After checking and cleaning it, save a separate file with a clear name. CSV is portable and easy to inspect; RDS preserves R column types, factors, dates, and list columns. Export summaries and model results separately so a table is not confused with the row-level data.

```r
dir.create("outputs", showWarnings = FALSE)

# Portable text file for use in many programs.
readr::write_csv(df_clean, "outputs/measurements_clean.csv")

# R-specific file that preserves the object exactly.
saveRDS(df_clean, "outputs/measurements_clean.rds")
df_again <- readRDS("outputs/measurements_clean.rds")

# A summary table and a fitted model's coefficients.
readr::write_csv(group_summary, "outputs/group_summary.csv")
fit <- lm(score ~ group + week, data = df_clean)
coefficients <- broom::tidy(fit)
readr::write_csv(coefficients, "outputs/model_coefficients.csv")
```

For graphics, `ggsave()` can write PNG, PDF, SVG, or other formats based on the filename. Set the width, height, and resolution deliberately when a figure will be shared. For a complete report, use Quarto or R Markdown so the code, tables, figures, and explanation are generated together. Save `sessionInfo()` with important results to record the R version and package versions.

## 6. Statistical tests and models

Start with the question, the outcome type, the design, and the unit that was independently sampled. Inspect the data, state the assumptions, choose a method, and report an estimate with uncertainty. A p-value is one piece of evidence; it is not a measure of importance.

### Describe the data

For numeric values, use `mean()`, `median()`, `sd()`, `IQR()`, `quantile()`, and `range()`. For categories, use `table()` and `prop.table()`. Use `count()` and `summarise()` to calculate these by group. Report the number of observations and the amount of missing data.

```r
mean(x, na.rm = TRUE)
median(x, na.rm = TRUE)
sd(x, na.rm = TRUE)
quantile(x, c(.25, .5, .75), na.rm = TRUE)
table(group, useNA = "ifany")
```

### Normality, shape, and transformations

Normality is a property of a variable or, more often, a model's residuals. Inspect a histogram, density plot, boxplot, and Q-Q plot before relying on a normal model. `qqnorm(x); qqline(x)` is a useful visual check. `shapiro.test(x)` tests normality, but with large samples it can flag tiny departures and with small samples it has little power. Do not use it as the only decision rule.

Positive, right-skewed measurements may be easier to model after `log(x)`, `log1p(x)` when zeros are present, or `sqrt(x)`. Recheck the plot and explain coefficients on the transformed scale. `MASS::boxcox()` can help explore a power transformation. A log-normal model describes a variable whose logarithm is approximately normal.

```r
hist(x)
qqnorm(x); qqline(x)
shapiro.test(x)
hist(log(x))       # only when x is strictly positive
```

### Probability distributions

R uses a consistent naming system: `d` gives density or probability mass, `p` cumulative probability, `q` a quantile, and `r` random values. Common choices include normal (`dnorm`), log-normal (`dlnorm`), uniform (`dunif`), exponential (`dexp`), gamma (`dgamma`), binomial (`dbinom`), Poisson (`dpois`), and negative binomial (`dnbinom`). Choose a distribution that matches the outcome: counts are not continuous normal measurements, and proportions are bounded.

### Comparing groups

Use `t.test(y ~ group)` for two independent numeric groups; R's default is Welch's test. Use `t.test(before, after, paired = TRUE)` for matched observations, pairing by an ID first. `wilcox.test()` provides rank-based alternatives. For three or more groups, use `aov()`, `TukeyHSD()`, `oneway.test(..., var.equal = FALSE)`, or `kruskal.test()` as appropriate. For repeated measurements, use a repeated-measures or mixed-effects model rather than treating every row as independent.

### Proportions and categories

Use `prop.test()` for proportions and `binom.test()` for an exact binomial interval or test. Use `chisq.test()` for contingency tables when expected counts are adequate, and `fisher.test()` for small tables. Inspect the table before testing.

### Correlation and regression

`cor.test(x, y, method = "pearson")` measures linear association; `method = "spearman"` uses ranks. `lm()` models a numeric outcome while adjusting for predictors. Check linearity, constant residual variance, approximate residual normality, influential observations, and collinearity with residual plots and tools such as `car::vif()`.

### Generalized and hierarchical models

Use `glm()` with `family = binomial` for binary outcomes and `family = poisson` for counts. Include an exposure offset for rates and check overdispersion; `MASS::glm.nb()` is a negative-binomial alternative. Use `lme4::lmer()` or `lme4::glmer()` when observations are repeated, nested, or clustered. Exponentiated logistic coefficients are odds ratios; exponentiated Poisson coefficients are rate ratios.

### Resampling and multiple comparisons

Bootstrap confidence intervals and permutation tests are useful when assumptions are doubtful, but resample the independent unit rather than arbitrary rows. Adjust families of p-values with `p.adjust(p_values, method = "BH")` or Holm. Report estimates, confidence intervals, sample sizes, missing-data rules, assumptions, and adjusted p-values when applicable.

R's built-in functions include `t.test()`, `prop.test()`, `chisq.test()`, `cor.test()`, `aov()`, and `lm()`. The matching `d`, `p`, `q`, and `r` distribution functions calculate density/probability mass, cumulative probability, quantiles, and random draws. For example, `dnorm()`, `pnorm()`, `qnorm()`, and `rnorm()` work with a normal distribution; `dbinom()` and `pbinom()` work with a binomial distribution.

```r
# Two independent groups: Welch's t test is the default in R.
t.test(score ~ group, data = df_clean)

# Same subjects measured twice: pair by subject ID, then use paired = TRUE.
# Never assume two separately sorted vectors line up by participant.

# Continuous outcome with categorical and numeric predictors.
fit <- lm(score ~ group + week, data = df_clean)
summary(fit)
confint(fit)
plot(fit) # residual diagnostic plots
```

For three or more independent groups, `aov(outcome ~ group, data = ...)` fits a classical one-way ANOVA; `summary()` reports the test and `TukeyHSD()` follows up pairwise comparisons. `oneway.test(..., var.equal = FALSE)` is a Welch alternative when group variances differ. These procedures require assumptions and a design that matches the test. Check plots and residual diagnostics, report effect estimates and confidence intervals, and account for multiple comparisons when relevant. A small p-value alone does not establish practical importance or causation.

Repeated times, nested cells, count outcomes, batch effects, and missingness may need a more suitable model than a basic t test or `lm()`. Pick the model from the experimental unit, outcome type, and design—not just the dataset's shape or which test is significant. Talk to a statistician for confirmatory work.

## 7. Further along: reliability engineering (not nessassary)

A reliability extension adds probability calculations, reliability of components and systems, probability plots, model fitting, numerical integration, and `uniroot()`. These make a useful optional extension after the core statistics lessons. The same foundation—vectors, functions, plots, and models—supports each topic.

For a Weibull lifetime with shape `beta` and scale `eta`, the survival reliability is `R(t) = exp(-(t / eta)^beta)`. In R, `pweibull(t, shape = beta, scale = eta, lower.tail = FALSE)` calculates this survival probability. `qweibull()` gives quantiles and `rweibull()` simulates lifetimes. Exponential, normal, log-normal, and gamma distributions have the same `p`/`q`/`r` pattern. `integrate()` integrates a function numerically; `uniroot()` solves a one-variable equation over a bracket.

```r
beta <- 1.6
eta <- 15
t <- 8
reliability <- pweibull(t, shape = beta, scale = eta, lower.tail = FALSE)

# Three identical independent components in parallel:
system_reliability <- 1 - (1 - reliability)^3

reliability_function <- function(time) {
  pweibull(time, shape = beta, scale = eta, lower.tail = FALSE)
}
mean_lifetime <- integrate(reliability_function, lower = 0, upper = Inf)$value
```

Probability plots can estimate distribution parameters using a fitted line. Treat that as a teaching approximation. For time-to-event data, a unit still functioning at the end of observation is right-censored: its failure time is unknown, but its observed survival time is informative. Dropping censored units and fitting only failures can bias the result. Install `survival` once with `install.packages("survival")`. It represents this with `Surv(time, event)` and supports models such as `survreg()`. Get help with `?survival::Surv` and `?survival::survreg`; make sure the chosen model and parameter interpretation suit the question. Record analysis choices and R/package versions (for example, `sessionInfo()`) alongside results so the work can be repeated.

Reliability work also asks how components combine. For independent components in series, all must work, so multiply reliabilities. For independent parallel components, at least one must work, so `1 - prod(1 - R)`. For more complex logic, enumerate component states with `expand.grid()` and sum the probabilities of working states. Independence is an assumption, not a default fact.

## 8. A short teaching plan

1. Open RStudio and run the first short basics example. Make a vector and calculate its mean.
2. Build a tiny data frame, inspect it, and create a new column.
3. Run the short analysis example with the built-in `iris` data. Read the plot before interpreting the model.
4. Recreate the same workflow with a file of your own, checking its structure and missing values first.
5. Continue to the statistical and Reliability Engineering sections when the basic workflow feels comfortable.
6. Continue with the Weibull and censoring material as an optional next chapter.

The optional `01_swirl_start.R` script launches interactive lessons in the Console. Run it after opening the project, choose a beginner course, and follow the prompts. `swirl` teaches by asking for commands and checking the answers; type `bye()` when finished.

The two small examples use built-in or simulated values. They are for learning syntax and workflow, not for making claims about a real study.


