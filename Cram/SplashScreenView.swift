import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var logoOpacity = 0.0
    @State private var logoScale = 0.8

    var body: some View {
        ZStack {
            Color("offwhite")
                .ignoresSafeArea()
            
            VStack {
                Text("Cram")
                    .font(Font.custom("Lexend-SemiBold", size: 48))
                    .foregroundColor(Color("content"))
                    .opacity(logoOpacity)
                    .scaleEffect(logoScale)
                    .animation(.easeOut(duration: 1.0), value: logoOpacity)
                    .animation(.spring(response: 0.7, dampingFraction: 0.6, blendDuration: 0), value: logoScale)
            }
        }
        .onAppear {
            withAnimation {
                self.logoOpacity = 1.0
                self.logoScale = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.isActive = true
                }
            }
        }
        .opacity(isActive ? 0 : 1)
        .animation(.easeInOut(duration: 0.5), value: isActive)
        .fullScreenCover(isPresented: $isActive) {
            DashboardView()
                .transition(.opacity)
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
