//
//  CreditCardListTableViewController.swift
//  iDeliver
//
//  Created by Rodrigo Buendia Ramos on 5/6/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class CreditCardListTableViewController: UITableViewController, NVActivityIndicatorViewable {
    
    // MARK: - Properties
    var user: User?
    private var creditCards = [CreditCard]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCreditCardInfo()
    }
    
    func fetchCreditCardInfo() {
        guard let user = user else { return }
        UserNetworkManager.shared.fetchCurrentUserCreditCardInfo(user: user) { (creditCard, success) in
            if success {
                guard let creditCard = creditCard else { return }
                self.creditCards.append(creditCard)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Handlers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAddCreditCard" {
            let controller = segue.destination as! AddCreditCardTableViewController
            controller.user = self.user
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CreditCardTableViewCell
        if creditCards[indexPath.row].cardNumber.prefix(4) == "4242" {
            cell.cardIssuerImageView.image = UIImage(named: "visa")
        }
        let lastFourDigits = String(creditCards[indexPath.row].cardNumber.suffix(4))
        cell.cardNumber.text = lastFourDigits.applyPatternOnNumbers(pattern: "**** **** **** ####", replacmentCharacter: "#")
        let expirationMonth = creditCards[indexPath.row].expirationMonth
        let expirationYear = creditCards[indexPath.row].expirationYear
        cell.cardExpiration.text = "\(expirationMonth) / \(expirationYear)"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
