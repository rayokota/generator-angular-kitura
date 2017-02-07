import Foundation
import Node
import ObjectMapper

open class NodeTransform: TransformType {
/*
	public typealias Object = Node
	public typealias JSON = Any
        */

	public init() {}

	open func transformFromJSON(_ value: Any?) -> Node? {
		if let valBool = value as? Bool {
			return Node.bool(valBool)
		}
		if let valInt = value as? Int {
			return Node.number(.int(valInt))
		}
		if let valUInt = value as? UInt {
			return Node.number(.uint(valUInt))
		}
		if let valDouble = value as? Double {
			return Node.number(.double(valDouble))
		}
		if let valStr = value as? String {
			return Node.string(valStr)
		}
		return nil
	}

	open func transformToJSON(_ value: Node?) -> Any? {
                switch value! {
                  case .bool(let valBool): 
                     return valBool
                  case .number(let valNum): 
                     switch valNum {
                       case .int(let valInt):
                         return valInt
                       case .uint(let valUInt):
                         return valUInt
                       case .double(let valDouble):
                         return valDouble
                     }
                  case .string(let valStr): 
                     return valStr
                  default:
                     return nil
                }
	}
}
