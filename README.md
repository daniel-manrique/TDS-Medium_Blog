# Medium / Towards Data Science blog

Reproducible code, data and Quarto documents behind my articles on statistics and data analysis in R, published on
[Medium](https://medium.com/@damanrique) and [Towards Data Science](https://towardsdatascience.com/author/damanrique/).

## Articles

| Date | Article | Folder |
|---|---|---|
| 2024-02-03 | Beyond the Mean: Embracing Uncertainty in Measurements with Bayesian Analysis and multilevel modeling | [articles/2024-02-03_BeyondTheMean](articles/2024-02-03_BeyondTheMean) |
| 2024-02-22 | Do not over-think about 'outliers', use a student-t distribution instead | [articles/2024-02-22_OutliersStudent-t](articles/2024-02-22_OutliersStudent-t) |
| 2024-04-03 | Avoiding abuse and misuse of T-test and ANOVA: Regression for categorical responses | [articles/2024-04-03_UseAndAbuseANOVA](articles/2024-04-03_UseAndAbuseANOVA) |
| 2024-04-19 | Improving the analysis of object (or cells) counts with lots of zeros | [articles/2024-04-19_CountsZeroInflated](articles/2024-04-19_CountsZeroInflated) |
| 2024-05-24 | Introduction to spatial analysis of cells for neuroscientists (part 1) | [articles/2024-05-24_SpatialAnalysis_Part1](articles/2024-05-24_SpatialAnalysis_Part1) |
| 2026-10-23 | Where a Cell Sits Matters More Than How Many There Are (spatial analysis, part 2) | [articles/2026-10-23_SpatialAnalysis_Part2](articles/2026-10-23_SpatialAnalysis_Part2) |
| 2026-10-28 | Your 'Outliers' Are Telling You Something: Rebuilding a Student-t Analysis From Scratch | [articles/2026-10-28_OutliersRevisited](articles/2026-10-28_OutliersRevisited) |
| 2026-10-28 | Persistent Homology Sees What Pair Correlation Cannot. A Null Model Decides If It Matters. (R) | [articles/2026-10-28_TDA_R](articles/2026-10-28_TDA_R) |
| 2026-10-28 | Does the Shape Beat the Count? Persistent Homology in Python for Point Clouds | [articles/2026-10-28_TDA_Python](articles/2026-10-28_TDA_Python) |
| 2026-10-28 | Mapper Draws the Map of Your Point Cloud. A Shuffled Null Tells You Which Roads Are Real. (Python) | [articles/2026-10-28_TDA_Mapper](articles/2026-10-28_TDA_Mapper) |

## Repository layout

```
_quarto.yml              # settings shared by all articles (author, license, formats, bibliography)
shared/                  # References.bib, science.csl
articles/
  <YYYY-MM-DD_Name>/
    index.qmd            # the article
    data/                # input data (tracked)
    models/              # fitted models (git-ignored, regenerated on render)
    plots/               # static images used in the text (tracked)
templates/article-template/   # copy this folder to start a new article
```

All paths inside an article are relative to its own folder (`data/...`, `models/...`, `plots/...`).

## Reproducing an article

1. Install [R](https://cran.r-project.org/), [Quarto](https://quarto.org/) and a C++ toolchain for Stan (needed by `brms`).
2. Install the packages:

   ```r
   install.packages(c("brms", "tidybayes", "ggdist", "modelr", "patchwork", "easystats",
                      "dplyr", "tibble", "tidyr", "ggplot2", "ghibli", "gtsummary", "spatstat", "readxl", "loo", "knitr", "TDA"))
   ```
   The Python articles (`2026-10-28_TDA_Python`, `2026-10-28_TDA_Mapper`) also need Python 3 with its Jupyter kernel:

   ```bash
   pip install gudhi numpy pandas scipy scikit-learn networkx matplotlib jupyter
   ```
3. Render one article, or all of them:

   ```bash
   quarto render articles/2024-02-22_OutliersStudent-t/index.qmd
   quarto render
   ```

Rendered `.html`/`.pdf` files and the fitted models (`models/*.rds`) are not versioned. The first render fits the
models and saves them in `models/`, so it takes longer; later renders reuse them.

## New article

Copy `templates/article-template/` to `articles/<YYYY-MM-DD_Name>/` and edit `index.qmd`.

## License

See [LICENSE](LICENSE).
