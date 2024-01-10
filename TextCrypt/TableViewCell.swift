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
    let containerView = UIView()
    var isDeleteButtonVisible = Bool()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        dateFormatter.dateFormat = "dd/MM/yyyy"
        timeFormatter.dateFormat = "HH:mm"

        selectionStyle = .none
        setupDeleteButton()
        setupContainerView()
   //     containerView.layer.borderColor = UIColor(.clear).cgColor
        
        containerView.layer.cornerRadius = 15
        containerView.layer.borderWidth = 2
        containerView.clipsToBounds = false
        backgroundColor = UIColor.clear
        backgroundView?.backgroundColor = UIColor.clear
        selectedBackgroundView?.backgroundColor = UIColor.clear
        
        setLabel(label: titleLabel, textColor: .systemGray5, fontSize: 22, numberOfLine: 0).isEnabled = false
        setLabel(label: noteLabel, textColor: .systemGray5, fontSize: 18, numberOfLine: 2).isHidden = false
        setLabel(label: dateLabel, textColor: .systemGray, fontSize: 14, numberOfLine: 1).isHidden = false
        setLabel(label: timeLabel, textColor: .systemGray, fontSize: 14, numberOfLine: 1).isHidden = false
        
        addcontainerView(views: [titleLabel,noteLabel,dateLabel,timeLabel])
       
        let colorIndex = UserDefaults.standard.integer(forKey: "index")
        setupBasedOnColors(index: colorIndex)
        setupConstraints()
        
        let leftSwipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleLeftSwipe(_:)))
        containerView.addGestureRecognizer(leftSwipeGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(_:)))
        tapGesture.delegate = self
        containerView.addGestureRecognizer(tapGesture)

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
    
    func setupContainerView(){
        contentView.addSubview(containerView)
    }

    
    func setupBasedOnColors(index: Int){
        switch index {
        case 0:
            containerView.layer.borderColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1).cgColor
        case 1:
            containerView.layer.borderColor = UIColor.systemPink.cgColor
        case 2:
            containerView.layer.borderColor = UIColor.systemGray3.cgColor
        case 3:
            containerView.layer.borderColor = UIColor.systemBlue.cgColor
        case 4:
            containerView.layer.borderColor = UIColor.systemYellow.cgColor
        case 5:
            containerView.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).cgColor
        default:
            print("Renk Bulunamadı")
        }
        containerView.setNeedsDisplay()
    }
    
    func setupDeleteButton(){
        containerView.addSubview(deleteButton)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.layer.cornerRadius = 15
        deleteButton.tintColor = .white
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.isUserInteractionEnabled = true
    }
    
    func setLabel(label: UILabel, textColor : UIColor, fontSize: CGFloat, numberOfLine: Int) -> UILabel {
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.numberOfLines = numberOfLine
        return label
    }
    
    func addcontainerView(views: [UILabel]){
        views.forEach { view in
            containerView.addSubview(view)
        }
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            deleteButton.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 7),
            deleteButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 100),
            
            noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            noteLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            noteLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            noteLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -10),
            
            dateLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -15),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            timeLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 20),
            timeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -9)
        ])
    }

    func configure(with note: NoteText) {
        titleLabel.text = note.title
        noteLabel.text = note.text
        if let date = note.date {
            timeLabel.text = timeFormatter.string(from: date)
        } else {
            timeLabel.text = "No time"
        }
        
        if let date = note.date {
               configureCellDateLabel(with: date)
           } else {
               dateLabel.text = "No date"
           }
    }
    
    func configureCellDateLabel(with date: Date) {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            dateLabel.text = "Today"
        } else {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateLabel.text = dateFormatter.string(from: date)
        }
    }
    
    @objc func handleLeftSwipe(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: containerView)
        if gesture.state == .changed {
            let newPosition = max(translation.x, -(deleteButton.frame.width + 7))
            if newPosition <= 0 {
                containerView.frame.origin.x = newPosition
            }
        } else if gesture.state == .ended {
            let shouldRevealButton = containerView.frame.origin.x < -deleteButton.frame.width / 2
            UIView.animate(withDuration: 0.3) {
                self.containerView.frame.origin.x = shouldRevealButton ? -(self.deleteButton.frame.width + 7) : 0
                self.isDeleteButtonVisible = shouldRevealButton ? true : false
            }
        }
    }
    
    @objc func handleCellTap(_ gesture: UITapGestureRecognizer) {
        if containerView.frame.origin.x != 0 {
            UIView.animate(withDuration: 0.3) {
                self.containerView.frame.origin.x = 0
            }
        }
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return containerView.frame.origin.x != 0
    }

    @objc func deleteButtonTapped(){
        delegate?.didRequestDelete(self)
    }
}

