import Foundation
import TipKit // Penting: Import TipKit

// Pastikan Anda menargetkan iOS 17 atau lebih baru untuk menggunakan TipKit
@available(iOS 17.0, *)
struct WelcomeTip: Tip {
    var title: Text {
        Text("Welcome to Cram")
    }
    var message: Text? {
        Text("Tap anywhere to continue.")
    }
    // Tidak ada rules atau events spesifik di sini karena ini custom overlay
    // Akan diatur oleh OnboardingManager
}

@available(iOS 17.0, *)
struct CreateTableButtonTip: Tip {
    static let didTapWelcome = Event(id: "didTapWelcome") // Event dari langkah sebelumnya

    var title: Text {
        Text("Start Here")
    }
    var message: Text? {
        Text("To get started, tap the 'Create Table' button.")
    }
    var image: Image? {
        Image(systemName: "plus.circle.fill")
    }

    var rules: [Rule] {
        // Tampilkan tip ini hanya jika event didTapWelcome sudah terjadi dan belum selesai
        #Rule(Self.didTapWelcome) { $0.donations.count > 0 }
    }
}

@available(iOS 17.0, *)
struct TableTitleInputTip: Tip {
    static let didTapCreateTable = Event(id: "didTapCreateTable") // Event dari langkah sebelumnya (modal dibuka)

    var title: Text {
        Text("Give Your Table a Title")
    }
    var message: Text? {
        Text("Begin by giving your study table a descriptive title, like 'IELTS Preparation' or 'Daily Journal'.")
    }
    var image: Image? {
        Image(systemName: "text.cursor")
    }

    var rules: [Rule] {
        #Rule(Self.didTapCreateTable) { $0.donations.count > 0 }
    }
}

@available(iOS 17.0, *)
struct SubjectAmountTip: Tip {
    static let didInputTableTitle = Event(id: "didInputTableTitle") // Event dari langkah sebelumnya (judul diisi)

    var title: Text {
        Text("Set Number of Subjects")
    }
    var message: Text? {
        Text("Now, set the number of topics. Tap '+' to increase or '-' to decrease.")
    }
    var image: Image? {
        Image(systemName: "plusminus.circle.fill")
    }

    var rules: [Rule] {
        #Rule(Self.didInputTableTitle) { $0.donations.count > 0 }
    }
}

@available(iOS 17.0, *)
struct SubjectTitlesInputTip: Tip {
    static let didChangeSubjectAmount = Event(id: "didChangeSubjectAmount") // Event dari langkah sebelumnya (jumlah subjek diubah)

    var title: Text {
        Text("Name Your Subjects")
    }
    var message: Text? {
        Text("Great! Now, let's give each one a name. Tap on each field below to enter the topic titles (e.g., 'Listening', 'Reading').")
    }
    var image: Image? {
        Image(systemName: "list.bullet.rectangle.portrait.fill")
    }

    var rules: [Rule] {
        #Rule(Self.didChangeSubjectAmount) { $0.donations.count > 0 }
    }
}

@available(iOS 17.0, *)
struct CreateButtonTip: Tip {
    static let didInputSubjectTitles = Event(id: "didInputSubjectTitles") // Event dari langkah sebelumnya (judul subjek diisi)

    var title: Text {
        Text("Create Your Table")
    }
    var message: Text? {
        Text("Tap 'Create' to finalize your new study table.")
    }
    var image: Image? {
        Image(systemName: "checkmark.circle.fill")
    }

    var rules: [Rule] {
        #Rule(Self.didInputSubjectTitles) { $0.donations.count > 0 }
    }
}

@available(iOS 17.0, *)
struct TableCreatedSuccessTip: Tip {
    static let didCreateTable = Event(id: "didCreateTable") // Event dari langkah sebelumnya (tabel berhasil dibuat)

    var title: Text {
        Text("Excellent! You're Ready!")
    }
    var message: Text? {
        Text("Your new study table and its subjects have been created. You're ready to start tracking!")
    }
    var image: Image? {
        Image(systemName: "star.fill")
    }

    var rules: [Rule] {
        #Rule(Self.didCreateTable) { $0.donations.count > 0 }
    }
}

@available(iOS 17.0, *)
struct AddSessionButtonTip: Tip {
    static let didSeeTableCreatedSuccess = Event(id: "didSeeTableCreatedSuccess") // Event dari langkah sebelumnya (tip sukses dilihat)

    var title: Text {
        Text("Log Your Progress")
    }
    var message: Text? {
        Text("Tap the '+ Add Session' button to start tracking your study progress.")
    }
    var image: Image? {
        Image(systemName: "plus.square.fill")
    }

    var rules: [Rule] {
        #Rule(Self.didSeeTableCreatedSuccess) { $0.donations.count > 0 }
    }
}

@available(iOS 17.0, *)
struct SelectTopicTip: Tip {
    static let didTapAddSession = Event(id: "didTapAddSession") // Event dari langkah sebelumnya (modal add session dibuka)

    var title: Text {
        Text("Choose a Subject")
    }
    var message: Text? {
        Text("Select the topic you worked on from the dropdown.")
    }
    var image: Image? {
        Image(systemName: "menucard.fill")
    }

    var rules: [Rule] {
        #Rule(Self.didTapAddSession) { $0.donations.count > 0 }
    }
}

@available(iOS 17.0, *)
struct AdjustSliderTip: Tip {
    static let didSelectTopic = Event(id: "didSelectTopic") // Event dari langkah sebelumnya (topik dipilih)

    var title: Text {
        Text("Rate Your Session")
    }
    var message: Text? {
        Text("How effective was this session? Use the slider below to give it a rating.")
    }
    var image: Image? {
        Image(systemName: "slider.horizontal.3")
    }

    var rules: [Rule] {
        #Rule(Self.didSelectTopic) { $0.donations.count > 0 }
    }
}

@available(iOS 17.0, *)
struct SaveSessionTip: Tip {
    static let didAdjustSlider = Event(id: "didAdjustSlider") // Event dari langkah sebelumnya (slider digerakkan)

    var title: Text {
        Text("Save Your Progress")
    }
    var message: Text? {
        Text("Tap 'Save' to log your hard work.")
    }
    var image: Image? {
        Image(systemName: "square.and.arrow.down.fill")
    }

    var rules: [Rule] {
        #Rule(Self.didAdjustSlider) { $0.donations.count > 0 }
    }
}

@available(iOS 17.0, *)
struct AllDoneTip: Tip {
    static let didSaveSession = Event(id: "didSaveSession") // Event dari langkah sebelumnya (sesi disimpan)

    var title: Text {
        Text("All Done! Happy Studying!")
    }
    var message: Text? {
        Text("Your hard work is logged, and your progress chart now reflects this session. Keep up the great work!")
    }
    var image: Image? {
        Image(systemName: "hand.thumbsup.fill")
    }

    var rules: [Rule] {
        #Rule(Self.didSaveSession) { $0.donations.count > 0 }
    }
}
