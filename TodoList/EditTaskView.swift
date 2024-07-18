//
//  EditTaskView.swift
//  TodoList
//
//  Created by Kumar, Govinda on 17/07/24.
//
import SwiftUI
import CoreData

struct EditTaskView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var updatedDesc: String
    @FocusState private var editDescField: Bool
    
    var task: TodoEntity
    
    init(viewModel: TodoViewModel, task: TodoEntity) {
        self.viewModel = viewModel
        self.task = task
        _updatedDesc = State(initialValue: task.desc ?? "")
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                TextField("Edit task", text: $updatedDesc)
                    .font(.headline)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
//                    .background(Color.gray)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .focused($editDescField)
                    
                
                Button(action: {
                    viewModel.updateItem(task, with: updatedDesc)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(updatedDesc.isEmpty ? Color.secondary : Color.blue)
                        .cornerRadius(10)
                })
                .padding(.horizontal)
                .disabled(updatedDesc.isEmpty)
            }
            .padding()
            .navigationTitle("Edit Task")
            .onAppear{
                editDescField = true
            }
        }
    }
}
