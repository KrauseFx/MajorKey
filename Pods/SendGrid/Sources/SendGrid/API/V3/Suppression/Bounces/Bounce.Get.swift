//
//  Bounce.Get.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension Bounce {
    
    /// The `Bounce.Get` class represents the API call to [retrieve the bounce
    /// list](https://sendgrid.com/docs/API_Reference/Web_API_v3/bounces.html#List-all-bounces-GET).
    /// You can use it to retrieve the entire list, or specific entries in the
    /// list.
    ///
    /// ## Get All Bounces
    /// 
    /// To retrieve the list of all bounces, use the `Bounce.Get` class with the 
    /// `init(start:end:page:)` initializer. The library will automatically map 
    /// the response to the `Bounce` struct model, accessible via the `model` 
    /// property on the response instance you get back.
    /// 
    /// ```swift
    /// do {
    ///     // If you don't specify any parameters, then the first page of your entire
    ///     // bounce list will be fetched:
    ///     let request = Bounce.Get()
    ///     try Session.shared.send(request: request) { (response) in
    ///         // The `model` property will be an array of `Bounce` structs.
    ///         response?.model?.forEach { print($0.email) }
    /// 
    ///         // The response object has a `Pagination` instance on it as well.
    ///         // You can use this to get the next page, if you wish.
    ///         //
    ///         // if let nextPage = response?.pages?.next {
    ///         //    let nextRequest = Bounce.Get(page: nextPage)
    ///         // }
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    /// 
    /// You can also specify any or all of the init parameters to filter your 
    /// search down:
    /// 
    /// ```swift
    /// do {
    ///     // Retrieve page 2
    ///     let page = Page(limit: 500, offset: 500)
    ///     // Bounces starting from yesterday
    ///     let now = Date()
    ///     let start = now.addingTimeInterval(-86400) // 24 hours
    /// 
    ///     let request = Bounce.Get(start: start, end: now, page: page)
    ///     try Session.shared.send(request: request) { (response) in
    ///         // The `model` property will be an array of `Bounce` structs.
    ///         response?.model?.forEach { print($0.email) }
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    /// 
    /// ## Get Specific Bounce
    /// 
    /// If you're looking for a specific email address in the bounce list, you 
    /// can use the `init(email:)` initializer on `Bounce.Get`:
    /// 
    /// ```swift
    /// do {
    ///     let request = Bounce.Get(email: "foo@example.none")
    ///     try Session.shared.send(request: request) { (response) in
    ///         // The `model` property will be an array of `Bounce` structs.
    ///         if let match = response?.model?.first {
    ///           print("\(match.email) bounced with reason \"\(match.reason)\"")
    ///         }
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    public class Get: SuppressionListReader<Bounce> {
        
        /// The path for the bounces API endpoint.
        override var path: String { return "/v3/suppression/bounces" }
        
    }
    
}
