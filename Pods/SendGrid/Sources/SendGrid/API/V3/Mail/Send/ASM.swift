//
//  ASM.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/15/17.
//

import Foundation

/// The `ASM` class is used to specify an unsubscribe group to associate the
/// email with.
public struct ASM: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The ID of the unsubscribe group to use.
    public let id: Int
    
    
    /// A list of IDs that should be shown on the "Manage Subscription" page for this email.
    public let groupsToDisplay: [Int]?
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the struct with a group ID and a list of group IDs to
    /// display on the manage subscription page for the email.
    ///
    /// - Parameters:
    ///   - groupID:            The ID of the unsubscribe group to use.
    ///   - groupsToDisplay:    An array of integers representing the IDs of
    ///                         other unsubscribe groups to display on the
    ///                         subscription page.
    public init(groupID: Int, groupsToDisplay: [Int]? = nil) {
        self.id = groupID
        self.groupsToDisplay = groupsToDisplay
    }
    
}

/// Encodable conformance.
extension ASM {
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case id                 = "group_id"
        case groupsToDisplay    = "groups_to_display"
    }
    
}

/// Validatable conformance.
extension ASM: Validatable {
    
    /// Validates that there are no more than 25 groups to display.
    public func validate() throws {
        if let display = self.groupsToDisplay {
            guard display.count <= Constants.UnsubscribeGroups.MaximumNumberOfDisplayGroups else {
                throw Exception.Mail.tooManyUnsubscribeGroups
            }
        }
    }
}
