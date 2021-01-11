//
//  ViewController.swift
//  TechnicalChallengeCC
//
//  Created by Hasan Qasim on 11/1/21.
//

import UIKit
import Firebase

class SinViewController: UIViewController {

    @IBOutlet weak var sinView: SinView!
    
    var LastLocationUpdateTextLayer: CATextLayer?
    var currentElectricityPriceLayer: CATextLayer?
    
    var timer: Timer?
    
    var flag = true
    var period: CGFloat = 0
    
    var count = 0
    var round = 0
    
    var hoursCounter = 9
    var minutesCounter = 0
    
    var isDayShift = true
    
    var labelArray = [UILabel]()
    
    var electrictyObjArr = [Electricity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.addSubview(sinView)
        self.sinView.backgroundColor = .black
        
        addAllXAxisLabelsToView(merediesA: "AM", merediesB: "PM")
        addAllYAxisLabelsToView()
        
        LastLocationUpdateTextLayer = createTextLayer(text: "Last Location at: 09:00am(Now)", x: 480, y: 16)
        currentElectricityPriceLayer = createTextLayer(text: "Current Electricty Price: $50", x: 16, y: 16)
        if let layer = LastLocationUpdateTextLayer, let electrictyPriceLayer = currentElectricityPriceLayer {
            self.sinView.layer.addSublayer(layer)
            self.sinView.layer.addSublayer(electrictyPriceLayer)
        }
        
        startTimer()
        authenticate()
        
       
    }
}

//MARK: Location tracking business logic code
extension SinViewController {
    
    func startTimer() {
        self.round += 1
        print("ROUND ---------------- \(round)")
        let timer = Timer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
    }
    
    func stopTimer() {
        self.count = 0
        self.flag = true
        self.timer?.invalidate()
        self.timer = nil
        
        if self.round == 12 {
            self.isDayShift = self.isDayShift ? false : true
        }
        
        if self.round < 12 {
            startTimer()
        } else if self.round == 12 {
            changeShift()
        }
    }
    
    @objc func updateTimer() {
        updateTextLayer()
        self.count += 1
        self.minutesCounter += 1
        
        if self.flag {
            if self.isDayShift {
                self.period = generatePeriod(for: 1.5)
            } else {
                self.period = generatePeriod(for: 1)
            }
        }
        
        sinView.periods += self.period
        
        if count == 60 {
            updateTimeCounters()
            stopTimer()
        }
    }
    
    func updateTimeCounters() {
        self.minutesCounter = 0
        self.hoursCounter = self.hoursCounter < 12 ? self.hoursCounter + 1 : 1
    }
        
    func generatePeriod(for value: CGFloat) -> CGFloat {
        self.flag = false
        let periodOne: CGFloat = value/60
        sinView.frequency = value
        return periodOne
    }
    
    func changeShift() {
        sinView.periods = 0
        self.round = 0
        startTimer()
        if self.isDayShift {
            updateLabels(merediesA: "PM", merediesB: "AM")
        } else {
            updateLabels(merediesA: "AM", merediesB: "PM")
        }
    }
    
}

//MARK: UI code
extension SinViewController {
    
    func createXAxisLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = label.font.withSize(14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    func addXAxisLabelConstraints(label: UILabel, constant: CGFloat) {
        self.sinView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 40).isActive = true
        label.leadingAnchor.constraint(equalTo: self.sinView.leadingAnchor, constant: constant).isActive = true
        label.bottomAnchor.constraint(equalTo: self.sinView.bottomAnchor, constant: -12).isActive = true
    }
    
    func createYAxisLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = label.font.withSize(12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    func addYAxisLabelConstraints(label: UILabel, constant: CGFloat) {
        self.sinView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 60).isActive = true
        label.leadingAnchor.constraint(equalTo: self.sinView.leadingAnchor, constant: 0).isActive = true
        label.topAnchor.constraint(equalTo: self.sinView.topAnchor, constant: constant).isActive = true
    }
    
    func createTextLayer(text: String, x: CGFloat, y: CGFloat) -> CATextLayer {
        let width = self.sinView.frame.width/4
        let height = self.sinView.frame.height
       
        
        let fontSize = min(width, height) / 10
        let offset = min(width, height) * 0.1
        
        let layer = CATextLayer()
        layer.string = text
        layer.foregroundColor = UIColor.white.cgColor
        layer.fontSize = fontSize
        layer.frame = CGRect(x: x, y: y, width: width+92, height: fontSize + offset - 16)
        layer.alignmentMode = .center
        return layer
    }
    
    func addAllXAxisLabelsToView(merediesA: String, merediesB: String) {
        let xAxisL1 = createXAxisLabel(text: "9\(merediesA)")
        addXAxisLabelConstraints(label: xAxisL1, constant: 48)
        labelArray.append(xAxisL1)
        
        let xAxisL2 = createXAxisLabel(text: "10\(merediesA)")
        addXAxisLabelConstraints(label: xAxisL2, constant: 104)
        labelArray.append(xAxisL2)
        
        let xAxisL3 = createXAxisLabel(text: "11\(merediesA)")
        addXAxisLabelConstraints(label: xAxisL3, constant: 164)
        labelArray.append(xAxisL3)
        
        let xAxisL4 = createXAxisLabel(text: "12\(merediesB)")
        addXAxisLabelConstraints(label: xAxisL4, constant: 224)
        labelArray.append(xAxisL4)
        
        let xAxisL5 = createXAxisLabel(text: "1\(merediesB)")
        addXAxisLabelConstraints(label: xAxisL5, constant: 284)
        labelArray.append(xAxisL5)
        
        let xAxisL6 = createXAxisLabel(text: "2\(merediesB)")
        addXAxisLabelConstraints(label: xAxisL6, constant: 344)
        labelArray.append(xAxisL6)
        
        let xAxisL7 = createXAxisLabel(text: "3\(merediesB)")
        addXAxisLabelConstraints(label: xAxisL7, constant: 404)
        labelArray.append(xAxisL7)
        
        let xAxisL8 = createXAxisLabel(text: "4\(merediesB)")
        addXAxisLabelConstraints(label: xAxisL8, constant: 464)
        labelArray.append(xAxisL8)
        
        let xAxisL9 = createXAxisLabel(text: "5\(merediesB)")
        addXAxisLabelConstraints(label: xAxisL9, constant: 524)
        labelArray.append(xAxisL9)
        
        let xAxisL10 = createXAxisLabel(text: "6\(merediesB)")
        addXAxisLabelConstraints(label: xAxisL10, constant: 584)
        labelArray.append(xAxisL10)
        
        let xAxisL11 = createXAxisLabel(text: "7\(merediesB)")
        addXAxisLabelConstraints(label: xAxisL11, constant: 644)
        labelArray.append(xAxisL11)
        
        let xAxisL12 = createXAxisLabel(text: "8\(merediesB)")
        addXAxisLabelConstraints(label: xAxisL12, constant: 704)
        labelArray.append(xAxisL12)
        
        let xAxisL13 = createXAxisLabel(text: "9\(merediesB)")
        addXAxisLabelConstraints(label: xAxisL13, constant: 764)
        labelArray.append(xAxisL13)
    }
    
    func addAllYAxisLabelsToView() {
        let tailGateLabel = createYAxisLabel(text: "Tail Gate")
        addYAxisLabelConstraints(label: tailGateLabel, constant: 56)
        let mainGateLabel = createYAxisLabel(text: "Main Gate")
        addYAxisLabelConstraints(label: mainGateLabel, constant: 342)
    }
    
    func updateTextLayer() {
        if let layer = LastLocationUpdateTextLayer {
            let meridiesString: String?
            let hourString = hoursCounter < 10 ? "0\(hoursCounter)" : "\(hoursCounter)"
            let minuteString = minutesCounter < 10 ? "0\(minutesCounter)" : "\(minutesCounter)"
            if self.isDayShift {
                meridiesString = hoursCounter > 8 && hoursCounter < 12 ? "am" : "pm"
            } else {
                meridiesString = hoursCounter > 8 && hoursCounter < 12 ? "pm" : "am"
            }
            layer.string = "Last Location at: \(hourString):\(minuteString)\(meridiesString!)(Now)"
        }
    }
    
    func updateElectricityPriceLayer() {
        if electrictyObjArr.count != 0 {
            let currentPrice = electrictyObjArr[electrictyObjArr.count-1].price
            if currentPrice > 60 {
                currentElectricityPriceLayer?.foregroundColor = UIColor.red.cgColor
            } else {
                currentElectricityPriceLayer?.foregroundColor = UIColor.green.cgColor
            }
            currentElectricityPriceLayer!.string = "Current Electricty Price: $\(currentPrice)"
        }
        
    }
    
    func updateLabels(merediesA: String, merediesB: String) {
        for i in 0...2 {
            labelArray[i].text = labelArray[i].text!.replacingOccurrences(of: merediesA, with: merediesB)
        }
        
        for i in 3...12 {
            labelArray[i].text = labelArray[i].text!.replacingOccurrences(of: merediesB, with: merediesA)
        }
    }

}

//MARK: Firebase Listener code
extension SinViewController {
    
    func authenticate() {
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase authentication failed")
            }
            self.setupFirebaseListener()
        }
    }
    
    func setupFirebaseListener() {
        Firestore.firestore().collection("Electricity").addSnapshotListener { querySnapshot, error in
            guard querySnapshot?.documents != nil else {
                print("error fetching documents: \(error!)")
                return
              }
            querySnapshot!.documentChanges.forEach { change in
                guard (change.document.data()["price"] != nil) else {
                    return
                }
                let price = change.document.data()["price"] as! Int
                self.electrictyObjArr.append(Electricity(price: price*10))
                self.updateElectricityPriceLayer()
            }
        }
    }
    
}


