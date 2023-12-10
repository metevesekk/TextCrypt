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
    var saveButton = UIButton()
    var isEncrypted = true // Notun şu anki durumunu tutar
    var noteContent: String?
    var dismissAction: (() -> Void)?


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupTextView()
        setupDecryptButton()
        setupSaveButton() // Yeni butonu kur
    }
    

    func setupTextView() {
        view.addSubview(textView)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        textView.backgroundColor = UIColor(white: 0.95, alpha: 1) // Çok açık gri renk

        // Klavye için "Done" tuşunu ayarla
        textView.returnKeyType = .done
    }
    
    func setupSaveButton() {
           view.addSubview(saveButton)
           saveButton.translatesAutoresizingMaskIntoConstraints = false
           saveButton.bottomAnchor.constraint(equalTo: decryptButton.topAnchor, constant: -10).isActive = true
           saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
           saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
           saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

           saveButton.setTitle("Kaydet", for: .normal)
           saveButton.backgroundColor = .systemBlue
           saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
       }


    func setupDecryptButton() {
        view.addSubview(decryptButton)
        decryptButton.translatesAutoresizingMaskIntoConstraints = false
        decryptButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        decryptButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        decryptButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        decryptButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        decryptButton.setTitle("Şifreyi Aç", for: .normal)
        decryptButton.backgroundColor = .systemBlue
        decryptButton.addTarget(self, action: #selector(decryptButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func decryptButtonTapped() {
        if isEncrypted {
            presentPasswordAlert(for: .decrypt)
        } else {
            encryptText()
        }
    }
    
    @objc func saveButtonTapped() {
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
            textView.resignFirstResponder() // Klavyeyi kapat
            return false
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

