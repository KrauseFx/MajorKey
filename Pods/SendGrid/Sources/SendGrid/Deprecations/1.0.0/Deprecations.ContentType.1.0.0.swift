//
//  Deprecations.ContentType.1.0.0.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/22/17.
//

import Foundation

public extension ContentType {
    @available(*, deprecated, renamed: "init(rawValue:)")
    static func other(_ rawValue: String) -> ContentType { return ContentType(rawValue: rawValue)! }
}
