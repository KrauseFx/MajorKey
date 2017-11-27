//
//  InvalidEmail.Get.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension InvalidEmail {
    
    /// The `InvalidEmail.Get` class represents the API call to [retrieve the
    /// invalid email list](https://sendgrid.com/docs/API_Reference/Web_API_v3/invalid_emails.html#List-all-invalid-emails-GET).
    /// You can use it to retrieve the entire list, or specific entries from the 
    /// list.
    /// 
    /// ## Get All Invalid Emails
    /// 
    /// To retrieve the list of all invalid emails, use the `InvalidEmail.Get` 
    /// class with the `init(start:end:page:)` initializer. The library will 
    /// automatically map the response to the `InvalidEmail` struct model, 
    /// accessible via the `model` property on the response instance you get 
    /// back.
    /// 
    /// ```swift
    /// do {
    ///     // If you don't specify any parameters, then the first page of your 
    ///     // entire invalid email list will be fetched:
    ///     let request = InvalidEmail.Get()
    ///     try Session.shared.send(request: request) { (response) in
    ///         // The `model` property will be an array of `InvalidEmail` 
    ///         // structs.
    ///         response?.model?.forEach { print($0.email) }
    /// 
    ///         // The response object has a `Pagination` instance on it as
    ///         // well. You can use this to get the next page, if you wish.
    ///         //
    ///         // if let nextPage = response?.pages?.next {
    ///         //    let nextRequest = InvalidEmail.Get(page: nextPage)
    ///         // }
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    /// 
    /// You can also specify any or all of the init parameters to filter your search down:
    /// 
    /// ```swift
    /// do {
    ///     // Retrieve page 2
    ///     let page = Page(limit: 500, offset: 500)
    ///     // Invalid emails starting from yesterday
    ///     let now = Date()
    ///     let start = now.addingTimeInterval(-86400) // 24 hours
    /// 
    ///     let request = InvalidEmail.Get(start: start, end: now, page: page)
    ///     try Session.shared.send(request: request) { (response) in
    ///         response?.model?.forEach { print($0.email) }
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    /// 
    /// ## Get Specific Invalid Email
    /// 
    /// If you're looking for a specific email address in the invalid email list, you can use the `init(email:)` initializer on `InvalidEmail.Get`:
    /// 
    /// ```swift
    /// do {
    ///     let request = InvalidEmail.Get(email: "foo@example")
    ///     try Session.shared.send(request: request) { (response) in
    ///         response?.model?.forEach { print($0.email) }
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    public class Get: SuppressionListReader<InvalidEmail> {
        
        /// The path to the spam reports API.
        override var path: String { return "/v3/suppression/invalid_emails" }
        
    }
    
}
