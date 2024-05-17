//
//  ViewController.swift
//  UpstoxPortfolio
//
//  Created by Shrey Garg on 16/05/24.
//

import UIKit

class ViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "UPSTOX"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = Constants.CustomStringFormats.blueColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startButton: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "View Holdings"
        configuration.baseBackgroundColor = Constants.CustomStringFormats.blueColor
        configuration.baseForegroundColor = .white
        configuration.background.cornerRadius = 8
        configuration.titlePadding = 10
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),

            startButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        startButton.setContentHuggingPriority(.required, for: .horizontal)
        startButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        startTitleLabelAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTitleLabelAnimation()
    }
    
    private func startTitleLabelAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.8
        animation.toValue = 1.1
        animation.autoreverses = true
        animation.duration = 1.0
        animation.repeatCount = .infinity
        titleLabel.layer.add(animation, forKey: "scale")
    }
    
    private func stopTitleLabelAnimation() {
        titleLabel.layer.removeAnimation(forKey: "scale")
    }
    
    @objc private func startButtonTapped() {
        let portfolioVC = PortfolioViewController()
        navigationController?.pushViewController(portfolioVC, animated: false)
    }
}
