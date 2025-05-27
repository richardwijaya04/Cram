# Cram: Your Smart Study Progress Tracker 🚀

[![Swift Version](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org/)
[![Platform](https://img.shields.io/badge/Platform-iOS%2016%2B-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple.svg)](https://developer.apple.com/xcode/swiftui/)
[![Architecture](https://img.shields.io/badge/Architecture-MVVM-green.svg)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE) <p align="center">
  <img src="LINK_KE_SCREENSHOT_UTAMA_ATAU_LOGO_CRAM.png" alt="Cram App Showcase" width="300"/>
  </p>

Cram adalah aplikasi iOS modern dan intuitif yang dirancang untuk membantu siswa dan pembelajar melacak kemajuan studi mereka secara efektif dan menyenangkan. Dengan visualisasi progres yang dinamis dan fitur pencatatan yang mudah, Cram memastikan Anda tetap termotivasi dan fokus pada tujuan belajar Anda.

---

## ✨ Fitur Unggulan (Key Features)

* 📊 **Visualisasi Progres Dinamis:** Nikmati progress bar interaktif dengan efek teks yang berubah warna secara _real-time_ seiring kemajuan Anda. Sangat memuaskan!
* 📚 **Manajemen Tabel & Topik Fleksibel:**
    * Buat "Tabel" untuk setiap mata pelajaran atau area studi (misalnya, "Persiapan Ujian Kalkulus", "Belajar Bahasa Jepang").
    * Tambahkan "Topik" di dalam setiap tabel untuk materi atau bab spesifik (misalnya, "Turunan & Integral", "Tata Bahasa Bab 1-5").
    * Edit dan kelola struktur belajar Anda dengan mudah.
* ⏱️ **Pencatatan Sesi Belajar Cerdas:**
    * Catat setiap sesi belajar dengan cepat, pilih topik, dan masukkan persentase kemajuan yang dicapai.
    * Lihat progres Anda bertambah secara instan.
* 📜 **Riwayat Progres Detail:**
    * Setiap sesi belajar dan perubahan progres dicatat dengan timestamp.
    * Akses riwayat lengkap untuk setiap topik untuk melihat perjalanan belajar Anda.
* 🔥 **Study Streak (Konsep):**
    * Dirancang untuk menampilkan jumlah hari belajar berturut-turut, memotivasi konsistensi. *(Logika perhitungan streak kompleks masih dalam pengembangan/penyederhanaan untuk demo ini)*.
* 💾 **Persistensi Data Lokal Handal:**
    * Semua tabel, topik, dan riwayat progres Anda tersimpan aman di perangkat menggunakan `Codable` dengan JSON dan `UserDefaults`. Data tidak akan hilang bahkan setelah aplikasi ditutup.
* 👋 **Onboarding Pengguna yang Ramah:**
    * Panduan singkat saat pertama kali membuka aplikasi untuk membantu pengguna memulai dengan cepat.
* 💡 **Integrasi TipKit (iOS 17+):**
    * Tips kontekstual muncul untuk memandu pengguna dan memperkenalkan fitur secara bertahap.
* 🎨 **Desain Modern dengan SwiftUI:**
    * Dibangun sepenuhnya menggunakan SwiftUI, menghasilkan UI yang bersih, responsif, dan _native_ iOS.
* 🖋️ **Tipografi Elegan:** Menggunakan custom font "Lexend" untuk keterbacaan dan estetika yang lebih baik.

---

## 🛠️ Teknologi yang Digunakan (Tech Stack)

* **Bahasa Pemrograman:** Swift 5.9+
* **UI Framework:** SwiftUI
* **Arsitektur Pola Desain:** MVVM (Model-View-ViewModel)
* **Persistensi Data:**
    * `Codable` protocol untuk serialisasi/deserialisasi data.
    * Penyimpanan file JSON di direktori Dokumen aplikasi untuk data tabel & topik.
    * `UserDefaults` untuk data preferensi sederhana (status onboarding, streak, dll.).
* **Fitur iOS Modern:** TipKit (memerlukan iOS 17+ untuk tampilan tips).
* **Concurrency:** Penggunaan `Task` untuk operasi asinkron (misalnya, donasi event TipKit).
* **Manajemen Dependensi:** Swift Package Manager (jika ada dependensi eksternal di masa depan).

---

## 📸 Tampilan Aplikasi (Screenshots & GIFs)

<table>
  <tr>
    <td><img src="readme-assets/dashboard-view.png" alt="Dashboard View" width="200"/></td>
    <td><img src="readme-assets/add-session-view.png" alt="Add Session View" width="200"/></td>
    <td><img src="readme-assets/edit-table-view.png" alt="Edit Table View" width="200"/></td>
  </tr>
  <tr>
    <td align="center"><em>Dashboard Utama</em></td>
    <td align="center"><em>Menambah Sesi Belajar</em></td>
    <td align="center"><em>Mengedit Tabel</em></td>
  </tr>
  <tr>
    <td><img src="readme-assets/topic-history-view.png" alt="Topic History View" width="200"/></td>
    <td><img src="readme-assets/progressbar-effect.gif" alt="Progress Bar Effect GIF" width="200"/></td>
    <td><img src="readme-assets/onboarding-view.png" alt="Onboarding View" width="200"/></td>
  </tr>
  <tr>
    <td align="center"><em>Riwayat Topik</em></td>
    <td align="center"><em>Efek Progress Bar Keren!</em></td>
    <td align="center"><em>Onboarding Pengguna</em></td>
  </tr>
</table>

---

## 🚀 Cara Menjalankan Proyek (How to Run)

1.  **Prasyarat:**
    * macOS dengan Xcode 15.0 atau lebih baru.
    * Git terinstal.
2.  **Clone Repositori:**
    ```bash
    git clone [https://github.com/](https://github.com/)[NAMA_USER_GITHUB_ANDA]/[NAMA_REPOSITORI_ANDA].git
    cd [NAMA_REPOSITORI_ANDA]
    ```
3.  **Buka Proyek:**
    * Buka file `Cram.xcodeproj` menggunakan Xcode.
4.  **Pilih Target:**
    * Pilih simulator iOS (misalnya, iPhone 15 Pro dengan iOS 17.0 untuk melihat TipKit) atau perangkat iOS fisik.
5.  **Build & Run:**
    * Tekan `Cmd+R` atau klik tombol Play di Xcode.

---

## 🤔 Tantangan & Pembelajaran

* **Implementasi `ProgressBarView` yang Dinamis:** Menciptakan efek teks yang berubah warna secara presisi mengikuti animasi progress bar adalah tantangan menarik. Ini melibatkan kalkulasi posisi karakter dan sinkronisasi dengan state `currentProgress` menggunakan `GeometryReader` dan estimasi lebar karakter.
* **Manajemen State dengan SwiftUI:** Mengelola alur data dan state antar-View (Dashboard, Modal Create/Edit/Add Session) secara efisien menggunakan `@StateObject`, `@ObservedObject`, dan `@Published` dalam arsitektur MVVM.
* **Persistensi Data `Codable`:** Mendesain model data (`Table`, `Topic`, `ProgressUpdateEvent`) agar `Codable` dan mengelola proses encoding/decoding (termasuk `Date`) untuk penyimpanan file JSON yang handal.
* **Logika Pembaruan Histori:** Memastikan bahwa setiap perubahan progres, baik melalui penambahan sesi maupun pengeditan langsung, tercatat dengan benar dalam `history` setiap topik.

Proyek ini secara signifikan meningkatkan pemahaman saya tentang pengembangan aplikasi iOS modern dengan SwiftUI, manajemen state, persistensi data, dan pembuatan UI yang interaktif.

---

## 🔮 Rencana Pengembangan Selanjutnya (Future Enhancements)

* [ ] **Sinkronisasi iCloud:** Memungkinkan pengguna menyinkronkan data mereka di berbagai perangkat Apple.
* [ ] **Widget iOS:** Menampilkan progres atau study streak di Home Screen.
* [ ] **Notifikasi & Pengingat:** Pengingat kustom untuk sesi belajar.
* [ ] **Tema Kustomisasi:** Pilihan tema terang/gelap atau aksen warna.
* [ ] **Grafik & Statistik Progres:** Visualisasi data progres dalam bentuk grafik (mingguan/bulanan).
* [ ] **Unit Testing & UI Testing:** Meningkatkan kualitas dan keandalan kode.

---

## 🧑‍💻 Kontributor / Pembuat

* **[Nama Lengkap Anda]**
    * GitHub: `[@username_github_anda](https://github.com/[username_github_anda])`
    * LinkedIn: `[Nama Anda di LinkedIn](LINK_PROFIL_LINKEDIN_ANDA)`
    * Email: `alamat.email@anda.com` (Opsional)

---

## 📄 Lisensi

Proyek ini dilisensikan di bawah Lisensi MIT. Lihat file `LICENSE.md` untuk detailnya.

---

Terima kasih telah mengunjungi repositori Cram! Jangan ragu untuk memberikan bintang ⭐ jika Anda merasa proyek ini menarik atau bermanfaat.
