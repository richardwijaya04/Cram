import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @State private var currentStep = 0
    @State private var isAnimating = false

    private let steps = [
        (title: "Welcome to Cram", message: "Tap anywhere to continue", highlightRect: CGRect(x: 0, y: 0, width: 0, height: 0)),
        (title: "Create Your First Table", message: "Tap the '+ Create Table' button to get started", highlightRect: CGRect.zero),
        (title: "Rate Your Session", message: "Tap to save your progress", highlightRect: CGRect.zero),
        (title: "All Done!", message: "Your hard work is logged, and your progress chart now reflects this session. Happy studying!", highlightRect: CGRect.zero)
    ]

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack {
                Spacer()
                VStack(spacing: 20) {
                    Text(steps[currentStep].title)
                        .font(Font.custom("Lexend-SemiBold", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text(steps[currentStep].message)
                        .font(Font.custom("Lexend-Regular", size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    if currentStep < steps.count - 1 {
                        Button(action: {
                            withAnimation {
                                if currentStep == 1 {
                                    viewModel.showCreateTableModal = true
                                } else if currentStep == 2 {
                                    if let firstTable = viewModel.tables.first {
                                        viewModel.prepareAddSession(for: firstTable)
                                        viewModel.selectedTopicForAddSession = firstTable.topics.first
                                    }
                                }
                                currentStep += 1
                                isAnimating = true
                            }
                        }) {
                            Text("Next")
                                .font(Font.custom("Lexend-SemiBold", size: 18))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 200)
                                .background(Color("content"))
                                .cornerRadius(10)
                        }
                    } else {
                        Button(action: {
                            withAnimation {
                                viewModel.completeOnboarding()
                            }
                        }) {
                            Text("Done")
                                .font(Font.custom("Lexend-SemiBold", size: 18))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 200)
                                .background(Color("content"))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(15)
                .padding(.bottom, 50)

                Spacer()
            }

            GeometryReader { geometry in
                ZStack {
                    if currentStep == 1 {
                        Color.clear
                            .frame(width: geometry.size.width * 0.4, height: 50)
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.3)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.yellow, lineWidth: 3)
                                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                            )
                    } else if currentStep == 2 {
                        Color.clear
                            .frame(width: geometry.size.width * 0.4, height: 50)
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.6)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.yellow, lineWidth: 3)
                                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                            )
                    } else if currentStep == 3 {
                        Color.clear
                            .frame(width: geometry.size.width * 0.3, height: 40)
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.7)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.yellow, lineWidth: 3)
                                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                            )
                    }
                }
            }
        }
        .onAppear {
            isAnimating = true
            if viewModel.tables.isEmpty {
                let sampleTable = Table(name: "Sample", topics: [Topic(name: "Sample Topic", currentProgress: 0.0)])
                viewModel.tables.append(sampleTable)
                viewModel.selectedTableIndex = 0
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: DashboardViewModel())
    }
}
