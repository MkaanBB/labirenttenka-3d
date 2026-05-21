Labirentten Kaçış 3D


**OSTİM Teknik Üniversitesi | GRS 202 Sektörel Proje | 2025-2026**  
**Geliştirici:** Mustafa Kaan Büyükbalcı — 240408477  
**Danışman:** Furkan Aydın

---

Oyun Hakkında

MAZE3D; Godot 4 oyun motoru ve GDScript ile geliştirilmiş, korku temalı bir labirent kaçış oyunudur. Oyuncu her oturumda algoritmik olarak üretilen farklı bir labirente girer ve çıkışı bulmaya çalışır. Karanlık ortam, el feneri, sis efekti ve rastgele jumpscare sistemi oyuna gerilim katar.

Proje; prosedürel içerik üretimi, çoklu oyun modu mimarisi ve kalıcı kayıt sistemi gibi temel oyun geliştirme kavramlarını bir arada ele almaktadır.

---
 Özellikler

Oynanış
-  **Prosedürel Labirent** — Recursive Backtracker algoritmasıyla her oyunda benzersiz labirent
-  **El Feneri** — F tuşuyla açılıp kapanır, kamerayla birlikte hareket eder
- **Sis Efekti** — WorldEnvironment ile atmosferik sis
-  **Jumpscare** — OGV video formatında, rastgele zamalamalı (mod bazlı sıklık)
-  **İşaret Sistemi** — E tuşuyla zemine işaret bırak, her levelde 3 hak
- **Kalp Atışı Sesi** — Çıkışa yaklaşınca otomatik tetiklenir
-  **Bob Efekti** — Yürürken doğal kamera sallantısı

### Sistem
-  **Skor Sistemi** — Süre bonusu + işaret tasarrufu bazlı puan hesabı
-  **En Yüksek Skor** — Mod bazlı kalıcı kayıt (ConfigFile)
-  **Seed Sistemi** — Aynı seed = aynı labirent
-  **Oyuncu Kaydı** — İsim girişi ve kalıcı veri saklama
- **Level Banner** — Level geçişinde animasyonlu yazı
- **Tutorial** — İlk açılışta kontrol rehberi

### Arayüz
- Ana menü (mod seçimi, seed girişi)
- Ayarlar (ses seviyesi, fare hassasiyeti, grafik kalitesi)
- Pause menüsü, yapımcı ekranı, oyun sonu ekranı

---

##  Oyun Modları

###  Endless — Sonsuz Mod
Level sınırı yoktur. Her level yeni labirent üretilir. Jumpscare 30–60 saniye aralıklıdır. Hedef: en yüksek skoru elde etmek.

###  Sprint — Hız Modu
10 leveli mümkün olduğunca hızlı bitir. Jumpscare **yoktur**. Hedef: 10 leveli en kısa sürede tamamlamak.

###  Survival — Hayatta Kal
Her levelde yalnızca **2 dakika** vardır. Süre biterse oyun sona erer. Jumpscare 10–25 saniye aralıklı, çok daha sıktır. Hedef: olabildiğince uzun hayatta kalmak.

---

##  Kontroller

| Tuş | Eylem |
|---|---|
| `WASD` | Hareket |
| `Fare` | Kamera / Bakış yönü |
| `E` | İşaret bırak |
| `F` | El fenerini aç / kapat |
| `ESC` | Pause menüsü |

---

##  Kurulum ve Çalıştırma



### Adımlar
1. Projeyi indir veya klonla
2. Godot 4'ü aç → **Import** → proje klasörünü seç
3. **F5** tuşuna bas veya ▶ butonuna tıkla
4. İlk açılışta isim gir → mod seç → **Yeni Oyun**

### Seed Kullanımı
Ana menüdeki SEED kutusuna bir sayı yazarak her zaman aynı labirenti oynayabilirsin. Boş bırakırsan rastgele labirent üretilir.

---

##  Kullanılan Teknolojiler

| Teknoloji | Kullanım Amacı |
|---|---|
| Godot 4 (Forward+) | Oyun motoru |
| GDScript | Programlama dili |
| Recursive Backtracker | Labirent üretim algoritması |
| FBX / GLB | 3D model formatları |
| MP3 / OGG | Ses ve müzik dosyaları |
| OGV (Theora) | Jumpscare video formatı |
| ConfigFile | Kalıcı veri saklama |

---

##  Proje Yapısı

```
maze3d/
├── game_manager.gd      # Oyun durumu, mod ve level yönetimi (Autoload)
├── game_settings.gd     # Ayarlar, skor ve isim kaydı (Autoload)
├── maze_generator.gd    # Prosedürel labirent üretimi
├── player.gd            # Oyuncu hareketi ve mekanikler
├── enemy.gd             # Düşman AI ve kovalama
├── exit.gd              # Çıkış portal ve level geçişi
├── jumpscare.gd         # Jumpscare video sistemi
├── menu.gd              # Ana menü
├── game_over.gd         # Oyun sonu ekranı
├── pause_menu.gd        # Pause menüsü
├── settings.gd          # Ayarlar ekranı
├── name_input.gd        # Oyuncu isim girişi
├── textures/            # Duvar ve zemin texture dosyaları
├── sounds/              # Ses efektleri ve müzik
├── models/              # 3D model dosyaları
└── jumpscare/           # Jumpscare video dosyası
```

---

##  Algoritma — Recursive Backtracker

1. NxM grid oluşturulur, tüm duvarlar kapalı başlar
2. Rastgele bir hücreden başlanır
3. Ziyaret edilmemiş rastgele bir komşuya geçilir
4. Geçilen hücreler arasındaki duvar kaldırılır
5. Çıkısız kalınırsa önceki hücreye geri dönülür (backtrack)
6. Tüm hücreler ziyaret edilince labirent tamamdır

Level arttıkça labirent büyür: `genişlik = yükseklik = 6 + level`

---

##  Skor Hesabı

```
Level Skoru = Süre Bonusu + İşaret Bonusu + 1000

Süre Bonusu   = max(0, 300 - geçen_süre) × 10
İşaret Bonusu = (3 - kullanılan_işaret) × 500
```

> Not: Survival modunda süre bonusu hesaplanmaz.

---

##  Uyarı

Bu oyun **jumpscare** içermektedir!

---

##  Lisans

Bu proje OSTİM Teknik Üniversitesi GRS 202 Sektörel Proje kapsamında geliştirilmiştir.
