CLASS zcx_ca_static_check DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  ABSTRACT
  CREATE PUBLIC .

*"* public components of class ZCX_CA_STATIC_CHECK
*"* do not include other source files here!!!
  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !textid   LIKE textid OPTIONAL
        !previous LIKE previous OPTIONAL .
  PROTECTED SECTION.
*"* protected components of class ZCX_CA_STATIC_CHECK
*"* do not include other source files here!!!
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_CA_STATIC_CHECK IMPLEMENTATION.


  METHOD constructor  ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        textid   = textid
        previous = previous.
  ENDMETHOD.
ENDCLASS.
