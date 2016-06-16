//
//  CalibrationViewController.swift
//  CameraTesting
//
//  Created by Cole Smith on 1/11/16.
//  Copyright © 2016 Cole Smith. All rights reserved.
//

import UIKit
import AVFoundation
import SlideMenuControllerSwift
import GPUImage

class CalibrationViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet var buttons: [UIButton]!
    
    // MARK: - Class Properties
    
    let ip = ImageProcessor.sharedProcessor
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in buttons {
            button.layer.cornerRadius = 40
            button.layer.masksToBounds = true
        }
        
        // Navigation Bar
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar?.shadowImage = UIImage()
        navBar?.backgroundColor = UIColor.clearColor()
        navBar?.translucent = true
        
        // Reticle
        self.view.addSubview(ip.generateReticle(self.view.frame))
    }
    
    override func viewWillAppear(animated: Bool) {
        self.ip.displayRawInputStream(self.view as! GPUImageView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.ip.stopCapture()
    }
    
    // MARK: - Actions
    
    @IBAction func menuPressed(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        let capturedColor: UIColor = self.ip.getColorFromPoint(CGPointMake(self.ip.pixelSize.width / 2, self.ip.pixelSize.height / 2))
        buttons[sender.tag].backgroundColor = capturedColor
        switch sender.tag {
        case 0:
            self.ip.red = capturedColor
        case 1:
            self.ip.yellow = capturedColor
        case 2:
            self.ip.purple = capturedColor
        default:
            print("[ ERR ]")
        }
    }
}
