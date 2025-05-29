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
    private var geometrySubject: CurrentValueSubject<CGRect, Never>
    
    init(
        hoveredFolder: Folder? = nil,
        folderSubject: CurrentValueSubject<Folder?, Never>,
        geometrySubject: CurrentValueSubject<CGRect, Never>
    ) {
        self.hoveredFolder = hoveredFolder
        self.folderSubject = folderSubject
        self.geometrySubject = geometrySubject
    }
    
    func setFolder(_ folder: Folder?) {
        self.hoveredFolder = folder
        sendHoveredFolder()
    }
    
    private func sendHoveredFolder() {        
        folderSubject.send(hoveredFolder)
    }
    
    func setFolderPosition(_ geometry: CGRect) {        
        geometrySubject.send(geometry)
    }
}
