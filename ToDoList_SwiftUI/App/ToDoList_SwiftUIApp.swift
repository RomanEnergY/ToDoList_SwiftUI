//
//  ToDoList_SwiftUIApp.swift
//  ToDoList_SwiftUI
//
//  Created by ZverikRS on 10.04.2025.
//

import SwiftUI

@main
struct ToDoList_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListViewBuilder(
                    config: .init(
                        viewModel: ListViewModel())
                ).build()
            }
            .navigationViewStyle(.stack)
        }
    }
}
