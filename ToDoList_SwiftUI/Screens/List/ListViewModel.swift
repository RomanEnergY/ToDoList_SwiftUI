//
//  ListViewModel.swift
//  ToDoList_SwiftUI
//
//  Created by ZverikRS on 10.04.2025.
//

import Foundation
import SwiftUICore

protocol ListViewModelProtocol: ObservableObject {
    var state: ListViewModel.State { get set }
    var addViewModel: AddViewModelProtocol { get }
}

final class ListViewModel: ListViewModelProtocol, ObservableObject {
    
    // MARK: - public properties
    var addViewModel: AddViewModelProtocol {
        self
    }
    @Published var state: State = .loading {
        didSet {
            saveData()
        }
    }
    
    // MARK: - private properties
    private let manager: ListManagerProtocol
    
    // MARK: - initializers
    init(manager: (any ListManagerProtocol)? = nil) {
        self.manager = manager ?? ListManager()
        loadData()
    }
}

// MARK: - calculated properties
private extension ListViewModel {
    private func loadData() {
        Task.detached { [weak self] in
            guard let model = await self?.manager.loadData() else { return }
            await self?.handlerLoadData(model: model)
        }
    }
    
    @MainActor
    private func handlerLoadData(model: ListManagerModel) {
        state = .data(
            inWork: .init(
                items: model.inWork.map { $0.convert },
                onUpdateState: { [weak self] id in
                    self?.handlerUpdateState(isWorking: true, id: id)
                },
                onDelete: { [weak self] indexSet in
                    self?.handlerDelete(isWorking: true, indexSet: indexSet)
                },
                onMove: { [weak self] indexSet, index in
                    self?.handlerMove(isWorking: true, indexSet: indexSet, index: index)
                }),
            completed: .init(
                items: model.completed.map { $0.convert },
                onUpdateState: { [weak self] id in
                    self?.handlerUpdateState(isWorking: false, id: id)
                },
                onDelete: { [weak self] indexSet in
                    self?.handlerDelete(isWorking: false, indexSet: indexSet)
                }, onMove: { [weak self] indexSet, index in
                    self?.handlerMove(isWorking: false, indexSet: indexSet, index: index)
                }))
    }
    
    private func handlerUpdateState(isWorking: Bool, id: String) {
        guard case var .data(inWork, completed) = state else { return }
        var workingItems: [ListModel] = inWork.items
        var completedItems: [ListModel] = completed.items
        
        if isWorking {
            guard let index = workingItems.firstIndex(where: { $0.id == id }) else { return }
            let element = workingItems.remove(at: index)
            completedItems.insert(element, at: 0)
            
        } else {
            guard let index = completedItems.firstIndex(where: { $0.id == id }) else { return }
            let element = completedItems.remove(at: index)
            workingItems.insert(element, at: 0)
        }
        
        inWork.items = workingItems
        completed.items = completedItems
        state = .data(inWork: inWork, completed: completed)
    }
    
    private func handlerDelete(isWorking: Bool, indexSet: IndexSet) {
        guard case var .data(inWork, completed) = state else { return }
        var items: [ListModel] = (isWorking ? inWork : completed).items
        items.remove(atOffsets: indexSet)
        
        if isWorking {
            inWork.items = items
        } else {
            completed.items = items
        }
        
        state = .data(inWork: inWork, completed: completed)
    }
    
    private func handlerMove(isWorking: Bool, indexSet: IndexSet, index: Int) {
        guard case var .data(inWork, completed) = state else { return }
        var items: [ListModel] = (isWorking ? inWork : completed).items
        items.move(fromOffsets: indexSet, toOffset: index)
        
        if isWorking {
            inWork.items = items
        } else {
            completed.items = items
        }
        
        state = .data(inWork: inWork, completed: completed)
    }
    
    private func saveData() {
        guard case let .data(inWork, completed) = state else { return }
        Task.detached { [weak self] in
            await self?.manager.saveData(model: .init(
                inWork: inWork.items.map { $0.convert },
                completed: completed.items.map { $0.convert }))
        }
    }
}

// MARK: - AddViewModel
extension ListViewModel: AddViewModelProtocol {
    func addItem(text: String) {
        guard case .data(var inWork, let completed) = state else { return }
        let model: ListModel = .init(text: text)
        inWork.items.insert(model, at: 0)
        state = .data(inWork: inWork, completed: completed)
    }
}

// MARK: - Entity
extension ListViewModel {
    enum State {
        case loading
        case data(
            inWork: SectionData,
            completed: SectionData)
    }
}

extension ListViewModel {
    struct SectionData {
        var items: [ListModel]
        let onUpdateState: (_ id: String) -> Void
        let onDelete: (_ indexSet: IndexSet) -> Void
        let onMove: (_ indexSet: IndexSet, _ index: Int) -> Void
    }
}

// MARK: - calculated properties
private extension ListModel {
    var convert: ListManagerModel.Item {
        .init(text: text)
    }
}

private extension ListManagerModel.Item {
    var convert: ListModel {
        .init(text: text)
    }
}
