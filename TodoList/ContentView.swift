//
//  ContentView.swift
//  TodoList
//
//  Created by Kumar, Govinda on 17/07/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: TodoViewModel
    
    @State private var showEditView = false
    @State private var showAddView = false
    @State private var showAddButton = true
    @State private var isToday = true
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: TodoViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.daysTask) { task in
                        ZStack {
                            HStack{
                                VStack(alignment: .leading, spacing: 5){
                                    Text(task.desc ?? "")
                                        .font(.title)
                                    Text(task.timestamp!, formatter: itemFormatter)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                VStack{
                                    if task.status == "COMPLETED"{
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                            .font(.title2)
                                    } else if task.status == "INCOMPLETE"{
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .font(.title2)
                                    } else {
                                        Image(systemName: "questionmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .font(.title2)
                                    }
                                }
                            }
                        }
                        .onTapGesture {
                            viewModel.selectedTask = task
                            showEditView = true
                        }
                        .if(viewModel.selectedDay != "yesterday") { view in
                            view.contextMenu {
                                Button(action: {
                                    viewModel.updateStatus(task, with: "INCOMPLETE")
                                }) {
                                    Label("Not Complete", systemImage: "xmark.circle")
                                }
                                Button(action: {
                                    viewModel.updateStatus(task, with: "COMPLETED")
                                }) {
                                    Label("Completed", systemImage: "checkmark.circle")
                                }
                                Button(action: {
                                    //closes context menu
                                }) {
                                    Label("Cancel", systemImage: "")
                                }
                            }
                            .defaultHoverEffect(.highlight)
                        }
                    }
                    .onDelete(perform: viewModel.deleteItems)
                }
            }
            .navigationTitle("Tasks for \(String(describing: viewModel.selectedDay))")
            .toolbar(content: {
                ToolbarItem(placement: ToolbarItemPlacement.topBarLeading) {
                    Button("Yesterday"){
                        viewModel.selectedDay = "yesterday"
                        showAddButton = false
                        isToday = false
                    }
                    .opacity(isToday ? 1.0 : 0.0)
                }
                ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                    Button("Today"){
                        viewModel.selectedDay = "today"
                        showAddButton = true
                        isToday = true
                    }
                    .opacity(isToday ? 0.0 : 1.0)
                }
                ToolbarItem(placement: ToolbarItemPlacement.topBarTrailing) {
                    Button("Tomorrow"){
                        viewModel.selectedDay = "tomorrow"
                        showAddButton = true
                        isToday = false
                    }
                    .opacity(isToday ? 1.0 : 0.0)
                }
            })
            .sheet(isPresented: $showEditView) {
                if let selectedTask = viewModel.selectedTask {
                    EditTaskView(viewModel: viewModel, task: selectedTask)
                }
            }
            .sheet(isPresented: $showAddView) {
                AddTaskView(viewModel: viewModel)
            }
            .overlay(
                Button(action: {
                    showAddView = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .opacity(showAddButton ? 1.0 : 0.0)
                }
                    .padding()
                    .position(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 220)
            )
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    ContentView(context: PersistenceController.preview.container.viewContext)
}
