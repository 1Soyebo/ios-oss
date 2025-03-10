import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift
import UIKit

public typealias PaymentSheetPaymentMethodCellData = (image: UIImage, redactedCardNumber: String)

public protocol PledgePaymentSheetPaymentMethodCellViewModelInputs {
  /// Call to configure cell with payment sheet card and selected payment sheet card values.
  func configureWith(value: PaymentSheetPaymentMethodCellData)

  // FIXME: All payment sheet cards are mapping to unselected temporarily. Revisit this once displaying multiple payment sheet cards is working.
  /// Call with the currently selected card.
  func setSelectedCard(_ creditCard: UserCreditCards.CreditCard)
}

public protocol PledgePaymentSheetPaymentMethodCellViewModelOutputs {
  /// Emits the alpha for the card image
  var cardImageAlpha: Signal<CGFloat, Never> { get }

  /// Emits the card's image.
  var cardImage: Signal<UIImage, Never> { get }

  /// Emits a formatted accessibility string containing the card type, number and last four digits
  var cardNumberAccessibilityLabel: Signal<String, Never> { get }

  /// Emits a formatted string containing the card's last four digits.
  var cardNumberTextShortStyle: Signal<String, Never> { get }

  /// Emits when the checkmark image should be hidden.
  var checkmarkImageHidden: Signal<Bool, Never> { get }

  /// Emits the checkmark image.
  var checkmarkImageName: Signal<String, Never> { get }

  /// Emits the formatted card's expirationdate.
  var expirationDateText: Signal<String, Never> { get }

  /// Emits the text color for the last four digits label.
  var lastFourLabelTextColor: Signal<UIColor, Never> { get }

  /// Emits the selection cell's selection style.
  var selectionStyle: Signal<UITableViewCell.SelectionStyle, Never> { get }

  /// Emits whether or not the unavailable card type label should be hidden.
  var unavailableCardLabelHidden: Signal<Bool, Never> { get }

  /// Emits a string explaining why card type is unavailable.
  var unavailableCardText: Signal<String, Never> { get }
}

public protocol PledgePaymentSheetPaymentMethodCellViewModelType {
  var inputs: PledgePaymentSheetPaymentMethodCellViewModelInputs { get }
  var outputs: PledgePaymentSheetPaymentMethodCellViewModelOutputs { get }
}

public final class PledgePaymentSheetPaymentMethodCellViewModel: PledgePaymentSheetPaymentMethodCellViewModelInputs,
  PledgePaymentSheetPaymentMethodCellViewModelOutputs, PledgePaymentSheetPaymentMethodCellViewModelType {
  public init() {
    let paymentSheetCreditCardImage = self.configureValueProperty.signal.skipNil()
      .map(\.image)
    let paymentSheetCreditCardRedactedNumber = self.configureValueProperty.signal.skipNil()
      .map(\.redactedCardNumber)

    self.cardImage = paymentSheetCreditCardImage

    self.cardNumberAccessibilityLabel = paymentSheetCreditCardRedactedNumber.map {
      Strings.Card_ending_in_last_four(last_four: $0)
    }

    self.cardNumberTextShortStyle = paymentSheetCreditCardRedactedNumber

    let paymentSheetCreditCardExpiryDate = paymentSheetCreditCardRedactedNumber
      .map(value: "")

    self.expirationDateText = paymentSheetCreditCardExpiryDate

    // FIXME: All payment sheet cards are mapping to unselected temporarily. Revisit this once displaying multiple payment sheet cards is working.
    let paymentSheetCheckImageName = paymentSheetCreditCardExpiryDate
      .map { _ in "icon-payment-method-unselected" }

    self.checkmarkImageName = paymentSheetCheckImageName

    let paymentSheetCreditCardUnavailable = paymentSheetCreditCardRedactedNumber.mapConst(false)

    self.unavailableCardLabelHidden = paymentSheetCreditCardUnavailable.negate()

    let paymentSheetCardText = paymentSheetCreditCardRedactedNumber.map { _ in Strings.general_error_oops() }

    self.unavailableCardText = paymentSheetCardText

    let paymentSheetCreditCardIsAvailableForSelectionStyle = paymentSheetCreditCardRedactedNumber
      .map { _ in UITableViewCell.SelectionStyle.default }

    self.selectionStyle = paymentSheetCreditCardIsAvailableForSelectionStyle

    let paymentSheetCreditCardIsAvailable = paymentSheetCreditCardRedactedNumber.map { _ in CGFloat(1.0) }

    self.cardImageAlpha = paymentSheetCreditCardIsAvailable

    let paymentSheetCreditCardImageHidden = paymentSheetCreditCardRedactedNumber.mapConst(false)

    self.checkmarkImageHidden = paymentSheetCreditCardImageHidden

    self.lastFourLabelTextColor = paymentSheetCreditCardRedactedNumber.mapConst(UIColor.ksr_support_700)
  }

  fileprivate let configureValueProperty = MutableProperty<PaymentSheetPaymentMethodCellData?>(nil)
  public func configureWith(value: PaymentSheetPaymentMethodCellData) {
    self.configureValueProperty.value = value
  }

  private let selectedCardProperty = MutableProperty<UserCreditCards.CreditCard?>(nil)
  public func setSelectedCard(_ creditCard: UserCreditCards.CreditCard) {
    self.selectedCardProperty.value = creditCard
  }

  public let cardImageAlpha: Signal<CGFloat, Never>
  public let cardImage: Signal<UIImage, Never>
  public let cardNumberAccessibilityLabel: Signal<String, Never>
  public let cardNumberTextShortStyle: Signal<String, Never>
  public let checkmarkImageHidden: Signal<Bool, Never>
  public let checkmarkImageName: Signal<String, Never>
  public let expirationDateText: Signal<String, Never>
  public let lastFourLabelTextColor: Signal<UIColor, Never>
  public let selectionStyle: Signal<UITableViewCell.SelectionStyle, Never>
  public let unavailableCardLabelHidden: Signal<Bool, Never>
  public let unavailableCardText: Signal<String, Never>

  public var inputs: PledgePaymentSheetPaymentMethodCellViewModelInputs { return self }
  public var outputs: PledgePaymentSheetPaymentMethodCellViewModelOutputs { return self }
}
