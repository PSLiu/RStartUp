%macro copy_to_new_encoding(from_dsname,to_dsname,new_encoding);
%global orig_encoding;

%let prefix=goobly; 

filename lngtstmt temp;
data _null_; 
   file lngtstmt; 
   put ' '; 
run; 

filename kcvtused temp;
data _null_; 
   file kcvtused; 
   put ' '; 
run; 

data temp2; 
   x=1; 
run; ;
 
%global sql_libname sql_memname; 
data _null_; 
   length libname memname $256; 
   memname=scan("&from_dsname",-1,'.'); 
   libname=ifc(index("&from_dsname",'.'),scan("&from_dsname",1,'.'),"WORK"); 
   call symputx('sql_libname',upcase(libname)); 
   call symputx('sql_memname',upcase(memname)); 
run;
proc sql; 
   create table temp as select * from dictionary.tables 
     where libname="&sql_libname." and memname="&sql_memname."; 
   quit; 
data _null_; 
   set temp; 
   call symputx('orig_encoding',scan(encoding,1,' ')); 
run;

proc contents data=&from_dsname out=temp(keep=name type length npos) noprint; 
run;
 
proc sort data=temp; 
   by name; 
run; 

%global nchars revise;
%let revise=0;  
data _null_; 
   set temp end=eof;
   retain nchars 0; 
   nchars + (type=2); 
   if eof;    
     call symputx('nchars',nchars); 
run;

%if &nchars %then %do; 

data temp2(keep=&prefix._name &prefix._length
   rename=(&prefix._name=NAME)); 
   set &from_dsname(encoding=binary) end=&prefix._eof; 
   retain &prefix._revise 0; 
   array &prefix._charlens{&nchars} _temporary_; 
   array &prefix._charvars _character_; 

   if _n_=1 then do over &prefix._charvars; 
     &prefix._charlens{_i_}= -vlength(&prefix._charvars); 
   end;

   do over &prefix._charvars; 
     &prefix._l = lengthc(kcvt(trim(&prefix._charvars),
     "&orig_encoding.","&new_encoding.")); 
     if &prefix._l > abs(&prefix._charlens{_i_}) then do; 
        &prefix._charlens{_i_} = &prefix._l; 
        &prefix._revise = 1; 
        end;
     end;

     if &prefix._eof and &prefix._revise;
     call symputx('revise',1); 
     length &prefix._name $32 &prefix._length 8; 
     do over &prefix._charvars; 
        if &prefix._charlens{_i_} > 0 then do;
           &prefix._name = vname(&prefix._charvars); 
           &prefix._length = &prefix._charlens{_i_}; 
           output temp2;
           end;
        end;
     run; 

%if &revise %then %do; 

proc sort data=temp2; 
   by name; 
run;

data temp; merge temp temp2(in=revised); 
   by name;
   if revised then length=&prefix._length; 
   need_kcvt = revised; 
run;
 
proc sort; 
   by npos; 
run;

data _null_; 
   set temp; 
   file lngtstmt mod; 
   length nlit $512 stmt $1024; 
   nlit = nliteral(name); 
   len = cats(ifc(type=2,'$',' '),length);
   stmt = catx(' ','length',nlit,len,';');  
   put stmt;
   if need_kcvt; 
     stmt = trim(nlit)||' = kcvt('||trim(nlit)||",""&orig_encoding
."",""&new_encoding."");"; 
   put stmt; 
run;
%end;
%end;
 
data &to_dsname(encoding=&new_encoding);       
   %include lngtstmt/source2; 
   set &from_dsname(encoding=binary); 
   %include kcvtused/source2; 
run;

filename lngtstmt clear; 
filename kcvtused clear; 
proc delete data=temp temp2; 
run; 

%mend copy_to_new_encoding;

