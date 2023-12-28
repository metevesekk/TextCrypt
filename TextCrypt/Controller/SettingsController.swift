//
//  SettingsController.swift
//  TextCrypt
//
//  Created by Mete Vesek on 27.12.2023.
//

import UIKit

class SettingsController: ViewController {

    var colorLabel = UILabel()
    var mySwitch = UISwitch()
    var dismissButton = UIButton()
    var dismissAction: (() -> Void)?
    var blurEffectView : UIVisualEffectView?
    weak var mainVC : ViewController?
    weak var tableViewCell : TableViewCell?
    var contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.bounds.width / 1.3
        let height = view.bounds.height / 2
        let x = (view.bounds.width - width) / 2
        let y = (view.bounds.height - height) / 2.3
        
        contentView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        contentView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        contentView.layer.cornerRadius = 15
        
        let blurEffect = UIBlurEffect(style: .regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
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
    }
    
    func setupFunctions(){
        setupMySwitch()
        setupColorLabel()
        setupDismissButton()
    }
    
    func setupColorLabel(){
        view.addSubview(colorLabel)
        colorLabel.text = "Tema Terichi"
        colorLabel.textColor = .white
        colorLabel.font = .systemFont(ofSize: 20)
        
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60),
            colorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200)
        ])
    }
    
    func setupMySwitch(){
        view.addSubview(mySwitch)
        mySwitch.isEnabled = true
        mySwitch.preferredStyle = .checkbox
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        mySwitch.onTintColor = .systemYellow
        mySwitch.thumbTintColor = .white
        NSLayoutConstraint.activate([
            mySwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 90),
            mySwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200)
        ])
        mySwitch.addTarget(self, action: #selector(mySwitchtapped), for: .touchUpInside)
    }
    
    func setupDismissButton(){
        view.addSubview(dismissButton)
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
    
    @objc func mySwitchtapped() {
        let isSwitchOn = mySwitch.isOn
        UserDefaults.standard.set(isSwitchOn, forKey: "mySwitchValue")

        // mainVC UI Güncellemeleri
    /*    mainVC?.view.backgroundColor = isSwitchOn ? .white : .black
        mainVC?.tableView.backgroundColor = isSwitchOn ? .white : .black
        mainVC?.randomLabel.textColor = isSwitchOn ? .black : .white
        mainVC?.titleLabel.textColor = isSwitchOn ? .black : .white */
        self.dismissButton.titleLabel?.textColor = isSwitchOn ? .black : .white
        self.colorLabel.textColor = isSwitchOn ? .black : .white
        self.dismissButton.backgroundColor = isSwitchOn ? .white : UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.contentView.backgroundColor = isSwitchOn ? UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) : UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
   //     mainVC?.randomColor = isSwitchOn ? UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) : UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)

        // Blur Efekti Güncelleme
        let blurStyle: UIBlurEffect.Style = isSwitchOn ? .extraLight : .systemChromeMaterialDark
        blurEffectView?.effect = UIBlurEffect(style: blurStyle)
    }


}
