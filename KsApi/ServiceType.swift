import Prelude
import ReactiveSwift
import UIKit

public enum Mailbox: String {
  case inbox
  case sent
}

/*
 *
 A type that knows how to perform requests for Kickstarter data.
 */
public protocol ServiceType {
  var appId: String { get }
  var serverConfig: ServerConfigType { get }
  var oauthToken: OauthTokenAuthType? { get }
  var language: String { get }
  var currency: String { get }
  var buildVersion: String { get }
  var deviceIdentifier: String { get }
  var perimeterXClient: PerimeterXClientType { get }
  var apolloClient: ApolloClientType? { get }

  init(
    appId: String,
    serverConfig: ServerConfigType,
    oauthToken: OauthTokenAuthType?,
    language: String,
    currency: String,
    buildVersion: String,
    deviceIdentifier: String,
    apolloClient: ApolloClientType?,
    perimeterXClient: PerimeterXClientType
  )

  /// Returns a new service with the oauth token replaced.
  func login(_ oauthToken: OauthTokenAuthType) -> Self

  /// Returns a new service with the oauth token set to `nil`.
  func logout() -> Self

  /// Request to connect user to Facebook with access token.
  func facebookConnect(facebookAccessToken token: String) -> SignalProducer<User, ErrorEnvelope>

  /// Uploads and attaches an image to the draft of a project update.
  func addImage(file fileURL: URL, toDraft draft: UpdateDraft)
    -> SignalProducer<UpdateDraft.Image, ErrorEnvelope>

  /// Cancels a backing
  func cancelBacking(input: CancelBackingInput)
    -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Changes the email on a user account
  func changeEmail(input: ChangeEmailInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Changes the password on a user account
  func changePassword(input: ChangePasswordInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Changes the currency code on a user profile
  func changeCurrency(input: ChangeCurrencyInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Clears the user's unseen activity count.
  func clearUserUnseenActivity(input: EmptyInput)
    -> SignalProducer<ClearUserUnseenActivityEnvelope, ErrorEnvelope>

  func createBacking(input: CreateBackingInput) ->
    SignalProducer<CreateBackingEnvelope, ErrorEnvelope>

  /// Creates the password on a user account
  func createPassword(input: CreatePasswordInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Create Stripe setup intent for use with Stripe payment sheet
  func createStripeSetupIntent(input: CreateSetupIntentInput) ->
    SignalProducer<ClientSecretEnvelope, ErrorEnvelope>

  /// Adds a new credit card to users' payment methods
  func addNewCreditCard(input: CreatePaymentSourceInput) ->
    SignalProducer<CreatePaymentSourceEnvelope, ErrorEnvelope>

  /// Deletes a payment method
  func deletePaymentMethod(input: PaymentSourceDeleteInput) ->
    SignalProducer<DeletePaymentMethodEnvelope, ErrorEnvelope>

  /// Removes an image from a project update draft.
  func delete(image: UpdateDraft.Image, fromDraft draft: UpdateDraft)
    -> SignalProducer<UpdateDraft.Image, ErrorEnvelope>

  func exportData() -> SignalProducer<VoidEnvelope, ErrorEnvelope>

  func exportDataState() -> SignalProducer<ExportDataEnvelope, ErrorEnvelope>

  /// Fetch a page of activities.
  func fetchActivities(count: Int?) -> SignalProducer<ActivityEnvelope, ErrorEnvelope>

  /// Fetch activities from a pagination URL
  func fetchActivities(paginationUrl: String) -> SignalProducer<ActivityEnvelope, ErrorEnvelope>

  /// Fetches the current user's backing for the project, if it exists.
  func fetchBacking(forProject project: Project, forUser user: User)
    -> SignalProducer<Backing, ErrorEnvelope>

  /// Fetch comments for a project with a slug, cursor and limit.
  func fetchProjectComments(
    slug: String,
    cursor: String?,
    limit: Int?,
    withStoredCards: Bool
  ) -> SignalProducer<CommentsEnvelope, ErrorEnvelope>

  /// Fetch comments for an update with an id, cursor, limit and comments' users' stored cards.
  func fetchUpdateComments(
    id: String,
    cursor: String?,
    limit: Int?,
    withStoredCards: Bool
  ) -> SignalProducer<CommentsEnvelope, ErrorEnvelope>

  /// Fetch comment replies for a comment with an id, limit, cursor and user information with stored cards.
  func fetchCommentReplies(
    id: String,
    cursor: String?,
    limit: Int,
    withStoredCards: Bool
  ) -> SignalProducer<CommentRepliesEnvelope, ErrorEnvelope>

  /// Fetch the config.
  func fetchConfig() -> SignalProducer<Config, ErrorEnvelope>

  /// Fetch discovery envelope with a pagination url.
  func fetchDiscovery(paginationUrl: String) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetch the full discovery envelope with specified discovery params.
  func fetchDiscovery(params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetch friends for a user.
  func fetchFriends() -> SignalProducer<FindFriendsEnvelope, ErrorEnvelope>

  /// Fetch friends from a pagination url.
  func fetchFriends(paginationUrl: String) -> SignalProducer<FindFriendsEnvelope, ErrorEnvelope>

  /// Fetch friend stats.
  func fetchFriendStats() -> SignalProducer<FriendStatsEnvelope, ErrorEnvelope>

  /// Fetch Categories objects using graphQL.
  func fetchGraphCategories() -> SignalProducer<RootCategoriesEnvelope, ErrorEnvelope>

  /// Fetch Category objects using graphQL.
  func fetchGraphCategory(id: String)
    -> SignalProducer<CategoryEnvelope, ErrorEnvelope>

  /// Fetches various fields of a given User using graphQL.
  func fetchGraphUser(withStoredCards: Bool)
    -> SignalProducer<UserEnvelope<GraphUser>, ErrorEnvelope>

  /// Fetch errored User's backings with a specific status.
  func fetchErroredUserBackings(status: BackingState)
    -> SignalProducer<ErroredBackingsEnvelope, ErrorEnvelope>

  /// Fetch `Backing` data with a `Backing` ID and the backers' stored cards.
  func fetchBacking(id: Int, withStoredCards: Bool)
    -> SignalProducer<ProjectAndBackingEnvelope, ErrorEnvelope>

  /// Fetches all of the messages in a particular message thread.
  func fetchMessageThread(messageThreadId: Int)
    -> SignalProducer<MessageThreadEnvelope, ErrorEnvelope>

  /// Fetches all of the messages related to a particular backing.
  func fetchMessageThread(backing: Backing) -> SignalProducer<MessageThreadEnvelope?, ErrorEnvelope>

  /// Fetches all of the messages in a particular mailbox and specific to a particular project.
  func fetchMessageThreads(mailbox: Mailbox, project: Project?)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope>

  /// Fetches more messages threads from a pagination URL.
  func fetchMessageThreads(paginationUrl: String)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope>

  /// Fetch the newest data for a particular project from its id or slug. (v1)
  func fetchProject(param: Param) -> SignalProducer<Project, ErrorEnvelope>

  /// Fetch the newest data for a particular project from its id or slug, including an optional backing id if current user is backing project
  /// (currently only used on `ProjectPamphetViewModel`and `ProjectPageViewModel`  because it's a GQL query)
  func fetchProject(projectParam: Param, configCurrency: String?)
    -> SignalProducer<Project.ProjectPamphletData, ErrorEnvelope>

  /// Fetch the project's rewards only, without shipping rules
  func fetchProjectRewards(projectId: Int) -> SignalProducer<[Reward], ErrorEnvelope>

  /// Fetch a project's friendly backers from its id or slug.
  func fetchProjectFriends(param: Param) -> SignalProducer<[User], ErrorEnvelope>

  /// Fetch a single project with the specified discovery params.
  func fetchProject(_ params: DiscoveryParams) -> SignalProducer<DiscoveryEnvelope, ErrorEnvelope>

  /// Fetch the newest data for a particular project from its project value.
  func fetchProject(project: Project) -> SignalProducer<Project, ErrorEnvelope>

  /// Fetch a page of activities for a project.
  func fetchProjectActivities(forProject project: Project) ->
    SignalProducer<ProjectActivityEnvelope, ErrorEnvelope>

  /// Fetch a page of activities for a project from a pagination url.
  func fetchProjectActivities(paginationUrl: String) ->
    SignalProducer<ProjectActivityEnvelope, ErrorEnvelope>

  /// Fetch the user's project notifications.
  func fetchProjectNotifications() -> SignalProducer<[ProjectNotification], ErrorEnvelope>

  /// Fetches the projects that the current user is a member of.
  func fetchProjects(member: Bool) -> SignalProducer<ProjectsEnvelope, ErrorEnvelope>

  /// Fetches more projects from a pagination URL.
  func fetchProjects(paginationUrl: String) -> SignalProducer<ProjectsEnvelope, ErrorEnvelope>

  /// Fetches the stats for a particular project.
  func fetchProjectStats(projectId: Int) -> SignalProducer<ProjectStatsEnvelope, ErrorEnvelope>

  /// Fetch the add-on rewards for the add-on selection view with a `Project` slug and optional `Location` ID.
  func fetchRewardAddOnsSelectionViewRewards(slug: String, shippingEnabled: Bool, locationId: String?)
    -> SignalProducer<Project, ErrorEnvelope>

  /// Fetches a reward's shipping rules for a project and reward id.
  func fetchRewardShippingRules(projectId: Int, rewardId: Int)
    -> SignalProducer<ShippingRulesEnvelope, ErrorEnvelope>

  /// Fetches a survey response belonging to the current user.
  func fetchSurveyResponse(surveyResponseId: Int)
    -> SignalProducer<SurveyResponse, ErrorEnvelope>

  /// Fetches all of the user's unanswered surveys.
  func fetchUnansweredSurveyResponses() -> SignalProducer<[SurveyResponse], ErrorEnvelope>

  /// Fetches an update from its id and project.
  func fetchUpdate(updateId: Int, projectParam: Param) -> SignalProducer<Update, ErrorEnvelope>

  /// Fetches a project update draft.
  func fetchUpdateDraft(forProject project: Project) -> SignalProducer<UpdateDraft, ErrorEnvelope>

  /// Fetch the newest data for a particular user.
  func fetchUser(_ user: User) -> SignalProducer<User, ErrorEnvelope>

  /// Fetch a user.
  func fetchUser(userId: Int) -> SignalProducer<User, ErrorEnvelope>

  /// Fetch the logged-in user's data.
  func fetchUserSelf() -> SignalProducer<User, ErrorEnvelope>

  /// Mark reward received.
  func backingUpdate(forProject project: Project, forUser user: User, received: Bool)
    -> SignalProducer<Backing, ErrorEnvelope>

  /// Follow all friends of current user.
  func followAllFriends() -> SignalProducer<VoidEnvelope, ErrorEnvelope>

  /// Follow a user with their id.
  func followFriend(userId id: Int) -> SignalProducer<User, ErrorEnvelope>

  /// Increment the video complete stat for a project.
  func incrementVideoCompletion(forProject project: Project) -> SignalProducer<VoidEnvelope, ErrorEnvelope>

  /// Increment the video start stat for a project.
  func incrementVideoStart(forProject project: Project) -> SignalProducer<VoidEnvelope, ErrorEnvelope>

  /// Attempt a login with an email, password and optional code.
  func login(email: String, password: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  /// Attempt a login with Facebook access token and optional code.
  func login(facebookAccessToken: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  /// Marks all the messages in a particular thread as read.
  func markAsRead(messageThread: MessageThread) -> SignalProducer<MessageThread, ErrorEnvelope>

  /// Posts a comment to a project or replies in a thread
  func postComment(input: PostCommentInput)
    -> SignalProducer<Comment, ErrorEnvelope>

  /// Returns a project update preview URL.
  func previewUrl(forDraft draft: UpdateDraft) -> URL?

  /// Publishes a project update draft.
  func publish(draft: UpdateDraft) -> SignalProducer<Update, ErrorEnvelope>

  /// Registers a push token.
  func register(pushToken: String) -> SignalProducer<VoidEnvelope, ErrorEnvelope>

  /// Reset user password with email address.
  func resetPassword(email: String) -> SignalProducer<User, ErrorEnvelope>

  /// Searches all of the messages, (optionally) bucketed to a specific project.
  func searchMessages(query: String, project: Project?)
    -> SignalProducer<MessageThreadsEnvelope, ErrorEnvelope>

  /// Sends a message to a subject, i.e. creator project, message thread, backer of backing.
  func sendMessage(body: String, toSubject subject: MessageSubject)
    -> SignalProducer<Message, ErrorEnvelope>

  /// Sends a verification email (after updating the email from account settings).
  func sendVerificationEmail(input: EmptyInput)
    -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Signin with Apple
  func signInWithApple(input: SignInWithAppleInput)
    -> SignalProducer<SignInWithAppleEnvelope, ErrorEnvelope>

  /// Signup with email.
  func signup(
    name: String, email: String, password: String, passwordConfirmation: String,
    sendNewsletters: Bool
  ) -> SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  /// Signup with Facebook access token and newsletter bool.
  func signup(facebookAccessToken: String, sendNewsletters: Bool) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  /// Unfollow a user with their id.
  func unfollowFriend(userId id: Int) -> SignalProducer<VoidEnvelope, ErrorEnvelope>

  /// Updates a backing
  func updateBacking(input: UpdateBackingInput) -> SignalProducer<UpdateBackingEnvelope, ErrorEnvelope>

  /// Update the project notification setting.
  func updateProjectNotification(_ notification: ProjectNotification)
    -> SignalProducer<ProjectNotification, ErrorEnvelope>

  /// Update the current user with settings attributes.
  func updateUserSelf(_ user: User) -> SignalProducer<User, ErrorEnvelope>

  /// Updates the draft of a project update.
  func update(draft: UpdateDraft, title: String, body: String, isPublic: Bool)
    -> SignalProducer<UpdateDraft, ErrorEnvelope>

  /// Unwatches a project.
  func unwatchProject(input: WatchProjectInput) ->
    SignalProducer<WatchProjectResponseEnvelope, ErrorEnvelope>

  /// Verifies an email address with a given access token.
  func verifyEmail(withToken token: String)
    -> SignalProducer<EmailVerificationResponseEnvelope, ErrorEnvelope>

  /// Watches (also known as favoriting) a project.
  func watchProject(input: WatchProjectInput) ->
    SignalProducer<WatchProjectResponseEnvelope, ErrorEnvelope>
}

extension ServiceType {
  /// Returns `true` if an oauth token is present, and `false` otherwise.
  public var isAuthenticated: Bool {
    return self.oauthToken != nil
  }
}

public func == (lhs: ServiceType, rhs: ServiceType) -> Bool {
  return
    type(of: lhs) == type(of: rhs) &&
    lhs.serverConfig == rhs.serverConfig &&
    lhs.oauthToken == rhs.oauthToken &&
    lhs.language == rhs.language &&
    lhs.buildVersion == rhs.buildVersion
}

public func != (lhs: ServiceType, rhs: ServiceType) -> Bool {
  return !(lhs == rhs)
}

extension ServiceType {
  /**
   Prepares a URL request to be sent to the server.

   - parameter originalRequest: The request that should be prepared.
   - parameter query:           Additional query params that should be attached to the request.

   - returns: A new URL request that is properly configured for the server.
   */
  public func preparedRequest(forRequest originalRequest: URLRequest, query: [String: Any] = [:])
    -> URLRequest {
    var request = originalRequest
    guard let URL = request.url else {
      return originalRequest
    }

    var headers = self.defaultHeaders

    let method = request.httpMethod?.uppercased()
    var components = URLComponents(url: URL, resolvingAgainstBaseURL: false)!
    var queryItems = components.queryItems ?? []
    queryItems.append(contentsOf: self.defaultQueryParams.map(URLQueryItem.init(name:value:)))

    if method == .some("POST") || method == .some("PUT") {
      if request.httpBody == nil {
        headers["Content-Type"] = "application/json; charset=utf-8"
        request.httpBody = try? JSONSerialization.data(withJSONObject: query, options: [])
      }
    } else {
      queryItems.append(
        contentsOf: query
          .flatMap(self.queryComponents)
          .map(URLQueryItem.init(name:value:))
      )
    }
    components.queryItems = queryItems.sorted { $0.name < $1.name }
    request.url = components.url

    let currentHeaders = request.allHTTPHeaderFields ?? [:]
    request.allHTTPHeaderFields = currentHeaders.withAllValuesFrom(headers)

    return request
  }

  /**
   Prepares a request to be sent to the server.

   - parameter URL:    The URL to turn into a request and prepare.
   - parameter method: The HTTP verb to use for the request.
   - parameter query:  Additional query params that should be attached to the request.

   - returns: A new URL request that is properly configured for the server.
   */
  public func preparedRequest(forURL url: URL, method: Method = .GET, query: [String: Any] = [:])
    -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    return self.preparedRequest(forRequest: request, query: query)
  }

  /**
   Prepares a URL request to be sent to the server.

   - parameter originalRequest: The request that should be prepared.
   - parameter queryString:     The GraphQL query string for the request.

   - returns: A new URL request that is properly configured for the server.
   */
  public func preparedRequest(forRequest originalRequest: URLRequest, queryString: String)
    -> URLRequest {
    var request = originalRequest
    guard let URL = request.url else {
      return originalRequest
    }

    request.httpBody = "query=\(queryString)".data(using: .utf8)

    let components = URLComponents(url: URL, resolvingAgainstBaseURL: false)!
    request.url = components.url
    request.allHTTPHeaderFields = self.defaultHeaders

    return request
  }

  public func preparedRequest(forURL url: URL, queryString: String)
    -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = Method.POST.rawValue
    return self.preparedRequest(forRequest: request, queryString: queryString)
  }

  /**
     Prepares a URL request to be sent to the server.
     - parameter originalRequest: The request that should be prepared
     - parameter queryString: The GraphQL mutation string description
     - parameter input: The input for the mutation

     - returns: A new URL request that is properly configured for the server
   **/
  public func preparedGraphRequest(
    forURL url: URL,
    queryString: String,
    input: [String: Any]
  ) throws -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = Method.POST.rawValue

    guard let URL = request.url else {
      return request
    }

    let requestBody = self.graphMutationRequestBody(mutation: queryString, input: input)
    let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])

    request.httpBody = jsonData

    var headers = self.defaultHeaders
    headers["Content-Type"] = "application/json; charset=utf-8"

    let components = URLComponents(url: URL, resolvingAgainstBaseURL: false)!
    request.url = components.url
    request.allHTTPHeaderFields = headers

    return request
  }

  public func isPrepared(request: URLRequest) -> Bool {
    return request.value(forHTTPHeaderField: "Authorization") == self.authorizationHeader
      && request.value(forHTTPHeaderField: "Kickstarter-iOS-App") != nil
  }

  internal var defaultHeaders: [String: String] {
    var headers: [String: String] = [:]
    headers["Accept-Language"] = self.language
    headers["Authorization"] = self.authorizationHeader
    headers["Kickstarter-App-Id"] = self.appId
    headers["Kickstarter-iOS-App"] = self.buildVersion
    headers["User-Agent"] = Self.userAgent
    headers["X-KICKSTARTER-CLIENT"] = self.serverConfig.apiClientAuth.clientId
    headers["Kickstarter-iOS-App-UUID"] = self.deviceIdentifier

    return headers.withAllValuesFrom(self.pxHeaders)
  }

  // PerimeterX authorization header
  internal var pxHeaders: [String: String] {
    return self.perimeterXClient.headers()
  }

  func graphMutationRequestBody(mutation: String, input: [String: Any]) -> [String: Any] {
    return [
      "query": mutation,
      "variables": ["input": input]
    ]
  }

  public static var userAgent: String {
    let executable = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String
    let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    let app: String = executable ?? bundleIdentifier ?? "Kickstarter"
    let bundleVersion: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "1"
    let model = UIDevice.current.model
    let systemVersion = UIDevice.current.systemVersion
    let scale = UIScreen.main.scale

    return "\(app)/\(bundleVersion) (\(model); iOS \(systemVersion) Scale/\(scale))"
  }

  fileprivate var authorizationHeader: String? {
    if let token = self.oauthToken?.token {
      return "token \(token)"
    } else {
      return self.serverConfig.basicHTTPAuth?.authorizationHeader
    }
  }

  fileprivate var defaultQueryParams: [String: String] {
    var query: [String: String] = [:]
    query["client_id"] = self.serverConfig.apiClientAuth.clientId
    query["currency"] = self.currency
    query["oauth_token"] = self.oauthToken?.token
    return query
  }

  fileprivate func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
    var components: [(String, String)] = []

    if let dictionary = value as? [String: Any] {
      for (nestedKey, value) in dictionary {
        components += self.queryComponents("\(key)[\(nestedKey)]", value)
      }
    } else if let array = value as? [Any] {
      for value in array {
        components += self.queryComponents("\(key)[]", value)
      }
    } else {
      components.append((key, String(describing: value)))
    }

    return components
  }
}
