

import Foundation
import UIKit

// Get Date 7 daya back
guard let dateFrom = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return }


//+++++++++++++++++++++++++++    CLOSER CONCEPT  +++++++++++++++++++++++++++++++++++++++++

CAPTURING SELF STRONGLY
Although it is good practice to capture self weakly in closures, it is not always necessary. Closures that are not retained by the self  can capture it strongly without causing a retain cycle. A few common examples of this are:

Working with DispatchQueues in GCD

DispatchQueue.main.async {
    self.doSomething() // Not a retain cycle
}Copy
Working with UIView.animate(withDuration:)

UIView.animate(withDuration: 1) {
    self.doSomething() // Not a retain cycle
}Copy
The first is not a retain cycle since self does not retain the DispatchQueue.main singleton. In the second example, UIView.animate(withDuration:) is a class method, which self also has no part in retaining.

Capturing self strongly in these situations will not cause a retain cycle, but it also may not be what you want. For example, going back to GCD:

DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
    self.doSomething()
}Copy
This closure will not run for another 60 seconds and will retain self until it does. This may be the behavior you want, but if you wanted self to be able to leave memory during this time, it would be better to capture it weakly and only run if self is still around:

DispatchQueue.main.asyncAfter(deadline: .now() + 60) { [weak self] in
    self?.doSomething()
}Copy
Another interesting place where self would not need to be captured strongly is in lazy variables, that are not closures, since they will be run once (or never) and then released afterwards:

lazy var fullName = {
  return self.firstName + " " + self.lastName  
}()Copy
However, if a lazy variable is a closure, it would need to capture self weakly. A good example of this comes from The Swift Programming Language guide:

class HTMLElement {
    let name: String
    let text: String?

    lazy var asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<(self.name)>(text)</(self.name)>"
        } else {
            return "<(self.name) />"
        }
    }
}Copy
This is also a good example of an instance that is reasonable to use an unowned reference, as the asHTML closure should exist as long as the HTMLElement does, but no longer.




//Button right side imAGE SETTING

 self.buttonName.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft


//UIAlertController
=============================================

 func userCallAlert(title: String? = nil, message: String? = nil, callThroughApp: @escaping (Bool) -> (Void), callThroughPhone: @escaping (Bool) -> (Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
       
        alert.addAction(UIAlertAction(title: StringConstants.VoiceCallThroughApp.localized, style: .default, handler: { action in
            callThroughApp(true)
        }))
      
        alert.addAction(UIAlertAction(title: StringConstants.VoiceCallThroughPhoneContact.localized, style: .default, handler: { action in
            callThroughPhone(true)
        }))
        
        alert.addAction(UIAlertAction(title: StringConstants.CancleActionSheet.localized, style: .cancel, handler: { action in
            
        }))
       // let root = UIApplication.shared.keyWindow?.rootViewController
            self.present(alert, animated: true, completion: nil)
    }

//======================================
extension NSMutableAttributedString {
    
    func setupAttriutedLable(texts: [String], fonts: [UIFont], colors: [UIColor]) -> NSAttributedString {
        // multi line enable Button
        //* button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let output = NSMutableAttributedString.init(string: texts.first?.localize ?? "", attributes: [.foregroundColor: colors.first ?? .black, .font: fonts.first ?? .systemFont(ofSize: 10), .paragraphStyle: paragraphStyle])
        guard texts.count > 1, texts.count == fonts.count, texts.count == colors.count else { return output }
        for index in texts.indices.dropFirst() {
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: colors[index], .font: fonts[index], .paragraphStyle: paragraphStyle]
            output.append(NSAttributedString(string: texts[index].localize, attributes: attributes))
        }
        return output
    }
}
//=========== useages: - 
 let attributedString = NSMutableAttributedString(string: "Booked Via: Normal Appointment")
 bookedViaLabel.attributedText = attributedString.setupAttriutedLable(texts: ["Booked Via: ", "Normal Appointment"], fonts: [AppFonts.Poppins_Bold.withSize(17), AppFonts.Poppins_Regular.withSize(16)], colors: [UIColor.green, AppColors.themeColor])




//

func setupActivityIndicator() {
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = AppColors.Blue.activityIndicator
        activityIndicator.center = webView.convert(webView.center, from: activityIndicator)
        webView.addSubview(activityIndicator)
    }

let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
activityIndicator.startAnimating()


text.size(withAttributes:[.font: AppFonts.Proxima_Nova_Rg_Regular.withSize(13)]).width + 80

// ============= Added textField in alert controller ===============================
//========================================================================================
  private func getGoalFromUser() {
    let alertController = UIAlertController(title: "What is your step goal?", message: nil, preferredStyle: .alert)
    alertController.addTextField { textField in
      textField.placeholder = "1000"
      textField.keyboardType = .numberPad
    }
    let action = UIAlertAction(title: "Done", style: .default) { [weak self] action in
      guard let textField = alertController.textFields?.first else { return }
      if let numberString = textField.text,
        let goal = Int(numberString) {
          self?.updateGoal(newGoal: goal)
      } else {
        self?.updateGoal(newGoal: 0)
      }
    }
    alertController.addAction(action)
    present(alertController, animated: true)
  }
            

// ====================== Check childView controller  =============================
extension RootViewController {
  var stepController: StepCountController {
    return children.first { $0 is StepCountController } as! StepCountController
  }
}

