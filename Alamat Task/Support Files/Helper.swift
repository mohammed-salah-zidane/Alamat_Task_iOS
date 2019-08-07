//
//  Helper.swift
//  Alamat Task
//
//  Created by prog_zidane on 8/6/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
import  SwiftMessages
import  MapKit
func SuccessMessage(title:String,body:String){
    let success = MessageView.viewFromNib(layout: .cardView)
    success.configureTheme(.success)
    success.configureDropShadow()
    success.configureContent(title: title, body: body)
    let successConfig = SwiftMessages.defaultConfig
    success.button?.isHidden = true
    SwiftMessages.show(config: successConfig, view: success)
}
func WarningMessage(title:String,body:String){
    let warning = MessageView.viewFromNib(layout: .cardView)
    warning.configureTheme(.warning)
    warning.configureDropShadow()
    warning.configureContent(title: title, body: body)
    let warningConfig = SwiftMessages.defaultConfig
    warning.button?.isHidden = true
    SwiftMessages.show(config: warningConfig, view: warning)
    
}
func ErrorMessage(title:String,body:String){
    let error = MessageView.viewFromNib(layout: .cardView)
    error.configureTheme(.error)
    error.configureDropShadow()
    error.configureContent(title: title, body: body)
    let errorConfig = SwiftMessages.defaultConfig
    error.button?.isHidden = true
    SwiftMessages.show(config: errorConfig, view: error)
    
}
