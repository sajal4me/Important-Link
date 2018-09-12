

import Foundation
import UIKit

// Get Date 7 daya back
guard let dateFrom = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return }
