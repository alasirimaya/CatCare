import SwiftUI

struct ChooseCat: View {
    let catImages = ["cat1", "cat2", "cat3", "cat4", "cat5"]
    
    @State private var currentIndex = 0
    @AppStorage("catName") private var catName: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("orange normal")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Title
                    HStack {
                        Text("Choose your")
                            .font(.title)
                            .fontWeight(.medium)
                            .padding(.top, 100)
                        Text("cat")
                            .font(.title)
                            .fontWeight(.medium)
                            .padding(.top, 100)
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                    
                    // Image slider
                    HStack {
                        Button(action: {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.largeTitle)
                                .padding()
                        }
                        .disabled(currentIndex == 0)
                        
                        // Cat image
                        Image(catImages[currentIndex])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                        
                        Button(action: {
                            if currentIndex < catImages.count - 1 {
                                currentIndex += 1
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.largeTitle)
                                .padding()
                        }
                        .disabled(currentIndex == catImages.count - 1)
                    }
                    
                    Spacer()
                    
                    // Cat name input
                    TextField("Enter cat name", text: $catName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                    
                    // Next button
                    NavigationLink(destination: CareOverView(selectedImageIndex: currentIndex)) {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(25)
                            .padding(.horizontal, 90)
                            .offset(y: -10)
                    }
                    .disabled(catName.isEmpty)
                    
                    Spacer()
                }
            }
        }
    }
}

struct CatSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCat()
    }
}
