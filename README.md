# SAS program for transport SAS encoding
# R program for read SAS *.sas7bdat using `read_sas` in `haven` package

1. Including 4 program
* **copy_to_new_encoding.sas**
  - main surface for launch, give 4 parameter.
    - where these SAS program saved
    - where original SAS dataset saved
    - where new SAS dataset saved
    - which encoding used for new SAS dataset
  - call other 2 program.
* **copy_to_new_encoding_A.sas**
  - Langston RD(2018). [A Macro for Ensuring Data Integrity When Converting SAS® Data Sets. SAS Paper SAS1778-2018.](https://support.sas.com/content/dam/SAS/support/en/sas-global-forum-proceedings/2018/1778-2018.pdf)
* **copy_to_new_encoding_B.sas**
  - get all of SAS dataset names in folder.
  - launch program A using macro loop.
* **Haven-read_sas.r**
  - R script, read SAS *.sas7bdat using `read_sas` in `haven` package.
  - Then save in `*.fst` file format.

