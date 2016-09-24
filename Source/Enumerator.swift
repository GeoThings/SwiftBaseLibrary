#if COOPER
	import java.util
#elseif ECHOES
	import System.Collections.Generic
#elseif NOUGAT
	import Foundation
#endif

#if NOUGAT
__mapped public class Enumerator<T> => Foundation.NSEnumerator {
	
	public func nextObject() -> T? { return __mapped.nextObject() }
	public var allObjects: Array<T> { return __mapped.allObjects.mutableCopy }
}
#else

open class Enumerator<T> {
	
	open func nextObject() -> T? {
		
		RequiresConcreteImplementation()
	}
}

extension Enumerator {
	public var allObjects: Array<T> {
		var allObjectCollection = [T]()
		
		let element: T?
		while ( (element = self.nextObject()) != nil ){
			allObjectCollection.append(element!)
		}
		
		return allObjectCollection
	}
}

#if COOPER
extension Enumerator: Iterable<T> {
	
	internal class Iterator<T>: java.util.Iterator<T> {
		private let _enumerator: Enumerator<T>
		init(enumerator: Enumerator<T>){
			_enumerator = enumerator
		}
		
		//java.util.Iterator<T>
		public func next() -> T {
			return _enumerator.nextObject()!
		}
		
		public func hasNext() -> Bool {
			return ((_enumerator.nextObject() != nil) ? true : false)
		}
		
		public func remove() {
			_enumerator.remove()
		}
	}
	
	public func iterator() -> java.util.Iterator<T>! {
		return Iterator(enumerator: self)
	}
	
	//for glueing it to java.util.Iterator
	public func remove() {
		RequiresConcreteImplementation()
	}
}
#elseif ECHOES
extension Enumerator: IEnumerable<T> {
	
	internal class EchoesEnumerator: IEnumerator<T> {
		private let _enumerator: Enumerator<T>
		private var _savedValue: T?
		
		init(enumerator: Enumerator<T>){
			_enumerator = enumerator
			_savedValue = _enumerator.nextObject()
		}
		
		//IEnumerator<T>
		@Implements(System.Collections.IEnumerator.Type, "Current")
		public var CurrentI: Object! {
			return self.Current
		}
		public var Current: T {
			//if enumerator returns nil for the first element - NullReferenceException will follow...
			return _savedValue!
		}
		
		public func MoveNext() -> Bool {
			_savedValue = _enumerator.nextObject()
			return (_savedValue != nil)
		}
		
		public func Reset() {
			_enumerator.Reset()
		}
		
		//IDisposable
		public func Dispose() {
			_enumerator.Dispose()
		}
	}
	  
	@Implements(System.Collections.IEnumerable.Type, "GetEnumerator")
	public func GetEnumeratorI() -> System.Collections.IEnumerator!  {
		return EchoesEnumerator(enumerator: self)
	}
	public func GetEnumerator() -> IEnumerator<T> {
		return EchoesEnumerator(enumerator: self)
	}
	
	//for glueing it to System.Collections.Generic.IEnumerator<T>
	public func Reset() {
		RequiresConcreteImplementation()
	}
	
	public func Dispose() {
		//override if IDisposable functionality needed 
	}
}
#endif

#endif

/* A Mirrored Implementation for Swift 2.2

public class Enumerator<T> {
	
	public func nextObject() -> T? {
		RequiresConcreteImplementation()
	}
}

extension Enumerator {
	
	public var allObjects: [T] {
		return Array(self)
	}
}

extension Enumerator: SequenceType {
	
	public func generate() -> Generator<T> {
		return Generator(enumerator: self)
	}
}

public struct Generator<T>: GeneratorType {
	
	let enumerator: Enumerator<T>
	public mutating func next() -> T? {
		return enumerator.nextObject()
	}
}

@noreturn internal func RequiresConcreteImplementation(fn fn: String = #function){
	fatalError("\(fn) must be overriden in subclass implementations")
}
*/