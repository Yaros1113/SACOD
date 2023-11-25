program LB2_1_003;

uses package;

var input, output:text;
    A, B, C:TLong;
    err:boolean;
    z:string; //
{Отчёт:
1. НФЗ: разработать пакет процедур...
2. ФПЗ: грамматика вх. файла в БНФ/РБНФ (Формы Бэкуна-Наура) !!!!!!!!!!!!!! к следующей неделе
3. Спецификация процедур/функций
4. Тесты для каждой процедуры и функции, тесты ко всей программе
}

{procedure err_write(err:integer);
  begin
    
  end;}

begin
  assign(input, 'input.txt'); reset(input);
  assign(output, 'output.txt'); rewrite(output);
  
  err:=false;
  
 // Read_TL(input, a, err);
  Read_TL(input, B, err);
  Write_TL(output, B, err);
 // if Less_TLong(a,b) then writeln ('yes') else writeln ('no'); 
  
  while not eof(input) do begin
      err:=false;
      readln(input, z);
      //writeln('z:',z);
      Read_TL(input, A, err);
      //writeln('sdfgh:', A.data[1]);
      case z of
        '+': ADD_TL(A, B, C, err);{begin writeln(Less_TLong(A,C)); writeln(A.data,A.dot,'; ', B.data, B.dot); end;}
        '*': MuL_TL(A, B, C, err);
        '-': SUB_TL(A, B, C, err);
        //'/':
      end;
      //writeln(C.data, C.dot);
      B:=C;
      Write_TL(output, A, err);
  end;
  {Write_TL(output, B);
  Write_TL(output, A);}
  
  close(output);
end.