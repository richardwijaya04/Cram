//
//  ProgressBarView.swift
//  Cram
//
//  Created by Richard WIjaya Harianto on 24/05/25.
//

import SwiftUI

struct ProgressBarView: View {
    let topic: Topic // Menerima objek Topic
    
    // PERBAIKAN: Menyederhanakan helper, fokus pada baseSize.
    // Anda perlu menyetel 'baseSubtopicCharSize' di bawah dengan hati-hati.
    private func averageCharWidth(for text: String, baseSize: CGFloat) -> CGFloat {
        if text.isEmpty { return baseSize } // Menangani string kosong
        // Menghilangkan penskalaan berdasarkan panjang teks untuk sementara.
        // Ini membuat 'estimatedSubtopicCharWidth' sama dengan 'baseSubtopicCharSize'.
        return baseSize
    }

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let progressWidth = totalWidth * CGFloat(topic.currentProgress)
            
            // === NILAI PENTING UNTUK PENYESUAIAN ===
            // Cobalah mengubah nilai ini (misalnya antara 7.0 hingga 9.5) untuk Lexend-Medium size 16
            // sampai akurasinya paling baik untuk berbagai panjang teks.
            let baseSubtopicCharSize: CGFloat = 8.0 // CONTOH NILAI AWAL BARU (ANDA HARUS MENYESUAIKANNYA)
            
            // Untuk persentase, Lexend-Regular size 15. Angka biasanya lebih konsisten lebarnya.
            let basePercentageCharSize: CGFloat = 7.8 // CONTOH NILAI AWAL BARU (SESUAIKAN JIKA PERLU)
            // ==========================================

            // 'estimatedSubtopicCharWidth' sekarang akan sama dengan 'baseSubtopicCharSize'
            // karena fungsi averageCharWidth yang disederhanakan.
            let estimatedSubtopicCharWidth = averageCharWidth(for: topic.name, baseSize: baseSubtopicCharSize)
            let estimatedPercentageCharWidth = basePercentageCharSize // Persentase tidak menggunakan averageCharWidth

            let leadingPadding: CGFloat = 15.0
            let trailingPadding: CGFloat = 15.0
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("content").opacity(0.2))
                    .frame(height: 50)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("content"))
                    .frame(width: progressWidth, height: 50)
                    .animation(.spring(), value: topic.currentProgress)
                
                HStack(spacing: 0) { // HStack utama untuk teks nama dan persentase
                    // Nama Subtopic
                    HStack(spacing: 0) {
                        // Pastikan topic.name tidak kosong untuk menghindari pembagian dengan nol atau loop yang tidak perlu
                        if !topic.name.isEmpty {
                            ForEach(Array(topic.name.enumerated()), id: \.offset) { index, char in
                                let charXStartInPaddedContainer = CGFloat(index) * estimatedSubtopicCharWidth
                                let charGlobalXStart = leadingPadding + charXStartInPaddedContainer
                                let charGlobalMidPoint = charGlobalXStart + (estimatedSubtopicCharWidth / 2.0)
                                
                                let isCovered = charGlobalMidPoint < progressWidth
                                
                                Text(String(char))
                                    .font(Font.custom("Lexend-Medium", size: 16))
                                    .foregroundColor(isCovered ? Color("offwhite") : Color("content").opacity(0.8))
                            }
                        }
                    }
                    .padding(.leading, leadingPadding)

                    Spacer()
                    
                    // Persentase
                    HStack(spacing: 0) {
                        let percentageText = "\(Int(round(topic.currentProgress * 100)))%"
                        if !percentageText.isEmpty { // Pastikan percentageText tidak kosong
                            let percentageChars = Array(percentageText)
                            // Lebar total teks persentase dihitung menggunakan estimatedPercentageCharWidth
                            let totalPercentageTextWidth = CGFloat(percentageChars.count) * estimatedPercentageCharWidth
                            
                            let percentageBlockGlobalXStart = totalWidth - trailingPadding - totalPercentageTextWidth
                            
                            ForEach(Array(percentageChars.enumerated()), id: \.offset) { index, char in
                                let charXStartInTextBlock = CGFloat(index) * estimatedPercentageCharWidth
                                let charGlobalXStart = percentageBlockGlobalXStart + charXStartInTextBlock
                                let charGlobalMidPoint = charGlobalXStart + (estimatedPercentageCharWidth / 2.0)
                                
                                let isCovered = charGlobalMidPoint < progressWidth
                                                                
                                Text(String(char))
                                    .font(Font.custom("Lexend-Regular", size: 15).monospacedDigit())
                                    .foregroundColor(isCovered ? Color("offwhite") : Color("content").opacity(0.8))
                            }
                        }
                    }
                    .padding(.trailing, trailingPadding)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView { // Tambahkan ScrollView agar semua kasus bisa terlihat
            VStack(spacing: 10) {
                Group {

                    ProgressBarView(topic: Topic(name: "Listening", currentProgress: 0.10))
                    ProgressBarView(topic: Topic(name: "Reading Skills", currentProgress: 0.63))
                    ProgressBarView(topic: Topic(name: "Short Name", currentProgress: 0.85))
                    ProgressBarView(topic: Topic(name: "S", currentProgress: 0.95))
                    ProgressBarView(topic: Topic(name: "Very Long Topic Name Indeed", currentProgress: 0.50))
                    ProgressBarView(topic: Topic(name: "Full", currentProgress: 1.0))
                    ProgressBarView(topic: Topic(name: "Almost Full", currentProgress: 0.98))
                    ProgressBarView(topic: Topic(name: "Test: iiiiW", currentProgress: 0.50)) // Karakter sempit diikuti lebar
                    ProgressBarView(topic: Topic(name: "Test: WWWWi", currentProgress: 0.50)) // Karakter lebar diikuti sempit
                }
                
                Group {
                    ProgressBarView(topic: Topic(name: "ABC", currentProgress: 0.0))
                    ProgressBarView(topic: Topic(name: "ABC", currentProgress: 0.15))
                    ProgressBarView(topic: Topic(name: "ABC", currentProgress: 0.25))
                    ProgressBarView(topic: Topic(name: "ABC", currentProgress: 0.50))
                    ProgressBarView(topic: Topic(name: "ABC", currentProgress: 0.85))
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
        }
    }
}
