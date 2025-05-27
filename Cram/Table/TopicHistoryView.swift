//
//  TopicHistoryView.swift
//  Cram
//
//  Created by Richard WIjaya Harianto on 24/05/25.
//

import SwiftUI

struct TopicHistoryView: View {
    @ObservedObject var viewModel: DashboardViewModel // Untuk menutup modal
    let topic: Topic

    // Formatter untuk tanggal dan waktu
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        NavigationStack {
            List {
                if topic.history.isEmpty || (topic.history.count == 1 && topic.history.first?.progressAdded == 0 && topic.history.first?.newTotalProgress == 0) {
                    Text("No progress history recorded for this subject yet, or only initial state exists.")
                        .font(Font.custom("Lexend-Regular", size: 15))
                        .foregroundColor(.gray)
                        .listRowBackground(Color.clear)
                } else {
                    // Urutkan histori dari yang terbaru ke terlama
                    ForEach(topic.history.sorted(by: { $0.date > $1.date })) { event in
                        // Jangan tampilkan event awal (0 progress) kecuali itu satu-satunya event
                        if !(event.progressAdded == 0 && event.newTotalProgress == 0 && topic.history.count > 1 && topic.history.first?.id == event.id) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(dateFormatter.string(from: event.date))
                                    .font(Font.custom("Lexend-SemiBold", size: 16))
                                
                                HStack {
                                    Text("Progress Added:")
                                        .font(Font.custom("Lexend-Regular", size: 14))
                                    Text("\(Int(event.progressAdded * 100))%")
                                        .font(Font.custom("Lexend-Medium", size: 14))
                                        .foregroundColor(event.progressAdded >= 0 ? .green : .red)
                                }
                                
                                HStack {
                                    Text("New Total:")
                                        .font(Font.custom("Lexend-Regular", size: 14))
                                    Text("\(Int(event.newTotalProgress * 100))%")
                                        .font(Font.custom("Lexend-Medium", size: 14))
                                        .foregroundColor(Color("content"))
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("History: \(topic.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        viewModel.closeTopicHistory()
                    }
                    .font(Font.custom("Lexend-Regular", size: 16))
                    .foregroundColor(Color("content"))
                }
            }
            .background(Color("offwhite").ignoresSafeArea()) // Set background untuk List juga
            .scrollContentBackground(.hidden) // Untuk iOS 16+, agar background List bisa transparan
        }
    }
}

struct TopicHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DashboardViewModel()
        let history = [
            ProgressUpdateEvent(date: Date().addingTimeInterval(-86400 * 2), progressAdded: 0.2, newTotalProgress: 0.2), // 2 hari lalu
            ProgressUpdateEvent(date: Date().addingTimeInterval(-86400), progressAdded: 0.3, newTotalProgress: 0.5),    // 1 hari lalu
            ProgressUpdateEvent(date: Date(), progressAdded: 0.15, newTotalProgress: 0.65)                               // Hari ini
        ]
        let topic = Topic(name: "Sample History", currentProgress: 0.65, history: history)
        vm.selectedTopicForHistory = topic
        
        return TopicHistoryView(viewModel: vm, topic: topic)
    }
}
