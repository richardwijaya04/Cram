//
//  DashboardModel.swift
//  Cram
//
//  Created by Richard WIjaya Harianto on 24/05/25.
//

import Foundation

// Struktur untuk mencatat setiap pembaruan progres
struct ProgressUpdateEvent: Identifiable, Hashable, Codable { // Tambahkan Codable jika butuh persistensi
    let id: UUID
    let date: Date
    let progressAdded: Double // Seberapa banyak progres ditambahkan pada sesi ini
    let newTotalProgress: Double // Total progres setelah sesi ini

    init(id: UUID = UUID(), date: Date = Date(), progressAdded: Double, newTotalProgress: Double) {
        self.id = id
        self.date = date
        self.progressAdded = progressAdded
        self.newTotalProgress = newTotalProgress
    }
}

// Struktur untuk merepresentasikan satu topik/subjek dalam tabel
struct Topic: Identifiable, Hashable, Codable { // Tambahkan Codable
    let id: UUID
    var name: String
    var currentProgress: Double // Progres saat ini (0.0 hingga 1.0)
    var history: [ProgressUpdateEvent]

    init(id: UUID = UUID(), name: String, currentProgress: Double = 0.0, history: [ProgressUpdateEvent] = []) {
        self.id = id
        self.name = name
        self.currentProgress = currentProgress
        self.history = history
    }

    // Conformance untuk Hashable (jika belum otomatis dari properti)
    static func == (lhs: Topic, rhs: Topic) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.currentProgress == rhs.currentProgress && lhs.history == rhs.history
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(currentProgress)
        hasher.combine(history)
    }
}

// Struktur utama untuk tabel
struct Table: Identifiable, Hashable, Codable { // Tambahkan Codable
    let id: UUID
    var name: String
    var topics: [Topic] // Menggunakan array dari struct Topic

    init(id: UUID = UUID(), name: String, topics: [Topic] = []) {
        self.id = id
        self.name = name
        self.topics = topics
    }

    // Conformance untuk Hashable (jika belum otomatis dari properti)
    static func == (lhs: Table, rhs: Table) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.topics == rhs.topics
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(topics)
    }
}

// Model untuk form pembuatan tabel
struct CreateTableModel {
    var tableName: String = ""
    var numberOfTopics: Int = 1 {
        didSet {
            let currentCount = topicNames.count
            if numberOfTopics > currentCount {
                topicNames.append(contentsOf: Array(repeating: "", count: numberOfTopics - currentCount))
            } else if numberOfTopics < currentCount {
                topicNames = Array(topicNames.prefix(numberOfTopics))
            }
        }
    }
    var topicNames: [String] = [""] // Tetap String untuk input awal
}

// Model untuk form edit tabel (disarankan langsung mengelola Topic)
struct EditTableModel {
    var tableID: UUID? // Untuk referensi tabel yang diedit
    var tableName: String = ""
    var topics: [Topic] = [] // Langsung kelola array Topic untuk menjaga integritas ID dan histori
}
