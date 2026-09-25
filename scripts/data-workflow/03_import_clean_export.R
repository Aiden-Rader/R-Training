# 03_import_clean_export.R
# Run from the RStudio project root.

required_packages <- c("readr", "dplyr", "ggplot2")
missing <- required_packages[!vapply(required_packages, requireNamespace,
                                    logical(1), quietly = TRUE)]
if (length(missing)) {
  stop("Install these packages first: ", paste(missing, collapse = ", "))
}

library(readr)
library(dplyr)
library(ggplot2)

dir.create("outputs", showWarnings = FALSE)

# Import -----------------------------------------------------------------
raw <- read_csv("data/practice_measurements.csv", show_col_types = FALSE)
print(head(raw))
print(str(raw))
print(colSums(is.na(raw)))

# Clean and create a derived variable ------------------------------------
clean <- raw |>
  filter(!is.na(score), minutes > 0) |>
  mutate(score_per_minute = score / minutes)

summary_by_group <- clean |>
  group_by(group) |>
  summarise(
    n = n(),
    mean_score = mean(score),
    sd_score = sd(score),
    .groups = "drop"
  )

# Plot -------------------------------------------------------------------
score_plot <- ggplot(clean, aes(group, score, color = group)) +
  geom_jitter(width = 0.08, height = 0, size = 2.5, show.legend = FALSE) +
  labs(title = "Practice scores by group", x = "Group", y = "Score") +
  theme_minimal()
print(score_plot)

# Export -----------------------------------------------------------------
write_csv(clean, "outputs/clean_measurements.csv")
write_csv(summary_by_group, "outputs/summary_by_group.csv")
ggsave("outputs/score_plot.png", score_plot, width = 7, height = 5, dpi = 160)

cat("Wrote cleaned data, a summary table, and a plot to outputs/.\n")
