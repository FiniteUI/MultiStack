WITH Ada.Text_Io, Ada.Integer_Text_Io, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO, ada.float_text_io, multiGStack;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO, Ada.Float_Text_Io;

PROCEDURE MultiGstackDriver IS

   IOString: Ada.Strings.Unbounded.Unbounded_String; --String for push and pop
   choice: integer; --Choice for stacktype and operation
   MinSpacePercent: Float; --Mimimum percent of available memory needed to reallocate
   N: Integer; --Number of stacks
   L0: Integer; --Base of useable area in stackspace
   M: Integer; --Last location of useable area in stackspace
   ArrayMinI: Integer; --Base of stackSpace
   ArrayMaxI: Integer; --LastLocation of stackspace
   K: Integer; --Stack to do operation in
   Success: Boolean; --For push and pop success
   PrintS: Ada.Strings.Unbounded.Unbounded_String; --String for printout

   TYPE MonthName IS (January, February, March, April, May, June, July, August, September, October, November, December, Empty);
   PACKAGE MonthIO IS NEW Ada.Text_IO.Enumeration_IO(MonthName);
   USE MonthIO;

   TYPE Date IS RECORD
      Month: MonthName;
      Day: Integer RANGE 1..31;
      Year: Integer RANGE 1400..2020;
   END RECORD;

   IODate: Date := (Empty, 1, 2000);--Date for push and pop
   PrintD: Date;--Date for printout

   PROCEDURE DateGet(x: out Date) IS
   BEGIN
      Get(X.Month);
      Get(X.Day);
      get(x.year);
   END Dateget;

   PROCEDURE DatePut(X: IN Date) IS
   BEGIN
      Put(X.Month); put(" "); Put(X.Day, 0); put(", "); Put(X.Year, 0);
   END DatePut;

BEGIN
   Put("1 for string multistack, 2 for Date multistack, 0 to exit:");
   Get(Choice); new_line;
   Put("Enter the number of stacks to use:");
   Get(N); new_line;
   Put("Enter the base of the main array:");
   Get(ArrayMini); new_line;
   Put("Enter the last location of the main array:");
   Get(ArrayMaxi); new_line;
   Put("Enter the base of useable area in main array:");
   Get(L0); new_line;
   Put("Enter the last location of useable area in main array:");
   Get(M); New_Line;
   Put("Enter the minimum percent of space wanted available to preform reallocation in decimal form:");
   Get(MinSpacePercent); New_Line;

   CASE Choice IS
      WHEN 1 =>
         DECLARE
            PACKAGE StringMultiStack IS NEW MultiGstack(MinSpacePercent, N, L0, M, ArrayMinI, ArrayMaxI, Ada.Strings.unbounded.Unbounded_String);
            USE StringMultiStack;
         BEGIN
            LOOP
               Put("1 to push, 2 to pop, 0 to exit:");
               Get(Choice); New_Line;

               CASE Choice IS
                  WHEN 1 => --Push
                     Put("Enter number of stack to push in followed by string to push:");
                     Get(K); get_line(IOString); new_line;
                     Put("Attempting to push string '"); Put(IOString); Put("' in stack "); Put(K, 0); Put("..."); New_Line;
                     push(IOString, k, success);
                     IF (Success) THEN
                        put("Successfully pushed String '"); Put(IOString); Put("' in stack "); Put(K, 0); new_line;
                     ELSE
                        Put("Error on push in stack "); Put(K, 0); Put(": Stack Overflow. Attempting reallocation..."); New_Line;
                        Put_line("Stack information before reallocation: "); OutputStackInfo;
                        Put_Line("Contents of memory before reallocation:");

                        FOR I IN ArrayMinI..ArrayMaxI LOOP
                           OutputMemory(i, prints);
                           Put("StackSpace["); Put(I, 0); Put("] = "); put(Prints); new_line;
                        END LOOP;

                        Reallocate(IOString, K, Success);
                        IF (Success) THEN
                           Put("Reallocation succesful, push of string '"); Put(IOString); Put("' in stack "); Put(K, 0); Put(" successful."); New_Line;
                           Put_line("Stack information after reallocation: "); OutputStackInfo;
                           Put_Line("Contents of memory after reallocation: ");
                           FOR I IN ArrayMini..ArrayMaxi LOOP
                              OutputMemory(i, prints);
                              Put("StackSpace["); Put(I, 0); Put("] = "); put(Prints); new_line;
                           END LOOP;

                        ELSE
                           Put_Line("Error in reallocation: Available space is less then minimum available space requirement. Terminating Program...");
                           --OutputVariables; for debugging
                           EXIT;

                        END IF;--If reallocation is successful
                     END IF;--If reallocation is necessary/push is successful

                  WHEN 2 =>--Pop
                     Put("Enter number of stack to pop:");
                     Get(K); New_Line;
                     Pop(IOString, K, Success);
                     put("Attempting to pop stack "); put(k, 0); put("..."); new_line;
                     IF (Success = false) THEN
                        Put("Error in stack "); Put(K, 0); Put(": Stack Underflow"); new_line;
                     ELSE
                        Put("Popping of stack "); put(k, 0); put(" successful, Result: "); Put(IOString); new_line;
                     END IF;

                  WHEN 0 =>--Exit
                     EXIT;

                  WHEN OTHERS =>
                     Put_Line("Error: Invalid input");

               END CASE;
            END LOOP;
         END;--End StringMultiStack

      WHEN 2 =>
         DECLARE PACKAGE DateMultiStack IS NEW MultiGStack(MinSpacePercent, N, L0, M, ArrayMini, ArrayMaxi, Date);
            USE DateMultiStack;
         BEGIN
            Initialize(IODate); --Easy fix for exceptions on dateput when stackSpace(i) is null
            loop
               Put("1 to push, 2 to pop, 0 to exit:");
               Get(Choice); New_Line;
               CASE Choice IS
                  WHEN 1 =>--push
                     Put("Enter number of stack to push in followed by date to push:");
                     Get(K); dateGet(IODate); new_line;
                     Put("Attempting to push date '"); datePut(IODate); Put("' in stack "); Put(K, 0); Put("..."); New_Line;
                     Push(IODate, K, Success);
                     IF (Success) THEN
                        put("Successfully pushed date '"); datePut(IODate); Put("' in stack "); Put(K, 0); new_line;
                     ELSE
                        Put("Error on push in stack "); Put(K, 0); Put(": Stack Overflow. Attempting reallocation..."); New_Line;
                        Put_line("Stack information before reallocation: "); OutputStackInfo;
                        Put_Line("Contents of memory before reallocation:");

                        FOR I IN ArrayMini..ArrayMaxi LOOP
                           OutputMemory(i, printd);
                           Put("StackSpace["); Put(I, 0); Put("] = ");
                           IF (PrintD = (Empty, 1, 2000)) then
                                    null;
                              ELSE
                                 DatePut(PrintD);
                              END IF;
                              new_line;
                        END LOOP;

                        Reallocate(IODate, K, Success);
                        IF (Success) THEN
                           Put("Reallocation succesful, push of date '"); datePut(IODate); Put("' in stack "); Put(K, 0); Put(" successful."); New_Line;
                           Put_line("Stack information after reallocation: "); OutputStackInfo;
                           Put_Line("Contents of memory after reallocation: ");
                           FOR I IN ArrayMini..ArrayMaxi LOOP
                              OutputMemory(i, printD);
                              Put("StackSpace["); Put(I, 0); Put("] = ");
                              IF (PrintD = (Empty, 1, 2000)) then
                                    null;
                              ELSE
                                 DatePut(PrintD);
                              END IF;
                              new_line;
                           END LOOP;
                        ELSE
                           Put_Line("Error in reallocation: Available space is less then minimum available space requirement. Terminating Program...");
                           --OutputVariables; for debugging
                           EXIT;
                        END IF;
                     END IF;

                  WHEN 2 =>--pop
                     Put("Enter number of stack to pop:");
                     Get(K); New_Line;
                     Pop(IODate, K, Success);
                     Put("Attempting to pop stack "); Put(K, 0); Put("..."); New_Line;
                     IF (Success = false) THEN
                        Put("Error in stack "); Put(K, 0); Put(": Stack Underflow"); new_line;
                     ELSE
                        Put("Popping of stack "); Put(K, 0); Put(" successful, Result: "); DatePut(IODate); New_Line;
                     END IF;

                  WHEN 0 =>
                     exit;
                  WHEN OTHERS =>
                     put("Error: Invalid input");
               END CASE;
            END LOOP;


         END;--End DateMultiStack


      WHEN OTHERS =>
         Put_Line("Error: Invalid input. Exiting Program...");
   END CASE;
END MultiGstackdriver;


