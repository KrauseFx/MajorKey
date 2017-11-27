//
//  Statistic.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation


/// The `Statistic` struct represents the enclosing structure of statistics
/// returning from the various stat API calls. It contains the
/// date of the aggregated time period, along with the raw stats.
public struct Statistic: Decodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The date for this statistic set.
    public let date: Date
    
    /// The individual stat samples that make up this collection.
    public let stats: [Statistic.Sample]
    
}
