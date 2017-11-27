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

class ViewController: UIViewController {
    @IBOutlet weak var keyButton: UIButton!
    @IBOutlet weak var majorTextView: UITextView!
    
    let emailAdress = "[email]"
    let apiKey = "[key]"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.majorTextView.text = ""
        
        Session.shared.authentication = Authentication.apiKey(apiKey)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.majorTextView.becomeFirstResponder()
    }


    @IBAction func didPressMajorKey(_ sender: Any) {
        let text = self.majorTextView.text!
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
}

