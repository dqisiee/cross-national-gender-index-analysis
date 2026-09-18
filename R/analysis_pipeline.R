# ==============================================================================
# Cross-National Comparative Analysis: Gender Role Conformity by Age Cohort
# Australia vs. Japan (Male Cohorts)
# ==============================================================================

# Install required packages if missing
required_pkgs <- c("dplyr", "ggplot2", "readr", "broom")
new_pkgs <- required_pkgs[!(required_pkgs %in% installed.packages()[, "Package"])]
if (length(new_pkgs)) install.packages(new_pkgs, repos = "https://cloud.r-project.org")

library(dplyr)
library(ggplot2)
library(readr)
library(broom)

# 1. Ingestion & Data Preparation ---------------------------------------------
raw_data <- read_csv("data/global_masculinity_survey.csv", show_col_types = FALSE)

analysis_sample <- raw_data %>%
  filter(
    country %in% c("Australia", "Japan"),
    male == 1,
    !is.na(cgi),
    !is.na(age)
  ) %>%
  mutate(
    age_group = cut(
      age,
      breaks = c(18, 25, 35, 45, 55, 65),
      labels = c("18-24", "25-34", "35-44", "45-54", "55-64"),
      right = FALSE
    ),
    country = factor(country, levels = c("Australia", "Japan"))
  )

# 2. Descriptive Summary Statistics ------------------------------------------
cohort_summary <- analysis_sample %>%
  group_by(country, age_group) %>%
  summarise(
    sample_size = n(),
    mean_cgi = round(mean(cgi), 2),
    sd_cgi = round(sd(cgi), 2),
    median_cgi = round(median(cgi), 2),
    iqr_cgi = round(IQR(cgi), 2),
    .groups = "drop"
  )

write_csv(cohort_summary, "output/tables/cohort_descriptive_statistics.csv")
print(cohort_summary)

# 3. High-Resolution Visualizations -------------------------------------------
plot_cohorts <- ggplot(analysis_sample, aes(x = age_group, y = cgi, fill = country)) +
  geom_boxplot(alpha = 0.75, outlier.alpha = 0.4) +
  scale_fill_manual(values = c("Australia" = "#2b5c8f", "Japan" = "#d95f02")) +
  theme_minimal(base_size = 12) +
  labs(
    title = "Gender Role Conformity Index (CGI) by Age Cohort",
    subtitle = "Comparative distribution across adult male cohorts in Australia and Japan",
    x = "Age Bracket",
    y = "Conformity to Gender Norms Index (0-10)",
    fill = "Country"
  ) +
  facet_wrap(~country)

ggsave("output/figures/cgi_distribution_by_cohort.png", plot_cohorts, width = 9, height = 5, dpi = 300)

# 4. Statistical Hypothesis Testing -------------------------------------------

# Kruskal-Wallis across age brackets within Australia and Japan
kw_aus <- kruskal.test(cgi ~ age_group, data = filter(analysis_sample, country == "Australia"))
kw_jpn <- kruskal.test(cgi ~ age_group, data = filter(analysis_sample, country == "Japan"))

# Two-way factorial ANOVA model
anova_model <- aov(cgi ~ country * age_group, data = analysis_sample)
tidy_anova_results <- tidy(anova_model)

write_csv(tidy_anova_results, "output/tables/anova_test_results.csv")
print(tidy_anova_results)