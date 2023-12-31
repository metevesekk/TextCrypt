//
//  NoteDetailViewController.swift
//  NoteCrypt
//
//  Created by Mete Vesek on 24.12.2023.
//


import UIKit
import CoreData

class NoteDetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate{

    var textView = UITextView()
    var decryptButton = UIButton()
    var isEncrypted = true
    var noteContent: String?
    var titleContent : String?
    var timeContent: Date?
    var dateContent : Date?
    var dismissAction: (() -> Void)?
    var backButton = UIButton()
    var doneButton = UIButton()
    var buttonStackView = UIStackView()
    var encryptButton = UIButton()
    var viewController = ViewController()
    var textField = UITextField()
    var titleLabel = UILabel()
    var timeLabel = UILabel()
    var dateLabel = UILabel()
    var bookMark = UILabel ()
    var charCountLabel = UILabel()
    var managedObjectContext: NSManagedObjectContext!
    var note: NoteText?
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    var customUndoManager = UndoManager()
    var previousText: String = ""

    
    lazy var specialButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemYellow
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var redoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.uturn.right"), for: .normal)
        button.tintColor = .systemYellow
        button.addTarget(self, action: #selector(redoButtonTapped), for: .touchUpInside)
        return button
    }()

    
    lazy var undoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.uturn.left"), for: .normal)
        button.tintColor = .systemYellow
        button.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        return button
    }()

    
    lazy var checkMarkItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(doneButtonTapped))
        item.tintColor = .systemYellow
        return item
        }()
    lazy var encryptMarkItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "lock.fill"), style: .plain, target: self, action: #selector(encryptButtonTapped))
        item.tintColor = .systemYellow
        return item
        }()
    lazy var backMarkItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        item.tintColor = .systemYellow
        return item
        }()

    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .black
        self.navigationController?.navigationBar.backgroundColor = .black
        charCountLabel.text = "\(textView.text.count) karakter"
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Cannot retrieve app delegate")
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext

        loadNoteData()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)

        setupTitleTextField()
        setupTimeAndDateLabel()
        setupTextView()
        setupStackView()
        setupSpecialButton()
        view.sendSubviewToBack(specialButton)
        
        navigationItem.rightBarButtonItem = encryptMarkItem
        navigationItem.leftBarButtonItem = backMarkItem
        
        textView.delegate = self
        textField.delegate = self
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        timeFormatter.dateFormat = "HH:mm"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        charCountLabel.text = "\(textView.text.count) karakter"
        loadNoteData()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        timeFormatter.dateFormat = "HH:mm"
    }
    

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    func saveNote() {
           guard let context = managedObjectContext else {
               print("Managed Object Context is not set.")
               return
           }
           
           // Eğer bir not varsa güncelle, yoksa yeni oluştur
        let newNote = NoteText(context: managedObjectContext)
        newNote.title = textField.text ?? ""
        newNote.text = textView.text ?? ""

           do {
               try context.save()
               dismissAction?()
           } catch {
               print("Could not save the note: \(error)")
           }
       }
    
    func loadNoteData() {
        if let note = note {
            textView.text = note.text
            textField.text = note.title
        }
    }

    func addUndoAction(for text: String, withPreviousText previousText: String){
        customUndoManager.registerUndo(withTarget: self) { targetSelf in
            targetSelf.textView.text = previousText
            targetSelf.addRedoAction(for: previousText, withPreviousText: text)
            
        }
    }
    
    func addRedoAction(for text: String, withPreviousText previousText: String){
        customUndoManager.registerUndo(withTarget: self) { targetSelf in
            targetSelf.textView.text = text
            targetSelf.addUndoAction(for: text, withPreviousText: previousText)
        }
    }
    
    //MARK: setup fonksiyonları
    
    func setupSpecialButton(){
        view.addSubview(specialButton)
        specialButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           // specialButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor, constant: 12),
            specialButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
            //specialButton.heightAnchor.constraint(equalToConstant: )
            specialButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3),
            specialButton.bottomAnchor.constraint(equalTo: textView.topAnchor),
            specialButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            specialButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        ])
        specialButton.isEnabled = false
        specialButton.isHidden = false
        specialButton.layer.cornerRadius = 7
    }
    
    func setupTimeAndDateLabel() {
        view.addSubview(dateLabel)
        view.addSubview(timeLabel)
        view.addSubview(bookMark)
        view.addSubview(charCountLabel)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let currentDate = Date()
        dateLabel.text = dateFormatter.string(from: currentDate)
        timeLabel.text = timeFormatter.string(from: currentDate)
        bookMark.text = "|"
        
        dateLabel.font = .systemFont(ofSize: 17)
        timeLabel.font = .systemFont(ofSize: 17)
        bookMark.font = .systemFont(ofSize: 17)
        charCountLabel.font = .systemFont(ofSize: 17)
        dateLabel.textColor = .white
        timeLabel.textColor = .white
        bookMark.textColor = .white
        charCountLabel.textColor = .white
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        bookMark.translatesAutoresizingMaskIntoConstraints = false
        charCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            dateLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor, constant: 30),
            
            bookMark.leftAnchor.constraint(equalTo: dateLabel.rightAnchor, constant: 10),
            bookMark.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            
            timeLabel.leftAnchor.constraint(equalTo: dateLabel.rightAnchor, constant: 22),
            timeLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            
            charCountLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            charCountLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            
        ])
    }
    
    func setupStackView(){
        let stackView = UIStackView(arrangedSubviews: [undoButton, redoButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 17
        navigationItem.titleView = stackView
    }

    func setupTextView() {
        
        view.addSubview(textView)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        textView.topAnchor.constraint(equalTo: dateLabel.centerYAnchor, constant: 17).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 22)

        // Klavye için "Done" tuşunu ayarla
        textView.returnKeyType = .done
    }
    
    
    func setupTitleTextField() {
        if textField.text == ""{
            textField = createDefaultTextField()
        }
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.textColor = .white
    }
    
    func createDefaultTextField() -> UITextField {
        let textField = UITextField()
        textField.text = "Başlık"
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.textColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        return textField
    }
    
    
    //MARK: Text View fonksiyonları
    
    func textViewDidChange(_ textView: UITextView) {
        let currentText = textView.text ?? ""
        if previousText != currentText {
                addUndoAction(for: currentText, withPreviousText: previousText)
                previousText = currentText
            }
        charCountLabel.text = "\(textView.text.count) karakter"
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        previousText = textView.text
        return true
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
            navigationItem.rightBarButtonItem = checkMarkItem
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = encryptMarkItem
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Başlık"{
            textField.text = ""
            navigationItem.rightBarButtonItem = encryptMarkItem
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            if textField.text == ""{
                textField.text = "Başlık"
                textField.textColor = .gray
            }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textField{
            textView.becomeFirstResponder()
        }
        return true
    }
    
    // Klavyenin "Done" tuşuna basıldığında çağrılacak fonksiyon
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return true
        }
        return true
    }

    //MARK: @objc fonksiyonları


    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        var contentInset = textView.contentInset
        contentInset.bottom = keyboardHeight - view.safeAreaInsets.bottom + 25

        UIView.animate(withDuration: 0.3) {
            self.textView.contentInset = contentInset
            self.textView.scrollIndicatorInsets = contentInset
        }

        // Optionally, scroll to the selected text
        if textView.selectedTextRange != nil {
            textView.scrollRangeToVisible(textView.selectedRange)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.textView.contentInset = .zero
            self.textView.scrollIndicatorInsets = .zero
        }
    }

    //MARK: tapped fonksiyonları

      @objc func doneButtonTapped() {
        textField.resignFirstResponder()
        textView.resignFirstResponder() // Klavyeyi kapatır
      }
    
    @objc func encryptButtonTapped() {
        if isEncrypted {
            presentPasswordAlert(for: .decrypt)
        } else {
            encryptText()
        }
    }
    
    @objc func undoButtonTapped(){
        if customUndoManager.canUndo{
            customUndoManager.undo()
        }
    }
    
    @objc func redoButtonTapped(){
        if customUndoManager.canRedo{
            customUndoManager.redo()
        }
    }

    
    @objc func backButtonTapped() {
        if !(textView.text?.isEmpty ?? true) || (textField.text != "Başlık" && !(textField.text?.isEmpty ?? true)) {
                if note == nil {
                    note = NoteText(context: managedObjectContext)
                }

               // Notun başlığını ve metnini güncelle
                note?.title = textField.text
                note?.text = textView.text
            if let dateString = dateLabel.text, let date = dateFormatter.date(from: dateString) {
                note?.date = date
            } else {
                // dateString uygun formatta değil veya nil, hata işleme
            }

            if let timeString = timeLabel.text, let time = timeFormatter.date(from: timeString) {
                // Saat bilgisini de note?.date'e eklemek istiyorsanız, önce tarih ve saat bilgilerini birleştirmeniz gerekir.
                // Bunun için önce tarih ve saat bilgilerini ayrı ayrı çevirin, sonra bu iki Date'i birleştirin.
                if let date = note?.date {
                    var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
                    let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)

                    dateComponents.hour = timeComponents.hour
                    dateComponents.minute = timeComponents.minute

                    if let combinedDate = Calendar.current.date(from: dateComponents) {
                        note?.date = combinedDate
                    } else {
                        // Kombine edilmiş tarih oluşturulamadı, hata işleme
                    }
                }
            } else {
                // timeString uygun formatta değil veya nil, hata işleme
            }

               // Context'i kaydetmeyi dene
               do {
                   try managedObjectContext.save()
               } catch {
                   print("Notu kaydedemedim: \(error)")
               }
           }

        guard let note = self.note else {
            dismiss(animated: true, completion: dismissAction)
            return
        }

        // Notun başlığını ve içeriğini kontrol et
        if let text = textView.text, let title = textField.text {
            if text.isEmpty && title.isEmpty {
                // Notun hem içeriği hem de başlığı boş ise, notu sil ve geri dön
                managedObjectContext.delete(note)
                do {
                    try managedObjectContext.save()
                } catch {
                    print("Could not save after deleting the note: \(error)")
                }
                dismiss(animated: true, completion: dismissAction)
            } else {
                
                // Notun içeriği veya başlığı varsa, güncelle veya kaydet
                note.title = title
                note.text = text
                do {
                    try managedObjectContext.save()
                } catch {
                    print("Could not save the note: \(error)")
                }
                dismiss(animated: true, completion: dismissAction)
            }
        } else {
            // Eğer text veya title nil ise, direkt geri dön
            dismiss(animated: true, completion: dismissAction)
        }
    }




    //MARK: Şifreleme ile ilgili kodlar

    
    func presentPasswordAlert(for action: EncryptionAction) {
        let alert = UIAlertController(title: "Şifre Girin", message: "Lütfen şifreyi girin", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.isSecureTextEntry = true
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Giriş", style: .default) { [unowned self] _ in
            guard let password = alert.textFields?.first?.text else { return }
            if action == .decrypt {
                self.decryptText(with: password)
            } else {
                self.encryptText()
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        present(alert, animated: true)
    }



    // Şifre çözme ve şifreleme işlemleri için örnek fonksiyonlar
    func decryptText(with password: String) {

        isEncrypted = false
        decryptButton.setTitle("Şifrele", for: .normal)
    }

    func encryptText() {

        isEncrypted = true
        decryptButton.setTitle("Şifreyi Aç", for: .normal)
    }

    enum EncryptionAction {
        case encrypt
        case decrypt
    }
}
