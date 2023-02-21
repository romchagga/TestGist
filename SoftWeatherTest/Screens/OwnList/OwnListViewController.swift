//
//  ViewController.swift
//  SoftWeatherTest
//
//  Created by macbook on 21.02.2023.
//

import UIKit

class OwnListViewController: UIViewController {
    
    private let viewModel = OwnListViewModel()
    
    private var isLoading: Bool = false
    
    private var ownListView: OwnListView {
        return view as! OwnListView
    }
    
    override func loadView() {
        super.loadView()
        self.view = OwnListView()
        self.viewModel.viewController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViewModel()
        
        viewModel.getGistsByUser()
    }
    
    private func setupViews() {
        setupTableView()
    }
    
    private func setupTableView() {
        self.navigationItem.title = "GitHub Gists"
        ownListView.tableView.delegate = self
        ownListView.tableView.dataSource = self

        ownListView.tableView.register(OwnListCell.self, forCellReuseIdentifier: "ownReuseId")
    }
    
    private func bindViewModel() {
        self.viewModel.cellModel.addObserver(self) { [weak self]  (gistJSON, _) in
            DispatchQueue.main.async {
                self?.ownListView.tableView.reloadData()
            }
        }
    }
}
extension OwnListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellModel.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let currentGist = viewModel.cellModel.value[indexPath.row]
        
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "ownReuseId", for: indexPath)
        
        guard let cell = dequeuedCell as? OwnListCell else {
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

