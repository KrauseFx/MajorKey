//
//  Deprecations.Content.1.0.0.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/22/17.
//

import Foundation

public extension Content {
    @available(*, deprecated, renamed: "plainText(body:)")
    public static func plainTextContent(_ value: String) -> Content { return .plainText(body: value) }
    
    @available(*, deprecated, renamed: "html(body:)")
    public static func htmlContent(_ value: String) -> Content { return .html(body: value) }
    
    @available(*, deprecated, renamed: "emailBody(plain:html:)")
    public static func emailContent(plain: String, html: String) -> [Content] { return Content.emailBody(plain: plain, html: html) }
}
