unit package;

interface
const n=40;

type TLong= record
  dot: array[1..N] of byte;
  data: array[1..N] of byte;
  sign:boolean;
  l_dot:word;
  l_data:word;
end;

procedure Read_TL(var f:text; var A:TLong; var err:boolean);
procedure Write_TL(var F:text; A:TLong; err:boolean);
procedure ADD_TL(A,B:TLong; var C:TLong; var err:boolean);
procedure SUB_TL(A,B:TLong; var C:TLong; var err:boolean);
function Less_TLong(A,B:TLong):boolean;// |A|<|B|->true; else false
procedure MuL_TL(A,B:TLong; var C:TLong; var err:boolean);
//procedure DiV_TL(A,B:TLong; var C:TLong);


implementation
procedure Read_TL(var f:text; var A:TLong; var err:boolean);
  var s,ss:string;
      l,i,d:word;
      e:integer;
      ch:byte;
  begin
    A.l_data := 0; A.l_dot := 0; 
    for i := 1 to n do begin A.data[1] := 0; A.data[2] := 0; A.dot[1] := 0; A.dot[2] := 0; end;
    
    readln(f, s);
    //writeln(s);
    l:=length(s);
    d:=0;
    A.sign:=False;
    if (l <> 0) and (l <= n*2) then begin
      if s[1]='-' then 
        if l >= 2 then begin
          s:=copy(s,2,l); A.sign:=True; l:=l-1;
        end
        else begin writeln('Ошибка: "Я не понимать, что ты хотеть сказать!!!"'); err:=True; end;
      
        
      d:=pos('.',s);
      if d>1 then begin 
        A.l_data := (d-1) div 2 + (d-1) mod 2;
        A.l_dot := (l-d) div 2 + (l-d) mod 2;
      end
      else if d = 1 then begin writeln('ОШИбКа№%:78435 лишняя точка:?&А?'); err:=True; end
      else A.l_data := (l) div 2 + (l) mod 2;
      
  
      if (d <> 0) and (A.l_dot <> 0) then begin
        for i:=1 to A.l_dot-1 do begin
          ss := copy(s, (2*i)+d-1, 2);
          val(ss, ch, e);
          if e=0 then
            A.dot[i]:=ch
          else begin writeln('Ошибка: "E111 Что-то сломалось :("'); err:=True; end
        end;
        
        ss := copy(s, (2*A.l_dot)+d-1, 2);
        val(ss, ch, e);
        if length(ss) = 1 then
          if e=0 then
            A.dot[A.l_dot]:=ch*10
          else begin writeln('Ошибка: "E32 Что-то сломалось :("'); err:=True; end
        else
          if e=0 then
            A.dot[A.l_dot]:=ch
          else begin writeln('Ошибка: "E0x33 Что-то сломалось :("'); err:=True; end;
      end
      else
        d := l+1;
      
      if d - 1 <> 1 then
        for i := 1 to A.l_data do begin
          ss := copy(s, d-2*i, 2);
          val(ss, ch, e);
          if e=0 then
            A.data[i]:=ch
          else begin writeln('Ошибка: "E0x234 Что-то сломалось :("'); err:=True; end;
        end;
      if ((d-1) mod 2) <> 0 then begin
        ss := copy(s, 1, 1);
        val(ss, ch, e);
        if e=0 then
          A.data[A.l_data]:=ch
        else begin writeln('Ошибка: "E34 Что-то сломалось :("'); err:=True; end;
      end;
    end
    else begin writeln('Ошибка: "E12 И чё мне с этим делать??????"'); err:=True; end;
     
    //writeln(A.dot, '; ', A.data);
    //writeln(A.data[1], A.data[2], ',', A.dot[1], A.dot[2]);
  end;


procedure Write_TL(var F:text; A:TLong; err:boolean);
    var i, j: word;
    begin
      if not err then begin
        j:=A.l_dot;
        
        for i := A.l_data downto 1 do
          if A.data[i]=0 then
            write(f,'00')
          else if (A.data[i]<10) and (i<A.l_data) then begin //НЕ работает
            write(f,'0');
            write(f, A.data[i]);
          end
          else
            write(f, A.data[i]);
        
        write(f, '.');
        
        for j := 1 to A.l_dot do
          if A.dot[j]=0 then
            write(f,'00')
          else if (A.dot[j]<10) {and (j<A.l_dot)} then begin
            write(f,'0');
            write(f, A.dot[j]);
          end
          else
            write(f, A.dot[j]);
        
        writeln(f, ';');
      end;
    end;



procedure ADD_TL(A,B:TLong; var C:TLong; var err:boolean);
  var C1:TLong;
      p:integer;
      max:boolean;
      i:word;
  begin
    if (A.sign and not B.sign) or (not A.sign and B.sign) then begin
      SUB_TL(A,B,C1, err);
      C:=C1;
    end
    else begin
      max:=Less_TLong(A,B);
      p:=0;
      C.sign:=B.sign;
      if max then begin
        C.l_dot:= B.l_dot;
        C.l_data:=B.l_data;
        if B.l_dot <> 0 then 
          for i:=B.l_dot downto 1 do 
            if i <= A.l_dot then
              if (B.dot[i]+p+A.dot[i]) > 99 then begin
                C.dot[i]:=(B.dot[i]+p+A.dot[i]) mod 100;
                p:=1;
              end
              else begin
                C.dot[i]:=B.dot[i]+p+A.dot[i];
                p:=0;
              end
            else
              C.dot[i]:=B.dot[i];           
          
          if B.l_data <> 0 then 
            for i:=1 to B.l_data do
              if i <= A.l_data then
                if (B.data[i]+p+A.data[i]) > 99 then begin
                  C.data[i]:=(B.data[i]+p+A.data[i]) mod 100;
                  p:=1;
                end
                else begin
                  C.data[i]:=B.data[i]+p+A.data[i];
                  p:=0;
                end
              else
                C.data[i]:=B.data[i];
        end
        else begin
          C.l_dot:= A.l_dot;
          C.l_data:=A.l_data;
          if A.l_dot <> 0 then
            for i:=A.l_dot downto 1 do
              if i <= B.l_dot then
                if (A.dot[i]+p+B.dot[i]) > 99 then begin
                  C.dot[i]:=(A.dot[i]+p+B.dot[i]) mod 100;
                  p:=1;
                end
                else begin
                  C.dot[i]:=A.dot[i]+p+B.dot[i];
                  p:=0;
                end
              else
                C.dot[i]:=A.dot[i];
            
            if A.l_data <> 0 then
              for i:=1 to A.l_data do
                if i <= B.l_data then
                  if (A.data[i]+p+B.data[i]) > 99 then begin
                    C.data[i]:=(A.data[i]+p+B.data[i]) mod 100;
                    p:=1;
                  end
                  else begin
                    C.data[i]:=A.data[i]+p+B.data[i];
                    p:=0;
                  end
                else
                  C.data[i]:=A.data[i];
        end;
      end;
  end;

procedure SUB_TL(A,B:TLong; var C:TLong; var err:boolean);
  var p:integer;
      max:boolean;
      i:word;
  begin
    max:=Less_TLong(A,B);
    p:=0;
    C.data[1]:=0;
    
    if max then begin
      C.l_dot:= B.l_dot;
      C.l_data:=B.l_data;
      C.sign:=B.sign;
      if B.l_dot <> 0 then
        for i:=B.l_dot downto 1 do
          if i <= A.l_dot then
            if (B.dot[i]-p-A.dot[i]) < 0 then begin
              C.dot[i]:=-(B.dot[i]-p-A.dot[i]);
              p:=-1;
            end
            else begin
              C.dot[i]:=B.dot[i]-p-A.dot[i];
              p:=0;
            end
          else
            C.dot[i]:=B.dot[i];
        
        if B.l_data <> 0 then
          for i:=1 to B.l_data do
            if i <= A.l_data then
              if (B.data[i]-p-A.data[i]) < 0 then begin
                C.data[i]:=-(B.data[i]-p-A.data[i]);
                p:=-1;
              end
              else begin
                C.data[i]:=B.data[i]-p-A.data[i];
                p:=0;
              end
            else
              C.data[i]:=B.data[i];
      end
      else begin
        C.l_dot:= A.l_dot;
        C.l_data:=A.l_data;
        C.sign:=A.sign;
        if A.l_dot <> 0 then
          for i:=A.l_dot downto 1 do
            if i<= B.l_dot then
              if (A.dot[i]-p-B.dot[i]) < 0 then begin
                C.dot[i]:=-(A.dot[i]-p-B.dot[i]);
                p:=-1;
              end
              else begin
                C.dot[i]:=A.dot[i]-p-B.dot[i];
                p:=0;
              end
            else
              C.dot[i] := A.dot[i];
        
        if A.l_data <> 0 then
          for i:=1 to A.l_data do
            if i <= B.l_data then
              if (A.data[i]-p-B.data[i]) < 0 then begin
                C.data[i]:=-(A.data[i]-p-B.data[i]);
                p:=-1;
              end
              else begin
                C.data[i]:=A.data[i]-p-B.data[i];
                p:=0;
              end
            else
              C.data[i]:=A.data[i];
      end;
  end;

function Less_TLong(A,B:TLong):boolean; //|A|<|B|->true; else false
  var k:boolean;
      i:word;
  begin
    k:=true;
    {if A.sign and not B.sign then
      Less_TLong := true
    else if not A.sign and B.sign then
      Less_TLong:= false
    else}
      if A.l_data < B.l_data then
        result:= true
      else if A.l_data > B.l_data then
        result:= false
      else begin
        for i:=A.l_data downto 1 do
          if A.data[i] < B.data[i] then
            result:= true
          else if A.data[i] > B.data[i] then
            result:= false
          else 
            k:=false;
        for i:=1 to A.l_dot do
          if A.dot[i] < B.dot[i] then
            result:= true
          else
            result:= false;
      end;
    result:= k;
  end;


procedure MuL_TL(A,B:TLong; var C:TLong; var err:boolean);
  var p,f:byte;
      i,j:word;
      K1,K2:TLong;
      max:boolean;
  begin
    p:=0; f:=0;
    if (A.sign and not B.sign) or (not A.sign and B.sign) then begin
      C.sign:=True;
    end
    else begin
      C.sign:=False;
    end;
    
    C.l_dot:=A.l_dot+B.l_dot;
    
    for j:=1 to n do begin K2.dot[j]:=0; K2.data[j]:=0; end;
    if A.l_dot <= B.l_dot then
      for i:=1 to A.l_dot do begin
        for j:=1 to B.l_dot do
          K1.dot[j]:=A.dot[i]*B.dot[j];
        if A.dot[B.l_dot]*B.dot[B.l_dot] > 99 then 
          K1.l_dot:=B.l_dot;
        ADD_TL(K2, K1, K2, err);
          
        
      end;
    
    
    
    
    if A.l_data>=B.l_data then
      C.l_data:=A.l_data+f
    else
      C.l_data:=B.l_data+f;
  end;
  
  
//procedure DiV_TL(A,B:TLong; var C:TLong);



begin
  
end.