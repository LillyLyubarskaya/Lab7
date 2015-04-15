-----------------------------------------------
-- ПРО Lab № 2--
-- Любарська Л.В.--
----ІО-21------------
-----10.09.14
-- 1.07: MR = (A*SORT(C)) *(MA*MM+MN)--
-- 2.27: MD = (MA*MB)*TRANS(MC)--
-- 3.01: MA = MB*MC+ MM--
----------------------------------------------
with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

generic

    N: integer;

package Data is

   type Matrix is private;
   type Vector is private;


procedure Input1(VA: out Vector);

procedure Input2(MA: out Matrix);

procedure Output1(VA: in Vector);

procedure Output2(MA: in Matrix);

function Add(MA: in Matrix;MB: in Matrix) return Matrix;

function f1(A,C: in Vector;MA,MM,MN:in Matrix) return Matrix;

function f2(MA,MB,MC: in Matrix) return Matrix;

function f3(MA,MB,MC: in Matrix)return Matrix;
 private
    type Vector is array (1..N) of integer;
    type Matrix is array (1..N) of Vector;


end Data;

