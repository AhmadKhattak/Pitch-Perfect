//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by izran khan on 2017-10-04.
//  Copyright © 2017 Ahmad. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
   
    @IBOutlet weak var stopRecording: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecording.isEnabled=false;
    }

    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording Started ..."
        stopRecording.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.delegate = self
        audioRecorder.record()

        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingLabel.text = "Tap To Record"
        stopRecording.isEnabled = false
        recordButton.isEnabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
   
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording Failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
        let playSounds = segue.destination as!PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSounds.recordedAudioURL = recordedAudioURL
        }
    }
   
}

