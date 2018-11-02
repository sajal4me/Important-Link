

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
