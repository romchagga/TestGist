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
        self.viewModel.viewController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViewModel()
        
        viewModel.getGists()
    }

    private func setupViews() {
        setupTableView()
        setupRefreshControl()
    }
    
    private func setupTableView() {
        self.navigationItem.title = "GitHub Gists"
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.prefetchDataSource = self
        mainView.tableView.register(MainCell.self, forCellReuseIdentifier: "reuseId")
    }
    
    private func bindViewModel() {
        self.viewModel.cellModel.addObserver(self) { [weak self]  (gistJSON, _) in
            DispatchQueue.main.async {
                self?.mainView.tableView.reloadData()
            }
        }
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
        viewModel.cellModel.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let currentGist = viewModel.cellModel.value[indexPath.row]
        
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "reuseId", for: indexPath)
        
        guard let cell = dequeuedCell as? MainCell else {
            return dequeuedCell
        }
        
        cell.configure(with: currentGist)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentGist = viewModel.cellModel.value[indexPath.row]
        viewModel.didSelectGist(currentGist)
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

