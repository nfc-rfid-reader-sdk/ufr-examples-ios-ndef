//
//  WriteViewController.swift
//  ndef-ios-nfc-ufr
//
//  Created by Digital Logic on 30.08.2021
//

import UIKit
class ViberViewController: UIViewController {
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var storeInto: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        txtMessage.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func writeViber(_ sender: Any) {
        
        var alert = UIAlertController(title: "Parameter error:", message: "", preferredStyle: .alert)
        
        var status: UFR_STATUS = UFR_COMMUNICATION_BREAK
        
        let ndef_storage = storeInto.selectedSegmentIndex
        
        if (txtMessage.text == "")
        {
            alert.message = "Invalid Message input!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        status = WriteNdefRecord_Viber(UInt8(ndef_storage), txtMessage.text)
        let strStatus = String(cString: UFR_Status2String(status))
        
        if (status == UFR_OK)
        {
            alert = UIAlertController(title: "Write Viber NDEF was successful", message: "Status: \(strStatus)", preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        } else
        {
            alert = UIAlertController(title: "Write Viber NDEF failed!", message: "Status: \(strStatus)", preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

