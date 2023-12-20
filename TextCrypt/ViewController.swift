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
        navigationController?.navigationBar.backgroundColor = .systemYellow
        
        let longPressGestureButton = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressCell))
        let longPressGestureCell = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressButton))
        longPressGestureCell.minimumPressDuration = 0.2
        longPressGestureButton.minimumPressDuration = 0.2
        
        tableView.addGestureRecognizer(longPressGestureButton)
        createNoteButton.addGestureRecognizer(longPressGestureCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }


    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }


    func setupCreateNoteButton() {
        view.addSubview(createNoteButton)
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
            UIView.animate(withDuration: 0.1) {
                self.createNoteButton.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
            }
        } else if gesture.state == .ended || gesture.state == .cancelled{
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
        UIView.animate(withDuration: 0.1) {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
               return UITableViewCell()
           }
        
        let title = titles[indexPath.section]
        let note = notes[indexPath.section]
        cell.configure(withTitle: title, note: note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellSpacing
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)

        if let cell = tableView.cellForRow(at: indexPath) {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 1.0  // Başlangıç ölçeği (normal boyut)
            animation.toValue = 0.92   // Bitiş ölçeği (biraz büyütülmüş)
            animation.duration = 0.1
            animation.autoreverses = true  // Animasyonun tersine çevrilmesi (küçülmesi)
            animation.repeatCount = 1      // Tekrar sayısı

            cell.layer.add(animation, forKey: "bounce")
        }
        
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
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       
    }
}
