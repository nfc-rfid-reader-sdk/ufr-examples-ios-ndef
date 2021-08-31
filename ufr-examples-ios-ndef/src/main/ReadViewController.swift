//
//  WriteViewController.swift
//  ndef-ios-nfc-ufr
//
//  Created by Digital Logic on 30.08.2021
//

import UIKit
class ReadViewController: UIViewController {
    
    var gifView: UIImageView!
    var gifLabel: UILabel!
    let color = UIColor(red: 143.0/255.0, green: 199.0/255.0, blue: 67.0/255.0, alpha: 1.0)
    
    var imgTime = UIImageView()
    var lblTime = UILabel()
    
    var imgCardType = UIImageView()
    var lblCardType = UILabel()
    
    var imgUID = UIImageView()
    var lblUID = UILabel()
    
    var imgPayload = UIImageView()
    var btnPayload = UIButton()
    
    var card_type: UInt8 = 0
    var sak: UInt8 = 0
    var uid_size: UInt8 = 0
    
    var tnf: UInt8 = 0
    var type_record = [UInt8] (repeating: 0x00, count: 32)
    var type_length: UInt8 = 0
    var id = [UInt8] (repeating: 0x00, count: 128)
    var id_length: UInt8 = 0
    var payload = [UInt8](repeating: 0x00, count: 2048)
    var payload_length: UInt32 = 0
    
    
    var read_active = false
    var view_loaded = true
    override func viewWillDisappear(_ animated: Bool) {
        read_active = false
        
        self.gifView.removeFromSuperview()
        self.gifLabel.removeFromSuperview()
        
        self.imgTime.removeFromSuperview()
        self.lblTime.removeFromSuperview()
        
        self.imgCardType.removeFromSuperview()
        self.lblCardType.removeFromSuperview()
        
        self.imgUID.removeFromSuperview()
        self.lblUID.removeFromSuperview()
        
        self.imgPayload.removeFromSuperview()
        self.btnPayload.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var imageData = Data()
        imageData = try! Data(contentsOf: Bundle.main.url(forResource: "nfc_reading", withExtension: "gif")!)
        
        let gif = UIImage.gifImageWithData(imageData)
        
        gifView = UIImageView()
        gifView.frame = CGRect(x: 0, y: 100, width: self.view.safeAreaLayoutGuide.layoutFrame.width, height: 300)
        gifView.contentMode = .scaleAspectFit
        gifView.clipsToBounds = true
        gifView.image = gif
        
        gifLabel = UILabel()
        gifLabel.frame = CGRect(x: 0, y: gifView.frame.maxY + 60, width: self.view.safeAreaLayoutGuide.layoutFrame.width, height: 60)
        gifLabel.numberOfLines = 0
        gifLabel.font = .boldSystemFont(ofSize: 18)
        gifLabel.textColor = color
        gifLabel.textAlignment = .center
        
        gifLabel.text = "PUT NFC TAG ON THE READER"
        
        self.view.addSubview(gifView)
        self.view.addSubview(gifLabel)
        
        read_active = true
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1, execute: {
            self.waitForTag()
        })
    }
    
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
        
        btnPayload.addTarget(self, action: #selector(showPayloadDetails), for: .touchUpInside)
        
        view_loaded = true
    }
    
    func waitForTag()
    {
        var old_uid = [UInt8](repeating: 0x00, count: 10)
        while(read_active && view_loaded)
        {
            var sak: UInt8 = 0
            var uid_size: UInt8 = 0
            var uid = [UInt8](repeating: 0x00, count: 11)
            
            var status = GetCardIdEx(&sak, &uid, &uid_size)
            if (status == UFR_OK) && (uid.elementsEqual(old_uid) == false)
            {
                old_uid = uid.map { $0 }
                
                var ndef_message_cnt: UInt8 = 0
                var ndef_count: UInt8 = 0
                var ndef_record_array = [UInt8] (repeating: 0x00, count: 100)
                var empty_ndef_message_cnt: UInt8 = 0
                
               status = get_ndef_record_count(&ndef_message_cnt, &ndef_count, &ndef_record_array, &empty_ndef_message_cnt)
                if (status == UFR_OK) && (ndef_count != 0)
                {
                    for record_nr in 1...ndef_count
                    {
                        status = GetDlogicCardType(&card_type)
                        if (status == UFR_OK)
                        {
                            type_record = [UInt8] (repeating: 0x00, count: 32)
                            id = [UInt8] (repeating: 0x00, count: 128)
                            payload = [UInt8](repeating: 0x00, count: 2048)
                            
                            status = read_ndef_record(1, record_nr, &tnf, &type_record, &type_length, &id, &id_length, &payload, &payload_length)
                            print("read_ndef_record status: \(String(cString: UFR_Status2String(status)))")
                            if (status == UFR_OK)
                            {
                                DispatchQueue.main.sync {
                                    
                                    self.gifView.removeFromSuperview()
                                    self.gifLabel.removeFromSuperview()
                                    
                                    imgTime.frame = CGRect(x: 20, y: 20, width: 40, height: 40)
                                    imgTime.image = UIImage(named: "clock_icon")
                                    
                                    lblTime.frame = CGRect(x: imgTime.frame.maxX + 10, y: 20, width: self.view.frame.width - imgTime.frame.width, height: 40)
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "E, MMM d HH:mm:ss ZZZZ yyyy" //2021-08-27 12:57:33+0000
                                    dateFormatter.timeZone = TimeZone(identifier: "GMT")
                                    
                                    lblTime.text = dateFormatter.string(from: Date())
                                    
                                    imgCardType.frame = CGRect(x: 20, y: lblTime.frame.maxY + 10, width: 40, height: 40)
                                    imgCardType.image = UIImage(named: "card_icon")
                                    
                                    lblCardType.frame = CGRect(x: imgCardType.frame.maxX + 10, y: lblTime.frame.maxY + 10, width: self.view.frame.width - imgTime.frame.width, height: 40)
                                    lblCardType.text = DLCardTypeToString(card_type: Int32(card_type))
                                    
                                    imgUID.frame = CGRect(x: 20, y: lblCardType.frame.maxY + 10, width:40, height: 40)
                                    imgUID.image = UIImage(named: "uid_icon")
                                    
                                    lblUID.frame = CGRect(x: imgUID.frame.maxX + 10, y: lblCardType.frame.maxY + 10, width: self.view.frame.width - imgTime.frame.width, height: 40)
                                    lblUID.text = Array(uid.prefix(Int(uid_size))).hexa
                                    
                                    imgPayload.frame = CGRect(x: 20, y: lblUID.frame.maxY + 10, width: 40, height: 40)
                                    
                                    btnPayload.frame = CGRect(x: imgPayload.frame.maxX + 10, y: lblUID.frame.maxY + 10, width: self.view.frame.width - imgTime.frame.width, height: 40)
                                    btnPayload.setTitleColor(.black, for: .normal)
                                    btnPayload.contentHorizontalAlignment = .left
                                    
                                    
                                    let parsedPayload = String(cString: ParseNdefMessage(&type_record, type_length, &payload, payload_length))
                                    SetPayloadIcon(type: type_record, payloadStr: parsedPayload, rawPayloadStr: String(bytes: payload.prefix(Int(payload_length)), encoding: .ascii)!)
                                    
                                    self.view.addSubview(imgTime)
                                    self.view.addSubview(lblTime)
                                    
                                    self.view.addSubview(imgCardType)
                                    self.view.addSubview(lblCardType)
                                    
                                    self.view.addSubview(imgUID)
                                    self.view.addSubview(lblUID)
                                    
                                    self.view.addSubview(imgPayload)
                                    self.view.addSubview(btnPayload)
                                }
                            } else
                            {
                                old_uid = [UInt8](repeating: 0x00, count: 11)
                            }
                        } else
                        {
                            old_uid = [UInt8](repeating: 0x00, count: 11)
                        }
                    }
                } else
                {
                    old_uid = [UInt8](repeating: 0x00, count: 11)
                }
            } else if (status != UFR_OK)
            {
                old_uid = [UInt8](repeating: 0x00, count: 11)
            }
            usleep(250 * 1000)
        }
    }
    
    func SetPayloadIcon(type: [UInt8], payloadStr: String, rawPayloadStr: String)
    {
        if (type[0] == 85) // type == 'U'"
        {
            if (payloadStr.starts(with: "Bitcoin"))
            {
                imgPayload.image = UIImage(named: "bitcoin_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
                
            } else if (payloadStr.starts(with: "Address"))
            {
                imgPayload.image = UIImage(named: "address_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
                
            }  else if (payloadStr.starts(with: "Location"))
            {
                imgPayload.image = UIImage(named: "geolocation_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
                
            }  else if (payloadStr.starts(with: "StreetView"))
            {
                imgPayload.image = UIImage(named: "streetview_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
                
            }  else if (payloadStr.starts(with: "Destination"))
            {
                imgPayload.image = UIImage(named: "navi_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
                
            }  else if (payloadStr.starts(with: "Email"))
            {
                imgPayload.image = UIImage(named: "email_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
                
            }  else if (payloadStr.starts(with: "Username"))
            {
                imgPayload.image = UIImage(named: "skype2_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
                
            }  else if (payloadStr.starts(with: "Whatsapp"))
            {
                imgPayload.image = UIImage(named: "whatsapp_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
                
            }  else if (payloadStr.starts(with: "Viber"))
            {
                imgPayload.image = UIImage(named: "viber_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
                
            }  else if (payloadStr.starts(with: "Phone"))
            {
                if (payloadStr.contains("Message"))
                {
                    //SMS
                    imgPayload.image = UIImage(named: "sms_icon")
                    btnPayload.setTitle(payloadStr, for: .normal)
                } else
                {
                    //PHONE
                    imgPayload.image = UIImage(named: "phone_icon")
                    btnPayload.setTitle(payloadStr, for: .normal)
                    
                }
            } else //generic URI
            {
                imgPayload.image = UIImage(named: "uri_icon")
                btnPayload.setTitle(rawPayloadStr, for: .normal)
            }
        } else
        {
            if (payloadStr.starts(with: "SSID"))
            {
                imgPayload.image = UIImage(named: "wifi_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
            }  else if (payloadStr.starts(with: "Bluetooth"))
            {
                imgPayload.image = UIImage(named: "bluetooth_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
            }  else if (payloadStr.starts(with: "Package"))
            {
                imgPayload.image = UIImage(named: "androidapp_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
            }  else if (payloadStr.starts(with: "Text"))
            {
                imgPayload.image = UIImage(named: "text_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
            }  else if (payloadStr.starts(with: "BEGIN"))
            {
                imgPayload.image = UIImage(named: "contact_icon")
                btnPayload.setTitle(payloadStr, for: .normal)
            }
        }
        btnPayload.titleLabel?.lineBreakMode = .byCharWrapping
        btnPayload.sizeToFit()
    }
    
    func DLCardTypeToString(card_type: Int32) -> String
    {
        switch(card_type)
        {
        case TAG_UNKNOWN:
            return "TAG_UNKNOWN"
        case DL_MIFARE_ULTRALIGHT:
            return "DL_MIFARE_ULTRALIGHT"
        case DL_MIFARE_ULTRALIGHT_EV1_11:
            return "DL_MIFARE_ULTRALIGHT_EV1_11"
        case DL_MIFARE_ULTRALIGHT_EV1_21:
            return "DL_MIFARE_ULTRALIGHT_EV1_21"
        case DL_MIFARE_ULTRALIGHT_C:
            return "DL_MIFARE_ULTRALIGHT_C"
        case DL_NTAG_203:
            return "DL_NTAG_203"
        case DL_NTAG_210:
            return "DL_NTAG_210"
        case DL_NTAG_212:
            return "DL_NTAG_212"
        case DL_NTAG_213:
            return "DL_NTAG_213"
        case DL_NTAG_215:
            return "DL_NTAG_215"
        case DL_NTAG_216:
            return "DL_NTAG_216"
        case DL_MIKRON_MIK640D:
            return "DL_MIKRON_MIK640D"
        case NFC_T2T_GENERIC:
            return "NFC_T2T_GENERIC"
        case DL_NT3H_1101:
            return "DL_NT3H_1101"
        case DL_NT3H_1201:
            return "DL_NT3H_1201"
        case DL_NT3H_2111:
            return "DL_NT3H_2111"
        case DL_NT3H_2211:
            return "DL_NT3H_2211"
        case DL_NTAG_413_DNA:
            return "DL_NTAG_413_DNA"
        case DL_NTAG_424_DNA:
            return "DL_NTAG_424_DNA"
        case DL_NTAG_424_DNA_TT:
            return "DL_NTAG_424_DNA_TT"
        case DL_MIFARE_MINI:
            return "DL_MIFARE_MINI"
        case DL_MIFARE_CLASSIC_1K:
            return "DL_MIFARE_CLASSIC_1K"
        case DL_MIFARE_CLASSIC_4K:
            return "DL_MIFARE_CLASSIC_4K"
        case DL_MIFARE_PLUS_S_2K_SL0:
            return "DL_MIFARE_PLUS_S_2K_SL0"
        case DL_MIFARE_PLUS_S_4K_SL0:
            return "DL_MIFARE_PLUS_S_4K_SL0"
        case DL_MIFARE_PLUS_X_2K_SL0:
            return "DL_MIFARE_PLUS_X_2K_SL0"
        case DL_MIFARE_PLUS_X_4K_SL0:
            return "DL_MIFARE_PLUS_X_4K_SL0"
        case DL_MIFARE_DESFIRE:
            return "DL_MIFARE_DESFIRE"
        case DL_MIFARE_DESFIRE_EV1_2K:
            return "DL_MIFARE_DESFIRE_EV1_2K"
        case DL_MIFARE_DESFIRE_EV1_4K:
            return "DL_MIFARE_DESFIRE_EV1_4K"
        case DL_MIFARE_DESFIRE_EV1_8K:
            return "DL_MIFARE_DESFIRE_EV1_8K"
        case DL_MIFARE_DESFIRE_EV2_2K:
            return "DL_MIFARE_DESFIRE_EV2_2K"
        case DL_MIFARE_DESFIRE_EV2_4K:
            return "DL_MIFARE_DESFIRE_EV2_4K"
        case DL_MIFARE_DESFIRE_EV2_8K:
            return "DL_MIFARE_DESFIRE_EV2_8K"
        case DL_MIFARE_PLUS_S_2K_SL1:
            return "DL_MIFARE_PLUS_S_2K_SL1"
        case DL_MIFARE_PLUS_X_2K_SL1:
            return "DL_MIFARE_PLUS_X_2K_SL1"
        case DL_MIFARE_PLUS_EV1_2K_SL1:
            return "DL_MIFARE_PLUS_EV1_2K_SL1"
        case DL_MIFARE_PLUS_X_2K_SL2:
            return "DL_MIFARE_PLUS_X_2K_SL2"
        case DL_MIFARE_PLUS_S_2K_SL3:
            return "DL_MIFARE_PLUS_S_2K_SL3"
        case DL_MIFARE_PLUS_X_2K_SL3:
            return "DL_MIFARE_PLUS_X_2K_SL3"
        case DL_MIFARE_PLUS_EV1_2K_SL3:
            return "DL_MIFARE_PLUS_EV1_2K_SL3"
        case DL_MIFARE_PLUS_S_4K_SL1:
            return "DL_MIFARE_PLUS_S_4K_SL1"
        case DL_MIFARE_PLUS_X_4K_SL1:
            return "DL_MIFARE_PLUS_X_4K_SL1"
        case DL_MIFARE_PLUS_EV1_4K_SL1:
            return "DL_MIFARE_PLUS_EV1_4K_SL1"
        case DL_MIFARE_PLUS_X_4K_SL2:
            return "DL_MIFARE_PLUS_X_4K_SL2"
        case DL_MIFARE_PLUS_S_4K_SL3:
            return "DL_MIFARE_PLUS_S_4K_SL3"
        case DL_MIFARE_PLUS_X_4K_SL3:
            return "DL_MIFARE_PLUS_X_4K_SL3"
        case DL_MIFARE_PLUS_EV1_4K_SL3:
            return "DL_MIFARE_PLUS_EV1_4K_SL3"
        case DL_MIFARE_PLUS_SE_SL0:
            return "DL_MIFARE_PLUS_SE_SL0"
        case DL_MIFARE_PLUS_SE_SL1:
            return "DL_MIFARE_PLUS_SE_SL1"
        case DL_MIFARE_PLUS_SE_SL3:
            return "DL_MIFARE_PLUS_SE_SL3"
        case DL_UNKNOWN_ISO_14443_4:
            return "DL_UNKNOWN_ISO_14443_4"
        case DL_GENERIC_ISO14443_4:
            return "DL_GENERIC_ISO14443_4"
        case DL_GENERIC_ISO14443_4_TYPE_B:
            return "DL_GENERIC_ISO14443_4_TYPE_B"
        case DL_GENERIC_ISO14443_3_TYPE_B:
            return "DL_GENERIC_ISO14443_3_TYPE_B"
        case DL_MIFARE_PLUS_EV1_2K_SL0:
            return "DL_MIFARE_PLUS_EV1_2K_SL0"
        case DL_MIFARE_PLUS_EV1_4K_SL0:
            return "DL_MIFARE_PLUS_EV1_4K_SL0"
        case DL_IMEI_UID:
            return "DL_IMEI_UID"
        default:
            return "UNSUPPORTED_CARD_TYPE"
        }
    }
    
    @objc func showPayloadDetails()
    {
        performSegue(withIdentifier: "showPayloadDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPayloadDetails") {
            let newViewController = segue.destination as? ReadPayloadDetailsViewController
            
            newViewController!.show_tnf = self.tnf
            newViewController!.show_type_record = self.type_record
            newViewController!.show_type_length = self.type_length
            newViewController!.show_payload = self.payload
            newViewController!.show_payload_length = self.payload_length
        }
    }
    
    
}

