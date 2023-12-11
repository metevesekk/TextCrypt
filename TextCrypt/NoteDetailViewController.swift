//
//  NoteDetailViewController.swift
//  TextCrypt
//
//  Created by Mete Vesek on 10.12.2023.
//

import UIKit

class NoteDetailViewController: UIViewController, UITextViewDelegate {

    var textView = UITextView()
    var decryptButton = UIButton()
    var isEncrypted = true
    var noteContent: String?
    var dismissAction: (() -> Void)?
    var backButton = UIButton()
    var doneButton = UIButton()
    var buttonStackView = UIStackView()
    var encryptButton = UIButton()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupTextView()
        setupButtonStackView()
        setupEncryptButton()
        doneButton.isHidden = true
    }
    
    

    func setupTextView() {
        view.addSubview(textView)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 37).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        textView.backgroundColor = .black
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
        backButton.setTitle("Geri", for: .normal)
        backButton.setTitleColor(.systemYellow, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    func setupDoneButton() {
        doneButton.setTitle("Bitti", for: .normal)
        doneButton.setTitleColor(.systemYellow, for: .normal)
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
        doneButton.isHidden = false    // Butonu tekrar göster
        doneButton.isEnabled = true    // Butonu etkinleştir,
        encryptButton.isEnabled = false
        encryptButton.isHidden = true
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
        dismiss(animated: true) {
            self.dismissAction?()
        }
    }


    
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
        textView.text = "Şifre çözüldü: \(textView.text)"
        isEncrypted = false
        decryptButton.setTitle("Şifrele", for: .normal)
    }

    func encryptText() {
        // Burada şifreleme işlemini gerçekleştirin
        textView.text = "Şifreli: \(textView.text)"
        isEncrypted = true
        decryptButton.setTitle("Şifreyi Aç", for: .normal)
    }

    enum EncryptionAction {
        case encrypt
        case decrypt
    }
}

