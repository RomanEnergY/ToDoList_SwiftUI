//
//  AddView.swift
//  ToDoList_SwiftUI
//
//  Created by ZverikRS on 10.04.2025.
//

import SwiftUI

protocol AddViewModelProtocol: AnyObject {
    func addItem(text: String)
}

struct AddView: View {
    
    // MARK: - public properties
    @Environment(\.dismiss) var dismiss
    
    // MARK: - private properties
    @Binding private var viewModel: any AddViewModelProtocol
    @State private var taskName: String = ""
    @FocusState private var focusState: Bool
    
    // MARK: - initializers
    init(config: AddViewBuilder.Config) {
        self._viewModel = .constant(config.viewModel)
    }
    
    // MARK: - life cycle
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                taskNametextField
                    .padding(.bottom, 20)
                
                saveButton
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: 400)
        .onTapGesture {
            focusState = false
        }
        .navigationTitle("Add new task")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - TaskNametextField
private extension AddView {
    var taskNametextField: some View {
        TextField("Enter task name", text: $taskName)
            .padding()
            .background(
                Color.white
                    .opacity(0.5)
                    .onTapGesture {
                        focusState = true
                    }
            )
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                    .padding(.horizontal, 0.5)
            )
            .keyboardType(.default)
            .focused($focusState)
            .onAppear {
                focusState = true
            }
    }
}

// MARK: - saveButton
private extension AddView {
    var saveButton: some View {
        Button {
            viewModel.addItem(text: taskName)
            taskName = ""
            focusState = false
            dismiss()
            
        } label: {
            Text("Save")
                .foregroundStyle(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(disabledSaveButton ? .gray : .blue)
                .cornerRadius(10)
        }
        .disabled(disabledSaveButton)
    }
    
    private var disabledSaveButton: Bool {
        taskName.count < 3
    }
}

#Preview {
    NavigationView {
        AddViewBuilder(
            config: .init(
                viewModel: ListViewModel()))
        .build()
    }
    .navigationViewStyle(.stack)
}
