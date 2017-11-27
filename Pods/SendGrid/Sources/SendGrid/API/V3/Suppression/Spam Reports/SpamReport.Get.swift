//
//  SpamReport.Get.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension SpamReport {
    
    /// The `SpamReport.Get` class represents the API call to [retrieve the
    /// spam reports list](https://sendgrid.com/docs/API_Reference/Web_API_v3/spam_reports.html#List-all-spam-reports-GET).
    /// You can use it to retrieve the entire list, or specific entries on the 
    /// list.
    ///
    /// ## Get All Spam Reports
    /// 
    /// To retrieve the list of all spam reports, use the `SpamReport.Get` class 
    /// with the `init(start:end:page:)` initializer. The library will 
    /// automatically map the response to the `SpamReport` struct model, 
    /// accessible via the `model` property on the response instance you get 
    /// back.
    /// 
    /// ```swift
    /// do {
    ///     // If you don't specify any parameters, then the first page of your 
    ///     // entire spam report list will be fetched:
    ///     let request = SpamReport.Get()
    ///     try Session.shared.send(request: request) { (response) in
    ///         // The `model` property will be an array of `SpamReport` structs.
    ///         response?.model?.forEach { print($0.email) }
    /// 
    ///         // The response object has a `Pagination` instance on it as well.
    ///         // You can use this to get the next page, if you wish.
    ///         //
    ///         // if let nextPage = response?.pages?.next {
    ///         //    let nextRequest = SpamReport.Get(page: nextPage)
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
    ///     // Spam Reports starting from yesterday
    ///     let now = Date()
    ///     let start = now.addingTimeInterval(-86400) // 24 hours
    /// 
    ///     let request = SpamReport.Get(start: start, end: now, page: page)
    ///     try Session.shared.send(request: request) { (response) in
    ///         // The `model` property will be an array of `SpamReport` 
    ///         // structs.
    ///         response?.model?.forEach { print($0.email) }
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    /// 
    /// ## Get Specific Spam Report
    /// 
    /// If you're looking for a specific email address in the spam report list, 
    /// you can use the `init(email:)` initializer on `SpamReport.Get`:
    /// 
    /// ```swift
    /// do {
    ///     let request = SpamReport.Get(email: "foo@example.none")
    ///     try Session.shared.send(request: request) { (response) in
    ///         // The `model` property will be an array of `SpamReport` 
    ///         // structs.
    ///         response?.model?.forEach { print($0.email) }
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    public class Get: SuppressionListReader<SpamReport> {
        
        /// The path to the spam reports API.
        override var path: String { return "/v3/suppression/spam_reports" }
        
    }
    
}
