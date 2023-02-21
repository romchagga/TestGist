//
//  ViewController.swift
//  SoftWeatherTest
//
//  Created by macbook on 21.02.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    
    private var isLoading: Bool = false 
    
    private var mainView: MainView {
        return view as! MainView
    }
    
    override func loadView() {
        super.loadView()
        self.view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }

    private func setupTableView() {
        self.navigationItem.title = "GitHub Gists"
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.prefetchDataSource = self
        mainView.tableView.register(MainCell.self, forCellReuseIdentifier: "reuseId")
    }
    
    private func setupRefreshControl() {
        self.mainView.tableView.refreshControl = UIRefreshControl()
        self.mainView.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Обновление...")
        self.mainView.tableView.refreshControl?.tintColor = .gray
        self.mainView.tableView.refreshControl?.addTarget(self, action: #selector(refreshGists), for: .valueChanged)
    }
    
    @objc func refreshGists() {
        self.viewModel.getGistForRefreshController()
        DispatchQueue.main.async {
            self.mainView.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "reuseId", for: indexPath)
        
        guard let cell = dequeuedCell as? MainCell else {
            return dequeuedCell
        }
        
        cell.textLabel?.text = "123"
        
        return cell
        
    }
}

extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map({ $0.row }).max() else { return }
        
        if maxRow > viewModel.cellModel.value.count - 2, !isLoading {
            isLoading = true
            viewModel.getGistForPrefetching()
        }
        isLoading = false
    }
}

