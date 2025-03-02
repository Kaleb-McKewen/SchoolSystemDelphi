{
School Test Unit using DUnitX
Used to test and develop the School Unit using TDD
}
unit uSchoolTest;

interface

uses
  DUnitX.TestFramework, uSchool, uPerson;

type
  [TestFixture]
  {
  Testing Class
  }
  SchoolTest = class
  private
  ObjSchool : TSchool;
  ObjClassroom : TClassroom;

  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    //test instantiating a new classroom
    [Test]
    procedure CreateClassroom;

    //teacher tests
    //test instantiating a new teacher
    [TestCase ('CreatingTeacher', 'Sam,Lung,Mr,Mr Lung')]
    procedure CreateTeacher(FirstName, LastName, Prefix, Expected: String);
    //test instantiating a new teacher with no last name
    [TestCase ('CreatingTeacherNoLastName', 'Sam,Mrs,Mrs Sam')]
    procedure CreateTeacherNoLastName(FirstName, Prefix, Expected: String);
    //test adding a teacher to a classroom
    [TestCase ('AddingTeacherToClassroom', 'Sam,Lung,Mr,Mr Lung')]
    procedure AddTeacherToClassroom(FirstName, LastName, Prefix, Expected: String);
    //test adding a teacher to a classroom then changing with a new teacher
    [TestCase ('ChangingTeacher', 'Sam,Lung,Mr,Jade,Ev,Mrs,Mrs Ev')]
    procedure ChangingTeacher(FirstName1, LastName1, Prefix1, FirstName2, LastName2, Prefix2, Expected: String);
    //test instantiating a new student
    [TestCase ('CreateStudent', 'John,Deer,John Deer')]
    procedure CreateStudent(FirstName, LastName, Expected: String);
    //test instantiating a new student with no last name
    [TestCase ('CreatingStudentNoLastName', 'Joe,Joe')]
    procedure CreateStudentNoLastName(FirstName, Expected: String);
    //test adding a student to a classroom
    [TestCase ('AddingStudentToClassroom', 'Jeff,Mue,Jeff Mue')]
    procedure AddStudentToClassroom(FirstName, LastName, Expected: String);
    //test adding multiple student to a classroom
    [TestCase ('AddingManyStudentsToClassroom', 'Jeff,Mue,Jimmy,Netron,Jeff Mue Jimmy Netron')]
    procedure AddingManyStudentsToClassroom(FirstName1, LastName1,FirstName2,LastName2,Expected: String);
    //test adding a student with the same id
    [TestCase ('AddingStudentsWithTheSameIdToClassroom', 'Jeff,Mue,Jimmy,Netron,Student id already exists in the classroom')]
    procedure AddingStudentsWithTheSameIdToClassroom(FirstName1, LastName1,FirstName2,LastName2, ExceptionMessage, Expected: String);

    //rolecall tests
    //test an empty rolecall
    [TestCase ('RoleCallEmpty', 'No Teacher, No Students',';')]
    procedure RoleCallEmpty(Expected: String);
    //test teacher no students rolecall
    [TestCase ('RoleCallOneTeacherNoStudents', 'Charlie;Lad;Mr;Mr Lad, No Students',';')]
    procedure RoleCallOneTeacherNoStudents(TeacherName,TeacherLastName,Prefix,Expected: String);
    //test no teacher one student rolecall
    [TestCase ('RoleCallNoTeacherOneStudents', 'Johnny;Sam;No Teacher, Students: Johnny Sam',';')]
    procedure RoleCallNoTeacherOneStudents(StudentName,StudentLastName,Expected: String);
    //test teacher and multiple students rolecall
    [TestCase ('RoleCallTeacherStudents', 'Charlie;Lad;Mr;Johnny;Sam;Jeff;Mue;Mr Lad, Students: Johnny Sam, Jeff Mue',';')]
    procedure RoleCallTeacherStudents(TeacherName,TeacherLastName,Prefix,StudentName1,StudentLastName1,StudentName2,StudentLastName2,Expected: String);
    //test adding a student to a classroom and removing the student
    [TestCase ('RemovingStudentFromClassroom', 'Jeff;Mue;No Teacher, No Students',';')]
    procedure RemovingStudentFromClassroom(FirstName, LastName, Expected: String);
    //test adding two students to a classroom and then removing one student
    [TestCase ('RemovingStudentWithManyStudentsFromClassroom', 'Jeff;Mue;Jimmy;Netron;No Teacher, Students: Jeff Mue', ';')]
    procedure RemovingStudentWithManyStudentsFromClassroom(FirstName, LastName,ToBeRemovedFirstName,ToBeRemovedLastName,Expected: String);
    //test removing student that does not exist in the classroom
    [TestCase ('RemovingNoExistantStudentFromClassroom', 'Student is not enrolled in the classroom')]
    procedure RemovingNoExistantStudentFromClassroom(ExceptionMessage, Expected: String);
  end;

implementation

procedure SchoolTest.Setup;
begin
  ReportMemoryLeaksOnShutdown := True;
  ObjSchool := TSchool.create;
  ObjClassroom := ObjSchool.CreateClassroom;
end;

procedure SchoolTest.TearDown;
begin
  ObjClassroom.free;
  ObjSchool.free;
end;

procedure SchoolTest.CreateClassroom;
begin
  assert.AreEqual(ObjClassroom.GetStudentCount,0);
end;

procedure SchoolTest.CreateTeacher(FirstName, LastName, Prefix: string; Expected: string);
var Teacher: TTeacher;
begin
Teacher:=TTeacher.Create(FirstName, Prefix, 1, LastName);
assert.AreEqual(Teacher.toString,Expected);
Teacher.free;
end;

procedure SchoolTest.CreateTeacherNoLastName(FirstName, Prefix: string; Expected: string);
var Teacher: TTeacher;
begin
Teacher:=TTeacher.Create(FirstName,Prefix, 1);
assert.AreEqual(Teacher.toString,Expected);
Teacher.free;
end;

procedure SchoolTest.AddTeacherToClassroom(FirstName,LastName,Prefix: string; Expected: string);
var Teacher: TTeacher;
begin
    Teacher:=TTeacher.Create(FirstName,Prefix,1,LastName);
    ObjClassroom.SetTeacher(Teacher);
    assert.AreEqual(ObjClassroom.FTeacher.toString,Expected);
end;

procedure SchoolTest.ChangingTeacher(FirstName1: string; LastName1: string; Prefix1: string; FirstName2: string; LastName2: string; Prefix2: string; Expected: string);
var Teacher1: TTeacher;
var Teacher2: TTeacher;
begin
    Teacher1:=TTeacher.Create(FirstName1,Prefix1,1,LastName1);
    ObjClassroom.SetTeacher(Teacher1);
    Teacher2:=TTeacher.Create(FirstName2,Prefix2,2,LastName2);
    ObjClassroom.SetTeacher(Teacher2);
    assert.AreEqual(ObjClassroom.FTeacher.toString,Expected);
    Teacher1.free;
end;

procedure SchoolTest.CreateStudent(FirstName: string; LastName: string; Expected: string);
var Student: TStudent;
begin
    Student:=TStudent.Create(FirstName,1,LastName);
    assert.AreEqual(Student.toString,Expected);
    Student.free;
end;

procedure SchoolTest.CreateStudentNoLastName(FirstName: string; Expected: string);
var Student: TStudent;
begin
  Student:=TStudent.Create(FirstName,1);
  assert.AreEqual(Student.toString,Expected);
  Student.free;
end;

procedure SchoolTest.AddStudentToClassroom(FirstName,LastName: string; Expected: string);
var Student: TStudent;
begin
    Student:=TStudent.Create(FirstName,1,LastName);
    ObjClassroom.AddStudent(Student);
    assert.AreEqual(ObjClassroom.FStudents[0].toString,Expected);
    assert.AreEqual(ObjClassroom.GetStudentCount,1);
end;

procedure SchoolTest.AddingManyStudentsToClassroom(FirstName1: string; LastName1: string; FirstName2: string; LastName2: string; Expected: string);
var Student1, Student2: TStudent;
begin
    Student1:=TStudent.Create(FirstName1,1,LastName1);
    ObjClassroom.AddStudent(Student1);
    Student2:=TStudent.Create(FirstName2,2,LastName2);
    ObjClassroom.AddStudent(Student2);
    assert.AreEqual(ObjClassroom.FStudents[0].toString+' '+ObjClassroom.FStudents[1].toString,Expected);
    assert.AreEqual(ObjClassroom.GetStudentCount,2);
end;

procedure SchoolTest.AddingStudentsWithTheSameIdToClassroom(FirstName1: string; LastName1: string; FirstName2: string; LastName2: string; ExceptionMessage: string; Expected: string);
var Student1, Student2: TStudent;
begin
  Student1:=TStudent.Create(FirstName1,1,LastName1);
  ObjClassroom.AddStudent(Student1);
  Student2:=TStudent.Create(FirstName2,1,LastName2);
  Assert.WillRaiseWithMessage(procedure
    begin
   ObjClassroom.AddStudent(Student2);
   end, nil, ExceptionMessage);
   Student2.Free;
end;

procedure SchoolTest.RoleCallEmpty(Expected: string);
begin
  assert.AreEqual(ObjClassroom.RoleCall,Expected);
end;

procedure SchoolTest.RoleCallOneTeacherNoStudents(TeacherName: string; TeacherLastName: string; Prefix: string; Expected: string);
var Teacher: TTeacher;
begin
    Teacher:=TTeacher.Create(TeacherName,Prefix,1,TeacherLastName);
    ObjClassroom.SetTeacher(Teacher);
    assert.AreEqual(ObjClassroom.RoleCall,Expected);
end;

procedure SchoolTest.RoleCallNoTeacherOneStudents(StudentName: string; StudentLastName: string; Expected: string);
var Student: TStudent;
begin
    Student:=TStudent.Create(StudentName,1,StudentLastName);
    ObjClassroom.AddStudent(Student);
    assert.AreEqual(ObjClassroom.RoleCall,Expected);
end;

procedure SchoolTest.RoleCallTeacherStudents(TeacherName: string; TeacherLastName: string; Prefix: string; StudentName1: string; StudentLastName1: string; StudentName2: string; StudentLastName2: string; Expected: string);
var Teacher: TTeacher;
var Student1: TStudent;
var Student2: TStudent;
begin
     Teacher:=TTeacher.Create(TeacherName,Prefix,1,TeacherLastName);
     ObjClassroom.SetTeacher(Teacher);
     Student1:=TStudent.Create(StudentName1,1,StudentLastName1);
    ObjClassroom.AddStudent(Student1);
    Student2:=TStudent.Create(StudentName2,2,StudentLastName2);
    ObjClassroom.AddStudent(Student2);
    assert.AreEqual(ObjClassroom.RoleCall,Expected);
end;

procedure SchoolTest.RemovingStudentFromClassroom(FirstName: string; LastName: string; Expected: string);
var Student: TStudent;
begin
    Student:=TStudent.Create(FirstName,1,LastName);
    ObjClassroom.AddStudent(Student);
    ObjClassroom.RemoveStudent(1);
    assert.AreEqual(ObjClassroom.RoleCall, Expected);
end;

procedure SchoolTest.RemovingStudentWithManyStudentsFromClassroom(FirstName: string; LastName: string; ToBeRemovedFirstName: string; ToBeRemovedLastName: string; Expected: string);
var Student1: TStudent;
var Student2: TStudent;
begin
   Student1:=TStudent.Create(FirstName,1,LastName);
    ObjClassroom.AddStudent(Student1);
    Student2:=TStudent.Create(ToBeRemovedFirstName,2,ToBeRemovedLastName);
    ObjClassroom.AddStudent(Student2);
    ObjClassroom.RemoveStudent(2);
    assert.AreEqual(ObjClassroom.RoleCall, Expected);
end;

procedure SchoolTest.RemovingNoExistantStudentFromClassroom(ExceptionMessage: string; Expected: string);
begin
    Assert.WillRaiseWithMessage(procedure
    begin
   ObjClassroom.RemoveStudent(53)
   end, nil, ExceptionMessage);
end;

initialization
  TDUnitX.RegisterTestFixture(SchoolTest);

end.
