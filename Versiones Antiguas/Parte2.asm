#make_COM#	; create ".com" executable (DOS 1.0 compatible).
org  100h	; add +100h to all addresses (required for .com file).

jmp inicio

aux db '00000'
num db '00000'

inicio:

mov cx,4
lea si,aux
call registrar_ingreso

lea si,aux
lea di,num
call acomodar_vector

lea si,num
mov cx,5
call imprimir

int 20h

;ESTA SUBRUTINA PERMITE EL INGRESO DE UNA SERIE DE NUMEROS Y LOS GUARDA EN UN VECTOR
;NECESITA SETEAR CX EN LA CANTIDAD DE DIGITOS QUE SE REQUIERAN
;NECESITA DE UN VECTOR DONDE GUARDAR LOS CARACTERES INGRESADOS

registrar_ingreso proc
  inc	cx
 ingreso:
  mov 	ah,0		;COPIA 0 EN AH PARA CAPTURAR TECLAS
  int 	16h		;CATURA UNA TECLA
 validacion:
  cmp	al,0dh
  je	es_enter
  cmp	al,08h
  je	es_borrar
  cmp	al,30h
  jb	ingreso
  cmp	al,39h
  ja	ingreso
  jmp	es_numero
 es_numero:
  mov	bx,1
  jmp	comprobacion
 es_enter:
  mov	bx,2
  jmp	comprobacion
 es_borrar:
  mov	bx,3
  jmp	comprobacion
 comprobacion:
  cmp	cx,5
  je	c5
  cmp	cx,1
  je	c1
  jmp	impresion
 c5:
  cmp	bx,3
  je	ingreso
  jmp	impresion
 c1:
  cmp	bx,1
  je	ingreso
  jmp	impresion
 impresion:
  mov 	ah,0Eh		;COPIA 0E EN AH (PARA IMPRIMIR)
  int 	10h		;IMPRIME EL CARACTER
  cmp	bx,3
  je	imp_borrar
  cmp	bx,2
  je	fin_ingreso
  mov	[si],al
  jmp	vuelta
 imp_borrar:
  add	cx,2
  sub	si,2
  mov 	al,0h		;COPIA 0 EN AL (CARACTER VACIO)
  int 	10h		;ESCRIBE UN CARACTER VACIO PISANDO AL ANTERIOR
  mov 	al,8h		;COPIA 8 EN AL (RETORNO DE CARRO)
  int 	10h		;VUELVE DENUEVO PARA ATRAS
 vuelta:
  inc	si
  loop	ingreso
 fin_ingreso:
  dec	cx
  ret
registrar_ingreso endp

;registrar_ingreso proc
  ;jmp 	ingreso		;SALTA A INGRESO
 ;borrar:
  ;cmp 	cx,4		;COMPARA CX CON 4
  ;je 	ingreso		;SI ES IGUAL A 4 SIGNIFICA QUE NO SE PUEDE BORRAR POR QUE EL CURSOR ESTA EN EL MARGEN IZQUIERDO
  ;inc 	cx		;INCREMENTA CX
  ;dec 	si		;DECREMENTA SI
  ;mov 	ah,0Eh		;COPIA 0E A AH (PARA IMPRIMIR CARACTERES CON INT 10)
  ;int 	10h		;RETORNO DE CARRO
  ;mov 	al,0h		;COPIA 0 EN AL (CARACTER VACIO)
  ;int 	10h		;ESCRIBE UN CARACTER VACIO PISANDO AL ANTERIOR
  ;mov 	al,8h		;COPIA 8 EN AL (RETORNO DE CARRO)
  ;int 	10h		;VUELVE DENUEVO PARA ATRAS
 ;ingreso:
  ;mov 	ah,0		;COPIA 0 EN AH PARA CAPTURAR TECLAS
  ;int 	16h		;CATURA UNA TECLA
 ;verificar:
  ;cmp 	al,13d		;VERIFICA SI EL CARACTER INGRESADO ES ENTER
  ;je 	fin_ingreso	;SI ES ENTER SALTA A FIN_INGRESO
  ;cmp 	al,8d		;VERIFICA SI EL CARACTER INGRESADO ES BACKSPACE
  ;je 	borrar		;SI ES BACKSPACE SALTA A BORRAR
  ;sub 	al,30h		;RESTA 30H AL CARACTER INGRESADO (ASCII->BCD)
  ;cmp 	al,10d		;COMPARA EL CARACTER INGRESADO CON 10
  ;jb 	continuar	;SI ES MENOR SALTA A CONTINUAR
  ;jmp 	ingreso		;SINO VUELVE A INGRESO
 ;continuar:
  ;add 	al,30h		;VUELVE A CONVERTIR EL BCD A ASCII
  ;mov 	ah,0Eh		;COPIA 0E EN AH (PARA IMPRIMIR)
  ;int 	10h		;IMPRIME EL CARACTER
  ;mov 	[si],AL		;GUARDA EL CARACTER EN LA POSICION DEL VECTOR CORRESPONDIENTE
  ;inc 	si		;PASA A LA SIGUIENTE POSICION DEL VECTOR
  ;loop 	ingreso		;VUELVE A INGRESO SI CX NO ES 0 (ES DECIR SI NO SE TERMINARON DE INGRESAR TODOS LOS DIGITOS)
 ;fin_ingreso:
  ;ret
;registrar_ingreso endp

;ESTA SUBRUTINA PERMITE ACOMODAR
;NECESITA DE UN VECTOR FUENTE CARGADO EN SI
;NECESITA DE UN VECTOR DE DESTINO DI EN DONDE GUARDAR EL NUEVO VECTOR

acomodar_vector proc
  mov 	ah,cl		;COPIA CL EN AH
  add 	ah,7		;LE AGREGA 7 A AH
  mov 	cx,5		;COPIA 5 EN CX
 copiar:
  dec 	ah		;DECREMENTA AH
  cmp 	ah,5		;COMPARA AH CON 5  
  jnbe 	escape		;SI ES MAYOR A 5 SALTA A ESCAPE
  mov 	al,[si]		;COPIA EL CONTENIDO DE LA POSICION CORRESPONDIENTE (DEPENDE DE CX) DEL VECTOR 1 EN AL
  mov 	[di],al		;COPIA EL CONTENIDO DE AL EN LA POSICION CORRESPONDIENTE (DEPENDE DE CX) DEL VECTOR 2
  inc 	si		;INCREMENTA LA POSICION DEL VECTOR 1
 escape:
  inc 	di		;INCREMENTA LA POSICION DEL VECTOR 2
  loop 	copiar		;VUELVE A COPIAR SI CX NO ES 0 (ES DECIR SI NO SE TERMINO DE RECORRER EL VECTOR)
  ret
acomodar_vector endp

imprimir proc
  mov 	ah,0Eh
  mov 	al,[si]
  inc 	si
  int 	10h
  loop 	imprimir
  ret
imprimir endp