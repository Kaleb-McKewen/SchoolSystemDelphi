{
School Unit for a school system
allowing classroom creation, adding/removing students to classrooms,
assigning teachers to classrooms and rolecall classrooms
}

unit uSchool;

interface

uses Generics.Collections, SysUtils, uPerson;

Type

{
Classroom Class
Used for storing an associated teacher,
associated students and outputing a rolecall
}
TClassroom = class
  private
    FClassroomId: Integer;


  protected
    constructor Create(classroomId: Integer);
    destructor Destroy; override;

  public
  FTeacher: TTeacher;
  FStudents: TList<TStudent>;
  procedure SetTeacher(NewTeacher: TTeacher);
  procedure AddStudent(NewStudent: TStudent);
  procedure RemoveStudent(Student: TStudent); overload;
  procedure RemoveStudent(StudentId: Integer); overload;
  function GetStudentCount: Integer;
  function RoleCall: String;

end;



{
School Class
Used for creating classrooms and storing multiple classrooms
}
TSchool = class
  private
    FClassrooms: Tlist<TClassroom>;

    public
      constructor Create;
      destructor Destroy; override;
      function CreateClassroom: TClassroom;
end;

implementation

//TClassroom Class Implementation Section
  constructor TClassroom.Create(classroomId: Integer);
  begin
     self.FClassroomId := classRoomId;
     self.FStudents := TList<TStudent>.Create;
  end;

  destructor TClassroom.Destroy;
  var i: integer;
  begin
    //check assignment before freeing
    if Assigned(self.FTeacher) then self.FTeacher.Free;
    if self.FStudents.Count>0 then
    begin
    //loop through all students in list
    for i := 0 to (self.FStudents.Count-1) do self.FStudents[i].free;
    end;
    self.FStudents.free;

    inherited;
  end;

  //procedure to set the teacher for the classroom
  procedure TClassroom.SetTeacher(NewTeacher: TTeacher);
  begin
    self.FTeacher:=NewTeacher;
  end;

  //procedure to add a student to classroom
  procedure TClassroom.AddStudent(NewStudent: TStudent);
  var i: Integer;
  begin
  //check if studentId from passed student object is already in use
    for i := 0 to self.FStudents.Count-1 do
    begin
      if self.FStudents[i].GetStudentId = NewStudent.GetStudentId then
      begin
      //raise exception if the studentId is already in use
      raise Exception.Create('Student id already exists in the classroom');
      exit;
      end;
    end;
    //add student
    self.FStudents.Add(NewStudent);
  end;

  //procedure to remove a student via student object
  procedure TClassroom.RemoveStudent(Student: TStudent);
  begin
  //check if student exists in the classroom before removing
    if self.FStudents.Contains(Student) then self.FStudents.Remove(Student)
    //raise exception if the student is not found
    else raise Exception.Create('Student is not enrolled in the classroom');

  end;

  //procedure to remove a student via studentId
  procedure TClassroom.RemoveStudent(StudentId: Integer);
  var i: Integer;
  begin
  //check if student exists in the classroom
  for i := 0 to self.FStudents.Count-1 do
    if self.FStudents[i].GetStudentId = StudentId then
    begin
    //if student exists remove from classroom
      self.FStudents[i].free;
     self.FStudents.Remove(self.FStudents[i]);
     exit;
    end;
    //raise exception if the student is not found
    raise Exception.Create('Student is not enrolled in the classroom');

  end;

  //function to return the number of students in the classroom
  function TClassroom.GetStudentCount: Integer;
  begin
    Result:=self.FStudents.Count;
  end;


  //function to return rolecall string for the classroom
  function TClassroom.RoleCall: string;
  var teacherText: String;
  var studentText: String;
  var i: Integer;
  begin
  //check if there is an assigned teacher
    if assigned(self.FTeacher) then
      teacherText:=self.FTeacher.ToString
    else teacherText:='No Teacher';
  //check if there are students
    if self.FStudents.Count > 0 then
    begin
      studentText:='Students: ';
      for i := 0 to (self.FStudents.Count-1) do studentText := studentText+self.FStudents[i].ToString+', ';
      //format string
      studentText:=Trim(studentText);
      delete(studentText,length(studentText),1);
    end
    else studentText:='No Students';
    //return rolecall text
    Result:=teacherText+', '+studentText;
  end;



//TSchool Class Implementation Section
  constructor TSchool.Create;
  begin
    self.FClassrooms := TList<TClassroom>.Create;
  end;

  destructor TSchool.Destroy;
  begin
    self.FClassrooms.Free;
  end;

  //function to create new classrooms (composition), returns instance
  function TSchool.CreateClassroom: TClassroom;
    var createdClassroom: TClassroom;
    begin
      //pass auto incrementing ID
       createdClassroom := TClassroom.Create(self.FClassrooms.Count+1);
       self.FClassrooms.add(createdClassroom);
       //return instance of the newly made classroom
       Result := createdClassroom;
    end;
end.
