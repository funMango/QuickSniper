//
//  DraggableView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/5/25.
//

import Foundation
import SwiftUI

protocol DraggableView: View {
    associatedtype VM: DragabbleObject
    associatedtype Item: CoreModel where VM.Item == Item
    
    var viewModel: VM { get }
    var draggingItem: String? { get set }
    init(viewModel: VM)
        
    func getDraggingBinding() -> Binding<String?>
}

extension View {
    func dragDrop<VM: DragabbleObject>(
        viewModel: VM,
        draggingItemId: Binding<String?>,
        itemId: String
    ) -> some View {
        self.modifier(
            DragDropModifier(
                draggingItemId: draggingItemId,
                viewModel: viewModel,
                itemId: itemId
            )
        )
    }
}

struct DragDropModifier<VM: DragabbleObject>: ViewModifier {
    @State private var isDragPressed = false
    @State private var lastTargetedItem: String? = nil
    @Binding var draggingItemId: String?
    var viewModel: VM
    let itemId: String
    
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .fill(Color.black.opacity(isDragPressed ? 0.3 : 0))
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onDrag {
                draggingItemId = itemId
                viewModel.selectItem(itemId)
                return NSItemProvider(object: NSString(string: itemId))
            } preview: {
                // 주의!: EmptyView() 사용시 오류
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 0, height: 0)
            }
            .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 10) {                
            } onPressingChanged: { pressing in
                isDragPressed = pressing
            }
            .dropDestination(for: String.self) { items, location in
                if let draggingItemId = draggingItemId {
                    handleDrop(from: draggingItemId, to: itemId, save: true)
                }
                
                draggingItemId = nil
                lastTargetedItem = nil
                return true
            } isTargeted: { status in
                if let draggingItemId, status, draggingItemId != itemId {
                    if lastTargetedItem != itemId {
                        lastTargetedItem = itemId
                        DispatchQueue.main.async {
                            handleDrop(from: draggingItemId, to: itemId, save: false)
                        }
                    }
                } else if !status {
                    lastTargetedItem = nil
                }
            }
    }
    
    func handleDrop(from draggingItemId: String, to targetItemId: String, save: Bool){
        let from = viewModel.items.firstIndex(where: { $0.id == draggingItemId })
        let to = viewModel.items.firstIndex(where: { $0.id == targetItemId })
        
        if let from, let to {
            withAnimation(.easeInOut) {
                let sourceItem = viewModel.items.remove(at: from)
                viewModel.items.insert(sourceItem, at: to)
                
                if save {
                    viewModel.updateItems()
                }
            }
        }
    }
}



