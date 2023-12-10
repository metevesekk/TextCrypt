//
//  ViewController.swift
//  TextCrypt
//
//  Created by Mete Vesek on 10.12.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let createNoteButton = UIButton(type: .system) // Not Oluştur butonu
    var notes = [String]() // Notları saklamak için dizi

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupCreateNoteButton()
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50), // Buton için yer bırak
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupCreateNoteButton() {
        view.addSubview(createNoteButton)
        createNoteButton.setTitle("Not Oluştur", for: .normal)
        createNoteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createNoteButton.heightAnchor.constraint(equalToConstant: 40),
            createNoteButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            createNoteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            createNoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        createNoteButton.addTarget(self, action: #selector(createNoteButtonTapped), for: .touchUpInside)
    }

    @objc func createNoteButtonTapped() {
        let noteDetailVC = NoteDetailViewController()
        noteDetailVC.dismissAction = { [weak self] in
            if let newNote = noteDetailVC.noteContent, !newNote.isEmpty {
                self?.notes.append(newNote) // Yeni notu ekliyoruz
                self?.tableView.reloadData()
            }
        }
        present(noteDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteDetailVC = NoteDetailViewController()
        noteDetailVC.textView.text = notes[indexPath.row]
        noteDetailVC.noteContent = notes[indexPath.row]
        noteDetailVC.dismissAction = { [weak self] in
            if let updatedNote = noteDetailVC.noteContent {
                self?.notes[indexPath.row] = updatedNote
                self?.tableView.reloadData()
            }
        }
        present(noteDetailVC, animated: true)
    }

    // ... [Diğer TableView DataSource ve Delegate metotları] ...
}

// NoteDetailViewController sınıfı ve diğer ilgili kodlar aynı kalacak.

