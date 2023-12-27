//
//  SettingsController.swift
//  TextCrypt
//
//  Created by Mete Vesek on 27.12.2023.
//

import UIKit

class SettingsController: UIViewController {

    var colorLabel = UILabel()
    var mySwitch = UISwitch()
    var dismissButton = UIButton()
    var dismissAction: (() -> Void)?
    var blurEffectView : UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = view.bounds.width / 1.3
        let height = view.bounds.height / 2
        let x = (view.bounds.width - width) / 2
        let y = (view.bounds.height - height) / 2.3
        
        let contentView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        contentView.backgroundColor = .white  // Veya istediğiniz bir renk
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 15
        
        let blurEffect = UIBlurEffect(style: .regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView?.isHidden = false
        view.insertSubview(blurEffectView!, belowSubview: contentView)
        view.addSubview(contentView)
        
        setupFunctions()
    }
    
    func setupFunctions(){
        setupMySwitch()
        setupColorLabel()
        setupDismissButton()
    }
    
    func setupColorLabel(){
        view.addSubview(colorLabel)
        colorLabel.text = "Arkaplan Terichi"
        colorLabel.textColor = .white
        colorLabel.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 20)
        
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -220)
        ])
    }
    
    func setupDismissButton(){
        view.addSubview(dismissButton)
        dismissButton.setTitle("Close", for: .normal)
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.backgroundColor = .systemYellow
        dismissButton.layer.cornerRadius = 5
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    func setupMySwitch(){
        view.addSubview(mySwitch)
        mySwitch.isOn = SettingsManager.shared.getSwitchStatus()
        mySwitch.isEnabled = true
        mySwitch.preferredStyle = .checkbox
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        mySwitch.onTintColor = .systemYellow
        mySwitch.thumbTintColor = .white
        NSLayoutConstraint.activate([
            mySwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mySwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -180)
        ])
    }
    
    @objc func dismissButtonTapped(){
            self.dismiss(animated: true) {
                self.dismissAction?()
            }
        }
}
