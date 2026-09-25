# 01_swirl_start.R
# Interactive R lessons in the Console. Run this file from RStudio.

# Install once if needed. You can also run this command manually in the Console.
if (!requireNamespace("swirl", quietly = TRUE)) {
  install.packages("swirl")
}

library(swirl)

# Follow the prompts to choose a course and lesson.
# Type bye() in the swirl prompt when you want to stop.
swirl()
