//
//  ExpandableFooterView.swift
//  UpstoxPortfolio
//
//  Created by Shrey Garg on 16/05/24.
//
import UIKit

class ExpandableFooterView: UIView{
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var dropdownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let expandableView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    var isExpanded: Bool = false {
        didSet {
            let arrowImage = isExpanded ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
            dropdownImageView.image = arrowImage
            arrangedSubViews()
        }
    }
    var views = [UIView]()
    var onExpandCollapseTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        self.addSubview(expandableView)
        expandableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandableView.topAnchor.constraint(equalTo: self.topAnchor),
            expandableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            expandableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            expandableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        expandableView.addGestureRecognizer(UITapGestureRecognizer(target: self , action: #selector(expandCollapseButtonTapped)))
        
        expandableView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: expandableView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: expandableView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: expandableView.trailingAnchor),
        ])
        expandableView.addBorders(edges: .top, color: .systemGray3)
    }
    
    // Action
    @objc func expandCollapseButtonTapped(_ sender: UIButton) {
        isExpanded.toggle()
        onExpandCollapseTapped?()
    }
    
    func setStackViewElements(data: CalculatedTotalInvestmentDetails){
        let elements = ["Current Value*", "Total Investment*", "Today's Profit & Loss*", "Profit & Loss*"]
        let calculatedData = [data.totalCurrentValue, data.totalInvestment, data.todaysTotalProfitAndLoss, data.totalProfitAndLoss]
        for i in 0..<elements.count{
            
            let detailView: UIView = {
                let detailView = UIView()
                detailView.translatesAutoresizingMaskIntoConstraints = false
                return detailView
            }()
            
            let nameLabel: UILabel = {
                let label = UILabel()
                label.textAlignment = .left
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = elements[i]
                label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
                label.textColor = .darkText
                return label
            }()
            
            let ltpLabel: UILabel = {
                let label = UILabel()
                label.textAlignment = .right
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = CommonUtils().formatAmountWithIndianRupee(amount: calculatedData[i])
                label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
                if i > 1{
                    label.textColor = calculatedData[i] >= 0 ? UIColor.systemGreen : UIColor.systemRed
                }else{
                    label.textColor = .darkText
                }
                return label
            }()
            
            detailView.addSubview(nameLabel)
            detailView.addSubview(ltpLabel)
            // Setup constraints
            NSLayoutConstraint.activate([
                
                nameLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 16),
                nameLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 20),
                nameLabel.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -20),
            ])
            NSLayoutConstraint.activate([
                ltpLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -16),
                ltpLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 20),
                ltpLabel.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -20),
                
            ])
            
            // Add dropdown image to the last detailView
            if i == elements.count - 1 {
                
                detailView.addBorders(edges: [.top], color: .systemGray4 ,inset: 10)
                dropdownImageView.image = UIImage(systemName: "chevron.up")
                dropdownImageView.translatesAutoresizingMaskIntoConstraints = false
                detailView.addSubview(dropdownImageView)
                
                // Setup constraints for dropdown image
                NSLayoutConstraint.activate([
                    dropdownImageView.centerYAnchor.constraint(equalTo: detailView.centerYAnchor),
                    dropdownImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10)
                ])
            }else {
                detailView.isHidden = true
            }
            stackView.addArrangedSubview(detailView)
            views.append(detailView)
            
        }
        arrangedSubViews()
    }
    
    private func arrangedSubViews(){
        UIView.animate(withDuration: 0.2, animations: {
            for i in 0..<self.views.count-1 {
                self.views[i].isHidden = !self.isExpanded
            }
        })
    }
}

