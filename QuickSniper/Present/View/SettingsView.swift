//
//  SettingView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/20/25.
//

import SwiftUI
import KeyboardShortcuts
import Resolver

struct SettingsView: View {
    @Injected var viewModelContainer: ViewModelContainer
    @State private var isBlocked = false
    private let width: CGFloat
    private let height: CGFloat
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        VStack(spacing: 13) {
            HStack {
                Text(String(localized: "settings"))
                    .font(.headline)
                    
                
                Spacer()
            }
            .padding(.bottom, 5)
                                    
            HStack {
                Text(String(localized: "shiftyOpen"))
                    .font(.subheadline)
                
                Spacer()
                
                KeyboardShortcuts.Recorder(
                    "", name: .toggleQuickSniper
                )
                .accentColor(.accentColor)
            }
            
            HotCornerSettingView(
                viewModel: viewModelContainer.hotCornerSettingViewModel
            )
                                                                                            
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
