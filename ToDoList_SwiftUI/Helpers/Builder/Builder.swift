//
//  Builder.swift
//  ToDoList_SwiftUI
//
//  Created by ZverikRS on 13.04.2025.
//

import Foundation

protocol Builder {
    associatedtype Module
    func build() -> Module
}
