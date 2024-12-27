; VARIABLES
 cblock
    temp1
 endc

; Retardo en milisegundos
delay_ms:
    movwf	temp1       ; Guardamos el valor actual en temp1
delay_ms_loop:
    call	delay_1ms   ; Llamamos a la rutina de 1 ms
    decfsz	temp1, 1    ; Decrementamos temp1; si es 0, salimos del bucle
    goto	delay_ms_loop
    return

; Retardo de 1 ms usando TMR0
delay_1ms:
    clrf	TMR0        ; Inicializamos TMR0
delay_1ms_wait:
    btfss	TMR0, 2     ; Esperamos hasta que el bit 2 de TMR0 se active
    goto	delay_1ms_wait
    return
