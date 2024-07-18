//
//  TodoViewModel.swift
//  TodoList
//
//  Created by Kumar, Govinda on 17/07/24.
//

import SwiftUI
import CoreData

class TodoViewModel: ObservableObject {
    @Published var tasks: [TodoEntity] = []
    @Published var selectedTask: TodoEntity?
    @Published var selectedDay: String = "today"
    @Published var updatedstatus: String = "OPEN"
    
    var daysTask: [TodoEntity] {
        var tasksForDay: Date
        switch selectedDay {
        case "yesterday":
            tasksForDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        case "tomorrow":
            tasksForDay = Calendar.current.date(byAdding: .day, value: +1, to: Date())!
        default:
            tasksForDay = Calendar.current.startOfDay(for: Date())
        }
        return tasks.filter { Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: tasksForDay) }
    }
    
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchTasks()
    }
    
    func fetchTasks() {
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TodoEntity.desc, ascending: true)]
        
        do {
            tasks = try viewContext.fetch(request)
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
        }
    }
    
    func addItem(_ desc: String) {
        let newTask = TodoEntity(context: viewContext)
        newTask.desc = desc
        newTask.status = "OPEN"
        if selectedDay == "today"{
            newTask.timestamp = Date()
        } else if selectedDay == "tomorrow"{
            newTask.timestamp = Calendar.current.date(byAdding: .day, value: +1, to: Date())
        }
        
        saveContext()
        fetchTasks()
    }
    
    func updateItem(_ task: TodoEntity, with newDesc: String) {
        task.desc = newDesc
        saveContext()
        fetchTasks()
    }
    
    func deleteItems(at offsets: IndexSet) {
        offsets.map { tasks[$0] }.forEach(viewContext.delete)
        saveContext()
        fetchTasks()
    }
    
    func updateStatus(_ task: TodoEntity, with newStatus: String){
        task.status = newStatus
        saveContext()
        fetchTasks()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
