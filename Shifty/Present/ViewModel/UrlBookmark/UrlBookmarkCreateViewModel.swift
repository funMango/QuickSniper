//
//  UrlBookmarkCreateViewModel.swift
//  Shifty
//
//  Created by 이민호 on 6/27/25.
//

import Foundation
import Combine

final class UrlBookmarkCreateViewModel: ObservableObject, ControllSubjectBindable, FolderSubjectBindable {
    @Published var title: String = ""
    @Published var urlString: String = ""
    @Published var isValidURL = true
    var urlBookmarkUsecase: UrlBookmarkUseCase
    var controllSubject: PassthroughSubject<ControllerMessage, Never>
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    let faviconManager = FaviconManager()
    var selectedFolder: Folder?
    var cancellables: Set<AnyCancellable> = []
    
    init(
        urlBookmarkUsecase: UrlBookmarkUseCase,
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    ) {
        self.urlBookmarkUsecase = urlBookmarkUsecase
        self.controllSubject = controllSubject
        self.selectedFolderSubject = selectedFolderSubject
        
        /// function
        setupControllMessageBindings()
        setupSelectedFolderBindings()
    }
    
    func buttonDisabled() -> Bool {
        return title.isEmpty || urlString.isEmpty
    }
    
    func save() {
        isValidURL = true
        
        guard let url = URL(string: urlString) else {
            print("[ERROR]: UrlBookmarkCreateViewModel-save: 해당 URL을 찾지 못함")
            isValidURL = false
            return
        }
        
        guard let folder = selectedFolder else {
            print("[ERROR]: UrlBookmarkCreateViewModel-save: 선택된 폴더가 없음")
            return
        }
        
        faviconManager.fetchFavicon(for: url) { [weak self] data in
            guard let self = self else {
                print("[ERROR]: UrlBookmarkCreateViewModel-save: ViewModel이 메모리에서 해제")
                return
            }
            
            let urlBookmark = UrlBookmark(
                folderId: folder.id,
                title: self.title,
                url: self.urlString,
                iconData: data,
                order: 0
            )
            
            urlBookmarkUsecase.save(urlBookmark)
        }
    }
    
    func cancel() {
        controllSubject.send(.escapePressed)
    }
    
    func reset() {
        self.title = ""
        self.urlString = ""
    }        
}

// MARK: - Message Bindings
extension UrlBookmarkCreateViewModel {
    func setupControllMessageBindings() {
        controllMessageBindings{ [weak self] message in
            switch message {
            case .didHideUrlBookmarkCreateView:
                self?.reset()
            default:
                break
            }
        }
    }
}
