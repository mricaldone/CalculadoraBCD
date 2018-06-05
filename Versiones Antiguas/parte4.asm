#make_COM#	; create ".com" executable (DOS 1.0 compatible).
org  100h	; add +100h to all addresses (required for .com file).

;PARTE 4
;CONVIERTE LOS VECTORES NUM1 Y NUM2 ASCII EN BCD NAT/AKN/XS3

jmp inicio

num1 db '04545'
num2 db '00000'
tipo db 2

inicio:

  lea si,num1
  mov cx,5
  call imprimir_ascii

  lea si,num1
  mov cx,5
  call conversor_bcd

  lea si,num1
  mov cx,5
  call imprimir_bcd

int 20h

;IMPRIME UN VECTOR ASCII
imprimir_ascii proc
  mov 	ah,0Eh
  mov 	al,[si]
  inc 	si
  int 	10h
  loop 	imprimir_ascii
  ret
imprimir_ascii endp

;IMPRIME UN VECTOR BCD
imprimir_bcd proc
  mov 	ah,0Eh
  mov 	al,[si]
  add 	al,30h
  inc 	si
  int 	10h
  loop 	imprimir_bcd
  ret
imprimir_bcd endp

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