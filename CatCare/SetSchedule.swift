import SwiftUI

struct SetSchedule: View {

    @State private var wakeUp = Date.now
    @State private var vaccinationDate = Date.now
    // Update foodTimes to hold both time and frequency
    @State private var foodTimes: [(time: Date, frequency: FoodFrequency)] = [(Date.now, .oneTime)] // Array to store multiple food times with frequency
    @State private var waterTime = Date.now
    @State private var litterboxTime = Date.now

    enum Frequency: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
    }

    enum WaterFrequency: String, CaseIterable {
        case daily = "Daily"
        case twiceDaily = "Twice Daily"
        case threeTimesDaily = "3 Times Daily"
    }

    // New enum for Food Frequency
    enum FoodFrequency: String, CaseIterable {
        case daily = "Daily"
        case oneTime = "One-Time"
    }

    @State private var waterFrequency: WaterFrequency = .daily
    @State private var literboxFrequency: Frequency = .daily

    var onSave: (([Task]) -> Void)?
    @State private var navigateToOverview: Bool = false
    @State private var tasks: [Task] = []

    var body: some View {
       
        NavigationStack {
            ZStack {
                Color("backgroundGray").ignoresSafeArea()
                // Background image
                Image("orange normal")
                    .resizable()
                    .scaledToFit()
                    .padding(-60)
                
                VStack(spacing: 20) {
                    
                    // Header Section
                    VStack(alignment: .leading, spacing: 100) {
                        Text("Schedule")
                            .offset(x:-3,y:100)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(Color.orange)
                        Text("your cat needs")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .padding(.top, 20) // Adjusted top padding
                    
                    // Scrollable content starts here
                    VStack(spacing: 24) {
                        
                        // Food Section
                        ScrollView {
                            VStack(spacing: 30) {
                                Divider()
                                Text("Food")
                                    .offset(x:-143)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.bottom, -10)
                                    .frame(alignment: .leading)
                                
                                ForEach(foodTimes.indices, id: \.self) { index in
                                    HStack {
                                        Text("Time \(index + 1)")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                        Spacer()
                                        
                                        // Reverse the order: First the frequency, then the time picker
                                        Picker("Frequency", selection: $foodTimes[index].frequency) {
                                            ForEach(FoodFrequency.allCases, id: \.self) { frequency in
                                                Text(frequency.rawValue)
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                        .frame(width: 100)
                                        
                                        DatePicker("", selection: $foodTimes[index].time, displayedComponents: .hourAndMinute)
                                            .labelsHidden()
                                            .frame(width: 100)
                                        
                                        // Delete Button
                                        Button(action: {
                                            foodTimes.remove(at: index)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                        .buttonStyle(BorderlessButtonStyle()) // Prevent row from being tapped when deleting
                                    }
                                }
                                
                                // Button to add more food times
                                Button(action: {
                                    foodTimes.append((time: Date.now, frequency: .oneTime))
                                }) {
                                    Text("Add food time +")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            Divider() // Divider between Food and Water Sections
                            
                            // Water Section
                            HStack {
                                Text("Water")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                Picker("", selection: $waterFrequency) {
                                    ForEach(WaterFrequency.allCases, id: \.self) { frequency in
                                        Text(frequency.rawValue)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 100)
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
                                Picker("", selection: $literboxFrequency) {
                                    ForEach(Frequency.allCases, id: \.self) { frequency in
                                        Text(frequency.rawValue)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 100)
                                DatePicker("", selection: $litterboxTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .frame(width: 100)
                            }
                            .padding(15)
                            
                            Divider()
                            
                            // Vaccination Section
                            HStack {
                                Text("Appointment")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                DatePicker("", selection: $vaccinationDate, displayedComponents: .date)
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
                        )
                        .padding(.horizontal, 20)
                        
                        // Done Button
                        Button(action: {
                            saveTasks()
                            navigateToOverview = true
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
                        .padding(.top, 20) // Added top padding for better spacing
                        
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .navigationDestination(isPresented: $navigateToOverview) {
                    CareOverView(selectedImageIndex: 0)
                }
            }
        }
    }

    private func saveTasks() {
        let foodTaskTimes = foodTimes.map { foodTime in
            Task(time: DateFormatter.localizedString(from: foodTime.time, dateStyle: .none, timeStyle: .short), name: "Feed", isCompleted: false, frequency: foodTime.frequency.rawValue)
        }
        let tasks: [Task] = foodTaskTimes + [
            Task(time: DateFormatter.localizedString(from: waterTime, dateStyle: .none, timeStyle: .short), name: "Water", isCompleted: false, frequency: waterFrequency.rawValue),
            Task(time: DateFormatter.localizedString(from: litterboxTime, dateStyle: .none, timeStyle: .short), name: "Litterbox", isCompleted: false, frequency: literboxFrequency.rawValue),
            Task(time: DateFormatter.localizedString(from: vaccinationDate, dateStyle: .medium, timeStyle: .none), name: "Vaccination", isCompleted: false, frequency: "Once")
        ]
        onSave?(tasks)
    }
}

struct SetSchedule_Previews: PreviewProvider {
    static var previews: some View {
        SetSchedule()
    }
}
