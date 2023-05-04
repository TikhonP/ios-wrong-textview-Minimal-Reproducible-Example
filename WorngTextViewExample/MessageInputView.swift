//
//  MessageInputView.swift
//  Medsenger
//
//  Created by Tikhon Petrishchev on 30.11.2022.
//  Copyright © 2022 TelePat ltd. All rights reserved.
//

import SwiftUI

extension Color {
    public static let systemBackground = {
#if canImport(UIKit)
        Color(UIColor.systemBackground)
#elseif canImport(AppKit)
        Color(NSColor.windowBackgroundColor)
#else
        Color.black
#endif
    }()
}

struct MessageInputView: View {
    
    @State private var message: String = ""
    @State private var calculatedHeight: CGFloat = .zero
    @State private var isScrollingEnabled = false
    @State private var clearText = false
    
    private static let maxHeightConstant: CGFloat = 250
    
    var body: some View {
        VStack(spacing: 5) {
            Divider()
                .edgesIgnoringSafeArea(.horizontal)
            
            HStack(alignment: .bottom) {
                Button {
                    // Some staff
                } label: {
                    Image(systemName: "paperclip.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 38)
                        .foregroundColor(.secondary.opacity(0.7))
                }
                
                UIKitTextViewRepresentable(
                    text: $message,
                    calculatedHeight: $calculatedHeight,
                    clearText: $clearText,
                    isScrollingEnabled: isScrollingEnabled
                )
                .frame(height: isScrollingEnabled ? Self.maxHeightConstant : calculatedHeight)
                .background(
                    Text("Message...")
                        .foregroundColor(Color(.placeholderText))
                        .padding(.leading, 14)
                        .opacity(message.isEmpty ? 1 : 0),
                    alignment: .leading
                )
                .onChange(of: calculatedHeight) { newValue in
                    if newValue < Self.maxHeightConstant {
                        isScrollingEnabled = false
                    } else {
                        isScrollingEnabled = true
                    }
                }
                .onChange(of: message, perform: { newValue in
                    if newValue.isEmpty {
                        clearText = true
                    }
                })
                .background(Color.systemBackground)
                .clipShape(RoundedRectangle(cornerSize: .init(width: 20, height: 20)))
                
                Button {
                    // Some staff
                } label: {
                    Image(systemName: "waveform.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 38)
                        .foregroundColor(.secondary.opacity(0.7))
                }
            }
            .padding(.horizontal, 7)
        }
        .padding(.bottom, 5)
        .background(.regularMaterial, ignoresSafeAreaEdges: .all)
    }
}

#if DEBUG
//struct MessageInputView_Previews: PreviewProvider {
//    //    static let persistence = PersistenceController.preview
//    //
//    //    static var contract1: Contract = {
//    //        let context = persistence.container.viewContext
//    //        return Contract.createSampleContract1(for: context)
//    //    }()
//    //
//    static var previews: some View {
//        MessageInputView()
//        //            .environment(\.managedObjectContext, persistence.container.viewContext)
//            .environmentObject(ChatViewModel(contract: )
//            .previewLayout(PreviewLayout.sizeThatFits)
//    }
//}
#endif
