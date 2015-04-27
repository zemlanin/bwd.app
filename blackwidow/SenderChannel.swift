//
//  SenderChannel.swift
//  blackwidow
//
//  Created by Anton Verinov on 27.04.15.
//  Copyright (c) 2015 ifelse. All rights reserved.
//

import Foundation

class SenderChannel: GCKCastChannel {
    override func didReceiveTextMessage(message: String!) {
        println(message)
    }
}
