//
//  BankVC.swift
//  Credit Card Fraud Detection
//
//  Created by Simran Gogia and Utkarsh Sharma on 14/03/21.
//

import UIKit

class BankVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    
    @IBOutlet weak var balanceUserLbl: UILabel!
    @IBOutlet weak var cardTopLbl: UILabel!
    @IBOutlet weak var subtitleOneLbl: UILabel!
    @IBOutlet weak var validThruLbl: UILabel!
    @IBOutlet weak var subtitleTwoLbl: UILabel!
    @IBOutlet weak var cvvLbl: UILabel!
    
    
    // MARK: Local Variables
    var userType: String?
    var userName: String?
    var filteredDict = [Int: [String: String]]()
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        userType = "Bank"
        userName = "Wells Fargo & Co."
        
//        userType = "User"
//        userName = "Utkarsh"
        
        if(userType == "Bank"){
            topLbl.text = userName
            secondLbl.text = "Admin Panel"
            balanceUserLbl.text = "4562"
            cardTopLbl.text = "Total Users"
            subtitleOneLbl.text = "FLAGGED TRANSACTIONS"
            validThruLbl.text = "2%"
            subtitleTwoLbl.isHidden = true
            cvvLbl.isHidden = true
        } else{
            topLbl.text = userName
            secondLbl.text = "Welcome back!"
            balanceUserLbl.text = "₹10250"
            cardTopLbl.text = "Outstanding Dues"
            subtitleOneLbl.text = "VALID THRU"
            validThruLbl.text = "05/22"
            subtitleTwoLbl.isHidden = false
            cvvLbl.isHidden = false
        }
    }
    
    
    // MARK: Table View Protocols
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(userType == "Bank"){
            return transactions.count
        } else{
            filteredDict.removeAll()
            var i = 0
            for counter in 0...(transactions.count-1) {
                let dict = transactions[counter]
                if(dict!["Customer"] == userName){
                    filteredDict[i] = dict
                    i = i+1
                }
            }
            print(filteredDict)
            return filteredDict.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentsCell", for: indexPath) as! RecentsCell
        
        cell.selectionStyle = .none

        
        if(userType == "Bank"){
            let transact = transactions[indexPath.row]
            let status = transact!["Status"]
            
            if(status == "Approved"){
                cell.backgroundImage.image = UIImage(named: "greenBg")
            } else{
                cell.backgroundImage.image = UIImage(named: "redBg")
            }
            
            cell.topLbl?.text = transact!["Customer"]
            cell.descLbl?.text = "Recipient: \(transact!["Recipient"] ?? "")"
            
            cell.amountLbl?.text = "₹\(transact!["Amount"] ?? "")"
        } else {
            let transact = filteredDict[indexPath.row]
            print("Transact: ")
            print(transact as Any)
            let status = transact?["Status"]
            
            if(status == "Approved"){
                cell.backgroundImage.image = UIImage(named: "greenBg")
            } else{
                cell.backgroundImage.image = UIImage(named: "redBg")
            }
            
            cell.topLbl?.text = transact?["Recipient"]
            cell.descLbl?.text = "Date: \(transact?["Date"] ?? "")"
            
            cell.amountLbl?.text = "₹\(transact?["Amount"] ?? "")"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transact = transactions[indexPath.row]
        showSimpleActionSheet(status: transact!["Status"]!, controller: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showSimpleActionSheet(status: String, controller: UIViewController) {
        var message: String?
        if(status == "Approved"){
            message = "This transaction was successfully approved by the system!"
        } else{
            message = "This transaction was rejected and flagged as possible fraud."
        }
        let alert = UIAlertController(title: status, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("Dismissed")
        }))

        self.present(alert, animated: true)
    }

    
    // MARK: IBActions
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func userButtonPressed(_ sender: Any) {
        
    }
    
}
