//
//  Statistic.Category.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public extension Statistic {
    
    /// The `Statistic.Category` class is used to make the
    /// [Get Category Stats](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/categories.html)
    /// API call. At minimum you need to specify a start date.
    /// 
    /// ```swift
    /// do {
    ///     let now = Date()
    ///     let lastMonth = now.addingTimeInterval(-2592000) // 30 days
    ///     let request = Statistic.Category(
    ///         startDate: lastMonth,
    ///         endDate: now,
    ///         aggregatedBy: .week,
    ///         categories: "Foo", "Bar"
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
    public class Category: Statistic.Global {
        
        // MARK: - Properties
        //======================================================================

        /// The categories to retrieve stats for.
        public let categories: [String]
        
        /// The path for the global unsubscribe endpoint.
        override internal var path: String { return "/v3/categories/stats" }
        
        /// The query parameters used in the request.
        override internal var queryItems: [URLQueryItem] {
            return super.queryItems + self.categories.map { URLQueryItem(name: "categories", value: $0) }
        }
        
        // MARK: - Initialization
        //======================================================================
        
        /// Initializes the request with a start date and categories, as well as
        /// an end date and/or aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:      The starting date of the statistics to retrieve.
        ///   - endDate:        The end date of the statistics to retrieve.
        ///   - aggregatedBy:   Indicates how the statistics should be grouped.
        ///   - categories:     An array of categories to retrieve stats for.
        public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, categories: [String]) {
            self.categories = categories
            super.init(startDate: startDate, endDate: endDate, aggregatedBy: aggregatedBy)
        }
        
        /// Initializes the request with a start date and categories, as well as
        /// an end date and/or aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:      The starting date of the statistics to retrieve.
        ///   - endDate:        The end date of the statistics to retrieve.
        ///   - aggregatedBy:   Indicates how the statistics should be grouped.
        ///   - categories:     An array of categories to retrieve stats for.
        public convenience init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, categories: String...) {
            self.init(startDate: startDate, endDate: endDate, aggregatedBy: aggregatedBy, categories: categories)
        }

        
        // MARK: - Methods
        //=========================================================================
        
        /// Validates that there are no more than 10 categories specified.
        public override func validate() throws {
            try super.validate()
            guard 1...10 ~= self.categories.count else {
                throw Exception.Statistic.invalidNumberOfCategories
            }
        }
        
    }
    
}
