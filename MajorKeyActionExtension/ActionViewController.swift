//
//  ActionViewController.swift
//  MajorKeyActionExtension
//
//  Created by Michael Schneider on 11/23/18.
//  Copyright © 2018 Felix Krause. All rights reserved.
//

import UIKit
import MobileCoreServices
import SwiftMessages

class ActionViewController: UIViewController {

    let apiClient: APIClient = MailJetAPIClient()

    @IBOutlet weak var textView: UITextView!

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.textView.text = ""

        // Search for supported attachments
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            guard let attachments = item.attachments else {
                continue
            }

            for attachment: NSItemProvider in attachments {
                if attachment.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    attachment.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { (url, error) in
                        guard let shareURL = url as? NSURL else {
                            return
                        }

                        print("Found URL: \(shareURL)")
                        DispatchQueue.main.async {
                            self.textView.text = shareURL.absoluteString
                        }
                    })
                    // We only handle only one attachment
                    break;
                } else if attachment.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                    attachment.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil, completionHandler: { (text, error) in
                        guard let shareText = text as? String else {
                            return
                        }

                        print("Found Text: \(shareText)")
                        DispatchQueue.main.async {
                            self.textView.text = shareText
                        }
                    })
                    // We only handle only one attachment
                    break;
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.textView.becomeFirstResponder()

        // TODO: Enable
//        if UserDefaults.shared.emailAddress == nil {
//            self.showAlert(title: "No email address set", body: "Please open the main app for the initial setup", theme: .error)
//        }
    }

    // MARK: Actions

    @IBAction func done() {
        // Don't send anything for zero text
        guard let text = self.textView.text, text.count > 0 else {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            return;
        }

        self.apiClient.send(text: text) { (result) in
            switch result {
            case .success:
                self.showAlert(
                    title: "Major Key",
                    body: "Never forget dat major key",
                    theme: .success,
                    closeOnHide: true
                )
            case .failure(let error):
                switch error {
                case .networkError(let reason):
                    self.showAlert(title: "Error", body: reason, theme: .error, closeOnHide: false)
                case .httpError(let reason):
                    self.showAlert(title: "Error", body: reason, theme: .error, closeOnHide: false)
                }
            }
        }
    }

    @IBAction func cancel(_ sender: Any) {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
}

// MARK: Alerts

extension ActionViewController {
    func showAlert(title: String, body: String, theme: Theme, closeOnHide: Bool) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureDropShadow()
        view.button?.removeFromSuperview()
        view.configureContent(title: title, body: body, iconText: "🔑")

        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.interactiveHide = true
        config.preferredStatusBarStyle = .lightContent
        config.presentationContext = .viewController(self)
        config.eventListeners.append { (event) in
            if case .didHide = event, closeOnHide == true {
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
        SwiftMessages.show(config: config, view: view)
    }
}
