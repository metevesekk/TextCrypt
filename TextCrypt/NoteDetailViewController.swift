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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
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
        setupButtonStackView()
        setupEncryptButton()
        textField.delegate = self
        doneButton.isHidden = true
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
          //  dateLabel.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: -20),
            
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
        textView.backgroundColor = .gray
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 22)

        // Klavye için "Done" tuşunu ayarla
        textView.returnKeyType = .done
    }
    
    func setupButtonStackView() {
            view.addSubview(buttonStackView)
            buttonStackView.addArrangedSubview(backButton)
            buttonStackView.addArrangedSubview(UIView())
            buttonStackView.addArrangedSubview(doneButton)
        
            buttonStackView.axis = .horizontal
            buttonStackView.distribution = .fill
            buttonStackView.spacing = 70
            buttonStackView.translatesAutoresizingMaskIntoConstraints = false
            buttonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -13).isActive = true
            buttonStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
            buttonStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
            buttonStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true

            setupBackButton()
            setupDoneButton()
        }
    
    func setupBackButton() {
       // view.addSubview(backButton)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .default)
        let openLockSymbol = UIImage(systemName: "arrow.left", withConfiguration: symbolConfiguration)
        backButton.setImage(openLockSymbol, for: .normal)
        backButton.tintColor = .systemYellow
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
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
        // Diğer varsayılan ayarlarınız burada yer alabilir.
        return textField
    }
    
    func setupTitleLabel() {
        titleLabel.text = "Not Al"
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel
    }

    func setupDoneButton() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .default)
        let openLockSymbol = UIImage(systemName: "checkmark", withConfiguration: symbolConfiguration)
        doneButton.setImage(openLockSymbol, for: .normal)
        doneButton.tintColor = .systemYellow
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    func setupEncryptButton() {
            view.addSubview(encryptButton)
            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .default)
            let openLockSymbol = UIImage(systemName: "lock.open", withConfiguration: symbolConfiguration)
            encryptButton.setImage(openLockSymbol, for: .normal)
            encryptButton.translatesAutoresizingMaskIntoConstraints = false
            encryptButton.tintColor = .systemYellow // Sembolün rengini ayarla
            encryptButton.addTarget(self, action: #selector(encryptButtonTapped), for: .touchUpInside)
            encryptButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -13).isActive = true
            encryptButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
            encryptButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        doneButton.isHidden = false
        doneButton.isEnabled = true
        encryptButton.isEnabled = false
        encryptButton.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Başlık"{
            textField.text = ""
        }
        doneButton.isHidden = false
        doneButton.isEnabled = true
        encryptButton.isEnabled = false
        encryptButton.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textField{
            textView.becomeFirstResponder()
        }
        return true
    }

    //MARK: @objc fonksiyonları
    
    @objc func keyboardWillShow(notification : NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let keyboardOrigin = keyboardRectangle.origin
            
            animateTextView(toValue: keyboardHeight)
        }
        
    }
    
    @objc func keyboardWillHide(notification : NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let keyboardOrigin = keyboardRectangle.origin
            
            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.fromValue = -keyboardHeight
            animation.toValue = 0
            animation.duration = 0.3
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
         //   animation.autoreverses = true // Animasyonun tersine çevrilmesini sağlar
            
            // textView.layer'a animasyonu ekle
            textView.layer.add(animation, forKey: "transform.translation.y")
            
        }
        
    }

      @objc func doneButtonTapped() {
        textView.resignFirstResponder() // Klavyeyi kapatır
        doneButton.isHidden = true
        doneButton.isEnabled = false
        encryptButton.isEnabled = true
        encryptButton.isHidden = false
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
    
    //MARK: Animasyon fonksiyonları
    
    func animateTextView(toValue: CGFloat) {
        // Animasyonun başlangıç ve bitiş değerlerini ayarla
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.fromValue = 0
        animation.toValue = -toValue
        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
     //   animation.autoreverses = true // Animasyonun tersine çevrilmesini sağlar
        
        // textView.layer'a animasyonu ekle
        textView.layer.add(animation, forKey: "transform.translation.y")
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

