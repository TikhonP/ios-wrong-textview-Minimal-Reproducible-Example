//
//  TextView.swift
//  Medsenger
//
//  Created by Tikhon Petrishchev on 08.12.2022.
//  Copyright © 2022 TelePat ltd. All rights reserved.
//

import SwiftUI
import UIKit

@available(macOS, unavailable)
public struct UIKitTextViewRepresentable: UIViewRepresentable {
    @Binding private var text: NSAttributedString
    @Binding private var calculatedHeight: CGFloat
    @Binding private var clearText: Bool
    
    private let isScrollingEnabled: Bool
    
    static let horizontalPadding: CGFloat = 10
    
    public init(text: Binding<String>, calculatedHeight: Binding<CGFloat>, clearText: Binding<Bool>, isScrollingEnabled: Bool) {
        _text = Binding(
            get: { NSAttributedString(string: text.wrappedValue) },
            set: { newValue in
                DispatchQueue.main.async {
                    text.wrappedValue = newValue.string
                }
            }
        )
        _calculatedHeight = calculatedHeight
        _clearText = clearText
        self.isScrollingEnabled = isScrollingEnabled
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, calculatedHeight: $calculatedHeight)
    }
    
    public func makeUIView(context: Context) -> UITextView {
        context.coordinator.textView
    }
    
    public func updateUIView(_ uiView: UITextView, context: Context) {
        context.coordinator.update(representable: self)
    }
}

extension UIKitTextViewRepresentable {
    public class Coordinator: NSObject {
        let textView: UITextView
        
        private var text: Binding<NSAttributedString>
        private var calculatedHeight: Binding<CGFloat>
        
        init(text: Binding<NSAttributedString>, calculatedHeight: Binding<CGFloat>) {
            textView = UITextView()
            textView.backgroundColor = .clear
            textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            textView.contentInset.left = UIKitTextViewRepresentable.horizontalPadding
            textView.contentInset.right = UIKitTextViewRepresentable.horizontalPadding
            textView.attributedText = text.wrappedValue
            textView.font = .preferredFont(forTextStyle: .body)
            textView.textColor = .label
            textView.adjustsFontForContentSizeCategory = true
            textView.textContainer.lineBreakMode = .byWordWrapping
            
            self.text = text
            self.calculatedHeight = calculatedHeight
            
            super.init()
            
            textView.delegate = self
        }
        
        func update(representable: UIKitTextViewRepresentable) {
            textView.isScrollEnabled = representable.isScrollingEnabled
            
            if representable.clearText {
                textView.text = ""
                textView.font = .preferredFont(forTextStyle: .body)
                textView.textColor = .label
                textView.adjustsFontForContentSizeCategory = true
                DispatchQueue.main.async {
                    representable.clearText = false
                }
            }
            
            recalculateHeight()
        }

        private func recalculateHeight() {
            let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
            guard calculatedHeight.wrappedValue != newSize.height else { return }
            
            DispatchQueue.main.async { // call in next render cycle.
                self.calculatedHeight.wrappedValue = newSize.height
            }
        }
    }
}

extension UIKitTextViewRepresentable.Coordinator: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        text.wrappedValue = NSAttributedString(attributedString: textView.attributedText)
        recalculateHeight()
    }
}
