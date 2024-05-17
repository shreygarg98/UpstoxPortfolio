//
//  CommonUtils.swift
//  UpstoxPortfolio
//
//  Created by Shrey Garg on 16/05/24.
//

import UIKit

class CommonUtils {
    
    func getAttributedText(with prefix: String, and amount: String, rightLabelColor: UIColor) -> NSMutableAttributedString {
        let prefixWithColon = !prefix.isEmpty ? "\(prefix): " : ""
        let attributedString = NSMutableAttributedString(string: prefixWithColon, attributes:
                                                            [.font: UIFont.systemFont(ofSize: 12,weight: .medium),
                                                             .foregroundColor: UIColor.gray])
       
        let boldedString = NSAttributedString(string: "\(amount)",attributes:
                                                [.font: UIFont.systemFont(ofSize: 16,weight: .regular),
                                                 .foregroundColor: rightLabelColor])
        attributedString.append(boldedString)
        
        return attributedString
    }
    
    func formatAmountWithIndianRupee(amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = Constants.CustomStringFormats.rupeeSign // Set the currency symbol to Indian Rupee
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return " " + (formatter.string(from: NSNumber(value: amount)) ?? "\(amount)") 
    }
}

extension UIView {
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }

}
