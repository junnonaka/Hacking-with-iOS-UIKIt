//
//  PersonCell.swift
//  Project10
//
//  Created by 野中淳 on 2022/12/11.
//

import UIKit

class CustomCell: UICollectionViewCell {
    //今回はImageVIewとLabelをセル内に置く
    let imageView = UIImageView()
    let name = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        imageView.image = UIImage(systemName: "person.fill")
        name.font = .systemFont(ofSize: 16)
        name.textAlignment = .center
    }
    
    func style(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout(){
        contentView.addSubview(imageView)
        contentView.addSubview(name)
        //好きな位置に配置
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            name.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            name.widthAnchor.constraint(equalToConstant: 120),
            name.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
}
