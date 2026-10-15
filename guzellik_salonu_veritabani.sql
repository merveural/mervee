-- =============================================
-- GÜZELLİK SALONU VERİTABANI
-- MySQL için hazırlanmıştır
-- =============================================

CREATE DATABASE IF NOT EXISTS guzellik_salonu
CHARACTER SET utf8mb4
COLLATE utf8mb4_turkish_ci;

USE guzellik_salonu;

-- =============================================
-- TABLOLAR
-- =============================================

CREATE TABLE IF NOT EXISTS musteriler (
    musteri_id INT AUTO_INCREMENT PRIMARY KEY,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    telefon VARCHAR(20) NOT NULL UNIQUE,
    eposta VARCHAR(100) UNIQUE,
    dogum_tarihi DATE,
    kayit_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS calisanlar (
    calisan_id INT AUTO_INCREMENT PRIMARY KEY,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    telefon VARCHAR(20) UNIQUE,
    eposta VARCHAR(100) UNIQUE,
    pozisyon VARCHAR(50) NOT NULL,
    maas DECIMAL(10,2) NOT NULL,
    ise_giris_tarihi DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS hizmetler (
    hizmet_id INT AUTO_INCREMENT PRIMARY KEY,
    hizmet_adi VARCHAR(100) NOT NULL,
    aciklama VARCHAR(255),
    sure_dk INT NOT NULL,
    fiyat DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS randevular (
    randevu_id INT AUTO_INCREMENT PRIMARY KEY,
    musteri_id INT NOT NULL,
    calisan_id INT NOT NULL,
    hizmet_id INT NOT NULL,
    randevu_tarihi DATE NOT NULL,
    randevu_saati TIME NOT NULL,
    durum ENUM('Bekliyor', 'Tamamlandi', 'Iptal') DEFAULT 'Bekliyor',
    olusturma_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (musteri_id) REFERENCES musteriler(musteri_id),
    FOREIGN KEY (calisan_id) REFERENCES calisanlar(calisan_id),
    FOREIGN KEY (hizmet_id) REFERENCES hizmetler(hizmet_id)
);

CREATE TABLE IF NOT EXISTS odemeler (
    odeme_id INT AUTO_INCREMENT PRIMARY KEY,
    randevu_id INT NOT NULL,
    tutar DECIMAL(10,2) NOT NULL,
    odeme_yontemi ENUM('Nakit', 'Kredi Karti', 'Havale') NOT NULL,
    odeme_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (randevu_id) REFERENCES randevular(randevu_id)
);

CREATE TABLE IF NOT EXISTS urunler (
    urun_id INT AUTO_INCREMENT PRIMARY KEY,
    urun_adi VARCHAR(100) NOT NULL,
    marka VARCHAR(50),
    stok_adedi INT NOT NULL DEFAULT 0,
    alis_fiyati DECIMAL(10,2) NOT NULL,
    satis_fiyati DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS urun_satislari (
    satis_id INT AUTO_INCREMENT PRIMARY KEY,
    musteri_id INT NOT NULL,
    urun_id INT NOT NULL,
    adet INT NOT NULL,
    satis_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (musteri_id) REFERENCES musteriler(musteri_id),
    FOREIGN KEY (urun_id) REFERENCES urunler(urun_id)
);

-- =============================================
-- ÖRNEK VERİLER
-- =============================================

INSERT INTO hizmetler (hizmet_adi, aciklama, sure_dk, fiyat) VALUES
('Saç Kesimi', 'Kadın/erkek saç kesimi', 45, 350.00),
('Saç Boyama', 'Profesyonel saç boyama', 120, 1200.00),
('Manikür', 'Tırnak bakımı ve oje', 60, 400.00),
('Pedikür', 'Ayak bakımı ve oje', 60, 450.00),
('Cilt Bakımı', 'Yüz temizliği ve maske', 75, 800.00);

INSERT INTO calisanlar (ad, soyad, telefon, eposta, pozisyon, maas, ise_giris_tarihi) VALUES
('Ayşe', 'Yılmaz', '05551112233', 'ayse@salon.com', 'Kuaför', 35000.00, '2024-01-15'),
('Elif', 'Kaya', '05552223344', 'elif@salon.com', 'Güzellik Uzmanı', 32000.00, '2024-03-01');

INSERT INTO musteriler (ad, soyad, telefon, eposta, dogum_tarihi) VALUES
('Zeynep', 'Demir', '05321112233', 'zeynep@mail.com', '1995-06-12'),
('Merve', 'Çelik', '05332223344', 'merve@mail.com', '1990-09-25');

INSERT INTO randevular (musteri_id, calisan_id, hizmet_id, randevu_tarihi, randevu_saati, durum) VALUES
(1, 1, 1, '2026-10-20', '14:00:00', 'Bekliyor'),
(2, 2, 4, '2026-10-21', '11:30:00', 'Bekliyor');

INSERT INTO urunler (urun_adi, marka, stok_adedi, alis_fiyati, satis_fiyati) VALUES
('Saç Kremi', 'Loreal', 25, 180.00, 320.00),
('Oje', 'Flormar', 40, 45.00, 95.00),
('Yüz Temizleme Jeli', 'Nivea', 15, 120.00, 220.00);

INSERT INTO urun_satislari (musteri_id, urun_id, adet) VALUES
(1, 1, 1),
(2, 2, 2);

-- =============================================
-- ÖRNEK RANDEVU LİSTELEME SORGUSU
-- =============================================

SELECT 
    r.randevu_id,
    CONCAT(m.ad, ' ', m.soyad) AS musteri,
    CONCAT(c.ad, ' ', c.soyad) AS calisan,
    h.hizmet_adi,
    r.randevu_tarihi,
    r.randevu_saati,
    r.durum
FROM randevular r
JOIN musteriler m ON r.musteri_id = m.musteri_id
JOIN calisanlar c ON r.calisan_id = c.calisan_id
JOIN hizmetler h ON r.hizmet_id = h.hizmet_id
ORDER BY r.randevu_tarihi, r.randevu_saati;
