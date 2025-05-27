// CustomOnboardingOverlayView.swift
import SwiftUI

struct CustomOnboardingOverlayView: View {
    @ObservedObject var onboardingManager: OnboardingManager
    
    // Teks spesifik untuk setiap langkah onboarding
    let instructionText: String
    
    // Apakah perlu membuat "lubang" pada overlay untuk menyorot elemen
    let showHighlightArea: Bool
    
    // Apakah tap di mana saja pada overlay akan melanjutkan ke langkah berikutnya (misalnya, untuk pesan selamat datang)
    let canTapAnywhereToProceed: Bool
    
    // Teks untuk tombol "Lanjut" atau "Berikutnya" jika diperlukan
    let nextButtonLabel: String?
    
    // Aksi yang dijalankan ketika tombol "Lanjut" ditekan
    let onNextButtonAction: (() -> Void)?

    // Radius sudut untuk area yang disorot (lubang)
    private let highlightCornerRadius: CGFloat = 12
    // Padding di sekitar elemen yang disorot untuk membuatnya lebih terlihat
    private let highlightPadding: EdgeInsets = EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8)

    var body: some View {
        ZStack {
            // Lapisan latar belakang gelap transparan
            Color.black.opacity(0.7) // Opasitas bisa disesuaikan
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    if canTapAnywhereToProceed {
                        onboardingManager.proceed() // Lanjut jika bisa tap di mana saja
                    }
                    // Jika ada tombol "Next", tap di luar tombol tidak melakukan apa-apa,
                    // kecuali Anda ingin fungsionalitas lain (misalnya, dismiss tip sementara).
                }
                // Menerapkan efek "lubang" (mask)
                .mask(
                    Rectangle() // Bentuk dasar mask adalah seluruh layar
                        .overlay(
                            // Hanya buat lubang jika showHighlightArea true dan highlightedRect valid
                            (showHighlightArea && onboardingManager.highlightedRect != .zero) ?
                            // Bentuk lubangnya (misalnya, RoundedRectangle)
                            RoundedRectangle(cornerRadius: highlightCornerRadius)
                                .fill(Color.white) // Warna tidak penting, hanya untuk blending mask
                                .frame(
                                    width: onboardingManager.highlightedRect.width + highlightPadding.leading + highlightPadding.trailing,
                                    height: onboardingManager.highlightedRect.height + highlightPadding.top + highlightPadding.bottom
                                )
                                .position(
                                    x: onboardingManager.highlightedRect.midX,
                                    y: onboardingManager.highlightedRect.midY
                                )
                                .blendMode(.destinationOut) // Ini yang "melubangi" lapisan gelap
                            : nil // Tidak ada lubang jika tidak perlu
                        )
                )

            // Konten teks instruksi dan tombol (jika ada)
            VStack(spacing: 20) { // Jarak antar teks dan tombol
                Spacer() // Mendorong konten ke bawah jika sorotan ada di atas, atau sebaliknya

                Text(instructionText)
                    .font(.system(size: 19, weight: .medium, design: .default)) // Font yang jelas
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30) // Padding horizontal agar teks tidak terlalu lebar
                    .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 1) // Sedikit shadow untuk keterbacaan

                // Tombol "Lanjut" jika ada label dan aksi yang diberikan
                if let label = nextButtonLabel, let action = onNextButtonAction {
                    Button(action: action) {
                        Text(label)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.accentColor) // Gunakan accent color untuk tombol
                            .padding(.horizontal, 28)
                            .padding(.vertical, 12)
                            .background(.thinMaterial) // Background modern (iOS 15+)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                } else if canTapAnywhereToProceed && onboardingManager.currentStep == .welcome {
                    // Tambahan teks "Tap anywhere" khusus untuk step welcome jika tidak ada tombol Next
                     Text("(Tap anywhere to continue)")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 4)
                }
                
                Spacer() // Mendorong konten ke atas jika sorotan ada di bawah
            }
            // Atur posisi VStack konten berdasarkan posisi sorotan
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, calculateTextContainerVerticalPadding().top)
            .padding(.bottom, calculateTextContainerVerticalPadding().bottom)
            
        }
        // Transisi untuk muncul dan hilangnya overlay
        .transition(.opacity.animation(.easeInOut(duration: 0.35)))
        // Animasikan perubahan pada highlightedRect untuk pergerakan sorotan yang mulus
        .animation(.interpolatingSpring(stiffness: 120, damping: 15), value: onboardingManager.highlightedRect)
    }

    // Fungsi untuk menghitung padding vertikal agar teks tidak overlap dengan area sorotan
    private func calculateTextContainerVerticalPadding() -> (top: CGFloat, bottom: CGFloat) {
        let defaultTopPadding: CGFloat = 80
        let defaultBottomPadding: CGFloat = 80
        let spacingFromHighlight: CGFloat = 30 // Jarak minimal antara teks dan sorotan

        guard showHighlightArea, onboardingManager.highlightedRect != .zero else {
            // Jika tidak ada sorotan (misalnya, untuk step welcome), seimbangkan padding
            return (UIScreen.main.bounds.height * 0.3, UIScreen.main.bounds.height * 0.3)
        }

        let highlightRect = onboardingManager.highlightedRect
        let screenHeight = UIScreen.main.bounds.height
        
        // Jika sorotan ada di paruh atas layar, tempatkan teks di bawahnya
        if highlightRect.midY < screenHeight / 2 {
            let topPadding = highlightRect.maxY + spacingFromHighlight
            return (max(defaultTopPadding, topPadding), defaultBottomPadding)
        } else { // Jika sorotan ada di paruh bawah layar, tempatkan teks di atasnya
            let bottomPadding = screenHeight - highlightRect.minY + spacingFromHighlight
            return (defaultTopPadding, max(defaultBottomPadding, bottomPadding))
        }
    }
}

// Preview Provider
struct CustomOnboardingOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        // Buat instance OnboardingManager untuk preview
        let manager = OnboardingManager()
        // Atur state manager untuk berbagai skenario preview
        manager.currentStep = .highlightCreateButton // Coba ganti ke .welcome atau .highlightTableTitleField
        manager.highlightedRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY - 100, width: 250, height: 60) // Contoh rect

        return ZStack {
            // Latar belakang dummy untuk preview
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            Text("Your App Content Here")
                .padding()
                .background(Color.yellow)
                .position(x: manager.highlightedRect.midX, y: manager.highlightedRect.midY)


            // Contoh penggunaan CustomOnboardingOverlayView
            if let step = manager.currentStep {
                 CustomOnboardingOverlayView(
                    onboardingManager: manager,
                    instructionText: {
                        switch step {
                            case .welcome: return "Welcome to Cram! Tap anywhere to discover how to get started."
                            case .highlightCreateButton: return "This is the 'Create Table' button. Tap it to begin organizing your study subjects."
                            case .highlightTableTitleField: return "First, give your new study table a descriptive title here."
                            default: return "Follow the instructions."
                        }
                    }(),
                    showHighlightArea: step != .welcome, // Jangan highlight untuk welcome
                    canTapAnywhereToProceed: step == .welcome,
                    nextButtonLabel: (step == .highlightCreateButton || step == .highlightTableTitleField) ? "Next" : nil, // Tombol "Next" untuk step tertentu
                    onNextButtonAction: (step == .highlightCreateButton || step == .highlightTableTitleField) ? { manager.proceed() } : nil
                )
            }
        }
    }
}
