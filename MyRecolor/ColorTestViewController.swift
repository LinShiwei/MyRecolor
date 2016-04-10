//
//  ColorTestViewController.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/10.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class ColorTestViewController: UIViewController {

    @IBOutlet weak var colorWell: ColorWell!
    @IBOutlet weak var colorPicker: ColorPicker!
    @IBOutlet weak var huePicker: HuePicker!
    var pickerController :ColorPickerController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        pickerController = ColorPickerController(svPickerView: colorPicker!, huePickerView: huePicker!, colorWell: colorWell!)
        pickerController!.color = UIColor.redColor()
        
        // get color:
        
        // get color updates:
        pickerController!.onColorChange = {(color, finished) in
            if finished {
                self.view.backgroundColor = UIColor.whiteColor() // reset background color to white
            } else {
                self.view.backgroundColor = color // set background color to current selected color (finger is still down)
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
