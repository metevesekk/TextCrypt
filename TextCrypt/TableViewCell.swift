//
//  TableViewCell.swift
//  NoteCrypt
//
//  Created by Mete Vesek on 24.12.2023.
//


import UIKit
import CoreData

protocol TableViewCellDelegate : AnyObject {
    func didRequestDelete(_ cell: TableViewCell)
}

class TableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let noteLabel = UILabel()
    let dateLabel = UILabel()
    let timeLabel = UILabel()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    let deleteButton = UIButton()
    weak var delegate : TableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        dateFormatter.dateFormat = "dd/MM/yyyy"
        timeFormatter.dateFormat = "HH:mm"

        selectionStyle = .none
        setupDeleteButton()
        
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 2
        
        backgroundColor = UIColor.clear
        backgroundView?.backgroundColor = UIColor.clear
        selectedBackgroundView?.backgroundColor = UIColor.clear
        
        setLabel(label: titleLabel, textColor: .systemGray5, fontSize: 22, numberOfLine: 0).isEnabled = false
        setLabel(label: noteLabel, textColor: .systemGray5, fontSize: 18, numberOfLine: 3).isHidden = false
        setLabel(label: dateLabel, textColor: .systemGray, fontSize: 14, numberOfLine: 1).isHidden = false
        setLabel(label: timeLabel, textColor: .systemGray, fontSize: 14, numberOfLine: 1).isHidden = false
        
        addContentView(views: [titleLabel,noteLabel,dateLabel,timeLabel])
       
        let colorIndex = UserDefaults.standard.integer(forKey: "index")
        setupBasedOnColors(index: colorIndex)
        setupConstraints()
        
        let leftSwipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleLeftSwipe(_:)))
        
        contentView.addGestureRecognizer(leftSwipeGesture)
        contentView.clipsToBounds = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
           let pointForTargetView = deleteButton.convert(point, from: self)

           if deleteButton.bounds.contains(pointForTargetView) {
               return deleteButton
           }

           return super.hitTest(point, with: event)
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
    
    func setupDeleteButton(){
        contentView.addSubview(deleteButton)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.layer.cornerRadius = 15
        deleteButton.tintColor = .white
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 6),
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.isUserInteractionEnabled = true
    }
    
    func setLabel(label: UILabel, textColor : UIColor, fontSize: CGFloat, numberOfLine: Int) -> UILabel {
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.numberOfLines = numberOfLine
        return label
    }
    
    func addContentView(views: [UILabel]){
        views.forEach { view in
            contentView.addSubview(view)
        }
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
    
    @objc func handleLeftSwipe(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: contentView) // Kaydırma mesafesini al
        if gesture.state == .changed {
            // Sola kaydırma için pozisyonları güncelle
            let newPosition = max(translation.x, -deleteButton.frame.width)
            if newPosition <= 0 { // Yalnızca sol tarafa kaydırma izin ver
                contentView.frame.origin.x = newPosition
            }
        } else if gesture.state == .ended {
            // Animasyonla kaydırma sonrası konumu ayarla
            let shouldRevealButton = contentView.frame.origin.x < -deleteButton.frame.width / 2
            UIView.animate(withDuration: 0.3) {
                self.contentView.frame.origin.x = shouldRevealButton ? -self.deleteButton.frame.width : 0
            }
        }
    }
    
    @objc func deleteButtonTapped(){
        delegate?.didRequestDelete(self)
    }
}

