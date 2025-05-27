//
//  CreateTableView.swift
//  Cram
//
//  Created by Richard Wijaya Harianto on 24/05/25.
//

import SwiftUI

struct CreateTableView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack { // NavigationStack tetap di sini untuk potensi penggunaan di masa depan atau konsistensi
            ScrollView {
                VStack(spacing: 20) {
      
                    HStack {
                         Spacer()
                         Button(action: {
                             viewModel.cancelCreateTable()
                         }) {
                             Image(systemName: "xmark")
                                 .foregroundColor(.black) // Warna dari kode awal Anda
                                 .padding(8)
                                 .background(Circle().fill(Color.gray.opacity(0.2))) // Style dari kode awal Anda
                         }
                     }
                     .padding(.trailing, 10) // Padding dari kode awal Anda
                     .padding(.top, 10) // Padding dari kode awal Anda


                    Text("Create New Table")
                        .font(Font.custom("Lexend-SemiBold", size: 24))
                        .foregroundColor(Color("content"))
                        .padding(.top, 10) // Mengurangi padding top jika tombol X sudah ada di atasnya

                    // MARK: - Table Title TextField
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Table Title")
                            .font(Font.custom("Lexend-Medium", size: 16))
                            .foregroundColor(Color("content"))
                        
                        HStack {
                            TextField("e.g., IELTS Preparation, Daily Journal", text: $viewModel.createTableData.tableName)
                                .font(Font.custom("Lexend-Regular", size: 16))
                                .padding(.leading)
                                .padding(.vertical)

                            if !viewModel.createTableData.tableName.isEmpty {
                                Button(action: {
                                    viewModel.createTableData.tableName = ""
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
                        HStack (spacing: 35) {
                            Text("Number of Subjects")
                                .font(Font.custom("Lexend-Medium", size: 16))
                                .foregroundColor(Color("content"))
                            Spacer()
                            Stepper("\(viewModel.createTableData.numberOfTopics)", value: $viewModel.createTableData.numberOfTopics, in: 1...10)
                                .font(Font.custom("Lexend-Regular", size: 16))
                                .tint(Color("content"))
                        }
                    }
                    .padding(.horizontal)

                    // MARK: - Subject Title TextFields
                    ForEach(0..<viewModel.createTableData.numberOfTopics, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Subject \(index + 1) Title")
                                .font(Font.custom("Lexend-Medium", size: 14))
                                .foregroundColor(Color("content"))
                            
                            HStack {
                                TextField("e.g., Listening, Chapter 1", text: $viewModel.createTableData.topicNames[index])
                                    .font(Font.custom("Lexend-Regular", size: 16))
                                    .padding(.leading)
                                    .padding(.vertical)

                                if !viewModel.createTableData.topicNames[index].isEmpty {
                                    Button(action: {
                                        viewModel.createTableData.topicNames[index] = ""
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
                    }
                    
                    Spacer(minLength: 5)

                    Button(action: {
                        viewModel.createTable()
                    }) {
                        Text("Create")
                            .font(Font.custom("Lexend-SemiBold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("content"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .background(Color("offwhite").ignoresSafeArea())
            .scrollDismissesKeyboard(.interactively)
            // .navigationTitle("Create Table") // Dihapus, karena judul ada di body dan tombol X juga di body
            // .navigationBarTitleDisplayMode(.inline) // Tidak digunakan
            .toolbar(.hidden, for: .navigationBar) // Menyembunyikan navigation bar jika tidak ada item lain
                                                  // Jika NavigationStack diperlukan untuk hal lain, ini bisa dihapus.
                                                  // Atau, jika tombol X memang mau di toolbar, ini harus dihapus.
        }
        // Jika NavigationStack tidak dibutuhkan sama sekali karena ini modal sheet,
        // bisa dihilangkan seluruhnya dan tombol X di body jadi tombol close utama.
        // Namun, jika Anda menggunakan .presentationDetents, NavigationStack mungkin masih berguna.
    }
}

// Preview tetap sama
struct CreateTableView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTableView(viewModel: DashboardViewModel())
    }
}
