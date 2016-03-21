//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Chris Garvey on 10/25/15.
//  Copyright © 2015 Chris Garvey. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
        
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var isRecording = false
    var hasStartedRecording = false
    
    let pauseImage = UIImage(named: "pause")
    let resumeImage = UIImage(named: "resume")
    let recordImage = UIImage(named: "microphone")
    
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.hidden = true
        recordingInProgress.text = "Tap to Record"
        recordButton.setImage(recordImage, forState: .Normal)
    }
    
    
    // MARK: - Actions
    
    @IBAction func recordAudio(sender: UIButton) {
        if isRecording == false && hasStartedRecording == false {
            stopButton.hidden = false
            recordingInProgress.text = "Recording... Tap Again to Pause"
            recordButton.setImage(pauseImage, forState: .Normal)
            hasStartedRecording = true
            isRecording = true
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
            let recordingName = "my_audio.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            print(filePath)
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } else if isRecording == true && hasStartedRecording == true {
            isRecording = false
            audioRecorder.pause()
            recordingInProgress.text = "Paused... Tap Again to Continue Recording"
            recordButton.setImage(resumeImage, forState: .Normal)
        } else if isRecording == false && hasStartedRecording == true {
            isRecording = true
            audioRecorder.record()
            recordingInProgress.text = "Recording... Tap Again to Pause"
            recordButton.setImage(pauseImage, forState: .Normal)
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        isRecording = false
        hasStartedRecording = false
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    // MARK: - Helper Function
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    
    // MARK: - Segue Method
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
}
