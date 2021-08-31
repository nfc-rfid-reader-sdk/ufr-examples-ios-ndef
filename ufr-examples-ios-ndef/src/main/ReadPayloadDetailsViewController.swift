//
//  WriteViewController.swift
//  ndef-ios-nfc-ufr
//
//  Created by Digital Logic on 30.08.2021
//

import UIKit
class ReadPayloadDetailsViewController: UIViewController {
    
    var show_tnf: UInt8 = 0
    var show_type_record = [UInt8] (repeating: 0x00, count: 32)
    var show_type_length: UInt8 = 0
    var show_payload = [UInt8](repeating: 0x00, count: 1024)
    var show_payload_length: UInt32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewDidLayoutSubviews() {
        let mainScrollView = UIScrollView()
        let contentView = UIView()
        
        let safe_width = view.safeAreaLayoutGuide.layoutFrame.width
        let safe_height = view.safeAreaLayoutGuide.layoutFrame.height
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: safe_width, height: safe_height)
        contentView.frame = CGRect(x: 0, y: 0, width: safe_width, height: safe_height)
        
        let lblPayloadDetails = UILabel()
        lblPayloadDetails.frame = CGRect(x: 20, y: 20, width: safe_width, height: 40)
        lblPayloadDetails.text = " PAYLOAD"
        lblPayloadDetails.font = UIFont.boldSystemFont(ofSize: 18)
        lblPayloadDetails.sizeToFit()
        
        contentView.addSubview(lblPayloadDetails)
        
        let lblPayloadLength = UILabel()
        lblPayloadLength.frame = CGRect(x: 20, y: lblPayloadDetails.frame.maxY + 10, width: safe_width, height: 40)
        lblPayloadLength.text = " Length: \(show_payload_length)"
        lblPayloadLength.font = UIFont.systemFont(ofSize: 16)
        lblPayloadLength.sizeToFit()
        
        contentView.addSubview(lblPayloadLength)
        
        let lblPayloadHex = UITextView()
        lblPayloadHex.frame = CGRect(x: 20, y: lblPayloadLength.frame.maxY + 5, width: safe_width - 20, height: 40)
        lblPayloadHex.text = "Hex: \(show_payload.prefix(Int(show_payload_length)).hexa)"
        lblPayloadHex.font = UIFont.systemFont(ofSize: 16)
        lblPayloadHex.sizeToFit()
        lblPayloadHex.isUserInteractionEnabled = false
        
        contentView.addSubview(lblPayloadHex)
        
        let lblPayloadASCII = UITextView()
        lblPayloadASCII.frame = CGRect(x: 20, y: lblPayloadHex.frame.maxY + 5, width: safe_width - 20, height: 40)
        lblPayloadASCII.text = "ASCII: \(String(bytes: show_payload.prefix(Int(show_payload_length)), encoding: .ascii)!)"
        lblPayloadASCII.font = UIFont.systemFont(ofSize: 16)
        lblPayloadASCII.sizeToFit()
        lblPayloadASCII.isUserInteractionEnabled = false
        
        contentView.addSubview(lblPayloadASCII)
        
        let lblTNF = UILabel()
        lblTNF.frame = CGRect(x: 20, y: lblPayloadASCII.frame.maxY + 5, width: safe_width - 20, height: 40)
        lblTNF.text = " TNF"
        lblTNF.font = UIFont.boldSystemFont(ofSize: 18)
        lblTNF.sizeToFit()
        
        contentView.addSubview(lblTNF)
        
        let lblTNFHex = UITextView()
        lblTNFHex.frame = CGRect(x: 20, y: lblTNF.frame.maxY + 5, width: safe_width - 20, height: 40)
        lblTNFHex.text = "Hex: \(String(format: "%X", show_tnf))"
        lblTNFHex.font = UIFont.systemFont(ofSize: 16)
        lblTNFHex.sizeToFit()
        lblTNFHex.isUserInteractionEnabled = false
        
        contentView.addSubview(lblTNFHex)
        
        let lblTNFDecimal = UITextView()
        lblTNFDecimal.frame = CGRect(x: 20, y: lblTNFHex.frame.maxY + 5, width: safe_width - 20, height: 40)
        lblTNFDecimal.text = "Decimal: \(show_tnf)"
        lblTNFDecimal.font = UIFont.systemFont(ofSize: 16)
        lblTNFDecimal.sizeToFit()
        lblTNFDecimal.isUserInteractionEnabled = false
        
        contentView.addSubview(lblTNFDecimal)
        
        let lblTypeDetails = UILabel()
        lblTypeDetails.frame = CGRect(x: 20, y: lblTNFDecimal.frame.maxY + 5, width: safe_width - 20, height: 40)
        lblTypeDetails.text = " TYPE"
        lblTypeDetails.font = UIFont.boldSystemFont(ofSize: 18)
        lblTypeDetails.sizeToFit()
        
        contentView.addSubview(lblTypeDetails)
        
        let lblTypeLength = UILabel()
        lblTypeLength.frame = CGRect(x: 20, y: lblTypeDetails.frame.maxY + 10, width: safe_width, height: 40)
        lblTypeLength.text = " Length: \(show_type_length)"
        lblTypeLength.font = UIFont.systemFont(ofSize: 16)
        lblTypeLength.sizeToFit()
        
        contentView.addSubview(lblTypeLength)
        
        let lblTypeHex = UITextView()
        lblTypeHex.frame = CGRect(x: 20, y: lblTypeLength.frame.maxY + 5, width: safe_width - 20, height: 40)
        lblTypeHex.text = "Hex: \(show_type_record.prefix(Int(show_type_length)).hexa)"
        lblTypeHex.font = UIFont.systemFont(ofSize: 16)
        lblTypeHex.sizeToFit()
        lblTypeHex.isUserInteractionEnabled = false
        
        contentView.addSubview(lblTypeHex)
        
        let lblTypeASCII = UITextView()
        lblTypeASCII.frame = CGRect(x: 20, y: lblTypeHex.frame.maxY + 5, width: safe_width - 20, height: 40)
        let type_ascii: String? = String(bytes: show_type_record, encoding: .ascii)
        lblTypeASCII.text = "ASCII: \(type_ascii!)"
        lblTypeASCII.font = UIFont.systemFont(ofSize: 16)
        lblTypeASCII.sizeToFit()
        lblTypeASCII.isUserInteractionEnabled = false
        
        contentView.addSubview(lblTypeASCII)
        
        contentView.frame = CGRect(x: contentView.frame.minX, y: contentView.frame.minY, width: mainScrollView.frame.width, height: lblTypeASCII.frame.maxY + 20)
        
        mainScrollView.contentSize = contentView.bounds.size
        mainScrollView.autoresizingMask = .flexibleHeight
        
        self.view.addSubview(mainScrollView)
        self.view.addSubview(contentView)
        
    }
    
}

