WITH Ada.Integer_Text_Io; USE Ada.Integer_Text_Io;
WITH Ada.Text_Io; USE Ada.Text_IO;
PACKAGE BODY MultiGStack IS

   OT_NB_G: ARRAY(1..N+1) OF Integer;--Array containing OldTop[j] = NewBase[J] = Growth[J-1]
   Base: ARRAY(1..N+1) OF Integer;
   Top: ARRAY(1..N) OF Integer;
   StackSpace: Array(ArrayMin..ArrayMax) of Item;

   AvailSpace: Integer;
   TotalInc: Integer;
   Alpha: float;
   Beta: float;
   Tau: float;
   Sigma: float;
   Deltaa: integer;
   EqualAllocate: constant Float := 0.07;
   J: Integer;
   MinSpace : Integer;

   PROCEDURE Push(X: IN Item; k: IN Integer; Success: OUT Boolean) IS
   BEGIN
      Top(K) := Top(K) + 1;
      --put(top(k)); put(base(k+1)); for debugging
      IF (Top(k) > Base (k+1)) THEN
         Success := False;
         Else
         Success := True;
         StackSpace(Top(k)) := X;
      END IF;
   END Push;

   PROCEDURE Pop(X: OUT Item; k: IN Integer; Success: OUT Boolean) IS
   BEGIN
      IF (Top(k) = Base(k)) THEN
         Success := False;
      ELSE
         X := StackSpace(Top(k));
         Top(k) := Top(k) - 1;
         Success := True;
      END IF;
   END Pop;

   PROCEDURE Reallocate(X: IN Item; k: IN Integer; Success: OUT Boolean) IS
   BEGIN
      AvailSpace := M - L0;
      TotalInc := 0;
      J := N;
      WHILE (J > 0) LOOP
         --put(j); for debugging
         AvailSpace := AvailSpace - (Top(J) - Base(J));
         IF (Top(J) > OT_NB_G(J)) THEN
            OT_NB_G(J+1) := Top(J) - OT_NB_G(J);
            TotalInc := TotalInc + OT_NB_G(j+1);
         ELSE
            OT_NB_G(j+1) := 0;
         END IF;
         J := J - 1;
      END LOOP;

      IF AvailSpace < (MinSpace - 1) THEN
         Success := False;
      ELSE
         Success := true;
         Alpha := EqualAllocate * Float(AvailSpace) / Float(N);
         Beta := (1.0 - EqualAllocate) * Float(AvailSpace) / float(TotalInc);

         OT_NB_G(1) := Base(1);
         Sigma := 0.0;

         FOR I IN 2..N LOOP
            Tau := Sigma + Alpha + float(OT_NB_G(I)) * Beta;
            OT_NB_G(I) := OT_NB_G(I-1) + (Top(I-1) - Base(I-1)) + Floor(Tau) - Floor(Sigma);
            Sigma := Tau;
         END LOOP;

         Top(K) := Top(K) - 1;
         MoveStack;
         Top(K) := Top(K) + 1;
         StackSpace(Top(K)) := X;
         FOR I IN 1..N LOOP
            OT_NB_G(I) := Top(I);
         END LOOP;
      END IF;
   END Reallocate;


   PROCEDURE MoveStack IS
   BEGIN
      FOR I IN 2..N LOOP
         IF OT_NB_G(I) < Base(I) THEN
            Deltaa := Base(I) - OT_NB_G(I);
            FOR L IN (Base(I) + 1)..Top(I) LOOP
               StackSpace(L - Deltaa) := StackSpace(L);
            END LOOP;
            Base(I) := OT_NB_G(I);
            Top(i) := Top(i) - Deltaa;
         END IF;
      END LOOP;

      FOR I IN REVERSE 2..N LOOP
         IF OT_NB_G(I) > Base(I) THEN
            Deltaa := OT_NB_G(I) - Base(I);
            FOR L IN REVERSE (Base(I) + 1)..Top(I) LOOP
               StackSpace(L + Deltaa) := StackSpace(L);
            END LOOP;
            Base(I) := OT_NB_G(I);
            Top(i) := Top(i) + Deltaa;
         END IF;
      END LOOP;
   END MoveStack;


   FUNCTION Floor( X: IN Float) RETURN Integer IS
      FloorValue: Integer;
   BEGIN
      FloorValue := Integer(X);
      IF Float(FloorValue) <= X THEN
         RETURN FloorValue;
      ELSE
         RETURN FloorValue-1;
      end if;
   END Floor;

   Procedure OutputMemory(X: IN Integer; y: out item) IS
    BEGIN
      Y := StackSpace(X);
    END OutputMemory;

    PROCEDURE OutputStackInfo IS
    BEGIN
       FOR I IN 1..N LOOP
          Put("Base of stack "); Put(I, 0); Put(": "); Put(Base(I), 0); New_Line;
          Put("Top of stack "); put(i, 0); put(": "); put(Top(i), 0); new_line;
       END LOOP;
    END OutputStackInfo;

    PROCEDURE Outputvariables IS--For debugging
    BEGIN
       Put("AvailSpace: "); Put(AvailSpace, 0); New_Line;
       Put("TotalInc: "); Put(TotalInc, 0); New_Line;
       Put("MinSpace: "); Put(MinSpace, 0); New_Line;
    END Outputvariables;

    PROCEDURE Initialize(X: IN Item) IS
    BEGIN
       FOR I IN ArrayMin..ArrayMax LOOP
          StackSpace(I) := X;
       END LOOP;
    END Initialize;


BEGIN
   FOR I IN 1..N LOOP
      Base(I) := Floor(float(I-1) / float(N) * float(M)) + L0;
      Top(I) := Base(I);
      OT_NB_G(I) := Top(I);
   END LOOP;

Base(N + 1) := M;
MinSpace := Floor(float(M - L0 + 1) * MinSpacePercent);

end multiGStack;
