//
//  CareOverView.swift
//  CatCare
//
//  Created by Wajd on 26/03/1446 AH.
//

import SwiftUI

struct CareOverView: View {
    @State private var isFirstFoodPawFilled = false
    @State private var isSecondFoodPawFilled = false
    @State private var isWaterPawFilled = false
    @State private var isLitterboxPawFilled = false
// for data swift
    @State private var savedCatName: String = ""
    @State private var savedCatImageIndex: Int = 0
    //cat images just like in chose cat
    let catImages = ["cat1", "cat2", "cat3", "cat4"]
    
    @AppStorage("catName") private var catName: String = ""
    
    var body: some View {
        
        NavigationStack{
            
            ZStack{
                
 //background
        Image("orange normal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 900)
                    .position(x: 200, y: 350)
    //text
                Text(makeAttributedText())
                    .font(.custom("SF Pro Regular", size: 28))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()   .position(x: 100, y: 104)
                
                
    HStack(spacing: 30) {
   RoundedRectangle(cornerRadius: 20)
  .fill(Color.customOrange)
  .frame(width: 144, height: 170)

  .overlay(
  NavigationLink(destination: PerCheck()){
      Image(catImages[savedCatImageIndex])
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
                            
                            
            VStack( spacing:5) {
    //Text(savedCatName)
        Text(catName.isEmpty ? "CatName" : catName)
   .offset(x: -50, y: -10)
 .foregroundColor(.black)
  
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
isSecondFoodPawFilled.toggle()//this makes sure you cant click the sceonde paw if the first one isnt clicked
                                                }
                                            }
                                            .opacity(isFirstFoodPawFilled ? 1.0 : 0.5) //this makes the seconde paw gray if not clicked on the first
                                        
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                }
                                .padding(.top, 5)
                                
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 200, height: 2)
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
                                
                                
                                HStack {
                                    Text("Literbox")
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
                        NavigationLink(destination: ChooseCat()){
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            .foregroundColor(.black)}
                            .padding()
                            .onTapGesture {
                                print("Plus symbol tapped")
                            }
                    }
        Spacer()
    }
                
            }
  .onAppear {
      
// Retrieve saved cat name and image index from UserDefaults
  // if let name = UserDefaults.standard.string(forKey: "savedCatName") {
    //savedCatName = name
    //}
      
   savedCatImageIndex = UserDefaults.standard.integer(forKey: "savedCatImageIndex")
                       }
        }}
    
    
    

func makeAttributedText() -> AttributedString {
       var attributedString = AttributedString("Care overview")

       if let range = attributedString.range(of: "Care") {
           attributedString[range].foregroundColor = .orange
       }

       if let range = attributedString.range(of: "overview") {
           attributedString[range].foregroundColor = .black
       }
       
       return attributedString
   }
}

extension Color {
    static let customOrange = Color(red: 1.0, green: 0.776, blue: 0.631)  // #FFC6A1
}


#Preview {
    CareOverView()
}

