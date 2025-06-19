//
//  FileBookmarkListViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import Foundation
import AppKit
import Combine

final class FileBookmarkListViewModel: ObservableObject, ControllSubjectBindable, VmPassSubjectBindable, FolderSubjectBindable {    
    var usecase: FileBookmarkUseCase
    var controllSubject: PassthroughSubject<ControllerMessage, Never>
    var vmPassSubject: PassthroughSubject<VmPassMessage, Never>
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var cancellables: Set<AnyCancellable> = []
    
    @Published var selectedFolder: Folder?
    @Published var items: [FileBookmarkItem]
    
    init(
        items: [FileBookmarkItem] = [],
        usecase: FileBookmarkUseCase,
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        vmPassSubject: PassthroughSubject<VmPassMessage, Never>,
        selectedFolderSubject:CurrentValueSubject<Folder?, Never>
    ) {
        self.items = items
        self.usecase = usecase
        self.controllSubject = controllSubject
        self.vmPassSubject = vmPassSubject
        self.selectedFolderSubject = selectedFolderSubject
        
        vmPassMessageBinding()
        setupSelectedFolderBindings()
        setupControllMessageBindings()
    }
    
    func deleteCheckedItem() {
        vmPassSubject.send(.deleteCheckedBookmarkItem)
    }
}

// MARK: - VmPassSubject Binding
extension FileBookmarkListViewModel {
    private func vmPassMessageBinding() {
        vmPassMessageBindings() { [weak self] message in
            switch message {
            case .sendCheckedBookmarkItem(let item):
                self?.deleteCheckedItem(item)
            case .saveBookmarkItems:
                self?.saveBookmarkItems()
            default:
                break
            }
        }
    }
    
    private func deleteCheckedItem(_ item: FileBookmarkItem) {
        self.items = items.filter { $0.id != item.id }
    }
    
    private func saveBookmarkItems() {
        do {
            try usecase.saveItems(items)
        } catch {
            print("FileBookmarkListViewModel-saveBookmarkItems: \(error)")
        }
    }
}

extension FileBookmarkListViewModel {
    func setupControllMessageBindings() {
        controllMessageBindings { [weak self] message in
            switch message {
            case .didHideFileBookmarkCreateView:
                self?.items = []                
            default:
                return
            }
        }
    }
}

// MARK: - bookmark 생성
extension FileBookmarkListViewModel {
    func addFileOrFolder() {
        guard let urls = selectFileOrFolder() else { return }
        guard let folderId = selectedFolder?.id else { return }
                
        for url in urls {
            /// Security-Scoped Bookmark 생성(macOS 정책)
            guard let bookmarkData = createBookmark(for: url) else {
                print("FileBookmarkListViewModel-addFileOrFolder, 북마크 생성 실패: \(url.lastPathComponent)")
                continue
            }
            
            let itemType: FileBookmarkType = url.hasDirectoryPath ? .folder : .file
            let workspace = NSWorkspace.shared
            let fileIcon = workspace.icon(forFile: url.path)
            
            let newItem = FileBookmarkItem(
                folderId: folderId,
                name: url.lastPathComponent,
                type: itemType,
                bookmarkData: bookmarkData,
                image: fileIcon,
                order: 0
            )
            
            items.append(newItem)
        }
    }
    
    private func selectFileOrFolder() -> [URL]? {
        controllSubject.send(.stopPageAutohide)
        
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.canCreateDirectories = false
        
        let result = panel.runModal()  // 창이 닫힐 때까지 대기
        
        controllSubject.send(.restartPageAutohide)  // 창이 닫힌 후에 재시작
        
        if result == .OK {
            return panel.urls
        }
        return nil
    }
    
    private func createBookmark(for url: URL) -> Data? {
        do {
            let bookmarkData = try url.bookmarkData(
                options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess],
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            return bookmarkData
        } catch {
            print("FileBookmarkListViewModel-createBookmark, 북마크 생성 오류: \(error)")
            return nil
        }
    }
}
