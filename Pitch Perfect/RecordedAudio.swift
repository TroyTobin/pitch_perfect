//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Troy Tobin on 16/03/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.
//

import Foundation

/// This class stores information regarding a recoded audio file
class RecordedAudio: NSObject
{
    
    var filePathUrl: NSURL;
    var title: String;
    
    /// Initialise the RecordedAudio Class with a filePathUrl and a title
    ///
    /// :param: filePathUrl The path to the recorded audio
    /// :param: title The title of the recoded audio
    init(filePathUrl: NSURL,
         title: String)
    {
        self.filePathUrl = filePathUrl;
        self.title = title;
    }
}