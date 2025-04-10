//
//  ListItemView.swift
//  ToDoList_SwiftUI
//
//  Created by ZverikRS on 13.04.2025.
//

import SwiftUI

struct ListItemView: View {
    
    // MARK: - private properties
    private let title: String
    private let isCompleted: Bool
    private let editMode: EditMode?
    private let onUpdateState: () -> Void
    
    // MARK: - initializers
    init(
        title: String,
        isCompleted: Bool,
        editMode: EditMode?,
        onUpdateState: @escaping () -> Void
    ) {
        self.title = title
        self.isCompleted = isCompleted
        self.editMode = editMode
        self.onUpdateState = onUpdateState
    }
    
    // MARK: - life cycle
    var body: some View {
        HStack {
            Image(systemName: isCompleted ? "checkmark.circle" : "circle")
                .foregroundStyle(isCompleted ? .green : .red)
                .onTapGesture {
                    onUpdateState()
                }
            
            Text(title)
            
            Spacer()
            
            if let editMode,
               case .inactive = editMode {
                Circle()
                    .fill(isCompleted ? .green : .red)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(10)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        ListItemView(
            title: "Test",
            isCompleted: true,
            editMode: .inactive,
            onUpdateState: {
                print("")
            })
        .padding(.horizontal, 20)
    }
}
