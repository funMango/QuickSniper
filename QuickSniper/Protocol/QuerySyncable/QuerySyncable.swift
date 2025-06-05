//
//  QuerySyncable.swift
//  QuickSniper
//
//  Created by 이민호 on 6/5/25.
//

import Foundation
import SwiftUI

extension View {
    func syncQuey<VM: QuerySyncableObject>(
        viewModel: VM,
        items: [VM.Item]
    ) -> some View {
        self.modifier(QuerySyncModifier(viewModel: viewModel, items: items))
    }
}

struct QuerySyncModifier<VM: QuerySyncableObject, Item: CoreModel>: ViewModifier
where VM.Item == Item {
    let viewModel: VM
    let items: [Item]
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                DispatchQueue.main.async {
                    viewModel.getItems(items)
                }
            }
            .onChange(of: items) { _, newItems in
                DispatchQueue.main.async {
                    viewModel.getItems(newItems)
                }
            }
    }
}
