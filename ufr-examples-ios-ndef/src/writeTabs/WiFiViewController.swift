//
//  WriteViewController.swift
//  ndef-ios-nfc-ufr
//
//  Created by Digital Logic on 30.08.2021
//

import UIKit
class WiFiViewController: UIViewController {
    
    
    @IBOutlet weak var btnWriteWiFi: UIButton!
    @IBOutlet weak var storeInto: UISegmentedControl!
    @IBOutlet weak var txtSSID: UITextField!
    @IBOutlet weak var txtAuthentication: UITextField!
    @IBOutlet weak var txtEncryption: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var authenticationPicker = UIPickerView()
    var encryptionPicker = UIPickerView()
    
    var authenticationSelected = 0
    var encryptionSelected = 0
    
    let authData = ["OPEN", "WPA - Personal", "WPA - Enterprise", "WPA2 - Personal", "WPA2 - Enterprise"]
    let encData = ["None", "WEP", "TKIP", "AES", "AES/TKIP"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        authenticationPicker.delegate = self
        authenticationPicker.dataSource = self
        authenticationPicker.tag = 1
        
        encryptionPicker.delegate = self
        encryptionPicker.dataSource = self
        encryptionPicker.tag = 2
        
        txtAuthentication.borderStyle = .none
        txtEncryption.borderStyle = .none
        
        txtAuthentication.background = UIImage(named: "picker")
        txtEncryption.background = UIImage(named: "picker")
        
        txtAuthentication.inputView = authenticationPicker
        txtEncryption.inputView = encryptionPicker
        
        txtSSID.delegate = self
        txtPassword.delegate = self
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
    }
    
    @IBAction func writeWiFi(_ sender: Any) {
        
        var alert = UIAlertController(title: "Parameter error:", message: "", preferredStyle: .alert)
        
        var status: UFR_STATUS = UFR_COMMUNICATION_BREAK
        
        let ndef_storage = storeInto.selectedSegmentIndex
        
        if (txtSSID.text == "")
        {
            alert.message = "Invalid SSID name input!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if (txtAuthentication.text == "")
        {
            alert.message = "Invalid Authentication input!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if (txtEncryption.text == "")
        {
            alert.message = "Invalid Encryption input!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if (txtPassword.text == "")
        {
            alert.message = "Invalid Password input!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        status = WriteNdefRecord_WiFi(UInt8(ndef_storage), txtSSID.text, UInt8(authenticationSelected), UInt8(encryptionSelected), txtPassword.text)
        
        let strStatus = String(cString: UFR_Status2String(status))
        
        if (status == UFR_OK)
        {
            alert = UIAlertController(title: "Write WiFi NDEF was successful", message: "Status: \(strStatus)", preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        } else
        {
            alert = UIAlertController(title: "Write WiFi NDEF failed!", message: "Status: \(strStatus)", preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension WiFiViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1)
        {
            return authData.count
        } else
        {
            return encData.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1)
        {
            return authData[row]
        } else
        {
            return encData[row]
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (pickerView.tag == 1)
        {
            txtAuthentication.text = authData[row]
            authenticationSelected = row
        } else
        {
            txtEncryption.text = encData[row]
            encryptionSelected = 0
        }
        self.view.endEditing(true)
    }
}

extension WiFiViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
