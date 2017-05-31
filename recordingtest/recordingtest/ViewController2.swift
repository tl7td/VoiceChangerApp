//
//  ViewController2.swift
//  recordingtest
//
//  Created by Tomas Lahm on 5/30/17.
//  Copyright © 2017 Tomas Lahm. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController2: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate  {

    @IBOutlet weak var high: UIButton!
    @IBOutlet weak var fast: UIButton!
    @IBOutlet weak var slow: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var deepBtn: UIButton!
    @IBOutlet weak var highBtn: UIButton!

    var receiveAudio: URL!
    var audioPlayer: AVAudioPlayer?
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var file: AVAudioFile!
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        do{
            file = try AVAudioFile(forReading: receiveAudio, commonFormat: AVAudioCommonFormat.pcmFormatFloat32, interleaved: false)
        } catch let error as NSError{
            fatalError("Error, \(error.localizedDescription)")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //
    //
    //
    @IBAction func stop(_ sender: Any) {
        audioPlayer?.pause()
    }
    //
    //
    //
    @IBAction func play(_ sender: Any) {
          //if audioRecorder?.isRecording == false {
          //stopButton.isEnabled = true
          //recordButton.isEnabled = false
        do {
            try audioPlayer = AVAudioPlayer(contentsOf:(receiveAudio))
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch let error as NSError {
            print("audioPlayer error: \(error.localizedDescription)")
            }
        }
    
    @IBAction func speedUp(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf:(receiveAudio))
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
            audioPlayer!.enableRate = true
            audioPlayer!.rate = 2.0
            audioPlayer!.play()
        } catch let error as NSError {
            print("audioPlayer error: \(error.localizedDescription)")
        }
    }

    @IBAction func slowDown(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf:(receiveAudio))
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
            audioPlayer!.enableRate = true
            audioPlayer!.rate = 0.5
            audioPlayer!.play() 
        } catch let error as NSError {
            print("audioPlayer error: \(error.localizedDescription)")
        }
    }
    
    //
    //
    //
    @IBAction func deepS(_ sender: Any) {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.stop()
        } else {
        pitchChange(value: -500, rateOrPitch: "Pitch")
        }
    }
    @IBAction func highS(_ sender: Any) {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.stop()
        } else {
        pitchChange(value: 1000, rateOrPitch: "Pitch")
        }
    }

    
    //
    //
    //
    
    public func pitchChange(value: Float, rateOrPitch: String){
        let audioPlayerNode = AVAudioPlayerNode()
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioEngine.attach(audioPlayerNode)
        
        let changeAudioUnitTime = AVAudioUnitTimePitch()
        
        if(rateOrPitch=="rate"){
            changeAudioUnitTime.rate = value
        } else {
            changeAudioUnitTime.pitch = value
        }
        
        audioEngine.attach(changeAudioUnitTime)
        audioEngine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        audioEngine.connect(changeAudioUnitTime, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(file, at: nil, completionHandler: nil)
    
        do{
            try audioEngine.start()
        } catch {
            print("Error")
        }
        audioPlayerNode.play()
    }
    
    
}
