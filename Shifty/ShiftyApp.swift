//
//  ShiftyApp.swift
//  Shifty
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
struct ShiftyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
        ) = ShiftyApp.configureDependencies() {
            self.modelContainer = modelContainer
            self.modelContext = modelContext
            self.viewModelContainer = viewModelContainer
            self.controllerContainer = controllerContainer
            self.keyboardShortcutManager = keyboardShortcutManager
            self.pageManager = pageManger
            self.serviceContainer = serviceContainer
        } else {
            fatalError("[Error]: QuickSniperApp: 의존성 구성 실패")
        }
    }

    var body: some Scene {
        MenuBarExtra(
            "shifty",
            image: "menubarIcon"
        ) {
            AppMenuBarView(
                viewModel: viewModelContainer.appMenuBarViewModel
            )
            .environment(\.modelContext, modelContext)
        }
        .menuBarExtraStyle(.menu)
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
            /// SwiftData
            let container = try ModelContainer(for: Folder.self, Snippet.self, User.self, FileBookmarkItem.self)
            let context = container.mainContext
            
            /// Core Subject
            let controllerSubject = PassthroughSubject<ControllerMessage, Never>()
            let vmPassSubject = PassthroughSubject<VmPassMessage, Never>()
            
            /// Option Subject
            let folderSubject = CurrentValueSubject<Folder?, Never>(nil)
            let folderEditSubject = CurrentValueSubject<Folder?, Never>(nil)
            let selectedFolderSubject = CurrentValueSubject<Folder?, Never>(nil)
            let folderMessageSubjec = CurrentValueSubject<FolderMessage?, Never>(nil)
            let snippetSubject = CurrentValueSubject<SnippetMessage?, Never>(nil)
            let serviceSubject = CurrentValueSubject<ServiceMessage?, Never>(nil)
            let hotCornerSubject = CurrentValueSubject<HotCornerMessage?, Never>(nil)
            let fileBookmarkSubject = CurrentValueSubject<FileBookmarkMessage?, Never>(nil)
            let coreModelSubject = CurrentValueSubject<CoreModelMessage?, Never>(nil)
                        
            let viewModelContainer = ViewModelContainer(
                modelContext: context,
                controllerSubject: controllerSubject,
                vmPassSubject: vmPassSubject,                
                folderSubject: folderSubject,
                folderEditSubject: folderEditSubject,
                selectedFolderSubject: selectedFolderSubject,
                folderMessageSubject: folderMessageSubjec,
                snippetSubject: snippetSubject,
                serviceSubject: serviceSubject,
                hotCornerSubject: hotCornerSubject,
                fileBookmarkSubject: fileBookmarkSubject,
                coreModelSubject: coreModelSubject
            )
            
            let controllerConntainer = ControllerContainer(
                controllSubject: controllerSubject,
                hotCornerSubject: hotCornerSubject
            )
            
            let keyboardShortcutManager = KeyboardShortcutManager(                
                controllerSubject: controllerSubject
            )
            
            let pageManager = PageManager(controllSubject: controllerSubject)
            let subscriptionManager = SubscriptionManager()
            
            let serviceContainer = ServiceContainer(
                serviceSubject: serviceSubject,
                controllSubject: controllerSubject,
                snippetSubject: snippetSubject,
                selectedFolderSubject: selectedFolderSubject
            )
                
            Resolver.register { controllerConntainer }.scope(.application)
            Resolver.register { context }.scope(.application)
            Resolver.register { viewModelContainer }.scope(.application)
            Resolver.register { keyboardShortcutManager }.scope(.application)
            Resolver.register { pageManager }.scope(.application)
            Resolver.register { subscriptionManager }.scope(.application)
            Resolver.register { serviceContainer }.scope(.application)
            
            /// System init function
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                controllerSubject.send(.openPanel)                
            }

            return (container, context, viewModelContainer, controllerConntainer, keyboardShortcutManager, pageManager, serviceContainer)
        } catch {
            print("❌ ModelContainer 생성 실패: \(error)")
            return nil
        }
    }
}
