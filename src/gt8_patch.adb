pragma Ada_2022;

with Ada.Command_Line;
with Ada.Sequential_IO;
with Ada.Text_IO;

procedure Gt8_Patch is

   package AIO renames Ada.Text_IO;
   package ACL renames Ada.Command_Line;

   type Byte is new Integer range 0 .. 255;
   for Byte'Size use 8;

   type Byte_Array is array (1 .. 7) of Byte;

   package Byte_IO is new Ada.Sequential_IO (Byte);

   function Is_Gt8 (File_Name : String) return Boolean is

      File      : Byte_IO.File_Type;
      Signature : constant Byte_Array :=
        [16#F0#, 16#41#, 16#00#, 16#00#, 16#00#, 16#06#, 16#12#];
      Sequence  : Byte_Array          := [others => 16#00#];

   begin

      Byte_IO.Open (File, Byte_IO.In_File, File_Name);

      for B in Sequence'Range loop
         exit when Byte_IO.End_Of_File (File);
         Byte_IO.Read (File, Sequence (B));
      end loop;

      Byte_IO.Close (File);

      return Sequence = Signature;

   end Is_Gt8;

begin

   if ACL.Argument_Count < 1 then
      AIO.Put_Line ("At least one argument is needed.");
      return;
   end if;

   for I in 1 .. ACL.Argument_Count loop
      if not Is_Gt8 (ACL.Argument (I)) then
         AIO.Put_Line (ACL.Argument (I) & " False");
      end if;
   end loop;

end Gt8_Patch;
