# Not: NHANES "Combining Cycles" Agirlik Duzeltmesi

## Kural

Birden fazla NHANES cycle'ini birlestirirken, survey weight'ler toplam
sureye gore yeniden olceklenmelidir.

## Kaynak

Standart kural (esit 2 yillik cycle'lar icin):
"The standard rule is to divide the original two-year sample weight by
the number of cycles being combined."
https://ehsanx.github.io/EpiMethods/surveydata0.html

Ozel durum (2017-2020 "pre-pandemic", 3.2 yil):
"To combine 2015-2016 (2 years) and 2017-March 2020 (3.2 years), the new
weight (MEC52Y) would be calculated as: MEC52Y = (2 / 5.2) * WTMEC2YR..."
https://ehsanx.github.io/EpiMethods/surveydata0.html

Resmi CDC NHANES Tutorials (Weighting Module):
https://wwwn.cdc.gov/nchs/nhanes/tutorials/weighting.aspx

## Uygulanan Formul

combined_weight = (cycle_suresi / toplam_sure) * cycle_kendi_2yillik_agirligi

| Cycle | Sure (yil) |
|---|---|
| 2011-2012 | 2.0 |
| 2013-2014 | 2.0 |
| 2015-2016 | 2.0 |
| 2017-2020 | 3.2 |
| 2021-2023 | 2.0 |
| Toplam | 11.2 |

Uygulama: int_demo_all_cycles.sql (combined_interview_weight,
combined_exam_weight sutunlari).

## Onemli Not

combined_* agirliklari sadece "tum 2011-2023'u tek bir kesit gibi
ozetlemek" icin kullanilir. Trend analizinde (cycle'lar arasi
karsilastirma), her cycle'in KENDI orijinal agirligi kullanilmalidir.
