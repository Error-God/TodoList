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
        newTask.timestamp = Date()
        
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
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}