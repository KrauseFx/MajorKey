//
//  Statistic.Sample.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public extension Statistic {
    
    /// The `Statistic.Sample` struct represents a single group of statistics,
    /// with the raw stats being made available via the `metrics` property.
    public struct Sample: Decodable {
        
        /// The raw metrics for each email event type.
        public let metrics: Statistic.Metric
        
        /// The name of the sample, if applicable. For instance, if these are
        /// category stats, then this property will have the name of the
        /// category.
        public let name: String?
        
        /// The dimension type these stats have been grouped by.
        public let type: Statistic.Dimension?
        
    }
    
}
