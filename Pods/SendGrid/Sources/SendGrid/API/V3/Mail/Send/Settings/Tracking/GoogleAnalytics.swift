//
//  GoogleAnalytics.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/16/17.
//

import Foundation

/// The `GoogleAnalytics` class is used to toggle the Google Analytics setting,
/// which adds GA parameters to links in the email.
public struct GoogleAnalytics: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// Name of the referrer source. (e.g. Google, SomeDomain.com, or Marketing
    /// Email)
    public let source: String?
    
    /// Name of the marketing medium. (e.g. Email)
    public let medium: String?
    
    /// Used to identify any paid keywords.
    public let term: String?
    
    /// Used to differentiate your campaign from advertisements.
    public let content: String?
    
    /// The name of the campaign.
    public let campaign: String?
    
    /// A `Bool` indicating if the setting is enabled or not.
    public let enable: Bool
    
    
    // MARK: - Initializers
    //=========================================================================
    
    /// Initializes the setting with the various Google Analytics parameters.
    ///
    /// If the Google Analytics setting is normally enabled by default on your
    /// SendGrid account and you want to disable it for this particular email,
    /// specify `nil` for all the parameters (the default values for each
    /// parameter is `nil` so you can also just initialize with
    /// `GoogleAnalytics()` to set everything to `nil`).
    ///
    /// - Parameters:
    ///   - source:     Name of the referrer source. (e.g. Google,
    ///                 SomeDomain.com, or Marketing Email)
    ///   - medium:     Name of the marketing medium. (e.g. Email)
    ///   - term:       Used to identify any paid keywords.
    ///   - content:    Used to differentiate your campaign from advertisements.
    ///   - campaign:   The name of the campaign.
    public init(source: String? = nil, medium: String? = nil, term: String? = nil, content: String? = nil, campaign: String? = nil) {
        self.source = source
        self.medium = medium
        self.term = term
        self.content = content
        self.campaign = campaign
        self.enable = [source, medium, term, content, campaign].reduce(false) { $0 || $1 != nil }
    }
    
}

/// Encodable conformance.
public extension GoogleAnalytics {
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case enable
        case source     = "utm_source"
        case medium     = "utm_medium"
        case term       = "utm_term"
        case content    = "utm_content"
        case campaign   = "utm_campaign"
    }
    
}
