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
 
        /*
        private func recalculateHeight1() {
            let textStorage = NSTextStorage(attributedString: textView.attributedText)
            let layoutManager = NSLayoutManager()
            textStorage.addLayoutManager(layoutManager)
            let textContainer = NSTextContainer(size: CGSize(width: textView.frame.size.width - 2 * UIKitTextViewRepresentable.horizontalPadding, height: CGFloat.greatestFiniteMagnitude))
//            textContainer.lineFragmentPadding = 0
//            textContainer.maximumNumberOfLines = 0
            layoutManager.addTextContainer(textContainer)
            let newSize = layoutManager.usedRect(for: textContainer).size
            guard calculatedHeight.wrappedValue != newSize.height else { return }
            
            DispatchQueue.main.async { // call in next render cycle.
                print("newSize.height: \(newSize.height)")
                self.calculatedHeight.wrappedValue = newSize.height
            }
        }
        
        
        private func recalculateHeight2() {
            let size = CGSize(width: textView.frame.width - 2 * UIKitTextViewRepresentable.horizontalPadding, height: .greatestFiniteMagnitude)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let context = NSStringDrawingContext()
//            context.minimumScaleFactor = textView.minimumScaleFactor
            let boundingRect = text.wrappedValue.boundingRect(with: size, options: options, context: context)
            let newSize = CGSize(width: ceil(boundingRect.width), height: ceil(boundingRect.height))

            guard calculatedHeight.wrappedValue != newSize.height else { return }

            DispatchQueue.main.async {
                self.calculatedHeight.wrappedValue = newSize.height
            }
        }
        
       
         - (CGSize)rectForAttributedString:(NSAttributedString *)string withSize:(CGSize)theSize
         {
             if (!string || CGSizeEqualToSize(theSize, CGSizeZero)) {
                 return CGSizeZero;
             }

             // setup TextKit stack
             NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:theSize];
             NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:string];
             NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
             [layoutManager addTextContainer:textContainer];
             [textStorage addLayoutManager:layoutManager];

             // query for size
             CGRect rect = [layoutManager usedRectForTextContainer:textContainer];

             return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
         }
         
        
        private func recalculateHeight() {
            let size = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
            
            let textContainer = NSTextContainer(size: size)
            let textStorage = NSTextStorage(attributedString: textView.attributedText)
            let layoutManager = NSLayoutManager()
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)
            
            let boundingRect = layoutManager.usedRect(for: textContainer)
//            let newSize = CGSize(width: ceil(boundingRect.width), height: ceil(boundingRect.height))
            
            guard calculatedHeight.wrappedValue != boundingRect.height else { return }

            DispatchQueue.main.async {
                self.calculatedHeight.wrappedValue = boundingRect.height
            }
        }
         */
    }
}

extension UIKitTextViewRepresentable.Coordinator: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        text.wrappedValue = NSAttributedString(attributedString: textView.attributedText)
        recalculateHeight()
    }
}
