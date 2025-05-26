//
//  CreateFolderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/25/25.
//

import SwiftUI

struct CreateFolderView: View {
    @State var folderName: String = ""
    @State var selectedFolderType: FolderType = .snippet
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("폴더 이름:")
                
                Spacer()
                
                TextField("폴더 이름을 입력해주세요", text: $folderName)
            }
            
            HStack {
                Text("폴더 종류:")
                
                Spacer()
                
                Menu {
                    ForEach(FolderType.allCases, id: \.self) { type in
                        Button {
                            selectedFolderType = type
                        } label: {
                            Text(type.rawValue)
                        }
                    }
                } label: {
                    Text(selectedFolderType.rawValue)
                }
            }
            
            HStack {
                Spacer()
                
                HStack {
                    Button {
                        
                    } label: {
                        Text("취소")
                    }
                    
                    Button {
                        
                    } label: {
                        Text("확인")
                    }
                }
            }
        }
        .padding()
        .frame(width: 400, height: 250)
    }
}
#Preview {
    CreateFolderView()
}
