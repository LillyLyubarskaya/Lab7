-----------------------------------------------
-- ПРО Lab № 2--
-- Любарська Л.В.--
----ІО-21------------
-----10.09.14
-- 1.07: MR = (A*SORT(C)) *(MA*MM+MN)--
-- 2.27: MD = (MA*MB)*TRANS(MC)--
-- 3.01: MA = MB*MC+ MM--
------------------------------------------------
with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package body Data is
------------Input for vectors---------------
    procedure Input1 (VA: out Vector) is
       buffer: integer;
       begin
          put("Enter Vector ");
	  put(N);
          put(" amount: ");
	  New_line;
	  for i in 1..N loop
             get(buffer);
             VA(i) := buffer;
              put(" ");
	  end loop;
   end Input1;
 --------------Input for matrix-------------------------
   procedure Input2(MA: out Matrix) is
      buffer: integer;
      begin
         put("Enter matrix ");
         put(N);
	 put(" : ");
	 New_Line;
	 for i in 1..N loop
	    for j in 1..N loop
		get(buffer);
		MA(i)(j) := buffer;
		put(" ");
	    end loop;
	    New_Line;
	 end loop;
   end Input2;
--------------Output for vectors----------------------------
   procedure Output1(VA: in Vector) is
	 begin
	    put("| ");
  	    for i in 1..N loop
	       put(VA(i));
	       put(" ");
	    end loop;
	    put("|");
	    New_Line;
   end Output1;
  --------------Output for matrix----------------------------
   procedure Output2(MA: in Matrix) is
       begin
	  for i in 1..N loop
	     Output1(MA(i));
	     New_Line;
	  end loop;
   end Output2;
   --------------Multiply Vector and Vector--------------------
   function Multiply1(VA, VB: in Vector) return integer is
       sum: integer := 0;
       begin
	 for i in 1..N loop
	     sum := sum + VA(i) * VB(i);
	 end loop;
	return sum;
   end Multiply1;
   --------------Add Matrix and Matrix--------------------
   function Add(MA,MB: in Matrix) return Matrix is
      MR:Matrix;
      begin
        for i in 1..N loop
	   for j in 1..N  loop
	     MR(i)(j):= MA(i)(j)+MB(i)(j);
	   end loop;
        end loop;
        return MR;
   end Add;
   --------------Multiply Matrix and Matrix--------------------
   procedure Multiply2(MA, MB: in Matrix;MC: out Matrix) is
       begin
       for i in 1..N loop
	  for j in 1..N loop
	     MC(i)(j) := 0;
	     for k in 1..N loop
	     MC(i)(j) := MC(i)(j) + MA(i)(k) * MB(k)(j);
	     end loop;
	  end loop;
      end loop;
   end Multiply2;
   ----------------Transposition------------------------------
   function Trans(MA: in  Matrix) return Matrix is
       MB: Matrix;
       begin
       for i in 1..N loop
           for j in 1..N loop
	      MB(j)(i) := MA(i)(j);
	end loop;
      end loop;
    return MB;
   end Trans;
    ----------------Vector sorting------------------------------
   function Sort(VA: in Vector) return Vector is
      VB:Vector;
      buffer: integer;
     begin
         for i in 1..N loop
            VB(i):=VA(i);
         end loop;
	for i in 1..N loop
	   for j in 1..N - 1 loop
	      if VB(j) > VB(j + 1) then
	         buffer := VA(j);
	         VB(j) := VB(j + 1);
	         VB(j + 1) := buffer;
	      end if;
	   end loop;
        end loop;
        return VB;
     end Sort;
  -------------Multiply Matrix and Vector---------------------
   procedure Multiply3(MA: in Matrix;VA: in Vector;VB: out Vector) is
       begin
           for i in 1..N loop
	       VB(i) := 0;
	       for j in 1..N loop
	          VB(i) := VB(i) + VA(j) * MA(j)(i);
	       end loop;
	   end loop;
     end Multiply3;
   -----------Multiply number and matrix----------------------
   procedure  Multiply4(MA: in Matrix;a: in integer;MB: out Matrix) is
      begin
         for i in 1..N loop
	    for j in 1..N loop
		MB(i)(j) := a * MA(i)(j);
	    end loop;
	 end loop;
   end Multiply4;
 --------MR = (A*SORT(C)) *(MA*MM+MN)
   function f1(A,C: in Vector;MA,MM,MN:in Matrix) return Matrix is
      i, j: integer;
      s:integer;
      MR1:Matrix;
      MR2:Matrix;
      MR:Matrix;
      B:Vector;
      begin
         B:=Sort(C);
         s:=Multiply1(A,B);
         Multiply2(MA,MM,MR1);
         MR2:=Add(MR1,MN);
         Multiply4(MR2,s,MR);
      return MR;
   end f1;
  ----- MD = (MA*MB)*TRANS(MC)--
   function f2(MA,MB,MC: in Matrix) return Matrix is
      MBuf1:Matrix;
      MBuf2:Matrix;
      MR:Matrix;
   begin
      MBuf1:= Trans(MC);
      Multiply2(MA,MB,MBuf2);
      Multiply2(MBuf2,MBuf1,MR);
      return MR;
   end f2;
-- 3.01: MA = MB*MC+ MM--
   function f3(MA,MB,MC: in Matrix) return Matrix is
      MBuf2:Matrix;
      MR:Matrix;
   begin

      Multiply2(MA,MB,MBuf2);
      MR:=Add(MBuf2,MC);
      return MR;
   end f3;
end Data;
