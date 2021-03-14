//
//  ContentView.swift
//  LazyCal
//
//  Created by Saivamsi Addagada on 2020-07-08.
//  Copyright © 2020 Saivamsi Addagada. All rights reserved.
//

import SwiftUI

enum CalButton {
    
    case zero, one, two, three, four, five, six, seven, eight, nine
    case equals, plus, minus, multiply, divide
    case ac, negative, decimal, tax, percent
    
    var title: String {
        switch self {
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .equals: return "="
        case .plus:  return "+"
        case .minus: return "-"
        case .multiply: return "x"
        case .divide: return "÷"
        case .negative: return "±"
        case .decimal: return "."
        case .tax: return "T"
        case .percent: return "%"
        default:
            return "AC"
        }
    }
}

class GlobalEnvironment: ObservableObject {
    
    @Published var display = ""
    @Published var message = ""
    
    var runningNumber = ""
    var negation = 0
    var firstValue = ""
    var secondValue = ""
    var fValue = 0.0
    var sValue = 0.0
    var numResult = 0.0
    var intResult = 0
    var result = ""
    var currentOperation = ""
    var equalCall = ""
    var operations = "% ÷ x - +"
    var percRand = Int.random(in: 1...10)
    var bedTime = -1
    var trigger = 0
    var check = 0
    var key = 0
    var timeKey = 0.0
    var timeKbac = 0.0
    var iter = 5
    var gradeview = 0
    var allRetorts = [String]()
    var gifFrames = [String]()
    var gifTimes = [2.1,2.24,1.96,1.7,1.8,1.47,1.2,1.41,1.44,0.96,6.0,2.88,1.92,1.25,
                    0.92,0.96,0.96,1.92,1.08,0.96,2.5,3.84,1.2,1.44,0.96,0.96,0.96,
                    1.92,1.84,1.92,2.0,0.68,2.50,1.92,0.96,1.92,0.96,1.0, 2.0, 2.0]
    
    func getFrames(int: Int) -> [String] {
        if let file = Bundle.main.url(forResource: String(int), withExtension: "txt", subdirectory: "GIFtxt") {
            if let content = try? String(contentsOf: file) {
                gifFrames = content.components(separatedBy: "\r")
            }
        }
        return gifFrames
    }
    
    func getGIF() {
        let x = Int.random(in: 1...38)
        key = x
        timeKey = gifTimes[key-1]
        timeKbac = timeKey
        getFrames(int: x)
    }
    
    func speedUp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if self.iter == 0 {
                self.check = -1
                self.getFrames(int: 39)
                self.timeKey = self.gifTimes[39-1]
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.getFrames(int: 40)
                    self.timeKey = self.gifTimes[40-1]
                    self.check = 0
                }
            }
            else {
                self.timeKey = self.timeKey - (self.timeKey * 0.1)
                self.iter = self.iter - 1
                self.speedUp()
            }
        }
    }

    func getRetorts() {
        if let textfile = Bundle.main.url(forResource: "retorts", withExtension: "txt") {
            if let retorts = try? String(contentsOf: textfile) {
                allRetorts = retorts.components(separatedBy: "\n")
            }
        }
        allRetorts.removeLast()
    }
    
    func typeOn(string: String) {
        self.message = ""
        let characterArray = Array(string)
        var characterIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            if characterArray[characterIndex] != "$" {
                while characterArray[characterIndex] == " " {
                    self.message = self.message + " "
                    characterIndex += 1
                    if characterIndex == characterArray.count {
                        timer.invalidate()
                        return
                    }
                }
                self.message = self.message + String(characterArray[characterIndex])
            }
            characterIndex += 1
            if characterIndex == characterArray.count {
                timer.invalidate()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            self.check = 0
        }
    }
        
    func getBedTime() {
        if percRand >= 9 {
            bedTime = Int.random(in: 11...15)
        }
        else if percRand >= 4  && percRand < 9 {
            bedTime = Int.random(in: 5...10)
        }
        else if percRand >= 2  && percRand < 4 {
            bedTime = Int.random(in: 1...4)
        }
        else {
            bedTime = 0
        }
    }
    
    func receiveInput(calButton: CalButton) {
        trigger = 0
        if bedTime == -1 {
            getBedTime()
            getRetorts()
        }
        if equalCall == "y" {
            allClear()
            equalCall = ""
        }
        if runningNumber.count <= 7 {
            runningNumber += calButton.title
            self.display = runningNumber
        }
    }
    
    func opCall(Operation: String) {
        if equalCall == "y" {
            currentOperation = Operation
            runningNumber = ""
            equalCall = ""
        }
        else if currentOperation == "" {
            firstValue = runningNumber
            fValue = Double(firstValue)!
            currentOperation = Operation
            runningNumber = ""
        }
        else {
            secondValue = runningNumber
            sValue = Double(secondValue)!
            if currentOperation == "+" {
                addCall()
            }
            else if currentOperation == "-" {
                subCall()
            }
            else if currentOperation == "x" {
                mulCall()
            }
            else if currentOperation == "÷" {
                divCall()
            }
            else if currentOperation == "%" {
                percCall()
            }
            if numResult.truncatingRemainder(dividingBy: 1) == 0 {
                intResult = Int(numResult)
                result = String(intResult)
            }
            else {
                result = String(numResult)
            }
            self.display = String(result.prefix(8))
            firstValue = result
            fValue = Double(firstValue)!
            secondValue = ""
            sValue = 0.0
            currentOperation = Operation
            runningNumber = ""
        }
    }
    
    
    func negCall(calButton: CalButton) {
        negation = Int(runningNumber)!
        
        runningNumber = String(negation * -1)
        self.display = runningNumber
    }
    
    func taxCall(calButton: CalButton) {
        firstValue = runningNumber
        fValue = Double(firstValue)!
        
        numResult = (fValue * 0.13) + fValue
        result = String(numResult)
        self.display = result
        runningNumber = result
    }
    
    func addCall() {
        numResult = fValue + sValue
    }
    
    func subCall() {
        numResult = fValue - sValue
    }
    
    func mulCall() {
        numResult = fValue * sValue
    }
    
    func divCall() {
        numResult = fValue / sValue
    }
    
    func percCall() {
        sValue = sValue / 100.0
        numResult = fValue * sValue
    }
    
    func resCall() {
        if bedTime != 0 {
            if currentOperation != "" && runningNumber != "" {
                opCall(Operation: currentOperation)
                equalCall = "y"
                runningNumber = " "
            }
            else {
                allClear()
            }
        }
        else {
            allClear()
            getGIF()
            trigger = -1
            check = -1
        }
        
    }
    
    func allClear() {
        runningNumber = ""
        negation = 0
        firstValue = ""
        secondValue = ""
        fValue = 0.0
        sValue = 0.0
        numResult = 0.0
        result = ""
        currentOperation = ""
        equalCall = ""
        self.display = ""
    }
    
}

struct ImageAnimated: UIViewRepresentable {
    
    // courtesy of Julio Bailon
    
    let imageSize: CGSize
    let imageNames: [String]
    let duration: Double

    func makeUIView(context: Self.Context) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0
            , width: imageSize.width, height: imageSize.height))

        let animationImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))

        animationImageView.clipsToBounds = true
        animationImageView.layer.cornerRadius = 5
        animationImageView.autoresizesSubviews = true
        animationImageView.contentMode = UIView.ContentMode.scaleAspectFill

        var images = [UIImage]()
        imageNames.forEach { imageName in
            if let img = UIImage(named: imageName) {
                images.append(img)
            }
        }

        animationImageView.image = UIImage.animatedImage(with: images, duration: duration)

        containerView.addSubview(animationImageView)

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<ImageAnimated>) {

    }
}

struct ContentView: View {
    
    @EnvironmentObject var env: GlobalEnvironment
    
    let buttons: [[CalButton]] = [
        [.ac, .tax, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .negative, .decimal, .equals]
    ]
    
    var body: some View {
        
        ZStack (alignment: .bottom) {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                
                HStack {
                    Spacer()
                    if self.env.gradeview == 0 {
                        if self.env.trigger == -1 {
                            Text(env.message).foregroundColor(.white)
                                .frame(width: 325.0, height: 95.0, alignment: .leading)
                                .font(Font.custom("Courier New", size: 15))
                                .offset(y:-95)
                                .offset(x: 65)
                                .padding()
                                
                           ImageAnimated(imageSize: CGSize(width: 125.0, height: 125.0), imageNames: self.env.gifFrames, duration: self.env.timeKey)
                                .frame(width: 125.0, height: 125.0)
                                .offset(x: -85)
                                .offset(y: 10)
                        }
                    }
                    else {
                        Text(env.message).foregroundColor(.white)
                        .frame(width: 325.0, height: 95.0, alignment: .leading)
                        .font(Font.custom("Courier New", size: 15))
                        .offset(y:-95)
                        .offset(x: 65)
                        .padding()
                        
                        ImageAnimated(imageSize: CGSize(width: 125.0, height: 125.0), imageNames: self.env.gifFrames, duration: self.env.timeKey)
                        .frame(width: 125.0, height: 125.0)
                        .offset(x: -85)
                        .offset(y: 10)
                    }
                    Text(env.display).foregroundColor(.white)
                        .font(.system(size: 55))
                        .offset(x: -5)
                }.padding()
                 .offset(y: 30)
                
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            
                            Button(action :{
                                if self.env.check != -1 {
                                    if Int(button.title) != nil || button.title == "." {
                                        self.env.receiveInput(calButton: button)
                                    }
                                    if button.title == "AC" {
                                        self.env.allClear()
                                    }
                                    if self.env.runningNumber != "" && button.title == "±" {
                                        self.env.negCall(calButton: button)
                                    }
                                    if self.env.runningNumber != "" && button.title == "T" {
                                        self.env.taxCall(calButton: button)
                                    }
                                    if self.env.runningNumber != "" && self.env.operations.contains(button.title) {
                                        self.env.opCall(Operation: button.title)
                                    }
                                    if button.title == "=" {
                                        self.env.resCall()
                                        if self.env.bedTime > 0 {
                                            self.env.bedTime = self.env.bedTime - 1
                                        }
                                        if self.env.trigger == -1 {
                                            self.env.typeOn(string: self.env.allRetorts.randomElement() ?? "NO")
                                        }
                                    }
                                }
                            }) {
                                if self.env.trigger == -1 {
                                    Text(button.title)
                                        .font(Font.custom("Courier New", size: 25))
                                        .frame(width: self.buttonWidth(), height: self.buttonWidth())
                                        .foregroundColor(.white)
                                }
                                else {
                                    Text(button.title)
                                        .font(.system(size: 25))
                                        .frame(width: self.buttonWidth(), height:   self.buttonWidth())
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
            }.padding()
        }
    }
    
    func buttonWidth() -> CGFloat {
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnvironment())
    }
}

