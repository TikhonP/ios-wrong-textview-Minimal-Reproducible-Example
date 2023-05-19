//
//  TextView.swift
//  Medsenger
//
//  Created by Tikhon Petrishchev on 08.12.2022.
//  Copyright © 2022 TelePat ltd. All rights reserved.
//

import SwiftUI
import UIKit

class MessageInputViewModel: ObservableObject {
    @Published var calculatedHeight: CGFloat = 42
    @Published var maxHeightConstant: CGFloat = 250
    @Published var isScrollingEnabled = false
}


@available(macOS, unavailable)
struct UIKitTextViewRepresentable: UIViewRepresentable {
    @Binding var text: String
    var viewModel: MessageInputViewModel
    
    private let padding: CGFloat = 10
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        textView.attributedText = NSAttributedString(string: text)
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textColor = .label
        textView.adjustsFontForContentSizeCategory = true
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        textView.textContainer.heightTracksTextView = true
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: UIKitTextViewRepresentable
        
        
        init(parent: UIKitTextViewRepresentable) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            adjustTextViewHeight(textView)
        }
        
        
        func adjustTextViewHeight(_ textView: UITextView) {
            let fixedWidth = textView.frame.size.width
            var newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            
            // Limit the calculated height to the maximum height constant
            newSize.height = min(newSize.height, parent.viewModel.maxHeightConstant)
            
            guard parent.viewModel.calculatedHeight != newSize.height else { return }
            
            parent.viewModel.calculatedHeight = newSize.height
            parent.viewModel.isScrollingEnabled = newSize.height >= parent.viewModel.maxHeightConstant
        }
    }
}
