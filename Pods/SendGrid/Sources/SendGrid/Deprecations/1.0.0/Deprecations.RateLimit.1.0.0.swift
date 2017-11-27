//
//  Deprecations.RateLimit.1.0.0.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/22/17.
//

import Foundation

public extension RateLimit {
    @available(*, deprecated, renamed: "from(response:)")
    static func rateLimitInfo(from response: URLResponse?) -> RateLimit? { return RateLimit.from(response: response) }
}
