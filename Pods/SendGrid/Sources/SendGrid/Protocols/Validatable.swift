//
//  Validatable.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/8/17.
//
import Foundation

/// The `Validatable` protocol defines the functions that a class or struct
/// needs to implement in order to validate their own values. These are often
/// adopted by structs or classes that are used to configure a request to ensure
/// all the required information is correct and present.
public protocol Validatable {
    
    /// This method is implemented by all conforming classes to validate their
    /// own values. If everything is valid, the method does not need to return
    /// or do anything. If one or more values are invalid, an error should be
    /// thrown.
    func validate() throws
    
}
