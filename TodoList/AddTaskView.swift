//
//  AddTaskView.swift
//  TodoList
//
//  Created by Kumar, Govinda on 17/07/24.
//

import SwiftUI
import CoreData

struct AddTaskView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var newTaskDesc: String = ""
    @FocusState private var addDescField: Bool
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                TextField("Enter new task", text: $newTaskDesc)
                    .font(.headline)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .focused($addDescField)
                
                Button(action: {
                    viewModel.addItem(newTaskDesc)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Add task")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(newTaskDesc.isEmpty ? Color.secondary : Color.blue)
                        .cornerRadius(10)
                })
                .padding(.horizontal)
                .disabled(newTaskDesc.isEmpty)
            }
            .padding()
            .navigationTitle("Add Task")
            .onAppear{
                addDescField = true
            }
        }
    }
}
