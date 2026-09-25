# 01_simple_basics.R
# Run one section at a time in RStudio and predict the result first.

# Values and calculations -------------------------------------------------
scores <- c(72, 81, 68, 90, 77)
mean(scores)
sd(scores)
scores[1]
scores[scores >= 80]

# A data frame ------------------------------------------------------------
students <- data.frame(
  name = c("Ava", "Ben", "Casey", "Drew", "Emery"),
  hours_studied = c(2, 4, 1, 5, 3),
  score = scores
)

students$passed <- students$score >= 70
students
str(students)
summary(students)

# A small function --------------------------------------------------------
score_per_hour <- function(score, hours) {
  score / hours
}

students$score_per_hour <- score_per_hour(students$score, students$hours_studied)
students
