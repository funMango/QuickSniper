//
//  SettingView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/20/25.
//

import SwiftUI
import KeyboardShortcuts

struct ShortcutSettingsView: View {
    
    @State private var isBlocked = false
    private let width: CGFloat
    private let height: CGFloat
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        VStack() {
            HStack {
                Text(String(localized: "shortCutSettings"))
                    .font(.headline)
                    .padding(.bottom, 15)
                
                Spacer()
            }
                                    
            HStack {
                Text(String(localized: "shiftyOpen"))
                    .font(.subheadline)
                
                Spacer()
                
                KeyboardShortcuts.Recorder(
                    "", name: .toggleQuickSniper
                )
            }
                                                                                            
            Spacer()
        }
        .padding()
        .frame(width: width, height: height)
        .background(.clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    }
}

//#Preview {
//    ShortcutSettingsView()
//}
