//
//  Exception+Mail.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/13/17.
//

import Foundation

public extension Exception {
    
    /// The `Exception.Mail` enum contains all the errors thrown for the mail
    /// send API.
    public enum Mail: Error, CustomStringConvertible {
        
        // MARK: - Cases
        //======================================================================
        
        /// The error thrown when an email address was expected, but received a
        /// String that isn't RFC 5322 compliant.
        case malformedEmailAddress(String)
        
        /// The error thrown when an email is scheduled further than 72 hours
        /// out.
        case invalidScheduleDate
        
        /// The error thrown if the subscription tracking setting is configured
        /// with text that doesn't contain a `<% %>` tag.
        case missingSubscriptionTrackingTag
        
        /// The error thrown if a personalization doesn't have at least 1
        /// recipient.
        case missingRecipients
        
        /// The error thrown when the SpamChecker setting is provided a
        /// threshold outside the 1-10 range.
        case thresholdOutOfRange(Int)
        
        /// The error thrown when more than 25 unsubscribe groups are provided
        /// in the `ASM` struct.
        case tooManyUnsubscribeGroups
        
        /// The error thrown if the number of personalizations in an email is
        /// less than 1 or more than 100.
        case invalidNumberOfPersonalizations
        
        /// The error thrown if an email doesn't contain any content.
        case missingContent
        
        /// The error thrown if a `Content` instance has an empty string value.
        case contentHasEmptyString
        
        /// Thrown if the array of `Content` instances used in an `Email`
        /// instances is in an incorrect order.
        case invalidContentOrder
        
        /// Thrown when an email contains too many recipients across all the
        /// `to`, `cc`, and `bcc` properties of the personalizations.
        case tooManyRecipients
        
        /// Thrown if an email does not contain a subject line.
        case missingSubject
        
        /// Thrown if a reserved header was specified in the custom headers
        /// section.
        case headerNotAllowed(String)
        
        /// Thrown if a header's name contains spaces.
        case malformedHeader(String)
        
        /// Thrown if there are more than 10 categories in an email.
        case tooManyCategories
        
        /// Thrown if a category name exceeds 255 characters.
        case categoryTooLong(String)
        
        /// Thrown when there are too many substitutions.
        case tooManySubstitutions
        
        /// Thrown when an email address is listed multiple times in an email.
        case duplicateRecipient(String)
        
        /// Thrown when the number of custom arguments exceeds 10,000 bytes.
        case tooManyCustomArguments(Int, String?)
        
        /// Thrown when an attachment's content ID contains invalid characters.
        case invalidContentID(String)
        
        /// Thrown when an attachment's filename contains invalid characters.
        case invalidFilename(String)
        
        /// Thrown when a category has been specified more than once.
        case duplicateCategory(String)
        
        
        // MARK: - Properties
        //=====================================================================
        
        /// A description for the error.
        public var description: String {
            switch self {
            case .malformedEmailAddress(let str):
                return "\"\(str)\" is not a valid email address. Please provide an RFC 5322 compliant email address."
            case .invalidScheduleDate:
                return "An email cannot be scheduled further than 72 hours in the future."
            case .missingSubscriptionTrackingTag:
                return "When specifying plain text and HTML text for the subscription tracking setting, you must include the `<% %>` tag to indicate where the unsubscribe URL should be placed."
            case .missingRecipients:
                return "At least one recipient is required for a personalization."
            case .thresholdOutOfRange(let i):
                return "The spam checker app only accepts a threshold which is between 1 and 10 (attempted to use \(i))"
            case .tooManyUnsubscribeGroups:
                return "The `ASM` struct can have no more than 25 unsubscribe groups to display."
            case .invalidNumberOfPersonalizations:
                return "An `Email` must contain at least 1 personalization and cannot exceed \(Constants.PersonalizationLimit) personalizations."
            case .missingContent:
                return "An `Email` must contain at least 1 `Content` instance."
            case .contentHasEmptyString:
                return "The `value` property on `Content` must be a string at least one character in length."
            case .invalidContentOrder:
                return "When specifying the content of an email, the plain text version must be first (if present), followed by the HTML version (if present), and then any other content."
            case .tooManyRecipients:
                return "Your `Email` instance contains too many recipients. The total number of recipients cannot exceed \(Constants.RecipientLimit) addresses. This includes all recipients defined within the `to`, `cc`, and `bcc` parameters, across each `Personalization` instance that you include in the personalizations array."
            case .missingSubject:
                return "An `Email` instance must contain a subject line for every personalization, and the subject line must contain at least 1 character. You can either define a global subject on the `Email` instance, add a subject line in every `Personalization` instance, or specify a template ID that contains a subject."
            case .headerNotAllowed(let str):
                return "The \"\(str)\" header is a reserved header, and cannot be used in the `headers` property."
            case .malformedHeader(let str):
                return "Invalid header \"\(str)\": When defining the headers that you would like to use, you must make sure that the header's name contains only ASCII characters and no spaces."
            case .tooManyCategories:
                return "You cannot have more than \(Constants.Categories.TotalLimit) categories associated with an email."
            case .categoryTooLong(let str):
                return "A category cannot have more than \(Constants.Categories.CharacterLimit) characters (attempted to use category named \"\(str)\")."
            case .tooManySubstitutions:
                return "You cannot have more than \(Constants.SubstitutionLimit) substitutions in a personalization."
            case .duplicateRecipient(let str):
                return "Each unique email address in the `personalizations` array should only be included once. You have included \"\(str)\" more than once."
            case .tooManyCustomArguments(let amount, let args):
                var error = "Each personalized email cannot have custom arguments exceeding \(Constants.CustomArguments.MaximumBytes) bytes. The email you're attempting to send has \(amount) bytes.  "
                if let a = args {
                    error += "The offending custom args are below:\n\n    \(a)"
                }
                return error
            case .invalidContentID(let str):
                return "Invalid content ID \"\(str)\" for attachment: Content IDs cannot contain ‘;’, spaces, or CRLF characters, and must be at least 1 character long."
            case .invalidFilename(let str):
                return "Invalid filename \"\(str)\" for attachment: Filenames cannot contain ‘;’, spaces, or CRLF characters, and must be at least 1 character long."
            case .duplicateCategory(let cat):
                return "You cannot specify the category '\(cat)' more than once."
            }
        }
    }
}
