import Foundation

typealias DataCompletion = (Data?, Error?) -> Void

extension String {
    func decodeString() -> String? {
        return removingPercentEncoding
    }
}

