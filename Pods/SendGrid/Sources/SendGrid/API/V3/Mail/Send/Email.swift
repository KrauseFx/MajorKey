//
//  Email.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/17/17.
//

import Foundation

/// The `Email` class is used to make the Mail Send API call. The class allows
/// you to configure many different aspects of the email.
/// 
/// ## Content
/// 
/// To specify the content of an email, use the `Content` class. In general, an 
/// email will have plain text and/or HTML text content, however you can specify 
/// other types of content, such as an ICS calendar invite. Following RFC 1341, 
/// section 7.2, if either HTML or plain text content are to be sent in your 
/// email: the plain text content needs to be first, followed by the HTML 
/// content, followed by any other content.
/// 
/// ## Personalizations
/// 
/// The new V3 endpoint introduces the idea of "personalizations."  When using 
/// the API, you define a set of global characteristics for the email, and then 
/// also define seperate personalizations, which contain recipient-specific 
/// information for the email. Since personalizations contain the recipients of 
/// the email, each request must contain at least 1 personalization.
/// 
/// ```swift
/// // Send a basic example
/// let personalization = Personalization(recipients: "test@example.com")
/// let plainText = Content(contentType: ContentType.plainText, value: "Hello World")
/// let htmlText = Content(contentType: ContentType.htmlText, value: "<h1>Hello World</h1>")
/// let email = Email(
///     personalizations: [personalization],
///     from: Address(email: "foo@bar.com"),
///     content: [plainText, htmlText],
///     subject: "Hello World"
/// )
/// do {
///     try Session.shared.send(request: email)
/// } catch {
///     print(error)
/// }
/// ```
/// 
/// An `Email` instance can have up to 1000 `Personalization` instances. A 
/// `Personalization` can be thought of an individual email.  It can contain 
/// several `to` addresses, along with `cc` and `bcc` addresses.  Keep in mind 
/// that if you put two addresses in a single `Personalization` instance, each 
/// recipient will be able to see each other's email address.  If you want to 
/// send to several recipients where each recipient only sees their own address, 
/// you'll want to create a seperate `Personalization` instance for each 
/// recipient.
/// 
/// The `Personalization` class also allows personalizing certain email 
/// attributes, including:
/// 
/// - Subject
/// - Headers
/// - Substitution tags
/// - [Custom arguments](https://sendgrid.com/docs/API_Reference/SMTP_API/unique_arguments.html)
/// - Scheduled sends
/// 
/// If a `Personalization` instance contains an email attribute that is also 
/// defined globally in the request (such as the subject), the `Personalization` 
/// instance's value takes priority.
/// 
/// Here is an advanced example of using personalizations:
/// 
/// ```swift
/// // Send an advanced example
/// let recipients = [
///     Address(email: "jose@example.none", name: "Jose"),
///     Address(email: "isaac@example.none", name: "Isaac"),
///     Address(email: "tim@example.none", name: "Tim")
/// ]
/// let personalizations = recipients.map { (recipient) -> Personalization in
///     let name = recipient.name ?? "there"
///     return Personalization(
///         to: [recipient],
///         cc: nil,
///         bcc: [Address(email: "bcc@example.none")],
///         subject: "Hello \(name)!",
///         headers: ["X-Campaign":"12345"],
///         substitutions: ["%name%":name],
///         customArguments: ["campaign_id":"12345"]
///     )
/// }
/// let contents = Content.emailBody(
///     plain: "Hello %name%,\n\nHow are you?\n\nBest,\nSender",
///     html: "<p>Hello %name%,</p><p>How are you?</p><p>Best,<br>Sender</p>"
/// )
/// let email = Email(
///     personalizations: personalizations,
///     from: Address(email: "sender@example.none"),
///     content: contents,
///     subject: nil
/// )
/// email.headers = [
///     "X-Campaign": "12345"
/// ]
/// email.customArguments = [
///     "campaign_id": "12345"
/// ]
/// do {
///     try Session.shared.send(request: email) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
/// 
/// You'll notice in the example above, the global email defines custom headers 
/// and custom arguments. In addition, each personalization defines some headers 
/// and custom arguments. For the resulting email, the headers and custom 
/// arguments will be merged together. In the event of a conflict, the 
/// personalization's values will be used.
/// 
/// ## Attachments
/// 
/// The `Attachment` class allows you to easily add attachments to an email. All 
/// you need is to convert your desired attachment into `NSData` and initialize 
/// it like so:
/// 
/// ```swift
/// let personalization = Personalization(recipients: "test@example.com")
/// let contents = Content.emailBody(
///     plain: "Hello World",
///     html: "<h1>Hello World</h1>"
/// )
/// let email = Email(
///     personalizations: [personalization],
///     from: Address(email: "foo@bar.com"),
///     content: contents,
///     subject: "Hello World"
/// )
/// do {
///     if let path = Bundle.main.url(forResource: "proposal", withExtension: "pdf") {
///         let attachment = Attachment(
///             filename: "proposal.pdf",
///             content: try Data(contentsOf: path),
///             disposition: .attachment,
///             type: .pdf,
///             contentID: nil
///         )
///         email.attachments = [attachment]
///     }
///     try Session.shared.send(request: email) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
/// 
/// You can also use attachments as inline images by setting the `disposition` 
/// property to `.Inline` and setting the `cid` property.  You can then 
/// reference that unique CID in your HTML like so:
/// 
/// ```swift
/// let personalization = Personalization(recipients: "test@example.com")
/// let contents = Content.emailBody(
///     plain: "Hello World",
///     html: "<img src=\"cid:main_logo_12345\" /><h1>Hello World</h1>"
/// )
/// let email = Email(
///     personalizations: [personalization],
///     from: Address(email: "foo@bar.com"),
///     content: contents,
///     subject: "Hello World"
/// )
/// do {
///     let filename = NSImage.Name("logo.png")
///     if let path = Bundle.main.urlForImageResource(filename) {
///         let attachment = Attachment(
///             filename: "logo.png",
///             content: try Data(contentsOf: path),
///             disposition: .inline,
///             type: .png,
///             contentID: "main_logo_12345"
///         )
///         email.attachments = [attachment]
///     }
///     try Session.shared.send(request: email) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
/// 
/// ## Mail and Tracking Settings
/// 
/// There are various classes available that you can use to modify the 
/// [mail](https://sendgrid.com/docs/User_Guide/Settings/mail.html) and 
/// [tracking](https://sendgrid.com/docs/User_Guide/Settings/tracking.html) 
/// settings for a specific email.
/// 
/// **MAIL SETTINGS**
/// 
/// The following mail setting classes are available:
/// 
/// - `BCCSetting` - This allows you to have a blind carbon copy automatically 
/// sent to the specified email address for every email that is sent.
/// - `BypassListManagement` - Allows you to bypass all unsubscribe groups and 
/// suppressions to ensure that the email is delivered to every single 
/// recipient. This should only be used in emergencies when it is absolutely 
/// necessary that every recipient receives your email. Ex: outage emails, or 
/// forgot password emails.
/// - `Footer` - The default footer that you would like appended to the bottom 
/// of every email.
/// - `SandboxMode` - This allows you to send a test email to ensure that your 
/// request body is valid and formatted correctly. For more information, please 
/// see the [Classroom](https://sendgrid.com/docs/Classroom/Send/v3_Mail_Send/sandbox_mode.html).
/// - `SpamChecker` -  This allows you to test the content of your email for 
/// spam.
/// 
/// **TRACKING SETTINGS**
/// 
/// The following tracking setting classes are available:
/// 
/// - `ClickTracking` - Allows you to track whether a recipient clicked a link 
/// in your email.
/// - `GoogleAnalytics` - Allows you to enable tracking provided by Google 
/// Analytics.
/// - `OpenTracking` - Allows you to track whether the email was opened or not, 
/// but including a single pixel image in the body of the content. When the 
/// pixel is loaded, we can log that the email was opened.
/// - `SubscriptionTracking` - Allows you to insert a subscription management 
/// link at the bottom of the text and html bodies of your email. If you would 
/// like to specify the location of the link within your email, you may specify 
/// a substitution tag.
/// 
/// **EXAMPLE**
/// 
/// Each setting has its own properties that can be configured, but here's a 
/// basic example:
/// 
/// ```swift
/// let personalization = Personalization(recipients: "test@example.com")
/// let contents = Content.emailBody(
///     plain: "Hello World",
///     html: "<h1>Hello World</h1>"
/// )
/// let email = Email(
///     personalizations: [personalization],
///     from: Address(email: "foo@bar.com"),
///     content: contents,
///     subject: "Hello World"
/// )
/// email.mailSettings.footer = Footer(
///     text: "Copyright 2016 MyCompany",
///     html: "<p><small>Copyright 2016 MyCompany</small></p>"
/// )
/// email.trackingSettings.clickTracking = ClickTracking(section: .htmlBody)
/// email.trackingSettings.openTracking = OpenTracking(location: .off)
/// do {
///     try Session.shared.send(request: email) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
/// 
/// ## Unsubscribe Groups (ASM)
/// 
/// If you use SendGrid's 
/// [unsubscribe groups](https://sendgrid.com/docs/User_Guide/Suppressions/advanced_suppression_manager.html) 
/// feature, you can specify which unsubscribe group to send an email under like 
/// so:
/// 
/// ```swift
/// let personalization = Personalization(recipients: "test@example.com")
/// let contents = Content.emailBody(
///     plain: "Hello World",
///     html: "<h1>Hello World</h1>"
/// )
/// let email = Email(
///     personalizations: [personalization],
///     from: Address(email: "foo@bar.com"),
///     content: contents,
///     subject: "Hello World"
/// )
/// /// Assuming your unsubscribe group has an ID of 4815…
/// email.asm = ASM(groupID: 4815)
/// do {
///     try Session.shared.send(request: email) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
/// 
/// You can also specify which unsubscribe groups should be shown on the 
/// subscription management page for this email:
/// 
/// ```swift
/// let personalization = Personalization(recipients: "test@example.com")
/// let contents = Content.emailBody(
///     plain: "Hello World",
///     html: "<h1>Hello World</h1>"
/// )
/// let email = Email(
///     personalizations: [personalization],
///     from: Address(email: "foo@bar.com"),
///     content: contents,
///     subject: "Hello World"
/// )
/// /// Assuming your unsubscribe group has an ID of 4815…
/// email.asm = ASM(groupID: 4815, groupsToDisplay: [16,23,42])
/// do {
///     try Session.shared.send(request: email) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
/// 
/// ## IP Pools
/// 
/// If you're on a pro plan or higher, and have set up 
/// [IP Pools](https://sendgrid.com/docs/API_Reference/Web_API_v3/IP_Management/ip_pools.html) 
/// on your account, you can specify a specific pool to send an email over like 
/// so:
/// 
/// ```swift
/// let personalization = Personalization(recipients: "test@example.com")
/// let contents = Content.emailBody(
///     plain: "Hello World",
///     html: "<h1>Hello World</h1>"
/// )
/// let email = Email(
///     personalizations: [personalization],
///     from: Address(email: "foo@bar.com"),
///     content: contents,
///     subject: "Hello World"
/// )
/// /// Assuming you have an IP pool called "transactional" on your account…
/// email.ipPoolName = "transactional"
/// do {
///     try Session.shared.send(request: email) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
/// 
/// ## Scheduled Sends
/// 
/// If you don't want the email to be sent right away, but rather at some point 
/// in the future, you can use the `sendAt` property. **NOTE**: You cannot 
/// schedule an email further than 72 hours in the future.  You can also assign 
/// an optional, unique `batchID` to the email so that you can 
/// [cancel via the API](https://sendgrid.com/docs/API_Reference/Web_API_v3/cancel_schedule_send.html) 
/// in the future if needed.
/// 
/// ```swift
/// let personalization = Personalization(recipients: "test@example.com")
/// let contents = Content.emailBody(
///     plain: "Hello World",
///     html: "<h1>Hello World</h1>"
/// )
/// let email = Email(
///     personalizations: [personalization],
///     from: Address("foo@bar.com"),
///     content: contents,
///     subject: "Hello World"
/// )
/// // Schedule the email for 24 hours from now.
/// email.sendAt = Date(timeIntervalSinceNow: 24 * 60 * 60)
/// 
/// // This part is optional, but if you [generated a batch ID](https://sendgrid.com/docs/API_Reference/Web_API_v3/cancel_schedule_send.html)
/// // and specify it here, you'll have the ability to cancel this send via the API if needed.
/// email.batchID = "76A8C7A6-B435-47F5-AB13-15F06BA2E3WD"
/// 
/// do {
///     try Session.shared.send(request: email) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
/// 
/// In the above example, we've set the `sendAt` property on the global email, 
/// which means every personalization will be scheduled for that time.  You can 
/// also set the `sendAt` property on a `Personalization` if you want each one 
/// to be set to a different time, or only have certain ones scheduled:
/// 
/// ```swift
/// let recipientInfo: [String:Date?] = [
///     "jose@example.none": Date(timeIntervalSinceNow: 4 * 60 * 60),
///     "isaac@example.none": nil,
///     "tim@example.none": Date(timeIntervalSinceNow: 12 * 60 * 60)
/// ]
/// let personalizations = recipientInfo.map { (recipient, date) -> Personalization in
///     let personalization = Personalization(recipients: recipient)
///     personalization.sendAt = date
///     return personalization
/// }
/// let contents = Content.emailBody(
///     plain: "Hello there,\n\nHow are you?\n\nBest,\nSender",
///     html: "<p>Hello there,</p><p>How are you?</p><p>Best,<br>Sender</p>"
/// )
/// let email = Email(
///     personalizations: personalizations,
///     from: Address(email: "sender@example.none"),
///     content: contents,
///     subject: nil
/// )
/// do {
///     try Session.shared.send(request: email) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
/// 
/// ## Categories
/// 
/// You can assign categories to an email which will show up in your SendGrid 
/// stats, Email Activity, and event webhook. You can not have more than 10 
/// categories per email.
/// 
/// ```swift
/// let personalization = Personalization(recipients: "test@example.com")
/// let contents = Content.emailBody(
///     plain: "Hello World",
///     html: "<h1>Hello World</h1>"
/// )
/// let email = Email(
///     personalizations: [personalization],
///     from: Address(email: "foo@bar.com"),
///     content: contents,
///     subject: "Hello World"
/// )
/// email.categories = ["Foo", "Bar"]
/// do {
///     try Session.shared.send(request: email) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
/// 
/// ## Sections
/// 
/// Sections allow you to define large blocks of content that can be inserted 
/// into your emails using substitution tags. An example of this might look like 
/// the following:
/// 
/// ```swift
/// let bob = Personalization(recipients: "bob@example.com")
/// bob.substitutions = [
///     ":salutation": ":male",
///     ":name": "Bob",
///     ":event_details": "event2",
///     ":event_date": "Feb 14"
/// ]
/// 
/// let alice = Personalization(recipients: "alice@example.com")
/// alice.substitutions = [
///     ":salutation": ":female",
///     ":name": "Alice",
///     ":event_details": "event1",
///     ":event_date": "Jan 1"
/// ]
/// 
/// let casey = Personalization(recipients: "casey@example.com")
/// casey.substitutions = [
///     ":salutation": ":neutral",
///     ":name": "Casey",
///     ":event_details": "event1",
///     ":event_date": "Aug 11"
/// ]
/// 
/// let personalization = [
///     bob,
///     alice,
///     casey
/// ]
/// let plainText = ":salutation,\n\nPlease join us for the :event_details."
/// let htmlText = "<p>:salutation,</p><p>Please join us for the :event_details.</p>"
/// let content = Content.emailBody(plain: plainText, html: htmlText)
/// let email = Email(
///     personalizations: personalization,
///     from: Address(email: "from@example.com"),
///     content: content
/// )
/// email.subject = "Hello World"
/// email.sections = [
///     ":male": "Mr. :name",
///     ":female": "Ms. :name",
///     ":neutral": ":name",
///     ":event1": "New User Event on :event_date",
///     ":event2": "Veteran User Appreciation on :event_date"
/// ]
/// ```
/// 
/// ## Template Engine
/// 
/// If you use SendGrid's 
/// [Template Engine](https://sendgrid.com/docs/User_Guide/Transactional_Templates/index.html), 
/// you can specify a template to apply to an email like so:
/// 
/// ```swift
/// let personalization = Personalization(recipients: "test@example.com")
/// let contents = Content.emailBody(
///     plain: "Hello World",
///     html: "<h1>Hello World</h1>"
/// )
/// let email = Email(
///     personalizations: [personalization],
///     from: Address(email: "foo@bar.com"),
///     content: contents,
///     subject: "Hello World"
/// )
/// /// Assuming you have a template with ID "52523e14-7e47-45ed-ab32-0db344d8cf9z" on your account…
/// email.templateID = "52523e14-7e47-45ed-ab32-0db344d8cf9z"
/// do {
///     try Session.shared.send(request: email) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class Email: Request<[String:Any]>, EmailHeaderRepresentable, Scheduling {
    
    // MARK: - Properties
    //=========================================================================
    
    /// A `Bool` indicating if the request supports the "On-behalf-of" header.
    public override var supportsImpersonation: Bool { return false }
    
    /// An array of personalization instances representing the various
    /// recipients of the email.
    public var personalizations: [Personalization]
    
    /// The content sections of the email.
    public var content: [Content]
    
    /// The subject of the email. If the personalizations in the email contain
    /// subjects, those will override this subject.
    public var subject: String?
    
    /// The sending address on the email.
    public var from: Address
    
    /// The reply to address on the email.
    public var replyTo: Address?
    
    /// Attachments to add to the email.
    public var attachments: [Attachment]?
    
    /// The ID of a template from the Template Engine to use with the email.
    public var templateID: String?
    
    /// Additional headers that should be added to the email.
    public var headers: [String:String]?
    
    /// Categories to associate with the email.
    public var categories: [String]?
    
    /// A dictionary of key/value pairs that define large blocks of content that
    /// can be inserted into your emails using substitution tags. An example of
    /// this might look like the following:
    ///
    ///     let bob = Personalization(recipients: "bob@example.com")
    ///     bob.substitutions = [
    ///         ":salutation": ":male",
    ///         ":name": "Bob",
    ///         ":event_details": "event2",
    ///         ":event_date": "Feb 14"
    ///     ]
    ///
    ///     let alice = Personalization(recipients: "alice@example.com")
    ///     alice.substitutions = [
    ///         ":salutation": ":female",
    ///         ":name": "Alice",
    ///         ":event_details": "event1",
    ///         ":event_date": "Jan 1"
    ///     ]
    ///
    ///     let casey = Personalization(recipients: "casey@example.com")
    ///     casey.substitutions = [
    ///         ":salutation": ":neutral",
    ///         ":name": "Casey",
    ///         ":event_details": "event1",
    ///         ":event_date": "Aug 11"
    ///     ]
    ///
    ///     let personalization = [
    ///         bob,
    ///         alice,
    ///         casey
    ///     ]
    ///     let plainText = ":salutation,\n\nPlease join us for the :event_details."
    ///     let htmlText = "<p>:salutation,</p><p>Please join us for the :event_details.</p>"
    ///     let content = Content.emailBody(plain: plainText, html: htmlText)
    ///     let email = Email(
    ///         personalizations: personalization,
    ///         from: Address(emailAddress: "from@example.com"),
    ///         content: content
    ///     )
    ///     email.subject = "Hello World"
    ///     email.sections = [
    ///         ":male": "Mr. :name",
    ///         ":female": "Ms. :name",
    ///         ":neutral": ":name",
    ///         ":event1": "New User Event on :event_date",
    ///         ":event2": "Veteran User Appreciation on :event_date"
    ///     ]
    public var sections: [String:String]?
    
    /// A set of custom arguments to add to the email. The keys of the
    /// dictionary should be the names of the custom arguments, while the values
    /// should represent the value of each custom argument. If personalizations
    /// in the email also contain custom arguments, they will be merged with
    /// these custom arguments, taking a preference to the personalization's
    /// custom arguments in the case of a conflict.
    public var customArguments: [String:String]?
    
    /// An `ASM` instance representing the unsubscribe group settings to apply
    /// to the email.
    public var asm: ASM?
    
    /// An optional time to send the email at.
    public var sendAt: Date? = nil
    
    /// This ID represents a batch of emails (AKA multiple sends of the same
    /// email) to be associated to each other for scheduling. Including a
    /// `batch_id` in your request allows you to include this email in that
    /// batch, and also enables you to cancel or pause the delivery of that
    /// entire batch. For more information, please read about [Cancel Scheduled
    /// Sends](https://sendgrid.com/docs/API_Reference/Web_API_v3/cancel_schedule_send.html).
    public var batchID: String? = nil
    
    /// The IP Pool that you would like to send this email from. See the [docs
    /// page](https://sendgrid.com/docs/API_Reference/Web_API_v3/IP_Management/ip_pools.html#-POST)
    /// for more information about creating IP Pools.
    public var ipPoolName: String? = nil
    
    /// An optional array of mail settings to configure the email with.
    public var mailSettings = MailSettings()
    
    /// An optional array of tracking settings to configure the email with.
    public var trackingSettings = TrackingSettings()
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the email request with a list of personalizations, a from
    /// address, content, and a subject.
    ///
    /// - Parameters:
    ///   - personalizations:   An array of personalization instances.
    ///   - from:               A from address to use in the email.
    ///   - content:            An array of content instances to use in the
    ///                         body.
    ///   - subject:            An optional global subject line.
    public init(personalizations: [Personalization], from: Address, content: [Content], subject: String? = nil) {
        self.personalizations = personalizations
        self.from = from
        self.content = content
        self.subject = subject
        super.init(method: .POST, contentType: .json, path: "/v3/mail/send")
    }
    
    // MARK: - Methods
    //=========================================================================
    
    /// Validates all the email properties and bubbles up errors.
    public override func validate() throws {
        try super.validate()
        
        // Check for correct amount of personalizations
        guard 1...Constants.PersonalizationLimit ~= self.personalizations.count else {
            throw Exception.Mail.invalidNumberOfPersonalizations
        }
        
        // Check for content
        guard self.content.count > 0 else { throw Exception.Mail.missingContent }
        
        // Check for content order
        let (isOrdered, _) = try self.content.reduce((true, 0)) { (running, item) -> (Bool, Int) in
            try item.validate()
            let thisIsOrdered = running.0 && (item.type.index >= running.1)
            return (thisIsOrdered, item.type.index)
        }
        guard isOrdered else { throw Exception.Mail.invalidContentOrder }
        
        // Check for total number of recipients
        let totalRecipients: [String] = try self.personalizations.reduce([String]()) { (list, per) -> [String] in
            try per.validate()
            func reduce(addresses: [Address]?) throws -> [String] {
                guard let array = addresses else { return [] }
                return try array.reduce([String](), { (running, address) -> [String] in
                    if list.contains(address.email.lowercased()) {
                        throw Exception.Mail.duplicateRecipient(address.email.lowercased())
                    }
                    return running + [address.email.lowercased()]
                })
            }
            let tos = try reduce(addresses: per.to)
            let ccs = try reduce(addresses: per.cc)
            let bcc = try reduce(addresses: per.bcc)
            return list + tos + ccs + bcc
        }
        guard totalRecipients.count <= Constants.RecipientLimit else { throw Exception.Mail.tooManyRecipients }
        
        // Check for subject present
        if ((self.subject?.count ?? 0) == 0) && self.templateID == nil {
            let subjectPresent = self.personalizations.reduce(true) { (hasSubject, person) -> Bool in
                return hasSubject && ((person.subject?.count ?? 0) > 0)
            }
            guard subjectPresent else { throw Exception.Mail.missingSubject }
        }
        
        // Validate from address
        try self.from.validate()
        
        // Validate reply-to address
        try self.replyTo?.validate()
        
        // Validate the headers
        try self.validateHeaders()
        
        // Validate the categories
        if let cats = self.categories {
            guard cats.count <= Constants.Categories.TotalLimit else { throw Exception.Mail.tooManyCategories }
            _ = try cats.reduce([String](), { (list, cat) -> [String] in
                guard cat.count <= Constants.Categories.CharacterLimit else {
                    throw Exception.Mail.categoryTooLong(cat)
                }
                let lower = cat.lowercased()
                if list.contains(lower) {
                    throw Exception.Mail.duplicateCategory(lower)
                }
                return list + [lower]
            })
        }
        
        // Validate the custom arguments.
        try self.personalizations.forEach({ (p) in
            var merged = self.customArguments ?? [:]
            if let list = p.customArguments {
                list.forEach { merged[$0.key] = $0.value }
            }
            let jsonData = try JSONEncoder().encode(merged)
            let bytes = jsonData.count
            guard bytes <= Constants.CustomArguments.MaximumBytes else {
                let jsonString = String(data: jsonData, encoding: .utf8)
                throw Exception.Mail.tooManyCustomArguments(bytes, jsonString)
            }
        })
        
        // Validate ASM
        try self.asm?.validate()
        
        // Validate the send at date.
        try self.validateSendAt()
        
        // Validate the mail settings.
        try self.mailSettings.validate()
        
        // validate the tracking settings.
        try self.trackingSettings.validate()
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
    public override func supports(auth: Authentication) -> Bool {
        // The mail send endpoint only supports API Keys.
        return auth.prefix == "Bearer"
    }
}

/// Encodable conformance.
extension Email: AutoEncodable {
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case asm
        case attachments
        case batchID            = "batch_id"
        case categories
        case content
        case customArguments    = "custom_args"
        case from
        case headers
        case ipPoolName         = "ip_pool_name"
        case mailSettings       = "mail_settings"
        case personalizations
        case replyTo            = "reply_to"
        case sections
        case sendAt             = "send_at"
        case subject
        case templateID         = "template_id"
        case trackingSettings   = "tracking_settings"
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.personalizations, forKey: .personalizations)
        try container.encode(self.from, forKey: .from)
        try container.encode(self.content, forKey: .content)
        try container.encodeIfPresent(self.subject, forKey: .subject)
        try container.encodeIfPresent(self.replyTo, forKey: .replyTo)
        try container.encodeIfPresent(self.attachments, forKey: .attachments)
        try container.encodeIfPresent(self.templateID, forKey: .templateID)
        try container.encodeIfPresent(self.sections, forKey: .sections)
        try container.encodeIfPresent(self.headers, forKey: .headers)
        try container.encodeIfPresent(self.categories, forKey: .categories)
        try container.encodeIfPresent(self.customArguments, forKey: .customArguments)
        try container.encodeIfPresent(self.asm, forKey: .asm)
        try container.encodeIfPresent(self.sendAt, forKey: .sendAt)
        try container.encodeIfPresent(self.batchID, forKey: .batchID)
        try container.encodeIfPresent(self.ipPoolName, forKey: .ipPoolName)
        if self.mailSettings.hasSettings {
            try container.encode(self.mailSettings, forKey: .mailSettings)
        }
        if self.trackingSettings.hasSettings {
            try container.encode(self.trackingSettings, forKey: .trackingSettings)
        }
    }
    
}
