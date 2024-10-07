import SwiftUI

struct ChooseCat: View {
    // Cat image names from assets
    let catImages = ["cat1", "cat2", "cat3", "cat4","cat5"]  // Add your actual cat image names here
    
    // State variables
    @State private var currentIndex = 0  // To keep track of the currently displayed cat image
    //@State private var catName = ""  // To store the cat's name input by the user
    
//    func getSavedCatName() -> String {
//        return UserDefaults.standard.string(forKey: "savedCatName") ?? "Unknown Cat"
//    }
    // Use @AppStorage to persistently store the cat name
    @AppStorage("catName") private var catName: String = ""
    
    // AppStorage to persist the selected image index
    //@AppStorage("selectedImageIndex") private var selectedImageIndex: Int = 0

    var body: some View {
        NavigationStack{
            ZStack {
                // Background image
                Image("orange normal")  // Use the background image from assets
                    .resizable()
                    .edgesIgnoringSafeArea(.all)  // Makes the background fill the whole screen
                
                VStack {
                    // Title text
                    
                    HStack{
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
                    //Text("Choose your")
                    // .font(.title)
                    // .fontWeight(.medium)
                    //  .padding(.top, 50)
                    
                    Spacer()
                    
                    // Image slider for the cats with left and right arrows
                    HStack {
                        // Left arrow
                        Button(action: {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.largeTitle)
                                .padding()
                        }
                        .disabled(currentIndex == 0)  // Disable if already on the first cat
                        
                        // Cat image
                        Image(catImages[currentIndex])                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                        
                        // Right arrow
                        Button(action: {
                            if currentIndex < catImages.count - 1 {
                                currentIndex += 1
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.largeTitle)
                                .padding()
                        }
                        .disabled(currentIndex == catImages.count - 1)  // Disable if already on the last cat
                    }
                    
                    Spacer()
                    
                  

                    //@State var currentCatName: String?
                        // Text field for the user to enter the cat's name
                   // TextField(text: currentCatName ?? "name")
                        TextField("Enter cat name", text: $catName)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 20)
                    
                    // Next button
                    
                    Button(action: {
                        //currentCatName = "catName"
                        
                        //USERDEAFULT
                        //UserDefaults.standard.set(catName, forKey: "savedCatName")
                        // Add your action for the next button here
                        //UserDefaults.standard.set(catName,forKey: "savedCatName")
                        //UserDefaults.standard.set(currentIndex, forKey: "savedCatImageIndex")
                        //print("Selected cat name: \(catName), Image index: \(currentIndex)")
                       // print("Selected cat name: \(catName)")
                    }) {
                        
                        
                        NavigationLink(destination: CareOverView()){
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .cornerRadius(25)
                                .padding(.horizontal, 90)
                                .offset(y: -10)
//                                .fontWeight(.bold)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.orange)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                .padding(.horizontal, 40)
                            
                        }}
                    .disabled(catName.isEmpty)
                    Spacer()
                }
                
            }
        }
    }}

struct CatSelectionView_previews: PreviewProvider {
    static var previews: some View {
       ChooseCat()
    }
}
