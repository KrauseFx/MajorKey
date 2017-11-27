//
//  Deprecations.Request.1.0.0.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/22/17.
//

import Foundation

public extension Request {
    @available(*, unavailable, message: "use the `generateUrlRequest` method instead.")
    public func request(for session: Session, onBehalfOf: String?) throws -> URLRequest {
        throw Exception.Global.methodUnavailable(type(of: self), "request(for:onBehalfOf:)")
    }
}
