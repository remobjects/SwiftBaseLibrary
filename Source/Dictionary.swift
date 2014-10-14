#if COOPER
import java.util
import com.remobjects.elements.linq
#elseif ECHOES
import System.Collections.Generic
import System.Linq
#elseif NOUGAT
import Foundation
import RemObjects.Elements.Linq
#endif


#if NOUGAT
__mapped public class Dictionary<Key: class, INSCopying, Value: class> /*: INSFastEnumeration<T>*/ => Foundation.NSMutableDictionary {
#elseif COOPER
__mapped public class Dictionary<Key,Value> => java.util.HashMap<Key,Value> {
#elseif ECHOES
__mapped public class Dictionary<Key,Value> => System.Collections.Generic.Dictionary<Key,Value> {
#endif

	init() {
	}

	/// Create a dictionary with at least the given number of
	/// elements worth of storage.  The actual capacity will be the
	/// smallest power of 2 that's >= `minimumCapacity`.
	init(minimumCapacity: Int) {
	}

	/// Create an instance initialized with `elements`.
	/*init(dictionaryLiteral elements: (Key, Value)...) { // Language element not supported on this target platform
	}*/

	//var startIndex: DictionaryIndex<Key, Value> { get }
	//var endIndex: DictionaryIndex<Key, Value> { get }

	/*func indexForKey(key: Key) -> DictionaryIndex<Key, Value>? {
	}
	
	subscript (position: DictionaryIndex<Key, Value>) -> (Key, Value) { 
		get {
		}
	}*/
	
	subscript (key: Key) -> Value? {
		get {
			#if COOPER
			if __mapped.containsKey(key) {
				return __mapped[key]
			}
			return nil
			#elseif ECHOES
			if __mapped.ContainsKey(key) {
				return __mapped[key]
			}
			return nil
			#elseif NOUGAT
			return __mapped[key]
			#endif
		}
		set {
			#if COOPER
			__mapped[key] = newValue
			#elseif ECHOES
			//__mapped[key] = newValue // 70037: Silver: can't assign nullable to .NET dictionary in mapped type
			#elseif NOUGAT
			if let val = newValue { // 70036: Silver: "if let" expression warns to "always evaluate to true"
				__mapped[key] = val
			} else {
				__mapped.removeObjectForKey(key)
			}
			
			#endif
		}
	}

	/// Update the value stored in the dictionary for the given key, or, if they
	/// key does not exist, add a new key-value pair to the dictionary.
	///
	/// Returns the value that was replaced, or `nil` if a new key-value pair
	/// was added.
	mutating func updateValue(value: Value, forKey key: Key) -> Value? {
	}

	/// Remove the key-value pair at index `i`
	///
	/// Invalidates all indices with respect to `self`.
	///
	/// Complexity: O(\ `count`\ ).
	/*mutating func removeAtIndex(index: DictionaryIndex<Key, Value>) {
	}*/

	/// Remove a given key and the associated value from the dictionary.
	/// Returns the value that was removed, or `nil` if the key was not present
	/// in the dictionary.
	mutating func removeValueForKey(key: Key) -> Value? {
	}

	/// Remove all elements.
	///
	/// Postcondition: `capacity == 0` iff `keepCapacity` is `false`.
	///
	/// Invalidates all indices with respect to `self`.
	///
	/// Complexity: O(\ `count`\ ).
	mutating func removeAll(keepCapacity: Bool = default) {
	}

	/// The number of entries in the dictionary.
	///
	/// Complexity: O(1)
	var count: Int { get {} }

	/// True iff `count == 0`
	var isEmpty: Bool { get {} }

	/// A collection containing just the keys of `self`
	///
	/// Keys appear in the same order as they occur as the `.0` member
	/// of key-value pairs in `self`.  Each key in the result has a
	/// unique value.
	var keys: ISequence<Key> { get {} }

	/// A collection containing just the values of `self`
	///
	/// Values appear in the same order as they occur as the `.1` member
	/// of key-value pairs in `self`.
	var values: ISequence<Value> { get {} }

	/// Return a *generator* over the (key, value) pairs.
	///
	/// Complexity: O(1)
	/*func generate() -> DictionaryGenerator<Key, Value> {
	}*/

}

/*namespace Sugar.Collections;

interface

uses
  {$IF ECHOES}System.Linq,{$ENDIF}
  Sugar;

type
  Dictionary<T, U> = public class mapped to {$IF COOPER}{$ELSEIF ECHOES}System.Collections.Generic.Dictionary<T,U>{$ELSEIF NOUGAT}Foundation.NSMutableDictionary where T is class, T is INSCopying, U is class;{$ENDIF}
  private
	method GetKeys: array of T;
	method GetValues: array of U;
	method GetItem(Key: T): U;
	method SetItem(Key: T; Value: U);
  public
	constructor; mapped to constructor();
	method &Add(Key: T; Value: U);
	method Clear;
	method ContainsKey(Key: T): Boolean;
	method ContainsValue(Value: U): Boolean;
	method &Remove(Key: T): Boolean;

	method ForEach(Action: Action<KeyValue<T,U>>);

	property Item[Key: T]: U read GetItem write SetItem; default;
	property Keys: array of T read GetKeys;
	property Values: array of U read GetValues;
	property Count: Integer read {$IF COOPER}mapped.size{$ELSEIF ECHOES OR NOUGAT}mapped.Count{$ENDIF};
  end;

  {$IF ECHOES}
  ArrayHelper = public static class
  public
	method ToArray<T>(Value: System.Collections.Generic.IEnumerable<T>): array of T;
  end;
  {$ENDIF}

implementation

method Dictionary<T, U>.Add(Key: T; Value: U);
begin
  if Key = nil then
	raise new SugarArgumentNullException("Key");

  if ContainsKey(Key) then
	raise new SugarArgumentException(ErrorMessage.KEY_EXISTS);

  {$IF COOPER}
  mapped.put(Key, Value);
  {$ELSEIF ECHOES}
  mapped.Add(Key, Value);
  {$ELSEIF NOUGAT}
  mapped.setObject(NullHelper.ValueOf(Value)) forKey(Key);
  {$ENDIF}
end;

method Dictionary<T, U>.Clear;
begin
  {$IF COOPER OR ECHOES}
  mapped.Clear;
  {$ELSEIF NOUGAT}
  mapped.removeAllObjects;
  {$ENDIF}
end;

method Dictionary<T, U>.ContainsKey(Key: T): Boolean;
begin
  if Key = nil then
	raise new SugarArgumentNullException("Key");

  {$IF COOPER OR ECHOES}
  exit mapped.ContainsKey(Key);
  {$ELSEIF NOUGAT}
  exit mapped.objectForKey(Key) <> nil;
  {$ENDIF}
end;

method Dictionary<T, U>.ContainsValue(Value: U): Boolean;
begin
  {$IF COOPER OR ECHOES}
  exit mapped.ContainsValue(Value);
  {$ELSEIF NOUGAT}
  exit mapped.allValues.containsObject(NullHelper.ValueOf(Value));
  {$ENDIF}
end;

method Dictionary<T, U>.ForEach(Action: Action<KeyValue<T, U>>);
begin
  if Action = nil then
	raise new SugarArgumentNullException("Action");

  var lKeys := self.Keys;
  for i: Integer := 0 to length(lKeys) - 1 do
	Action(new KeyValue<T,U>(lKeys[i], self.Item[lKeys[i]]));
end;

method Dictionary<T, U>.GetItem(Key: T): U;
begin
  {$IF COOPER OR ECHOES}
  result := mapped[Key];
  {$ELSEIF NOUGAT}
  result := mapped.objectForKey(Key);

  if result <> nil then
	exit NullHelper.ValueOf(result);
  {$ENDIF}

  if result = nil then
	raise new SugarKeyNotFoundException;
end;

method Dictionary<T, U>.GetKeys: array of T;
begin
  {$IF COOPER}
  exit mapped.keySet.toArray(new T[0]);
  {$ELSEIF ECHOES}
  exit ArrayHelper.ToArray<T>(mapped.Keys);
  {$ELSEIF NOUGAT}
  result := new T[mapped.allKeys.count];
  for i: Integer := 0 to mapped.allKeys.count - 1 do begin
	result[i] := mapped.allKeys.objectAtIndex(i);
  end;
  {$ENDIF}
end;

method Dictionary<T, U>.GetValues: array of U;
begin
  {$IF COOPER}
  exit mapped.values.toArray(new U[0]);
  {$ELSEIF ECHOES}
  exit ArrayHelper.ToArray<U>(mapped.Values);
  {$ELSEIF NOUGAT}
  result := new U[mapped.allValues.count];
  for i: Integer := 0 to mapped.allValues.count - 1 do
	result[i] := NullHelper.ValueOf(mapped.allValues.objectAtIndex(i));
  {$ENDIF}
end;

method Dictionary<T, U>.&Remove(Key: T): Boolean;
begin
  if Key = nil then
	raise new SugarArgumentNullException("Key");

  {$IF COOPER}
  exit mapped.remove(Key) <> nil;
  {$ELSEIF ECHOES}
  exit mapped.Remove(Key);
  {$ELSEIF NOUGAT}
  result := ContainsKey(Key);
  if result then
	mapped.removeObjectForKey(Key);
  {$ENDIF}
end;

method Dictionary<T, U>.SetItem(Key: T; Value: U);
begin
  if Key = nil then
	raise new SugarArgumentNullException("Key");

  {$IF COOPER OR ECHOES}
  mapped[Key] := Value;
  {$ELSEIF NOUGAT}
  mapped.setObject(NullHelper.ValueOf(Value)) forKey(Key);
  {$ENDIF}
end;

{$IF ECHOES}
method ArrayHelper.ToArray<T>(Value: System.Collections.Generic.IEnumerable<T>): array of T;
begin
  exit Value.ToArray;
end;
{$ENDIF}

end.*/