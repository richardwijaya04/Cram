//
//  AddSessionView.swift
//  Cram
//
//  Created by Richard WIjaya Harianto on 24/05/25.
//

import SwiftUI

struct AddSessionView: View {
    @ObservedObject var viewModel: DashboardViewModel
    let table: Table // Menerima tabel yang relevan

    @State private var selectedTopicID: UUID? = nil
    @State private var addedProgressPercentage: Double = 0 // Slider dari 0-100%

    var availableTopics: [Topic] {
        table.topics.filter { $0.currentProgress < 1.0 }
    }
    
    var selectedTopic: Topic? {
        guard let topicID = selectedTopicID else { return nil }
        return table.topics.first(where: { $0.id == topicID })
    }
    
    var selectedTopicCurrentProgress: Double {
        return selectedTopic?.currentProgress ?? 0.0
    }
    
    var remainingProgressForSelectedTopic: Double {
        guard let topic = selectedTopic else { return 1.0 } // Jika tidak ada topik terpilih, anggap bisa tambah 100%
        return max(0, 1.0 - topic.currentProgress)
    }

    // Menentukan apakah tombol Save bisa di-tap
    var canSaveChanges: Bool {
        guard selectedTopicID != nil else { return false } // Harus ada topik terpilih
        // Boleh save jika ada progress yang ditambahkan, ATAU jika progress awal sudah 100% (misal untuk log 0% jika diperlukan)
        // Namun, jika progress awal sudah 100%, slider akan di-disable. Jadi, cek addedProgressPercentage > 0
        return addedProgressPercentage > 0 || (selectedTopicCurrentProgress < 1.0 && addedProgressPercentage == 0)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) { // Tambah spacing antar elemen utama
                    // "Rate Your Session" title bisa dihilangkan jika sudah ada di navigationTitle
                    // atau jika ingin style yang berbeda
                    // Text("Rate Your Session")
                    //     .font(Font.custom("Lexend-SemiBold", size: 28)) // Lebih besar
                    //     .foregroundColor(.black)
                    //     .padding(.top, 5) // Kurangi padding top jika ada di navigation bar

                    // MARK: - Select Subject Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Subject")
                            .font(Font.custom("Lexend-Medium", size: 16))
                            .foregroundColor(Color.content) // Warna label standar
                            .padding(.horizontal)

                        if availableTopics.isEmpty {
                            Text("All subjects are 100% complete or no subjects available.")
                                .font(Font.custom("Lexend-Regular", size: 15))
                                .foregroundColor(.content)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(Color.gray.opacity(0.05))
                                .cornerRadius(8)
                                .padding(.horizontal)
                        } else {
                            Menu {
                                // Tombol Picker di dalam Menu
                                Picker("Select Subject", selection: $selectedTopicID) {
                                    Text("Choose a subject").tag(nil as UUID?)
                                    ForEach(availableTopics) { topic in
                                        Text(topic.name).tag(topic.id as UUID?)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedTopic?.name ?? "Choose a subject")
                                        .font(Font.custom("Lexend-Regular", size: 17))
                                        .foregroundColor(selectedTopicID == nil ? .gray : Color("content"))
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color.gray)
                                }
                                .padding(.horizontal)
                                .frame(height: 50) // Tinggi standar untuk input
                                .background(Color("offwhite")) // Warna background standar iOS
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1) // Border lebih jelas
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // MARK: - Progress Slider Section
                    if let topic = selectedTopic { // Hanya tampilkan jika topik sudah dipilih
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How much progress did you make?")
                                .font(Font.custom("Lexend-Medium", size: 16))
                                .foregroundColor(Color.content) // Warna label standar
                                .padding(.horizontal)
                            
                            HStack {
                                Slider(value: $addedProgressPercentage,
                                       in: 0...max(0, (remainingProgressForSelectedTopic * 100)), // Max berdasarkan sisa progress
                                       step: 1)
                                    .tint(Color("content")) // Warna slider
                                    .disabled(remainingProgressForSelectedTopic <= 0 && topic.currentProgress >= 1.0)
                                
                                Text("\(Int(addedProgressPercentage))%")
                                    .font(Font.custom("Lexend-Medium", size: 17).monospacedDigit())
                                    .foregroundColor(Color("content"))
                                    .frame(width: 55, alignment: .trailing) // Alokasi ruang untuk persentase
                            }
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(Color("offwhite"))
                            .cornerRadius(8)
                            
                            if topic.currentProgress >= 1.0 {
                                Text("This subject is already 100% complete.")
                                    .font(Font.custom("Lexend-Regular", size: 14))
                                    .foregroundColor(.green)
                                    .padding(.horizontal)
                            } else if addedProgressPercentage > 0 {
                                Text("New total progress will be \(Int(min(100,(topic.currentProgress * 100) + addedProgressPercentage)))%")
                                    .font(Font.custom("Lexend-Regular", size: 14))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    Spacer() // Mendorong tombol Save ke bawah jika konten sedikit

                    // MARK: - Save Button
                    Button(action: {
                        guard let topicId = selectedTopicID else { return }
                        viewModel.recordSession(topicId: topicId, addedProgress: addedProgressPercentage / 100.0)
                    }) {
                        Text("Save Session")
                            .font(Font.custom("Lexend-SemiBold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50) // Tinggi tombol standar
                            .background(Color("content"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20) // Jarak dari tepi bawah
                    .disabled(!canSaveChanges) // Disable berdasarkan kondisi
                    .opacity(canSaveChanges ? 1.0 : 0.5) // Efek visual saat disabled

                }
                .padding(.top, 20) // Padding atas untuk seluruh konten VStack
                .padding(.bottom) // Padding bawah untuk ScrollView
            }
            .background(Color("offwhite").ignoresSafeArea()) // Background standar iOS untuk form/sheet
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Rate Your Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { // Mengganti dengan tombol silang
                    Button(action: {
                        viewModel.cancelAddSession()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(Color("content"))
                    }
                }
                // Tombol Save di toolbar kanan dihapus karena sudah ada di body
            }
            .onAppear {
                if availableTopics.isEmpty {
                    selectedTopicID = nil
                }
                // Jangan auto-select, biarkan user memilih "Choose a subject"
            }
        }
    }
}

struct AddSessionView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DashboardViewModel()
        let topics = [
            Topic(name: "Ancient Civilizations", currentProgress: 0.2),
            Topic(name: "World Wars", currentProgress: 0.95),
            Topic(name: "Modern History", currentProgress: 1.0) // Contoh topik yang sudah selesai
        ]
        let table = Table(name: "History Studies", topics: topics)
        vm.tables = [table]
        vm.selectedTableIndex = 0
        
        return AddSessionView(viewModel: vm, table: table)
    }
}
