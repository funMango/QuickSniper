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
    @StateObject private var settingsWindowController = SettingsWindowController()
    private let controllerContainer:  ControllerContainer
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    private let viewModelContainer: ViewModelContainer
    
    init() {
        if let (modelContainer, modelContext, viewModelContainer) = QuickSniperApp.configureDependencies() {
            self.modelContainer = modelContainer
            self.modelContext = modelContext
            self.viewModelContainer = viewModelContainer
            self.controllerContainer = Resolver.resolve(ControllerContainer.self)
        } else {
            fatalError("❌ 의존성 구성 실패")
        }
        
        configureKeyboardShortcuts()
        runInitialLaunchActions()
    }

    var body: some Scene {
        MenuBarExtra("QuickSniper", systemImage: "bolt.circle.fill") {
            Button("패널 토글") {
                controllerContainer.panelController.toggle()
            }

            Button("단축키 설정") {
                settingsWindowController.showSettings()
            }

            Divider()

            Button("종료", role: .destructive) {
                NSApplication.shared.terminate(nil)
            }
        }
        .menuBarExtraStyle(.window)
    }
    
    private func configureKeyboardShortcuts() {
        if KeyboardShortcuts.getShortcut(for: .toggleQuickSniper) == nil {
            let shortcut = KeyboardShortcuts.Shortcut(.k, modifiers: [.option])
            KeyboardShortcuts.setShortcut(shortcut, for: .toggleQuickSniper)
        }

        KeyboardShortcuts.onKeyUp(for: .toggleQuickSniper) {
            controllerContainer.panelController.toggle()
        }
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
            let snippetSubject = PassthroughSubject<Snippet?, Never>()
            
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
                geometrySubject: geometrySubject,
                snippetSubject: snippetSubject
            )
                
            Resolver.register { controllerConntainer }.scope(.application)
            Resolver.register { context }.scope(.application)
            Resolver.register { viewModelContainer }.scope(.application)

            return (container, context, viewModelContainer)
        } catch {
            print("❌ ModelContainer 생성 실패: \(error)")
            return nil
        }
    }
}
