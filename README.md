# Dose of Reality — Overlap Deceives, Exceedance Is Real

Data analysis of U.S. dietary supplement use: does taking multiple
supplements that share the same nutrient push people past the
official safe upper limit — and does that risk differ by gender, age,
or ethnicity, or shift under the pressure of a pandemic?

**Metrics:** Overlap = taking the same ingredient from >1 product in the
past 30 days. Exceedance = total intake of an ingredient exceeding its
official Tolerable Upper Intake Level (UL).

## Data

- NHANES Dietary Supplement Use Data (CDC, public domain) — 46,388
  person-cycle observations across 10 survey cycles, 1999–2023
  ([source](https://wwwn.cdc.gov/nchs/nhanes/search/default.aspx?Component=Dietary))
- NHANES Supplement Product/Ingredient Reference Tables (DSPI/DSII/DSBI)
  — cross-cycle product-to-ingredient mapping, bridging a 2016/2017
  product-ID system change
- IOM/NAS Dietary Reference Intakes — official UL values for 6
  ingredients (Vitamin D, Iron, Magnesium, Niacin, Zinc, Vitamin A)

## Method

- **Warehouse:** BigQuery, layered dbt architecture (staging →
  intermediate → marts), 10 survey cycles combined per NHANES's
  official cycle-combining and duration-weighting rules
- **Analysis:** Python (pandas) in Colab
- **Statistics:** design-based survey statistics (`svy` package) — t-tests,
  Kruskal-Wallis rank tests, one-sample proportion test — accounting
  for NHANES's complex stratified/clustered sampling design
- **Counterfactual Modeling:** pre-pandemic trend (1999–2020) projected
  forward to quantify the pandemic's actual deviation from expected
  usage, rather than forecasting an inherently atypical period directly

## Key Findings

- 64.2% of UL exceedance cases stem from ingredient overlap rather
  than single-product dosage (t=21.37, p<0.0001)
- The gender gap in overlap and exceedance has held structurally
  stable for 24 years and survives official survey weighting
  (t=−13.76, p<0.0001)
- Age is the strongest demographic factor — risk rises monotonically
  with age (F=584.79, p<0.0001)
- The Non-Hispanic Black exceedance rate overtook Non-Hispanic White
  in 2021–2023, reversing a hierarchy that had held since 1999
- The pandemic pushed overall usage 20.9 points below its pre-pandemic
  trend projection — while overlap and exceedance kept rising among
  the users who remained

## Full Write-Up

Full methodology, limitations, and statistical detail are in the
accompanying report and presentation:

- 📊 [Interactive Dashboard](#) — Looker Studio *(coming soon)*
- 📄 [Report (PDF)](./Dose_of_Reality_Report_EN.pdf)
- 🎞️ [Presentation (PDF)](./Dose_of_Reality_Presentation_EN.pdf)
- 🎬 [Video Summary](https://drive.google.com/file/d/1Q9-42b-Aue8TZS1yXjlc7bWH6I7K32kV/view?usp=share_link) — narrative overview
- 📓 [Analysis Notebook](./notebooks/dose_of_reality.ipynb)

---

Workintech Data Science & Analytics Bootcamp — Capstone Project, 2026
Didem Arslan
