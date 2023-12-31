//
//  ViewController.swift
//  NoteCrypt
//
//  Created by Mete Vesek on 24.12.2023.
//


import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {
    


    var context: NSManagedObjectContext!
    let tableView = UITableView()
    let createNoteButton = UIButton()
    let cellSpacing : CGFloat = 6
    var fetchedNotes: [NoteText] = []
    var titleLabel = UILabel()
    var selectedIndexPath: IndexPath?
    var randomLabel = UILabel()
    var randomColor = UIColor()
    var randomBool = Bool()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
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
        
        for family in UIFont.familyNames.sorted() {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family).sorted() {
                print("== \(name)")
            }
        }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Cannot retrieve app delegate")
        }
        context = appDelegate.persistentContainer.viewContext

        setupCreateNoteButton()
        randomLabel.isHidden = true
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
        
        let switchValue = UserDefaults.standard.bool(forKey: "mySwitchValue")
        setupUIBasedOnSwitch(switchValue: switchValue)
        
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotes()
        tableView.delegate = self
        tableView.dataSource = self
        
        let switchValue = UserDefaults.standard.bool(forKey: "mySwitchValue")
        setupUIBasedOnSwitch(switchValue: switchValue)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        timeFormatter.dateFormat = "HH:mm"
        
        let colorIndex = UserDefaults.standard.integer(forKey: "index")
        setupBasedOnColors(index: colorIndex)
    }
    
    // MARK: UserDefaults get functions
    
    func getIndexValue() -> Int{
        let index = UserDefaults.standard.integer(forKey: "index")
        return index
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
    
    func addNoteWithTitle(_ title: String, text: String, date: Date, time: Date) {
        let newNote = NoteText(context: context)
        newNote.title = title
        newNote.text = text
        newNote.date = date
        newNote.time = date
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
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5)
        ])
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    func setupCreateNoteButton() {
        view.addSubview(createNoteButton)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 45, weight: .regular, scale: .default)
        // "+" işaretini oluşturuyoruz ve konfigürasyonunu ekliyoruz
        let plusSymbol = UIImage(systemName: "plus", withConfiguration: symbolConfiguration)
        createNoteButton.setImage(plusSymbol, for: .normal)
        createNoteButton.tintColor = .systemYellow // "+" işaretinin rengini sarı yapıyoruz
        
        // Buton için içi boş çember oluşturuyoruz
        createNoteButton.backgroundColor = .clear // Butonun arka planını transparan yapıyoruz
        createNoteButton.layer.cornerRadius = 35 // Butonun yarıçapını ayarlıyoruz
        createNoteButton.layer.borderWidth = 2 // Çerçeve genişliği
        createNoteButton.layer.borderColor = UIColor.systemYellow.cgColor
        
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
    
    func setupUIBasedOnSwitch(switchValue: Bool) {
        if switchValue {
            view.backgroundColor = .white
            tableView.backgroundColor = .white
            randomLabel.textColor = .black
            titleLabel.textColor = .black
          //  randomColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            randomColor = .white
        } else {
            view.backgroundColor = .black
            tableView.backgroundColor = .black
            randomLabel.textColor = .white
            titleLabel.textColor = .white
          //  randomColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
            randomColor = .black
        }
    }
    
    
    
    func setupBasedOnColors(index: Int){
        switch index {
        case 0:
            optionsMarkItem.tintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
            createNoteButton.tintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
            createNoteButton.layer.borderColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1).cgColor
        case 1:
            optionsMarkItem.tintColor = .systemPink
            createNoteButton.tintColor = .systemPink
            createNoteButton.layer.borderColor = UIColor.systemPink.cgColor
        case 2:
            optionsMarkItem.tintColor = .systemGray3
            createNoteButton.tintColor = .systemGray3
            createNoteButton.layer.borderColor = UIColor.systemGray3.cgColor
        case 3:
            optionsMarkItem.tintColor = .systemBlue
            createNoteButton.tintColor = .systemBlue
            createNoteButton.layer.borderColor = UIColor.systemBlue.cgColor
        case 4:
            optionsMarkItem.tintColor = .systemYellow
            createNoteButton.tintColor = .systemYellow
            createNoteButton.layer.borderColor = UIColor.systemYellow.cgColor
        case 5:
            optionsMarkItem.tintColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
            createNoteButton.tintColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
            createNoteButton.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).cgColor
        default:
            print("Renk Bulunamadı")
        }
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
        
    @objc func optionsButtonTapped() {
        let settingsVC = SettingsController()
        settingsVC.modalPresentationStyle = .fullScreen
        settingsVC.mainVC = self
        present(settingsVC, animated: true)
    //    settingsVC.dismissAction = { [weak self] in }
        
        }
    
    @objc func createNoteButtonTapped() {
        let noteDetailVC = NoteDetailViewController()
        // İlk olarak managedObjectContext ve dismissAction'ı ayarla
        noteDetailVC.managedObjectContext = self.context
        noteDetailVC.view.backgroundColor = self.view.backgroundColor
        noteDetailVC.textView.backgroundColor = self.view.backgroundColor
        noteDetailVC.titleLabel.textColor = self.randomLabel.textColor
        noteDetailVC.textView.textColor = self.randomLabel.textColor
        noteDetailVC.backMarkItem.tintColor = createNoteButton.tintColor
        noteDetailVC.checkMarkItem.tintColor = createNoteButton.tintColor
        noteDetailVC.redoButton.tintColor = createNoteButton.tintColor
        noteDetailVC.undoButton.tintColor = createNoteButton.tintColor
        noteDetailVC.encryptMarkItem.tintColor = createNoteButton.tintColor
        noteDetailVC.specialButton.backgroundColor = createNoteButton.tintColor
        noteDetailVC.dismissAction = { [weak self] in
            // Kullanıcı arayüzünden gelen not bilgilerini al
            if let newNote = noteDetailVC.noteContent, !newNote.isEmpty,
               let newTitle = noteDetailVC.titleContent, !newTitle.isEmpty, let newDate = noteDetailVC.dateContent, let newTime = noteDetailVC.timeContent {
                // Yeni bir Core Data nesnesi oluştur ve kaydet
                self?.addNoteWithTitle(newTitle, text: newNote, date: newDate, time: newTime)
            }
            if let newNote = noteDetailVC.noteContent, newNote.isEmpty,
               let newTitle = noteDetailVC.titleContent, !newTitle.isEmpty, let newDate = noteDetailVC.dateContent, let newTime = noteDetailVC.timeContent {
                // Yeni bir Core Data nesnesi oluştur ve kaydet
                self?.addNoteWithTitle(newTitle, text: newNote, date: newDate, time: newTime)
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
                            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
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
    
    func didRequestDelete(_ cell: TableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        self.deleteNoteAtIndexPath(indexPath)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.containerView.backgroundColor = self.randomColor
        cell.containerView.layer.borderColor = self.createNoteButton.tintColor.cgColor
        cell.titleLabel.textColor = self.randomLabel.textColor
        cell.noteLabel.textColor = self.randomLabel.textColor
        cell.deleteButton.backgroundColor = self.createNoteButton.tintColor

        let note = fetchedNotes[indexPath.section]
        cell.configure(with: note)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = self.randomColor
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
            animation.duration = 0.10
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
        noteDetailVC.dateContent = selectedNote.date
        noteDetailVC.timeContent = selectedNote.time
        noteDetailVC.view.backgroundColor = self.view.backgroundColor
        noteDetailVC.textView.backgroundColor = self.view.backgroundColor
        noteDetailVC.titleLabel.textColor = self.randomLabel.textColor
        noteDetailVC.textView.textColor = self.randomLabel.textColor
        noteDetailVC.backMarkItem.tintColor = createNoteButton.tintColor
        noteDetailVC.checkMarkItem.tintColor = createNoteButton.tintColor
        noteDetailVC.redoButton.tintColor = createNoteButton.tintColor
        noteDetailVC.undoButton.tintColor = createNoteButton.tintColor
        noteDetailVC.encryptMarkItem.tintColor = createNoteButton.tintColor
        noteDetailVC.specialButton.backgroundColor = createNoteButton.tintColor
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
}


