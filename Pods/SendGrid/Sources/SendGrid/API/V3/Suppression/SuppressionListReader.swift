//
//  SuppressionListReader.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

/// The `SuppressionListReader` class is base class inherited by requests that
/// retrieve entries from a supression list. You should not use this class
/// directly.
public class SuppressionListReader<T : EmailEventRepresentable & Decodable>: Request<[T]> {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The date to start looking for events.
    public let startDate: Date?
    
    /// The date to stop looking for events.
    public let endDate: Date?
    
    /// The page of results to look for.
    public let page: Page?
    
    /// The path for the request's API endpoint.
    internal var path: String {
        return "/"
    }
    
    /// The query params for the request.
    internal var queryItems: [URLQueryItem]? {
        var items: [(String, String)]?
        func append(_ str: String, _ val: Any) {
            let element = (str, "\(val)")
            if items == nil {
                items = [element]
            } else {
                items?.append(element)
            }
        }
        
        if let p = self.page {
            append("limit", p.limit)
            append("offset", p.offset)
        }
        if let s = self.startDate { append("start_time", Int(s.timeIntervalSince1970)) }
        if let e = self.endDate { append("end_time", Int(e.timeIntervalSince1970)) }
        return items?.map { URLQueryItem(name: $0.0, value: $0.1) }
    }
    
    
    // MARK: - Initialization
    //======================================================================
    
    /// Initializes the request with a specific email to look for in the
    /// bounce list.
    ///
    /// - Parameter email: The email address to look for in the bounce list.
    public init(email: String) {
        self.startDate = nil
        self.endDate = nil
        self.page = nil
        super.init(
            method: .GET,
            contentType: .formUrlEncoded,
            path: "\(self.path)/\(email)"
        )
    }
    
    
    /// Initializes the request to retrieve a list of bounces.
    ///
    /// - Parameters:
    ///   - start:  Limits the search to a specific start time for the
    ///             event.
    ///   - end:    Limits the search to a specific end time for the event.
    ///   - range:  A range of dates to search between If `nil`, the entire
    ///             bounce list will be searched.
    ///   - page:   A `PaginationInfo` instance to limit the search to a
    ///             specific page. The `limit` value cannot exceed 500. If
    ///             not specified, the limit will be set to 500 and the
    ///             offset will be set to 0.
    /// - Throws:   An error will be thrown if the `limit` value in `page`
    ///             is out of range.
    public init(start: Date? = nil, end: Date? = nil, page: Page? = nil) {
        self.startDate = start
        self.endDate = end
        self.page = page
        super.init(
            method: .GET,
            contentType: .formUrlEncoded,
            path: self.path
        )
        self.endpoint?.queryItems = self.queryItems
    }
    
    // MARK: - Methods
    //=========================================================================
    
    /// Validates that the `limit` value isn't over 500.
    public override func validate() throws {
        try super.validate()
        if let limit = self.page?.limit {
            let range = 1...500
            guard range ~= limit else { throw Exception.Global.limitOutOfRange(limit, range) }
        }
    }
    
}
