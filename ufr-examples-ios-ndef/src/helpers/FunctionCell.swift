//
//  FunctionCell.swift
//  ndef-ios-nfc-ufr
//
//  Created by bojan on 25.8.21..
//

import UIKit

class FunctionCell: UITableViewCell
{
    var functionImageView = UIImageView()
    var functionTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(functionImageView)
        addSubview(functionTitleLabel)
        
        configureImageView()
        configureTitleLabel()
        setImageConstraints()
        setTitleConstraints()
        
        //self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(functionItem: FunctionItem)
    {
        functionImageView.image = functionItem.image
        functionImageView.contentMode = .scaleAspectFit
        functionTitleLabel.text = functionItem.title
    }
    
    func configureImageView()
    {
        functionImageView.layer.cornerRadius = 10
        functionImageView.clipsToBounds = true
        functionImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    }
    
    func configureTitleLabel()
    {
        functionTitleLabel.numberOfLines = 0
        functionTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstraints()
    {
        functionImageView.translatesAutoresizingMaskIntoConstraints                                                 = false
        functionImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                 = true
        functionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive                                 = true
        functionImageView.heightAnchor.constraint(equalToConstant: 40).isActive                                     = true
        functionImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        
        
        
        
        
        
        
    }
    
    func setTitleConstraints()
    {
        functionTitleLabel.translatesAutoresizingMaskIntoConstraints                                                 = false
        functionTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                 = true
        functionTitleLabel.leadingAnchor.constraint(equalTo: functionImageView.trailingAnchor, constant: 20).isActive                                 = true
        functionTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive                                     = true
        functionTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive                = true
    }
}
