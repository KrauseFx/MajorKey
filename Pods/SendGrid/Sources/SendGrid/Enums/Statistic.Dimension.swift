//
//  Statistic.Dimension.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public extension Statistic {
    
    /// The `Statistic.Dimension` enum represents the different ways the
    /// statistics can be sliced.
    ///
    /// - category: Represents statistics grouped by category.
    /// - subuser:  Represents statistics grouped by subuser.
    public enum Dimension: String, Decodable {
        
        /// Represents statistics grouped by category.
        case category
        
        /// Represents statistics grouped by subuser.
        case subuser
    }
    
}
