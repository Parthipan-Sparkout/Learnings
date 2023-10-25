//
//  CashFreeViewController.swift
//  Learnings
//
//  Created by Hxtreme on 25/10/23.
//

import UIKit
import CFSDK

class CashFreeViewController: UIViewController {

    let appId = "TEST100470408780cc4c7f9c0c5d332b04074001"
    let cfToken = "g69JCN4MzUIJiOicGbhJCLiQ1VKJiOiAXe0Jye.NK0nIjVWZ2UmM1YmZ4MTN2IiOiQHbhN3XiwCN5EjNygDMwcTM6ICc4VmIsIiUOlkI6ISej5WZyJXdDJXZkJ3biwCMwIjOiQnb19WbBJXZkJ3biwiIyADMSZFUiojIklkclRmcvJye.yM0PZZRmuNNhXmloqf3tNzXRYhZyEEwwAzKlrz_Gz_7JUvXevZo6JguN-KE1d1ZwNZ" // This token will be get by https://test.cashfree.com/api/v2/cftoken/order api
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func payButtonAction(_ sender: UIButton) {
        let requestParams = getPaymentParams()
        CFPaymentService().doWebCheckoutPayment(params: requestParams, env: "TEST", callback: self)
       // CFPaymentService().doUPIPayment(params: requestParams, env: "TEST", callback: self)
    }
    
    func getPaymentParams() -> Dictionary<String, Any> {
        return [
            "orderId": "PVR002",
            "appId": appId,
            "tokenData" : cfToken,
            "orderAmount": "200",
            "customerName": "Parthipan",
            "orderNote": "Order Note",
            "orderCurrency": "INR",
            "customerPhone": "9012341234",
            "customerEmail": "sample@gmail.com",
            "notifyUrl": "https://test.gocashfree.com/notify"
        ]
    }

}

extension CashFreeViewController: ResultDelegate
{
    func onPaymentCompletion(msg: String)
    {
        print("Result Delegate : onPaymentCompletion")
        print(msg)
        // Handle the result here
    }
}

