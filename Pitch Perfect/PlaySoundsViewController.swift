//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Troy Tobin on 11/03/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.
//

import UIKit
import AVFoundation

/// This class controls the view for playing and processing audio.
/// NOTE: majority of this code and structure has resulted from 
///       completing the "Intro to iOS App Development with Swift" 
///       Udacity course
class PlaySoundsViewController: UIViewController
{
  
  @IBOutlet weak var slowButton: UIButton!
  @IBOutlet weak var fastButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var chipmunkButton: UIButton!
  @IBOutlet weak var darthVaderButton: UIButton!
  
  var receivedAudio:RecordedAudio!
  var audioEngine:AVAudioEngine!
  var audioFile:AVAudioFile!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    audioEngine = AVAudioEngine()
    audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
  }
  
  /// Reset the button view selections
  func resetButtonViews()
  {
    slowButton.enabled       = true
    fastButton.enabled       = true
    chipmunkButton.enabled   = true
    darthVaderButton.enabled = true
    stopButton.enabled       = false
  }
  
  /// Reset the audio player and the button selection
  func resetAudio()
  {
    audioEngine.stop()
    audioEngine.reset()
  }
  
  override func viewWillAppear(animated: Bool) {
    resetButtonViews()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  /// Plays and audio stream with a specified pitch
  ///
  /// :param: pitch The value to set the audio pitch
  func playAudioWithVariablePitch(pitch: Float)
  {
    var audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)
    
    var changePitchEffect = AVAudioUnitTimePitch()
    changePitchEffect.pitch = pitch
    audioEngine.attachNode(changePitchEffect)
    
    audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
    audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    
    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    audioEngine.startAndReturnError(nil)

    audioPlayerNode.play()
  }
  
  /// Plays and audio stream with a specified speed
  ///
  /// :param: speed The value to set the audio speed
  func playAudioWithVariableSpeed(speed: Float)
  {
    var audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)
    
    // since we are changing the speed we need to balance out the pitch
    var changePitchEffect = AVAudioUnitTimePitch()
    if (1 < speed)
    {
      changePitchEffect.pitch = -500*speed;
    }
    else
    {
      changePitchEffect.pitch = 2000*speed;
    }
    
    // change the speed
    audioEngine.attachNode(changePitchEffect)
    
    var changeSpeedEffect = AVAudioUnitVarispeed()
    changeSpeedEffect.rate = speed
    audioEngine.attachNode(changeSpeedEffect)
    
    // Connect all the effects together
    audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
    audioEngine.connect(changePitchEffect, to: changeSpeedEffect, format: nil)
    audioEngine.connect(changeSpeedEffect, to: audioEngine.outputNode, format: nil)
    
    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    audioEngine.startAndReturnError(nil)
    
    audioPlayerNode.play()
  }
  
  /// Plays an audio stream at a slow rate (half speed)
  @IBAction func playSlow(sender: AnyObject)
  {
    resetAudio();
    
    slowButton.enabled       = false;
    fastButton.enabled       = true;
    chipmunkButton.enabled   = true;
    darthVaderButton.enabled = true;
    stopButton.enabled       = true;
    
    playAudioWithVariableSpeed(0.50);
  }
  
  /// Plays an audio stram at a fast rate (double speed)
  @IBAction func playFast(sender: AnyObject)
  {
    resetAudio();
    
    slowButton.enabled       = true;
    fastButton.enabled       = false;
    chipmunkButton.enabled   = true;
    darthVaderButton.enabled = true;
    stopButton.enabled       = true;
    
    playAudioWithVariableSpeed(2);
  }
  
  /// Plays an audio stream at a higher pitch to sound like a chupmunk
  @IBAction func playChipmunk(sender: AnyObject)
  {
    resetAudio()
    
    slowButton.enabled       = true;
    fastButton.enabled       = true;
    chipmunkButton.enabled   = false;
    darthVaderButton.enabled = true;
    stopButton.enabled       = true;
    
    playAudioWithVariablePitch(1000);
  }
  
  /// Plays an audio stream at a lower pitch to sound like Darth Vader
  @IBAction func playDarthVader(sender: AnyObject)
  {
    resetAudio()
    
    slowButton.enabled       = true;
    fastButton.enabled       = true;
    chipmunkButton.enabled   = true;
    darthVaderButton.enabled = false;
    stopButton.enabled       = true;
    
    playAudioWithVariablePitch(-1000);
  }
  
  /// Stops all audio
  @IBAction func stopAudio(sender: AnyObject)
  {
    resetAudio()
    resetButtonViews()
  }
}
