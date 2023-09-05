//
//  settingVC.swift
//  LookHeart 100
//
//  Created by Yeun-Ho Joung on 2021/09/05.
//

import UIKit
import Foundation


class settingVC : UIViewController {
    
    lazy var PotButton: UIButton = {
        let PotButton = UIButton()
        
        // Define the size of the button
        let width: CGFloat = 200
        let height: CGFloat = 80
        // Define coordinates to be placed.
        // (center of screen)
        
        let posX: CGFloat = self.view.bounds.width/2 - width/2
        let posY: CGFloat = self.view.bounds.height/4 - height/2
        // Set the button installation coordinates and size.
        
        PotButton.frame = CGRect(x: posX, y: posY, width: width, height: height)
        // Set the background color of the button.
        PotButton.backgroundColor = .blue
        // Round the button frame.
        PotButton.layer.masksToBounds = true
        // Set the radius of the corner.
        PotButton.layer.cornerRadius = 20.0
        // Set the title (normal).
        PotButton.setTitle("ECG Cal. Start", for: .normal)
        PotButton.setTitleColor(.white, for: .normal)
        PotButton.setTitle("ECG Cal. Start", for: .highlighted)
        PotButton.setTitleColor(.black, for: .highlighted)
        // Add an event
        PotButton.addTarget(self, action: #selector(PotButtonClick(_:)), for: .touchUpInside)
        return PotButton
        
    }()
    
    
    
    lazy var EcgButton: UIButton = {
        let EcgButton = UIButton()
        
        // Define the size of the button
        let width: CGFloat = 200
        let height: CGFloat = 80
        // Define coordinates to be placed.
        // (center of screen)
        
        let posX: CGFloat = self.view.bounds.width/2 - width/2
        let posY: CGFloat = (self.view.bounds.height * 2)/4 - height/2
        // Set the button installation coordinates and size.
        
        EcgButton.frame = CGRect(x: posX, y: posY, width: width, height: height)
        // Set the background color of the button.
        EcgButton.backgroundColor = .red
        // Round the button frame.
        EcgButton.layer.masksToBounds = true
        // Set the radius of the corner.
        EcgButton.layer.cornerRadius = 20.0
        // Set the title (normal).
        EcgButton.setTitle("ECG Signal Start", for: .normal)
        EcgButton.setTitleColor(.white, for: .normal)
        EcgButton.setTitle("ECG Signal Start", for: .highlighted)
        EcgButton.setTitleColor(.black, for: .highlighted)

        // Add an event
        EcgButton.addTarget(self, action: #selector(EcgButtonClick(_:)), for: .touchUpInside)
        return EcgButton
        
    }()
    
    
    lazy var PeakButton: UIButton = {
        let PeakButton = UIButton()
        
        // Define the size of the button
        let width: CGFloat = 200
        let height: CGFloat = 80
        // Define coordinates to be placed.
        // (center of screen)
        
        let posX: CGFloat = self.view.bounds.width/2 - width/2
        let posY: CGFloat = (self.view.bounds.height * 3)/4 - height/2
        // Set the button installation coordinates and size.
        
        PeakButton.frame = CGRect(x: posX, y: posY, width: width, height: height)
        // Set the background color of the button.
        PeakButton.backgroundColor = .magenta
        // Round the button frame.
        PeakButton.layer.masksToBounds = true
        // Set the radius of the corner.
        PeakButton.layer.cornerRadius = 20.0
        // Set the title (normal).
        PeakButton.setTitle("Peak Signal Start", for: .normal)
        PeakButton.setTitleColor(.white, for: .normal)
        PeakButton.setTitle("Peak Signal Start", for: .highlighted)
        PeakButton.setTitleColor(.black, for: .highlighted)

       
        
        PeakButton.addTarget(self, action: #selector(PeakButtonClick(_:)), for: .touchUpInside)
        return PeakButton
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.view.addSubview(self.PotButton)
        self.view.addSubview(self.EcgButton)
        self.view.addSubview(self.PeakButton)
       
        
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
    // Button event.
    @objc func PotButtonClick(_ sender: Any) {
        if sender is UIButton {
            
            NotificationCenter.default.post(name: NSNotification.Name("ECGPOT"), object: nil, userInfo: ["potCal":"c\n"])
            
        }
        
    }
    
    @objc func EcgButtonClick(_ sender: Any) {
        if sender is UIButton {
            
            NotificationCenter.default.post(name: NSNotification.Name("ECG"), object: nil, userInfo: ["ECG":"c\n"])
            
        }
        
    }
    
    @objc func PeakButtonClick(_ sender: Any) {
        if sender is UIButton {
            
            NotificationCenter.default.post(name: NSNotification.Name("Peak"), object: nil, userInfo: ["Peak":"c\n"])
            
        }
        
    }
    
}


