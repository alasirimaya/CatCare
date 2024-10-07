import SwiftUI

struct ContentView: View {
    @State private var isActive = true
    
    var body: some View {
        if self.isActive {
            ZStack {
                Color(hex: "FDB573")
                    .ignoresSafeArea()
//                Color(red: 1.0, green: 0.8, blue: 0.6)// Set the background color to orange
                
                Image("Kitty")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                
                Text("CatCare")
                .font(.title) // Set the font size
                .foregroundColor(.black) // Set the text color
                .padding(.top, 100) // Add some spacing above the text
            }
            
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        self.isActive = false
                    }
                }
            }
        } else {
            ChooseCat()
        }
    }
}

#Preview {
    ContentView()
}
