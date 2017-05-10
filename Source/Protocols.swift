
#if COCOA
/*@unsafe_no_objc_tagged_pointer*/ public protocol _CocoaArrayType {
	func objectAtIndex(index: Int) -> AnyObject
	//func getObjects(_: UnsafeMutablePointer<AnyObject>, range: _SwiftNSRange)
	//func countByEnumeratingWithState(state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>, objects buffer: UnsafeMutablePointer<AnyObject>, count len: Int) -> Int
	//func copyWithZone(_: COpaquePointer) -> _CocoaArrayType
	var count: Int { get }
}
#endif

public typealias CustomStringConvertible = ICustomStringConvertible
public protocol ICustomStringConvertible {
	var description: NativeString! { get } // unwrapped nullable for better Cocoa compatibility
}

public typealias CustomDebugStringConvertible = ICustomDebugStringConvertible
public protocol ICustomDebugStringConvertible {
	var debugDescription: NativeString! { get } // unwrapped nullable for better Cocoa compatibility
}

public typealias RawRepresentable = IRawRepresentable
public protocol IRawRepresentable {
	associatedtype RawValue
	init/*?*/(rawValue rawValue: Self.RawValue)
	var rawValue: Self.RawValue { get }
}

public typealias ErrorType = IErrorType
public protocol IErrorType {
}

public typealias Hashable = IHashable
public protocol IHashable /*: Equatable*/ {
	var hashValue: Int { get }
}

public typealias OutputStreamType = IOutputStreamType
public protocol IOutputStreamType {
	mutating func write(_ string: String)
}

public typealias Streamable = IStreamable
public protocol IStreamable {
	//func writeTo<Target: OutputStreamType>(inout _ target: OutputStreamType)
	func writeTo(_ target: OutputStreamType) // deliberately different that Apple's SBL due to limitations on Island
}




//basic Sequence and IteratorProtocol support (for swift 3 version of baselibrary)
//this compiles under xcode 8.2.1 (except for the ISequence related code)
//but sadly silver 9 screams bloody murder 




public protocol IteratorProtocol{
	associatedtype Element
	//==nil after last element
	mutating func next() -> Self.Element?
}




extension IteratorProtocol: /*ISequence*/{
	typealias T = Self.Element
	public func iterator() -> ISequence<T> {
		while let elem = self.next(){
			__yield elem
		}
	}
}

extension ISequence: IteratorProtocol{
	typealias Element = T
	func next()->Element?{
		for elem in self{
			__yield elem
		}
		while true {__yield nil}
	}
}

public protocol Sequence {
	
	associatedtype Iterator : IteratorProtocol
	associatedtype SubSequence
	
	func makeIterator() -> Self.Iterator
	
	//will have defaults	
	//should be O(1)
	var underestimatedCount: Int { get }
	
	func map<T>(_ transform: (Self.Iterator.Element) throws -> T) rethrows -> [T]
	
	func filter(_ isIncluded: (Self.Iterator.Element) throws -> Bool) rethrows -> [Self.Iterator.Element]
	
	func forEach(_ body: (Self.Iterator.Element) throws -> ()) rethrows
	
	func dropFirst(_ n: Int) -> Self.SubSequence
	
	func dropLast(_ n: Int) -> Self.SubSequence
	
	func prefix(_ maxLength: Int) -> Self.SubSequence
	
	func suffix(_ maxLength: Int) -> Self.SubSequence
	
	func split(maxSplits: Int, omittingEmptySubsequences: Bool, whereSeparator isSeparator: (Self.Iterator.Element) throws -> Bool) rethrows -> [Self.SubSequence]
}

//default implementationhelpers



public struct AnyIterator<E>:IteratorProtocol,Sequence{
	public typealias Iterator = AnyIterator<E>
	public func makeIterator() -> AnyIterator<E> {
		return self
	}
	
	var nextFunc: ()->E?
	
	init(_ body: @escaping ()->E?){
		self.nextFunc = body
	}
	
	init<I : IteratorProtocol>( _ base: I) where I.Element == E{
		var mbase = base
		self.nextFunc = {return mbase.next()}
	}
	
	mutating public func next() -> E? {
		return self.nextFunc()
	}
}


public struct AnySequence<E>: Sequence{
	public typealias SubSequence = AnySequence<E>

	public typealias Iterator = AnyIterator<E>

	var makerFunc: ()->AnyIterator<E>
	
	public func makeIterator() -> AnySequence.Iterator {
		return makerFunc()
	}
	
	init<I : IteratorProtocol>(_ makerFunc: @escaping () -> I) where I.Element == E{
		self.makerFunc = {return AnyIterator(makerFunc())}
	}
	
	init<S : Sequence>(_ base: S) where
		S.Iterator.Element == E,
		S.SubSequence : Sequence,
		S.SubSequence.Iterator.Element == E,
		S.SubSequence.SubSequence == S.SubSequence{
			self.makerFunc = {return AnyIterator(base.makeIterator())}
	}
}




//default implementations (eager)
extension Sequence{
	/*public var lazy: LazySequence<Self> { get{
		return LazySequence<Self>(self)
		}}
	*/
	public var underestimatedCount: Int {
		return 0
	}
	
	public func contains(where predicate: (Iterator.Element) throws -> Bool) rethrows -> Bool {
		var it = self.makeIterator()
		while let elem = it.next(){
			if try predicate(elem) {return true}
		}
		return false
	}
	
	//drops the first elements satisfying the predicate(for anything elsse use filter)
	func drop(
		while predicate: @escaping (Self.Iterator.Element) throws -> Bool)
		rethrows -> AnySequence<Self.Iterator.Element>{
		var it = makeIterator()
		while let elem = it.next(){
			if !(try predicate(elem)){break}
		}
		
		return AnySequence({return it})
	}
	
	func dropFirst()->Self.SubSequence{
		return dropFirst(1)
	}
	
	func dropLast()->Self.SubSequence{
		return dropLast(1)
	}
	
	public func map<T>(_ transform: (Self.Iterator.Element) throws -> T) rethrows -> [T]{
		var ret = Array<T?>()//repeating: nil, count: underestimatedCount)
		var it = makeIterator()
		while let elem = it.next(){
			ret.append(try transform(elem))
		}
		return ret as! [T]
	}
	
	public func filter(_ isIncluded: (Self.Iterator.Element) throws -> Bool) rethrows -> [Self.Iterator.Element]{
		var ret = Array<Self.Iterator.Element>()
		var it = makeIterator()
		while let elem = it.next(){
			if try isIncluded(elem){ret.append(elem)}
		}		
		return ret
	}
	
	public func forEach(_ body: (Self.Iterator.Element) throws -> ()) rethrows{
		var it = makeIterator()
		while let elem = it.next(){
			try body(elem)
		}
	}
	
}

class RingBuf<T>{
	var buf: Array<T?>
	var front: Int
	var back: Int
	private func step( _ val:inout Int){
		val += 1
		if val == buf.count{
			val = 0
		}
	}
	init(_ size:Int){
		assert(size > 0,"Only positive RingBufferSize allowed")
		buf = Array<T?>.init(repeating: nil, count: size)
		front = 0
		back = front
	}
	var isEmpty: Bool{
		return front == back && buf[front] == nil
	}
	var isFull: Bool{
		return front == back && !isEmpty
	}
	
	func put(_ elem:T){
		if !isFull{
			buf[back] = elem
			step(&back)
		}
	}
	
	//consumes
	func get()->T?{
		if isEmpty {return nil}
		let ret = buf[front]
		buf[front] = nil
		step(&front)
		return ret
	}
	
}

extension Sequence where 
	Self.SubSequence:Sequence,
	Self.SubSequence.Iterator.Element == Iterator.Element,
	Self.SubSequence == Self.SubSequence.SubSequence{
	
	public func dropFirst(_ n:Int) -> AnySequence<Iterator.Element>
	{
			assert(n>=0,"Drop only nonnegative Number of Elements from Sequence.")
			var it = makeIterator()
			for _ in 1...n{
				let _ = it.next()
			}
			let ret = AnySequence({return it})
			return ret
	} 
	
	public func dropLast(_ n:Int)->AnySequence<Iterator.Element>{
		assert(n>=0,"Drop only nonnegative Number of Elements from Sequence.")
		if n == 0 {return AnySequence(self)}
		
		//n>0
		let dropList = RingBuf<Iterator.Element>(n)
		var it = makeIterator()
		while let elem = it.next(){
			dropList.put(elem)
			if dropList.isFull{break}
		}
		let retIt = AnyIterator({ () -> Self.Iterator.Element? in 
			if let anotherElement = it.next(){
				let nextElem = dropList.get()
				dropList.put(anotherElement)
				return nextElem
			}else{
				return nil
			}
		})
		return AnySequence<Iterator.Element>({return retIt})
	}
	
	
	public func prefix(_ maxLength: Int) -> AnySequence<Iterator.Element>{
		var length = 0
		var it = makeIterator()
		let retIt = AnyIterator({ () -> Self.Iterator.Element? in 
			if length < maxLength{
				length += 1
				return it.next()
			}else{
				return nil
			}
		})
		return AnySequence({return retIt})
	}
	
	public func suffix (_ maxLength: Int) -> AnySequence<Iterator.Element>{
		assert(maxLength>=0)
		if maxLength == 0 {return AnySequence({return AnyIterator({return nil})})}
		
		//maxLength>0
		let buf = RingBuf<Iterator.Element>(maxLength)
		var it = makeIterator()
		//fill buffer
		while let elem = it.next() {
			buf.put(elem)
			if buf.isFull{break}
		}
		
		//filled buffer
		while let elem = it.next(){
			let _ = buf.get()
			buf.put(elem)
		}
		
		//
		//empty buffer
		let retIt = AnyIterator({ () -> Self.Iterator.Element? in 
			if !buf.isEmpty{return buf.get()}
			return nil
		})
		return AnySequence({return retIt})
	}
	
	public func split(
		/*default value for max splits should be 1 less imho, but docs say otherwise
		(guess arguement is:Int is signed,so cannot exhaust adressspace... but then 
		again Int is defined as default array index (and type for count) 
		and maxSplits+1 can be length of returned array)*/
		maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true,
		whereSeparator isSeparator: (Self.Iterator.Element) throws -> Bool)
		rethrows -> [AnySequence<Iterator.Element>]{
			var it = makeIterator()
			var sequences = Array<AnySequence<Iterator.Element>>()
			var reachedMaxSplits: Bool = false
			var subseq = Array<Iterator.Element>()
			while let elem = it.next(){
				if try isSeparator(elem){
					if subseq.isEmpty && omittingEmptySubsequences{
						continue
					}else{//package , append  and  realloc subseq
							//package
						let package = AnySequence({ () -> AnyIterator<Self.Iterator.Element> in 
							var index: Int = 0
							return AnyIterator({ 
								var retval: Iterator.Element? = nil
								if index < subseq.count {retval = subseq[index]}
								index += 1
								return retval
							})
						})
						//append
						sequences.append(package)
						if sequences.count == maxSplits{
							reachedMaxSplits = true
							break
						}
						//realloc
						subseq = Array<Iterator.Element>()
					}
				}else{//no separator
					subseq.append(elem)
				} 
			}//while
			//two cases:reached max splits or end of sequence
			if reachedMaxSplits{
				//package rest of sequence, and append to sequences
				
				//we need to check for emptiness of the last sequence,
				//so in order to not loose any element, we need to introduce 
				//a little buffer
				var nextElem = it.next()
				let ait = AnyIterator({ () -> Self.Iterator.Element? in 
					let retval = nextElem
					nextElem = it.next()
					return retval
				})
				let package = AnySequence({
					return ait
				})
				
				//sequence empty?
				if !(nextElem == nil && omittingEmptySubsequences){
					sequences.append(package)
				}
			}else{//reached end of sequence
			//done	
			}
			return sequences
		}
}



extension Sequence where Iterator.Element: Equatable{
	public func contains(_ element: Iterator.Element) -> Bool{
		var it = self.makeIterator()
		while let thing = it.next(){
			if thing == element{ return true}
		}
		return false
	}	
}


/*public protocol GeneratorType {
	typealias Element
	mutating func next() -> Element?
}*/


