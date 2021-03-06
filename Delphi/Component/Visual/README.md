# Installation

 1. Download the source code of the library in this repo ([link](https://github.com/albertodev01/TEquations/tree/master/Delphi/Source))
 2. Download the content of this folder, including the images that are needed if you want to have a nice component icon in the IDE. **Note**: it's better if you move the content of the `Parser` folder in the main folder where you have all the files. At the end, your folder should look like this:
 
 <p align="center"><img src="https://github.com/albertodev01/TEquations/blob/master/Delphi/Component/Visual/github_images/folder.png" /></p>
 <p align="center">Green = component files | Red = library files</p>
 
 3. Open Delphi and do File > New > Package. Name it and Save All. Now in the project manager: Right click on the project name > Add > Select the `.pas` files (**not** the images) > Click open
 4. Go on Project > Resources and Images > Add the bmp/png files > Give them the following names:
 
 <p align="center"><img src="https://github.com/albertodev01/TEquations/blob/master/Delphi/Component/Visual/github_images/required.png" /></p>
 
 5. Click Ok. Now save all and in the project manager: Right click on the project name > Compile > Right click on the project name > Build > Right click on the project name > Install.
 6. Done!

# Usage

Let's do an example. Create a new FMX project, add a Button and drop the `EquationSolverPlot` component (set its `Name` property to `Solver`, just to type less characters!). In this section I'll show you how to solve a simple equation such as `f(x) = x^2-4.2`. Select the component in the Form Designer and do the following:

 1. Align it to `Client`
 1. Set the `Kind` property to `etEquation` (it's the default option)
 2. Expand `(TEquationOptions)` and use one of the following settings (it depends if you want to use Newton or Secant)
 
  <p align="center"><img src="https://github.com/albertodev01/TEquations/blob/master/Delphi/Component/Visual/github_images/equation_settings.png" /></p>
  
  3. Just as example, add `res: string;` in the private part of your form. Then add an `OnCreate` event for the `From` and type the following code:
  
```delphi
procedure TForm1.FormCreate(Sender: TObject);
var
  tmp: TSolution;
  I: Integer;
begin
  if Solver.Kind = etEquation then
    begin
      tmp := Solver.SolveEquation;

      res := 'x0 = ' + tmp.Solution.ToString + slineBreak;
      res := res + 'f(x0) = ' + tmp.Residual.ToString + sLineBreak + sLineBreak;

      for I := Low(tmp.GuessesList) to High(tmp.GuessesList) do
        res := res + tmp.GuessesList[I].ToString + sLineBreak;
    end
  else
    begin
      //polynomial...
    end;
end;
```

  4. Put a `TButton` on the top-left corner of the form (or where you prefer!), set the Text property to 'Solve', double click it and type the following code:

```delphi
procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage(res);
end;
```

  5. Let's add the possibility to zoom in and out with the mouse wheel! Select the component, click on Events and add a `OnMouseWheel` event.
  
```delphi
procedure TForm1.SolverMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
begin
  if WheelDelta > 0 then
    Solver.ZoomIn
  else
    Solver.ZoomOut;
end;
```  

Done! Save all, click `Run` and you'll get the following result:

<p align="center"><img src="https://github.com/albertodev01/TEquations/blob/master/Delphi/Component/Visual/github_images/example1.png" /></p>

Now if you try to move the wheel of your mouse up or down you'll be able to zoom in or out the equation!

<p align="center"><img src="https://github.com/albertodev01/TEquations/blob/master/Delphi/Component/Visual/github_images/example2-zoom.png" /></p>

Finally, if you click on the button you'll get the approximation of the root, the residual and the list of the approximation calculated by the root finding algorithm you have chosen (in my case, Newton).

<p align="center"><img src="https://github.com/albertodev01/TEquations/blob/master/Delphi/Component/Visual/github_images/result.png" /></p>
 
**Polynomial.**
From the example above, you just need to do some little changes and you'll be ready to solve polynomials as well:

  1. Select the component and change the `Kind` property to `etPolynomial`.
  2. Expand `(TPolynomialOptions)` and use the following settings. Here I want to solve `f(x) = x^3 + 2x^2 + 3x + 4`.
  
  <p align="center"><img src="https://github.com/albertodev01/TEquations/blob/master/Delphi/Component/Visual/github_images/polysettings.png" /></p>
  
  3. From the previous code, in the `OnCreate` event, use the following code:

```delphi
procedure TForm1.FormCreate(Sender: TObject);
var
  tmp: TSolutions;
  I: Integer;
begin
  if Solver.Kind = etPolynomial then
    begin
      tmp := Solver.SolvePolynomial;
      res := 'Disc. = ' + tmp.Discriminant.ToString + sLineBreak + sLineBreak;

      for I := Low(tmp.Solutions) to High(tmp.Solutions) do
        res := res + 'x' + i.ToString + ' = '+
                      tmp.Solutions[I].RealPart.ToString + ' + ' +
                      tmp.Solutions[I].ImagPart.ToString + 'i ' + sLineBreak;
    end;
end;
```

Done! Now if you run the program you'll get the following result:

<p align="center"><img src="https://github.com/albertodev01/TEquations/blob/master/Delphi/Component/Visual/github_images/polyresult.png" /></p>

Note that you could have used the `etEquation` mode with the `Equation` property set to `x^3+2*x^2+3*x+4`. The equation would have been the same but you wouldn't have been able to compute the imaginary solutions.
