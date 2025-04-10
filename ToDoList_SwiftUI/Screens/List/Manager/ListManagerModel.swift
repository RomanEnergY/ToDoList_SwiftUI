//
//  ListManagerData.swift
//  ToDoList_SwiftUI
//
//  Created by ZverikRS on 13.04.2025.
//

import Foundation

struct ListManagerModel: Codable {
    let inWork: [Item]
    let completed: [Item]
    
    init(inWork: [Item] = [], completed: [Item] = []) {
        self.inWork = inWork
        self.completed = completed
    }
}

extension ListManagerModel {
    struct Item: Codable {
        let text: String
    }
}
