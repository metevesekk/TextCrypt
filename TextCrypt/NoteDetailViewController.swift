//
//  NoteDetailViewController.swift
//  TextCrypt
//
//  Created by Mete Vesek on 10.12.2023.
//

import UIKit

class NoteDetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate{

    var textView = UITextView()
    var decryptButton = UIButton()
    var isEncrypted = true
    var noteContent: String?
    var titleContent : String?
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
    
    lazy var checkMarkItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(doneButtonTapped))
        item.tintColor = .systemYellow
            return item
        }()
    lazy var encryptMarkItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "lock.open"), style: .plain, target: self, action: #selector(encryptButtonTapped))
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
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .black
        self.navigationController?.navigationBar.backgroundColor = .clear


        
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
        setupTitleLabel()
        setupTextView()
        
        navigationItem.rightBarButtonItem = encryptMarkItem
        navigationItem.leftBarButtonItem = backMarkItem
        
        textView.delegate = self
        textField.delegate = self

    }
    

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    //MARK: setup fonksiyonları
    
    func setupTimeAndDateLabel() {
        view.addSubview(dateLabel)
        view.addSubview(timeLabel)
        view.addSubview(bookMark)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let currenDate = Date()
        dateLabel.text = dateFormatter.string(from: currenDate)
        timeLabel.text = timeFormatter.string(from: currenDate)
        bookMark.text = "|"
        
        dateLabel.font = .systemFont(ofSize: 17)
        timeLabel.font = .systemFont(ofSize: 17)
        bookMark.font = .systemFont(ofSize: 17)
        dateLabel.textColor = .systemGray2
        timeLabel.textColor = .systemGray2
        bookMark.textColor = .systemGray2
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        bookMark.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 62),
            
            bookMark.leftAnchor.constraint(equalTo: dateLabel.rightAnchor, constant: 10),
            bookMark.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 62),
            
            timeLabel.leftAnchor.constraint(equalTo: dateLabel.rightAnchor, constant: 22),
            timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 62),

            
        ])
    }

    func setupTextView() {
        view.addSubview(textView)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 82).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
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
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.textColor = .darkGray
    }
    
    func createDefaultTextField() -> UITextField {
        let textField = UITextField()
        textField.text = "Başlık"
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.textColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        return textField
    }
    
    func setupTitleLabel() {
        titleLabel.text = "Not Al"
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel
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
        }
        checkMarkItem.isHidden = false
        checkMarkItem.isEnabled = true
        encryptMarkItem.isEnabled = false
        encryptMarkItem.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textField{
            textView.becomeFirstResponder()
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
        contentInset.bottom = keyboardHeight - view.safeAreaInsets.bottom

        UIView.animate(withDuration: 0.3) {
            self.textView.contentInset = contentInset
            self.textView.scrollIndicatorInsets = contentInset
        }

        // Optionally, scroll to the selected text
        if let selectedRange = textView.selectedTextRange {
            textView.scrollRangeToVisible(textView.selectedRange)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.textView.contentInset = .zero
            self.textView.scrollIndicatorInsets = .zero
        }
    }

    

    
    //MARK: Animasyon fonksiyonları
    


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


   @objc func backButtonTapped() {
        noteContent = textView.text
        titleContent = textField.text
        dismiss(animated: true) {
            self.dismissAction?()
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

    // Klavyenin "Done" tuşuna basıldığında çağrılacak fonksiyon
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { // "Done" tuşuna basıldı mı kontrol et
            return true
        }
        return true
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

