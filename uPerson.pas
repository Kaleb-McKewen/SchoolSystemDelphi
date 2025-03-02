{
Person Unit for different types of people in a school system
allowing student and teacher creation that include shared/inherited properties
of the main person class and unique properties
}

unit uPerson;

interface

uses SysUtils;

type

{
Person Class
Used as the parent class for storing standard person attributes
and including the standard toString function
}
TPerson = class
  private
    fname: string;
    flname: string;
  public
    constructor Create(firstName:String; lastName: String = '');
    destructor Destroy; override;
    function ToString: String; override;

end;

{
Teacher Class
Extends TPerson Class, represents a Teacher in a School System
}
TTeacher=class(TPerson)
  private
    fteacherId: integer;
    fprefix: string;
  public
    constructor Create(firstName, prefix: string; teacherId: integer; lastName: String = '');
    destructor Destroy; override;
    function ToString: String; override;
end;


{
Student Class
Extends TPerson Class, represents a Student in a School System
}
TStudent=class(TPerson)
  private
    fstudentId: integer;
  public
    constructor Create(firstName: string; studentId: integer; lastName: String = '');
    destructor Destroy; override;
    function GetStudentId: integer;
end;

implementation

//TPerson Class Implementation Section
constructor TPerson.Create(firstName:String; lastName: string = '');
begin
  self.fname:=firstName;
  self.flname:=lastName;
end;

destructor TPerson.Destroy;
begin
  inherited
end;

//function to return the full name of a person
function TPerson.toString: string;
begin
  if self.flname='' then Result:= self.fname
  else Result:= Trim(self.fname+' '+self.flname);
end;

//TTeacher Class Implementation Section
constructor TTeacher.Create(firstName, prefix: string; teacherId: Integer; lastName: string = '');
begin
  inherited Create(firstName, lastName);
  self.fteacherId:=teacherId;
  self.fprefix:=prefix;
end;

destructor TTeacher.Destroy;
begin
  inherited;
end;

//function to return a teachers professional name
function TTeacher.toString: string;
begin
  if self.flname='' then Result:= Trim(self.fprefix+' '+self.fname)
  else Result:= Trim(self.fprefix+' '+self.flname);
end;


//TStudent Class Implementation Section
 constructor TStudent.Create(firstName: string; studentId: Integer; lastName: string = '');
begin
  inherited Create(firstName, lastName);
  self.fstudentId:=studentId;
end;

destructor TStudent.Destroy;
begin
  inherited;
end;

//function to get a students Id
function TStudent.GetStudentId: Integer;
begin
  Result:=self.fstudentId;
end;

end.
