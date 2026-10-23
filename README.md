# Medium / Towards Data Science blog

Source files for my articles on [Medium](https://medium.com/@damanrique) and Towards Data Science.

## Articles

| Date | Article | Folder |
|---|---|---|
| 2024-02-03 | Beyond the Mean: Embracing Uncertainty in Measurements with Bayesian Analysis and multilevel modeling | [articles/2024-02-03_BeyondTheMean](articles/2024-02-03_BeyondTheMean) |
| 2024-02-22 | Do not over-think about 'outliers', use a student-t distribution instead | [articles/2024-02-22_OutliersStudent-t](articles/2024-02-22_OutliersStudent-t) |
| 2024-04-03 | Avoiding abuse and misuse of T-test and ANOVA: Regression for categorical responses | [articles/2024-04-03_UseAndAbuseANOVA](articles/2024-04-03_UseAndAbuseANOVA) |
| 2024-04-19 | Improving the analysis of object (or cells) counts with lots of zeros | [articles/2024-04-19_CountsZeroInflated](articles/2024-04-19_CountsZeroInflated) |
| 2024-05-24 | Introduction to spatial analysis of cells for neuroscientists (part 1) | [articles/2024-05-24_SpatialAnalysis_Part1](articles/2024-05-24_SpatialAnalysis_Part1) |

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
                      "dplyr", "tibble", "ggplot2", "ghibli", "gtsummary", "spatstat"))
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
