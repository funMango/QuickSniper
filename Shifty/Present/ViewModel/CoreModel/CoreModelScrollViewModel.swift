//
//  CoreModelScrollViewModel.swift
//  Shifty
//
//  Created by 이민호 on 6/30/25.
//

import Foundation
import Combine

final class CoreModelScrollViewModel: ObservableObject, ControllSubjectBindable, CoreModelSubjectBindable, FolderSubjectBindable {
    
    @Published var coreModels: [any CoreModel] = []
    @Published var selectedFolder: Folder?
                    
    var controllSubject: PassthroughSubject<ControllerMessage, Never>
    var coreModelSubject: CurrentValueSubject<CoreModelMessage?, Never>
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var coreModelUseCase: CoreModelUseCase
    
    var cancellables: Set<AnyCancellable> = []
    
    init(controllSubject: PassthroughSubject<ControllerMessage, Never>,
         coreModelSubject: CurrentValueSubject<CoreModelMessage?, Never>,
         selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
         coreModelUseCase: CoreModelUseCase
    ) {
        self.controllSubject = controllSubject
        self.coreModelSubject = coreModelSubject
        self.selectedFolderSubject = selectedFolderSubject
        self.coreModelUseCase = coreModelUseCase
        
        setupControllMessageBinding()
        setupSelectedFolderBindings()        
        setupCoreModels()                       
    }
}

extension CoreModelScrollViewModel {
    func setupControllMessageBinding() {
        controllMessageBindings{ message in
            switch message {
            
            default:
                break
            }
        }
    }
    
    func setupCoreModelMessageBinding() {
        coreModelMessageBindings() { [weak self] message in
            switch message {
            case .updated:
                self?.setupCoreModels()
            default:
                break
            }
        }
    }
    
    func setupCoreModels() {
        print("setupCoreModels")
        $selectedFolder
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] folder in
                guard let self = self else { return }
                
                self.coreModels = self.coreModelUseCase.fetch()
                    .filter { $0.folderId == folder.id }
                    .sorted { $0.id < $1.id }
                
                print("coreModels count: \(self.coreModels.count)")
            }
            .store(in: &cancellables)
    }
}
