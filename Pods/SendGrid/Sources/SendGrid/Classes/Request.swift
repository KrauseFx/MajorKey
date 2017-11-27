//
//  Request.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/8/17.
//
import Foundation

/// The `Request` class should be inherited by any class that represents an API
/// request and sent through the `send` function in `Session`.
///
/// This class contains a `ModelType` generic, which is used to map the API
/// response to a specific model that conforms to `Codable`.
open class Request<ModelType : Decodable>: Validatable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// A `Bool` indicating if the request supports the "On-behalf-of" header.
    open var supportsImpersonation: Bool { return true }
    
    /// The HTTP verb to use in the call.
    open var method: HTTPMethod
    
    /// The Content-Type of the call.
    open var contentType: ContentType
    
    /// The Accept header value.
    open var acceptType: ContentType = .json
    
    /// The decoding strategy.
    open var decodingStrategy: DecodingStrategy
    
    /// The encoding strategy.
    open var encodingStrategy: EncodingStrategy
    
    /// The full URL endpoint for the API call.
    open var endpoint: URLComponents?
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the request.
    ///
    /// - Parameters:
    ///   - method:     The HTTP verb to use in the API call.
    ///   - parameters: Any parameters to send with the API call.
    ///   - path:       The path portion of the API endpoint, such as
    ///                 "/v3/mail/send". The path *must* start with a forward
    ///                 slash (`/`).
    public init(method: HTTPMethod, contentType: ContentType, path: String?, encoding: EncodingStrategy = EncodingStrategy(), decoding: DecodingStrategy = DecodingStrategy()) {
        self.method = method
        self.contentType = contentType
        var components = URLComponents(string: Constants.ApiHost)
        if let p = path { components?.path = p }
        self.endpoint = components
        self.encodingStrategy = encoding
        self.decodingStrategy = decoding
    }
    
    
    // MARK: - Methods
    //=========================================================================
    /// Generates a `URLRequest` representation of the request.
    ///
    /// - Returns:  A `URLRequest` instance.
    /// - Throws:   Errors can be thrown if there was a problem encoding the
    ///             parameters or constructing the API URL endpoint.
    open func generateUrlRequest() throws -> URLRequest {
        guard let url = self.endpoint?.url else {
            throw Exception.Request.couldNotConstructUrlRequest
        }
        var req = URLRequest(url: url)
        req.httpMethod = self.method.rawValue
        req.addValue(self.contentType.description, forHTTPHeaderField: "Content-Type")
        req.addValue(self.acceptType.description, forHTTPHeaderField: "Accept")
        if self.method.hasBody, let enc = self as? AutoEncodable {
            req.httpBody = enc.encode()
        }
        return req
    }
    
    /// Validates that the content and accept types are valid.
    public func validate() throws {
        try self.contentType.validate()
        try self.acceptType.validate()
    }
    
    /// Before a `Session` instance makes an API call, it will call this method
    /// to double check that the auth method it's about to use is supported by
    /// the endpoint. In general, this will always return `true`, however some
    /// endpoints, such as the mail send endpoint, only support API keys.
    ///
    /// - Parameter auth:   The `Authentication` instance that's about to be
    ///                     used.
    /// - Returns:          A `Bool` indicating if the authentication method is
    ///                     supported.
    public func supports(auth: Authentication) -> Bool {
        return true
    }
    
}

/// CustomStringConvertible conformance
extension Request: CustomStringConvertible {
    
    /// The description of the request, represented as an [API
    /// Blueprint](https://apiblueprint.org/)
    public var description: String {
        let path = self.endpoint?.path ?? ""
        var query: String {
            guard let q = self.endpoint?.query else { return "" }
            return "?\(q)"
        }
        var blueprint = """
        # \(self.method) \(path + query)
        
        + Request (\(self.contentType))
        
            + Headers
        
                    Accept: \(self.acceptType)
        
        """
        if self.method.hasBody,
            let encodable = self as? AutoEncodable,
            let bodyData = encodable.encode(formatting: [.prettyPrinted]),
            let bodyString = String(data: bodyData, encoding: .utf8)
        {
            let indented = bodyString.split(separator: "\n").map { "            \($0)" }
            blueprint += """
            
                + Body
            
            \(indented.joined(separator: "\n"))
            """
        }
        return blueprint
    }
    
}

