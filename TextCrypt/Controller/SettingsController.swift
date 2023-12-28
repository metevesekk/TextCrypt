//
//  SettingsController.swift
//  TextCrypt
//
//  Created by Mete Vesek on 27.12.2023.
//

import UIKit

class SettingsController: ViewController {

    var themeLabel = UILabel()
    var colorLabel = UILabel()
    var mySwitch = UISwitch()
    var dismissButton = UIButton()
    var dismissAction: (() -> Void)?
    var blurEffectView : UIVisualEffectView?
    weak var mainVC : ViewController?
    weak var tableViewCell : TableViewCell?
    var contentView = UIView()
    var buttons = [UIButton]()
    var colors : [UIColor] = [.white, .systemPink, .systemGray3, .systemBlue, .systemYellow, .black]
    let buttonSize : CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.bounds.width / 1.3
        let height = view.bounds.height / 2
        let x = (view.bounds.width - width) / 2
        let y = (view.bounds.height - height) / 2.3
        
        contentView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        contentView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemYellow.cgColor
        
        let switchValue = UserDefaults.standard.bool(forKey: "mySwitchValue")
        let blurStyle: UIBlurEffect.Style = switchValue ? .systemThinMaterialLight : .systemThickMaterialDark
        mySwitch.isOn = switchValue
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        blurEffectView?.frame = view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView?.isHidden = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissButtonTapped))
        blurEffectView?.addGestureRecognizer(tapGesture)
        blurEffectView?.isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        
        view.insertSubview(blurEffectView!, belowSubview: contentView)
        view.addSubview(contentView)
        
        setupFunctions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let switchValue = UserDefaults.standard.bool(forKey: "mySwitchValue")
        mySwitch.isOn = switchValue
        setupFunctions()
    }
    
    func setupButtons(){
        for (index, color) in colors.enumerated() {
            let button = UIButton()
            // Auto Layout kullanılacağı için frame tanımlamasına gerek yok.
            button.translatesAutoresizingMaskIntoConstraints = false // Auto Layout kullanacağımızı belirtiyoruz.
            button.layer.cornerRadius = buttonSize / 4 // Daire butonlar için.
            button.backgroundColor = color
            button.tag = index
            button.addTarget(self, action: #selector(buttonsTapped), for: .touchUpInside)
            contentView.addSubview(button) // Butonları contentView içine ekliyoruz.
            buttons.append(button)
            
            // Butonların constraintlerini tanımlıyoruz.
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: buttonSize),
                button.heightAnchor.constraint(equalToConstant: buttonSize),
                button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -110),
                // İlk butonu merkezden başlatmak için, centerXAnchor ile belirli bir konumda ayarlıyoruz.
                // Sonraki butonlar için bu noktadan itibaren her biri için 40 puanlık bir artışla x ekseninde yerleştiriyoruz.
                button.centerXAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(110 + index * (5 + Int(buttonSize))))
            ])
        }
    }

    
    func setupFunctions(){
        setupMySwitch()
        setupThemeLabel()
        setupDismissButton()
        setupButtons()
        setupThemeLabel()
        setupColorLabel()
    }
    
    func setupThemeLabel(){
        contentView.addSubview(themeLabel)
        themeLabel.text = "Tema"
        themeLabel.textColor = .white
        themeLabel.font = UIFont(name: "Times New Roman", size: 22)
        
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            themeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -130),
            themeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -170)
        ])
    }
    
    func setupColorLabel(){
        contentView.addSubview(colorLabel)
        colorLabel.text = "Renk"
        colorLabel.font = UIFont(name: "Times New Roman", size: 22)
        colorLabel.textColor = .white
        
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -130),
            colorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -110)
            
        ])
    }
    
    func setupMySwitch(){
        contentView.addSubview(mySwitch)
        mySwitch.isEnabled = true
        mySwitch.preferredStyle = .checkbox
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        mySwitch.onTintColor = .systemYellow
        mySwitch.thumbTintColor = .white
        NSLayoutConstraint.activate([
            mySwitch.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -50),
            mySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -170)
        ])
        mySwitch.addTarget(self, action: #selector(mySwitchtapped), for: .touchUpInside)
    }
    
    func setupDismissButton(){
        contentView.addSubview(dismissButton)
        dismissButton.setTitle("Close", for: .normal)
        dismissButton.setTitleColor(.black, for: .normal)
        dismissButton.backgroundColor = .white
        dismissButton.layer.cornerRadius = 5
        dismissButton.layer.borderWidth = 2
        dismissButton.layer.borderColor = UIColor.systemYellow.cgColor
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            dismissButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    @objc func dismissButtonTapped(){
            self.dismiss(animated: true) {
                self.dismissAction?()
            }
        }
    
    @objc func buttonsTapped(_ sender: UIButton) {
        // Tüm butonların seçimini sıfırla
        for button in buttons {
            UIView.animate(withDuration: 0.3) {
                button.layer.borderWidth = 0
                button.transform = .identity  // Eğer bir önceki seçimde transform edildiyse, orijinal haline getir.
            }
        }
        
        // Seçili olanın etrafına çerçeve çiz ve küçültme/büyütme animasyonu ekle
        UIView.animate(withDuration: 0.15) {
            sender.layer.borderWidth = 4
            sender.layer.borderColor = UIColor.darkGray.cgColor
          //  sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) // Küçült
        } completion: { _ in
            UIView.animate(withDuration: 0.01) {
                sender.transform = .identity // Orijinal boyutuna dön
            }
        }
    }

    
    @objc func mySwitchtapped() {
        UIView.animate(withDuration: 0.4) {
            let isSwitchOn = self.mySwitch.isOn
            UserDefaults.standard.set(isSwitchOn, forKey: "mySwitchValue")
            self.dismissButton.titleLabel?.textColor = isSwitchOn ? .black : .white
            self.themeLabel.textColor = isSwitchOn ? .black : .white
            self.colorLabel.textColor = isSwitchOn ? .black : .white
            self.dismissButton.backgroundColor = isSwitchOn ? .white : UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            self.contentView.backgroundColor = isSwitchOn ? UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) : UIColor(red:   0.1, green: 0.1, blue: 0.1, alpha: 1)
        
            let blurStyle: UIBlurEffect.Style = isSwitchOn ? .light : .systemThickMaterialDark
            self.blurEffectView?.effect = UIBlurEffect(style: blurStyle)
        }
    }
}
