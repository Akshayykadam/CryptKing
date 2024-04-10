//
//  CloseButton.swift
//  CryptKing
//
//  Created by Akshay Kadam on 05/04/24.
//

import SwiftUI

struct CloseButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "arrow.left.circle.fill")
                .font(.headline)
        })
    }
}

#Preview {
    CloseButton()
}
