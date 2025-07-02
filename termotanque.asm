
    __CONFIG _CP_OFF & _WDT_OFF & _PWRTE_ON & _XT_OSC

    INCLUDE <p16f628a.inc>

    ORG 0x00 ; Inicio del programa

; Definición de variables
aguamax EQU 0x20;
aguaactual EQU 0x21
	CLRF aguaactual
tempmax EQU 0x22
tempactual EQU 0x23
aguamin EQU 0x24
CONT EQU 0x25
CONT2 EQU 0x26
  	  CLRF tempactual

    MOVLW d'110'
    MOVWF aguamax;agrego 110 en decimal a aguamax
    
    MOVLW d'45'
    MOVWF tempmax;agrego 45 en decimal a tempmax 

 	MOVLW d'50'
    MOVWF aguamin;agrego 50 en decimal a aguamin

	MOVLW d'20'
    MOVWF tempactual;agrego 20 en decimal a tempactual
 	

	BCF STATUS, RP0 ;  voy al banco 0 de registros
	CLRF PORTB; apago todo portb
	BSF STATUS, RP0 ; voy al banco 1 de registros
    BCF STATUS, RP1 ; Limpiar RP1 para evitar errores
    CLRF TRISB    ; pongo todos los pines de portb como salida
    BCF STATUS, RP0 ; Volver al banco 0 de registros

  

Main:	

	CLRF CONT; INICIO A USEG EN 0
	clrf CONT2; INICIO A MSEG EN 0

	BSF PORTB,1; Led azul que indica que se prendio el termotanque
	
	; Verificar si la cantidad de agua es menor que 110 litros
    MOVF aguaactual, W; muevo aguaactual a w
    SUBWF aguamax, W; resto aguaactual de aguamax
    BTFSS STATUS, Z ; si la resta no es 0 ejecuta el siguiente paso
    GOTO ActivarBomba ; si no se igualaron, la cantidad es menor que la máxima y se activa la bomba
	
	; Verificar si la cantidad de temp es 45
	MOVF tempactual, W
    SUBWF tempmax, W
    BTFSS STATUS, Z ; si la resta no es 0 ejecuta el siguiente paso
   	GOTO ActivarResistencia ; si no se igualaron, la cantidad es menor que la máxima y se activa la resistencia
	BSF PORTB,3    ;prendemos led RB3 Verde para indicar que se apago la resistencia
	CALL Retardo500ms; esperamos 500ms
	BCF PORTB,3    ;apagamos led RB3 Verde para indicar que se apago la resistencia

	; Abro la canilla
 	
	CALL Retardo1Segundo; esperamos 1 segundo 
	GOTO AbrirCanilla 


;--------------SUBRUTINAS------------------------



ActivarBomba:
  	BCF STATUS, RP0 ; Cambiar al banco 0 de registros      
	BSF PORTB,0 ;Led amarillo que indica que se prendio la bomba

    MOVLW 0x0A
    ADDWF aguaactual, F ; le sumo 10 litros a aguaactual

    ; Verificar si la cantidad de agua es menor que 110 litros
    MOVF aguaactual, W; muevo aguaactual a w
    SUBWF aguamax, W; resto aguaactual de aguamax
    BTFSS STATUS, Z ; si la resta no es 0 ejecuta el siguiente paso
    goto ActivarBomba ; Volver al bucle

    ; La cantidad llegó a la máxima, apagar el LED y volver al MainLoop
    bcf PORTB,0 ; Apagar el LED amarillo ya que se apoago la bomba
  	goto Main



ActivarResistencia:

	; Sumar 5 grados a la temperatura actual      
    MOVLW 5 ;agrego 5 en decimal a w
    ADDWF tempactual, F ; Sumar 5 grados tempactual
	
	; Prender y apagar un LED para indicar que la resistencia está funcionando
    bsf PORTB, 2 ; Encender el LED rojo que indica que esta calentando
    CALL Retardo500ms; esperamos 500ms
    bcf PORTB,2;apagamos el led rojo que indica que esta calentando
	CALL Retardo500ms; esperamos 500ms 
	bsf PORTB, 2 ; Encender el LED rojo que indica que esta calentando
	CALL Retardo500ms; esperamos 500ms 
	bcf PORTB,2; apagamos el led rojo que indica que esta calentando

   
 ; Verificar si llegue a la temperatura maxima
   
    MOVF tempactual, W; muevo tempactual a w
    SUBWF tempmax, W; resto tempactual de tempmax
    BTFSS STATUS, Z ;  si la resta no es 0 ejecuta el siguiente paso
  	goto ActivarResistencia ; Volver al bucle

	
  	goto Main





AbrirCanilla:
	;CALL Retardo1Segundo; esperamos un segundo

	BSF PORTB,4; Prendo el LED RB4 Blanco para indicar que se abrio la canilla
    ; Resto 5 litros a la cantidad actual
     
    MOVLW -5 ;Resto 5 en decimal a w
    ADDWF aguaactual, F ; Sumar -5 litros en decimal a cantactual
	
    ; Verificar si la cantidad actual es igual la cantidad minima
    
    MOVF aguaactual, W
    SUBWF aguamin, W; resto aguaactual de aguamin
    BTFSS STATUS, Z ; si la resta no es 0 ejecuta el siguiente paso
  	goto AbrirCanilla

	CALL Retardo1Segundo; esperamos un segundo 
	BCF STATUS, RP0 ; Cambiar al banco 0 de registros
	BCF PORTB,4 ; Apago el LED RB4 Blanco para indicar que se cerro la canilla

	MOVLW d'20'
    MOVWF tempactual;decremento a 20 en decimal a tempactual
	
   
  	goto Main



delay_1ms
			movlw .250 ; Carga el valor 250 en el registro W
			movwf CONT ; Mueve el valor de W al registro CONT (variable CONT)
loop nop ; No hace nada durante un ciclo de instrucción (nop)
			decfsz CONT, F; Decrementa el valor de la variable CONT y salta a 'loop' si no es cero
			goto loop ; Salta de nuevo a la etiqueta 'loop' si la condición se cumple (CONT no es cero)
			return ; Retorna de la subrutina delay_1ms

delay_250ms
			movlw .250 ; Carga el valor 250 en el registro W
			movwf CONT2; Mueve el valor de W al registro CONT2 (variable CONT2)
loop2 
	       call delay_1ms ; Llama a la subrutina delay_1ms (1 ms)
			decfsz CONT2, f; Decrementa el valor de la variable CONT y salta a 'loop' si no es cero
			goto loop2; Salta de nuevo a la etiqueta 'loop' si la condición se cumple (CONT no es cero)
			return ;Retorna de la subrutina delay_250ms



Retardo500ms
    ; Realizar un retardo de 1 segundo
    CALL delay_250ms ; Llamada 1: 250 ms
    CALL delay_250ms ; Llamada 2: 500 ms

Retardo1Segundo
    ; Realizar un retardo de 1 segundo
    CALL delay_250ms ; Llamada 1: 250 ms
    CALL delay_250ms ; Llamada 2: 500 ms
    CALL delay_250ms ; Llamada 3: 750 ms
    CALL delay_250ms ; Llamada 4: 1000 ms = 1 seg


    END