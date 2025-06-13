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
    private let pageManager: PageManager
    private let serviceContainer: ServiceContainer
        
    init() {
        if let (
            modelContainer,
            modelContext,
            viewModelContainer,
            controllerContainer,
            keyboardShortcutManager,
            pageManger,
            serviceContainer
        ) = QuickSniperApp.configureDependencies() {
            self.modelContainer = modelContainer
            self.modelContext = modelContext
            self.viewModelContainer = viewModelContainer
            self.controllerContainer = controllerContainer
            self.keyboardShortcutManager = keyboardShortcutManager
            self.pageManager = pageManger
            self.serviceContainer = serviceContainer
        } else {
            fatalError("❌ 의존성 구성 실패")
        }
    }

    var body: some Scene {
        MenuBarExtra(
            "shifty",
            systemImage: "arrow.up.circle.fill"
        ) {
            AppMenuBarView(
                viewModel: viewModelContainer.appMenuBarViewModel
            )
            .environment(\.modelContext, modelContext)
        }
        .menuBarExtraStyle(.window)
    }
            
    private static func configureDependencies() -> (
        modelContainer: ModelContainer,
        modelContext: ModelContext,
        viewModelContainer: ViewModelContainer,
        controllerContainer: ControllerContainer,
        keyboardShortcutManager: KeyboardShortcutManager,
        pageManager: PageManager,
        serviceContainer: ServiceContainer
    )? {
        do {
            let container = try ModelContainer(for: Folder.self, Snippet.self, User.self)
            let context = container.mainContext
            
            let controllerSubject = PassthroughSubject<ControllerMessage, Never>()
            let folderSubject = CurrentValueSubject<Folder?, Never>(nil)
            let folderEditSubject = PassthroughSubject<Folder, Never>()
            let selectedFolderSubject = CurrentValueSubject<Folder?, Never>(nil)
            let geometrySubject = CurrentValueSubject<CGRect, Never>(.zero)
            let snippetSubject = CurrentValueSubject<SnippetMessage?, Never>(nil)
            let serviceSubject = CurrentValueSubject<ServiceMessage?, Never>(nil)
            let hotCornerSubject = CurrentValueSubject<HotCornerMessage?, Never>(nil)
                        
            let viewModelContainer = ViewModelContainer(
                modelContext: context,
                controllerSubject: controllerSubject,
                folderSubject: folderSubject,
                folderEditSubject: folderEditSubject,
                selectedFolderSubject: selectedFolderSubject,
                geometrySubject: geometrySubject,
                snippetSubject: snippetSubject,
                serviceSubject: serviceSubject,
                hotCornerSubject: hotCornerSubject
            )
            
            let controllerConntainer = ControllerContainer(
                controllSubject: controllerSubject,
                hotCornerSubject: hotCornerSubject,
                geometrySubject: geometrySubject
            )
            
            let keyboardShortcutManager = KeyboardShortcutManager(                
                controllerSubject: controllerSubject
            )
            
            let pageManager = PageManager(controllSubject: controllerSubject)
            
            let serviceContainer = ServiceContainer(
                serviceSubject: serviceSubject,
                controllSubject: controllerSubject,
                snippetSubject: snippetSubject
            )
                
            Resolver.register { controllerConntainer }.scope(.application)
            Resolver.register { context }.scope(.application)
            Resolver.register { viewModelContainer }.scope(.application)
            Resolver.register { keyboardShortcutManager }.scope(.application)
            Resolver.register { pageManager }.scope(.application)
            Resolver.register { serviceContainer }.scope(.application)
                                    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                controllerSubject.send(.openPanel)
                controllerSubject.send(.openHotCorner)
            }

            return (container, context, viewModelContainer, controllerConntainer, keyboardShortcutManager, pageManager, serviceContainer)
        } catch {
            print("❌ ModelContainer 생성 실패: \(error)")
            return nil
        }
    }
}
