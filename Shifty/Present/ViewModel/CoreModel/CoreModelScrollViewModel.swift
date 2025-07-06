//
//  CoreModelScrollViewModel.swift
//  Shifty
//
//  Created by 이민호 on 6/30/25.
//

import Foundation
import Combine
import Resolver

final class CoreModelScrollViewModel: ObservableObject, ControllSubjectBindable, CoreModelSubjectBindable, FolderSubjectBindable {
    @Published var coreModels: [any CoreModel] = []
    @Published var selectedFolder: Folder?
                    
    @Injected var controllSubject: PassthroughSubject<ControllerMessage, Never>
    @Injected var coreModelSubject: CurrentValueSubject<CoreModelMessage?, Never>
    @Injected var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var coreModelUseCase: CoreModelUseCase    
    var cancellables: Set<AnyCancellable> = []
    
    init(coreModelUseCase: CoreModelUseCase) {
        self.coreModelUseCase = coreModelUseCase
        
        setupControllMessageBinding()
        setupCoreModelMessageBinding()
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
        $selectedFolder
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] folder in
                guard let self = self else { return }
                                
                    self.coreModels = self.coreModelUseCase.fetch()
                        .filter { $0.folderId == folder.id }
                        .sorted { $0.id < $1.id }
                                                
            }
            .store(in: &cancellables)
    }
}
