CLASS y_exemption_general DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS: is_object_exempted
      IMPORTING
                object_type   TYPE trobjtype
                object_name   TYPE sobj_name
      RETURNING VALUE(result) TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS is_tadir_generated
      IMPORTING
                object_type   TYPE trobjtype
                object_name   TYPE sobj_name
      RETURNING VALUE(result) TYPE abap_bool.

    METHODS is_object_existing
      IMPORTING
                object_type   TYPE trobjtype
                object_name   TYPE sobj_name
      RETURNING VALUE(result) TYPE abap_bool.
ENDCLASS.



CLASS Y_EXEMPTION_GENERAL IMPLEMENTATION.


  METHOD is_object_exempted.
    result = xsdbool( ( is_object_existing( object_type = object_type object_name = object_name ) = abap_true ) OR
                      ( is_tadir_generated( object_type = object_type object_name = object_name ) = abap_true ) ).
  ENDMETHOD.


  METHOD is_object_existing.
    CONSTANTS object_exists TYPE char1 VALUE 'X'.

    DATA: existence_flag TYPE strl_pari-flag,
          l_object_type  TYPE e071-object,
          l_object_name  TYPE e071-obj_name.
    l_object_type = object_type.
    l_object_name = object_name.

    CALL FUNCTION 'TR_CHECK_EXIST'
      EXPORTING
        iv_pgmid    = 'R3TR'
        iv_object   = l_object_type
        iv_obj_name = l_object_name
      IMPORTING
        e_exist     = existence_flag.

    IF existence_flag <> object_exists.
      result = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD is_tadir_generated.
    SELECT SINGLE genflag FROM tadir INTO @result
      WHERE pgmid = 'R3TR' AND object = @object_type AND obj_name = @object_name.
  ENDMETHOD.
ENDCLASS.
