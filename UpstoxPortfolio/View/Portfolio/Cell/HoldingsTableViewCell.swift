//
//  HoldingsTableViewCell.swift
//  UpstoxPortfolio
//
//  Created by Shrey Garg on 16/05/24.
//

import UIKit

class HoldingsTableViewCell: UITableViewCell {

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ltpLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let qtyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pnlLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupCell(holding: Holding){
        
        nameLabel.text = "\(holding.symbol.uppercased())"
        ltpLabel.attributedText = CommonUtils().getAttributedText(with: "LTP", and: CommonUtils().formatAmountWithIndianRupee(amount: holding.lastTradedPrice), rightLabelColor: UIColor.black)
        qtyLabel.attributedText = CommonUtils().getAttributedText(with: "Net QTY", and: "\(holding.quantity)", rightLabelColor: UIColor.black)
        pnlLabel.attributedText = CommonUtils().getAttributedText(with: "P/L", and: CommonUtils().formatAmountWithIndianRupee(amount: holding.profitAndLoss), rightLabelColor: holding.profitAndLoss >= 0 ? UIColor.systemGreen : UIColor.systemRed)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(ltpLabel)
        contentView.addSubview(qtyLabel)
        contentView.addSubview(pnlLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            ltpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ltpLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            
            qtyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            qtyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            qtyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            pnlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pnlLabel.topAnchor.constraint(equalTo: qtyLabel.topAnchor),
            pnlLabel.bottomAnchor.constraint(equalTo: qtyLabel.bottomAnchor),
        ])
        
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
