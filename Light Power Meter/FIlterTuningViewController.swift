//
//  FilterTuningViewController.swift
//  Light Power Meter
//
//  Created by Cole Smith on 6/14/16.
//  Copyright © 2016 Cole Smith. All rights reserved.
//

import UIKit
import GPUImage

class FilterTuningViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var preview: GPUImageView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var sliders: [UISlider]!
    
    // MARK: - Class Properties
    
    private let ip = ImageProcessor.sharedProcessor
    
    // MARK: - Initalizers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Handlers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar?.shadowImage = UIImage()
        navBar?.backgroundColor = UIColor.clearColor()
        navBar?.translucent = true
        
        for label in labels {
            label.layer.masksToBounds = true
            label.layer.cornerRadius = label.frame.height
        }
        
        if let sen = ip.thresholdSensitivity {
            sliders[0].value = sen
            labels[1].text = String.localizedStringWithFormat("%.2f", sen)
        }
        if let lume = ip.lumeThreshold {
            sliders[1].value = Float(lume)
            labels[2].text = String.localizedStringWithFormat("%.2f", lume)
        }
        if let edge = ip.edgeTolerance {
            sliders[2].value = edge
            labels[3].text = String.localizedStringWithFormat("%.2f", edge)
        }
        if let rad = ip.closingPixelRadius {
            stepper.value = Double(rad)
            labels[0].text = "\(rad)"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        ip.filterInputStream(self.preview)
    }
    
    override func viewWillDisappear(animated: Bool) {
        ip.stopCapture()
    }
    
    // MARK: - Actions
    
    @IBAction func stepperChanged(sender: AnyObject) {
        self.ip.closingPixelRadius = UInt(stepper.value)
        labels[0].text = "\(UInt(stepper.value))"
    }
    
    @IBAction func menuPressed(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func slilderChanged(sender: AnyObject) {
        switch sender.tag {
        case 0:
            self.ip.thresholdSensitivity = sliders[0].value
            labels[1].text = String.localizedStringWithFormat("%.2f", sliders[0].value)
        case 1:
            self.ip.lumeThreshold = sliders[1].value
            labels[2].text = String.localizedStringWithFormat("%.2f", sliders[1].value)
            print(ip.lumeThreshold)
        case 2:
            self.ip.edgeTolerance = sliders[2].value
            labels[3].text = String.localizedStringWithFormat("%.2f", sliders[2].value)
        default:
            print("[ ERR ]")
        }
    }
}
