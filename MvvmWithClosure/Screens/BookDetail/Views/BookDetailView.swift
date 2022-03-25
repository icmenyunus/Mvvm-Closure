//
//  BookDetailView.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import Foundation
import UIKit

final class BookDetailView: UIView {

    //MARK: - Properties
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var imageViewHeightConstraint: NSLayoutConstraint?

    //MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        arrangeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Arrange Views
private extension BookDetailView {

    func arrangeViews() {
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [nameLabel, bookImageView].forEach(contentView.addSubview(_:))
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.0),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6.0),
            bookImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),

            nameLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 10.0),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6.0),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.0),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ])
        imageViewHeightConstraint = bookImageView.heightAnchor.constraint(equalToConstant: 10.0)
        imageViewHeightConstraint?.isActive = true
    }
}

// MARK: - Arrange Views
extension BookDetailView {

    func populateUI(with book: BookModel) {
        nameLabel.text = book.volumeInfo?.description ?? ""
        let imageUrl = book.volumeInfo?.imageLinks?.medium
        ?? book.volumeInfo?.imageLinks?.large
        ?? book.volumeInfo?.imageLinks?.extraLarge

        if imageUrl != "" && imageUrl != nil {
            bookImageView.setImage(with: imageUrl) { [weak self] scaledImageHeight in
                guard let self = self else { return }

                self.imageViewHeightConstraint?.constant = scaledImageHeight
            }
            layoutIfNeeded()
        }
    }
}
