//
//  ViewController.swift
//  DjApplication
//
//  Created by Anand Jain on 7/2/19.
//  Copyright © 2019 Arihant Jain. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //Left Side Variables
    @IBOutlet var TrackLeftVariable: UILabel!
    
    
    
    
    
    //Right Side Variables
    @IBOutlet var WaveformSliderRight: UISlider!
    @IBOutlet var BPMLabel: UILabel!
    @IBOutlet var TrackRightLabel: UILabel!
    @IBOutlet var ImageRightLabel: UIImageView!
    @IBOutlet var RightVinyl: UIImageView!
    @IBOutlet var RightWaveform: UIImageView!
    @IBOutlet var TrackRightSlider: DesignableSlider!{
        didSet {
            //Makes the TrackRightSlider verticle
            TrackRightSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Gives trackRight an empty audio file to start with
        do {
            trackRight = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "emptyaudio", ofType: "mp3")!))
            trackRight.prepareToPlay() }
        catch {
            print("error")
        }
        
        WaveformSliderRight.maximumValue = Float(trackRight.duration)
        WaveformSliderRight.value = 0
        
        //Loads right track data onto mainVC, Notification Catcher
        NotificationCenter.default.addObserver(forName: .loadRightTrackData, object: nil, queue: OperationQueue.main) { (notification) in
            //let SongSelectorVC = notification.object as! RightSongSelectionViewController
            self.BPMLabel.text = BPMTrackRight
            self.TrackRightLabel.text = songNameTrackRight
            self.ImageRightLabel.image = UIImage(named: songImageRight)
            self.RightWaveform.image = UIImage(named: waveformImageRight)
            self.WaveformSliderRight.maximumValue = Float(trackRight.duration)
            self.WaveformSliderRight.value = 0
            trackRight.volume = 0.5
        }
        
        //Loads left track data onto mainVC
            NotificationCenter.default.addObserver(forName: .loadLeftTrackData, object: nil, queue: OperationQueue.main) { (notification) in
            self.TrackLeftVariable.text = songNameTrackRight
        }
        
        //Sets attributes for the WaveformSliderRight
        WaveformSliderRight.setThumbImage(UIImage(named: "WaveformSlider"), for: .normal)
        
        //This is supposed to make the slider move as the song is playing, breaks build when outside loop
        Timer.scheduledTimer(timeInterval: 0.00001, target: self, selector: #selector(ViewController.updateWaveformSliderRight) , userInfo: nil, repeats: true)
    }
    
    //Plays and pauses the trackRight song
    @IBAction func playPause(_ sender: Any) {
        if (trackRight.isPlaying) {
            trackRight.pause()
            RightVinyl.stopRotating()
            ImageRightLabel.stopRotating()
        } else {
            trackRight.play()
            RightVinyl.startRotating()
            ImageRightLabel.startRotating()
            print("test")
        }
    }
    
    
    //Restarts the trackRight song but does not play it
    @IBAction func cueButton(_ sender: Any) {
        RightVinyl.stopRotating()
        ImageRightLabel.stopRotating()
        trackRight.stop()
        trackRight.currentTime = 0
        trackRight.pause()
    }
    
    //Controls the volume of trackRight with the slider
    @IBAction func controlTrackRightVolume(_ sender: Any) {
        trackRight.volume = TrackRightSlider.value
    }
    
    @IBAction func audioSlider(_ sender: Any) {
        if (trackRight.isPlaying == true) {
            trackRight.currentTime = TimeInterval(WaveformSliderRight.value)
            trackRight.prepareToPlay()
            trackRight.play()
        } else {
            trackRight.currentTime = TimeInterval(WaveformSliderRight.value)
            trackRight.prepareToPlay()
        }
    }
    
    //Makes sure that the waveform slider continuously moves
    @objc func updateWaveformSliderRight() {
        WaveformSliderRight.value = Float(trackRight.currentTime)
    }
    
}

