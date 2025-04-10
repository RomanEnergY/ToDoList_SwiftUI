//
//  ListModel.swift
//  ToDoList_SwiftUI
//
//  Created by ZverikRS on 10.04.2025.
//

import SwiftUI

struct ListModel: Identifiable {
    let id: String
    let text: String
    
    // MARK: - initializers
    init (
        id: String = UUID().uuidString,
        text: String
    ) {
        self.id = id
        self.text = text
    }
}
