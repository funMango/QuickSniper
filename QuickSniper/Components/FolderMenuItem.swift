//
//  FolderMenuItem.swift
//  QuickSniper
//
//  Created by 이민호 on 5/27/25.
//

import SwiftUI

struct FolderMenuItem: View {
    var systemName: String
    var title: String.LocalizationValue
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 14)
            
            Text(String(localized: title))
        }
    }
}


//#Preview {
//    FolderMenuItem()
//}
