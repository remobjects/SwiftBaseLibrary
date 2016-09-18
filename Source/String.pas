namespace Swift;

interface

type
  SwiftString = public partial record
  public

    operator Implicit(aString: NativeString): SwiftString;
    begin
      if aString = nil then exit new SwiftString withCount(0) repeatedValue(#0);
      result := new SwiftString(aString);
    end;

    operator Implicit(aString: SwiftString): NativeString;
    begin
      result := aString.nativeStringValue;
    end;
    
  end;

implementation

end.
