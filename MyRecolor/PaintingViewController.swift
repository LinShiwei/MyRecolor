//
//  ViewController.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/6.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class PaintingViewController: UIViewController {
    var paintingImage:UIImage?
    
    var paletteView: PaletteView!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = paintingImage
        configurePaletteView()
    }
    private func configurePaletteView(){
        guard let viewFromNib = NSBundle.mainBundle().loadNibNamed("PaletteView", owner: self, options: nil).first as? PaletteView else{return}
        paletteView = viewFromNib
        paletteView.imageView = imageView
        view.addSubview(paletteView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func taptap(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(imageView)
        imageView.buckerFill(point, replacementColor: paletteView.currentColor)
    }
    @IBAction func swipeToDismiss(sender: UISwipeGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

