//
//  WriteViewController.swift
//  ndef-ios-nfc-ufr
//
//  Created by Digital Logic on 30.08.2021
//

import UIKit
class AddressViewController: UIViewController {
    
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var storeInto: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        txtAddress.delegate = self
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
    }
    
    @IBAction func writeAddress(_ sender: Any) {
        
        var alert = UIAlertController(title: "Parameter error:", message: "", preferredStyle: .alert)
        
        var status: UFR_STATUS = UFR_COMMUNICATION_BREAK
        
        let ndef_storage = storeInto.selectedSegmentIndex
        
        if (txtAddress.text == "")
        {
            alert.message = "Invalid Address input!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        status = WriteNdefRecord_Address(UInt8(ndef_storage), txtAddress.text)
        let strStatus = String(cString: UFR_Status2String(status))
        
        if (status == UFR_OK)
        {
            alert = UIAlertController(title: "Write Address NDEF was successful", message: "Status: \(strStatus)", preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        } else
        {
            alert = UIAlertController(title: "Write Address NDEF failed!", message: "Status: \(strStatus)", preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension AddressViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
