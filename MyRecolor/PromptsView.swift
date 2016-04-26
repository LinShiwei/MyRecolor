//
//  PromptsView.swift
//  MyRecolor
//
//  Created by Linsw on 16/4/20.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
enum PromptsViewType {
    case Assert
    case Information
}
class PromptsView: SwiftPromptsView {

    convenience init(_ frame: CGRect, ofType type: PromptsViewType, delegate:SwiftPromptsProtocol){
        
        self.init(frame:frame)
        self.delegate = delegate
        setBlurringLevel(2.0)
        setPromptTopLineVisibility(true)
        setPromptBottomLineVisibility(false)
        setPromptBottomBarVisibility(true)
        switch type {
        case .Assert:
            configureAssertPromptsView()
        case .Information:
            configureInformationPromptsView()
        }
    }
    func configureText(header:String, contentText:String, mainButtonText:String){
        setPromptHeader(header)
        setPromptContentText(contentText)
        setMainButtonText(mainButtonText)
    }
    private func configureAssertPromptsView(){
        setPromptDismissIconVisibility(true)
        setPromptOutlineVisibility(true)
        setPromptHeaderTxtColor(UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0))
        setPromptOutlineColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0))
        setPromptDismissIconColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0))
        setPromptTopLineColor(UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0))
        setPromptBackgroundColor(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.67))
        setPromptBottomBarColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0))
        setMainButtonColor(UIColor.whiteColor())
    }
    private func configureInformationPromptsView(){
        setPromptTopLineColor(UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0))
        setPromptBackgroundColor(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.67))
        setPromptBottomBarColor(UIColor(red: 34.0/255.0, green: 139.0/255.0, blue: 34.0/255.0, alpha: 0.67))
        setMainButtonColor(UIColor.whiteColor())
    }

}
