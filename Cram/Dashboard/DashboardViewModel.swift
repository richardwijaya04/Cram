// DashboardViewModel.swift
import Foundation
import SwiftUI // Untuk @Published
import TipKit // Tambahkan ini

class DashboardViewModel: ObservableObject {
    @Published var streakDays: Int = 0 {
        didSet {
            // Kita bisa panggil saveData() di sini jika streakDays sering diupdate terpisah
            // Tapi untuk sekarang, kita akan panggil saveData() pada aksi utama lainnya
        }
    }
    @Published var tables: [Table] = []
    @Published var selectedTableIndex: Int? = nil // Ubah ke nil sebagai default yang lebih aman

    @Published var showCreateTableModal: Bool = false
    @Published var showEditTableModal: Bool = false
    @Published var showAddSessionModal: Bool = false
    @Published var showTopicHistoryModal: Bool = false

    @Published var createTableData: CreateTableModel = CreateTableModel()
    @Published var editTableData: EditTableModel = EditTableModel()
    @Published var selectedTopicForHistory: Topic? = nil
    @Published var selectedTopicForAddSession: Topic? = nil
    // showOnboarding akan tetap menggunakan UserDefaults secara langsung saat init
    @Published var showOnboarding: Bool

    // URL untuk file penyimpanan data tabel
    private var tablesFileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("cramTablesData.json")
    }

    // Keys untuk UserDefaults
    private let streakDaysKey = "streakDaysKey"
    private let selectedTableIndexKey = "selectedTableIndexKey"
    private let hasCompletedOnboardingKey = "hasCompletedOnboarding"

    init() {
        // Inisialisasi showOnboarding dari UserDefaults
        self.showOnboarding = !UserDefaults.standard.bool(forKey: hasCompletedOnboardingKey)
        
        loadData() // Panggil loadData saat ViewModel diinisialisasi

        // Logika inisialisasi selectedTableIndex setelah data dimuat
        if !tables.isEmpty {
            if selectedTableIndex == nil || selectedTableIndex! >= tables.count {
                selectedTableIndex = 0 // Default ke tabel pertama jika tidak valid
            }
        } else {
            selectedTableIndex = nil // Tidak ada tabel, tidak ada yang dipilih
        }
    }

    // MARK: - Data Persistency
    func saveData() {
        // Save Tables to JSON file
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601 // Strategi encoding tanggal yang baik
        do {
            let data = try encoder.encode(tables)
            try data.write(to: tablesFileURL, options: [.atomicWrite])
            print("Tables saved successfully to: \(tablesFileURL)")
        } catch {
            print("Error saving tables: \(error.localizedDescription)")
        }

        // Save streakDays and selectedTableIndex to UserDefaults
        UserDefaults.standard.set(streakDays, forKey: streakDaysKey)
        if let selectedIndex = selectedTableIndex {
            UserDefaults.standard.set(selectedIndex, forKey: selectedTableIndexKey)
        } else {
            UserDefaults.standard.removeObject(forKey: selectedTableIndexKey) // Hapus jika nil
        }
        print("Streak days and selected index saved to UserDefaults.")
    }

    func loadData() {
        // Load Tables from JSON file
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Pastikan konsisten dengan encoding
        do {
            if FileManager.default.fileExists(atPath: tablesFileURL.path) {
                let data = try Data(contentsOf: tablesFileURL)
                tables = try decoder.decode([Table].self, from: data)
                print("Tables loaded successfully from: \(tablesFileURL)")
            } else {
                print("Data file not found. Starting with empty tables.")
                tables = [] // Jika file tidak ada, mulai dengan array kosong
            }
        } catch {
            print("Error loading tables: \(error.localizedDescription)")
            tables = [] // Jika ada error, fallback ke array kosong
        }

        // Load streakDays and selectedTableIndex from UserDefaults
        streakDays = UserDefaults.standard.integer(forKey: streakDaysKey) // Default 0 jika tidak ada
        if UserDefaults.standard.object(forKey: selectedTableIndexKey) != nil {
            selectedTableIndex = UserDefaults.standard.integer(forKey: selectedTableIndexKey)
        } else {
            selectedTableIndex = nil
        }
        print("Streak days and selected index loaded from UserDefaults.")
        
        // showOnboarding sudah di-handle di init() sebelum loadData()
    }


    // MARK: - Table Management
    func createTable() {
        let validTopicNames = createTableData.topicNames.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        let newTopics: [Topic]
        if validTopicNames.isEmpty {
            let defaultTopic = Topic(name: "Default Topic", currentProgress: 0.0, history: [
                ProgressUpdateEvent(progressAdded: 0.0, newTotalProgress: 0.0) // Histori awal
            ])
            newTopics = [defaultTopic]
        } else {
            newTopics = validTopicNames.map { name in
                Topic(name: name, currentProgress: 0.0, history: [
                    ProgressUpdateEvent(progressAdded: 0.0, newTotalProgress: 0.0) // Histori awal
                ])
            }
        }

        let newTable = Table(
            name: createTableData.tableName.isEmpty ? "Untitled Table" : createTableData.tableName,
            topics: newTopics
        )
        tables.append(newTable)
        selectedTableIndex = tables.count - 1
        resetCreateTableData()
        showCreateTableModal = false
        saveData() // <-- SAVE DATA

        if #available(iOS 17.0, *) {
            Task {
                await TableCreatedSuccessTip.didCreateTable.donate()
                print("TipKit: didCreateTable event donated from DashboardViewModel.createTable")
            }
        }
    }

    func cancelCreateTable() {
        resetCreateTableData()
        showCreateTableModal = false
    }

    func prepareEditTable() {
        guard let index = selectedTableIndex, index < tables.count else { return }
        let table = tables[index]
        editTableData.tableID = table.id
        editTableData.tableName = table.name
        // Penting: Buat salinan baru dari Topic agar perubahan pada editTableData tidak langsung mengubah `tables`
        // kecuali saat `saveEditTable` dipanggil.
        editTableData.topics = table.topics.map { topic in
            Topic(id: topic.id, name: topic.name, currentProgress: topic.currentProgress, history: topic.history)
        }
        showEditTableModal = true
    }

    func saveEditTable() {
        guard let tableId = editTableData.tableID,
              let tableIndex = tables.firstIndex(where: { $0.id == tableId }) else {
            showEditTableModal = false
            resetEditTableData()
            return
        }

        let validEditedTopics = editTableData.topics.filter { !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        var finalTopics: [Topic] = []

        // Iterasi melalui topik yang diedit di form
        for var editedTopicFromForm in validEditedTopics {
            // Cari topik asli di state `tables` berdasarkan ID
            if let originalTopicIndex = tables[tableIndex].topics.firstIndex(where: { $0.id == editedTopicFromForm.id }) {
                let originalTopic = tables[tableIndex].topics[originalTopicIndex]
                
                // Jika progress di form berbeda dari progress asli
                if originalTopic.currentProgress != editedTopicFromForm.currentProgress {
                    let progressDelta = editedTopicFromForm.currentProgress - originalTopic.currentProgress
                    // Hanya tambahkan event jika ada perubahan progress aktual
                    if progressDelta != 0 {
                        let event = ProgressUpdateEvent(
                            progressAdded: progressDelta,
                            newTotalProgress: editedTopicFromForm.currentProgress
                        )
                        editedTopicFromForm.history.append(event)
                    }
                }
                // Jika topik sudah ada, histori dari form sudah termasuk histori asli + event baru (jika ada)
                finalTopics.append(editedTopicFromForm)
            } else {
                // Ini adalah topik baru yang ditambahkan melalui form edit
                // Pastikan ada histori awal jika belum ada
                if editedTopicFromForm.history.isEmpty || editedTopicFromForm.history.last?.newTotalProgress != editedTopicFromForm.currentProgress {
                     let event = ProgressUpdateEvent(
                         progressAdded: editedTopicFromForm.currentProgress, // Progress awal adalah progress yang ditambahkan
                         newTotalProgress: editedTopicFromForm.currentProgress
                     )
                     editedTopicFromForm.history.append(event)
                }
                finalTopics.append(editedTopicFromForm)
            }
        }
        
        if finalTopics.isEmpty && !editTableData.topics.isEmpty { // Jika semua nama topik dikosongkan
             let defaultTopic = Topic(name: "Default Topic", currentProgress: 0.0, history: [
                 ProgressUpdateEvent(progressAdded: 0.0, newTotalProgress: 0.0)
             ])
             finalTopics = [defaultTopic]
        } else if finalTopics.isEmpty && editTableData.topics.isEmpty { // Jika memang tidak ada topik (misal dikurangi jadi 0)
            // Biarkan finalTopics kosong, atau bisa juga tambahkan default topic jika itu behavior yang diinginkan
            // Untuk saat ini, kita biarkan kosong jika memang 0 topik yang diinginkan
        }


        tables[tableIndex].name = editTableData.tableName.isEmpty ? "Untitled Table" : editTableData.tableName
        tables[tableIndex].topics = finalTopics

        showEditTableModal = false
        resetEditTableData()
        saveData() // <-- SAVE DATA
    }

    func deleteTable() {
        guard let index = selectedTableIndex, index < tables.count else { return }
        tables.remove(at: index)
        if tables.isEmpty {
            selectedTableIndex = nil
        } else if index >= tables.count { // Jika item terakhir dihapus
            selectedTableIndex = tables.count - 1
        } else {
            // selectedTableIndex tetap, atau bisa di set ke 0 jika mau
            selectedTableIndex = max(0, index, -1) // Coba pilih item sebelumnya atau item pertama
             if tables.isEmpty { selectedTableIndex = nil } else if selectedTableIndex! >= tables.count { selectedTableIndex = 0}

        }
        showEditTableModal = false // Tutup modal setelah delete
        resetEditTableData() // Reset data edit
        saveData() // <-- SAVE DATA
    }

    func cancelEditTable() {
        resetEditTableData()
        showEditTableModal = false
    }

    private func resetCreateTableData() {
        createTableData = CreateTableModel()
    }

    private func resetEditTableData() {
        editTableData = EditTableModel()
    }

    // MARK: - Session Management
    func prepareAddSession(for table: Table) {
        // Tidak perlu set selectedTopicForAddSession di sini, biarkan AddSessionView yang mengelola
        showAddSessionModal = true
    }
    
    // Fungsi ini mungkin tidak lagi diperlukan jika AddSessionView mengelola topiknya sendiri
    // atau bisa digunakan jika ada logika pemilihan topik default sebelum modal tampil.
    func setSelectedTopicForSession(_ topic: Topic?) {
        self.selectedTopicForAddSession = topic
    }

    func recordSession(topicId: UUID, addedProgress: Double) {
        guard let tableIdx = selectedTableIndex, tableIdx < tables.count else { return }
        
        if let topicIdx = tables[tableIdx].topics.firstIndex(where: { $0.id == topicId }) {
            var topic = tables[tableIdx].topics[topicIdx]
            
            let currentTotalProgress = topic.currentProgress
            // Pastikan newTotalProgress tidak melebihi 1.0 atau kurang dari 0.0
            let newTotalProgress = min(1.0, max(0.0, currentTotalProgress + addedProgress))
            
            // Hitung berapa banyak progress yang benar-benar ditambahkan (bisa 0 jika sudah 100%)
            let actualProgressAdded = newTotalProgress - currentTotalProgress

            // Hanya catat dan simpan jika ada perubahan progress aktual,
            // atau jika addedProgress adalah 0 (misal, ingin mencatat sesi belajar tanpa progress)
            // Namun, jika progress 0 ditambahkan dan tidak ada perubahan, mungkin tidak perlu event baru.
            // Kondisi di bawah memastikan event dibuat jika ada perubahan, atau jika explicit 0 progress ditambahkan (walau ini jarang).
            if actualProgressAdded != 0 || (addedProgress == 0 && topic.history.last?.progressAdded != 0) { // Hindari duplikat event 0 progress
                topic.currentProgress = newTotalProgress
                let event = ProgressUpdateEvent(
                    progressAdded: actualProgressAdded,
                    newTotalProgress: newTotalProgress
                )
                topic.history.append(event)
                tables[tableIdx].topics[topicIdx] = topic
                
                // Update streak jika progress bertambah
                if actualProgressAdded > 0 {
                    // Di sini Anda bisa menambahkan logika untuk memperbarui streakDays
                    // Misalnya, jika sesi ini adalah hari baru, streakDays += 1
                    // Untuk sekarang, kita hanya contohkan increment sederhana
                    // streakDays += 1 // Logika streak perlu lebih kompleks (cek tanggal, dll.)
                }

                saveData() // <-- SAVE DATA

                if #available(iOS 17.0, *) {
                    Task {
                        await AllDoneTip.didSaveSession.donate()
                        print("TipKit: didSaveSession event donated from DashboardViewModel.recordSession")
                    }
                }
            }
            showAddSessionModal = false // Tutup modal setelah record
            selectedTopicForAddSession = nil // Reset pilihan topik untuk sesi
        } else {
            print("Error: Topic with ID \(topicId) not found in table \(tables[tableIdx].name)")
            showAddSessionModal = false
            selectedTopicForAddSession = nil
        }
    }

    func cancelAddSession() {
        showAddSessionModal = false
        selectedTopicForAddSession = nil
    }

    // MARK: - Topic History
    func viewTopicHistory(topic: Topic) {
        selectedTopicForHistory = topic
        showTopicHistoryModal = true
    }
    
    func closeTopicHistory() {
        showTopicHistoryModal = false
        selectedTopicForHistory = nil
    }
    
    // MARK: - Onboarding
    func completeOnboarding() {
        showOnboarding = false
        UserDefaults.standard.set(true, forKey: hasCompletedOnboardingKey)
        // Tidak perlu saveData() di sini karena ini hanya state UI
    }
}
