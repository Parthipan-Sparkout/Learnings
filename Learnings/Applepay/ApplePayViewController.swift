//
//  ApplePayViewController.swift
//  Learnings
//
//  Created by Hxtreme on 27/09/23.
//

import UIKit
import PassKit

class ApplePayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func payButtonTapped(_ sender: UIButton) {
        let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
        // Add in any extra support payments.
        let ApplePayMerchantID = "merchant.com.FirstApplePaySample"
        let productToBuy = PKPaymentSummaryItem(label: "Himalaya Anti Dandruff shampoo", amount: NSDecimalNumber(decimal:Decimal(10000/100)), type: .final)
        let total = PKPaymentSummaryItem(label: "Total with Tax", amount: NSDecimalNumber(decimal:Decimal(12000/100)))
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = ApplePayMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [productToBuy,total]
        
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController?.delegate = self
        self.present(applePayController!, animated: true, completion: nil)
    }

}

extension ApplePayViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print("payment finish")
        dismiss(animated: true)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        print("Authorize payment")
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}
