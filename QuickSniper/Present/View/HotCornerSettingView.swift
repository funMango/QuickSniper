//
//  HotCornerSettingView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/12/25.
//

import SwiftUI

struct HotCornerSettingView: View {
    @StateObject var viewModel: HotCornerSettingViewModel
    
    init(viewModel: HotCornerSettingViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(String(localized: "settingHotCorner"))
                
                Spacer()
                
                Menu {
                    ForEach(HotCornerPosition.allCases, id: \.self) { position in
                        
                        Button(action: {
                            viewModel.setSelectedPosition(position)
                            
                        }) {
                            HStack {
                                Text(position.displayName)
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(viewModel.selectedPosition.displayName)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(5)
                }
                .buttonStyle(.plain)
            }
            
            HStack {
                Text(String(localized: "hotCornerWarning"))
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
        }
    }
}

//#Preview {
//    HotCornerSettingView()
//}
