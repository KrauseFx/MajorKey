//
//  Block.Get.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension Block {
    
    /// The `Block.Get` class represents the API call to [retrieve the block
    /// list](https://sendgrid.com/docs/API_Reference/Web_API_v3/blocks.html#List-all-blocks-GET).
    /// You can use it to retrieve the entire list, or specific entries in the 
    /// list.
    ///
    /// ## Get All Blocks
    /// 
    /// To retrieve the list of all blocks, use the `Block.Get` class with the 
    /// `init(start:end:page:)` initializer. The library will automatically map 
    /// the response to the `Block` struct model, accessible via the `model` 
    /// property on the response instance you get back.
    /// 
    /// ```swift
    /// do {
    ///     // If you don't specify any parameters, then the first page of your
    ///     // entire block list will be fetched:
    ///     let request = Block.Get()
    ///     try Session.shared.send(request: request) { (response) in
    ///         // The `model` property will be an array of `Block` structs.
    ///         response?.model?.forEach { print($0.email) }
    /// 
    ///         // The response object has a `Pagination` instance on it as well.
    ///         // You can use this to get the next page, if you wish.
    ///         //
    ///         // if let nextPage = response?.pages?.next {
    ///         //    let nextRequest = Block.Get(page: nextPage)
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
    ///     // Blocks starting from yesterday
    ///     let now = Date()
    ///     let start = now.addingTimeInterval(-86400) // 24 hours
    /// 
    ///     let request = Block.Get(start: start, end: now, page: page)
    ///     try Session.shared.send(request: request) { (response) in
    ///         // The `model` property will be an array of `Block` structs.
    ///         response?.model?.forEach { print($0.email) }
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    /// 
    /// ## Get Specific Block
    /// 
    /// If you're looking for a specific email address in the block list, you 
    /// can use the `init(email:)` initializer on `Block.Get`:
    /// 
    /// ```swift
    /// do {
    ///     let request = Block.Get(email: "foo@example.none")
    ///     try Session.shared.send(request: request) { (response) in
    ///         // The `model` property will be an array of `Block` structs.
    ///         response?.model?.forEach { (item) in
    ///           print("\(item.email) was blocked with reason \"\(item.reason)\"")
    ///         }
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    public class Get: SuppressionListReader<Block> {
        
        /// The path to the blocks API.
        override var path: String { return "/v3/suppression/blocks" }
        
    }
    
}
