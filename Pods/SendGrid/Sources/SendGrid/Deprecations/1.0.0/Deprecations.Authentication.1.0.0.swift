//
//  Deprecations.Authentication.1.0.0.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/22/17.
//

import Foundation

public extension Authentication {
    /// Initializes with a dictionary and returns the most appropriate
    /// authentication type.
    ///
    /// - parameter info:    A dictionary containing a `api_key`, or `username`
    /// and `password` key.
    @available(*, unavailable, message: "use the designated initializer or one of the static functions")
    public init?(info: [AnyHashable: Any]) { return nil }
    
    /// Retrieves the user value for the authentication type (applies only to
    /// `.credential`).
    @available(*, unavailable, message: "use the `value` property to extrapolate the desired value")
    public var user: String? { return nil }
    
    /// Retrieves the key value for that authentication type. If the type is a
    /// `.Credentials`, this will be the password. Otherwise it will be the API
    /// key value.
    @available(*, unavailable, message: "use the `value` property to extrapolate the desired value")
    public var key: String { return "" }
}
