//
//  MessagesViewController.swift
//  iMessage Extension
//
//  Created by Hassan El Desouky on 11/29/18.
//  Copyright © 2018 Felix Krause. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var majorTextView: UITextView!
    var textViewRealYPosition: CGFloat = 0.0
    
    let apiKey = ""
    let apiSecret = ""

    let defaultsForHistory = "MajorKeys"
    let defaultsForEmail = "MajorKeyEmail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()

        let majorView = MajorKeyButtonView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 92))
        majorView.delegate = self as MajorKeyViewDelegate
        self.majorTextView.inputAccessoryView = majorView

    }
    
    fileprivate func setupTextView() {
        let tapOutTextField: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didPressTextView))
        self.majorTextView.text = ""
        self.majorTextView.delegate = self
        self.majorTextView.addGestureRecognizer(tapOutTextField)
    }
    
    //MARK: - Actions
    @objc func didPressTextView() {
        requestPresentationStyle(.expanded)
        majorTextView.becomeFirstResponder()
    }
    
    // MARK: - Conversation Handling
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        majorTextView.text = "Tap to expand."
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
        let present = MSMessagesAppPresentationStyle.expanded
        if present == presentationStyle {
            if validate(majorTextView) && majorTextView.text == "Tap to expand." {
                majorTextView.text = ""
            }
        } else {
            if !validate(majorTextView) {
                majorTextView.text = "Tap to expand."
            }
        }
    }
    
    //MARK: -
    func didPressKeyButton() {
        guard let text = self.majorTextView.text, text.count > 0 else {
            return
        }
        
        var oldKeys = UserDefaults.standard.stringArray(forKey: defaultsForHistory) ?? []
        oldKeys.append(text)
        UserDefaults.standard.set(oldKeys, forKey: defaultsForHistory)
        
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
        let url = URL(string: "https://api.mailjet.com/v3.1/send")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Auth code
        // code via https://stackoverflow.com/questions/24379601/how-to-make-an-http-request-basic-auth-in-swift
        let loginString = String(format: "%@:%@", apiKey, apiSecret)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Subject allows 255 chars maximum
        let truncatedTextForSubject = text.suffix(200)
        
        let emailAddress = UserDefaults.standard.string(forKey: defaultsForEmail)!
        let postContent = [
            "Messages": [
                [
                    "From": [
                        "Email": "new@MajorKey.me",
                        "Name": "New MajorKey"
                    ],
                    "To": [
                        [
                            "Email": emailAddress,
                            "Name": "Name"
                        ]
                    ],
                    "Subject": "[Major 🔑] \(truncatedTextForSubject)",
                    "TextPart": text
                ]
            ]
        ]
        do {
            let postString = try JSONSerialization.data(withJSONObject: postContent, options: .prettyPrinted)
            
            // Request body
            request.httpBody = postString //postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {                                                 // check for fundamental networking error
                        print("error=\(String(describing: error))")
                        self.showAlert(title: "Error", body: String(describing: error), theme: .error);
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(String(describing: response) )")
                        self.showAlert(title: "Error", body: String(describing: response), theme: .error);
                        return
                    }
                    
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(String(describing: responseString))")
                    self.showAlert(title: "Major Key", body: "Never forget dat major key", theme: .success);
                    
                    self.majorTextView.text = ""
                }
            }
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Helper functions
    // https://stackoverflow.com/questions/40021280/swift-check-if-textview-is-empty
    func validate(_ textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                // this will be reached if the text is nil (unlikely)
                // or if the text only contains white spaces
                // or no text at all
                return false
        }
        
        return true
    }


}

//MARK: - Extensions
extension MessagesViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            self.didPressKeyButton()
            return false
        }
        return true
    }
}

extension MessagesViewController: MajorKeyViewDelegate {
    func didPressKeyButton(button: UIButton) {
        didPressKeyButton()
    }
}
