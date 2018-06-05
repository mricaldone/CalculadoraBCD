#make_COM#	; create ".com" executable (DOS 1.0 compatible).
org  100h	; add +100h to all addresses (required for .com file).

;PARTE 3
;ORDENA LOS VECTORES, COLOCA EL MAYOR EN NUM1 Y EL MENOR EN NUM2

jmp inicio

num1 	db '00010'
num2 	db '04000'
aux	db '00000'

inicio:

  mov cx,5
  call ordenar_vectores

  lea si,num1
  mov cx,5
  call imprimir_ascii
  
  lea si,num2
  mov cx,5
  call imprimir_ascii

int 20h

;IMPRIME UN VECTOR ASCII
;NECESITA TENER CARGADO EN "SI" LA DIRECCION DE MEMORIA DE LA VARIABLE QUE DEBE SER IMPRESA
;SE DEBE COLOCAR EN CX EL TAMA�O DEL VECTOR
imprimir_ascii proc
  mov 	ah,0Eh
  mov 	al,[si]
  inc 	si
  int 	10h
  loop 	imprimir_ascii
  ret
imprimir_ascii endp

;ORDENA LOS VECTORES NUM1 Y NUM2 GUARDA EN NUM1 EL MAYOR DE LOS 2 Y EN NUM2 EL MENOR
;NECESITA DE LOS VECTORES AUX, NUM1 Y NUM2
;SE DEBE COLOCAR EN CX EL TAMA�O DEL VECTOR
;REQUIERE DE LA SUBRUTINA "COPIAR VECTOR"

ordenar_vectores proc
  mov 	bx,cx		;GUARDA EN BX EL VALOR DE CX (CX CONTIENE EL TAMA�O DEL VECTOR QUE TAMBIEN SE USARA PARA COPIARLO MAS ADELANTE)
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
  mov 	cx,bx		;RECUPERA EL TAMA�O DEL VECTOR Y LO GUARDA EN CX
  call 	copiar_vector	;COPIA EL VECTOR NUM2 EN AUX
  lea 	si,num1		;CARGA EN SI LA DIRECCION DE MEMORIA DE NUM1
  lea 	di,num2		;CARGA EN DI LA DIRECCION DE MEMORIA DE NUM2
  mov 	cx,bx		;RECUPERA EL TAMA�O DEL VECTOR Y LO GUARDA EN CX
  call 	copiar_vector	;COPIA EL VECTOR NUM1 EN NUM2
  lea 	si,aux		;CARGA EN SI LA DIRECCION DE MEMORIA DE AUX
  lea 	di,num1		;CARGA EN DI LA DIRECCION DE MEMORIA DE NUM1
  mov 	cx,bx		;RECUPERA EL TAMA�O DEL VECTOR Y LO GUARDA EN CX
  call 	copiar_vector	;COPIA EL VECTOR AUX EN NUM1
 oend:
  ret
ordenar_vectores endp

;COPIA DEL VECTOR CARGADO EN SI AL VECTOR CARGADO DI
;SE DEBE COLOCAR EN CX EL TAMA�O DEL VECTOR

copiar_vector proc
  mov 	al,[si]		;COPIA EN AL EL VALOR DE UNA POSICION DEL VECTOR CARGADO EN SI
  mov 	[di],al		;COPIA EL VALOR DE AL EN UNA POSICION DEL VECTOR CARGADO EN DI
  inc 	si		;PASA A LA SIGUIENTE POSICION DEL VECTOR CARGADO EN SI
  inc 	di		;PASA A LA SIGUIENTE POSICION DEL VECTOR CARGADO EN DI
  loop 	copiar_vector	;VUELVE A COPIAR_VECTOR SI CX NO ES 0 (ES DECIR SI NO SE TERMINO DE COPIAR TODO)
  ret
copiar_vector endp