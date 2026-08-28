# Not: NHANES Urun ID Sistemi Sureksizligi ve Cozumu (2016/2017 Kirilimi)

## Ilk Tespit (Yanlis Sonuca Goturen)

2011-2012, 2013-2014, 2015-2016 cycle'larindaki urun ID'leri (DSDSUPID),
DSPI'daki yeni urun ID sutunu (DSDPID) ile karsilastirildiginda %0
eslesiyordu.

## Kaynak / Dogrulama

CDC'nin resmi NHANES Tutorials sayfasi:
"NHANES 1999-2016 cycles are linked by the old ID code (variable DSDSUPID)
and the NHANES 2017-March 2020 cycles is linked by the new ID code
(variable DSDPID)."
https://wwwn.cdc.gov/nchs/nhanes/tutorials/dietaryanalyses.aspx

## Gercek Cozum: DSPI'nin Kendi Icindeki Eski ID Sutunu

DSBI.htm dokumantasyonu:
"Variables DSDPID, DSDIID, DSDBID were added to indicate the updated
supplement ID, ingredient ID, and blend component ID, respectively. The
variables DSDSUPID, DSDINGID, and DSDBCID now indicate the old versions..."
https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/1999/DataFiles/DSBI.htm

DSPI tablosunun kendi icinde hem DSDPID hem DSDSUPID sutunu birlikte
bulunuyor. Dogrulama: 2011-2012 cycle'indaki 2,242 farkli urun ID'sinden
2,174'u (%97.0) DSPI'nin DSDSUPID sutunu uzerinden basariyla eslesti.

## Kapsam Karari

Tum 5 cycle (2011-2023), DSPI'nin DSDSUPID/DSDPID sutunlari uzerinden
join edilerek hem genel kullanim hem ingredient bazli cakisma/UL analizine
dahil edilebilir. Uygulama: int_dsqids_all_cycles.sql (dspi_product_id
sutunu).
