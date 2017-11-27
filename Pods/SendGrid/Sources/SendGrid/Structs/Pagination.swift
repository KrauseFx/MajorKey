//
//  Pagination.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

/// The `Pagination` struct represents all the pagination info that can be
/// returned via an API call, often containing a `first`, `previous`, `next`,
/// and `last` page. This struct represents all those pages as `Page` instances.
public struct Pagination {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The first page of results.
    public let first: Page?
    
    /// The previous page of results.
    public let previous: Page?
    
    /// The next page of results.
    public let next: Page?
    
    /// The last page of results.
    public let last: Page?
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the struct with a first, previous, next, and last page.
    ///
    /// - Parameters:
    ///   - first:      The first page of results.
    ///   - previous:   The previous page of results.
    ///   - next:       The next page of results.
    ///   - last:       The last page of results.
    public init(first: Page? = nil, previous: Page? = nil, next: Page? = nil, last: Page? = nil) {
        self.first = first
        self.previous = previous
        self.next = next
        self.last = last
    }
    
    
    /// Returns a new struct instance from a URLResponse, extracting the
    /// information out of the "Link" header (if present).
    ///
    /// - Parameter response:   An instance of `URLResponse`.
    /// - Returns:              An instance of `Pages` using information
    ///                         from an URLResponse (if pagination
    ///                         information was returned in the
    ///                         URLResponse).
    static func from(response: URLResponse?) -> Pagination? {
        guard let http = response as? HTTPURLResponse,
            let link = http.allHeaderFields["Link"] as? String,
            let relRegex = try? NSRegularExpression(pattern: "(?<=rel=\")\\S+(?=\")"),
            let urlRegex = try? NSRegularExpression(pattern: "(?<=<)\\S+(?=>)")
            else { return nil }
        func first(match pattern: String, in str: String) -> String? {
            let range = str.startIndex..<str.endIndex
            guard let regex = try? NSRegularExpression(pattern: pattern),
                let result = regex.firstMatch(in: str, range: NSRange(range, in: str)),
                let matchRange = Range(result.range, in: str)
                else { return nil }
            return String(str[matchRange])
        }
        let rawPages = link.split(separator: ",").flatMap { (item) -> (String, Page)? in
            let partial = String(item)
            guard let name = first(match: "(?<=rel=\")\\S+(?=\")", in: partial),
                let limitStr = first(match: "(?<=limit=)\\d+", in: partial),
                let limit = Int(limitStr),
                let offsetStr = first(match: "(?<=offset=)\\d+", in: partial),
                let offset = Int(offsetStr)
                else { return nil }
            let info = Page(limit: limit, offset: offset)
            return (name, info)
        }
        func page(_ rel: String) -> Page? {
            let filtered = rawPages.filter { $0.0 == rel }
            return filtered.first?.1
        }
        return Pagination(
            first: page("first"),
            previous: page("prev"),
            next: page("next"),
            last: page("last")
        )
    }
    
}
