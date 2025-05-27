// OnboardingManager.swift
import SwiftUI
import Combine // Jika Anda menggunakan Combine untuk hal lain, jika tidak bisa dihapus
import Foundation // Untuk AppStorage

// Enum untuk mendefinisikan setiap langkah dalam proses onboarding
enum OnboardingStep: CaseIterable, Identifiable {
    case welcome // Langkah 1: Pesan selamat datang awal
    case highlightCreateButton // Langkah 2: Menyorot tombol "Create Table" di DashboardView
    case highlightTableTitleField // Langkah 3: Menyorot field "Title" di modal CreateTableView
    // case highlightSubjectAmount // Contoh langkah selanjutnya
    // case ... tambahkan langkah lain sesuai alur dari gambar Anda
    case finished // Status untuk menandakan semua langkah onboarding telah selesai

    var id: Self { self } // Conformance ke Identifiable
}

class OnboardingManager: ObservableObject {
    // Menyimpan status apakah onboarding keseluruhan sudah selesai atau belum.
    // Key diubah untuk memastikan reset jika ada versi sebelumnya.
    @AppStorage("hasCompletedMainOnboarding_v4") var hasCompletedMainOnboarding: Bool = false

    // Menyimpan langkah onboarding saat ini yang sedang aktif.
    // Optional karena bisa jadi nil jika onboarding sudah selesai atau belum dimulai.
    @Published var currentStep: OnboardingStep?

    // Menyimpan frame (posisi dan ukuran) dari elemen UI yang ingin disorot.
    // Default ke .zero jika tidak ada yang disorot.
    @Published var highlightedRect: CGRect = .zero

    init() {
        if !hasCompletedMainOnboarding {
            currentStep = .welcome // Mulai dari langkah 'welcome' jika onboarding belum pernah selesai.
            print("OnboardingManager: Initialized. Starting onboarding at .welcome step.")
        } else {
            currentStep = nil // Onboarding sudah selesai, tidak ada langkah aktif.
            print("OnboardingManager: Initialized. Onboarding previously completed.")
        }
    }

    // Fungsi untuk melanjutkan ke langkah onboarding berikutnya.
    func proceed() {
        guard let currentActiveStep = currentStep else {
            // Jika tidak ada langkah aktif (misalnya, setelah selesai atau di-reset tanpa memulai lagi),
            // dan onboarding belum selesai, maka mulai dari awal.
            if !hasCompletedMainOnboarding {
                currentStep = .welcome
                print("OnboardingManager: No active step, restarting onboarding at .welcome.")
            }
            return
        }

        // Logika transisi antar langkah onboarding
        switch currentActiveStep {
        case .welcome:
            currentStep = .highlightCreateButton
            print("OnboardingManager: Proceeding from .welcome to .highlightCreateButton.")
        case .highlightCreateButton:
            // Aksi ini akan ditangani oleh DashboardView (membuka modal).
            // Kita set step berikutnya di sini agar CreateTableView tahu untuk menampilkan sorotan.
            currentStep = .highlightTableTitleField
            print("OnboardingManager: Proceeding from .highlightCreateButton to .highlightTableTitleField. Modal should be opening.")
        case .highlightTableTitleField:
            // Setelah field judul disorot, dan user (misalnya) menekan "Next" di overlay.
            // Ini adalah akhir dari 3 langkah yang diminta untuk contoh ini.
            // Dalam implementasi penuh, Anda akan lanjut ke step berikutnya.
            print("OnboardingManager: .highlightTableTitleField acknowledged by user. This is the last of the 3 initial steps for now.")
            // Untuk contoh 3 langkah ini, kita akan langsung selesaikan.
            // Jika ada langkah selanjutnya: currentStep = .nextActualStep
             completeOnboardingFlow() // Tandai selesai setelah 3 langkah ini.
        case .finished:
            // Jika sudah di step 'finished', panggil completeOnboardingFlow untuk memastikan.
            completeOnboardingFlow()
            print("OnboardingManager: Already at .finished step.")
        // Anda akan menambahkan case untuk langkah-langkah lain di sini.
        // default:
        //     print("OnboardingManager: Reached an unhandled or unknown step: \(currentActiveStep). Completing flow.")
        //     completeOnboardingFlow()
        }
    }

    // Fungsi untuk menandai seluruh alur onboarding sebagai selesai.
    func completeOnboardingFlow() {
        hasCompletedMainOnboarding = true // Set flag persistensi
        currentStep = nil // Hapus langkah aktif untuk menyembunyikan overlay
        highlightedRect = .zero // Reset frame sorotan
        print("OnboardingManager: Entire onboarding flow marked as completed. Overlay hidden.")
    }

    // Fungsi untuk mereset status onboarding (berguna untuk testing/debugging).
    func resetOnboarding() {
        hasCompletedMainOnboarding = false
        currentStep = .welcome // Kembali ke langkah awal
        highlightedRect = .zero
        print("OnboardingManager: Onboarding has been reset. Current step is .welcome.")
    }

    // Fungsi yang dipanggil oleh View untuk memberitahu manager tentang frame elemen yang akan disorot.
    func setHighlight(rect: CGRect, forStep step: OnboardingStep) {
        // Hanya update jika step saat ini sesuai dengan step yang mengirimkan frame,
        // dan frame-nya berbeda untuk menghindari re-render yang tidak perlu.
        if currentStep == step && highlightedRect != rect {
            self.highlightedRect = rect
            print("OnboardingManager: Highlight rectangle updated for step \(step) to \(rect).")
        } else if currentStep == step && highlightedRect == rect {
            // print("OnboardingManager: Highlight rectangle is the same for step \(step). No update.")
        }
    }
}
