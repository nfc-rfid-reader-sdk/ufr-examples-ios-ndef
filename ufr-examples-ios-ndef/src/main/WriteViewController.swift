//
//  WriteViewController.swift
//  ndef-ios-nfc-ufr
//
//  Created by Digital Logic on 30.08.2021
//

import UIKit

struct FunctionItem
{
    var image: UIImage
    var title: String
}

class WriteViewController: UIViewController {
    
    var functionTable = UITableView()
    
    var items = [FunctionItem]()
    
    
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
        
        items = fetchData()
        
        configureTableView()
    }
    
    func configureTableView()
    {
        view.addSubview(functionTable)
        setTableDelegates()
        functionTable.rowHeight = 50
        functionTable.register(FunctionCell.self, forCellReuseIdentifier: "FunctionCell")
        functionTable.pin(to: view)
        
    }
    
    func setTableDelegates()
    {
        functionTable.delegate = self
        functionTable.dataSource = self
    }
}


extension WriteViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = functionTable.dequeueReusableCell(withIdentifier: "FunctionCell") as! FunctionCell
        let fItem = items[indexPath.row]
        cell.set(functionItem: fItem )
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row)
        {
        case 0:
            //print("Wifi selected\n")
            performSegue(withIdentifier: "showWifiWrite", sender: self)
            break
        case 1:
            //print("URI selected")
            performSegue(withIdentifier: "showURIWrite", sender: self)
            break
        case 2:
            //print("Bluetooth selected")
            performSegue(withIdentifier: "showBluetoothWrite", sender: self)
            break
        case 3:
            //print("SMS selected")
            performSegue(withIdentifier: "showSMSWrite", sender: self)
            break
        case 4:
            //print("Location selected")
            performSegue(withIdentifier: "showLocationWrite", sender: self)
            break
        case 5:
            //print("Destination selected")
            performSegue(withIdentifier: "showDestinationWrite", sender: self)
            break
        case 6:
            //print("Email selected")
            performSegue(withIdentifier: "showEmailWrite", sender: self)
            break
        case 7:
            //print("Address selected")
            performSegue(withIdentifier: "showAddressWrite", sender: self)
            break
        case 8:
            //print("Application selected")
            performSegue(withIdentifier: "showApplicationWrite", sender: self)
            break
        case 9:
            //print("Text selected")
            performSegue(withIdentifier: "showTextWrite", sender: self)
            break
        case 10:
            //print("Streetview selected")
            performSegue(withIdentifier: "showStreetviewWrite", sender: self)
            break
        case 11:
            //print("Phone selected")
            performSegue(withIdentifier: "showPhoneWrite", sender: self)
            break
        case 12:
            //print("Contact selected")
            performSegue(withIdentifier: "showContactWrite", sender: self)
            break
        case 13:
            //print("Bitcoin selected")
            performSegue(withIdentifier: "showBitcoinWrite", sender: self)
            break
        case 14:
            //print("Skype selected")
            performSegue(withIdentifier: "showSkypeWrite", sender: self)
            break
        case 15:
            //print("Viber selected")
            performSegue(withIdentifier: "showViberWrite", sender: self)
            break
        case 16:
            //print("Whatsapp selected")
            performSegue(withIdentifier: "showWhatsappWrite", sender: self)
            break
        default:
            break
            
        }
        
        
    }
    
    
}

extension WriteViewController
{
    func fetchData() -> [FunctionItem]
    {
        let WifiItem = FunctionItem(image: UIImage(named: "wifi_icon")!, title: "WiFi")
        let UriItem = FunctionItem(image: UIImage(named: "uri_icon")!, title: "URI")
        let BlueToothItem = FunctionItem(image: UIImage(named: "bluetooth_icon")!, title: "Bluetooth")
        let SMSItem = FunctionItem(image: UIImage(named: "sms_icon")!, title: "SMS")
        let LocationItem = FunctionItem(image: UIImage(named: "geolocation_icon")!, title: "Location")
        let DestinationItem = FunctionItem(image: UIImage(named: "navi_icon")!, title: "Destination")
        let EmailItem = FunctionItem(image: UIImage(named: "email_icon")!, title: "Email")
        let AddressItem = FunctionItem(image: UIImage(named: "homeaddress_icon")!, title: "Address")
        let ApplicationItem = FunctionItem(image: UIImage(named: "androidapp_icon")!, title: "Application")
        let TextItem = FunctionItem(image: UIImage(named: "text_icon")!, title: "Text")
        let StreetviewItem = FunctionItem(image: UIImage(named: "streetview_icon")!, title: "StreetView")
        let PhoneItem = FunctionItem(image: UIImage(named: "phone_icon")!, title: "Phone")
        let ContactItem = FunctionItem(image: UIImage(named: "contact_icon")!, title: "Contact")
        let BitcoinItem = FunctionItem(image: UIImage(named: "bitcoin_icon")!, title: "Bitcoin")
        let SkypeItem = FunctionItem(image: UIImage(named: "skype2_icon")!, title: "Skype")
        let ViberItem = FunctionItem(image: UIImage(named: "viber_icon")!, title: "Viber")
        let WhatsappItem = FunctionItem(image: UIImage(named: "whatsapp2_icon")!, title: "Whatsapp")
        
        
        return [WifiItem, UriItem, BlueToothItem, SMSItem, LocationItem, DestinationItem, EmailItem, AddressItem, ApplicationItem, TextItem, StreetviewItem, PhoneItem, ContactItem, BitcoinItem, SkypeItem, ViberItem, WhatsappItem]
    }
}
