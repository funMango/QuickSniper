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
                    .font(.subheadline)
                
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
                        Spacer()
                        Text(viewModel.selectedPosition.displayName)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .frame(width: 150, height: 23)
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(5)
                }
                .buttonStyle(.plain)
            }
            
            HStack {
                Spacer()
                
                Text(String(localized: "hotCornerWarning"))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

//#Preview {
//    HotCornerSettingView()
//}
