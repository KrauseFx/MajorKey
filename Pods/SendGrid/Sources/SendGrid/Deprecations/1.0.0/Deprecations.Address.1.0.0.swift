//
//  Deprecations.Address.1.0.0.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/22/17.
//

import Foundation

public extension Address {
    @available(*, deprecated, renamed: "init(email:)")
    public init(_ email: String) { self.init(email: email, name: nil) }
}
