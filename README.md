# Dose of Reality

**Ingredient overlap and Tolerable Upper Intake Level exceedance in U.S. dietary supplement use, 1999–2023**

If you take a multivitamin *and* a separate vitamin D capsule *and* a magnesium tablet, you are taking
vitamin D three times. Nothing on any of those labels tells you that. This project measures how often
that happens across the U.S. population, and how often it pushes someone past the Tolerable Upper
Intake Level (UL) — the daily ceiling above which intake is no longer considered safe.

24 years of CDC survey data, 10 NHANES cycle blocks, ~46,000 person-cycle records.

📓 **[Read the analysis notebook →](notebooks/dose_of_reality.ipynb)**

---

## Headline findings

| | |
|---|---|
| **39.8%** | of supplement users take the same vitamin or mineral from **two or more different products** *(2021–2023, survey-weighted)* |
| **33.3%** | exceed the UL for at least one ingredient *(2021–2023, survey-weighted)* |
| **64.2%** | of all UL exceedance is **overlap-driven** rather than caused by a single product — significantly more than a 50/50 split *(t = 21.4, p < 0.0001)* |
| **+6.2 pts** | vitamin D exceedance in 2021–2023 above what the 1999–2020 trend predicted; zinc **+5.5 pts** from a two-decade flat line |
| **−20.9 pts** | overall supplement use in 2021–2023 below the pre-pandemic trend forecast |

**The finding that changes the advice:** *overlap* and *exceedance* are not the same risk, and the mix
differs by ingredient. Vitamin D exceedance is almost entirely driven by stacking multiple products.
Iron exceedance is driven by the dose printed on a *single* label. Guidance that only says "watch out
for taking too many supplements" would be right about vitamin D and wrong about iron.

---

## Stack

**BigQuery** (warehouse) · **dbt** (transformation) · **Python** — pandas, matplotlib,
[`svy`](https://svylab.com/docs/svy) for design-based survey statistics · **Looker Studio** (dashboard)

## Data sources

| Source | What it provides |
|---|---|
| [NHANES Dietary Supplement Use](https://wwwn.cdc.gov/nchs/nhanes/) (CDC) | 30-day supplement use, one row per person per product — 10 cycles |
| [NHANES Demographics](https://wwwn.cdc.gov/nchs/nhanes/) (CDC) | Age, sex, race/ethnicity, survey weights, strata, PSU |
| [NHANES Dietary Supplement Database](https://wwwn.cdc.gov/nchs/nhanes/) (CDC) | Product reference (`DSPI`), ingredient composition (`DSII`), blends (`DSBI`) |
| IOM/NAS Dietary Reference Intakes ([2000](https://www.ncbi.nlm.nih.gov/books/NBK222881/), [2003](https://www.ncbi.nlm.nih.gov/books/NBK208874/)) | Tolerable Upper Intake Levels |

**Coverage:** `1999–2002` · `2003–2004` · `2005–2006` · `2007–2008` · `2009–2010` · `2011–2012` ·
`2013–2014` · `2015–2016` · `2017–2020` · `2021–2023`

All sources are public and free.

---

## Repository map

```
notebooks/
  dose_of_reality.ipynb        the full analysis, end to end
dbt/
  models/staging/              one view per source file — absorbs 24 years of schema drift
  models/intermediate/         cycle unions, product-ID crosswalk, unit standardisation, UL join
  models/marts/                one materialised table per analytical question
docs/                          methodology notes
```

### Pipeline

```
nhanes_raw   →   staging   →   intermediate   →   marts   →   notebook + dashboard
(30 raw          rename,        union cycles,      one table
 tables)         decode,        resolve IDs,       per question
                 stamp cycle    normalise units
```

---

## Three problems worth reading about

**A product-ID system change that returns 0% match, silently.**
NHANES switched product identifiers in 2017 (`DSDSUPID` → `DSDPID`). Joining older cycles to the
product reference table returns *zero* rows — which looks like a hard limit on how far back the
analysis can reach. It is not: `DSPI` carries both id systems in the same row and is its own crosswalk.
Match rates 92–98% across all ten cycles.
→ [Notebook §12](notebooks/dose_of_reality.ipynb) · [`docs/nhanes_id_sistemi_kisiti.md`](docs/nhanes_id_sistemi_kisiti.md) (TR)

**A 4× duplication bug that corrupted one number and left another untouched.**
A BigQuery load cell run four times, with `load_table_from_dataframe` defaulting to `WRITE_APPEND`,
quadrupled every raw table. Exceedance (which uses `SUM`) read 98.2%; overlap (which uses
`COUNT DISTINCT`) was completely unaffected at 40.7%. The same bad data produced one catastrophically
wrong number and one correct one. Corrected exceedance: 34.2%.
→ [Notebook §9](notebooks/dose_of_reality.ipynb)

**Survey weighting, done twice — once wrong.**
NHANES deliberately oversamples certain groups, and CDC's guidance for this questionnaire mandates
interview weights. An early decision to report unweighted rates was reversed. The effect turned out to
depend on the *kind* of question: 25 points for prevalence metrics, under 1 point for conditional ones.
Pooling cycles then needs a second, separate duration-weighted correction.
→ [Notebook §13](notebooks/dose_of_reality.ipynb) · [`docs/nhanes_combining_cycles_kurali.md`](docs/nhanes_combining_cycles_kurali.md) (TR)

---

## Reproducing

```bash
pip install pandas matplotlib google-cloud-bigquery db-dtypes svy polars dbt-core dbt-bigquery
```

1. Download the NHANES `.xpt` files listed above.
2. Load them to BigQuery as `nhanes_raw.*` (use `WRITE_TRUNCATE`).
3. `cd dbt && dbt run` to build `nhanes_dbt.*`.
4. Run the notebook top to bottom. Sections 1–7 need only pandas; from §11 onward the cells query
   BigQuery.

Replace the project id `dose-of-reality-506713` with your own throughout.

---

## Scope and limitations

This is a **descriptive population-level study**. It does not model drug–supplement interactions,
does not produce individual dosing advice, and does not use paid clinical databases.

The main limitations, stated in full in [notebook §26](notebooks/dose_of_reality.ipynb):

- ULs are applied at **adult (19–70) values to all ages**, so exceedance is understated for under-18s
- **One serving per day per product** is assumed, since use frequency is not consistently comparable across all ten cycles
- The 2021–2023 break **cannot be decomposed** into survey-mode effect vs real behaviour change — the questionnaire moved to telephone administration that cycle
- Non-Hispanic Asian respondents are not separately visible (`RIDRETH1` is the only coding available across all cycles)
- Botanicals and amino acids are out of scope — no standardised, population-applicable UL system exists for them
- Ingredients with "ND" (Not Determinable) ULs — including vitamin B-12 and biotin, both frequently overlapped — can be measured for overlap but not for exceedance

Every mechanism suggested in the analysis (pandemic behaviour, product reformulation, awareness waves)
is a hypothesis consistent with the timing. None is tested, and none is claimed.

---

*Not medical advice. Analysis of public survey data.*

**Didem Arslan** — bootcamp capstone project (Workintech)
