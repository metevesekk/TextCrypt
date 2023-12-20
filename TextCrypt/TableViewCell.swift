//
//  TableViewCell.swift
//  TextCrypt
//
//  Created by Mete Vesek on 17.12.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let noteLabel = UILabel()
    let dateLabel = UILabel()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        
        // Hücrenin genel ayarları
        backgroundColor = UIColor(displayP3Red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true

        // titleLabel ayarları
        titleLabel.textColor = .systemGray5
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.numberOfLines = 0

        // noteLabel ayarları
        noteLabel.textColor = .systemGray5
        noteLabel.font = UIFont.systemFont(ofSize: 18)
        noteLabel.numberOfLines = 3

        // Subviews ekleme ve layout
        contentView.addSubview(titleLabel)
        contentView.addSubview(noteLabel)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            noteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            noteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(withTitle title: String, note: String) {
        titleLabel.text = title
        noteLabel.text = note
    }
}
