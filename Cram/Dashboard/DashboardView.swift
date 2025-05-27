//
//  DashboardView.swift
//  Cram
//
//  Created by Richard WIjaya Harianto on 24/05/25.
//

import SwiftUI
import TipKit

struct StreakView: View {
    let days: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Study Streak")
                .font(Font.custom("Lexend", size: 18))
                .foregroundColor(.white)
            Text("\(days) days")
                .font(Font.custom("Lexend", size: 24))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(Color("content")) // Pastikan warna "content" dan "offwhite" ada di Assets
        .cornerRadius(10)
    }
}

struct OnboardingOverlay: View {
    @Binding var step: Int
    @Environment(\.dismiss) var dismiss
    let onContinue: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                Text(step == 1 ? "Welcome to Cram" : "")
                    .font(Font.custom("Lexend-SemiBold", size: 28))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("content").opacity(0.8))
                    .cornerRadius(12)
                    .opacity(step == 1 ? 1 : 0)
                
                Text(step == 1 ? "Tap anywhere to continue" : (step == 2 ? "To get started, tap the create table button" : ""))
                    .font(Font.custom("Lexend-Regular", size: 16))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("content").opacity(0.8))
                    .cornerRadius(12)
                    .opacity(step == 1 || step == 2 ? 1 : 0)
                
                Spacer()
            }
            .transition(.opacity)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if step == 1 {
                withAnimation {
                    step = 2
                }
            } else if step == 2 {
                onContinue()
                withAnimation {
                    step = 0
                }
            }
        }
    }
}

struct DashboardContentView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            StreakView(days: viewModel.streakDays)
            
            if viewModel.tables.isEmpty {
                Button(action: { viewModel.showCreateTableModal = true }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Create Your First Table")
                            .font(Font.custom("Lexend", size: 16))
                    }
                    .foregroundColor(Color("content"))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            } else if let index = viewModel.selectedTableIndex, index < viewModel.tables.count {
                let currentTable = viewModel.tables[index]
                
                HStack(alignment: .center, spacing: 10) {
                    // Picker untuk memilih tabel jika ada lebih dari satu
                    if viewModel.tables.count > 1 {
                        Picker("Select Table", selection: $viewModel.selectedTableIndex) {
                            ForEach(viewModel.tables.indices, id: \.self) { idx in
                                Text(viewModel.tables[idx].name).tag(idx as Int?)
                            }
                        }
                        .font(Font.custom("Lexend", size: 20))
                        .tint(Color.black) // Untuk warna picker
                    } else {
                        Text(currentTable.name)
                            .font(Font.custom("Lexend", size: 20))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    Button(action: { viewModel.prepareEditTable() }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit Table")
                                .font(Font.custom("Lexend", size: 16))
                        }
                        .foregroundColor(Color("content"))
                    }
                }
                
                if currentTable.topics.isEmpty {
                    Text("This table has no topics. Edit the table to add some.")
                        .font(Font.custom("Lexend", size: 14))
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(currentTable.topics) { topic in // Iterasi langsung pada Topic
                        ProgressBarView(topic: topic) // Kirim objek Topic
                            .frame(height: 50)
                            .onTapGesture {
                                viewModel.viewTopicHistory(topic: topic)
                            }
                    }
                }
                
                Button(action: { viewModel.prepareAddSession(for: currentTable) }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Session")
                            .font(Font.custom("Lexend", size: 16))
                    }
                    .foregroundColor(Color.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .background(Color("content"))
                    .cornerRadius(10)
                }
            } else if !viewModel.tables.isEmpty && viewModel.selectedTableIndex == nil {
                 // Kasus jika ada tabel tapi tidak ada yang terpilih (seharusnya tidak terjadi dengan default index 0)
                Text("Select a table to view its progress.")
                    .font(Font.custom("Lexend", size: 16))
                    .foregroundColor(.gray)
                Button("Create New Table") {
                    viewModel.showCreateTableModal = true
                }
            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $viewModel.showCreateTableModal) {
            CreateTableView(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showEditTableModal) {
            // Pastikan editTableData sudah disiapkan
            if viewModel.editTableData.tableID != nil {
                EditTableView(viewModel: viewModel)
            }
        }
        .sheet(isPresented: $viewModel.showAddSessionModal) {
            // Pastikan ada tabel terpilih
            if let tableIndex = viewModel.selectedTableIndex, tableIndex < viewModel.tables.count {
                 AddSessionView(viewModel: viewModel, table: viewModel.tables[tableIndex])
            }
        }
        .sheet(isPresented: $viewModel.showTopicHistoryModal) {
            if let topic = viewModel.selectedTopicForHistory {
                TopicHistoryView(viewModel: viewModel, topic: topic)
            }
        }
        .onAppear {
            if !viewModel.tables.isEmpty && viewModel.selectedTableIndex == nil {
                viewModel.selectedTableIndex = 0 // Pilih tabel pertama jika belum ada yang terpilih
            }
        }
    }
}

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                DashboardContentView(viewModel: viewModel)
                    .navigationTitle("Dashboard")
                    .background(Color("offwhite").ignoresSafeArea())
                
                if viewModel.showOnboarding {
                    OnboardingView(viewModel: viewModel)
                        .transition(.opacity)
                }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
