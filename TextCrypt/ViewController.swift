//
//  ViewController.swift
//  TextCrypt
//
//  Created by Mete Vesek on 10.12.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let createNoteButton = UIButton()
    let cellSpacing : CGFloat = 8
    var notes = [String]()
    var indexPath = IndexPath()
    var titles = [String]()
    var selectedIndexPath: IndexPath?
    


    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupCreateNoteButton()
        view.backgroundColor = .black
        tableView.backgroundColor = .black
        
        let longPressGestureButton = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressCell))
        let longPressGestureCell = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressButton))
        longPressGestureCell.minimumPressDuration = 0.05
        longPressGestureButton.minimumPressDuration = 0.05
        
        tableView.addGestureRecognizer(longPressGestureButton)
        createNoteButton.addGestureRecognizer(longPressGestureCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() // TableView'ı yenile
    }


    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50), // Buton için yer bırak
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupCreateNoteButton() {
        view.addSubview(createNoteButton)
    //    createNoteButton.setTitle("Not Oluştur", for: .normal)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 45, weight: .regular, scale: .default)
        let openLockSymbol = UIImage(systemName: "plus", withConfiguration: symbolConfiguration)
        createNoteButton.setImage(openLockSymbol, for: .normal)
        createNoteButton.tintColor = .black
        createNoteButton.backgroundColor = .systemYellow
        createNoteButton.layer.cornerRadius = 35
        createNoteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        createNoteButton.heightAnchor.constraint(equalToConstant: 70),
        createNoteButton.widthAnchor.constraint(equalToConstant: 70),
        createNoteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        createNoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55)
        ])
        createNoteButton.addTarget(self, action: #selector(createNoteButtonTapped), for: .touchUpInside)
    }

    @objc func createNoteButtonTapped() {
        let noteDetailVC = NoteDetailViewController()
            noteDetailVC.dismissAction = { [weak self] in
                if let newNote = noteDetailVC.noteContent, !newNote.isEmpty,
                   let newTitle = noteDetailVC.titleContent, !newTitle.isEmpty {
                    self?.notes.append(newNote)
                    self?.titles.append(newTitle)
                    self?.tableView.reloadData()
                }
            }
        let navigationController = UINavigationController(rootViewController: noteDetailVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func handleLongPressButton(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            UIView.animate(withDuration: 0.025) {
                self.createNoteButton.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
            }
        } else if gesture.state == .ended || gesture.state == .cancelled {
            resetButtonSize()
        }
    }
    
    @objc func handleLongPressCell(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            switch gesture.state {
            case .began:
                if let cell = tableView.cellForRow(at: indexPath) {
                    UIView.animate(withDuration: 0.1) {
                        cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    }
                }
            case .ended, .changed:
                resetCellSize(at: indexPath)
            default:
                break
            }
        }
    }

    private func resetCellSize(at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform.identity
            }
        }
    }
    
    private func resetButtonSize(){
        UIView.animate(withDuration: 0.025) {
            self.createNoteButton.transform = CGAffineTransform.identity
        }
    }



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return min(notes.count, titles.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "\(titles[indexPath.section]) \n \(notes[indexPath.section])"
        cell.textLabel?.textColor = .systemGray5
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22)
        cell.textLabel?.numberOfLines = 3
        cell.backgroundColor = UIColor(displayP3Red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellSpacing // İstediğiniz boşluk büyüklüğü
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
        let noteDetailVC = NoteDetailViewController()
        noteDetailVC.textView.text = notes[indexPath.row]
        noteDetailVC.textField.text = titles[indexPath.row]
        noteDetailVC.noteContent = notes[indexPath.row]
        noteDetailVC.titleContent = titles[indexPath.row]
        noteDetailVC.dismissAction = { [weak self] in
            if let updatedNote = noteDetailVC.noteContent, let updatedTitle = noteDetailVC.titleContent {
                self?.notes[indexPath.row] = updatedNote
                self?.titles[indexPath.row] = updatedTitle
                self?.tableView.reloadData()
            }
        }
        let navigationController = UINavigationController(rootViewController: noteDetailVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundColor = UIColor.darkGray // Daha koyu bir renk
        }
    }
/*    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Hücrenin seçimi kaldırıldığında orijinal rengine dön
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundColor = UIColor(displayP3Red: 0.15, green: 0.15, blue: 0.15, alpha: 1) // Orijinal renk
        }
    } */
}
