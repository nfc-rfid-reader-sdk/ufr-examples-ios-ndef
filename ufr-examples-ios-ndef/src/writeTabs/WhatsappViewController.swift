//
//  WriteViewController.swift
//  ndef-ios-nfc-ufr
//
//  Created by Digital Logic on 30.08.2021
//

import UIKit
class WhatsappViewController: UIViewController {
    
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var storeInto: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        txtMessage.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func writeWhatsapp(_ sender: Any) {
        
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
        
        status = WriteNdefRecord_Whatsapp(UInt8(ndef_storage), txtMessage.text)
        let strStatus = String(cString: UFR_Status2String(status))
        
        if (status == UFR_OK)
        {
            alert = UIAlertController(title: "Write Whatsapp NDEF was successful", message: "Status: \(strStatus)", preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        } else
        {
            alert = UIAlertController(title: "Write Whatsapp NDEF failed!", message: "Status: \(strStatus)", preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
