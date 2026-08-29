# Dashboard Notu: Kucuk Ornek Seffafligi

## Durum

Dashboard icin olusturulan mart_dashboard_ingredient tablosunda
(cycle x ingredient x cinsiyet x yas x etnik koken kirilimi, 1,499 satir),
439 satirda (%29.3) kisi sayisi 20'nin altinda.

## Tasarim Karari

Bu satirlar silinmedi - seffaflik icin tabloda tutuluyor, ama her satirda
n_kisi sutunu acikca yer aliyor. Looker Studio dashboard'unda:

1. n_kisi her zaman gorunur tutulacak
2. Kosullu bicimlendirme ile n_kisi < 20 olan satirlar isaretlenecek
3. Istege bagli bir "minimum orneklem" filtresi eklenecek

## Gerekce

Kucuk orneklemli hucrelerdeki buyuk gorunen farklar yaniltici olabilir.
Bu riski gizlemek yerine gorunur kilmak, dashboard'un guvenilirligini
artirir.
