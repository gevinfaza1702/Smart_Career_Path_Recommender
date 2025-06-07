# Smart Career Path Recommender

Proyek ini bertujuan memberikan rekomendasi karier berdasarkan skill yang dipilih pengguna. Aplikasi terdiri dari backend Flask dan frontend Flutter yang saling terhubung melalui REST API.

## Arsitektur

```
smart_career_path_recommender/
├── backend/            # kode Python Flask
│   ├── app.py          # REST API `/predict-career`
│   ├── recommender.py  # logika pemetaan skill ke karier
│   ├── job_scraper.py  # contoh scraper Glints
│   ├── skill_extractor.py  # ekstraksi skill dari jobs.csv
│   └── requirements.txt
└── frontend_flutter/   # project Flutter
    └── lib/
        ├── api_service.dart
        └── recommendation_page.dart
```

Backend menerima daftar skill melalui endpoint `/predict-career` lalu mengembalikan prediksi karier beserta rekomendasi belajar. Frontend Flutter menampilkan checkbox skill dan memanggil API tersebut.

## Menjalankan Backend

```bash
cd smart_career_path_recommender/backend
pip install -r requirements.txt
python app.py  # server berjalan di http://localhost:5000
```

## Menjalankan Frontend

```bash
cd smart_career_path_recommender/frontend_flutter
flutter pub get
flutter run            # jalankan pada emulator/device aktif
```

## Deploy ke Emulator

1. Pastikan Android emulator telah terpasang (misal melalui Android Studio).
2. Jalankan perintah berikut untuk melihat daftar emulator:

   ```bash
   flutter emulators
   ```
3. Luncurkan salah satu emulator:

   ```bash
   flutter emulators --launch <id_emulator>
   ```
4. Setelah emulator aktif, jalankan aplikasi Flutter:

   ```bash
   flutter run
   ```

Backend harus sudah berjalan agar halaman `RecommendationPage` dapat memperoleh hasil dari API.
