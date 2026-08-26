[README.md](https://github.com/user-attachments/files/31474225/README.md)
# Dose of Reality: Overlap in U.S. Supplement Use (1999–2023)

Bu proje, ABD'de açık kaynak anket verileri (NHANES) üzerinden supplement kullanım
davranışını inceliyor: kimler, hangi supplement'leri, ne yoğunlukta kullanıyor; kullanım
demografik gruplara göre nasıl farklılaşıyor; ve zaman içinde bu eğilim nasıl değişmiş.
Ayrıca birden fazla supplement'in içeriklerinde örtüşen bileşenlerin, önerilen üst
sınırları (UL — Tolerable Upper Intake Level) popülasyon düzeyinde ne ölçüde aştığına
bakılıyor.

**Kapsam dışı:** İlaç–supplement etkileşimi, kişiye özel doz tavsiyesi, ücretli
database'ler.

## Veri Kaynakları

- **NHANES – Dietary Supplement Use (CDC):** 30 günlük kullanım anketi (DSQIDS, DSQTOT),
  demografik değişkenler için DEMO ile join edilecek
- **NHANES – Dietary Supplement Database:** ürün (DSPI), içerik (DSII) ve karışım (DSBI)
  referans tabloları
- **NIH ODS – Dietary Supplement Label Database (DSLD):** ek ürün/içerik bilgisi

## Analiz Kırılımları

- Cinsiyet, yaş grubu, etnik köken
- Coğrafya (kısıt: NHANES'te region düzeyi olabilir, eyalet değil)
- Zaman (NHANES cycle'ları arası — 1999–2023 trend analizi)

## Analiz Planı

1. Veri yükleme (NHANES XPT dosyaları → pandas/BigQuery)
2. Veri temizleme
3. DEMO ile join → demografik zenginleştirme
4. DSII/DSPI/DSBI ile join → içerik/ingredient eşleme
5. "Potansiyel çakışan içerik yükü" metriği türetme
6. EDA — demografik kırılım analizi (2021–2023 cycle'ı üzerinden)
7. Segmentasyon — hangi grup hangi supplement kombinasyonunu kullanıyor
8. Geçmiş cycle'ların dahil edilmesi (kademeli genişletme)
9. Trend analizi — cycle'lar arası karşılaştırma
10. Tahminleme (ML) — segment bazlı trendlerin tutarlılığını test etme ve
    gelecekteki kullanım davranışını öngörme

## Stack

- **BigQuery** — veri ambarı
- **dbt** — veri modelleme/dönüştürme
- **Python (pandas, vb.)** — veri yükleme, EDA, ML

## Proje Durumu

🚧 Aktif geliştirme aşamasında. Bootcamp bitirme projesi (Workintech).

---

*Bu, kişisel bir merak sorusundan (birden fazla supplement kullanırken içerik çakışması
UL sınırlarını aşıyor mu?) doğan ve popülasyon düzeyinde bir davranış analizine dönüşen
bir çalışmadır.*

