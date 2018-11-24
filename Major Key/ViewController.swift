//
//  ViewController.swift
//  Major Key
//
//  Created by Felix Krause on 11/26/17.
//  Copyright © 2017 Felix Krause. All rights reserved.
//

import UIKit
import SwiftMessages

class ViewController: UIViewController {

    let apiClient: APIClient = MailJetAPIClient()

    @IBOutlet weak var majorTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.majorTextView.text = ""
        self.majorTextView.delegate = self

        let majorView = MajorKeyView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 92))
        majorView.delegate = self
        self.majorTextView.inputAccessoryView = majorView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.majorTextView.becomeFirstResponder()
        
        if UserDefaults.shared.emailAddress == nil {
            self.didPressSettingsButton(button: nil)
        }
    }

    func didPressMajorKey() {
        guard let text = self.majorTextView.text, text.count > 0 else {
            return
        }

        var oldKeys = UserDefaults.shared.history
        oldKeys.append(text)
        UserDefaults.shared.history = oldKeys

        triggerEmail(text: text)
    }
    
    func showAlert(title: String, body: String, theme: Theme) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureDropShadow()
        view.button?.removeFromSuperview()
        view.configureContent(title: title, body: body, iconText: "🔑")
        
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.interactiveHide = true
        config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show(config: config, view: view)
    }
    
    func triggerEmail(text: String) {
        self.apiClient.send(text: text) { (result) in
            switch result {
            case .success:
                self.showAlert(title: "Major Key", body: "Never forget dat major key", theme: .success);
                self.majorTextView.text = ""
            case .failure(let error):
                switch error {
                case .networkError(let reason):
                    self.showAlert(title: "Error", body: reason, theme: .error);
                case .httpError(let reason):
                    self.showAlert(title: "Error", body: reason, theme: .error);
                }
            }
        }
    }

    func didTapOldKeys() {
        self.majorTextView.text = UserDefaults.shared.history.reversed().joined(separator: "\n")
    }
    
    func didPressSettingsButton(message: String) {
        let alert = UIAlertController(
            title: "Choose your email address",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addTextField { (textField) in
            textField.placeholder = "Your email address"
            textField.keyboardType = .emailAddress
            textField.textContentType = UITextContentType.emailAddress
            textField.text = UserDefaults.shared.emailAddress
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields?[0] else {
                print("Couldn't find alert text field")
                return
            }

            if let text = textField.text, text.contains("@") {
                UserDefaults.shared.emailAddress = text
            } else {
                self.didPressSettingsButton(message: "Please enter a valid email address");
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
          didPressMajorKey()
          return false
        }

        return true
    }
}

extension ViewController: MajorKeyViewDelegate {
    func didPressKeyButton(button: UIButton) {
        didPressMajorKey()
    }

    func didPressPackageButton(button: UIButton) {
        didPressMajorKey()
        didTapOldKeys()
    }
    
    func didPressSettingsButton(button: UIButton?) {
        didPressSettingsButton(message: "This is where all major keys will be sent to");
    }
}
