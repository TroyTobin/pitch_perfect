//
//  RecordAudioViewController.swift
//  Pitch Perfect
//
//  Created by Troy Tobin on 10/03/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.
//

import UIKit
import AVFoundation

/// This class controls the view for recording audio.
/// NOTE: majority of this code and structure has resulted from
///       completing the "Intro to iOS App Development with Swift"
///       Udacity course
class RecordAudioViewController: UIViewController,
                                 AVAudioRecorderDelegate
{
  
  /// View elements to modify throughout the view lifecycle
  @IBOutlet weak var recordLabel:  UILabel!
  @IBOutlet weak var stopButton:   UIButton!
  @IBOutlet weak var recordButton: UIButton!
  
  /// Audio specifics
  var audioRecorder:AVAudioRecorder!
  var recordedAudio:RecordedAudio!
  
  /// No need to do anything extra once view loads
  override func viewDidLoad()
  {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(animated: Bool)
  {
    // Hide the stop button when the view loads
    stopButton.hidden = true;
    recordLabel.text = "Tap to record"
  }
  
  
  /// Record Audio started by UI event on Record Button
  @IBAction func recordAudio(sender: AnyObject)
  {
    // Make the recoding label and stop button visible when recording
    // and disable the recording button
    recordLabel.text = "Recording in progress";
    stopButton.hidden  = false;
    recordButton.enabled = false;
    
    
    // Create a new filename for the recorded file
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                                                      .UserDomainMask,
                                                      true)[0] as String
    
    let currentDate = NSDate()
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "ddMMyyyy-HHmmss"
    let recordingName = dateFormatter.stringFromDate(currentDate) + ".wav"
    let recordingFullPath = NSURL.fileURLWithPathComponents([dirPath, recordingName])

    
    // Record Audio
    var audioSession = AVAudioSession.sharedInstance()
    audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
    
    audioRecorder = AVAudioRecorder(URL: recordingFullPath,
                                    settings: nil,
                                    error: nil)
    audioRecorder.delegate = self
    audioRecorder.meteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
  }
  
  /// Stop the audio recording
  @IBAction func stopAudio(sender: AnyObject)
  {
    // Make the recoding stop button hidden and re-enable the record button
    stopButton.hidden  = true;
    recordButton.enabled = true;
    
    audioRecorder.stop()
    var audioSession = AVAudioSession.sharedInstance()
    audioSession.setActive(false, error: nil)
  }
  
  
  /// Send recorded file to Audio play sounds View
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!,
                          successfully flag: Bool)
  {
    if (true == flag)
    {
      // recording was successful so perform segue
      recordedAudio = RecordedAudio(filePathUrl: recorder.url,
        title: recorder.url.lastPathComponent!);
      
      self.performSegueWithIdentifier("stoppedRecording",
        sender: recordedAudio);
    }
    else
    {
      println("Error: Audio Recording was not successeful");
      recordButton.enabled = true;
      stopButton.hidden = true;
    }
  }
  
  /// About to segue, so set the recorded data on the play audio view controller
  override func prepareForSegue(segue: UIStoryboardSegue,
                                sender: AnyObject?)
  {
    if("stoppedRecording" == segue.identifier)
    {
      let playSoundsVC:PlaySoundsViewController =
      segue.destinationViewController as PlaySoundsViewController;
      
      let data = sender as RecordedAudio;
      playSoundsVC.receivedAudio = data;
    }
  }
  
}

