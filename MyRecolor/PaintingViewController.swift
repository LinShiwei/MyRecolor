//
//  ViewController.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/6.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

protocol SaveImageDelegate : class {
    func saveImage(_ image : UIImage)
}

class PaintingViewController: UIViewController {
    //MARK: Property
    var originImage:UIImage?
    var paintingImage:UIImage?

    var paletteView: PaletteView!
    
    weak var delegate : SaveImageDelegate?
    
    fileprivate var prompt = PromptsView()
    
    @IBOutlet weak var imageView: PaintingImageView!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    //MARK: IBAction
    @IBAction func refreshButtonTap(_ sender: UIButton) {
        prompt = PromptsView(self.view.bounds, ofType: .assert, delegate: self)
        prompt.configureText("重置", contentText: "确定要重置这幅图片吗?重置后不可复原。", mainButtonText: "重置")
        self.view.addSubview(prompt)
    }
    @IBAction func tapToFill(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: imageView)
        imageView.buckerFill(point, replacementColor: paletteView.currentColor)
    }
    @IBAction func swipeToDismiss(_ sender: UISwipeGestureRecognizer) {
        self.delegate?.saveImage(imageView.image!)
        paletteView.hidePalette()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func swipeToSave(_ sender: UISwipeGestureRecognizer) {
        DispatchQueue.global().async{
            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(PaintingViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
//        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async{
//            
//        }
    }
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        DispatchQueue.main.async {[unowned self] in
            if error == nil {
                self.prompt = PromptsView(self.view.bounds, ofType: .information, delegate: self)
                self.prompt.configureText("太棒了", contentText: "图片已经储存到系统相册", mainButtonText: "好的")
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
    fileprivate func configurePaletteView(){
        guard let viewFromNib = Bundle.main.loadNibNamed("PaletteView", owner: self, options: nil)?.first as? PaletteView else{return}
        paletteView = viewFromNib
        paletteView.imageView = imageView
        view.addSubview(paletteView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: Zoomming
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        imageScrollView.minimumZoomScale = minScale
        imageScrollView.maximumZoomScale = 4
        imageScrollView.zoomScale = minScale

    }
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        
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
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            scrollView.isScrollEnabled = false
        }else{
            scrollView.isScrollEnabled = true
        }
    }
}
//MARK: SwiftPrompts Delegate
extension PaintingViewController: SwiftPromptsProtocol{
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
