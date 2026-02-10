    "-------------------------------------------------------------
    " Eliminar WF atual
    "-------------------------------------------------------------
      DATA: lt_wi2obj TYPE TABLE OF sww_wi2obj,
            ls_wi2obj TYPE sww_wi2obj,
            lt_wihead TYPE TABLE OF swwwihead,
            ls_wihead TYPE swwwihead,
            lv_return TYPE sy-subrc.

      SELECT SINGLE * FROM sww_wi2obj
        INTO ls_wi2obj
        WHERE WI_RH_TASK = 'WS01800145' " WF code
          AND TYPEID = 'CL_SD_SALESCONTRACT_WORKFLOW' "Object name ex.: BUS2012
          AND INSTID = lv_SalesContract. " Object key, document number

      IF sy-subrc = 0.

        SELECT single * FROM swwwihead
          INTO ls_wihead
          "FOR ALL ENTRIES IN lt_wi2obj
          WHERE wi_id   = ls_wi2obj-wi_id
            AND wi_stat IN ('READY','STARTED').   "ajuste conforme a sua necessidade
            "AND witask  = 'TS00008267'.          "ou sua TS de decisão

          IF sy-subrc = 0.

            CALL FUNCTION 'SAP_WAPI_SET_WORKITEM_STATUS'
              EXPORTING
                workitem_id = ls_wi2obj-wi_id
                STATUS  = 'ERROR' "'CANCELLED'
                do_commit   = space
              IMPORTING
                return_code = lv_return.

            COMMIT WORK AND WAIT.
          ENDIF.
      ENDIF.
