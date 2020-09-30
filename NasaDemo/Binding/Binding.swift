//
//  Binding.swift
//  NasaDemo
//
//  Created by Mdo on 29/09/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import Foundation

import Foundation


class Observable<T>{
    
    var bind : (T)->() = {_ in}
    
    var value:T{
        
        didSet{
            bind(value)
            
        }
        
    }
    
    init(_ value:T){
        
        self.value = value
    }
    
}
