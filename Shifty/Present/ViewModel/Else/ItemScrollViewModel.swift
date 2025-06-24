//
//  ItemScrollViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import Foundation
import Combine

final class ItemScrollViewModel: FolderBindableViewModel {
    override init(selectedFolderSubject: CurrentValueSubject<Folder?, Never>) {
        super.init(selectedFolderSubject: selectedFolderSubject)
        setupSelectedFolderBindings()
    }
}
