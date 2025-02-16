//
//  UIStyleManager.swift
//  NeoCareApp
//
//  Created by Noe  on 16/02/25.
//

import Foundation
import UIKit

extension UITextField {
    func applyStyle(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, leftPadding: CGFloat = 20) {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.height))
            self.leftView = paddingView
            self.leftViewMode = .always
            self.borderStyle = .none
            self.layer.cornerRadius = cornerRadius
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
        }
    
    func setPlaceholderColor(_ color: UIColor) {
          if let placeholderText = self.placeholder {
              let attributes = [NSAttributedString.Key.foregroundColor: color]
              self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
          }
      }
}
