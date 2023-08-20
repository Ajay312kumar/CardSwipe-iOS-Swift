//
//  CardView.swift
//  CardSlider
//
//  Created by iPHTechnologies pvt ltd on 30/06/2023.
//  Copyright © 2023 iPHTechnologies pvt ltd. All rights reserved.
//

import UIKit

public enum Reaction: String {
    case like = "like"
    case nope = "nope"
}

class CustomProfileView: UIView {
    
    var LikeLbl: CardViewLabel!
    var dislikeLbl: CardViewLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 79/255, green: 96/255, blue: 201/255, alpha: 1.0)
        self.layer.cornerRadius = 10
        let padding: CGFloat = 20
        
        LikeLbl = CardViewLabel(origin: CGPoint(x: padding, y: padding), color: UIColor(red: 102/255, green: 209/255, blue: 158/255, alpha: 1.0))
        LikeLbl.isHidden = true
        self.addSubview(LikeLbl)
        
        dislikeLbl = CardViewLabel(origin: CGPoint(x: frame.width - CardViewLabel.size.width - padding, y: padding), color: UIColor(red: 236/255, green: 137/255, blue: 134/255, alpha: 1.0))
        dislikeLbl.isHidden = true
        self.addSubview(dislikeLbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showOptionLabel(option: Reaction) {
        if option == .like {
            
            LikeLbl.text = option.rawValue
            
            // fade out redLabel
            if !dislikeLbl.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.dislikeLbl.alpha = 0
                }, completion: { (_) in
                    self.dislikeLbl.isHidden = true
                })
            }
            
            // fade in greenLabel
            if LikeLbl.isHidden {
                LikeLbl.alpha = 0
                LikeLbl.isHidden = false
                UIView.animate(withDuration: 0.2, animations: { 
                    self.LikeLbl.alpha = 1
                })
            }
            
        } else {
            
            dislikeLbl.text = option.rawValue
            
            
            // fade out greenLabel
            if !LikeLbl.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.LikeLbl.alpha = 0
                }, completion: { (_) in
                    self.LikeLbl.isHidden = true
                })
            }
            
            // fade in redLabel
            if dislikeLbl.isHidden {
                dislikeLbl.alpha = 0
                dislikeLbl.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.dislikeLbl.alpha = 1
                })
            }
        }
    }
    
    var isHidingOptionLabel = false
    
    func hideOptionLabel() {
        // fade out greenLabel
        if !LikeLbl.isHidden {
            if isHidingOptionLabel { return }
            isHidingOptionLabel = true
            UIView.animate(withDuration: 0.15, animations: {
                self.LikeLbl.alpha = 0
            }, completion: { (_) in
                self.LikeLbl.isHidden = true
                self.isHidingOptionLabel = false
            })
        }
        // fade out redLabel
        if !dislikeLbl.isHidden {
            if isHidingOptionLabel { return }
            isHidingOptionLabel = true
            UIView.animate(withDuration: 0.15, animations: {
                self.dislikeLbl.alpha = 0
            }, completion: { (_) in
                self.dislikeLbl.isHidden = true
                self.isHidingOptionLabel = false
            })
        }
    }

}

class CardViewLabel: UILabel {
    fileprivate static let size = CGSize(width: 120, height: 36)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textColor = .white
        self.font = UIFont.boldSystemFont(ofSize: 18)
        self.textAlignment = .center
        
        self.layer.cornerRadius = frame.height / 2
        self.layer.masksToBounds = true
        self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }
    
    convenience init(origin: CGPoint, color: UIColor) {
        
        self.init(frame: CGRect(x: origin.x, y: origin.y, width: CardViewLabel.size.width, height: CardViewLabel.size.height))
        self.backgroundColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
