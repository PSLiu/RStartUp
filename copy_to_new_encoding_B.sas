/* Catch all SAS data file names */
Filename filelist pipe "dir /b /s  &inpath.\*.sas7bdat"; 

/* Input file names in a dataset named a1 */ 
data a1;                                        
  infile filelist truncover;
  input filename $150.;
  put filename=;
Run;

/* Delete path character for sas program syntax */
data a2;
  set a1;
  filename2 = tranwrd(filename, "&inpath.\","");
  filename2 = tranwrd(filename2, ".sas7bdat", "");
run;

/*  Give a sequential number */
proc sql;
  create table a3 as 
  select *, monotonic() as ListIndex
  from a2;
quit;

/* Setting working dictionary */
libname s1 "&inpath.";
libname s2 "&outpath.";

/* Get total count of file names in folder */
proc sql; 
  create table a3_tot_count as select count(*) as file_tot_count from a3;  
quit;
data _null_;
  set a3_tot_count;
  call symput("file_tot_count",file_tot_count);
run;

%macro TranGoGO(fi);
%do fi = 1 %to &file_tot_count.;

data _null_;
  set a3;
  call symput("file_to_do",filename2);
  where ListIndex = &fi.;
run;

%copy_to_new_encoding(from_dsname = s1.&file_to_do., to_dsname = s2.&file_to_do., new_encoding = &outencoding.);

%end;
%mend;
%TranGoGO(fi);
