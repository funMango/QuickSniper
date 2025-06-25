//
//  PanelHeaderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/6/25.
//

import Foundation
import Combine
import Resolver

final class PanelHeaderViewModel: ObservableObject, QuerySyncableObject {
    typealias Item = Folder
    @Injected var subscriptionManager: SubscriptionManager
    var allItems: [Folder] = []
    private let controllerSubject: PassthroughSubject<ControllerMessage, Never>
    
    init(controllerSubject: PassthroughSubject<ControllerMessage, Never>) {
        self.controllerSubject = controllerSubject
    }
    
    @MainActor
    func openCreateFolderView() {
        if allItems.count >= StoreKitConfig.freeFolderLimit {
            if !subscriptionManager.isPro {
                // controllerSubject.send(.openSubscriptionView)
                showLimitFolderAlert()
            }
        } else {
            controllerSubject.send(.openCreateFolderView)
        }
    }
        
    func getItems(_ items: [Folder]) {
        self.allItems = items
    }
    
    func closePanel() {
        controllerSubject.send(.hidePanel)
    }
}

extension PanelHeaderViewModel {
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
