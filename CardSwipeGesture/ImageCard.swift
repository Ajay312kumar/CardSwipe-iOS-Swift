//
//  ImageCard.swift
//  CardSlider
//
//  Created by iPHTechnologies pvt ltd on 30/06/2023.
//  Copyright © 2023 iPHTechnologies pvt ltd. All rights reserved.
//

import UIKit

class ProfileImageCard: CustomProfileView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func addImage(imageName: String) {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(red: 67/255, green: 79/255, blue: 182/255, alpha: 1.0)
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        imageView.frame = CGRect(x: 12, y: 12, width: self.frame.width - 24, height: self.frame.height - 103)
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
