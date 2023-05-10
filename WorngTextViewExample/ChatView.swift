//
//  ChatView.swift
//  Medsenger
//
//  Created by Tikhon Petrishchev on 07.11.2022.
//  Copyright © 2022 TelePat ltd. All righchatViewModelts reserved.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack {
                    ForEach(0...100, id: \.self) {
                        Text("Message \($0)")
                            .padding()
                    }
                }
            }
            MessageInputView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Chat")
    }
}

