//
//  QuickSniperApp.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import SwiftUI
import AppKit
import KeyboardShortcuts
import Resolver
import SwiftData
import Combine

@main
struct QuickSniperApp: App {    
    private let controllerContainer:  ControllerContainer
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    private let viewModelContainer: ViewModelContainer
    private let keyboardShortcutManager: KeyboardShortcutManager
    
    init() {
        if let (modelContainer, modelContext, viewModelContainer) = QuickSniperApp.configureDependencies() {
            self.modelContainer = modelContainer
            self.modelContext = modelContext
            self.viewModelContainer = viewModelContainer
            self.controllerContainer = Resolver.resolve(ControllerContainer.self)
            self.keyboardShortcutManager = Resolver.resolve(KeyboardShortcutManager.self)
        } else {
            fatalError("❌ 의존성 구성 실패")
        }
                
        runInitialLaunchActions()
    }

    var body: some Scene {
        MenuBarExtra(
            "shifty",
            systemImage: "arrow.up.circle.fill"
        ) {
            AppMenuBarView(
                viewModel: viewModelContainer.appMenuBarViewModel
            )
        }
        .menuBarExtraStyle(.window)
    }
    
    private func runInitialLaunchActions() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            controllerContainer.panelController.toggle()
        }
    }
    
    private static func configureDependencies() -> (
        modelContainer: ModelContainer,
        modelContext: ModelContext,
        viewModelContainer: ViewModelContainer
    )? {
        do {
            let container = try ModelContainer(for: Folder.self, Snippet.self)
            let context = container.mainContext
            
            let controllerSubject = PassthroughSubject<ControllerMessage, Never>()
            let folderSubject = CurrentValueSubject<Folder?, Never>(nil)
            let folderEditSubject = PassthroughSubject<Folder, Never>()
            let selectedFolderSubject = CurrentValueSubject<Folder?, Never>(nil)
            let geometrySubject = CurrentValueSubject<CGRect, Never>(.zero)
            let snippetSubject = CurrentValueSubject<SnippetMessage?, Never>(nil)
            
            
            let viewModelContainer = ViewModelContainer(
                modelContext: context,
                controllerSubject: controllerSubject,
                folderSubject: folderSubject,
                folderEditSubject: folderEditSubject,
                selectedFolderSubject: selectedFolderSubject,
                geometrySubject: geometrySubject,
                snippetSubject: snippetSubject
            )
            
            let controllerConntainer = ControllerContainer(
                controllSubject: controllerSubject,
                geometrySubject: geometrySubject                
            )
            
            let keyboardShortcutManager = KeyboardShortcutManager(                
                controllerSubject: controllerSubject
            )
                
            Resolver.register { controllerConntainer }.scope(.application)
            Resolver.register { context }.scope(.application)
            Resolver.register { viewModelContainer }.scope(.application)
            Resolver.register { keyboardShortcutManager }.scope(.application)

            return (container, context, viewModelContainer)
        } catch {
            print("❌ ModelContainer 생성 실패: \(error)")
            return nil
        }
    }
}
