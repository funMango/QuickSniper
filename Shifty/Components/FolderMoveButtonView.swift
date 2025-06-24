//
//  MoveButtonView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/19/25.
//

import SwiftUI

struct FolderMoveButtonView: View {
    let items: [Folder]  // Folder로 고정
    let onMove: (Folder) -> Void
    
    var body: some View {
        Menu {
            if items.isEmpty {
                Text(String(localized: "noMoveFolder"))
            }
            
            ForEach(items, id: \.id) { folder in
                Button {
                    onMove(folder)
                } label: {
                    Text("\(folder.name)")
                }
            }
        } label: {
            OptionButtonStyle(systemName: "arrowshape.turn.up.forward", title: "moveFolder")
        }
    }
}
