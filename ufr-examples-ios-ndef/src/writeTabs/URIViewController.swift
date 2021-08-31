//
//  WriteViewController.swift
//  ndef-ios-nfc-ufr
//
//  Created by Digital Logic on 30.08.2021
//

import UIKit
class URIViewController: UIViewController {
    
    @IBOutlet weak var txtUriIdentifers: UITextField!
    @IBOutlet weak var txtURIField: UITextField!
    @IBOutlet weak var storeInto: UISegmentedControl!
    
    var uri_identifier = 1
    
    var uriPicker = UIPickerView()
    
    let uriIdentifiers = ["N/A. No prepending", "http://www.", "https://www.", "http://", "https://", "tel:", "mailto:", "ftp://anonymous:anonymous@", "ftp://ftp.",
                          "ftps://", "sftp://", "smb://", "nfs://", "ftp://", "dav://", "news:", "telnet://", "imap:", "rtsp://", "urn:", "pop:",
                          "sip:", "sips:", "tftp:", "btspp://", "btl2cap://", "btgoep://", "tcpobex://", "irdaobex://", "file://", "urn:epc:id:",
                          "urn:epc:tag:", "urn:epc:pat:", "urn:epc:raw:", "urn:epc:", "urn:nfc:"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        uriPicker.delegate = self
        uriPicker.dataSource = self
        
        txtUriIdentifers.borderStyle = .none
        txtUriIdentifers.background = UIImage(named: "picker")
        txtUriIdentifers.inputView = uriPicker
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        txtURIField.delegate = self
        
        txtUriIdentifers.text = uriIdentifiers[1]
        
    }
    
    @IBAction func writeURI(_ sender: Any) {
        var alert = UIAlertController(title: "Parameter error:", message: "", preferredStyle: .alert)
        
        var status: UFR_STATUS = UFR_COMMUNICATION_BREAK
        
        let ndef_storage = storeInto.selectedSegmentIndex
        
        if (txtURIField.text == "")
        {
            alert.message = "Invalid URI Field input!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        var tnf: UInt8 = 1
        var type_record: UInt8 = 85 // 'U' - URI
        var type_length: UInt8 = 1
        var id_length: UInt8 = 0
        
        var card_formatted: UInt8 = 0
        
        var payload_length: UInt32 = 0
        
        let uri_field_array: [UInt8] = Array(txtURIField.text!.utf8)
        
        var payload_array = [UInt8](arrayLiteral: UInt8(uri_identifier))
        
        payload_array.append(contentsOf: uri_field_array)
        
        payload_length = UInt32(payload_array.count)
        
        var id = [UInt8](repeating: 0x00, count: 2)
        
        if (ndef_storage == 1) // write to Tag
        {
            status = write_ndef_record(1, &tnf, &type_record, &type_length, &id, &id_length, &payload_array, &payload_length, &card_formatted)
            
        } else
        {
            status = WriteEmulationNdef(tnf, &type_record, type_length, &id, id_length, &payload_array, UInt8(payload_length))
        }
        
        let strStatus = String(cString: UFR_Status2String(status))
        
        if (status == UFR_OK)
        {
            alert = UIAlertController(title: "Write URI NDEF was successful", message: "Status: \(strStatus)", preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        } else
        {
            alert = UIAlertController(title: "Write URI NDEF failed!", message: "Status: \(strStatus)", preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension URIViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return uriIdentifiers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return uriIdentifiers[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        txtUriIdentifers.text = uriIdentifiers[row]
        uri_identifier = row
        
        self.view.endEditing(true)
    }
}

extension URIViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
