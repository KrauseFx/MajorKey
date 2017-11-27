//
//  Deprecations.ClickTracking.1.0.0.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/22/17.
//

import Foundation

public extension ClickTracking {
    @available(*, deprecated, renamed: "init(section:)")
    public init(enable: Bool, enablePlainText: Bool? = nil) {
        self.enable = enable
        self.enableText = enablePlainText
    }
}
