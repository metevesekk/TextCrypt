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
            return item
        }()
    lazy var encryptMarkItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "lock.open"), style: .plain, target: self, action: #selector(encryptButtonTapped))
            return item
        }()
    lazy var backMarkItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonTapped))
            return item
        }()

    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .black
        self.navigationController?.navigationBar.backgroundColor = .black


        
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

        let keyboardTopY = keyboardFrame.origin.y
        let selectedRange = textView.selectedRange
        let textRect = textView.layoutManager.boundingRect(forGlyphRange: selectedRange, in: textView.textContainer)
        let textViewRect = textView.convert(textRect, to: view)
        let textViewBottomY = textViewRect.origin.y + textViewRect.size.height

        if textViewBottomY > keyboardTopY {
            let offset = textViewBottomY - keyboardTopY
            textView.frame.origin.y -= offset
            textView.contentInset.bottom = keyboardFrame.size.height
            textView.scrollIndicatorInsets = textView.contentInset
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        textView.frame.origin.y = 82
        textView.contentInset.bottom = 0
        textView.scrollIndicatorInsets = textView.contentInset
    }

    

    
    //MARK: Animasyon fonksiyonları
    


      @objc func doneButtonTapped() {
        textField.resignFirstResponder()
        textView.resignFirstResponder() // Klavyeyi kapatır
    /*    checkMarkItem.isHidden = true
        checkMarkItem.isEnabled = false
        encryptMarkItem.isEnabled = true
        encryptMarkItem.isHidden = false */
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
         //   textView.resignFirstResponder() // Klavyeyi kapat
            return true
        }
        return true
    }
    
    // Diğer fonksiyonlarınız burada yer alacak...

    // Şifre çözme ve şifreleme işlemleri için örnek fonksiyonlar
    func decryptText(with password: String) {
        // Burada şifre çözme işlemini gerçekleştirin
  //      textView.text = "Şifre çözüldü: \(textView.text)"
        isEncrypted = false
        decryptButton.setTitle("Şifrele", for: .normal)
    }

    func encryptText() {
        // Burada şifreleme işlemini gerçekleştirin
  //      textView.text = "Şifreli: \(textView.text)"
        isEncrypted = true
        decryptButton.setTitle("Şifreyi Aç", for: .normal)
    }

    enum EncryptionAction {
        case encrypt
        case decrypt
    }
}

