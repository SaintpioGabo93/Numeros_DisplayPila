; Configuración del PIC16F628A
__CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF

; Indica el modelo de microcontrolador utilizado
LIST P=16F628A
    
; Declaramos las variables
cblock 0x20
    conta	; Contador del programa
endc
    
; Incluimos el archivo con las definiciones del microcontrolador. 
    #include <p16f628a.inc>
    
; Punto de inicio del programa
    org	    0x00
    
    ; Configuramos el TRISB para establecer todos los pines del PORTB como salida
    bsf		STATUS, 5
    clrf	TRISB
    movlw	b'00000111' ; Cargamos la configuracion del TMR0
    movwf	OPTION_REG  ; Movemos la configuracion al OPTION_REG
    bcf		STATUS, 5   ; Regresamos al banco 0
    
; Inicio del programa principal
inicio:
    clrf	conta	    icializamos la variable conta en 0
    movf	conta, W    ; Cargamos el valor de conta en el registro de trabajo
    call	tabla	    ; Llamamos a la tabla de conversion para obtener el valor correspondiente
    movwf	PORTB	    ; Cargamos el valor obtenido de la tabla con la instruccion retlw
    movlw	.1000	    ; Cargamos un segundo para descargarlo en la rutina delay
    call	delay_ms    ; Llamamos a rutina de retraso milisegundos. 
    ; Una vez que terminamos las instrucciones principales es hora de incrementar el contador
    incf	conta, F
    movlw	.10	    ; Cargamos el valor de 10 para poderlo comparar con el contador
    subwf	conta, W    ; Aqui se compara el valor de conta con el que cargamos en el registro de trabajo con movlw
; Bien importante esta instruccion, porque el resultado de la comparacion anterior afecta al bit 2 del Registro STATUS
    btfss	STATUS, 2   ; Verificamos si el resultado es 0 (Z = 10)
    goto	$-9	    ; Si la comparacion es diferente de 0, regresamos 9 instrucciones, o sea a movf conta, W
    goto	inicio	    ; Si la comparacion es 0, regresamos a inicio. 
    
; Tablita de conversion para los valores de salida para el PORTB
tabla:
    addwf	PCL, F	    ; Modificamos el contador de programa para que cada que regrese acceda a la entrada correcta. 
    retlw	b'00111111'    ; Representación del número 0
    retlw	b'00000110'    ; Representación del número 1
    retlw	b'01011011'    ; Representación del número 2
    retlw	b'01001111'    ; Representación del número 3
    retlw	b'01100110'    ; Representación del número 4
    retlw	b'01101101'    ; Representación del número 5
    retlw	b'01111101'    ; Representación del número 6
    retlw	b'00000111'    ; Representación del número 7
    retlw	b'01111111'    ; Representación del número 8
    retlw	b'01100111'    ; Representación del número 9
    
; Incluimos el archivo para la rutina de retraso. 
    #include <delay.inc>
    
    end