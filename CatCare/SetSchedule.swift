import SwiftUI

struct SetSchedule: View {

   @State private var wakeUp = Date.now
    @State private var vaccinationDate = Date.now
    @State private var foodTime = Date.now
    @State private var waterTime = Date.now
    @State private var litterboxTime = Date.now
    
    // Enum to define frequency options
    enum Frequency: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        
    }
    
    enum FoodFrequency: String, CaseIterable {
           case daily = "Daily"
           case twiceDaily = "Twice Daily"
           case threeTimesDaily = "3 Times Daily"
       }
    
    enum WaterFrequency: String, CaseIterable {
           case daily = "Daily"
           case twiceDaily = "Twice Daily"
           case threeTimesDaily = "3 Times Daily"
       }
    
    // State to track selected frequency for each item
    @State private var foodFrequency: FoodFrequency = .daily
    @State private var waterFrequency: WaterFrequency = .daily
    @State private var literboxFrequency: Frequency = .daily
    

    // State to hold times set by the user
//    @State private var foodTime = Date.now
//    @State private var waterTime = Date.now
//    @State private var litterboxTime = Date.now
    
    // Closure to pass tasks back
    var onSave: (([Task]) -> Void)?
//    @Binding var tasks: [Task]

    // State to trigger navigation
    @State private var navigateToOverview: Bool = false
    @State private var tasks: [Task] = [] // Store the tasks here

    var body: some View {
        NavigationStack {
            
            VStack(spacing: 20) {
                
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    Text("Schedule")
                        .offset(y: 40)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Color.orange)
                    
                    Text("your cat needs")
                        .offset(x: 2, y: 25)
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                
                // Background abstract shape
                ZStack {
                    Image("orange normal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500, height: 900)
                        .position(x: 200, y: 260)
                }
                .frame(maxWidth: .infinity, alignment: .topTrailing)
                
                
                    // Schedule list section
                    VStack(spacing: 24) {
                        // Food Section
                        HStack {
                            Text("Food")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.bottom,-25)
                            
                            Spacer()
                            
                            // Picker for food frequency
                            Picker("", selection: $foodFrequency) {
                                
                                ForEach(FoodFrequency.allCases, id: \.self) { frequency in
                                    Text(frequency.rawValue)
                                    
                                }
                                
                            }
                            .padding(.bottom,-25)
                            
                            
                            
                            
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 100)
                            
                            // Time Picker for Food
                            DatePicker("", selection: $foodTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .frame(width: 100)
                                .padding(.bottom,-25)
                        }
                        .padding(15)
                        
                        Divider()
                        
                        // Water Section
                        HStack {
                            Text("Water")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            // Picker for water frequency
                            Picker("", selection: $waterFrequency) {
                                ForEach(WaterFrequency.allCases, id: \.self) { frequency in
                                    Text(frequency.rawValue)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 100)
                            
                            // Time Picker for Watera
                            DatePicker("", selection: $waterTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .frame(width: 100)
                        }
                        .padding(15)
                        
                        Divider()
                        
                        // Litterbox Section
                        HStack {
                            Text("Litterbox")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            // Picker for litterbox frequency
                            Picker("", selection: $literboxFrequency) {
                                ForEach(Frequency.allCases, id: \.self) { frequency in
                                    Text(frequency.rawValue)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 100)
                            
                            // Time Picker for Litterbox
                            DatePicker("", selection: $litterboxTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .frame(width: 100)
                        }
                        .padding(15)
                        
                        Divider()
                        
                        // Vaccination Section with small date picker
                        HStack {
                            Text("Appointment")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.top,-25)
                            
                            Spacer()
                            
                            // Small DatePicker with no labels
                            DatePicker("", selection: $vaccinationDate, displayedComponents: .date)
                                .padding(.top,-19)
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                                .frame(width: 100)
                            
                        }
                        
                        .padding(15)
                    }
                
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .shadow(radius: 5)
                        .frame(height: 400)
                )
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .offset(y: -80)
                
                // Done Button
                Button(action: {
                    saveTasks()
                    navigateToOverview = true // Trigger navigation after saving tasks
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 90)
                .offset(y: -50)
                
                Spacer()
            }
            .background(Color(UIColor.systemGray6))
            .edgesIgnoringSafeArea(.all)
            // Define the navigation destination
            .navigationDestination(isPresented: $navigateToOverview) {
                CareOverView(selectedImageIndex: 0) // Navigate to CareOverView when true
            }
        }
    }
    
    private func saveTasks() {
        let tasks: [Task] = [
            Task(time: DateFormatter.localizedString(from: foodTime, dateStyle: .none, timeStyle: .short), name: "Feed", isCompleted: false, frequency: foodFrequency.rawValue),
            Task(time: DateFormatter.localizedString(from: waterTime, dateStyle: .none, timeStyle: .short), name: "Water", isCompleted: false, frequency: waterFrequency.rawValue),
            Task(time: DateFormatter.localizedString(from: litterboxTime, dateStyle: .none, timeStyle: .short), name: "Litterbox", isCompleted: false, frequency: literboxFrequency.rawValue),
            Task(time: DateFormatter.localizedString(from: vaccinationDate, dateStyle: .medium, timeStyle: .none), name: "Vaccination", isCompleted: false, frequency: "Once")
        ]
        onSave?(tasks)
    }
}

struct TimeView: View {
    var timeText: String

    var body: some View {
        DatePicker("", selection: .constant(Date.now), displayedComponents: .hourAndMinute)
            .labelsHidden()
    }
}

struct SetSchedule_Previews: PreviewProvider {
    static var previews: some View {
        SetSchedule()
    }
}
