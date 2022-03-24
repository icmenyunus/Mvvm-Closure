//
//  BookView.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import UIKit

final class BookView: UIView {

    //MARK: - Properties
    private(set) var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(BookCell.self, forCellReuseIdentifier: "BookCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    //MARK: - initializations
    override init(frame: CGRect) {
        super.init(frame: frame)

        arrangeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Arrange Views
private extension BookView {

    func arrangeViews() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

