//
//  BookCell.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import UIKit

final class BookCell: UITableViewCell {

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var previewImageViewBottomConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        arrangeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        previewImageView.image = nil
    }
}

// MARK: - Arrange Views
private extension BookCell {

    func arrangeViews() {
        selectionStyle = .none
        [nameLabel, previewImageView].forEach(contentView.addSubview(_:))
        previewImageViewBottomConstraint = previewImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,
                                                                                    constant: -5.0)
        previewImageViewBottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
            previewImageView.widthAnchor.constraint(equalToConstant: 40.0),
            previewImageView.heightAnchor.constraint(equalToConstant: 40.0),
            previewImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            previewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            nameLabel.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: 6.0),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.0),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6.0),
        ])
    }
}

// MARK: - Populate UI
extension BookCell {

    func populateUI(with book: BookModel) {
        nameLabel.text = book.volumeInfo?.title ?? ""
        let imageUrl = book.volumeInfo?.imageLinks?.thumbnail ?? book.volumeInfo?.imageLinks?.thumbnail ?? ""
        previewImageView.setImage(with: imageUrl)
    }
}
