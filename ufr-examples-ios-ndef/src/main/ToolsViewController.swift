//
//  WriteViewController.swift
//  ndef-ios-nfc-ufr
//
//  Created by Digital Logic on 30.08.2021
//

import UIKit
class ToolsViewController: UIViewController {
    @IBOutlet weak var emulationSwitch: UISwitch!
    
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
    }
    @IBAction func onEmulationSwitchChange(_ sender: Any) {
        var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        var status: UFR_STATUS = UFR_COMMUNICATION_BREAK
        if (emulationSwitch.isOn)
        {
            status = TagEmulationStart()
            
            let strStatus = String(cString: UFR_Status2String(status))
            if (status != UFR_OK)
            {
                emulationSwitch.setOn(false, animated: true)
                alert = UIAlertController(title: "Tag emulation start failed!", message: "Status: \(strStatus)", preferredStyle: .alert)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    alert.dismiss(animated: true, completion: nil)
                }
            } else
            {
                emulationSwitch.setOn(true, animated: true)
                alert = UIAlertController(title: "Tag emulation start was successful!", message: "Status: \(strStatus)", preferredStyle: .alert)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
            
            self.present(alert, animated: true, completion: nil)
        } else
        {
            status = TagEmulationStop()
            
            let strStatus = String(cString: UFR_Status2String(status))
            if (status != UFR_OK)
            {
                alert = UIAlertController(title: "Tag emulation stop failed!", message: "Status: \(strStatus)", preferredStyle: .alert)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    alert.dismiss(animated: true, completion: nil)
                }
            } else
            {
                emulationSwitch.setOn(false, animated: true)
                alert = UIAlertController(title: "Tag emulation stop was successful!", message: "Status: \(strStatus)", preferredStyle: .alert)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func eraseTagClick(_ sender: Any) {
        
        var alert = UIAlertController(title: "Function error:", message: "", preferredStyle: .alert)
        
        let status = erase_all_ndef_records(UInt8(1))
        let strStatus = String(cString: UFR_Status2String(status))
        
        if (status == UFR_OK)
        {
            alert = UIAlertController(title: "Erase tag was successful", message: "Status: \(strStatus)", preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        } else
        {
            alert = UIAlertController(title: "Erase tag failed!", message: "Status: \(strStatus)", preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
