# Run from the article folder: Rscript plots/featured_image.R [out.png] [animal id]
# Featured image: Delaunay network of the neurons of one section, microglia as dots, and the
# longest-lived H1 loops drawn as discs that grow from their birth radius to their death radius.
suppressMessages({library(spatstat); library(TDA)})

args <- commandArgs(trailingOnly = TRUE)
out  <- if (length(args) >= 1) args[1] else "plots/featured_image.png"
id   <- if (length(args) >= 2) args[2] else "M01"

PointPatterns <- readRDS("data/PointPatterns_5x.rds")
row.names(PointPatterns) <- PointPatterns$ID
N <- PointPatterns$Neurons[[id]]; M <- PointPatterns$Microglia[[id]]
xy <- cbind(N$x, N$y)

# H1 loops: alphaComplexDiag gives squared radii; a loop dies at the circumcircle of a Delaunay triangle
d  <- alphaComplexDiag(xy, maxdimension = 1, library = "GUDHI")$diagram
d  <- d[d[, 1] == 1, , drop = FALSE]
tri <- t(sapply(deldir::triang.list(deldir::deldir(xy[, 1], xy[, 2])), function(t) t$ptNum))
circ <- t(apply(tri, 1, function(v) {
  a <- xy[v[1], ]; b <- xy[v[2], ]; c <- xy[v[3], ]
  D <- 2 * (a[1] * (b[2] - c[2]) + b[1] * (c[2] - a[2]) + c[1] * (a[2] - b[2]))
  ux <- ((sum(a^2)) * (b[2] - c[2]) + sum(b^2) * (c[2] - a[2]) + sum(c^2) * (a[2] - b[2])) / D
  uy <- ((sum(a^2)) * (c[1] - b[1]) + sum(b^2) * (a[1] - c[1]) + sum(c^2) * (b[1] - a[1])) / D
  c(ux, uy, sqrt((a[1] - ux)^2 + (a[2] - uy)^2))
}))
life <- sqrt(d[, 3]) - sqrt(d[, 2])
top  <- order(life, decreasing = TRUE)[1:40]
loops <- t(sapply(top, function(i) {
  j <- which.min(abs(circ[, 3]^2 - d[i, 3]))
  c(circ[j, 1:2], birth = sqrt(d[i, 2]), death = sqrt(d[i, 3]), life = life[i])
}))
colnames(loops) <- c("x", "y", "birth", "death", "life")

# Sections are taller than wide: swap the axes so that the image is landscape
loops[, 1:2] <- loops[, 2:1]; xy <- xy[, 2:1]; Mxy <- cbind(M$y, M$x)

bg <- "#070B18"
pal <- colorRampPalette(c("#5B1A6E", "#C03A83", "#F1605D", "#FEC98D"))(100)
ring <- function(x, y, r, ...) { a <- seq(0, 2 * pi, length.out = 120); polygon(x + r * cos(a), y + r * sin(a), ...) }

png(out, width = 2400, height = 1260, res = 200, bg = bg)
par(mar = c(0, 0, 0, 0), bg = bg)
xr <- range(xy[, 1]); yr <- range(xy[, 2])
plot(NA, xlim = xr, ylim = yr, asp = 1, axes = FALSE, xlab = "", ylab = "")
# Delaunay edges and the neurons
segs <- rbind(tri[, c(1, 2)], tri[, c(2, 3)], tri[, c(1, 3)])
segments(xy[segs[, 1], 1], xy[segs[, 1], 2], xy[segs[, 2], 1], xy[segs[, 2], 2], col = adjustcolor("#6C8CD5", 0.25), lwd = 0.5)
points(xy, pch = 16, cex = 0.35, col = adjustcolor("#9DB4F0", 0.8))
# Loops, smallest first so that the largest sit underneath
rk <- pmax(1, ceiling(100 * (loops[, "life"] - min(loops[, "life"])) / diff(range(loops[, "life"]))))
for (k in order(loops[, "life"])) {
  col <- pal[rk[k]]
  for (r in seq(loops[k, "birth"], loops[k, "death"], length.out = 8)[-1])
    ring(loops[k, 1], loops[k, 2], r, col = adjustcolor(col, 0.10), border = NA)
  ring(loops[k, 1], loops[k, 2], loops[k, "death"], col = NA, border = adjustcolor(col, 0.9), lwd = 1.2)
}
points(Mxy, pch = 16, cex = 0.4, col = adjustcolor("#FFB000", 0.9))
invisible(dev.off())
cat("saved", out, "\n")
