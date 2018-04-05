GENERIC

   MinSpacePercent: float; --Minimum available space required for worth while reallocation
   N: Integer; --Number of stacks
   L0: Integer; --L0, Base of area in array we can use
   M: Integer; --Last location of area in array we can use
   ArrayMin: integer; --Base of main array
   ArrayMax: integer; --Last location of main array
   TYPE Item IS PRIVATE;

   PACKAGE MultiGStack IS
      PROCEDURE Push(X: IN Item; k: IN Integer; Success: OUT Boolean);
      PROCEDURE Pop(X: OUT Item; k: IN Integer; Success: OUT Boolean);
      PROCEDURE Reallocate(X: IN Item; k: IN Integer; Success: OUT Boolean);
      PROCEDURE MoveStack;
      PROCEDURE OutputMemory(X: IN Integer; Y: OUT Item);
      PROCEDURE OutputStackInfo;
      PROCEDURE OutputVariables;
      Procedure Initialize(x: in item);
      FUNCTION Floor(X: IN Float) Return Integer;
   end;

