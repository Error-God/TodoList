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

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: TodoViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.tasks) { task in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(task.desc ?? "")
                                .font(.title)
                            Text(task.timestamp!, formatter: itemFormatter)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .onTapGesture {
                            viewModel.selectedTask = task
                            showEditView = true
                        }
                    }
                    .onDelete(perform: viewModel.deleteItems)
                }
            }
            .navigationTitle("Todo List")
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

#Preview {
    ContentView(context: PersistenceController.preview.container.viewContext)
}
