//
//  Statistic.Global.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public extension Statistic {
    
    /// The `Statistic.Global` class is used to make the
    /// [Get Global Stats](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/global.html)
    /// API call. At minimum you need to specify a start date.
    ///
    /// ```swift
    /// do {
    ///     let now = Date()
    ///     let lastMonth = now.addingTimeInterval(-2592000) // 30 days
    ///     let request = Statistic.Global(
    ///         startDate: lastMonth,
    ///         endDate: now,
    ///         aggregatedBy: .week
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
    public class Global: Request<[Statistic]> {
        
        // MARK: - Properties
        //=========================================================================
        
        /// Indicates how the statistics should be grouped.
        public let aggregatedBy: Statistic.Aggregation?
        
        /// The starting date of the statistics to retrieve.
        public let startDate: Date
        
        /// The end date of the statistics to retrieve.
        public let endDate: Date?
        
        /// The format used for dates.
        internal let dateFormat: String
        
        /// The path for the endpoint.
        internal var path: String {
            return "/v3/stats"
        }
        
        /// The query items generated from the various properties.
        internal var queryItems: [URLQueryItem] {
            let formatter = DateFormatter()
            formatter.dateFormat = self.dateFormat
            var items: [(String, String)] = [
                ("start_date", formatter.string(from: self.startDate))
            ]
            if let e = self.endDate { items.append(("end_date", formatter.string(from: e))) }
            if let a = self.aggregatedBy { items.append(("aggregated_by", a.rawValue)) }
            return items.map { URLQueryItem(name: $0.0, value: $0.1) }
        }
        
        
        // MARK: - Initialization
        //=========================================================================
        
        /// Initializes the request with a start date, as well as an end date and/or
        /// aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:      The starting date of the statistics to retrieve.
        ///   - endDate:        The end date of the statistics to retrieve.
        ///   - aggregatedBy:   Indicates how the statistics should be grouped.
        public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil) {
            self.startDate = startDate
            self.endDate = endDate
            self.aggregatedBy = aggregatedBy
            let format = "yyyy-MM-dd"
            self.dateFormat = format
            let formatter = DateFormatter()
            formatter.dateFormat = format
            super.init(
                method: .GET,
                contentType: .formUrlEncoded,
                path: self.path,
                encoding: EncodingStrategy(dates: .formatted(formatter), data: .base64),
                decoding: DecodingStrategy(dates: .formatted(formatter), data: .base64)
            )
            self.endpoint?.queryItems = self.queryItems
        }
        
        
        // MARK: - Methods
        //=========================================================================
        
        /// Validates that the end date (if present) is not earlier than the start
        /// date.
        public override func validate() throws {
            try super.validate()
            if let e = self.endDate {
                guard self.startDate.timeIntervalSince(e) < 0 else {
                    throw Exception.Statistic.invalidEndDate
                }
            }
        }
    }
}
