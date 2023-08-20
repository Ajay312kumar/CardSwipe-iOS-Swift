//
//  ViewController.swift
//  CardSlider
//
//  Created by iPHTechnologies pvt ltd on 30/06/2023.
//  Copyright © 2023 iPHTechnologies pvt ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var profileArray = [ProfileImageCard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientLayer(self.view)
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        for i in 1...9 {
            let card = ProfileImageCard(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: self.view.frame.height * 0.6))
            card.addImage(imageName: "\(i)")
            profileArray.append(card)
        }
        layoutCards()
    }
    
    func addGradientLayer(_ gradientView: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        //ToDo
        gradientLayer.colors = [UIColor(red: 252/255, green: 53/255, blue: 76/255, alpha: 1.0).cgColor, UIColor(red: 10/255, green: 191/255, blue: 188/255, alpha: 1.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientView.layer.addSublayer(gradientLayer)
    }

    
    let cardAttributes: [(downscale: CGFloat, alpha: CGFloat)] = [(1, 1), (0.92, 0.8), (0.84, 0.6), (0.76, 0.4)]
    let cardInteritemSpacing: CGFloat = 15
    func layoutCards() {
        let firstCard = profileArray[0]
        self.view.addSubview(firstCard)
        firstCard.layer.zPosition = CGFloat(profileArray.count)
        firstCard.center = self.view.center
        firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleCardPan)))
        
        for i in 1...3 {
            if i > (profileArray.count - 1) { continue }
            
            let card = profileArray[i]
            
            card.layer.zPosition = CGFloat(profileArray.count - i)
           
            let downscale = cardAttributes[i].downscale
            let alpha = cardAttributes[i].alpha
            card.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            card.alpha = alpha
            card.center.x = self.view.center.x
            card.frame.origin.y = profileArray[0].frame.origin.y - (CGFloat(i) * cardInteritemSpacing)
            if i == 3 {
                card.frame.origin.y += 1.5
            }
            
            self.view.addSubview(card)
        }
        self.view.bringSubviewToFront(profileArray[0])
    }
    func showNextCard() {
        let animationDuration: TimeInterval = 0.2
        for i in 1...3 {
            if i > (profileArray.count - 1) { continue }
            let card = profileArray[i]
            let newDownscale = cardAttributes[i - 1].downscale
            let newAlpha = cardAttributes[i - 1].alpha
            UIView.animate(withDuration: animationDuration, delay: (TimeInterval(i - 1) * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                card.transform = CGAffineTransform(scaleX: newDownscale, y: newDownscale)
                card.alpha = newAlpha
                if i == 1 {
                    card.center = self.view.center
                } else {
                    card.center.x = self.view.center.x
                    card.frame.origin.y = self.profileArray[1].frame.origin.y - (CGFloat(i - 1) * self.cardInteritemSpacing)
                }
            }, completion: { (_) in
                if i == 1 {
                    card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleCardPan)))
                }
            })
            
        }
        if 4 > (profileArray.count - 1) {
            if profileArray.count != 1 {
                self.view.bringSubviewToFront(profileArray[1])
            }
            return
        }
        let newCard = profileArray[4]
        newCard.layer.zPosition = CGFloat(profileArray.count - 4)
        let downscale = cardAttributes[3].downscale
        let alpha = cardAttributes[3].alpha
        
        // initial state of new card
        newCard.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        newCard.alpha = 0
        newCard.center.x = self.view.center.x
        newCard.frame.origin.y = profileArray[1].frame.origin.y - (4 * cardInteritemSpacing)
        self.view.addSubview(newCard)
        UIView.animate(withDuration: animationDuration, delay: (3 * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            newCard.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            newCard.alpha = alpha
            newCard.center.x = self.view.center.x
            newCard.frame.origin.y = self.profileArray[1].frame.origin.y - (3 * self.cardInteritemSpacing) + 1.5
        }, completion: { (_) in
            
        })
        self.view.bringSubviewToFront(self.profileArray[1])
        
    }
    func removeOldFrontCard() {
        profileArray[0].removeFromSuperview()
        profileArray.remove(at: 0)
    }
    var dynamicAnimator: UIDynamicAnimator!
    var cardAttachmentBehavior: UIAttachmentBehavior!
    
    /// This method handles the swiping gesture on each card and shows the appropriate emoji based on the card's center.
    @objc func handleCardPan(sender: UIPanGestureRecognizer) {
        // if we're in the process of hiding a card, don't let the user interace with the cards yet
        if cardIsHiding { return }
        // change this to your discretion - it represents how far the user must pan up or down to change the option
        let optionLength: CGFloat = 60
        // distance user must pan right or left to trigger an option
        let requiredOffsetFromCenter: CGFloat = 15
        
        let panLocationInView = sender.location(in: view)
        let panLocationInCard = sender.location(in: profileArray[0])
        switch sender.state {
        case .began:
            dynamicAnimator.removeAllBehaviors()
            let offset = UIOffset(horizontal: panLocationInCard.x - profileArray[0].bounds.midX, vertical: panLocationInCard.y - profileArray[0].bounds.midY);
            // card is attached to center
            cardAttachmentBehavior = UIAttachmentBehavior(item: profileArray[0], offsetFromCenter: offset, attachedToAnchor: panLocationInView)
            dynamicAnimator.addBehavior(cardAttachmentBehavior)
        case .changed:
            cardAttachmentBehavior.anchorPoint = panLocationInView
            if profileArray[0].center.x > (self.view.center.x + requiredOffsetFromCenter) {
                if profileArray[0].center.y < (self.view.center.y - optionLength) {
                    profileArray[0].showOptionLabel(option: .like)
                    
                } else if profileArray[0].center.y > (self.view.center.y + optionLength) {
                    profileArray[0].showOptionLabel(option: .like)
                } else {
                    profileArray[0].showOptionLabel(option: .like)
                }
            } else if profileArray[0].center.x < (self.view.center.x - requiredOffsetFromCenter) {
                if profileArray[0].center.y < (self.view.center.y - optionLength) {
                    profileArray[0].showOptionLabel(option: .nope)
                } else if profileArray[0].center.y > (self.view.center.y + optionLength) {
                    profileArray[0].showOptionLabel(option: .nope)
                } else {
                    profileArray[0].showOptionLabel(option: .nope)
                }
            } else {
                profileArray[0].hideOptionLabel()
            }
            
        case .ended:
            dynamicAnimator.removeAllBehaviors()
        default:
            break
        }
    }
    var cardIsHiding = false
    func hideFrontCard() {
        if #available(iOS 10.0, *) {
            var cardRemoveTimer: Timer? = nil
            cardRemoveTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (_) in
                guard self != nil else { return }
                if !(self!.view.bounds.contains(self!.profileArray[0].center)) {
                    cardRemoveTimer!.invalidate()
                    self?.cardIsHiding = true
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                        self?.profileArray[0].alpha = 0.0
                    }, completion: { (_) in
                        self?.removeOldFrontCard()
                        self?.cardIsHiding = false
                    })
                }
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 1.5, options: [.curveEaseIn], animations: {
                self.profileArray[0].alpha = 0.0
            }, completion: { (_) in
                self.removeOldFrontCard()
            })
        }
    }
}


