//
//  LightControlViewController.swift
//  Light Power Meter
//
//  Created by Cole Smith on 6/10/16.
//  Copyright © 2016 Cole Smith. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class LightControlViewController: UIViewController {

    // MARK: - Class Properties
    
    @IBOutlet var switches: [UISwitch]!
    @IBOutlet var sliders: [UISlider]!
    
    @IBOutlet var purpleButtons: [UIButton]!
    @IBOutlet var yellowButtons: [UIButton]!
    @IBOutlet var redButtons: [UIButton]!
    
    let lightManager = LightControlManager.sharedManager
    
    let purple = LightControlManager.purple
    let yellow = LightControlManager.yellow
    let red =    LightControlManager.red
    let saturationConstant = LightControlManager.saturationConstant
    
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
        
        // Set all lights to default position
        for i in 1...3 {
            lightManager.setLightOn(i, lightOn: false)
            //lightManager.setLight(i, saturation: saturationConstant, brightness: 100, hue: 10000)
        }
    }
    
    // MARK: - Event Handlers
    
    @IBAction func switchFlipped(sender: AnyObject) {
        self.lightManager.setLightOn((sender.tag + 1), lightOn: (switches[sender.tag].on))
    }
    
    @IBAction func sliderDidChangeValue(sender: AnyObject) {
        let sliderVal = Int(sliders[sender.tag].value)
        self.lightManager.setLightBrightness((sender.tag + 1), brightness: sliderVal)
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        switch sender.tag {
        case 0,3,6:
            // Set light purple
            let lightVal = ((sender.tag / 3) + 1)
            self.lightManager.setLight(lightVal, saturation: saturationConstant, brightness: Int(sliders[lightVal - 1].value), hue: purple)
        case 1,4,7:
            // Set light yellow
            let lightVal = (((sender.tag + 1) / 3) + 1)
            self.lightManager.setLight(lightVal, saturation: saturationConstant, brightness: Int(sliders[lightVal - 1].value), hue: yellow)
        case 2,5,8:
            // Set light red
            let lightVal = ((sender.tag / 3) + 1)
            self.lightManager.setLight(lightVal, saturation: saturationConstant, brightness: Int(sliders[lightVal - 1].value), hue: red)
        default:
            print("[ ERR ] Light Value Not valid")
        }
    }
    
    @IBAction func resetPressed(sender: AnyObject) {
        self.lightManager.resetAllLights()
        for s in switches {
            s.on = true
        }
        for s in sliders {
            s.value = 255
        }
    }
    
    @IBAction func menuPressed(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
}
