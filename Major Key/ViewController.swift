//
//  ViewController.swift
//  Major Key
//
//  Created by Felix Krause on 11/26/17.
//  Copyright © 2017 Felix Krause. All rights reserved.
//

import UIKit
import SendGrid
import SwiftMessages

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var majorTextView: UITextView!
    
    let emailAdress = "[email]"
    let apiKey = "[key]"
    let defaults = "MajorKeys"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.majorTextView.text = ""
        self.majorTextView.delegate = self

        let majorView = MajorKeyView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 92))
        majorView.delegate = self
        majorTextView.inputAccessoryView = majorView
        
        Session.shared.authentication = Authentication.apiKey(apiKey)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.majorTextView.becomeFirstResponder()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            self.didPressMajorKey()
            return false
        }
        return true
    }

    func didPressMajorKey() {
        let text = self.majorTextView.text!
        var oldKeys = UserDefaults.standard.stringArray(forKey: defaults)
        if oldKeys == nil {
            oldKeys = []
        }
        oldKeys!.append(text)
        UserDefaults.standard.set(oldKeys, forKey: defaults)
        
        let personalization = Personalization(recipients: emailAdress)
        let plainText = Content(contentType: ContentType.plainText, value: text)
        let email = Email(
            personalizations: [personalization],
            from: Address(email: emailAdress),
            content: [plainText],
            subject: "[Major 🔑] \(text)"
        )
        
        do {
            try Session.shared.send(request: email)
        } catch {
            print(error)
        }
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.configureDropShadow()
        view.button!.removeFromSuperview()
        
        view.configureContent(title: "Major Key", body: "Never forget dat major 🔑", iconText: "🔑")
        
        var config = SwiftMessages.Config()
        
        config.presentationStyle = .top
        
        config.interactiveHide = true
        config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show(config: config, view: view)
        
        self.majorTextView.text = ""
    }

    func didTapOldKeys() {
        self.majorTextView.text = UserDefaults.standard.stringArray(forKey: defaults)?.reversed().joined(separator: "\n")
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
}

