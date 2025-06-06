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
    @Binding var draggingItemId: String?
    var viewModel: VM
    let itemId: String
    
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .fill(Color.black.opacity(isDragPressed ? 0.3 : 0))
                    .animation(.easeInOut(duration: 0.15), value: isDragPressed)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onDrag {
                draggingItemId = itemId
                return NSItemProvider(object: NSString(string: itemId))
            } preview: {
                // 주의!: EmptyView() 사용시 오류
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 0, height: 0)
            }
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) {
            } onPressingChanged: { pressing in
                isDragPressed = pressing
            }
            .dropDestination(for: String.self) { items, location in
                draggingItemId = nil
                return false
            } isTargeted: { status in
                if let draggingItemId, status, draggingItemId != itemId {
                    DispatchQueue.main.async {
                        handleDrop(from: draggingItemId, to: itemId)
                    }
                }
            }
    }
    
    func handleDrop(from draggingItemId: String, to targetItemId: String){
        let from = viewModel.items.firstIndex(where: { $0.id == draggingItemId })
        let to = viewModel.items.firstIndex(where: { $0.id == targetItemId })
        
        if let from, let to {
            withAnimation(.easeInOut) {
                let sourceItem = viewModel.items.remove(at: from)
                viewModel.items.insert(sourceItem, at: to)
                viewModel.updateItems()
            }
        }
    }
}



