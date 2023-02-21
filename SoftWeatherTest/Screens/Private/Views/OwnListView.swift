//
//  OwnListView.swift
//  SoftWeatherTest
//
//  Created by macbook on 21.02.2023.
//

import UIKit


final class OwnListView: UIView {

private(set) lazy var tableView: UITableView = {
    var tableView = UITableView()
    tableView.rowHeight = 72.0
    tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 0.0)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.isHidden = false
    return tableView
}()

override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
}

required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.configureUI()
}

private func configureUI() {
    self.backgroundColor = .white
    self.addSubview(tableView)
    self.setupConstraints()
}

private func setupConstraints() {
    let safeArea = self.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
    ])
}
}
