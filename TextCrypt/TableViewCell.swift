//
//  TableViewCell.swift
//  NoteCrypt
//
//  Created by Mete Vesek on 24.12.2023.
//


import UIKit
import CoreData

class TableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let noteLabel = UILabel()
    let dateLabel = UILabel()
    let timeLabel = UILabel()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        timeFormatter.dateFormat = "HH:mm"

        selectionStyle = .none
        
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 2
        contentView.clipsToBounds = true
        
        backgroundColor = UIColor.clear
        backgroundView?.backgroundColor = UIColor.clear
        selectedBackgroundView?.backgroundColor = UIColor.clear

        titleLabel.textColor = .systemGray5
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.numberOfLines = 0

        noteLabel.textColor = .systemGray5
        noteLabel.font = UIFont.systemFont(ofSize: 18)
        noteLabel.numberOfLines = 3
        
        dateLabel.textColor = .systemGray
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.numberOfLines = 1
        
        timeLabel.textColor = .systemGray
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.numberOfLines = 1

        contentView.addSubview(timeLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(noteLabel)
        
       
        
        let colorIndex = UserDefaults.standard.integer(forKey: "index")
        setupBasedOnColors(index: colorIndex)
        
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBasedOnColors(index: Int){
        switch index {
        case 0:
            contentView.layer.borderColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1).cgColor
        case 1:
            contentView.layer.borderColor = UIColor.systemPink.cgColor
        case 2:
            contentView.layer.borderColor = UIColor.systemGray3.cgColor
        case 3:
            contentView.layer.borderColor = UIColor.systemBlue.cgColor
        case 4:
            contentView.layer.borderColor = UIColor.systemYellow.cgColor
        case 5:
            contentView.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).cgColor
        default:
            print("Renk Bulunamadı")
        }
        contentView.setNeedsDisplay()
    }
    

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            

            noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            noteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            noteLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -10),
            
            dateLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -15),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            timeLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 20),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9)
        ])
    }

    func configure(with note: NoteText) {
        titleLabel.text = note.title
        noteLabel.text = note.text
        if let date = note.date {
         //   dateLabel.text = dateFormatter.string(from: date)
            timeLabel.text = timeFormatter.string(from: date)
        } else {
        //    dateLabel.text = "No date"
            timeLabel.text = "No time"
        }
        
        if let date = note.date {
               configureCellDateLabel(with: date)
           } else {
               dateLabel.text = "No date"
              // timeLabel.text = "No time"
           }
    }
    
    func configureCellDateLabel(with date: Date) {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            // Eğer tarih bugünse, "Today" yaz
            dateLabel.text = "Today"
        } else {
            // Değilse, tarihi formatla
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateLabel.text = dateFormatter.string(from: date)
        }
    }

}

