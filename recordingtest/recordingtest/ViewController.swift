//
//  ViewController.swift
//  recordingtest
//
//  Created by Tomas Lahm on 5/30/17.
//  Copyright © 2017 Tomas Lahm. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //playButton.isEnabled = false
        //stopButton.isEnabled = false
        
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func recordAudio(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            //playButton.isEnabled = false
            //stopButton.isEnabled = true
            audioRecorder?.record()
        }
    }

    @IBAction func stopAudio(_ sender: Any) {
        stopButton.isEnabled = false
        //playButton.isEnabled = true
        recordButton.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
        //performSegue(withIdentifier: "Stop", sender: stopButton )

    }
    
    //@IBAction func playAudio(_ sender: Any) {
      //  if audioRecorder?.isRecording == false {
          //  stopButton.isEnabled = true
          //  recordButton.isEnabled = false
          //
          //  do {
          //      try audioPlayer = AVAudioPlayer(contentsOf:
          //          (audioRecorder?.url)!)
          //      audioPlayer!.delegate = self
          //      audioPlayer!.prepareToPlay()
         //       audioPlayer!.play()
        //    } catch let error as NSError {
       //         print("audioPlayer error: \(error.localizedDescription)")
      //      }
     //   }
    //}
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("About to go")
        if(segue.identifier == "Stop"){
            let pitchVC:ViewController2 = segue.destination as! ViewController2
            pitchVC.receiveAudio = (audioRecorder?.url)!
        }
    }

}

