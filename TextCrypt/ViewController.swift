//
//  ViewController.swift
//  NoteCrypt
//
//  Created by Mete Vesek on 24.12.2023.
//


import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    var context: NSManagedObjectContext!
    let tableView = UITableView()
    let createNoteButton = UIButton()
    let cellSpacing : CGFloat = 8
    var fetchedNotes: [NoteText] = []
    var titleLabel = UILabel()
    var selectedIndexPath: IndexPath?
    
    lazy var optionsMarkItem : UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(optionsButtonTapped))
        item.tintColor = .systemYellow
        return item
    }()

    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupTableView()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Cannot retrieve app delegate")
        }
        context = appDelegate.persistentContainer.viewContext

        setupCreateNoteButton()
        setupTitleLabel()
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        fetchNotes()
        navigationItem.rightBarButtonItem = optionsMarkItem
        
        let longPressGestureButton = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressCell))
        let longPressGestureCell = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressButton))
        longPressGestureCell.minimumPressDuration = 0.2
        longPressGestureButton.minimumPressDuration = 0.2
        
        tableView.addGestureRecognizer(longPressGestureButton)
        createNoteButton.addGestureRecognizer(longPressGestureCell)
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotes()
        tableView.delegate = self
        tableView.dataSource = self
    }

    //MARK: Core Data Fonksiyonları
    
    func fetchNotes() {
            let request: NSFetchRequest<NoteText> = NoteText.fetchRequest()
            do {
                fetchedNotes = try context.fetch(request)
            } catch {
                print("Not çekme hatası: \(error)")
            }
            tableView.reloadData()
        }
    
    func addNoteWithTitle(_ title: String, text: String) {
           let newNote = NoteText(context: context)
           newNote.title = title
           newNote.text = text
           do {
               try context.save()
               fetchNotes() // Listeyi güncelle
           } catch {
               print("Not kaydetme hatası: \(error)")
           }
       }
    
    func deleteNoteAtIndexPath(_ indexPath: IndexPath) {
        let noteToDelete = fetchedNotes[indexPath.section]
        context.delete(noteToDelete)
        fetchedNotes.remove(at: indexPath.section)
        
        do {
            try context.save()
            tableView.beginUpdates()
            tableView.deleteSections([indexPath.section], with: .automatic)
            tableView.endUpdates()
        } catch {
            print("Not silme hatası: \(error)")
        }
    }
    
    //MARK: setup Fonksiyonları
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
    
    func setupTitleLabel() {
        titleLabel.text = "TextCrypt"
        titleLabel.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 27)
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel
    }
    
    // MARK: reset fonksiyonları
    
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
    
    // MARK: @objc fonksiyonları
    

    
    @objc func optionsButtonTapped(Myswitch: UISwitch) {
        let settingsVC = SettingsController()
        settingsVC.modalPresentationStyle = .overCurrentContext
        settingsVC.modalTransitionStyle = .crossDissolve
        
        settingsVC.dismissAction = { [weak self] in
                //self?.blurEffectView?.isHidden = true
            }
        
        self.present(settingsVC, animated: true) {
                //self.blurEffectView?.isHidden = false
            }
        }
    
    @objc func createNoteButtonTapped() {
        let noteDetailVC = NoteDetailViewController()
        // İlk olarak managedObjectContext ve dismissAction'ı ayarla
        noteDetailVC.managedObjectContext = self.context
        noteDetailVC.dismissAction = { [weak self] in
            // Kullanıcı arayüzünden gelen not bilgilerini al
            if let newNote = noteDetailVC.noteContent, !newNote.isEmpty,
               let newTitle = noteDetailVC.titleContent, !newTitle.isEmpty {
                // Yeni bir Core Data nesnesi oluştur ve kaydet
                self?.addNoteWithTitle(newTitle, text: newNote)
            }
            if let newNote = noteDetailVC.noteContent, newNote.isEmpty,
               let newTitle = noteDetailVC.titleContent, !newTitle.isEmpty {
                // Yeni bir Core Data nesnesi oluştur ve kaydet
                self?.addNoteWithTitle(newTitle, text: newNote)
            }
            // Notları tekrar çekmek için fetchNotes çağrılabilir
            self?.fetchNotes()
        }

        // Not detayı için bir navigation controller oluştur
        let navigationController = UINavigationController(rootViewController: noteDetailVC)
        navigationController.modalPresentationStyle = .fullScreen

        // Navigation controller'ı sun
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
    

    // MARK: tavleView ayarları

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedNotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        // Fetch edilen notları kullanarak hücreyi yapılandır
        let note = fetchedNotes[indexPath.section]
        cell.configure(with: note)
        
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

    // MARK: didSelectRowAt

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 1.0
            animation.toValue = 0.92
            animation.duration = 0.15
            animation.autoreverses = true
            animation.repeatCount = 1

            cell.layer.add(animation, forKey: "bounce")
        }
        
        let noteDetailVC = NoteDetailViewController()
        // Seçilen notu NoteDetailViewController'a geçir
        let selectedNote = fetchedNotes[indexPath.section]
        noteDetailVC.note = selectedNote
        noteDetailVC.noteContent = selectedNote.text
        noteDetailVC.titleContent = selectedNote.title
        noteDetailVC.dismissAction = { [weak self] in
            // Kullanıcı notu tamamen silip geri döndüğünde ilgili notu sil
            if let newNote = noteDetailVC.noteContent, newNote.isEmpty,
               let newTitle = noteDetailVC.titleContent, newTitle.isEmpty {
                // Not silme fonksiyonunu çağır
                self?.deleteNoteAtIndexPath(indexPath)
            } else {
                // Not güncellendiyse veya değişiklik olmadıysa güncellemeleri kaydet
                if let newNote = noteDetailVC.noteContent, !newNote.isEmpty,
                   let newTitle = noteDetailVC.titleContent, !newTitle.isEmpty {
                    // Yeni bir Core Data nesnesi oluştur ve kaydet
                }
                // Notları tekrar çekmek için fetchNotes çağrılabilir
                self?.fetchNotes()
            }
        }
        
        let navigationController = UINavigationController(rootViewController: noteDetailVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }


    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Silme işlemini burada gerçekleştirin
                deleteNoteAtIndexPath(indexPath)
            }
            // Diğer düzenleme stilleri için de burada kod ekleyebilirsiniz
        }
}


