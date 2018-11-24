//
//  APIClient.swift
//  Major Key
//
//  Created by Michael Schneider on 11/23/18.
//  Copyright © 2018 Felix Krause. All rights reserved.
//

import UIKit

enum Result<Value, Error> {
    case success(Value)
    case failure(Error)
}

enum SendingError {
    case httpError(reason: String)
    case networkError(reason: String)
}

/// APIClient protocol for supporting different mail provider
protocol APIClient {
    func send(text: String, handler: @escaping (Result<String, SendingError>) -> Void)
}

/// MailJet APIClient
struct MailJetAPIClient: APIClient {

    static let apiEndpoint = "https://api.mailjet.com/v3.1/send"
    static let apiKey = ""
    static let apiSecret = ""

    func send(text: String, handler: @escaping (Result<String, SendingError>) -> Void) {
        let url = URL(string: MailJetAPIClient.apiEndpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Auth code
        // code via https://stackoverflow.com/questions/24379601/how-to-make-an-http-request-basic-auth-in-swift
        let loginString = String(format: "%@:%@", MailJetAPIClient.apiKey, MailJetAPIClient.apiSecret)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        // Subject allows 255 chars maximum
        let truncatedTextForSubject = text.suffix(200)

        let emailAddress = UserDefaults.shared.emailAddress
        let postContent = [
            "Messages": [
                [
                    "From": [
                        "Email": Settings.senderEmailAddress,
                        "Name": Settings.senderName
                    ],
                    "To": [
                        [
                            "Email": emailAddress,
                            "Name": Settings.receiverName
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
                        handler(.failure(.networkError(reason: String(describing: error))))
                        return
                    }

                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(String(describing: response) )")
                        handler(.failure(.httpError(reason: String(describing: response))))
                        return
                    }

                    let responseString = String(describing:String(data: data, encoding: .utf8))
                    print("responseString = \(responseString)")
                    handler(.success(responseString))
                }
            }
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
}
