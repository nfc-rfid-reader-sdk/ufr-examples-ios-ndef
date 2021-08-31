//
//  ViewController.swift
//  ndef-ios-nfc-ufr
//
//  Created by Digital Logic on 23/08/2021.
//

import UIKit
class DeviceViewController: UIViewController, UITextFieldDelegate {
    
    let color = UIColor(red: 143.0/255.0, green: 199.0/255.0, blue: 67.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var btnOpen: UIButton!
    @IBOutlet weak var chkAdvanced: DLRadioButton!
    @IBOutlet weak var imgDevice: UIImageView!
    @IBOutlet weak var btnAbout: UIButton!
    
    
    //reserved for readerOpenEx
    var readerTypeLabel: UILabel!
    var readerTypeText: UITextField!
    var portNameLabel: UILabel!
    var portNameText: UITextField!
    var portInterfaceLabel: UILabel!
    var portInterfaceText: UITextField!
    var openArgLabel: UILabel!
    var openArgText: UITextField!
    
    var readerOpened = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 270))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "header")
        imageView.image = image
        self.navigationItem.titleView = imageView
        
        chkAdvanced.isMultipleSelectionEnabled = true
        
        imgDevice.image = UIImage(named: "ufr_online")
        imgDevice.frame = CGRect(x: imgDevice.frame.minX, y: btnOpen.frame.maxY + 80, width: imgDevice.frame.width, height: imgDevice.frame.height)
        
        
        mainContentView.frame = CGRect(x: mainContentView.frame.minX, y: mainContentView.frame.minY, width: mainScrollView.frame.width - 80, height: btnAbout.frame.maxY + 10)
        
        self.mainScrollView.contentSize = mainContentView.bounds.size
        self.mainScrollView.autoresizingMask = .flexibleHeight
        
        btnOpen.addTarget(self, action: #selector(uFRReaderOpen), for: .touchUpInside)
        
        chkAdvanced.isEnabled = false
        
    }
    
    override func viewDidLayoutSubviews() {
        chkAdvanced.isEnabled = true
        chkAdvanced.isSelected = true
        onAdvancedClick(self)
    }
    
    @IBAction func onAdvancedClick(_ sender: Any) {
        if chkAdvanced.isSelected {
            
            readerTypeLabel = UILabel()
            readerTypeLabel.font = .systemFont(ofSize: 15)
            readerTypeLabel.text = "ENTER READER TYPE:"
            readerTypeLabel.frame = CGRect(x: btnOpen.frame.minX, y: btnOpen.frame.maxY, width: self.view.frame.width, height: 30)
            mainContentView.addSubview(readerTypeLabel)
            
            readerTypeText = UITextField()
            readerTypeText.frame = CGRect(x: btnOpen.frame.minX, y: readerTypeLabel.frame.maxY+10, width: mainContentView.frame.width, height: 40)
            readerTypeText.addBottomBorderWithColor(color: color, width: 1)
            
            readerTypeText.delegate = self
            readerTypeText.tag = 0
            mainContentView.addSubview(readerTypeText)
            
            portNameLabel = UILabel()
            portNameLabel.font = .systemFont(ofSize: 15)
            portNameLabel.text = "ENTER PORT NAME:"
            portNameLabel.frame = CGRect(x: btnOpen.frame.minX, y: readerTypeText.frame.maxY+10, width: mainContentView.frame.width, height: 30)
            mainContentView.addSubview(portNameLabel)
            
            portNameText = UITextField()
            portNameText.frame = CGRect(x: btnOpen.frame.minX, y: portNameLabel.frame.maxY+10, width: mainContentView.frame.width, height: 40)
            portNameText.addBottomBorderWithColor(color: color, width: 1)
            portNameText.delegate = self
            portNameText.tag = 1
            mainContentView.addSubview(portNameText)
            
            portInterfaceLabel = UILabel()
            portInterfaceLabel.font = .systemFont(ofSize: 15)
            portInterfaceLabel.text = "ENTER PORT INTERFACE:"
            portInterfaceLabel.frame = CGRect(x: btnOpen.frame.minX, y: portNameText.frame.maxY+10, width: mainContentView.frame.width, height: 30)
            mainContentView.addSubview(portInterfaceLabel)
            
            portInterfaceText = UITextField()
            portInterfaceText.frame = CGRect(x: btnOpen.frame.minX, y: portInterfaceLabel.frame.maxY+10, width: mainContentView.frame.width, height: 40)
            portInterfaceText.addBottomBorderWithColor(color: color, width: 1)
            portInterfaceText.delegate = self
            portInterfaceText.tag = 2
            mainContentView.addSubview(portInterfaceText)
            
            openArgLabel = UILabel()
            openArgLabel.font = .systemFont(ofSize: 15)
            openArgLabel.text = "ENTER ARGUMENT:"
            openArgLabel.frame = CGRect(x: btnOpen.frame.minX, y: portInterfaceText.frame.maxY+10, width: mainContentView.frame.width, height: 30)
            mainContentView.addSubview(openArgLabel)
            
            openArgText = UITextField()
            openArgText.frame = CGRect(x: btnOpen.frame.minX, y: openArgLabel.frame.maxY+10, width: mainContentView.frame.width, height: 40)
            openArgText.addBottomBorderWithColor(color: color, width: 1)
            openArgText.delegate = self
            openArgText.tag = 3
            mainContentView.addSubview(openArgText)
            
            imgDevice.frame = CGRect(x: imgDevice.frame.minX, y:openArgText.frame.maxY + 40, width: imgDevice.frame.width, height: imgDevice.frame.height)
            imgDevice.image = UIImage(named: "ufr_online")
            
            btnAbout.frame = CGRect(x: imgDevice.frame.minX + 50, y: imgDevice.frame.maxY + 30, width: btnAbout.bounds.width, height: btnAbout.bounds.height)

            mainContentView.frame = CGRect(x: mainContentView.frame.minX, y: mainContentView.frame.minY, width: view.safeAreaLayoutGuide.layoutFrame.width, height: btnAbout.frame.maxY + 10)
            
            self.mainScrollView.contentSize = mainContentView.bounds.size
            self.mainScrollView.autoresizingMask = .flexibleHeight
            
            
        } else {
            readerTypeLabel.removeFromSuperview()
            readerTypeText.removeFromSuperview()
            portNameLabel.removeFromSuperview()
            portNameText.removeFromSuperview()
            portInterfaceLabel.removeFromSuperview()
            portInterfaceText.removeFromSuperview()
            openArgLabel.removeFromSuperview()
            openArgText.removeFromSuperview()
            
            imgDevice.frame = CGRect(x: imgDevice.frame.minX, y: btnOpen.frame.maxY + 80, width: imgDevice.frame.width, height: imgDevice.frame.height)
            imgDevice.image = UIImage(named: "ufr_online")
            
            btnAbout.frame = CGRect(x: imgDevice.frame.minX + 50, y: imgDevice.frame.maxY + 30, width: btnAbout.bounds.width, height: btnAbout.bounds.height)
            
            mainContentView.frame = CGRect(x: mainContentView.frame.minX, y: mainContentView.frame.minY, width: mainScrollView.frame.width, height: imgDevice.frame.maxY + 10)
            
            self.mainScrollView.contentSize = mainContentView.bounds.size
            self.mainScrollView.autoresizingMask = .flexibleHeight
        }
    }
    
    
    @IBAction func onAboutClick(_ sender: Any) {
        
        if let url = URL(string: "https://www.d-logic.net/nfc-rfid-reader-sdk/wireless-nfc-reader-ufr-nano-online"){
            UIApplication.shared.open(url)
        }
    }
    
    @objc func uFRReaderOpen() {
        
        var status = UFR_READER_OPENING_ERROR
        
        var alert = UIAlertController(title: "Parameter error:", message: "wrong reader type input", preferredStyle: .alert)
        
        if (chkAdvanced.isSelected == false) {
            
                let failAlert = UIAlertController(title: "ReaderOpen() is currently not supported:", message: "Please use \"Advanced options\" to open uFR Online series reader.", preferredStyle: .alert)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    failAlert.dismiss(animated: true, completion: nil)
                }
                self.present(failAlert, animated: true, completion: nil)
            
        } else {
            
            let readerType = UInt32(readerTypeText.text!)
            if readerType == nil {
                alert.message = "Wrong reader type input!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    alert.dismiss(animated: true, completion: nil)
                }
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            let portName = portNameText.text
            var portInterface: UInt32?
            if (portInterfaceText.text == "T") {
                portInterface = 84
                
            } else if (portInterfaceText.text == "U") {
                portInterface = 85
                
            } else if (portInterfaceText.text == "L") {
                portInterface = 76
                
            } else {
                portInterface = UInt32(portInterfaceText.text!)
                
            }
            
            if portInterface == nil {
                alert.message = "Wrong port interface input!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    alert.dismiss(animated: true, completion: nil)
                }
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            for n in 1...5 {
                status = ReaderOpenEx(readerType!, portName, portInterface!, nil)
                
                if status == UFR_OK {
                    //ReaderUISignal(1, 1)
                    readerOpened = true
                    let strStatus = String(cString: UFR_Status2String(status))
                    alert = UIAlertController(title: "ReaderOpenEx was successful", message: "Status: \(strStatus)", preferredStyle: .alert)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        alert.dismiss(animated: true, completion: nil)
                    }
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                print("ReaderOpenEx() #\(n): \(status)")
                usleep(1000 * 100)
            }
            if (status != UFR_OK) {
                readerOpened = false
                let strStatus = String(cString: UFR_Status2String(status))
                let failAlert = UIAlertController(title: "ReaderOpenEx failed:", message: "Status: \(strStatus)", preferredStyle: .alert)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    failAlert.dismiss(animated: true, completion: nil)
                }
                self.present(failAlert, animated: true, completion: nil)
            }
            
        }
    }
}


extension DeviceViewController {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            mainScrollView.setContentOffset(CGPoint(x: 0, y: readerTypeLabel.frame.minY), animated: true)
            break
        case 1:
            mainScrollView.setContentOffset(CGPoint(x: 0, y: portNameLabel.frame.minY), animated: true)
            break
        case 2:
            mainScrollView.setContentOffset(CGPoint(x: 0, y: portInterfaceLabel.frame.minY), animated: true)
            break
        case 3:
            mainScrollView.setContentOffset(CGPoint(x: 0, y: openArgLabel.frame.minY), animated: true)
            break
        default:
            break
        }
        
    }
}
