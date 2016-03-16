//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Chris Garvey on 10/30/15.
//  Copyright © 2015 Chris Garvey. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
