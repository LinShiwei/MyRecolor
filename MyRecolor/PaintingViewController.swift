//
//  ViewController.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/6.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

protocol SaveImageDelegate : class {
    func saveImage(image : UIImage)
}

class PaintingViewController: UIViewController {
    var paintingImage:UIImage?

    var paletteView: PaletteView!
    
    weak var delegate : SaveImageDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBAction func taptap(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(imageView)
        print("taptap point \(point)")
        imageView.buckerFill(point, replacementColor: paletteView.currentColor)
    }
    @IBAction func swipeToDismiss(sender: UISwipeGestureRecognizer) {
        self.delegate?.saveImage(imageView.image!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func swipeToSave(sender: UISwipeGestureRecognizer) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }
    }
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        dispatch_async(dispatch_get_main_queue()) {[unowned self] in
            if error == nil {
                let alert = UIAlertController(title: "Congratulations", message: "Save succeed!", preferredStyle: .Alert)
                let saveAction = UIAlertAction(title: "OK", style: .Default,handler: { (action:UIAlertAction) -> Void in
                    
                })
                alert.addAction(saveAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = paintingImage
        configurePaletteView()
        updateConstraintsForSize(view.bounds.size)

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScaleForSize(view.bounds.size)
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
    private func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        imageScrollView.minimumZoomScale = minScale
        imageScrollView.maximumZoomScale = 4
        imageScrollView.zoomScale = minScale
        print("zoomScale \(imageScrollView.zoomScale)")

    }
    private func updateConstraintsForSize(size: CGSize) {
        
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
}
extension PaintingViewController:UIScrollViewDelegate{
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            scrollView.scrollEnabled = false
        }else{
            scrollView.scrollEnabled = true
        }
        
    }
}

