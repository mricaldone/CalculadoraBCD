#make_COM#	; create ".com" executable (DOS 1.0 compatible).
org  100h	; add +100h to all addresses (required for .com file).
;INCLUDE "PARTE1.ASM"
jmp inicio

num1 db 0000b,0000b,0000b,0000b,1101b
num2 db 0000b,0000b,0000b,0000b,1101b
resu db 0,0,0,0,0
tipo db 2
oper db 1

inicio:


mov cx,5
call operacion_auto

mov al,resu[0]
  call imprimir_binario
  mov al,resu[1]
  call imprimir_binario
  mov al,resu[2]
  call imprimir_binario
  mov al,resu[3]
  call imprimir_binario
  mov al,resu[4]
  call imprimir_binario

int 20h

;ESTA SUBRUTINA SELECCIONA AUTOMATICAMENTE EL TIPO DE OPERACION BASANDOSE EN EL VALOR DE LAS VARIABLES TIPO Y OPER

operacion_auto proc
  cmp 	oper,1		;COMPARA OPER CON 1
  je 	op_sumas	;SI ES 1 SALTA A OP_SUMAS
  cmp 	oper,2		;COMPARA OPER CON 2
  je 	op_restas	;SI ES 2 SALTA A OP_RESTAS
  jmp 	op_end		;SI EL VALOR DE OPER NO ES VALIDO SALTA A OP_END
 op_sumas:
  cmp 	tipo,1		;COMPARA TIPO CON 1
  je 	op_snat		;SI ES 1 SALTA A OP_SNAT
  cmp 	tipo,2		;COMPARA TIPO CON 2
  je 	op_sakn		;SI ES 2 SALTA A OP_SAKN
  cmp 	tipo,3		;COMPARA TIPO CON 3
  je 	op_sxs3		;SI ES 3 SALTA A OP_SXS3
  jmp 	op_end		;SI EL VALOR DE TIPO NO ES VALIDO SALTA A OP_END
 op_restas:
  cmp 	tipo,1		;COMPARA TIPO CON 1
  je 	op_rnat		;SI ES 1 SALTA A OP_RNAT
  cmp 	tipo,2		;COMPARA TIPO CON 2
  je 	op_rakn		;SI ES 2 SALTA A OP_RAKN
  cmp 	tipo,3		;COMPARA TIPO CON 3
  je 	op_rxs3		;SI ES 3 SALTA A OP_RXS3
  jmp 	op_end		;SI EL VALOR DE TIPO NO ES VALIDO SALTA A OP_END
 op_snat:
  call 	suma_nat	;LLAMADA A LA SUBRUTINA SUMA_NAT
  jmp 	op_end		;SALTA A OP_END
 op_sakn:
  call 	suma_akn	;LLAMADA A LA SUBRUTINA SUMA_AKN
  jmp	op_end		;SALTA A OP_END
 op_sxs3:
  call 	suma_xs3	;LLAMADA A LA SUBRUTINA SUMA_XS3
  jmp 	op_end		;SALTA A OP_END
 op_rnat:
  call 	resta_nat	;LLAMADA A LA SUBRUTINA RESTA_NAT
  jmp 	op_end		;SALTA A OP_END
 op_rakn:
  call 	resta_akn	;LLAMADA A LA SUBRUTINA RESTA_AKN
  jmp 	op_end		;SALTA A OP_END
 op_rxs3:
  call 	resta_xs3	;LLAMADA A LA SUBRUTINA RESTA_XS3
  jmp 	op_end		;SALTA A OP_END
 op_end:
  ret
operacion_auto endp

;ESTA SUBRUTINA DEVUELVE BX=1 SI ES AIKEN O BX=0 SI NO LO ES
;EL NUMERO A PROBAR TIENE QUE ESTAR CARGADO EN AL

tabla_akn proc
  cmp 	al,0100b	;COMPARA AL CON 0100
  jbe 	es_akn		;SALTA A ES_AKN SI AL ES MENOR A 0100
  cmp 	al,1011b	;COMPARA AL CON 1011
  jae 	es_akn		;SALTA A ES_AKN SI AL ES MAYOR A 1011
  mov 	bx,0		;COMO NO ES AIKEN COLOCA BX EN 0
  jmp 	end_akn		;SALTA A END_AKN
 es_akn:
  mov 	bx,1		;COMO ES AIKEN COLOCA BX EN 1
 end_akn:
  ret
tabla_akn endp

;ESTA SUBRUTINA REALIZA UNA RESTA EN BCD AIKEN ENTRE NUM1 Y NUM2 COLOCANDO EL RESULTADO EN EL VECTOR RESU
;NECESITA DE LOS VECTORES NUM1, NUM2 Y RESU
resta_akn proc
  lea 	si,num1		;CARGA LA DIRECCION DE MEMORIA DE NUM1 EN SI
  lea 	di,num2		;CARGA LA DIRECCION DE MEMORIA DE NUM2 EN DI
  add 	si,cx		;AGREGA A SI EL VALOR DE CX (PARA EMPEZAR DESDE LA ULTIMA POSICION)
  add 	di,cx		;AGREGA A DI EL VALOR DE CX (PARA EMPEZAR DESDE LA ULTIMA POSICION)
  dec 	si		;DECREMENTA UNA POSICION DEL VECTOR NUM1
  dec 	di		;DECREMENTA UNA POSICION DEL VECTOR NUM2
  mov 	al,[si]		;COPIA EL VALOR DE UNA POSICION DEL VECTOR NUM1 EN AL
  sub 	al,ah		;LE SUSTRAE AH A AL (EL CARRY)
  cmp	al,[di]		;COMPARA AL CON NUM2
  js 	ra_cy		;SI HAY SIGNO QUIERE DECIR QUE NECESITA EL CARRY PARA PODER RESTAR POR LO QUE SALTA A RA_CY
  mov 	ah,0b		;DEJA AH EN 0 INDICA QUE ESTA OPERACION NO UTILIZO CARRY
  sub 	al,[di]		;LE SUSTRAE NUM2 A AL
  call 	tabla_akn	;VERIFICA SI ESTA EN TABLA
  cmp 	bx,1		;SI ESTA EN TABLA BX ES 1 SINO ES 0
  je 	ra_end		;SI ESTA EN TABLA SALTA A RA_END
  sub 	al,0110b	;LE SUSTRAE A AL EL VALOR DE UNA POSICION DE MEMORIA DE NUM2
  jmp 	ra_end		;SALTA A RA_END
 ra_cy:
  mov 	ah,1b		;INDICA QUE EN ESTA OPERACION SE USO CARRY COLOCANDO AH EN 1
  add 	al,10h		;AGREGA EL CARRY A AL
  sub 	al,[di]		;LE SUSTRAE A AL EL CONTENIDO DE UNA POSICION DEL VECTOR NUM2
  call	tabla_akn	;VERIFICA SI ESTA EN TABLA
  cmp 	bx,1		;SI ESTA EN TABALA BX VALE 1 SINO ES 0
  je	ra_end		;SI ESTA EN TABLA SALTA A RA_END
  add 	al,0110b	;LE SUSTRAE 0110
 ra_end:
  lea 	si,resu		;CARGA LA DIRECCION DE MEMORIA DE RESU EN SI
  add 	si,cx		;LE AGREGA A SI EL VALOR DE CX
  dec 	si		;DECREMENTA SI
  mov 	[si],al		;COPIA AL EN RESU
  loop 	resta_akn	;VUELVE A RESTA_NAT SI CX NO ES 0
  ret
resta_akn endp

;ESTA SUBRUTINA REALIZA UNA RESTA EN BCD NATURAL ENTRE NUM1 Y NUM2 COLOCANDO EL RESULTADO EN EL VECTOR RESU
;NECESITA DE LOS VECTORES NUM1, NUM2 Y RESU

resta_nat proc
  lea 	si,num1		;CARGA LA DIRECCION DE MEMORIA DE NUM1 EN SI
  lea 	di,num2		;CARGA LA DIRECCION DE MEMORIA DE NUM2 EN DI
  add 	si,cx		;AGREGA A SI EL VALOR DE CX (PARA EMPEZAR DESDE LA ULTIMA POSICION)
  add 	di,cx		;AGREGA A DI EL VALOR DE CX (PARA EMPEZAR DESDE LA ULTIMA POSICION)
  dec 	si		;DECREMENTA UNA POSICION DEL VECTOR NUM1
  dec 	di		;DECREMENTA UNA POSICION DEL VECTOR NUM2
  mov 	al,[si]		;COPIA EL VALOR DE UNA POSICION DEL VECTOR NUM1 EN AL
  sub 	al,ah		;LE SUSTRAE AH A AL (EL CARRY)
  cmp 	al,[di]		;COMPARA AL CON UNA POSICION DEL VECTOR DE NUM2
  js 	rn_cy		;SI HAY SIGNO QUIERE DECIR QUE NECESITA EL CARRY PARA PODER RESTAR POR LO QUE SALTA A RN_CY
  sub 	al,[di]		;LE SUSTRAE A AL EL VALOR DE UNA POSICION DE MEMORIA DE NUM2
  mov 	ah,0b		;DEJA AH EN 0
  jmp 	rn_end		;SALTA A RN_END
 rn_cy:
  add 	al,10h		;AGREGA EL CARRY A AL
  sub 	al,[di]		;LE SUSTRAE A AL EL CONTENIDO DE UNA POSICION DEL VECTOR NUM2
  sub 	al,0110b	;LE SUSTRAE 0110
  mov 	ah,1b		;INDICA QUE EN ESTA OPERACION SE USO CARRY COLOCANDO AH EN 1
 rn_end:
  lea 	si,resu		;CARGA LA DIRECCION DE MEMORIA DE RESU EN SI
  add 	si,cx		;LE AGREGA A SI EL VALOR DE CX
  dec 	si		;DECREMENTA SI
  mov 	[si],al		;COPIA AL EN RESU
  loop 	resta_nat	;VUELVE A RESTA_NAT SI CX NO ES 0
  ret
resta_nat endp

suma_nat proc
 sn_retry:
  lea 	si,num1
  lea 	di,num2
  add 	si,cx
  add 	di,cx
  dec 	si
  dec 	di
  mov 	al,[si]
  add 	al,[di]
  add 	al,ah
  mov 	ah,0b
  cmp 	al,1001b;hay overflow? (¿se paso de 9?)
  jna 	sn_end
  add 	al,0110b
  sub 	al,10h;quita el overflow de al
  mov 	ah,1b;coloca el overflow en ah
 sn_end:
  lea 	si,resu
  add 	si,cx
  dec 	si
  mov 	[si],al
  loop 	sn_retry
  ret
suma_nat endp

suma_akn proc
  lea 	si,num1		;
  lea 	di,num2		;
  add 	si,cx		;
  add 	di,cx		;
  dec 	si		;
  dec 	di		;
  mov 	al,[si]		;
  add 	al,[di]		;
  add 	al,ah		;
  mov 	ah,0b		;
  cmp 	al,1111b	;hay overflow? (¿se paso de 9?)
  jna 	sa_nof		;SI NO HAY OVERFLOW SALTA A SA_END
  sub 	al,10h
  mov 	ah,1
  call 	tabla_akn	;
  cmp 	bx,1		;
  je 	sa_end		;
  sub  	al,0110b		;
  jmp 	sa_end		;
 sa_nof:
 call 	tabla_akn	;
  cmp 	bx,1		;
  je 	sa_end		;
  add	al,0110b	;
  mov 	ah,0		;
 sa_end:
  lea 	si,resu		;
  add 	si,cx		;
  dec 	si		;
  mov 	[si],al		;
  loop 	suma_akn	;
  ret
suma_akn endp

suma_xs3 proc
 sx_retry:
  lea si,num1
  lea di,num2
  add si,cx
  add di,cx
  dec si
  dec di
  mov al,[si]
  add al,[di]
  add al,ah
  cmp al,1111b;hay overflow? (¿se paso de 9?)
  ja sx_of
  sub al,0011b
  mov ah,0b
  jmp sx_end
 sx_of:
  add al,0011b
  sub al,10h;quita el overflow de al
  mov ah,1b;coloca el overflow en ah
 sx_end:
  lea si,resu
  add si,cx
  dec si
  mov [si],al
  loop sx_retry
  ret
suma_xs3 endp

resta_xs3 proc
  lea 	si,num1		;CARGA LA DIRECCION DE MEMORIA DE NUM1 EN SI
  lea 	di,num2		;CARGA LA DIRECCION DE MEMORIA DE NUM2 EN DI
  add 	si,cx		;AGREGA EL VALOR DE CX A SI
  add 	di,cx		;AGREGA EL VALOR DE CX A DI
  dec 	si		;DECREMENTA SI
  dec 	di		;DECREMENTA DI
  mov 	al,[si]		;COPIA EL VALOR DE NUM1 EN AL
  sub 	al,ah		;LE SUSTRAE EL VALOR DEL CARRY A AL
  cmp 	al,[di]		;COMPARA EL VALOR DE AL CON NUM2
  js 	rx_cy		;SI HAY SIGNO QUIERE DECIR QUE NECESITA CARRY PARA HACER LA OPERACION POR LO QUE SALTA A RX_CY
  mov 	al,[si]		;COPIA NUM1 EN AL
  sub 	al,[di]		;LE SUSTRAE NUM2 A AL
  add 	al,0011b	;LE AGREGA A AL 0011
  sub 	al,ah		;LE SUSTRAE A AL EL CARRY
  mov 	ah,0b		;RESETEA EL CARRY
  jmp 	rx_end		;SALTA A RX_END
 rx_cy:
  add 	al,10h		;AGREGO EL CARRY PARA PODER REALIZAR LA OPERACION
  sub 	al,[di]		;LE SUSTRAIGO EL VALOR DE NUM2 A AL
  sub 	al,0011b	;LE SUSTRAIGO 0011 A AL
  mov 	ah,1b		;COPIO EL CARRY EN AH
 rx_end:
  lea 	si,resu		;CARGO LA DIRECCION DE MEMORIA DE RESU EN SI
  add 	si,cx		;LE AGREGO EL VALOR DE CX A SI
  dec 	si		;DECREMENTO SI
  mov 	[si],al		;COPIO EL VALOR DE AL EN RESU
  loop 	resta_xs3	;VUELVO A RESTA_XS3 SI CX NO ES 0
  ret
resta_xs3 endp

imprimir_binario PROC
  mov 	bx,2
  mov 	cx,4
conversor:
  div 	bx
  push 	dx
  loop 	conversor
  mov 	cx,4
inversor:
  pop 	ax
  add 	al,30h
  MOV 	ah,0Eh
  int 	10h
  loop 	inversor
  mov 	al,20h
  int 	10h
RET
imprimir_binario ENDP