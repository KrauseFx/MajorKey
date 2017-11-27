//
//  SubscriptionTracking.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/16/17.
//

import Foundation

/// The `SubscriptionTracking` class is used to modify the subscription tracking
/// setting on an email.
public struct SubscriptionTracking: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// Text to be appended to the email, with the subscription tracking link.
    /// You may control where the link is by using the tag `<% %>`. For example:
    ///
    ///     Click here to unsubscribe: <% %>
    public let text: String?
    
    /// HTML to be appended to the email, with the subscription tracking link.
    /// You may control where the link is by using the tag `<% %>`. For example:
    ///
    ///     <p><% Click here %> to unsubscribe.</p>
    public let html: String?
    
    /// A tag that will be replaced with the unsubscribe URL. For example:
    /// `[unsubscribe_url`. If this parameter is used, it will override both
    /// the `text` and `html` parameters. The URL of the link will be placed at
    /// the substitution tag's location, with no additional formatting.
    public let substitutionTag: String?
    
    /// A `Bool` indicating if the setting is enabled or not.
    public let enable: Bool
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Private initializer that sets all of the setting's properties.
    ///
    /// - Parameters:
    ///   - enable:             A boolean indicating whether the setting should
    ///                         be on or off.
    ///   - plainText:          Text to be appended to the email, with the
    ///                         subscription tracking link. You may control
    ///                         where the link is by using the tag `<% %>`.
    ///   - html:               HTML to be appended to the email, with the
    ///                         subscription tracking link. You may control
    ///                         where the link is by using the tag `<% %>`.
    ///   - substitutionTag:    A tag to indicate where to place the unsubscribe
    ///                         URL.
    fileprivate init(plainText: String?, html: String?, substitutionTag: String?) {
        self.enable = (plainText != nil && html != nil) || substitutionTag != nil
        self.text = plainText
        self.html = html
        self.substitutionTag = substitutionTag
    }
    
    /// Initializes the setting with no templates or substitution tags,
    /// effectively disabling the setting. Use this initializer if the
    /// subscription tracking setting is enabled on your SendGrid account by
    /// default and you want to disable it for this specific email.
    ///
    /// If you want to enable the setting and/or modify the configuration of the
    /// setting for this email, use either the `init(plainText:html:)` or the
    /// `init(substitutionTag:)` initializer instead.
    public init() {
        self.init(plainText: nil, html: nil, substitutionTag: nil)
    }
    
    /// Initializes the setting with a plain text and HTML template to put at
    /// the bottom of the email.
    ///
    /// Both templates must use the `<% %>` tag to indicate where to place the
    /// actual unsubscribe link. For instance, this would be a valid template
    /// for the plain text template:
    ///
    ///     Click here to unsubscribe: <% %>.
    ///
    /// …and this would be a valid template for the HTML portion:
    ///
    ///     <p><% Click here %> to unsubscribe.</p>
    ///
    /// If you want to place the unsubscribe link somewhere other than the
    /// bottom of the email, use the `init(substitutionTag:)` initializer
    /// instead.
    ///
    /// If the subscription tracking setting is enabled by default on your
    /// SendGrid account and you want to disable it for this email, use the
    /// `init()` initializer instead.
    ///
    /// - Parameters:
    ///   - plainText:  Text to be appended to the email, with the subscription
    ///                 tracking link. You may control where the link is by
    ///                 using the tag `<% %>`.
    ///   - html:       HTML to be appended to the email, with the subscription
    ///                 tracking link. You may control where the link is by
    ///                 using the tag `<% %>`.
    public init(plainText: String, html: String) {
        self.init(plainText: plainText, html: html, substitutionTag: nil)
    }
    
    /// Initializes the setting with a substitution tag to place the unsubscribe
    /// URL at. **Note:** the tag you specify will be replaced with the
    /// unsubscribe URL only, not the templates defined in the setting.
    ///
    /// So for example, if you specified `%unsubscribe%` as your substitution
    /// tag, then in your plain text portion of your email, you would want to
    /// have something like this:
    ///
    ///     Click here to unsubscribe: %unsubscribe%
    ///
    /// …and then in your HTML body you would want something like this:
    ///
    ///     <p><a href="%unsubscribe%">Click here</a> to unsubscribe.</p>
    ///
    /// - Parameter substitutionTag:    A tag to indicate where to place the
    ///                                 unsubscribe URL.
    public init(substitutionTag: String) {
        self.init(plainText: nil, html: nil, substitutionTag: substitutionTag)
    }
    
}

/// Encodable configuration
public extension SubscriptionTracking {
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case enable
        case text
        case html
        case substitutionTag    = "substitution_tag"
    }
    
}

/// Validatable conformance
extension SubscriptionTracking: Validatable {
    
    /// Validates that the plain text and HTML text contain the proper tag.
    public func validate() throws {
        let bodies: [String?] = [self.text, self.html]
        try bodies.forEach { (body) in
            guard let b = body else { return }
            guard Validate.subscriptionTracking(body: b) else {
                throw Exception.Mail.missingSubscriptionTrackingTag
            }
        }
    }
    
}
