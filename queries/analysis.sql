-- Banka Telepazarlama Kampanyasi - SQL Musteri Analizi
-- Veri: UCI Bank Marketing Dataset (train.csv, 45.000 kayit)


-- ========== BLOK 1: Genel Ortalama ==========

-- Toplam kayit sayisi
SELECT COUNT(*) FROM train;

-- Evet/hayir dagilimi
SELECT COUNT(*), y
FROM train
GROUP BY y;

-- Meslek gruplari
SELECT job FROM train
GROUP BY job;

-- Genel ortalama:  %11.7
SELECT 5289 * 100.0 / (39922 + 5289) AS evet_orani;


-- ========== BLOK 2: DEMOGRAFI ==========

-- Meslege gore evet oranı
SELECT job,
       COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*) AS evet_orani
FROM train
GROUP BY job
ORDER BY evet_orani DESC;

-- Egitime gore evet oranı
SELECT education,
       COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*) AS evet_orani
FROM train
GROUP BY education
ORDER BY evet_orani DESC;

-- Medeni duruma gore evet oranı
SELECT marital,
       COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*) AS evet_orani
FROM train
GROUP BY marital
ORDER BY evet_orani DESC;


-- ========== BLOK 3: FILTRELEME ==========

-- Negatif,düşük bakiyelilerin evet oranı
SELECT ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_orani
FROM train
WHERE balance < 0;

-- Ogrenci olmayan bekarlar 
SELECT ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_orani
FROM train
WHERE marital = 'single' AND job != 'student';

-- Meslek evet oranı, kucuk gruplar elendi having ile
SELECT job,
       COUNT(*) AS kisi_sayisi,
       ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_orani
FROM train
GROUP BY job
HAVING COUNT(*) > 100
ORDER BY evet_orani DESC;


-- ========== BLOK 4: KATEGORILESTIRME (CASE WHEN) ==========

-- Yas gruplarina gore evet oranı
SELECT
    CASE
        WHEN age < 30 THEN 'genc'
        WHEN age <= 50 THEN 'orta'
        ELSE 'yasli'
    END AS yas_grubu,
    ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_orani
FROM train
GROUP BY yas_grubu
ORDER BY evet_orani DESC;

-- Bakiye dilimlerine gore evet oranı
SELECT
    CASE
        WHEN balance <= 0 THEN 'dusuk alim gucu'
        WHEN balance > 0 AND balance < 1000 THEN 'orta alim gucu'
        ELSE 'yuksek alim gucu'
    END AS alim_gucu,
    ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_orani
FROM train
GROUP BY alim_gucu
ORDER BY evet_orani DESC;

-- Meslege gore ortalama bakiye 
SELECT job,
       ROUND(AVG(balance), 0) AS ort_bakiye
FROM train
GROUP BY job
HAVING job != 'unknown'
ORDER BY ort_bakiye DESC;


-- ========== BLOK 5: KAMPANYA DAVRANISI ==========

-- Onceki kampanya sonucuna gore evet oranı (poutcome)
SELECT poutcome,
       COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*) AS evet_orani
FROM train
GROUP BY poutcome
ORDER BY evet_orani DESC;

-- success grubunun buyuklugu
SELECT COUNT(poutcome) FROM train
GROUP BY poutcome
HAVING poutcome = 'success';

-- Arama sayisina gore evet oranı (campaign)
SELECT
    CASE
        WHEN campaign = 1 THEN '1 kere aranan'
        WHEN campaign = 2 THEN '2 kere aranan'
        WHEN campaign = 3 THEN '3 kere aranan'
        WHEN campaign = 4 THEN '4 kere aranan'
        WHEN campaign = 5 THEN '5 kere aranan'
        ELSE '5+ kere aranan'
    END AS aranma_sayisi,
    ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_orani
FROM train
GROUP BY aranma_sayisi
ORDER BY evet_orani DESC;

-- Daha önce aranmanın verilen cevaba etkisi var mı?(previous)
SELECT
    CASE
        WHEN previous = 0 THEN 'daha once aranmamis'
        ELSE 'daha once aranan'
    END AS gecmis_temas,
    ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_orani
FROM train
GROUP BY gecmis_temas
ORDER BY evet_orani DESC;


-- ========== BLOK 6: WINDOW FONKSIYONU (CTE + RANK) ==========

-- Meslekleri evet oranına gore siralar
WITH meslek_oranlari AS (
    SELECT job,
           ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_orani
    FROM train
    GROUP BY job
)
SELECT
    job,
    evet_orani,
    RANK() OVER (ORDER BY evet_orani DESC) AS meslek_siralamasi
FROM meslek_oranlari;
