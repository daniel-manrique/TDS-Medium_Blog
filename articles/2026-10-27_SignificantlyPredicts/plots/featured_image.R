# Run from the article folder: Rscript plots/featured_image.R [out.png]
# Featured image: the 998 real participants (age and emotion recognition), coloured by diagnostic group,
# with the pooled line the paper shows (black, dashed) and one line per group.
suppressMessages({library(ggplot2); library(readxl); library(dplyr)})

args <- commandArgs(trailingOnly = TRUE)
out  <- if (length(args) >= 1) args[1] else "plots/featured_image.png"

dx_cols <- c(HC = "#009E73", SCC = "#56B4E9", MCI = "#E69F00", AD = "#D55E00", bvFTD = "#CC79A7")
mini <- read_excel("data/Base.xlsx") |>
  transmute(dx = factor(diagnosis_specify, levels = c(1, 4, 5, 2, 3), labels = names(dx_cols)),
            age = Edad_procesada, fer = mini_sea_fer)

set.seed(1)
p <- ggplot(mini, aes(age, fer, colour = dx)) +
  geom_jitter(width = 0.4, height = 0.25, alpha = 0.55, size = 2.6) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.6) +
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, colour = "black", linetype = "dashed", linewidth = 1.8) +
  scale_colour_manual(values = dx_cols) +
  theme_void() +
  theme(legend.position = "none", plot.background = element_rect(fill = "white", colour = NA),
        plot.margin = margin(30, 30, 30, 30))

ggsave(out, p, width = 16, height = 9, dpi = 150, bg = "white")
