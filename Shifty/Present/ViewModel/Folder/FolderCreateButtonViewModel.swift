//
//  FolderCreateButtonViewModel.swift
//  Shifty
//
//  Created by 이민호 on 6/30/25.
//

import Foundation
import Combine
import Resolver

final class FolderCreateButtonViewModel: ObservableObject, FolderSubjectBindable, QuerySyncableObject {
    @Injected var subscriptionManager: SubscriptionManager
    typealias Item = Folder
    var allItems: [Folder] = []
    var folderUsecase: FolderUseCase
    var controllerSubject: PassthroughSubject<ControllerMessage, Never>
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var folderEditSubject: CurrentValueSubject<Folder?, Never>
    var selectedFolder: Folder?
    var cancellables: Set<AnyCancellable> = []
    
    init(controllerSubject: PassthroughSubject<ControllerMessage, Never>,
         selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
         folderEditSubject: CurrentValueSubject<Folder?, Never>,
         folderUsecase: FolderUseCase) {
        self.controllerSubject = controllerSubject
        self.selectedFolderSubject = selectedFolderSubject
        self.folderEditSubject = folderEditSubject
        self.folderUsecase = folderUsecase
    }
    
    func getItems(_ items: [Folder]) {
        self.allItems = items
    }        
    
    @MainActor
    func validFolderCount() {
        if allItems.count >= StoreKitConfig.freeFolderLimit {
            if !subscriptionManager.isPro {
                // controllerSubject.send(.openSubscriptionView)
                showLimitFolderAlert()
            }
        } else {
            createFolder()
        }
    }
    
    
    func createFolder() {
        do {
            let newFolder = Folder(
                name: "",
                type: .all,
                order: 0
            )
            try folderUsecase.createFolder(newFolder)
            
            DispatchQueue.main.async { [weak self] in
                self?.selectedFolderSubject.send(newFolder)
                self?.folderEditSubject.send(newFolder)
            }
        } catch {
            print("[Error]: \(error)")
        }
    }
}

extension FolderCreateButtonViewModel {
    func showLimitFolderAlert() {
        let folderLimitInfo = getFolderLimitMessage()
        
        AlertManager.showOneButtonAlert(
            messageText: folderLimitInfo.title,
            informativeText: folderLimitInfo.message
        ) { [weak self] in
            self?.controllerSubject.send(.openPanel)
        }
    }
    
    private func getFolderLimitMessage() -> (title: String, message: String) {
        let isKorean = Locale.current.language.languageCode?.identifier == "ko"
        
        if isKorean {
            return (
                title: "폴더 개수 제한",
                message: "더 많은 폴더가 필요하시나요?\nPro 기능을 열심히 준비 중입니다!\n\n무제한 폴더 생성과 더 다양한 기능을 제공하는\n업데이트가 곧 출시될 예정입니다.\n\n많은 기대 부탁드립니다! 🚀"
            )
        } else {
            return (
                title: "Folder Limit Reached",
                message: "You can create up to 3 folders.\n\nNeed more folders?\nPro features are coming soon!\n\nAn update with unlimited folder creation\nand various new features will be released shortly.\n\nStay tuned! 🚀"
            )
        }
    }
}
