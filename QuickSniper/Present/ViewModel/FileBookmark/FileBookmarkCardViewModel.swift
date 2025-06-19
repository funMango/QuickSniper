//
//  FileBookmarkCardViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import AppKit
import Combine

final class FileBookmarkCardViewModel: ObservableObject, ControllSubjectBindable, FileBookmarkSubjectBindable {
    @Published var item: FileBookmarkItem
    @Published var isSelected: Bool = false
    
    var usecase: FileBookmarkUseCase
    var controllSubject: PassthroughSubject<ControllerMessage, Never>
    var fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(
        item: FileBookmarkItem,
        usecase: FileBookmarkUseCase,
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>
    ) {
        self.item = item
        self.usecase = usecase
        self.controllSubject = controllSubject
        self.fileBookmarkSubject = fileBookmarkSubject
        
        fileBookmarkMessageBindings()        
    }
    
    func sendSelectedFileBookmarkItemMesssage() {
        fileBookmarkSubject.send(.switchSelectedBookmarkItem(item))
    }
    
    func fileBookmarkMessageBindings() {
        fileBookmarkMessageBindings { [weak self] message in
            switch message {
            case .switchSelectedBookmarkItem(let item):
                self?.isSelected = item.id == self?.item.id
            default:
                break
            }
        }
    }
}

// MARK: - 파일, 폴더 열기
extension FileBookmarkCardViewModel {
    func openFile() {
        guard let bookmarkData = item.bookmarkData else {
            showMissingBookmarkAlert()
            return
        }

        var isStale = false

        do {
            let url = try URL(
                resolvingBookmarkData: bookmarkData,
                options: [.withSecurityScope],
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
            )
            
            /// 파일이 휴지통에 있는 경우
            if url.path.contains("/.Trash") || url.path.contains("/.Trashes") {
                showMissingBookmarkAlert()
                return
            }
            
            /// 파일 내용이 변경된 경우
            if isStale {
                showUpdateBookmarkAlert(from: url)
            }
                                    
            guard url.startAccessingSecurityScopedResource() else {
                showMissingBookmarkAlert()
                return
            }

            defer { url.stopAccessingSecurityScopedResource() }
                                    
            NSWorkspace.shared.open(url)
            
            DispatchQueue.main.async { [weak self] in
                self?.controllSubject.send(.escapePressed)
            }
            
        } catch {
            print("[ERROR]: FileBookmarkCardViewModel-openFile: \(error)")
            showMissingBookmarkAlert()
        }
    }
    
    func updateFile(from url: URL) throws {
        guard url.startAccessingSecurityScopedResource() else {
            throw NSError(domain: "FileAccess", code: 1, userInfo: [NSLocalizedDescriptionKey: "보안 스코프 리소스 접근 실패"])
        }
            
        defer { url.stopAccessingSecurityScopedResource() }
        
        // 1. 새로운 북마크 데이터 생성
        let newBookmarkData = try url.bookmarkData(
            options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess],
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )
        
        // 2. 파일 이름 업데이트
        let fileName = url.deletingPathExtension().lastPathComponent
        
        // 3. 파일 타입 확인 및 업데이트
        let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
        let newType: FileBookmarkType = resourceValues.isDirectory == true ? .folder : .file
        
        // 4. 아이콘 데이터 업데이트
        let workSpace = NSWorkspace.shared
        let icon = workSpace.icon(forFile: url.path)
        
        // 5. 모델 업데이트
        item.name = fileName
        item.type = newType
        item.bookmarkData = newBookmarkData
        item.update(
            name: fileName,
            type: newType,
            bookmarkData: newBookmarkData,
            image: icon
        )
        
        try usecase.update(item)
    }
}

extension FileBookmarkCardViewModel {
    private func showMissingBookmarkAlert() {
        AlertManager.showTwoButtonAlert(
            messageText: "fileAccessAlert",
            informativeText: "fileAccessAlertContent",
            confirmButtonText: "delete"
        ) {
            do {
                try usecase.delete(self.item)
            } catch {
                print("[ERROR]: FileBookmarkCardViewModel-showMissingBookmarkAlert: \(error)")
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.controllSubject.send(.openPanel)
        }
    }
    
    private func showUpdateBookmarkAlert(from url: URL) {
        AlertManager.showTwoButtonAlert(
            messageText: "fileChangedAlert",
            informativeText: "fileChangedAlertContent",
            confirmButtonText: "update"
        ) {
            do {
                try updateFile(from: url)
            } catch {
                print("[ERROR]: FileBookmarkCardViewModel-showUpdateBookmarkAlert: \(error)")
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.controllSubject.send(.openPanel)
        }
    }
}
