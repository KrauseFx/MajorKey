//
//  Exception+Statistic.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public extension Exception {
    
    /// The `Exception.Statistic` enum represents all the errors that can be thrown
    /// on the statistics calls.
    public enum Statistic: Error, CustomStringConvertible {
        
        /// Thrown if the end date is before the start date.
        case invalidEndDate
        
        /// Thrown if more than 10 categories are specified in the category
        /// stats call.
        case invalidNumberOfCategories
        
        /// Thrown if more than 10 subusers are specified in the subuser stats
        /// call.
        case invalidNumberOfSubusers
        
        /// A description of the error.
        public var description: String {
            switch self {
            case .invalidEndDate:
                return "The end date cannot be any earlier in time than the start date."
            case .invalidNumberOfCategories:
                return "Invalid number of categories specified. You must specify at least 1 category, and no more than 10."
            case .invalidNumberOfSubusers:
                return "Invalid number of subusers specified. You must specify at least 1 subuser, and no more than 10."
            }
        }
        
    }
    
}
