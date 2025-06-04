//
//  EdgeDropDelegate.swift
//  QuickSniper
//
//  Created by 이민호 on 6/4/25.
//

import Foundation
import SwiftUI

enum Edge { case left, right }

struct EdgeDropDelegate: DropDelegate {
    @Binding var draggingSnippet: Snippet?
    @Binding var snippets: [Snippet]
    @Binding var isDroped: Bool
    var destinationSnippet: Snippet
    
    func validateDrop(info: DropInfo) -> Bool {
        return draggingSnippet != nil
    }
    
    func dropEntered(info: DropInfo) {
        // 드래그 중에는 시각적 피드백만 제공
        guard let draggingSnippet = draggingSnippet,
              draggingSnippet.id != destinationSnippet.id else { return }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        defer { draggingSnippet = nil }
        
        guard let draggingSnippet = draggingSnippet,
              draggingSnippet.id != destinationSnippet.id,
              let fromIndex = snippets.firstIndex(where: { $0.id == draggingSnippet.id }),
              let toIndex = snippets.firstIndex(where: { $0.id == destinationSnippet.id })
        else { return false }
        
        // 배열 업데이트를 메인 스레드에서 명시적으로 수행
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.25)) {
                snippets.move(
                    fromOffsets: IndexSet(integer: fromIndex),
                    toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex
                )
                isDroped = true
            }
        }
        
        return true
    }
    
    func dropExited(info: DropInfo) {
        // 드롭 영역을 벗어났을 때
    }
}
