//
//  AddViewBuilder.swift
//  ToDoList_SwiftUI
//
//  Created by ZverikRS on 13.04.2025.
//

import Foundation
import SwiftUICore

struct AddViewBuilder: Builder {
    struct Config {
        let viewModel: AddViewModelProtocol
    }
    
    // MARK: - public properties
    let config: Config
    
    // MARK: - life cycle
    func build() -> AddView {
        .init(config: config)
    }
}
