//
//  ViewController.swift
//  tip-calculator
//
//  Created by Nguyen Van Phuong Mai on 6/6/16.
//  Copyright © 2016 Nguyen Van Phuong Mai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bill_field: UITextField!
    @IBOutlet weak var tip_label: UILabel!
    @IBOutlet weak var total_label: UILabel!
    @IBOutlet weak var tip_control: UISegmentedControl!
    @IBOutlet weak var bill_label: UILabel!
    @IBOutlet weak var tip_name: UILabel!
    @IBOutlet weak var total_name: UILabel!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let utility = Utility()
    var currency_cons = Constants.Currency.self
    var default_cons = Constants.DefaultKeys.self
    var tip_percentage = -1.0
    var locale_identifier = "vi"
    let tip_percentages = [0.18, 0.2, 0.22]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tip_control.selectedSegmentIndex = -1
        tip_label.text = getFormattedNum(0)
        total_label.text = getFormattedNum(0)
        bill_field.text = NSString(string: utility.getBillAmount() as! String) as String
        tip_percentage = utility.getTipPercentage().doubleValue
    }
    
    override func viewWillAppear(animated: Bool) {
        bill_field.becomeFirstResponder()
        locale_identifier = utility.getLocaleIdentifier()
        animate()
        reflectUserInput()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        reflectUserInput()
        saveBillAmount()
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func saveBillAmount() {
        if bill_field.text != nil {
            let bill_amount = bill_field.text
            if bill_amount != nil {
                defaults.setObject(NSDate(), forKey: default_cons.current_time_key)
                defaults.setObject(bill_amount, forKey: default_cons.bill_amount_key)
                defaults.synchronize()
            }
        }
    }
    
    func reflectUserInput() {
        if tip_control.selectedSegmentIndex != -1 || tip_percentage < 0 {
            tip_percentage = tip_percentages[tip_control.selectedSegmentIndex]
        }
        
        let bill_amount = NSString(string: bill_field.text!).doubleValue
        let tip = bill_amount * tip_percentage
        let total = bill_amount + tip
        
        tip_label.text = getFormattedNum(tip)
        total_label.text = getFormattedNum(total)
    }
    
    func getFormattedNum(num: Double) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: locale_identifier)
        return formatter.stringFromNumber(num)!
    }
    
    func animate() {
        bill_field.center.x += view.bounds.width
        bill_label.center.x -= view.bounds.width
        tip_name.center.x -= view.bounds.width
        tip_label.center.x += view.bounds.width
        total_name.center.x -= view.bounds.width
        total_label.center.x += view.bounds.width
        
        UIView.animateWithDuration(1.5, delay: 0.5,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.5,
            options: [], animations: {
            self.bill_label.center.x += self.view.bounds.width
            self.bill_field.center.x -= self.view.bounds.width
            self.total_label.center.x -= self.view.bounds.width
            self.total_name.center.x += self.view.bounds.width
            self.tip_name.center.x += self.view.bounds.width
            self.tip_label.center.x -= self.view.bounds.width
            }, completion: nil)
    }
}

