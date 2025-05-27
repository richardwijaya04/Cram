import SwiftUI
import TipKit // Penting: Import TipKit

@main
struct CramApp: App {
    // Inisialisasi OnboardingManager sebagai StateObject di level App
    // agar status onboarding bisa diakses dan dipertahankan di seluruh aplikasi.
    @StateObject private var onboardingManager = OnboardingManager()

    init() {
        // Hanya jalankan konfigurasi TipKit jika di iOS 17 atau lebih baru.
        if #available(iOS 17.0, *) {
            do {
                try Tips.configure([
                    .displayFrequency(.immediate) // Tampilkan tips sesering mungkin untuk onboarding
                    // .datastoreLocation(.applicationStorage) // Menggunakan lokasi penyimpanan default untuk menghindari error
                ])
                // Untuk debugging: Jika Anda ingin mereset semua tips dan status onboarding untuk tujuan pengembangan/debugging,
                // uncomment baris di bawah ini. Pastikan untuk mengomentarinya kembali sebelum rilis ke produksi.
                // Task { await Tips.resetDatastore() }
                // onboardingManager.resetOnboarding() // Reset status onboarding di UserDefaults
                print("TipKit configured successfully with default storage.")
            } catch {
                print("Failed to configure TipKit: \(error.localizedDescription)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Menyediakan OnboardingManager ke environment
                // agar semua View yang membutuhkannya bisa mengaksesnya.
                .environmentObject(onboardingManager)
        }
    }
}
