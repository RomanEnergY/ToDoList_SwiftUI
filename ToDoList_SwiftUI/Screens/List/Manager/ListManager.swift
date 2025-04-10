//
//  ListManager.swift
//  ToDoList_SwiftUI
//
//  Created by ZverikRS on 10.04.2025.
//

import SwiftUI

protocol ListManagerProtocol {
    func loadData() async -> ListManagerModel
    func saveData(model: ListManagerModel) async
}

final class ListManager: ListManagerProtocol {
    private enum CodingKeys: String {
        case model
    }
    
    // MARK: - private properties
    private let todoListStorage: UserDefaults? = .init(suiteName: "TodoList")
    
    // MARK: - public methods
    func loadData() async -> ListManagerModel {
        if let todoListStorage,
           let data = todoListStorage.data(forKey: CodingKeys.model.rawValue),
           let model = try? JSONDecoder().decode(ListManagerModel.self, from: data) {
            return model
            
        } else {
            return .init()
        }
    }
    
    func saveData(model: ListManagerModel) async {
        guard let encodedData = try? JSONEncoder().encode(model) else  { return }
        todoListStorage?.set(encodedData, forKey: CodingKeys.model.rawValue)
    }
}
