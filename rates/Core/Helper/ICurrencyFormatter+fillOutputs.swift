//
//  ICurrencyFormatter+fillOutputs.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 06/09/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import Foundation

extension ICurrencyFormatter {
    func formattOutputs(_ outputs: [OutputsSource], triggered: OutputsTriggered) {
        outputs.forEach({ (input) in
            if let output = triggered.0, output > 0.0, let rate = triggered.1.rates[input.1] {
                input.0.value = formatt(amount: rate * output, currency: input.1)
            } else {
                input.0.value = ""
            }
        })
    }
}
