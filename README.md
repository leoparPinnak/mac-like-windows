# 🪟 Mac-Like-Windows: macOS to Windows Keyboard & Mouse Adaptation Report

> **Transform macOS keyboard shortcuts, navigation, and mouse scrolling into an exact Windows experience.**  
> *Zero background daemons, zero external applications, 100% native macOS kernel & framework configurations.*

[![macOS](https://img.shields.io/badge/Platform-macOS%20ARM64%20%7C%20x86__64-black.svg?logo=apple)](https://apple.com/macos)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 📌 Executive Summary / Yönetici Özeti

Hem Windows hem de macOS kullanan kullanıcıların en büyük zorluğu **kas hafızası çatışmasıdır (muscle memory conflict)**:
1. **Kopyala-Yapıştır ve Kısayollar:** Windows'ta sol alt köşedeki `Ctrl` tuşuna basılırken, Mac'te başparmakla `Command (⌘)` tuşuna basmak gerekir.
2. **Ters Kaydırma (Natural Scrolling):** macOS varsayılan olarak fare tekerleğini ters çalıştırır (aşağı kaydırınca sayfa yukarı gider).
3. **Home & End Tuşları:** Windows'ta satır başına/sonuna giden tuşlar Mac'te tüm sayfayı aşağı/yukarı kaydırır.
4. **Uygulama Geçişi:** `Alt + Tab` ve `Cmd + Tab` konum farklılıkları.

Bu proje, üçüncü parti ağır uygulamalar (Karabiner vb.) kurmaya gerek kalmadan, macOS'in kendi yerel çekirdek araçları (`hidutil`, `defaults`, `DefaultKeyBinding.dict` ve `LaunchAgent`) ile Mac'inizi **tamamen Windows gibi** çalıştırmayı sağlar.

---

## 🛠️ Yapılan Teknik Değişiklikler ve Mimari Raporu

### 1. ⌨️ Sol ve Sağ Control Tuşlarının Dönüştürülmesi (hidutil)
* **HID Mapping:** Sol fiziksel Control tuşu (`0x7000000E0`) ve Sağ Control tuşu (`0x7000000E4`), doğrudan Mac'in Command tuşlarına (`0x7000000E3` ve `0x7000000E7`) eşlendi.
* **Sonuç:** Serçe parmağınızla Windows'taki gibi:
  - `Ctrl + C` ➔ Kopyala
  - `Ctrl + V` ➔ Yapıştır
  - `Ctrl + X` ➔ Kes
  - `Ctrl + Z` ➔ Geri Al
  - `Ctrl + A` ➔ Tümünü Seç
  - `Ctrl + S` ➔ Kaydet
  - `Ctrl + F` ➔ Bul
  - `Ctrl + W` ➔ Sekme / Pencere Kapat
  - `Ctrl + T` ➔ Yeni Sekme
  - `Ctrl + R` ➔ Yenile

### 2. 🖱️ Ters Kaydırma (Scroll Inversion) Düzeltmesi
* **WindowServer Ayarı:**
  ```bash
  defaults write -g com.apple.swipescrolldirection -bool false
  ```
* **Sonuç:** Fare tekerleğini kendinize (aşağı) çevirdiğinizde sayfa geleneksel Windows mantığıyla **aşağı**, yukarı çevirdiğinizde **yukarı** hareket eder.

### 3. 📄 Home ve End Tuşlarının Düzeltilmesi (Cocoa Text System)
* **Dosya:** `~/Library/KeyBindings/DefaultKeyBinding.dict`
* **Sonuç:**
  - `Home` ➔ Sayfayı kaydırmaz, imleci **satır başına** götürür.
  - `End` ➔ İmleci **satır sonuna** götürür.
  - `Shift + Home` / `Shift + End` ➔ İlgili satırı başa/sona kadar seçer.

### 4. 🔄 Kalıcılık (Persistence via LaunchAgent)
* macOS'te `hidutil` ayarları yeniden başlatmalarda sıfırlanır. Bunu önlemek için `~/Library/LaunchAgents/com.local.KeyMapping.plist` servisi oluşturuldu. Mac her açıldığında ayarlar arka planda otomatik yüklenir.

### 5. 💻 Orijinal Terminal Control Tuşu (SIGINT)
* Gerçek Mac Control tuşu Windows tuşunun (`Option`) olduğu yere taşındı. Terminalde çalışan bir işlemi durdurmak istediğinizde (`Ctrl + C` / SIGINT), klavyedeki orta tuş + C kombinasyonunu kullanabilirsiniz.

---

## ⚡ Hızlı Kurulum (One-Line Setup)

Terminali açıp şu komutları çalıştırmanız yeterlidir:

```bash
git clone https://github.com/leoparPinnak/mac-like-windows.git
cd mac-like-windows
chmod +x setup.sh restore.sh
./setup.sh
```

---

## 🔄 Fabrika Ayarlarına Geri Dönüş (Restore)

İstediğiniz zaman tek bir komutla orijinal Apple klavye ve fare düzenine dönebilirsiniz:

```bash
./restore.sh
```

---

## 📊 Kısayol Karşılaştırma Tablosu

| İşlem | Orijinal Mac | Mac-Like-Windows Modu | Windows Davranışı |
| :--- | :---: | :---: | :---: |
| **Kopyala** | `Cmd + C` | **`Ctrl + C`** | `Ctrl + C` |
| **Yapıştır** | `Cmd + V` | **`Ctrl + V`** | `Ctrl + V` |
| **Geri Al** | `Cmd + Z` | **`Ctrl + Z`** | `Ctrl + Z` |
| **Tümünü Seç** | `Cmd + A` | **`Ctrl + A`** | `Ctrl + A` |
| **Kaydet** | `Cmd + S` | **`Ctrl + S`** | `Ctrl + S` |
| **Sekme Kapat** | `Cmd + W` | **`Ctrl + W`** | `Ctrl + W` |
| **Satır Başına Git** | `Cmd + Sol Ok` | **`Home`** | `Home` |
| **Satır Sonuna Git** | `Cmd + Sağ Ok` | **`End`** | `End` |
| **Fare Tekerleği Aşağı** | Sayfa Yukarı | **Sayfa Aşağı** | Sayfa Aşağı |

---

## 📄 Lisans
Bu proje [MIT Lisansı](LICENSE) ile korunmaktadır.
