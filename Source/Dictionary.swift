namespace Sugar.Collections;

interface

uses
  {$IF ECHOES}System.Linq,{$ENDIF}
  Sugar;

type
  Dictionary<T, U> = public class mapped to {$IF COOPER}java.util.HashMap<T,U>{$ELSEIF ECHOES}System.Collections.Generic.Dictionary<T,U>{$ELSEIF NOUGAT}Foundation.NSMutableDictionary where T is class, T is INSCopying, U is class;{$ENDIF}
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

end.