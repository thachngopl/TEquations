unit Fraction;

interface

uses
 SysUtils, Math, RegularExpressions;

type
 TFraction = record
   strict private
     aNumerator: integer;
     aDenominator: integer;
     function GCD(a, b: integer): integer;
     function FromString(const s: string): TFraction;
     function FromDouble(const d: double): TFraction;
     function GetDecimal: double;
     function GetString: string;
   public type
           TMixedFraction = record
             private
               FWholePart: integer;
               FNumerator, FDenominator: integer;
               function GetString: string;
               function GetDouble: double;
             public
               constructor Create(AWholePart, ANumerator, ADenominator: integer);
               property WholePart: integer read FWholePart;
               property Numerator: integer read FNumerator;
               property Denominator: integer read FDenominator;
               property ToString: string read GetString;
               property ToDouble: double read GetDouble;
           end;
   public
     constructor Create(aNumerator: integer; aDenominator: integer); overload;
     constructor Create(aFraction: string); overload;
     constructor Create(aFraction: double); overload;
     constructor Create(aMixedFraction: TFraction.TMixedFraction); overload;
     procedure Reduce;
     procedure Negate;
     procedure Inverse;
     function ToMixedFraction(out Mixed: TFraction.TMixedFraction): boolean;
     class operator Add(fraction1, fraction2: TFraction): TFraction;
     class operator Subtract(fraction1, fraction2: TFraction): TFraction;
     class operator Multiply(fraction1, fraction2: TFraction): TFraction;
     class operator Divide(fraction1, fraction2: TFraction): TFraction;
     class operator Negative(const Value: TFraction): TFraction;
     class operator Implicit(fraction: TFraction): double;
     class operator Implicit(fraction: TFraction): string;
     class operator Implicit(fraction: double): TFraction;
     class operator Implicit(fraction: string): TFraction;
     property Numerator: integer read aNumerator;
     property Denominator: integer read aDenominator;
     property ToDouble: double read GetDecimal;
     property ToString: string read GetString;
 end;

implementation

{ TFraction }

constructor TFraction.Create(aNumerator, aDenominator: integer);
begin
  if (aDenominator = 0) then
   begin
    raise Exception.Create('Denominator cannot be zero in rationals!');
   end;

  Self.aNumerator := aNumerator;
  Self.aDenominator := aDenominator;
end;

constructor TFraction.Create(aFraction: string);
var Temp: TFraction;
    k: double;
begin
  if (TryStrToFloat(aFraction, k)) then
    Temp := FromDouble(k)
  else
    Temp := FromString(aFraction);

  Self.aNumerator := Temp.aNumerator;
  Self.aDenominator := Temp.aDenominator;
end;

constructor TFraction.Create(aFraction: double);
var Temp: TFraction;
begin
  Temp := FromDouble(aFraction);

  Self.aNumerator := Temp.aNumerator;
  Self.aDenominator := Temp.aDenominator;
end;

constructor TFraction.Create(AMixedFraction: TMixedFraction);
begin
  Self.aNumerator := aMixedFraction.FWholePart * aMixedFraction.FDenominator + aMixedFraction.FNumerator;
  Self.aDenominator := aMixedFraction.FDenominator;
end;

function TFraction.GCD(a, b: integer): integer;
var remd: integer;
begin
  remd := a mod b;

  if remd = 0 then
   Result := b
  else
   Result := gcd(b, remd);
end;

function TFraction.GetDecimal: double;
begin
  Result := aNumerator / aDenominator;
end;

function TFraction.ToMixedFraction(out Mixed: TFraction.TMixedFraction): boolean;
begin
  Result := false;

  if aNumerator > aDenominator then
    begin
      Mixed.FWholePart := aNumerator div aDenominator;
      Mixed.FNumerator := aNumerator mod aDenominator;
      Mixed.FDenominator := aDenominator;
      Result := true;
    end;
end;

function TFraction.GetString: string;
begin
  Result := aNumerator.ToString + '/' + aDenominator.ToString;
end;

class operator TFraction.Implicit(fraction: TFraction): string;
begin
  Result := fraction.Numerator.ToString + '/' + fraction.Denominator.ToString;
end;

class operator TFraction.Implicit(fraction: TFraction): double;
begin
  Result := fraction.Numerator / fraction.Denominator;
end;

procedure TFraction.Inverse;
var temp: integer;
begin
  temp := aNumerator;
  aNumerator := aDenominator;
  aDenominator := temp;
end;

procedure TFraction.Reduce;
var LGCD: integer;
begin
  LGCD := GCD(aNumerator, aDenominator);
  aNumerator := aNumerator div LGCD;
  aDenominator := aDenominator div LGCD;
end;

function TFraction.FromDouble(const d: double): TFraction;
var h1, h2, k1, k2, y, a, aux, sign: double;
begin
  h1 := 1;
  h2 := 0;
  k1 := 0;
  k2 := 1;
  y := abs(d);
  sign := 1;

  repeat
    begin
      a := floor(y);
      aux := h1;
      h1 := a * h1 + h2;
      h2 := aux;
      aux := k1;
      k1 := a * k1 + k2;
      k2 := aux;
      if (y - a = 0) or (k1 = 0) then break;
      y := 1 / (y - a) ;
    end;
  until (Abs(abs(d) - h1 / k1) <= abs(d) * 0.0000000001);

  if (d < 0) then
    sign := -1;

  if not(h1 = 0) then
    begin
      Result.aNumerator := Round(sign * Abs(h1));
      Result.aDenominator := Round(k1);
    end
  else
    begin
      Result.aNumerator := 0;
      Result.aDenominator := 1;
    end;
end;

function TFraction.FromString(const s: string): TFraction;
var
  BarPos: integer;
  numStr, denomStr: string;
begin
  BarPos := Pos('/', S);
  if BarPos = 0 then
    begin
     Result.aNumerator := StrToInt(S);
     Result.aDenominator := 1;
    end
  else
    begin
      numStr := Trim(Copy(S, 1, BarPos - 1));
      denomStr := Trim(Copy(S, BarPos + 1, Length(S)));
      Result.aNumerator := StrToInt(numStr);
      Result.aDenominator := StrToInt(denomStr);
    end;
end;

procedure TFraction.Negate;
begin
  aNumerator := (-1) * aNumerator;
end;

class operator TFraction.Negative(const Value: TFraction): TFraction;
begin
  Result.aNumerator := -Value.aNumerator;
  Result.aDenominator := Value.aDenominator;
end;

//operators overloads

class operator TFraction.Add(fraction1, fraction2: TFraction): TFraction;
begin
  Result.aNumerator := fraction1.Numerator*fraction2.Denominator+fraction1.Denominator*fraction2.Numerator;
  Result.aDenominator := fraction1.Denominator*fraction2.Denominator;
end;

class operator TFraction.Subtract(fraction1, fraction2: TFraction): TFraction;
begin
  Result := fraction1 + (-fraction2);
end;

class operator TFraction.Multiply(fraction1, fraction2: TFraction): TFraction;
begin
  Result.aNumerator := fraction1.Numerator*fraction2.Numerator;
  Result.aDenominator := fraction1.Denominator*fraction2.Denominator;
end;

class operator TFraction.Divide(fraction1, fraction2: TFraction): TFraction;
begin
  Result.aNumerator := fraction1.Numerator*fraction2.Denominator;
  Result.aDenominator := fraction1.Denominator*fraction2.Numerator;
end;

class operator TFraction.Implicit(fraction: double): TFraction;
begin
  Result := TFraction.Create(fraction);
end;

class operator TFraction.Implicit(fraction: string): TFraction;
begin
  Result := TFraction.Create(fraction);
end;

{ TFraction.TMixedFraction }

constructor TFraction.TMixedFraction.Create(AWholePart, ANumerator,
  ADenominator: integer);
begin
  if ANumerator > ADenominator then
    raise Exception.Create('The numerator cannot be greater than the denominator');

  if ADenominator = 0 then
    raise Exception.Create('Denominator cannot be zero.');

  FWholePart := AWholePart;
  FNumerator := ANumerator;

  if ADenominator > 0 then
    FDenominator := ADenominator
  else
    begin
      FNumerator := -FNumerator;
      FDenominator := - FDenominator;
    end;
end;

function TFraction.TMixedFraction.GetDouble: double;
begin
  Result := FWholePart + (FNumerator / FDenominator);
end;

function TFraction.TMixedFraction.GetString: string;
begin
  Result := FWholePart.ToString + ' ' + FNumerator.ToString + '/' + FDenominator.ToString;
end;

end.
