//
//  ListEmptyView.swift
//  ToDoList_SwiftUI
//
//  Created by ZverikRS on 13.04.2025.
//

import SwiftUI
import SwiftUICore

struct ListEmptyView: View {
    
    // MARK: - private properties
    private let viewModel: any AddViewModelProtocol
    @State private var animate: Bool = false
    
    // MARK: - initializers
    init(config: ListEmptyViewBuilder.Config) {
        self.viewModel = config.viewModel
    }
    
    // MARK: - life cycle
    var body: some View {
        VStack(spacing: 10) {
            Text("There are not items!")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("Are you a productive person? I think you should click the add button and add a bunch of items to your todo list!")
            
            NavigationLink {
                AddViewBuilder(
                    config: .init(
                        viewModel: viewModel)
                ).build()
                
            } label: {
                let backgroundColor = animate ? Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)) : Color.blue
                Text("Add Something! 🥳")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(backgroundColor)
                    .cornerRadius(10)
                    .padding(.horizontal, animate ? 50 : 20)
                    .scaleEffect(animate ? 1.1 : 1)
                    .offset(y: animate ? 6 : 0)
                    .shadow(
                        color: backgroundColor.opacity(0.5),
                        radius: animate ? 30 : 0,
                        x: 0,
                        y: animate ? 50 : 0)
            }
        }
        .multilineTextAlignment(.center)
        .ignoresSafeArea(.all)
        .padding(.horizontal, 20)
        .onAppear(perform: addAnimate)
        .frame(maxWidth: 400)
    }
    
    private func addAnimate() {
        guard !animate else { return }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: NSEC_PER_SEC * 1)
            withAnimation(
                Animation
                    .easeOut(duration: 2)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
}

#Preview {
    ListEmptyViewBuilder(
        config: .init(
            viewModel: ListViewModel())
    ).build()
}
