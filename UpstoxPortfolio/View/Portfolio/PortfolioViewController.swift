//
//  PortfolioViewController.swift
//  UpstoxPortfolio
//
//  Created by Shrey Garg on 16/05/24.
//

import UIKit

class PortfolioViewController: UIViewController {
    
    var viewModel: PortfolioViewModel!
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorInset = .zero
        return tableView
    }()
    
    let loaderView: UIActivityIndicatorView = {
        let loaderView = UIActivityIndicatorView(style: .large)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.hidesWhenStopped = true
        return loaderView
    }()
    
    var expandableFooterView = ExpandableFooterView()
    var isFooterExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupTableView()
        setupLoaderView()
        setupViewModel()
        viewModel.fetchPortfolio()
    }
    
    func setupNavBar() {
        
        navigationController?.navigationBar.isHidden = false
       
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: nil),
            UIBarButtonItem(title: "Portfolio", style: .plain, target: self, action: nil)
        ]
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward.fill")?.withTintColor(.white), style: .plain, target: self, action: #selector(backButton))
        
        navigationItem.rightBarButtonItem = backButton
    }
    
    func setupLoaderView() {
        view.addSubview(loaderView)
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func startOrStopAnimating(_ value: Bool){
        value ? self.loaderView.startAnimating() :  self.loaderView.stopAnimating()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HoldingsTableViewCell.self, forCellReuseIdentifier: "holdingCell")
       
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    
    }
    
    func setupTotalInvestmentDetails() {
        view.addSubview(expandableFooterView)
        expandableFooterView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            expandableFooterView.topAnchor.constraint(greaterThanOrEqualTo: tableView.topAnchor),
            expandableFooterView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            expandableFooterView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            expandableFooterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
         ])
        expandableFooterView.setStackViewElements(data: viewModel.getCalculatedTotalInvestmentDetails())
    }
    func setupViewModel() {
        let portfolioRepository = PortfolioRepository()
        viewModel = PortfolioViewModel(portfolioRepository: portfolioRepository)
        
        viewModel.startOrStopLoader = { [weak self] boolValue in
            DispatchQueue.main.async {
                self?.startOrStopAnimating(boolValue)
            }
        }
        
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.setupTotalInvestmentDetails()
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            guard let self = self else {return}
            DispatchQueue.main.async {
                // Handle error
                let label = UILabel(frame: CGRect(x: 0, y: Int(self.view.bounds.height)/2, width: Int(self.view.bounds.width), height: 30))
                label.textAlignment = .center
                label.text = "\(error)"
                self.view.addSubview(label)
            }
        }
    }
    
    @objc func backButton(){
        navigationController?.popViewController(animated: true)
    }
    
}

extension PortfolioViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getHoldingsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "holdingCell", for: indexPath) as! HoldingsTableViewCell
        cell.setupCell(holding: viewModel.getHolding(forIndexpath: indexPath.row))
        return cell
    }

}
