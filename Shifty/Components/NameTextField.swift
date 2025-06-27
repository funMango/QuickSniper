//
//  NameTextField.swift
//  Shifty
//
//  Created by 이민호 on 6/27/25.
//

import SwiftUI

struct NameTextField: View {
    var title: String
    var text: Binding<String>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            
            TextField("", text: text)
                .textFieldStyle(.roundedBorder)
        }
    }
}

#Preview {
    NameTextField(title: "이름", text: .constant(""))
        .padding()
        .frame(width: 400, height: 200)
}
