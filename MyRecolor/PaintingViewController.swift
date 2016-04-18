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
    //MARK: Property
    var originImage:UIImage?
    var paintingImage:UIImage?

    var paletteView: PaletteView!
    
    weak var delegate : SaveImageDelegate?
    
    private var prompt = SwiftPromptsView()
    
    @IBOutlet weak var imageView: PaintingImageView!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    //MARK: IBAction
    @IBAction func refreshButtonTap(sender: UIButton) {
        initPrompt()
        prompt.setPromptHeader("重置")
        prompt.setPromptContentText("确定要重置这幅图片吗?重置后不可复原。")
        prompt.setPromptDismissIconVisibility(true)
        prompt.setPromptOutlineVisibility(true)
        prompt.setPromptHeaderTxtColor(UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0))
        prompt.setPromptOutlineColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0))
        prompt.setPromptDismissIconColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0))
        prompt.setPromptTopLineColor(UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0))
        prompt.setPromptBackgroundColor(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.67))
        prompt.setPromptBottomBarColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0))
        prompt.setMainButtonColor(UIColor.whiteColor())
        prompt.setMainButtonText("重置")
        
        self.view.addSubview(prompt)
    }
    @IBAction func taptap(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(imageView)
        imageView.buckerFill(point, replacementColor: paletteView.currentColor)
    }
    @IBAction func swipeToDismiss(sender: UISwipeGestureRecognizer) {
        self.delegate?.saveImage(imageView.image!)
        paletteView.hidePalette()
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
                self.initPrompt()
                self.prompt.setPromptHeader("太棒了")
                self.prompt.setPromptContentText("图片已经储存到系统相册")
                self.prompt.setPromptTopLineColor(UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0))
                self.prompt.setPromptBackgroundColor(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.67))
                self.prompt.setPromptBottomBarColor(UIColor(red: 34.0/255.0, green: 139.0/255.0, blue: 34.0/255.0, alpha: 0.67))
                self.prompt.setMainButtonColor(UIColor.whiteColor())
                self.prompt.setMainButtonText("好的")
                self.view.addSubview(self.prompt)

            } else {
                
            }
        }
    }
    //MARK: Init view
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
    //MARK: Zoomming
    private func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        imageScrollView.minimumZoomScale = minScale
        imageScrollView.maximumZoomScale = 4
        imageScrollView.zoomScale = minScale

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
//MARK: UIScrollView Delegate
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
//MARK: SwiftPrompts Delegate
extension PaintingViewController: SwiftPromptsProtocol{
    func initPrompt(){
        prompt = SwiftPromptsView(frame: self.view.bounds)
        prompt.delegate = self
        //Set the properties for the background
        prompt.setBlurringLevel(2.0)
        prompt.setPromptTopLineVisibility(true)
        prompt.setPromptBottomLineVisibility(false)
        prompt.setPromptBottomBarVisibility(true)
    }
    func clickedOnTheMainButton() {
        print("Clicked on the main button")
        if prompt.getPromptHeader() == "重置" {
            imageView.image = originImage
        }
        prompt.dismissPrompt()
    }
    
    func clickedOnTheSecondButton() {
        print("Clicked on the second button")
        prompt.dismissPrompt()
    }
    
    func promptWasDismissed() {
        print("Dismissed the prompt")
    }
}
