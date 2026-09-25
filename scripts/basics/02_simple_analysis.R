# 02_simple_analysis.R
# A complete, small workflow using built-in data and one simple plot.

# install dplyr only onnce
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}

# Import dplyr library (much better then regular R)
library(dplyr)

# Use the built-in iris data set. Each row is one flower measurement.
data(iris)
head(iris)
str(iris)
summary(iris)

# Base R summaries by group ----------------------------------------------
aggregate(Sepal.Length ~ Species, data = iris, FUN = mean)

# A plot ------------------------------------------------------------------
plot(iris$Sepal.Length, iris$Petal.Length,
     col = as.integer(iris$Species), pch = 19,
     xlab = "Sepal length", ylab = "Petal length",
     main = "Iris measurements")
legend("topleft", legend = levels(iris$Species),
       col = seq_along(levels(iris$Species)), pch = 19)

# A simple model ----------------------------------------------------------
fit <- lm(Petal.Length ~ Sepal.Length + Species, data = iris)
summary(fit)
confint(fit)
plot(fit)

# Optional tidyverse version ---------------------------------------------
iris |>
group_by(Species) |>
summarise(
	n = n(),
	mean_petal_length = mean(Petal.Length),
	sd_petal_length = sd(Petal.Length),
	.groups = "drop"
)
