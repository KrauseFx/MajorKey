//
//  Response.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/12/17.
//

import Foundation

/// The `Response` class is a wrapper used after an API call is made. It
/// includes all the raw data, but also attempts to parse it into the
/// appropriate models.
open class Response<ModelType : Decodable> {
    
    // MARK: - Read Only Properties
    //=========================================================================
    
    /// The data (if present) returned from the request.
    public let data: Data?
    
    /// The URLResponse returned from the request.
    public let urlResponse: URLResponse?
    
    /// The URL response as an HTTPURLResponse (if applicable).
    public var httpUrlResponse: HTTPURLResponse? {
        return self.urlResponse as? HTTPURLResponse
    }
    
    /// The error that arose during the request (if applicable).
    public let error: Error?
    
    /// The record(s) returned from the response.
    public let model: ModelType?
    
    /// If the response contained the total number of records, you can access it here.
    public let count: Int?
    
    /// The rate limit information extracted from the response.
    public let rateLimit: RateLimit?
    
    /// The pagination info from the response, if specified.
    public let pages: Pagination?
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the class with the data returned from an HTTP request. The
    /// class then parses the data to try and create models from the response.
    ///
    /// - Parameters:
    ///   - data:                   The data (if present) returned from the
    ///                             request.
    ///   - response:               The URLResponse returned from the request.
    ///   - error:                  The error that arose during the request (if
    ///                             applicable).
    ///   - decodingStrategy:       The strategy for decoding dates and data.
    public init(data: Data?, response: URLResponse?, error: Error?, decodingStrategy: DecodingStrategy) {
        self.data = data
        self.urlResponse = response
        self.error = error
        self.rateLimit = RateLimit.from(response: response)
        self.pages = Pagination.from(response: response)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = decodingStrategy.dates
        decoder.dataDecodingStrategy = decodingStrategy.data
        if let d = data,
            let parsed = try? decoder.decode(ModelType.self, from: d)
        {
            self.model = parsed
            self.count = nil
        } else {
            self.model = nil
            self.count = nil
        }
    }
    
}
