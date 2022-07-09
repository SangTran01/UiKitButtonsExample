//
//  ViewController.swift
//  UiKitButtons
//
//  Created by Sang Tran on 2022-07-03.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var RecordLabel: UILabel!
    @IBOutlet var RecordButton: UIButton!
    @IBOutlet var StopRecordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        StopRecordButton.isEnabled = false
    }

    @IBAction func RecordAudio(_ sender: Any) {
        RecordLabel.text = "Recording..."
        RecordButton.isEnabled = false
        StopRecordButton.isEnabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))

            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
    }
    
    @IBAction func StopRecording(_ sender: UIButton) {
        RecordLabel.text = "Tap to Record"
        RecordButton.isEnabled = true
        StopRecordButton.isEnabled = false
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        print("Finished")
        if !flag {
            print("failed")
        } else {
            print(audioRecorder.url)
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let vc = segue.destination as! PlaySoundsViewController
            
            let url = sender as! URL
            vc.recordedSoundsURL = url
        }
    }
    
    
}

