//
//  Statistic.Subuser.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/22/17.
//

import Foundation

public extension Statistic {
    
    /// The `Statistic.Subuser` class is used to make the
    /// [Get Subuser Stats](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/subusers.html)
    /// API call. At minimum you need to specify a start date.
    ///
    /// ```swift
    /// do {
    ///     let now = Date()
    ///     let lastMonth = now.addingTimeInterval(-2592000) // 30 days
    ///     let request = Statistic.Subuser(
    ///         startDate: lastMonth,
    ///         endDate: now,
    ///         aggregatedBy: .week,
    ///         subusers: "Foo", "Bar"
    ///     )
    ///     try Session.shared.send(request: request) { (response) in
    ///         // The `model` property will be an array of `Statistic` structs.
    ///         response?.model?.forEach{ (stat) in
    ///             // Do something with the stats here...
    ///         }
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    public class Subuser: Statistic.Global {
        
        // MARK: - Properties
        //======================================================================
        
        /// The subusers to retrieve stats for.
        public let subusers: [String]
        
        /// The path for the global unsubscribe endpoint.
        override internal var path: String { return "/v3/subusers/stats" }
        
        /// The query parameters used in the request.
        override internal var queryItems: [URLQueryItem] {
            return super.queryItems + self.subusers.map { URLQueryItem(name: "subusers", value: $0) }
        }
        
        // MARK: - Initialization
        //======================================================================
        
        /// Initializes the request with a start date and subusers, as well as
        /// an end date and/or aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:      The starting date of the statistics to retrieve.
        ///   - endDate:        The end date of the statistics to retrieve.
        ///   - aggregatedBy:   Indicates how the statistics should be grouped.
        ///   - subusers:       An array of subuser usernames to retrieve stats
        ///                     for (max 10).
        public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, subusers: [String]) {
            self.subusers = subusers
            super.init(startDate: startDate, endDate: endDate, aggregatedBy: aggregatedBy)
        }
        
        /// Initializes the request with a start date and subusers, as well as
        /// an end date and/or aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:      The starting date of the statistics to retrieve.
        ///   - endDate:        The end date of the statistics to retrieve.
        ///   - aggregatedBy:   Indicates how the statistics should be grouped.
        ///   - subusers:       An array of subuser usernames to retrieve stats
        ///                     for (max 10).
        public convenience init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, subusers: String...) {
            self.init(startDate: startDate, endDate: endDate, aggregatedBy: aggregatedBy, subusers: subusers)
        }
        
        /// Initializes the request with a start date and subusers, as well as
        /// an end date and/or aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:      The starting date of the statistics to retrieve.
        ///   - endDate:        The end date of the statistics to retrieve.
        ///   - aggregatedBy:   Indicates how the statistics should be grouped.
        ///   - subusers:       An array of `Subuser` instances to retrieve
        ///                     stats for (max 10).
        public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, subusers: [SendGrid.Subuser]) {
            self.subusers = subusers.map { $0.username }
            super.init(startDate: startDate, endDate: endDate, aggregatedBy: aggregatedBy)
        }
        
        /// Initializes the request with a start date and subusers, as well as
        /// an end date and/or aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:      The starting date of the statistics to retrieve.
        ///   - endDate:        The end date of the statistics to retrieve.
        ///   - aggregatedBy:   Indicates how the statistics should be grouped.
        ///   - subusers:       An array of `Subuser` instances to retrieve
        ///                     stats for (max 10).
        public convenience init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, subusers: SendGrid.Subuser...) {
            self.init(startDate: startDate, endDate: endDate, aggregatedBy: aggregatedBy, subusers: subusers)
        }
        
        
        // MARK: - Methods
        //=========================================================================
        
        /// Validates that there are no more than 10 subusers specified.
        public override func validate() throws {
            try super.validate()
            guard 1...10 ~= self.subusers.count else {
                throw Exception.Statistic.invalidNumberOfSubusers
            }
        }
        
    }
    
}
