import SwiftUI

struct CareOverView: View {
    @State private var isFirstFoodPawFilled = false
    @State private var isSecondFoodPawFilled = false
    @State private var isWaterPawFilled = false
    @State private var isLitterboxPawFilled = false
    
    @AppStorage("catName") private var catName: String = ""
    var selectedImageIndex: Int  // Receive selected index as a parameter
    
    let catImages = ["cat1", "cat2", "cat3", "cat4", "cat5"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                //Color("backgroundGray").ignoresSafeArea()
                Image("orange normal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 900)
                    .position(x: 200, y: 350)

                HStack {
                                   Text("Care")
                        .foregroundColor(.orange)// Set the "Care" text to orange
                        .font(.custom("SF Pro Regular", size: 28))

                                   Text("overview")
                                       .font(.custom("SF Pro Regular", size: 28))
                               }
                    .position(x: 100, y: 104)

                HStack(spacing: 30) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.customOrange)
                        .frame(width: 144, height: 170)
                        .overlay(
                            NavigationLink(destination: PerCheck()) {
                                Image(catImages[selectedImageIndex])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                            }
                        )
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.customOrange)
                        .frame(width: 200, height: 170)
                        .overlay(
                            VStack(spacing: 5) {
                                Text(catName.isEmpty ? "CatName" : catName)
                                    .offset(x: -50, y: -10)
                                    .foregroundColor(.black)
                                
                                // Food section
                                HStack {
                                    Text("Food")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 15)
                                    
                                    HStack(spacing: 5) {
                                        Image(systemName: isFirstFoodPawFilled ? "pawprint.fill" : "pawprint")
                                            .foregroundColor(.black)
                                            .onTapGesture {
                                                isFirstFoodPawFilled.toggle()
                                            }
                                        
                                        Image(systemName: isSecondFoodPawFilled ? "pawprint.fill" : "pawprint")
                                            .foregroundColor(.black)
                                            .onTapGesture {
                                                if isFirstFoodPawFilled {
                                                    isSecondFoodPawFilled.toggle()
                                                }
                                            }
                                            .opacity(isFirstFoodPawFilled ? 1.0 : 0.5)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                }
                                .padding(.top, 5)
                                
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 200, height: 2)
                                
                                // Water section
                                HStack {
                                    Text("Water")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 15)
                                    
                                    HStack(spacing: 5) {
                                        Image(systemName: isWaterPawFilled ? "pawprint.fill" : "pawprint")
                                            .foregroundColor(.black)
                                            .onTapGesture {
                                                isWaterPawFilled.toggle()
                                            }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                }
                                .padding(.top, 5)
                                
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 200, height: 2)
                                
                                // Litterbox section
                                HStack {
                                    Text("Litterbox")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 15)
                                    
                                    Image(systemName: isLitterboxPawFilled ? "pawprint.fill" : "pawprint")
                                        .foregroundColor(.black)
                                        .onTapGesture {
                                            isLitterboxPawFilled.toggle()
                                        }
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                                .padding(.top, 5)
                            }
                            .padding(.top, 15)
                        )
                }
                .padding(.top, 150)
                .position(x: 200, y: 150)
                
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: ChooseCat()) {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .onTapGesture {
                            print("Plus symbol tapped")
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

extension Color {
    static let customOrange = Color(red: 1.0, green: 0.776, blue: 0.631)  // #FFC6A1
}

#Preview {
    CareOverView(selectedImageIndex: 0) // Default index for preview
}
