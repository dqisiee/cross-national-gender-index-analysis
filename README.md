# Cross-National Comparative Statistical Analysis: Gender Role Conformity

A reproducible R analytics pipeline examining generational variance in adherence to traditional masculine gender norms across Australia and Japan.

---

## Overview
This study examines survey data assessing the **Conformity to Gender Norms Index (CGI)** across adult male respondents in Australia ($N = 512$) and Japan ($N = 260$). 

The objective is to evaluate whether adherence to traditional gender expectations diverges significantly across chronological age brackets (18–24, 25–34, 35–44, 45–54, 55–64) and across national cultural contexts.

---

## Key Methodology
- **Cohort Harmonization:** Binned continuous age values into standardised demographic brackets.
- **Descriptive Diagnostics:** Evaluated distribution properties, dispersion (IQR, standard deviation), and central tendency per cohort.
- **Parametric & Non-Parametric Hypothesis Testing:**
  - Non-parametric Kruskal-Wallis rank sum tests for cohort variance within countries.
  - Two-way factorial ANOVA ($Country \times AgeCohort$) evaluating main effects and interaction dynamics.
- **Visualization:** Publication-grade `ggplot2` distributions exported at 300 DPI.

---

## Repository Structure

```text
├── data/
│   └── global_masculinity_survey.csv   # Source dataset
├── output/
│   ├── figures/                        # Generated ggplot2 distributions
│   └── tables/                         # Exported ANOVA and summary statistics
├── R/
│   └── analysis_pipeline.R             # End-to-end reproducible pipeline
├── .gitignore
└── README.md
```