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
    var indexPath = IndexPath()
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.bounds.width / 1.3
        let height = view.bounds.height / 2
        let x = (view.bounds.width - width) / 2
        let y = (view.bounds.height - height) / 2.3
        contentView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        contentView.backgroundColor = getSwitchValue() ? UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.1) : UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        
        
        switch getColorIndexValue() {
        case 0:
            contentView.layer.borderColor = UIColor.white.cgColor
            dismissButton.layer.borderColor = UIColor.white.cgColor
            mySwitch.onTintColor = .white
        case 1:
            contentView.layer.borderColor = UIColor.systemPink.cgColor
            dismissButton.layer.borderColor = UIColor.systemPink.cgColor
            mySwitch.onTintColor = .systemPink
        case 2:
            contentView.layer.borderColor = UIColor.systemGray3.cgColor
            dismissButton.layer.borderColor = UIColor.systemGray3.cgColor
            mySwitch.onTintColor = .systemGray3
        case 3:
            contentView.layer.borderColor = UIColor.systemBlue.cgColor
            dismissButton.layer.borderColor = UIColor.systemBlue.cgColor
            mySwitch.onTintColor = .systemBlue
        case 4:
            contentView.layer.borderColor = UIColor.systemYellow.cgColor
            dismissButton.layer.borderColor = UIColor.systemYellow.cgColor
            mySwitch.onTintColor = .systemYellow
        case 5:
            contentView.layer.borderColor = UIColor.black.cgColor
            dismissButton.layer.borderColor = UIColor.black.cgColor
            mySwitch.onTintColor = .black
        default:
            print("Renk Bulunamadı")
        }
        
        
        
        let blurStyle: UIBlurEffect.Style = getSwitchValue() ? .systemThinMaterialLight : .systemThickMaterialDark
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        blurEffectView?.frame = view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView?.isHidden = false
        view.insertSubview(blurEffectView!, belowSubview: contentView)
        view.addSubview(contentView)
        setupFunctions()
    }
    
    //MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFunctions()
    }
    
    
    
    
    // MARK: UserDefaults get functions
    
    func getSwitchValue() -> Bool{
        let switchValue = UserDefaults.standard.bool(forKey: "mySwitchValue")
        mySwitch.isOn = switchValue
        return switchValue
    }
    
     func getColorIndexValue() -> Int{
        let index = UserDefaults.standard.integer(forKey: "index")
        return index
    }
    
    
    
    // MARK: setup functions
    
    func setupFunctions(){
        setupMySwitch()
        setupThemeLabel()
        setupDismissButton()
        setupButtons()
        setupThemeLabel()
        setupColorLabel()
        setupTapGesture()
    }
    
    func setupColors(_ index: Int){
        switch index {
        case 0:
            contentView.layer.borderColor = UIColor.white.cgColor
            dismissButton.layer.borderColor = UIColor.white.cgColor
            mySwitch.onTintColor = .white
        case 1:
            contentView.layer.borderColor = UIColor.systemPink.cgColor
            dismissButton.layer.borderColor = UIColor.systemPink.cgColor
            mySwitch.onTintColor = .systemPink
        case 2:
            contentView.layer.borderColor = UIColor.systemGray3.cgColor
            dismissButton.layer.borderColor = UIColor.systemGray3.cgColor
            mySwitch.onTintColor = .systemGray3
        case 3:
            contentView.layer.borderColor = UIColor.systemBlue.cgColor
            dismissButton.layer.borderColor = UIColor.systemBlue.cgColor
            mySwitch.onTintColor = .systemBlue
        case 4:
            contentView.layer.borderColor = UIColor.systemYellow.cgColor
            dismissButton.layer.borderColor = UIColor.systemYellow.cgColor
            mySwitch.onTintColor = .systemYellow
        case 5:
            contentView.layer.borderColor = UIColor.black.cgColor
            dismissButton.layer.borderColor = UIColor.black.cgColor
            mySwitch.onTintColor = .black
        default:
            print("Renk Bulunamadı")
        }
    }

    
    func setupTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissButtonTapped))
        blurEffectView?.addGestureRecognizer(tapGesture)
        blurEffectView?.isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
    }
    
    func setupButtons(){
        for (index, color) in colors.enumerated() {
            let button = UIButton()
            // Auto Layout kullanılacağı için frame tanımlamasına gerek yok.
            button.translatesAutoresizingMaskIntoConstraints = false // Auto Layout kullanacağımızı belirtiyoruz.
            button.layer.cornerRadius = buttonSize / 6 // Daire butonlar için.
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
    
    func setupThemeLabel(){
        contentView.addSubview(themeLabel)
        themeLabel.text = "Tema"
        themeLabel.textColor = getSwitchValue() ? .black : .white
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
        colorLabel.textColor = getSwitchValue() ? .black : .white
        
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
    //    mySwitch.onTintColor = .systemYellow
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
        dismissButton.setTitleColor(getSwitchValue() ? .black : .white, for: .normal)
        dismissButton.backgroundColor = getSwitchValue() ? UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) : UIColor(red:   0.15, green: 0.15, blue: 0.15, alpha: 1)
        dismissButton.layer.cornerRadius = 5
        dismissButton.layer.borderWidth = 2
     //   dismissButton.layer.borderColor = UIColor.systemYellow.cgColor
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            dismissButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    // MARK: @objc functions
    
    @objc func dismissButtonTapped(){
            self.dismiss(animated: true) {
                self.dismissAction?()
            }
        }
    
    @objc func buttonsTapped(_ sender: UIButton) {
        for button in buttons {
            UIView.animate(withDuration: 0.3) {
                button.layer.borderWidth = 0
                button.transform = .identity
            }
        }
        UIView.animate(withDuration: 0.15) {
            sender.layer.borderWidth = 3
            sender.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        let buttonIndex = sender.tag
        UserDefaults.standard.setValue(buttonIndex, forKey: "index")
        self.setupColors(self.getColorIndexValue())
    }

    
    @objc func mySwitchtapped() {
        UIView.animate(withDuration: 0.4) {
            let isSwitchOn = self.mySwitch.isOn
            UserDefaults.standard.set(isSwitchOn, forKey: "mySwitchValue")
            self.dismissButton.titleLabel?.textColor = isSwitchOn ? .black : .white
            self.themeLabel.textColor = isSwitchOn ? .black : .white
            self.colorLabel.textColor = isSwitchOn ? .black : .white
            self.dismissButton.backgroundColor = isSwitchOn ? .white : UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            self.contentView.backgroundColor = isSwitchOn ? UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) : UIColor(red:   0.15, green: 0.15, blue: 0.15, alpha: 1)
        
            let blurStyle: UIBlurEffect.Style = isSwitchOn ? .systemMaterialLight : .systemThickMaterialDark
            self.blurEffectView?.effect = UIBlurEffect(style: blurStyle)
        }
    }
}
