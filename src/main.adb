
-----------------------------------------------
-- Laboratory work # 1: Ada semaphores---------
-- Task: A = (B*(MO+MK))*(MO*MK)---------------
-- Author: Lyubarska L.V., group IO-21---------
-- Last modified date: 03.02.2015--------------
-----------------------------------------------
with  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Synchronous_Task_Control,Ada.Strings.Unbounded;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Synchronous_Task_Control,Ada.Strings.unbounded;
procedure Main is
   -- Vectors size
   N: positive :=8 ;
  -- Processors count
   P: positive := 8;
   -- Part
   H: positive := N/P;
   ---Types
   type Vec is array (Integer range <>) of Integer;
   subtype Vector is Vec (1..N);
   subtype VectorH is Vec (1..H);
   subtype Vector2H is Vec (1..2*H);
   subtype Vector3H is Vec (1..3*H);
   subtype Vector4H is Vec (1..4*H);
   type Matr is array(integer range<>) of Vector;
   subtype Matrix is Matr(1..N);
   subtype MatrixH is Matr(1..H);
   subtype Matrix2H is Matr(1..2*H);
   subtype Matrix3H is Matr(1..3*H);
   subtype Matrix4H is Matr(1..4*H);
   procedure count(A: out VectorH;B: in Vector;MO:in Matrix;alpha:in integer;Z:in VectorH;MK: in MatrixH) is
      MZ:MatrixH;
      temp: integer;
      tempV: Vector;
   begin
      for i in 1..H loop
         for j in 1..N loop
            temp:= 0;
            for k in 1..N loop
               temp := temp + MO(k)(j)*MK(i)(k);
            end loop;
            tempV(j):=temp;
         end loop;
            temp := 0;
            for j in 1..N loop
               temp := temp + B(j)*tempV(j);
            end loop;
            A(i):= temp - alpha*Z(i);
      end loop;
   end count;
   procedure Output1(VA: in Vector) is
   begin
      	if (N<10) then
	    put("| ");
  	    for i in 1..N loop
	       put(VA(i));
	       put(" ");
	    end loop;
	    put("|");
         New_Line;
         end if;
   end Output1;
   procedure Output3(VA: in VectorH) is
   begin
      	if (H<10) then
	    put("| ");
  	    for i in 1..H loop
	       put(VA(i));
	       put(" ");
	    end loop;
	    put("|");
         New_Line;
         end if;
   end Output3;
   ------------Input for vectors---------------
    procedure Input1 (VA: out Vector) is
       begin
	  for i in 1..N loop
             VA(i) := 1;
       end loop;
   end Input1;
 --------------Input for matrix-------------------------
   procedure Input2(MA: out Matrix) is
      begin
	 for i in 1..N loop
	    for j in 1..N loop
		MA(i)(j) := 1;
	    end loop;
	 end loop;
   end Input2;
   procedure Output2(MA: in Matrix) is
      begin
	 for i in 1..N loop
	    for j in 1..N loop
		Put(MA(i)(j));
            end loop;
            New_Line;
	 end loop;
   end Output2;
   ----------T1------------------------------------------
   procedure Start is
      task T1 is
         entry setData(MK:in MatrixH;alpha:in integer;B:in Vector);
         entry getData(MO:out Matrix;Z: out Vector2H);
         entry getRes(A:out VectorH);
      end T1;
      task T2 is
         entry setData(MK:in Matrix2H;alpha:in integer;B:in Vector);
         entry getData(MO:out Matrix;Z: out VectorH);
         entry getRes(A:out Vector2H);
      end T2;
      task T3 is
         entry setData(MK:in Matrix3H;alpha:in integer;B:in Vector);
         entry getRes(A:out Vector3H);
      end T3;
      task T4;
      task T5 is
         entry setData(MK:in Matrix4H;alpha:in integer;B:in Vector);
         entry getData(MO:out Matrix;Z: out VectorH);
         entry getRes(A:out Vector4H);
      end T5;
      task T6 is
        entry setData(MK:in Matrix3H;alpha:in integer;B:in Vector);
        entry getData(MO:out Matrix;Z: out Vector2H);
        entry getRes(A:out Vector3H);
      end T6;
      task T7 is
        entry setData(MK:in Matrix2H;alpha:in integer;B:in Vector);
        entry getData(MO:out Matrix;Z: out Vector3H);
        entry getRes(A:out Vector2H);
      end T7;
      task T8 is
        entry setData(MK:in MatrixH;alpha:in integer;B:in Vector);
        entry setData_1(MO:in Matrix;Z: in Vector4H);
        entry getData(MO:out Matrix;Z: out Vector3H);
        entry getRes(A:out VectorH);
      end T8;
      task body T1  is
         MK1,MZ:MatrixH;
         MO1:Matrix;
         Z1:Vector3H;
         Z2:Vector2H;
         alpha1,buf:Integer;
         B1:Vector;
         A1:VectorH;
      begin
         Put_Line("T1 started");
         --прием данных от Т8
         T8.getData(MO1,Z1);
         Put_Line("1.>> T1: T8->T1");
         --прием данных от Т2
         accept setData (MK : in MatrixH; alpha : in integer; B : in Vector) do
            MK1:=MK;
            alpha1:=alpha;
            B1:=B;
         end setData;
         Put_Line("2.>> T1: T2->T1");
         --передача данніх в Т2
         accept getData (MO : out Matrix; Z : out Vector2H) do
            --копируем в массив две последние части для Т2
           Z:=Z1(H+1..3*H);
           MO:=MO1;
         end getData;
         Put_Line("3.>> T1: T1->T2");
         --count
         count(A1,B1,MO1,alpha1,Z1(1..H),MK1);
         Output3(A1);
         accept getRes (A : out VectorH) do
            A:=A1;
         end getRes;
         Put_Line("Result 4.>> T1: T1->T2");
         Put_Line("T1 ended");
      end T1;
      task body T2  is
         Z2:Vector2H;
         MO2:Matrix;
         MK2:Matrix2H;
         alpha2:integer;
         B2:Vector;
         MK1:MatrixH;
         ZZ:VectorH;
         A2:Vector2H;
      begin
         Put_Line("T2 started");
         --прием данных от Т3
         accept setData (MK : in Matrix2H; alpha : in integer; B : in Vector) do
            MK2:=MK;
            alpha2:=alpha;
            B2:=B;
         end setData;
         Put_Line("1.>> T2: T3->T2");
         --передача данных в Т1
         --формируем МК1 - копируем 1..Н
         T1.setData(MK2(1..H),alpha2,B2);
          Put_Line("2.>> T2: T2->T1");
         --прием данных от Т1
         T1.getData(MO2,Z2);
         Put_Line("3.>> T2: T1->T2");
         --передача данніх в Т3
         accept getData (MO : out Matrix; Z : out VectorH) do
             --формируем Z3 копируем Н+1..2*H
            Z:=Z2(H+1..2*H);
            MO:=MO2;
         end getData;
         Put_Line("4.>> T2: T2->T3");
         count(A2(H+1..2*H),B2,MO2,alpha2,Z2(H+1..2*H),MK2(H+1..2*H));
         T1.getRes(A2(1..H));
         Put_Line("5.>> T2: T1->T2");
         accept getRes (A : out Vector2H) do
            A:=A2;
         end getRes;
         Put_Line("Result 6.>> T2: T2->T3");
         Put_Line("T2 ended");
    end T2;
    task body T3 is
       MK3:Matrix3H;
       alpha3:integer;
       B3:Vector;
       MK2:Matrix2H;
       Z3:VectorH;
         MO3:Matrix;
         A3:Vector3H;
       begin
            Put_Line("T3 started");
         --Прием данных от Т4
            accept setData (MK : in Matrix3H; alpha : in integer; B : in Vector) do
               MK3:=MK;
               alpha3:=alpha;
               B3:=B;
         end setData;
          Put_Line("1.>> T3: T4->T3");
         --Передача данных в Т2
         T2.setData(MK3(1..2*H),alpha3,B3);
         Put_Line("2.>> T3: T3->T2");
         --прием данных от Т2
         T2.getData(MO3,Z3);
         Put_Line("3.>> T3: T2->T3");
         count(A3(2*H+1..3*H),B3,MO3,alpha3,Z3,MK3(2*H+1..3*H));
         T2.getRes(A3(1..2*H));
         Put_Line("4.>> T3: T2->T3");
         accept getRes (A : out Vector3H) do
            A:=A3;
         end getRes;
         Put_Line("Result 5.>> T3: T3->T4");
         Put_Line("T3 ended");
      end T3;
    task body T4 is
    alpha4:integer;
    MK4:Matrix;
    MK3:Matrix3H;
    MK5:Matrix4H;
    B4:Vector;
    Z4:VectorH;
    MO4:Matrix;
    A4:Vector;
      begin
         Put_Line("T4 started");
         --ввод данніх
        Input2(MK4);
        alpha4:=1;
         Input1(B4);
         Put_Line(" T4: Input");
          --передача данніх в Т5
        T5.setData(MK4(4*H+1..N),alpha4,B4);
        Put_line("1.>> T4: T4->T5");
         --передача данніх в Т3
         T3.setData(MK4(1..3*H),alpha4,B4);
         Put_Line("2.>> T4: T4->T3");
         --прием данных от Т5
         T5.getData(MO4,Z4);
         Put_Line("3.>> T4: T5->T4");
         count(A4(3*H+1..4*H),B4,MO4,alpha4,Z4,MK4(3*H+1..4*H));
         T5.getRes(A4(4*H+1..N));
         Put_Line("5.>> T4: T5->T4");
          T3.getRes(A4(1..3*H));
         Put_Line("4.>> T4: T3->T4");
         Output1(A4);
      Put_Line("T4 ended");
    end T4;
   task body T5 is
      B5:Vector;
      alpha5:integer;
         MK5:Matrix4H;
         MK6:Matrix3H;
         Z5:Vector2H;
         Z4:VectorH;
         A5:Vector4H;
      MO5:Matrix;
   begin
         Put_Line("T5 started");
         --прием данных от Т4
      accept  setData(MK:in Matrix4H;alpha:in integer;B:in Vector)do
	    MK5:=MK;
	    alpha5:=alpha;
	    B5:=B;
         end setData;
         Put_Line("1.>> T5: T4->T5");
         --передача данных в Т6
         T6.setData(MK5(H+1..4*H),alpha5,B5);
         Put_Line("2.>> T5: T5->T6");
         --прием данных от Т6
         T6.getData(MO5,Z5);
         Put_Line("3.>> T5: T6->T5");
         --передача данных в Т4
         accept  getData(MO:out Matrix;Z: out VectorH)do
            Z:=Z5(1..H);
	    MO:=MO5;
         end getData;
         Put_Line("4.>> T5: T5->T4");
         count(A5(1..H),B5,MO5,alpha5,Z5(H+1..2*H),MK5(1..H));
         T6.getRes(A5(H+1..2*H));
         Put_Line("5.>> T5: T6->T5");
         accept getRes (A : out Vector4H) do
            A:=A5;
         end getRes;
         Put_Line("Result: 6.>> T5: T5->T4");
      Put_Line("T5 ended");
    end T5;
    task body T6 is
	Z6:Vector3H;
	MO6:Matrix;
	MK6:Matrix3H;
	alpha6:integer;
	B6:Vector;
        MK7:Matrix2H;
        A6:Vector3H;
      begin
            Put_Line("T6 started");
           --прием данных от Т7
         T7.getData(MO6,Z6);
         Put_Line("1.>> T6: T7->T6");
         --прием данных от Т5
	   accept  setData(MK:in Matrix3H;alpha:in integer;B:in Vector)do
	    MK6:=MK;
	    alpha6:=alpha;
	    B6:=B;
         end setData;
         Put_Line("2.>> T6: T5->T6");
         --передача данных в Т5
         accept  getData(MO:out Matrix;Z:out Vector2H)do
                Z:=Z6(1..2*H);
		MO:=MO6;
         end getData;
         Put_Line("3.>> T6: T6->T5");
         --передача данных в Т7
         T7.setData(MK6(H+1..3*H),alpha6,B6);
         Put_Line("4.>> T6: T6->T7");
         count(A6(1..H),B6,MO6,alpha6,Z6(2*H+1..3*H),MK6(1..H));
         T7.getRes(A6(2*H+1..3*H));
         Put_Line("5.>> T6: T7->T6");
         accept getRes (A : out Vector3H) do
            A:=A6;
         end getRes;
         Put_Line("5.>> T6: T6->T5");
         Put_Line("T6 ended");
   end T6;
   task body T7 is
    MO7:Matrix;
	Z7:Vector;
        Z8:Vector4H;
        MK7:Matrix2H;
        MK8:MatrixH;
        alpha7:integer;
         B7:Vector;
         A7:Vector2H;
    begin
     Put_Line("T7 started");
         --ввод данных
         Put_Line(" T7: Input");
	Input1(Z7);
	Input2(MO7);
         --передача данных в Т6
         accept getData (MO : out Matrix; Z : out Vector3H) do
            MO:=MO7;
            Z:=Z7(3*H+1..6*H);
         end getData;
          Put_Line("1.>> T7: T7->T6");
         --передача данных в T8
         for i in 1..3*H loop
            Z8(i):=Z7(i);
         end loop;
         for i in 7*H+1..N loop
            Z8(i-4*H):=Z7(i);
         end loop;
         T8.setData_1(MO7,Z8);
         Put_Line("2.>> T7: T7->T8");
         --прием данных от Т6
         accept setData (MK : in Matrix2H; alpha : in integer; B : in Vector) do
            MK7:=MK;
            alpha7:=alpha;
            B7:=B;
         end setData;
         Put_Line("3.>> T7: T6->T7");
         --передача данных в Т8
         T8.setData(MK7(H+1..2*H),alpha7,B7);
         Put_Line("4.>> T7: T7->T8");
         count(A7(1..H),B7,MO7,alpha7,Z7(6*H+1..7*H),MK7(1..H));
         T8.getRes(A7(H+1..2*H));
         Put_Line("5.>> T7: T8->T7");
         accept getRes (A : out Vector2H) do
            A:=A7;
         end getRes;
         Put_Line("6.>> T7: T7->T6");
        Put_Line("T7 ended");
    end T7;
      task body T8 is
         MK8:MatrixH;
         alpha8:integer;
         B8:Vector;
         MO8:Matrix;
         Z8:Vector4H;
         A8:VectorH;
      begin
         Put_Line("T8 started");
         --прием данных от Т7
         accept setData_1 (MO : in Matrix; Z : in Vector4H) do
            MO8:=MO;
            Z8:=Z;
         end setData_1;
         Put_Line("1.>> T8: T7->T8");
         --передача данных в Т1
         accept getData (MO : out Matrix; Z : out Vector3H) do
            Z:=Z8(1..3*H);
            MO:=MO8;
         end getData;
          Put_Line("2.>> T7: T8->T1");
         --прием данных от Т7
         accept setData (MK : in MatrixH; alpha : in integer; B : in Vector) do
            MK8:=MK;
            alpha8:=alpha;
            B8:=B;
         end setData;
         Put_Line("3.>> T8: T7->T8");
         count(A8,B8,MO8,alpha8,Z8(3*H+1..4*H),MK8);
         accept getRes (A : out VectorH) do
            A:=A8;
         end getRes;
         Put_Line("Result: 4.>> T8: T8->T7");
         Put_Line("T8 ended");
    end T8;
   begin
      null;
   end Start;
begin
   Put_Line("Main started");
   Start;
   Put_Line("Main ended");
end Main;
