# Featured image: the ring behind a pair correlation curve. Around a microglia (orange) we look at the
# neurons (grey) that fall in the 30 to 100 um band. Data: one animal at 15D.
# Run from the article folder: Rscript plots/featured_image.R
suppressMessages({library(spatstat); library(ggplot2); library(dplyr)})
set.seed(8807)

PointPatterns <- readRDS("data/PointPatterns_5x.rds")
row.names(PointPatterns) <- PointPatterns$ID
Id <- PointPatterns$ID[PointPatterns$DPI == "15D"]
Id <- Id[which.max(sapply(Id, function(i) npoints(PointPatterns$Neurons[[i]])))]
Neu <- PointPatterns$Neurons[[Id]]
Mic <- PointPatterns$Microglia[[Id]]

Dist_to <- function(X, x, y) sqrt((X$x - x)^2 + (X$y - y)^2)
N_df <- as.data.frame(Neu); M_df <- as.data.frame(Mic)

# Centre the picture on a microglia with several neurons in its 30 to 100 um ring, away from the border
Inner <- M_df[inside.owin(M_df$x, M_df$y, erosion(Window(Neu), 0.5)), ]
In_ring <- sapply(seq_len(nrow(Inner)), function(i) { d <- Dist_to(N_df, Inner$x[i], Inner$y[i]); sum(d >= 0.03 & d <= 0.10) })
C0 <- Inner[sample(which(In_ring == max(In_ring)), 1), ]
cx <- C0$x; cy <- C0$y
W_crop <- c(cx - 0.6, cx + 0.6, cy - 0.3375, cy + 0.3375)

Crop <- function(d) d[d$x > W_crop[1] & d$x < W_crop[2] & d$y > W_crop[3] & d$y < W_crop[4], ]
Nd <- Crop(N_df); Md <- Crop(M_df)

# Other rings: a few microglia, spaced out and away from the border
Cand <- Md[Md$x > W_crop[1] + 0.13 & Md$x < W_crop[2] - 0.13 & Md$y > W_crop[3] + 0.13 & Md$y < W_crop[4] - 0.13, ]
Cand <- Cand[Dist_to(Cand, cx, cy) > 0.26, ]
Cand <- Cand[sample(nrow(Cand)), ]
Centres <- data.frame(x = cx, y = cy)
for (i in seq_len(nrow(Cand))) {
  if (nrow(Centres) >= 6) break
  if (all(sqrt((Cand$x[i] - Centres$x)^2 + (Cand$y[i] - Centres$y)^2) > 0.26)) Centres <- rbind(Centres, Cand[i, c("x", "y")])
}

Ring <- function(x, y, r, n = 200) { t <- seq(0, 2 * pi, length.out = n); data.frame(x = x + r * cos(t), y = y + r * sin(t)) }
Annuli <- bind_rows(lapply(seq_len(nrow(Centres)), function(i) {
  o <- Ring(Centres$x[i], Centres$y[i], 0.10); n <- Ring(Centres$x[i], Centres$y[i], 0.03)[rev(seq_len(200)), ]
  rbind(o, n) %>% mutate(id = i)
}))

# Neurons that fall inside any ring are the ones the curve counts
InBand <- sapply(seq_len(nrow(Nd)), function(i) {
  d <- sqrt((Nd$x[i] - Centres$x)^2 + (Nd$y[i] - Centres$y)^2); any(d >= 0.03 & d <= 0.10)
})

# Arrows on the central ring: "microglia" from the lower left, "neuron" from above, and the radius r to a neuron in the ring
d0 <- Dist_to(Nd, cx, cy)
In0 <- Nd[d0 >= 0.03 & d0 <= 0.10, ]
N1 <- In0[which.max(In0$y - cy), ]                       # neuron most above: gets the "neuron" label
N2 <- In0[which.min(In0$y - cy), ]                       # neuron most below: the radius arrow goes to it
Seg <- function(from, to, a, b) { u <- to - from; u <- u / sqrt(sum(u^2))
  data.frame(x = from[1] + a * u[1], y = from[2] + a * u[2], xend = to[1] - b * u[1], yend = to[2] - b * u[2]) }
L1 <- c(cx - 0.40, cy - 0.17)
L2 <- c(N1$x - 0.09, N1$y + 0.11)
Arrows <- rbind(Seg(L1, c(cx, cy), 0.075, 0.035), Seg(L2, c(N1$x, N1$y), 0.06, 0.02))
Radius <- Seg(c(cx, cy), c(N2$x, N2$y), 0.025, 0.02)
Mid <- c((cx + N2$x) / 2, (cy + N2$y) / 2)
Labels <- data.frame(x = c(L1[1], L2[1], Mid[1] - 0.035), y = c(L1[2], L2[2], Mid[2]),
                     label = c("microglia", "neuron", "r"), col = c("#B23A1E", "#1D3557", "#1D3557"))

p <- ggplot() +
  geom_polygon(data = Annuli, aes(x, y, group = id), fill = "#2A9D8F", alpha = 0.3, colour = NA) +
  geom_point(data = Nd, aes(x, y), colour = "#5C677D", size = 3.4, alpha = 0.95, stroke = 0) +
  geom_point(data = Nd[InBand, ], aes(x, y), colour = "#1D3557", size = 5, stroke = 0) +
  geom_point(data = Md, aes(x, y), colour = "#E76F51", size = 4.5, stroke = 0) +
  geom_point(data = Centres, aes(x, y), colour = "#B23A1E", size = 7) +
  geom_segment(data = Arrows, aes(x = x, y = y, xend = xend, yend = yend), colour = "#1D3557", linewidth = 1.1,
               arrow = arrow(length = unit(0.28, "cm"), type = "closed")) +
  geom_segment(data = Radius, aes(x = x, y = y, xend = xend, yend = yend), colour = "#1D3557", linewidth = 1.1,
               arrow = arrow(length = unit(0.25, "cm"), type = "closed", ends = "both")) +
  geom_text(data = Labels, aes(x, y, label = label, colour = col), fontface = "bold", size = 9) +
  scale_colour_identity() +
  coord_equal(xlim = W_crop[1:2], ylim = W_crop[3:4], expand = FALSE) +
  theme_void() +
  theme(plot.background = element_rect(fill = "#F7F3EA", colour = NA))

ggsave("plots/featured_image.png", p, width = 16, height = 9, dpi = 200, bg = "#F7F3EA")
