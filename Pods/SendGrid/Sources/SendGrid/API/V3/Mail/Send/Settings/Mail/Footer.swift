//
//  Footer.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/16/17.
//

import Foundation

/// The `Footer` mail setting allows you to specify a footer that will be
/// appended to the bottom of every email.
public struct Footer: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The plain text content of your footer.
    public let text: String?
    
    /// The HTML content of your footer.
    public let html: String?
    
    /// A `Bool` indicating if the setting is enabled or not.
    public let enable: Bool
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the setting with plain text and HTML to use in the footer.
    /// This will enable the setting for this email and use the provided
    /// content.
    ///
    /// If the footer setting is enabled by default on your SendGrid account and
    /// you want to disable it for this email, use the `init()` initializer
    /// instead.
    ///
    /// - Parameters:
    ///   - text: The plain text content of your footer.
    ///   - html: The HTML content of your footer.
    public init(text: String, html: String) {
        self.text = text
        self.html = html
        self.enable = true
    }
    
    /// Initializes the setting with no templates, indicating that the footer
    /// setting should be disabled for this particular email (assuming it's
    /// normally enabled on the SendGrid account).
    ///
    /// If you want to enable the footer setting, use the `init(text:html:)`
    /// initializer instead.
    public init() {
        self.text = nil
        self.html = nil
        self.enable = false
    }
    
}
