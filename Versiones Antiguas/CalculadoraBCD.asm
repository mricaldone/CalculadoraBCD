
;	TP ASSEMBLER - CALCULADORA BCD
;	2DO CUATRIMESTRE 2012
;
;	- URQUIZA, LUCAS
;	- RICALDONE, MATIAS

#make_COM#	; create ".com" executable (DOS 1.0 compatible).
org  100h	; add +100h to all addresses (required for .com file).

jmp main

pres1 db 201d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,187d,0
pres6 db 186d,'     SISTEMAS DE PROCESAMIENTO DE DATOS     ',186d,0
pres8 db 186d,'                                            ',186d,0
pres2 db 186d,'              CALCULADORA  BCD              ',186d,0
pres3 db 186d,' Ricaldone, Matias                          ',186d,0
pres9 db 186d,' matias.ricaldone@hotmail.com               ',186d,0
pres4 db 186d,' Urquiza, Lucas                             ',186d,0
pres5 db 186d,' lucas.urqui@hotmail.com                    ',186d,0
pres7 db 200d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,205d,188d,0
pres0 db      '    Presiones una tecla para comenzar...',0

sep	db	196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,0
aux 	db 	'00000'
num1 	db 	'00000'
num2 	db 	'00000'
rbin	db	'00000'
adds	db	'00000'
oflw	db	'                                   ',0
sign	db	'    +      +      +      +      +  ',0
resu 	db 	0,0,0,0,0
tipo 	db 	0
oper 	db 	0
msj01	db	'ELIJA UN METODO',0
msj02	db	'INGRESE LOS NUMEROS A OPERAR',0
line	db	196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,0
msj03	db	'1-BCD NATURAL',0
msj04	db	'2-BCD AIKEN',0
msj05	db	'3-BCD EXCESO 3',0
msj07	db	'0-SALIR',0
msj08	db	'INGRESE UNA OPCION:',0
msj10	db	'0-VOLVER',0
msj09	db	'ELIJA UNA OPERACION',0
msj11	db	'1-SUMA',0
msj12	db	'2-RESTA',0
msj15	db	' ',218d,196d,196d,196d,196d,196d,196d,196d,194d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,194d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,191d,0
msj13	db	' ',179d,'0-SALIR',179d,'1-CAMBIAR DE METODO',179d,'2-RECALCULAR',179d,0
msj16	db	' ',192d,196d,196d,196d,196d,196d,196d,196d,193d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,193d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,196d,217d,0
msj14	db	'Elija una opcion: ',0
msjakn	db	'AIKEN ',0
msjnat	db	'NATURAL ',0
msjxs3	db	'EXCESO 3 ',0
msjsum	db	'SUMA ',0
msjres	db	'RESTA ',0	

main:
  call 	limpiar
  call	presentacion

configuracion:
  call 	menu_metodo
  call 	menu_operacion
 
  call 	ingreso_oper
  cmp 	al,0
  je	configuracion
 recalcular:
  call  inicio
 confirmar:
  mov 	ax,00h
  int 	16h
  cmp   al,30h
  je    salida
  cmp   al,31h
  je	configuracion
  cmp   al,32h
  je	recalcular
  jmp 	confirmar
 salida:
  mov 	ax,0
  int	21h

inicio proc
  lea 	si,num1
  mov	cx,5
  call 	limpiar_vector
  lea 	si,num2
  mov	cx,5
  call 	limpiar_vector
  call 	limpiar
  
  cmp	oper,1
  je	mostrar_sum
  cmp	oper,2
  je	mostrar_res
 mostrar_sum:
  lea	si,msjsum
  call 	imprimir
  jmp	seguir1
 mostrar_res:
  lea	si,msjres
  call 	imprimir
 seguir1:
  cmp	tipo,1
  je	mostrar_nat
  cmp	tipo,2
  je	mostrar_akn
  cmp	tipo,3
  je	mostrar_xs3
 mostrar_nat:
  lea	si,msjnat
  call 	imprimir
  jmp	seguir2
 mostrar_akn:
  lea	si,msjakn
  call 	imprimir
  jmp	seguir2
 mostrar_xs3:
  lea	si,msjxs3
  call 	imprimir
 seguir2:
  lea 	si,msj02
  call 	imprimir
  call 	enter
  lea 	si,line
  call 	imprimir
  call 	enter
  mov 	cx,4
  lea 	si,aux
  call 	registrar_ingreso
  lea 	si,aux
  lea 	di,num1
  call 	acomodar_vector
  call 	enter
  mov 	cx,4
  lea 	si,aux
  call 	registrar_ingreso
  lea 	si,aux
  lea 	di,num2
  call 	acomodar_vector
  call 	enter
  mov 	cx,5
  call 	ordenar_vectores
  lea 	si,num1
  mov 	cx,5
  call 	conversor_bcd
  lea 	si,num2
  mov 	cx,5
  call 	conversor_bcd
  
  lea 	si,sep
  call 	imprimir
  call 	enter
  
  lea 	si,oflw
  mov	cx,30d
  call 	limpiar_vector_vacio
  
  mov 	cx,5
  call 	operacion_auto
  
  lea 	si,oflw
  call 	imprimir
  call 	enter
  
  lea	si,num1
  mov	cx,5
  call	imprimir_binario
  call 	enter
  
  lea	si,num2
  mov	cx,5
  call	imprimir_binario
  call 	enter
  
  lea 	si,sep
  call 	imprimir
  call 	enter
  
  lea	si,rbin
  mov	cx,5
  call	imprimir_binario
  call 	enter
  
  lea 	si,sign
  call 	imprimir
  call 	enter
  
  lea	si,adds
  mov	cx,5
  call	imprimir_binario
  call 	enter
  
  lea 	si,sep
  call 	imprimir
  call 	enter
  
  lea	si,resu
  mov	cx,5
  call	imprimir_binario
  
  call 	enter
  call 	enter
  lea 	si,msj15
  call 	imprimir
  call 	enter  
  lea 	si,msj13
  call 	imprimir
  call 	enter
  lea 	si,msj16
  call 	imprimir
  call 	enter
  call 	enter
  lea 	si,msj14
  call 	imprimir
  ret
inicio endp

menu_operacion proc
  call 	limpiar
  lea 	si,msj09
  call 	imprimir
  call 	enter
  lea 	si,line
  call 	imprimir
  call 	enter
  lea 	si,msj11
  call 	imprimir
  call 	enter
  lea 	si,msj12
  call 	imprimir
  call 	enter
  call 	enter
  lea 	si,line
  call 	imprimir
  call 	enter
  lea 	si,msj10
  call 	imprimir
  call 	enter
  call 	enter
  lea 	si,msj08
  call 	imprimir
  ret
menu_operacion endp

menu_metodo proc
  call 	limpiar
  lea 	si,msj01
  call 	imprimir
  call 	enter
  lea 	si,line
  call 	imprimir
  call 	enter
  lea 	si,msj03
  call 	imprimir
  call 	enter
  lea 	si,msj04
  call 	imprimir
  call 	enter
  lea 	si,msj05
  call 	imprimir
  call 	enter
  lea 	si,line
  call 	imprimir
  call 	enter
  lea 	si,msj07
  call 	imprimir
  call 	enter
  call 	enter
  lea 	si,msj08
  call 	imprimir
  call 	ingreso_tipo
  cmp 	al,0
  jne	metodo_cont
  mov	ax,0
  int 	20h
metodo_cont:
  ret
menu_metodo endp

;ESTA SUBRUTINA AGREGA UN SALTO DE LINEA EN LA PANTALLA

enter proc
  mov 	ah,0Eh
  mov 	al,10d
  int 	10h
  mov 	al,13d
  int 	10h
  ret
enter endp

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

;ORDENA LOS VECTORES NUM1 Y NUM2 GUARDA EN NUM1 EL MAYOR DE LOS 2 Y EN NUM2 EL MENOR
;NECESITA DE LOS VECTORES AUX, NUM1 Y NUM2
;SE DEBE COLOCAR EN CX EL TAMAÑO DEL VECTOR
;REQUIERE DE LA SUBRUTINA "COPIAR VECTOR"

ordenar_vectores proc
  mov 	bx,cx		;GUARDA EN BX EL VALOR DE CX (CX CONTIENE EL TAMAÑO DEL VECTOR QUE TAMBIEN SE USARA PARA COPIARLO MAS ADELANTE)
  lea 	si,num1		;CARGA LA DIRECCION DE MEMORIA DE SI EN NUM1
  lea 	di,num2		;CARGA LA DIRECCION DE MEMORIA DE DI EN NUM2
 compara:
  mov 	al,[si]		;COPIA EL VALOR DE UNA POSICION DEL VECTOR NUM1 EN AL
  cmp 	al,[di]		;COMPARA AL CON EL VALOR DE UNA POSICION DEL VECTOR NUM2
  jne 	ordena		;SI NO SON IGUALES SALTA A ORDENA (SI SON IGUALES CONTINUA PORQUE NO ALCANZAN LOS DATOS PARA SABER CUAL ES MAYOR)
  inc 	si		;ACCEDE A LA SIGUIENTE POSICION DE NUM1
  inc 	di		;ACCEDE A LA SIGUIENTE POSICION DE NUM2
  loop 	compara		;VUELVE A COMPARA SI CX NO ES 0
 ordena:
  mov 	al,[si]		;COPIA EL VALOR DE UNA POSICION DEL VECTOR NUM1 EN AL
  cmp 	al,[di]		;COMPARA EL VALOR DEL VECTOR NUM2 CON AL
  ja 	oend		;SALTA A OEND SI NUM1 ES MAYOR A NUM2 (OSEA QUE NO NECESITA ORDENAR PORQUE NUM1 ES MAYOR QUE NUM2)
  lea 	si,num2		;CARGA EN SI LA DIRECCION DE MEMORIA DE NUM2
  lea 	di,aux		;CARGA EN DI LA DIRECCION DE MEMORIA DE AUX
  mov 	cx,bx		;RECUPERA EL TAMAÑO DEL VECTOR Y LO GUARDA EN CX
  call 	copiar_vector	;COPIA EL VECTOR NUM2 EN AUX
  lea 	si,num1		;CARGA EN SI LA DIRECCION DE MEMORIA DE NUM1
  lea 	di,num2		;CARGA EN DI LA DIRECCION DE MEMORIA DE NUM2
  mov 	cx,bx		;RECUPERA EL TAMAÑO DEL VECTOR Y LO GUARDA EN CX
  call 	copiar_vector	;COPIA EL VECTOR NUM1 EN NUM2
  lea 	si,aux		;CARGA EN SI LA DIRECCION DE MEMORIA DE AUX
  lea 	di,num1		;CARGA EN DI LA DIRECCION DE MEMORIA DE NUM1
  mov 	cx,bx		;RECUPERA EL TAMAÑO DEL VECTOR Y LO GUARDA EN CX
  call 	copiar_vector	;COPIA EL VECTOR AUX EN NUM1
 oend:
  ret
ordenar_vectores endp

;COPIA DEL VECTOR CARGADO EN SI AL VECTOR CARGADO DI
;SE DEBE COLOCAR EN CX EL TAMAÑO DEL VECTOR

copiar_vector proc
  mov 	al,[si]		;COPIA EN AL EL VALOR DE UNA POSICION DEL VECTOR CARGADO EN SI
  mov 	[di],al		;COPIA EL VALOR DE AL EN UNA POSICION DEL VECTOR CARGADO EN DI
  inc 	si		;PASA A LA SIGUIENTE POSICION DEL VECTOR CARGADO EN SI
  inc 	di		;PASA A LA SIGUIENTE POSICION DEL VECTOR CARGADO EN DI
  loop 	copiar_vector	;VUELVE A COPIAR_VECTOR SI CX NO ES 0 (ES DECIR SI NO SE TERMINO DE COPIAR TODO)
  ret
copiar_vector endp

;CONVIERTE AUTOMATICAMENTE UNA CADENA ASCII PRECARGADA EN "SI" A BDC NATURAL / AIKEN / EXCESO 3
;DEPENDE DE LA VARIBLE "TIPO"
;NECESITA QUE EL TAMAÑO DEL VECTOR ESTE CARGADO EN CX

conversor_bcd proc
  mov 	al,[si]		;COPIA EL CONTENIDO DE UNA POSICION DEL VECTOR CARGADO EN SI A AL
  call 	ascii_to_bcd	;CONVIERTE ESE VALOR DE ASCII A BCD
  cmp 	tipo,2		;COMPARA LA VARIABLE TIPO CON EL VALOR 2
  je 	takn		;SI ES 2 SALTA A TAKN
  cmp 	tipo,3		;COMPARA LA VARIABLE TIPO CON EL VALOR 3
  je 	txs3		;SI ES 3 SALTA A TXS3
  jmp 	tend		;SALTA A TEND
 takn:
  call 	trans_akn	;TRANSFORMA BCD A AIKEN
  jmp 	tend		;SALTA A TEND
 txs3:
  call 	trans_xs3	;TRANSFORMA BCD A EXCESO 3
  jmp 	tend		;SALTA A TEND
 tend:
  mov 	[si],al		;GUARDA EL VALOR TRANSFORMADO EN LA POSICION DEL VECTOR CARGADO EN SI (DE DONDE LO TOMO EN PRINCIPIO)
  inc 	si		;INCREMENTA SI
  loop 	conversor_bcd	;VUELVE A CONVERSOR_BCD SI CX NO ES 0 (ES DECIR SI NO SE TERMINO DE RECORRER EL VECTOR)
  ret
conversor_bcd endp

;CONVIERTE UN SOLO CARACTER DE ASCII A BCD

ascii_to_bcd proc
  sub 	al,30h		;CONVIERTE A BCD SUSTRAYENDO 30
  ret
ascii_to_bcd endp

;CONVIERTE UN SOLO CARACTER ASCII A BCD AIKEN
;LO TOMA DE AL Y LO GUARDA EN AL

trans_akn proc
  mov 	ah,0		;COLOCA AH EN 0
  cmp 	al,0100b	;COMPARA AL CON 0100
  jbe 	taend		;SI ES MENOR O IGUAL SALTA A TAEND
  mov 	ah,11111001b	;MUEVE 11111001B A AH
  sub 	ah,al		;LE SUSTRAE EL VALOR DE AL A AH
  not 	ah		;INVIERTE LOS BITS DE AL
  xchg 	al,ah		;INTERCAMBIA AL CON AH
  mov 	ah,0		;DEJA EN 0 AH
 taend:
  ret
trans_akn endp

;CONVIERTE UN SOLO CARACTER ASCII A BCD EXCESO 3
;LO TOMA DE AL Y LO GUARDA EN AL

trans_xs3 proc
  add 	al,0011b	;AGREGA 0011 A AL
  ret
trans_xs3 endp

;ESTA SUBRUTINA SELECCIONA AUTOMATICAMENTE EL TIPO DE OPERACION BASANDOSE EN EL VALOR DE LAS VARIABLES TIPO Y OPER

operacion_auto proc
  mov 	ah,0		;PONE AH EN 0 (AH VA A CONTENER EL OVERFLOW O EL CARRY)
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
  call	load_cy
  cmp	ah,0
  je	ra_st
  mov	[si],'1'	;
  dec	si
  mov	[si],'-'
 ra_st: 
  call	load_adds
  mov	[si],0000b
  mov	bx,ax
  call	load_sign
  mov	[si],' '
  mov	ax,bx
  call	load_num1
  mov 	al,[si]		;COPIA EL VALOR DE UNA POSICION DEL VECTOR NUM1 EN AL
  sub 	al,ah		;LE SUSTRAE AH A AL (EL CARRY)
  call	load_num2
  cmp	al,[si]		;COMPARA AL CON NUM2
  js 	ra_cy		;SI HAY SIGNO QUIERE DECIR QUE NECESITA EL CARRY PARA PODER RESTAR POR LO QUE SALTA A RA_CY
  mov 	ah,0b		;DEJA AH EN 0 INDICA QUE ESTA OPERACION NO UTILIZO CARRY
  ;call	load_num2
  sub 	al,[si]		;LE SUSTRAE NUM2 A AL
  call 	load_rbin
  mov	[si],al
  call 	tabla_akn	;VERIFICA SI ESTA EN TABLA
  cmp 	bx,1		;SI ESTA EN TABLA BX ES 1 SINO ES 0
  je 	ra_end		;SI ESTA EN TABLA SALTA A RA_END
  sub 	al,0110b	;LE SUSTRAE A AL EL VALOR DE UNA POSICION DE MEMORIA DE NUM2
  call	load_adds
  mov	[si],0110b
  mov	bx,ax
  call	load_sign
  mov	[si],'-'
  mov	ax,bx
  jmp 	ra_end		;SALTA A RA_END
 ra_lj:
  jmp	resta_akn
 ra_cy:
  call	load_crry
  mov	[si],'+'	;
  inc	si
  mov	[si],'1'	;
  inc	si
  mov	[si],'0'	;
  inc	si
  mov 	ah,1b		;INDICA QUE EN ESTA OPERACION SE USO CARRY COLOCANDO AH EN 1
  add 	al,10h		;AGREGA EL CARRY A AL
  call	load_num2
  sub 	al,[si]		;LE SUSTRAE A AL EL CONTENIDO DE UNA POSICION DEL VECTOR NUM2
  call 	load_rbin
  mov	[si],al
  call	tabla_akn	;VERIFICA SI ESTA EN TABLA
  cmp 	bx,1		;SI ESTA EN TABALA BX VALE 1 SINO ES 0
  je	ra_end		;SI ESTA EN TABLA SALTA A RA_END
  add 	al,0110b	;LE SUSTRAE 0110
  call	load_adds
  mov	[si],0110b
  mov	bx,ax
  call	load_sign
  mov	[si],'+'
  mov	ax,bx
 ra_end:
  call	load_resu
  mov 	[si],al		;COPIA AL EN RESU
  loop 	ra_lj	;VUELVE A RESTA_NAT SI CX NO ES 0
  ret
resta_akn endp

;ESTA SUBRUTINA REALIZA UNA RESTA EN BCD NATURAL ENTRE NUM1 Y NUM2 COLOCANDO EL RESULTADO EN EL VECTOR RESU
;NECESITA DE LOS VECTORES NUM1, NUM2 Y RESU

resta_nat proc
  call	load_cy
  cmp	ah,0
  je	rn_st
  mov	[si],'1'	;
  dec	si
  mov	[si],'-'
 rn_st: 
  call	load_num1
  mov 	al,[si]		;COPIA EL VALOR DE UNA POSICION DEL VECTOR NUM1 EN AL
  sub 	al,ah		;LE SUSTRAE AH A AL (EL CARRY)
  call  load_num2
  cmp 	al,[si]		;COMPARA AL CON UNA POSICION DEL VECTOR DE NUM2
  js 	rn_cy		;SI HAY SIGNO QUIERE DECIR QUE NECESITA EL CARRY PARA PODER RESTAR POR LO QUE SALTA A RN_CY
  sub 	al,[si]		;LE SUSTRAE A AL EL VALOR DE UNA POSICION DE MEMORIA DE NUM2
  
  call	load_rbin
  mov	[si],al
  
  call	load_adds
  mov	[si],0000b
  
  mov	bx,ax
  call	load_sign
  mov	[si],' '
  mov	ax,bx
  
  mov 	ah,0b		;DEJA AH EN 0
  jmp 	rn_end		;SALTA A RN_END
 rn_cy:
  call	load_crry
  mov	[si],'+'	;
  inc	si
  mov	[si],'1'	;
  inc	si
  mov	[si],'0'	;
  inc	si
  add 	al,10h		;AGREGA EL CARRY A AL
  call  load_num2
  sub 	al,[si]		;LE SUSTRAE A AL EL CONTENIDO DE UNA POSICION DEL VECTOR NUM2
  
  call	load_rbin
  mov	[si],al
  
  sub 	al,0110b	;LE SUSTRAE 0110
  
  call	load_adds
  mov	[si],0110b
  
  mov	bx,ax
  call	load_sign
  mov	[si],'-'
  mov	ax,bx
  
  mov 	ah,1b		;INDICA QUE EN ESTA OPERACION SE USO CARRY COLOCANDO AH EN 1
 rn_end:
  call	load_resu
  mov 	[si],al		;COPIA AL EN RESU
  loop 	resta_nat	;VUELVE A RESTA_NAT SI CX NO ES 0
  ret
resta_nat endp

;ESTA SUBRUTINA REALIZA UNA SUMA EN BCD NATURAL ENTRE NUM1 Y NUM2 COLOCANDO EL RESULTADO EN EL VECTOR RESU
;NECESITA DE LOS VECTORES NUM1, NUM2 Y RESU

suma_nat proc
  call	load_oflw
  cmp	ah,0
  je	sn_st
  mov	[si],'1'	;
  dec	si
  mov	[si],'+'
 sn_st: 
  mov	bx,ax
  call	load_sign
  mov	[si],' '
  mov	ax,bx
  call	load_adds
  mov	[si],0b
  call	load_num2
  mov 	al,[si]		;
  call	load_num1
  add 	al,[si]		;
  add 	al,ah		;
  mov 	ah,0b		;
  cmp	al,1111b
  jbe	sn_nof
  sub 	al,10h		;
  mov	ah,1b
  call	load_rbin
  mov 	[si],al		;
  add	al,0110b
  call	load_adds
  mov	[si],0110b
  mov	bx,ax
  call	load_sign
  mov	[si],'+'
  mov	ax,bx
  jmp sn_end
 sn_nof:
  call	load_rbin
  mov 	[si],al		;
  cmp 	al,1001b	;hay overflow? (¿se paso de 9?)
  jbe 	sn_end		;SI NO HAY OVERFLOW SALTA A SA_END
  mov 	ah,1b		;
  add	al,0110b	;
  call	load_adds
  mov	[si],0110b
  mov	bx,ax
  call	load_sign
  mov	[si],'+'
  mov	ax,bx
  jmp	sn_end
 sn_end:
  call	load_resu
  mov 	[si],al		;
  loop 	suma_nat	;
  ret
suma_nat endp

suma_akn proc
  call	load_oflw
  cmp	ah,0
  je	sa_st
  mov	[si],'1'	;
  dec	si
  mov	[si],'+'
 sa_st: 
  mov	bx,ax
  call	load_sign
  mov	[si],' '
  mov	ax,bx
  call	load_adds
  mov	[si],0b  
  call	load_num2
  mov 	al,[si]		;
  call	load_num1
  add 	al,[si]		;
  add 	al,ah		;
  mov 	ah,0b		;
  cmp 	al,1111b	;hay overflow? (¿se paso de 9?)
  jna 	sa_nof		;SI NO HAY OVERFLOW SALTA A SA_END
  sub 	al,10h		;
  call	load_rbin
  mov	[si],al
  mov 	ah,1		;
  call 	tabla_akn	;
  cmp 	bx,1		;
  je 	sa_end		;
  sub  	al,0110b	;
  call	load_adds
  mov	[si],0110b
  mov	bx,ax
  call	load_sign
  mov	[si],'-'
  mov	ax,bx
  jmp 	sa_end		;
 sa_nof:
  call	load_rbin
  mov	[si],al
  call 	tabla_akn	;
  cmp 	bx,1		;
  je 	sa_end		;
  add	al,0110b	;
  mov 	ah,0		;
  call	load_adds
  mov	[si],0110b
  mov	bx,ax
  call	load_sign
  mov	[si],'+'
  mov	ax,bx
 sa_end:
  call	load_resu
  mov 	[si],al		;
  loop 	suma_akn	;
  ret
suma_akn endp

load_num1 proc
  lea 	si,num1		;
  add 	si,cx		;
  dec 	si		;
  ret
load_num1 endp

load_num2 proc
  lea 	si,num2	;
  add 	si,cx		;
  dec 	si		;
  ret
load_num2 endp

load_rbin proc
  lea 	si,rbin	;
  add 	si,cx		;
  dec 	si		;
  ret
load_rbin endp

load_resu proc
  lea 	si,resu	;
  add 	si,cx		;
  dec 	si		;
  ret
load_resu endp

load_oflw proc
  mov	bx,ax
  mov   ax,7
  mul	cx
  sub	ax,3
  lea 	si,oflw		;
  add 	si,ax		;
  dec 	si		;
  mov	ax,bx
  ret
load_oflw endp

load_crry proc
  mov	bx,ax
  mov   ax,7
  mul	cx
  sub	ax,7
  lea 	si,oflw		;
  add 	si,ax		;
  mov	[si],' '	;
  dec 	si		;
  mov	[si],' '	;
  dec	si
  mov	[si],' '	;
  mov	ax,bx
  ret
load_crry endp

load_cy proc
  mov	bx,ax
  mov   ax,7
  mul	cx
  sub	ax,3
  lea 	si,oflw		;
  add 	si,ax		;
  dec 	si		;
  mov	[si],' '	;
  dec	si
  mov	[si],' '	;
  inc	si
  mov	ax,bx
  ret
load_cy endp

load_sign proc
  mov   ax,7
  mul	cx
  sub	ax,2
  lea 	si,sign		;
  add 	si,ax		;
  dec 	si		;
  ret
load_sign endp

load_adds proc
  lea 	si,adds	;
  add 	si,cx		;
  dec 	si		;
  ret
load_adds endp

suma_xs3 proc
  call	load_oflw
  cmp	ah,0
  je	sx_st
  mov	[si],'1'	;
  dec	si
  mov	[si],'+'
 sx_st: 
  call	load_num1
  mov 	al,[si]		;
  call	load_num2
  add 	al,[si]		;
  add 	al,ah		;
  cmp 	al,1111b	;hay overflow? (¿se paso de 9?)
  ja 	sx_of		;
  call	load_rbin
  mov	[si],al		;
  call	load_adds
  mov	[si],0011b	;
  sub 	al,0011b	;
  mov 	ah,0b		;
  mov	bx,ax
  call	load_sign
  mov	[si],'-'	;
  jmp 	sx_end		;
 sx_of:
  sub 	al,10h		;quita el overflow de al
  call	load_rbin
  mov	[si],al
  call	load_adds
  mov	[si],0011b	;
  add 	al,0011b	;
  mov 	ah,1b		;coloca el overflow en ah
  mov	bx,ax
  call	load_sign
  mov	[si],'+'	;
 sx_end:
  mov	ax,bx
  call load_resu	;
  mov 	[si],al		;
  loop 	suma_xs3	;
  ret
suma_xs3 endp

resta_xs3 proc
  call	load_cy
  cmp	ah,0
  je	rx_st
  mov	[si],'1'	;
  dec	si
  mov	[si],'-'
 rx_st: 
  call	load_num1
  mov 	al,[si]		;COPIA EL VALOR DE NUM1 EN AL
  sub 	al,ah		;LE SUSTRAE EL VALOR DEL CARRY A AL
  call	load_num2
  cmp 	al,[si]		;COMPARA EL VALOR DE AL CON NUM2
  js 	rx_cy		;SI HAY SIGNO QUIERE DECIR QUE NECESITA CARRY PARA HACER LA OPERACION POR LO QUE SALTA A RX_CY
  call	load_num1
  mov 	al,[si]		;COPIA NUM1 EN AL
  call	load_num2
  sub 	al,[si]		;LE SUSTRAE NUM2 A AL
  sub 	al,ah		;LE SUSTRAE A AL EL CARRY
  call	load_rbin
  mov	[si],al
  add 	al,0011b	;LE AGREGA A AL 0011
  mov 	ah,0b		;RESETEA EL CARRY
  call	load_adds
  mov	[si],0011b
  mov	bx,ax
  call	load_sign
  mov	[si],'+'
  jmp 	rx_end		;SALTA A RX_END
 rx_cy:
  call	load_crry
  mov	[si],'+'	;
  inc	si
  mov	[si],'1'	;
  inc	si
  mov	[si],'0'	;
  inc	si
  add 	al,10h		;AGREGO EL CARRY PARA PODER REALIZAR LA OPERACION
  call	load_num2
  sub 	al,[si]		;LE SUSTRAIGO EL VALOR DE NUM2 A AL
  call	load_rbin
  mov	[si],al
  sub 	al,0011b	;LE SUSTRAIGO 0011 A AL
  mov 	ah,1b		;COPIO EL CARRY EN AH
  call	load_adds
  mov	[si],0011b
  mov	bx,ax
  call	load_sign
  mov	[si],'-'
 rx_end:
  mov	ax,bx
  call	load_resu
  mov 	[si],al		;COPIO EL VALOR DE AL EN RESU
  loop 	resta_xs3	;VUELVO A RESTA_XS3 SI CX NO ES 0
  ret
resta_xs3 endp

imprimir_binario PROC
  mov	al,[si]
  inc	si
  push	cx
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
  mov	ah,0Eh
  mov 	al,20h
  int 	10h
  int 	10h
  int 	10h
  pop	cx
  loop	imprimir_binario
  RET
imprimir_binario ENDP

IMPRIMIR PROC
  MOV 	AH,0Eh
 SALTO1:
  MOV 	AL,[SI]
  INC 	SI
  CMP 	AL,0
  JE 	SALTO2
  INT 	10h
  JMP 	SALTO1
 SALTO2:
  RET
IMPRIMIR ENDP

LIMPIAR PROC
  MOV 	AX,0600h	;CONFIGURACION DE AX PARA LIMPIAR LA PANTALLA
  MOV 	BH,01110001b 	;PRIMEROS 4 BITS FONDO, SEGUNDOS 4 BITS TEXTO
  MOV 	CX,0000h	;CONFIGURACION DE CX PARA LIMPIAR LA PANTALLA
  MOV 	DX,2479h	;CONFIGURACION DE DX PARA LIMPIAR LA PANTALLA
  INT 	10h 		;LIMPIAR PANTALLA
  MOV 	AH,2       	;CONFIGURACION DE AH PARA POSICIONAR CURSOR AL INICIO
  MOV 	BH,0		;CONFIGURACION DE BH PARA POSICIONAR CURSOR AL INICIO
  MOV 	DX,0000h	;CONFIGURACION DE DH PARA POSICIONAR CURSOR AL INICIO
  INT 	10h  		;POSICIONAR CURSOR AL INICIO
  RET
LIMPIAR ENDP

ingreso_tipo PROC
  MOV 	AH,00h
  INT 	16h
  cmp 	al,33h
  ja 	ingreso_tipo
  cmp 	al,30h
  jb 	ingreso_tipo
  sub 	al,30h
  mov 	tipo,al
  RET
ingreso_tipo ENDP

ingreso_oper PROC
  MOV 	AH,00h
  INT 	16h
  cmp 	al,33h
  ja 	ingreso_oper
  cmp 	al,30h
  jb 	ingreso_oper
  sub 	al,30h
  mov 	oper,al
  RET
ingreso_oper ENDP

limpiar_vector proc
  mov	[si],'0'
  inc	si
  loop	limpiar_vector
  ret
limpiar_vector endp

limpiar_vector_vacio proc
  mov	[si],' '
  inc	si
  loop	limpiar_vector_vacio
  ret
limpiar_vector_vacio endp

presentacion proc
  lea 	si,pres1
  call 	imprimir
  call 	enter
  lea 	si,pres8
  call 	imprimir
  call 	enter
  lea 	si,pres6
  call 	imprimir
  call 	enter
  lea 	si,pres8
  call 	imprimir
  call 	enter
  lea 	si,pres2
  call 	imprimir
  call 	enter
  lea 	si,pres8
  call 	imprimir
  call 	enter
  lea 	si,pres8
  call 	imprimir
  call 	enter
  lea 	si,pres8
  call 	imprimir
  call 	enter
  lea 	si,pres3
  call 	imprimir
  call 	enter
  lea 	si,pres9
  call 	imprimir
  call 	enter
  lea 	si,pres8
  call 	imprimir
  call 	enter
  lea 	si,pres4
  call 	imprimir
  call 	enter
  lea 	si,pres5
  call 	imprimir
  call 	enter
  lea 	si,pres8
  call 	imprimir
  call 	enter
  lea 	si,pres7
  call 	imprimir
  call 	enter
  call 	enter
  lea 	si,pres0
  call 	imprimir
  mov 	ax,0h
  int 	16h
  ret
presentacion endp

;	TP ASSEMBLER - CALCULADORA BCD
;	2DO CUATRIMESTRE 2012
;
;	- URQUIZA, LUCAS
;	- RICALDONE, MATIAS