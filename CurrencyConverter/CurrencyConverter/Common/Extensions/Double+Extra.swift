//
//  Double+Extra.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 01/06/23.
//

import Foundation

extension Double {
    //MARK: Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
