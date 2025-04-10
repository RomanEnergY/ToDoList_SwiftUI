//
//  ListViewBuilder.swift
//  ToDoList_SwiftUI
//
//  Created by ZverikRS on 13.04.2025.
//

import Foundation

struct ListViewBuilder<ViewModel: ListViewModelProtocol>: Builder {
    struct Config {
        let viewModel: ViewModel
    }
    
    // MARK: - public properties
    let config: Config
    
    // MARK: - life cycle
    func build() -> ListView<ViewModel> {
        .init(config: config)
    }
}
