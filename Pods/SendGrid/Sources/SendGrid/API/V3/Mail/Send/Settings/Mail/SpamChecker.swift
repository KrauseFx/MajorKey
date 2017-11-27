//
//  SpamChecker.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/16/17.
//

import Foundation

/// The `SpamChecker` mail setting allows you to test the content of your email
/// for spam.
public struct SpamChecker: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The threshold used to determine if your content qualifies as spam on a
    /// scale from 1 to 10, with 10 being most strict, or most likely to be
    /// considered as spam.
    public let threshold: Int?
    
    /// A webhook URL that you would like a copy of your email along with the
    /// spam report to be POSTed to.
    public let postURL: URL?
    
    /// A `Bool` indicating if the setting is enabled or not.
    public let enable: Bool
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the setting with a threshold and optional URL to POST spam
    /// reports to. This will enable the setting for this specific email even if
    /// it's normally disabled on your SendGrid account.
    ///
    /// If the spam checker setting is enabled by default on your SendGrid
    /// account and you want to disable it for this specific email, then use the
    /// `init()` initializer instead.
    ///
    /// - Parameters:
    ///   - threshold:  An integer used to determine if your content qualifies
    ///                 as spam on a scale from 1 to 10, with 10 being most
    ///                 strict, or most likely to be considered as spam.
    ///   - url:        A webhook URL that you would like a copy of your email
    ///                 along with the spam report to be POSTed to.
    public init(threshold: Int, url: URL? = nil) {
        self.threshold = threshold
        self.postURL = url
        self.enable = true
    }
    
    /// Initializes the setting with no threshold, indicating that the spam
    /// checker setting should be disabled for this particular email (assuming
    /// it's normally enabled on the SendGrid account).
    ///
    /// If you want to enable the spam checker setting, use the
    /// `init(threshold:url:)` initializer instead.
    public init() {
        self.threshold = nil
        self.postURL = nil
        self.enable = false
    }
    
}

/// Encodable conformance.
public extension SpamChecker {
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case enable
        case threshold
        case postURL = "post_to_url"
    }
    
}

/// Validatble conformance.
extension SpamChecker: Validatable {
    
    /// Validates that the threshold is within the correct range.
    public func validate() throws {
        if let level = self.threshold {
            guard 1...10 ~= level else { throw Exception.Mail.thresholdOutOfRange(level) }
        }
    }
    
}
