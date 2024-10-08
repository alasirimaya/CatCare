import SwiftUI

// Main PerCheck view showing tasks for a specific day
struct PerCheck: View {

    // List of tasks managed by the user
    @State private var Utasks: [Task] = []
    
    // Boolean state to control task editing mode
    @State private var isEditing = false
    
    // Get the current start date of the week
    var startDate: Date {
        let today = Calendar.current.startOfDay(for: Date())
        let weekday = Calendar.current.component(.weekday, from: today)
        let daysFromSunday = weekday - Calendar.current.firstWeekday
        return Calendar.current.date(byAdding: .day, value: -daysFromSunday, to: today)!
    }
    
    // Generate the days of the week starting from the current date
    var daysOfWeek: [Date] {
        (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: startDate) }
    }
    
    // Get the name of the current day
    var currentDayName: String {
        DateFormatter().shortWeekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
    }
    
    // Retrieve cat name from storage
    @AppStorage("catName") private var catName: String = ""

    // Main UI for PerCheck view
    var body: some View {
        ZStack {
            Color("backgroundGray").ignoresSafeArea()
            
            // Orange background design
            Image("background")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 500)
                .position(x: 280, y: 30)
            
            VStack {
                header
                dayPicker
                taskHeader
                taskList
            }
        }
        // Navigation bar customization
        .navigationBarItems(
            leading: navBarLeading, // Back button and cat name on the left
            trailing: Button("Edit") { isEditing.toggle() } // Edit button on the right
                .foregroundColor(.blue)
        )
        .navigationBarTitleDisplayMode(.inline) // Align title with toolbar
        
        // Edit tasks in a sheet view
        .sheet(isPresented: $isEditing) {
            SetSchedule(onSave: { newTasks in
                Utasks.append(contentsOf: newTasks) // Add new tasks
                isEditing = false // Close the edit sheet
            })
        }
        .onAppear(perform: loadTasks) // Load tasks when view appears
    }

    // Header section displaying current month and title
    var header: some View {
        VStack(alignment: .leading) {
            Text(currentMonth).font(.system(size: 20)).foregroundColor(.gray).padding(.leading, -160)
            Text("Today reminders").font(.title).fontWeight(.light).padding(.leading, -160)
        }
        .padding()
    }
    
    // Get the current month name
    var currentMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: Date()) // Return current month
    }
    
    // Day picker displaying the days of the week
    var dayPicker: some View {
        HStack(spacing: 8) {
            ForEach(daysOfWeek, id: \.self) { day in
                let dayName = getDayName(for: day)
                let dayOfMonth = getDayOfMonth(for: day)
                VStack {
                    Text(dayName).font(.caption).padding(.bottom, 10)
                    Text(dayOfMonth)
                        .font(.callout)
                        .padding()
                        // Highlight current day
                        .background(dayName == currentDayName ? Color.orange : Color.clear)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
    }
    
    // Header for the task list displaying time and task columns
    var taskHeader: some View {
        HStack {
            Text("Time").font(.headline).foregroundColor(.gray).frame(width: 80, alignment: .leading)
            Text("Task").font(.headline).foregroundColor(.gray)
            Spacer()
        }.padding(.horizontal)
    }
    
    // Scrollable list displaying all tasks or a message if no tasks exist
    var taskList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if Utasks.isEmpty {
                    // Display a message when no tasks are available
                    Text("There are no tasks")
                        .fontWeight(.light)
                        .offset(y:160)
                        .font(.title2)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    // Display tasks with completion status
                    ForEach($Utasks) { $task in
                        TaskView(task: $task, tasks: $Utasks)
                    }
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(45)
        .shadow(radius: 1)
        .padding(.horizontal)
    }

    // Navigation bar leading with back button and cat name
    var navBarLeading: some View {
        HStack {
            NavigationLink(destination: CareOverView(selectedImageIndex: 0)) { }
            Image(systemName: "pawprint.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            Text(catName.isEmpty ? "CatName" : catName)
                .font(.title)
        }
    }

    // Helper functions to retrieve day names and dates
    func getDayName(for date: Date) -> String {
        DateFormatter().shortWeekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
    }
    
    func getDayOfMonth(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    // Load tasks from persistent storage
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let savedTasks = try? JSONDecoder().decode([Task].self, from: data) {
            Utasks = savedTasks
        }
    }
}

// Individual TaskView to display task details and handle completion
struct TaskView: View {
    @Binding var task: Task
    @Binding var tasks: [Task]
    @State private var isFadingOut = false // Control fade-out animation
    
    var body: some View {
        HStack(alignment: .top) {
            // Display task time
            Text(task.time)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)
            
            // Blue separator line between time and task
            Rectangle()
                .frame(width: 2)
                .foregroundColor(.blue)
                .padding(.vertical, 5)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        // Task name and strikethrough if completed
                        Text(task.name)
                            .font(.system(size: 18, weight: .bold))
                            .strikethrough(task.isCompleted, color: .gray)
                        // Task frequency (e.g., daily, weekly)
                        Text(task.frequency)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Paw icon indicating task completion status
                    Image(systemName: task.isCompleted ? "pawprint.fill" : "pawprint")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.orange)
                        .onTapGesture {
                            markTaskCompleted() // Toggle task completion
                        }
                }
            }
            .padding()
            .background(Color.orange.opacity(0.3))
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.orange, lineWidth: task.isCompleted ? 0 : 2)
            )
            .opacity(isFadingOut ? 0 : 1) // Animate fade-out when completed
            .animation(.easeInOut(duration: 0.5), value: isFadingOut)
        }
        .padding(.vertical, 5)
    }

    // Handle task completion and removal after animation
    private func markTaskCompleted() {
        task.isCompleted.toggle()
        if task.isCompleted {
            task.completionDate = Date()
            
            // Fade out and remove task after 0.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    isFadingOut = true
                }
                // Remove task after fade-out
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    tasks.removeAll { $0.id == task.id }
                    saveTasks() // Save updated task list
                }
            }
        } else {
            task.completionDate = nil
        }
    }

    // Save tasks to persistent storage
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
}


// Task model to represent each task
struct Task: Identifiable, Codable {
    var id = UUID()
    var time: String
    var name: String
    var isCompleted: Bool
    var frequency: String
    var completionDate: Date? // Optional completion date for the task
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PerCheck()
    }
}
