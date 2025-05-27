//
//  EditTableView.swift
//  Cram
//
//  Created by Richard Wijaya Harianto on 24/05/25.
//

import SwiftUI

struct EditTableView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showDeleteConfirmation: Bool = false

    var body: some View {
        NavigationStack { // Sama seperti CreateTableView
            ScrollView {
                VStack(spacing: 20) {
                    // Tombol silang di kanan atas, di dalam konten ScrollView (sesuai struktur awal Anda)
                    HStack {
                         Spacer()
                         Button(action: {
                             viewModel.cancelEditTable()
                         }) {
                             Image(systemName: "xmark")
                                 .foregroundColor(.black) // Warna dari kode awal Anda
                                 .padding(8)
                                 .background(Circle().fill(Color.gray.opacity(0.2))) // Style dari kode awal Anda
                         }
                     }
                     .padding(.trailing, 10) // Padding dari kode awal Anda
                     .padding(.top, 10) // Padding dari kode awal Anda

                    Text("Edit Table")
                        .font(Font.custom("Lexend-SemiBold", size: 24))
                        .foregroundColor(Color("content"))
                        .padding(.top, 10) // Mengurangi padding top

                    // MARK: - Table Title TextField
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Table Title")
                            .font(Font.custom("Lexend-Medium", size: 16))
                            .foregroundColor(Color("content"))
                        
                        HStack {
                            TextField("Table Title", text: $viewModel.editTableData.tableName)
                                .font(Font.custom("Lexend-Regular", size: 16))
                                .padding(.leading)
                                .padding(.vertical)

                            if !viewModel.editTableData.tableName.isEmpty {
                                Button(action: {
                                    viewModel.editTableData.tableName = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray.opacity(0.7))
                                }
                                .padding(.trailing, 8)
                            }
                        }
                        .background(Color("offwhite"))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)

                    // MARK: - Number of Subjects Stepper
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Number of Subjects")
                                .font(Font.custom("Lexend-Medium", size: 16))
                                .foregroundColor(Color("content"))
                            Spacer()
                            Stepper(value: Binding(
                                get: { viewModel.editTableData.topics.count },
                                set: { newCount in
                                    let oldCount = viewModel.editTableData.topics.count
                                    if newCount > oldCount {
                                        for _ in 0..<(newCount - oldCount) {
                                            viewModel.editTableData.topics.append(Topic(name: "", currentProgress: 0.0, history: [ProgressUpdateEvent(progressAdded: 0.0, newTotalProgress: 0.0)]))
                                        }
                                    } else if newCount < oldCount && newCount >= 0 {
                                        viewModel.editTableData.topics.removeLast(oldCount - newCount)
                                    }
                                }
                            ), in: 0...10) {
                                Text("\(viewModel.editTableData.topics.count)")
                                    .font(Font.custom("Lexend-Regular", size: 16))
                                    .foregroundColor(Color("content"))
                            }
                            .tint(Color("content"))
                        }
                    }
                    .padding(.horizontal)

                    // MARK: - Subject Title TextFields
                    ForEach($viewModel.editTableData.topics.indices, id: \.self) { index in
                        if index < viewModel.editTableData.topics.count {
                            let topicBinding = $viewModel.editTableData.topics[index]
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Subject \(index + 1) Title")
                                    .font(Font.custom("Lexend-Medium", size: 14))
                                    .foregroundColor(Color("content"))
                                
                                HStack {
                                    TextField("Subject Title", text: topicBinding.name)
                                        .font(Font.custom("Lexend-Regular", size: 16))
                                        .padding(.leading)
                                        .padding(.vertical)

                                    if !topicBinding.name.wrappedValue.isEmpty {
                                        Button(action: {
                                            viewModel.editTableData.topics[index].name = ""
                                        }) {
                                            Image(systemName: "multiply.circle.fill")
                                                .foregroundColor(.gray.opacity(0.7))
                                        }
                                        .padding(.trailing, 8)
                                    }
                                }
                                .background(Color("offwhite"))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )

                                Text("Current Progress: \(Int(topicBinding.currentProgress.wrappedValue * 100))%")
                                    .font(Font.custom("Lexend-Regular", size: 14))
                                    .foregroundColor(.gray)
                                Slider(value: topicBinding.currentProgress, in: 0...1, step: 0.01)
                                    .tint(Color("content"))
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                    }
                    
                    Spacer(minLength: 10)

                    Button(action: {
                        viewModel.saveEditTable()
                    }) {
                        Text("Save Changes")
                            .font(Font.custom("Lexend-SemiBold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("content"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 15)

                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Table")
                                .font(Font.custom("Lexend-Medium", size: 16))
                        }
                        .foregroundColor(.red)
                    }
                    .alert("Delete Table?", isPresented: $showDeleteConfirmation) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            viewModel.deleteTable()
                        }
                    } message: {
                        Text("Are you sure you want to delete this table? This action cannot be undone.")
                    }

                    Spacer(minLength: 30)
                }
            }
            .background(Color("offwhite").ignoresSafeArea())
            .scrollDismissesKeyboard(.interactively)
            // .navigationTitle("Edit Table") // Dihapus
            // .navigationBarTitleDisplayMode(.inline) // Tidak digunakan
            .toolbar(.hidden, for: .navigationBar) // Sama seperti CreateTableView
        }
    }
}

// Preview tetap sama
struct EditTableView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DashboardViewModel()
        // ... (kode preview lainnya sama) ...
        vm.prepareEditTable()
        return EditTableView(viewModel: vm)
    }
}
