/************************************************************/
/* Programer: Peter Pin-Sung Liu                            */
/* Last revised: 2020.01.23                                 */
/* Program aim
     1. Include macro "copy_to_new_encoding".
        Langston RD(2018). A Macro for Ensuring Data Integrity When Converting SASR Data Sets. SAS1778-2018.
     2. Creat a dataset including list of name in folder    
     3. Transfer all SAS dataset to new encoding            */ 
/************************************************************/

/* Folder path where the macro program save */
%let pgpath = C:\Users\ACER\Downloads\§j¬‡¿…;

/* Folder path where ORIGINAL SAS dataset are */
%let inpath = C:\File\DataLab\NHIRD_DemoFile2013_SAS;

/* Folder path where NEW ENCOIDING SAS dataset to be saved */
%let outpath = C:\File\DataLab\NHIRD_DemoFile2013_SAS_UTF8;

/* Specify new encoding */
%let outencoding = utf8;




/* Main function */
%include "&pgpath.\copy_to_new_encoding_A.sas";

/* Do in loop */
%include "&pgpath.\copy_to_new_encoding_B.sas";
