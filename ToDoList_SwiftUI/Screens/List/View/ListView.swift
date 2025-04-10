//
//  ListView.swift
//  ToDoList_SwiftUI
//
//  Created by ZverikRS on 10.04.2025.
//

import SwiftUI

struct ListView<ViewModel: ListViewModelProtocol>: View {
    
    // MARK: - private properties
    @StateObject private var viewModel: ViewModel
    @Environment(\.editMode) private var editMode
    
    init(config: ListViewBuilder<ViewModel>.Config) {
        _viewModel = .init(wrappedValue: config.viewModel)
    }
    
    // MARK: - life cycle
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .tint(.blue)
                
            case .data(let inWork, let completed):
                if inWork.items.isEmpty && completed.items.isEmpty {
                    ListEmptyViewBuilder(
                        config: .init(
                            viewModel: viewModel.addViewModel)
                    ).build()
                        .transition(.opacity.animation(.easeIn))
                    
                } else {
                    List {
                        if !inWork.items.isEmpty {
                            Section("In work") {
                                section(data: inWork, isCompleted: false)
                            }
                        }
                        
                        if !completed.items.isEmpty {
                            Section("Completed") {
                                section(data: completed, isCompleted: true)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .transition(.opacity.animation(.easeIn))
                }
            }
        }
        .background(.white)
        .navigationTitle("Todo List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if case let .data(inWork, completed) = viewModel.state,
                   !(inWork.items.isEmpty && completed.items.isEmpty) {
                    EditButton()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if case let .data(inWork, completed) = viewModel.state,
                   !(inWork.items.isEmpty && completed.items.isEmpty) {
                    NavigationLink("Add") {
                        AddViewBuilder(
                            config: .init(
                                viewModel: viewModel.addViewModel)
                        ).build()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ListViewBuilder(
            config: .init(
                viewModel: ListViewModel())
        ).build()
    }
    .navigationViewStyle(.stack)
}

// MARK: - calculated properties
private extension ListView {
    func section(data: ListViewModel.SectionData, isCompleted: Bool) -> some View {
        ForEach(data.items) { item in
            LazyVStack {
                ListItemView(
                    title: item.text,
                    isCompleted: isCompleted,
                    editMode: editMode?.wrappedValue,
                    onUpdateState: {
                    withAnimation(.linear) {
                        data.onUpdateState(item.id)
                    }
                })
            }
        }
        .onDelete { indexSet in
            withAnimation(.linear) {
                data.onDelete(indexSet)
            }
        }
        .onMove { indexSet, index in
            withAnimation(.linear) {
                data.onMove(indexSet, index)
            }
        }
    }
}
