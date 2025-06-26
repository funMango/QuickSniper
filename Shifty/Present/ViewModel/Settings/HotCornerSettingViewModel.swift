//
//  HotCornerViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/12/25.
//

import Foundation
import Combine

final class HotCornerSettingViewModel: ObservableObject {
    @Published var selectedPosition: HotCornerPosition = .bottomLeft
    private let hotCornerSubject: CurrentValueSubject<HotCornerMessage?, Never>
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        hotCornerSubject: CurrentValueSubject<HotCornerMessage?, Never>
    ) {
        self.hotCornerSubject = hotCornerSubject
        setupControllMessageBindings()
    }
        
    func setSelectedPosition(_ position: HotCornerPosition) {
        self.selectedPosition = position
        hotCornerSubject.send(.changeHotCornerPosition(position))
    }
    
    private func setupControllMessageBindings() {
        hotCornerSubject
            .sink { [weak self] message in
                guard let self = self else { return }
                
                switch message {
                case .setupHotCornerPosition(let position):
                    print(position.displayName)
                    self.selectedPosition = position
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
