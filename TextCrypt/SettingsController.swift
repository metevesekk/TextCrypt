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
        contentView.isUserInteractionEnabled = false
        
        view.insertSubview(blurEffectView!, belowSubview: contentView)
        view.addSubview(contentView)
        
        setupFunctions()
    }
    
    
    func setupFunctions(){
        setupMySwitch()
        setupColorLabel()
        setupDismissButton()
    //    setupBlurTapGesture()
    }
    
    func setupColorLabel(){
        view.addSubview(colorLabel)
        colorLabel.text = "Arkaplan Terichi"
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
        mySwitch.isOn = SettingsManager.shared.getSwitchStatus()
        mySwitch.isEnabled = true
        mySwitch.preferredStyle = .checkbox
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        mySwitch.onTintColor = .systemYellow
        mySwitch.thumbTintColor = .white
        NSLayoutConstraint.activate([
            mySwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 90),
            mySwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200)
        ])
    }
    
    func setupDismissButton(){
        view.addSubview(dismissButton)
        dismissButton.setTitle("Close", for: .normal)
        dismissButton.setTitleColor(.black, for: .normal)
        dismissButton.backgroundColor = .systemYellow
        dismissButton.layer.cornerRadius = 5
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
}
