//
//  FolderButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/27/25.
//

import Foundation
import Combine

final class FolderButtonViewModel: ObservableObject {
    @Published var hoveredFolder: Folder?
    private var folderSubject: CurrentValueSubject<Folder?, Never>
    
    init(
        hoveredFolder: Folder? = nil,
        folderSubject: CurrentValueSubject<Folder?, Never>        
    ) {
        self.hoveredFolder = hoveredFolder
        self.folderSubject = folderSubject
    }
    
    func setFolder(_ folder: Folder?) {
        self.hoveredFolder = folder
        sendHoveredFolder()
    }
    
    private func sendHoveredFolder() {        
        folderSubject.send(hoveredFolder)
    }
}
