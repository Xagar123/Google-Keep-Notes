//
//  PhotoCollectionViewCell.swift
//  grid view
//
//  Created by Admin on 04/12/22.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "photoCell"
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var namelbl:UILabel = {
           let lbl = UILabel()
   
          lbl.font = UIFont.boldSystemFont(ofSize: 22)
          lbl.textAlignment = .left
          return lbl
     }()
   
   
       lazy var agelbl:UILabel = {
           let lbl = UILabel()
           lbl.textAlignment = .left
           lbl.numberOfLines = 0
   
           return lbl
       }()
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           contentView.addSubview(namelbl)
           contentView.addSubview(agelbl)
          // contentView.addSubview(imageView)
           
//           let images = [
//               UIImage(imageLiteralResourceName: "image1"),
//               UIImage(imageLiteralResourceName: "image1"),
//               UIImage(imageLiteralResourceName: "image1"),
//               UIImage(imageLiteralResourceName: "image1"),
//               UIImage(imageLiteralResourceName: "image1"),
//           ]
//           imageView.image = images.randomElement()
        namelbl.translatesAutoresizingMaskIntoConstraints = false
        namelbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        namelbl.topAnchor.constraint(equalTo: topAnchor,constant: 20).isActive = true
        namelbl.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        agelbl.translatesAutoresizingMaskIntoConstraints = false
        agelbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        agelbl.topAnchor.constraint(equalTo: namelbl.topAnchor, constant: 20).isActive = true
        agelbl.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
           // setupUI()
           // imageView.frame = contentView.bounds
        namelbl.frame = contentView.bounds
        agelbl.frame = contentView.bounds
        }
    
    override func prepareForReuse() {
            super.prepareForReuse()
           // imageView.image = nil
        }
    
}
