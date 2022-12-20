//
//  CustomeTableViewCell.swift
//  tableVC custom cell
//
//  Created by Admin on 30/11/22.
//

import UIKit

class CustomeTableViewCell: UITableViewCell {
    
    lazy var titlelbl:UILabel = {
        let lbl = UILabel()
        
        lbl.font = UIFont.boldSystemFont(ofSize: 22)
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var notelbl:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.clear
   
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setupUI()
        
    }
    
    func setupUI(){
        
        
        let stackView = UIStackView(arrangedSubviews: [titlelbl,notelbl])
        stackView.axis = .vertical
        stackView.spacing = 5
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
    }

}
