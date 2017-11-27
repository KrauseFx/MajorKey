//
//  Metric.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public extension Statistic {
    
    /// The `Statistic.Metric` struct represents the raw statistics for a given
    /// time period.
    public struct Metric: Decodable {
        
        // MARK: - Properties
        //======================================================================
        
        /// The number of block events for the given period.
        public let blocks: Int
        
        /// The number of emails dropped due to the address being on the bounce
        /// list for the given period.
        public let bounceDrops: Int
        
        /// The number of bounce events for the given period.
        public let bounces: Int
        
        /// The number of click events for the given period.
        public let clicks: Int
        
        /// The number of deferred events for the given period.
        public let deferred: Int
        
        /// The number of delivered events for the given period.
        public let delivered: Int
        
        /// The number of invalid email events for the given period.
        public let invalidEmails: Int
        
        /// The number of open events for the given period.
        public let opens: Int
        
        /// The number of processed events for the given period.
        public let processed: Int
        
        /// The number of requests for the given period.
        public let requests: Int
        
        /// The number of emails dropped due to the address being on the spam
        /// report list for the given period.
        public let spamReportDrops: Int
        
        /// The number of spam report events for the given period.
        public let spamReports: Int
        
        /// The number of unique click events for the given period.
        public let uniqueClicks: Int
        
        /// The number of unique open events for the given period.
        public let uniqueOpens: Int
        
        /// The number of emails dropped due to the address being on the
        /// unsubscribe list for the given period.
        public let unsubscribeDrops: Int
        
        /// The number of unsubscribe events for the given period.
        public let unsubscribes: Int
        
    }
    
}

/// Decodable conformance.
public extension Statistic.Metric {
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case blocks
        case bounceDrops        = "bounce_drops"
        case bounces
        case clicks
        case deferred
        case delivered
        case invalidEmails      = "invalid_emails"
        case opens
        case processed
        case requests
        case spamReportDrops    = "spam_report_drops"
        case spamReports        = "spam_reports"
        case uniqueClicks       = "unique_clicks"
        case uniqueOpens        = "unique_opens"
        case unsubscribeDrops   = "unsubscribe_drops"
        case unsubscribes
    }
    
}
