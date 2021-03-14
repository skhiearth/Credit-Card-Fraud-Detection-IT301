//
//  BankVC.swift
//  Credit Card Fraud Detection
//
//  Created by Simran Gogia and Utkarsh Sharma on 14/03/21.
//

import UIKit
import CoreML
import CDAlertView
import LocalAuthentication


class BankVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTransactionBtn: UIButton!
    
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
        tableView.transform = CGAffineTransform(scaleX: 1,y: -1);

        if(userType == "Bank"){
            topLbl.text = userName
            secondLbl.text = "Admin Panel"
            balanceUserLbl.text = "4562"
            cardTopLbl.text = "Total Users"
            subtitleOneLbl.text = "FLAGGED TRANSACTIONS"
            validThruLbl.text = "2%"
            subtitleTwoLbl.isHidden = true
            cvvLbl.isHidden = true
            newTransactionBtn.isHidden = true
        } else{
            topLbl.text = userName
            secondLbl.text = "Welcome back!"
            balanceUserLbl.text = "₹10250"
            cardTopLbl.text = "Outstanding Dues"
            subtitleOneLbl.text = "VALID THRU"
            validThruLbl.text = "05/22"
            subtitleTwoLbl.isHidden = false
            cvvLbl.isHidden = false
            newTransactionBtn.isHidden = false
        }
    }
    
    
    func setupAsUser(){
        userType = "User"
        userName = "Utkarsh"
    }
    
    func setupAsBank(){
        userType = "Bank"
        userName = "Wells Fargo & Co."
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
            return filteredDict.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentsCell", for: indexPath) as! RecentsCell
        cell.contentView.transform = CGAffineTransform (scaleX: 1,y: -1);
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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func userButtonPressed(_ sender: Any) {
        
    }
    
    
    // New Transaction
    @IBAction func newTransactionBtn(_ sender: Any) {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy"
        let dateRes = formatter.string(from: date)
        
        let alertController = UIAlertController(title: "New Transaction", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter amount in INR"
            textField.keyboardType = .decimalPad
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Recipient"
        }
        
        let saveAction = UIAlertAction(title: "Process", style: .default, handler: { alert -> Void in
            let amountField = alertController.textFields![0] as UITextField
            let recipientField = alertController.textFields![1] as UITextField
            let amt = Double(amountField.text!) ?? 0.0
            let rec = recipientField.text
            
            let context = LAContext()
                var error: NSError?

                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Identify yourself!"

                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        [weak self] success, authenticationError in

                        DispatchQueue.main.async {
                            if success {
                                transactions[transactions.count] = [
                                    "Customer": "\(self!.userName ?? "")",
                                    "Amount": "6000",
                                    "Status": self!.checkStatus(amount: (amt*0.014)),
                                    "Recipient": String(rec!),
                                    "Date": "\(dateRes)"
                                ]
                                
                                self?.tableView.reloadData()
                            } else {
                                let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified. Please try again.", preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "Okay", style: .default))
                                self?.present(ac, animated: true)
                            }
                        }
                    }
                } else {
                    let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        tableView.reloadData()
    }
    
    
    // MARK: ML model to check validity
    func checkStatus(amount: Double) -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let minsToAdd = hour*60 + minutes + 480
        
        let model = Fraud_Detection_1()
        
        guard let statusOutput = try? model.prediction(Time: Double(minsToAdd), V1: Double.random(in: -36..<3), V2: Double.random(in: -60..<22), V3: Double.random(in: -33..<9), V4: Double.random(in: -5..<16), V5: Double.random(in: -42..<34), V6: Double.random(in: -26..<23), V7: Double.random(in: -36..<44), V8: Double.random(in: -50..<20), V9: Double.random(in: -13..<10), V10: Double.random(in: -22..<15), V11: Double.random(in: -4..<11), V12: Double.random(in: -18..<4), V13: Double.random(in: -4..<4), V14: Double.random(in: -19..<7), V15: Double.random(in: -5..<5), V16: Double.random(in: -13..<8), V17: Double.random(in: -24..<9), V18: Double.random(in: -10..<5), V19: Double.random(in: -9..<6), V20: Double.random(in: -28..<38), V21: Double.random(in: -22..<27), V22: Double.random(in: -9..<8), V23: Double.random(in: -36..<23), V24: Double.random(in: -2..<4), V25: Double.random(in: -3..<6), V26: Double.random(in: -2..<3), V27: Double.random(in: -9..<12), V28: Double.random(in: -11..<22), Amount: amount) else {
            fatalError("Unexpected runtime error.")
        }

        let status = statusOutput.Class_
        
        if(status == 0){
            let alert = CDAlertView(title: "Approved", message: "This transaction has been successfully processed.", type: .success)
            let doneAction = CDAlertViewAction(title: "Okay")
            alert.add(action: doneAction)
            alert.show()
            return "Approved"
        } else {
            let alert = CDAlertView(title: "Rejected", message: "This transaction has been flagged as possible fraud by the system.", type: .error)
            let doneAction = CDAlertViewAction(title: "Dismiss")
            alert.add(action: doneAction)
            alert.show()
            return "Rejected"
        }
    }
    
}
