;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»«««««««««««««««««««««««««««««««««««««««««««««««««««««««««;
;»********************************************************************************************************«;
;»* Projecto de Arquitetura de computadores                                                              *«;
;»*                                                                                                      *«;
;»* Projecto: Relogio/Cronometro/Despertador                                                             *«;
;»*                                                                                                      *«;
;»* Produzido por:                                                                                       *«;
;»*               Rodrigo Rocha  Nr. 73952  LETI                   				                         *«;
;»*               Fábio Carvalho Nr. 73811  LETI                                                         *«;
;»*               Filipe Cunha   Nr. 73987  LETI                                                         *«;
;»*                                                                                                      *«;
;»*	Histórico: 		Versão 1.0 		a 15/04/2014                                                         *«;
;»*      	        Versão 2.0 		a 25/14/2014                                                         *«;
;»*      	        Versão 3.0 		a 08/14/2014                                                         *«;
;»*      	        Versão Final 	a 20/05/2014                                                         *«;
;»*                                                                            2013/2014 - 2º Semestre   *«;
;»********************************************************************************************************«;
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»«««««««««««««««««««««««««««««««««««««««««««««««««««««««««;
; **********************************************************************************************************
; ****************************************** Variaveis Globais *********************************************
; *																										   *
; *								R10 - contagem dos impulsos de clock/RTC		                           *
; *																										   *
; **********************************************************************************************************
; ****************************************** Constantes ****************************************************
; **********************************************************************************************************
; **************************************** TECLAS PREMIDAS *************************************************
TECLA_ACERTO_REL	EQU 	0FH		;	tecla 'F'													       *
TECLA_DISABLE		EQU 	0DH		;	tecla 'D'													       *
TECLA_PROG_ALARM	EQU 	0AH		;	tecla 'A'													       *
TECLA_ENABLE		EQU 	0EH		;	tecla 'E'													       *
TECLA_ALARM1		EQU 	01H		;	tecla '1'													       *
TECLA_ALARM2		EQU 	02H		;	tecla '2'													       *
TECLA_ALARM3		EQU 	03H		;	tecla '3'													   	   *	
NENHUMA_TECLA		EQU 	0FFH	;	nenhuma tecla premida										   	   *
; ****************************************** MUARTS ********************************************************
M1_RCU				EQU		0D000H			; Registo controlo da MUART-1								   *
M1_REP				EQU		0D002H			; Registo estado da MUART-1									   *
M1_RD1				EQU		0D004H			; Registo dados da UART 1 da MUART-1 (porto de Rx)			   *
M1_RD2				EQU		0D006H			; Registo dados da UART 2 da MUART-1 (porto de Tx)			   *
TEC_MU_D			EQU		64H				; 64H corresponde ao valor "d" em ASCII.					   *
VAL_NULO			EQU		0FFFFH			; Constante usada para indentificar valores neutros.		   *
MUART				EQU		2000H			; endereco para guardar o valor lido na MUART				   *
; **********************************************************************************************************
FLAG_ALARM1			EQU		2310H	; flag que verifica se o alarm1 esta ativo ou nao 					   *		
FLAG_ALARM2			EQU		2320H	; flag que verifica se o alarm2 esta ativo ou nao 					   *
FLAG_ALARM3			EQU		2330H	; flag que verifica se o alarm3 esta ativo ou nao 					   *
LED					EQU		2400H	; valor anterior do led ativo										   *
SEVENSEGDISPLAY		EQU		0A000H	; endereco do Seven Segment Display									   *
PXMIN				EQU		0C000H  ; endereco de inicio do pixel screen                           		   *
PXMAX				EQU		0C07FH	; endereco de fim do pixel screen							   		   *
LEDs				EQU		9000H	; endereco dos LEDs													   *
maskG				EQU		0FF0FH	; mascara para desenhar os numeros grandes					   		   * 	 		
maskP				EQU		0FF1FH	; mascara para desenhar os numeros pequenos					   		   *	
BUFFERN				EQU		2250H	; endereço de memoria que vai guardar o valor da tecla premida 		   *
HORAS				EQU		2260H	; endereco reservado para guardar o valor das horas			   		   *
HORAS_ANT			EQU		2262H	; endereco reservado para guardar o valor das horas anteriores 		   *	
MINUTOS				EQU		2270H	; endereco reservado para guardar o valor dos minutos 		   		   *
MINUTOS_ANT			EQU		2272H	; endereco reservado para guardar o valor dos minutos anteriores   	   *
SEGUNDOS_ANT		EQU		2280H	; endereco reservado para guardar o valor dos segundos 		   		   *
ALARM1_HORAS		EQU		2290H	; endereco reservado para o valor do alarme para disparar			   *
ALARM3_HORAS_ESQ    EQU		2300H	; endereco reservado para o alarme3 para se verificar o seu valor	   *	
ALARM3_HORAS_DIR    EQU		2301H	; endereco reservado para o alarme3 para se verificar o seu valor	   *
ALARM3_MINUTOS_ESQ  EQU		2302H	; endereco reservado para o alarme3 para se verificar o seu valor	   *
ALARM3_MINUTOS_DIR  EQU		2303H	; endereco reservado para o alarme3 para se verificar o seu valor	   *
ALARM2_HORAS_ESQ    EQU		2304H	; endereco reservado para o alarme2 para se verificar o seu valor	   *
ALARM2_HORAS_DIR    EQU		2305H	; endereco reservado para o alarme2 para se verificar o seu valor	   *
ALARM2_MINUTOS_ESQ  EQU		2306H	; endereco reservado para o alarme2 para se verificar o seu valor	   *
ALARM2_MINUTOS_DIR  EQU		2307H	; endereco reservado para o alarme2 para se verificar o seu valor	   *
ALARM1_HORAS_ESQ    EQU		2308H	; endereco reservado para o alarme1 para se verificar o seu valor	   *
ALARM1_HORAS_DIR    EQU		2309H	; endereco reservado para o alarme1 para se verificar o seu valor	   *
ALARM1_MINUTOS_ESQ  EQU		230AH	; endereco reservado para o alarme1 para se verificar o seu valor	   *
ALARM1_MINUTOS_DIR  EQU		230BH	; endereco reservado para o alarme1 para se verificar o seu valor	   *
ALARM1_MINUTOS		EQU		2292H	; endereco reservado para o valor do alarme para disparar			   *
ALARM2_HORAS		EQU		2294H	; endereco reservado para o valor do alarme para disparar			   *
ALARM2_MINUTOS		EQU		2296H	; endereco reservado para o valor do alarme para disparar			   *
ALARM3_HORAS		EQU		2298H	; endereco reservado para o valor do alarme para disparar			   *
ALARM3_MINUTOS		EQU		229AH	; endereco reservado para o valor do alarme para disparar			   *
LINHA				EQU		1		; posição do bit correspondente à linha (1) a testar           		   *
KEYPADINOUT			EQU		0B000H	; endereço do porto de E/S do teclado						   		   *
; ******************************************** COORDENADAS *************************************************
COORD_HORAS1		EQU		0000H	; coordenada do digito 1 das horas									   *	
COORD_HORAS2		EQU		0005H	; coordenada do digito 2 das horas									   *	
COORD_MIN1			EQU		000CH	; coordenada do digito 1 dos minutos								   * 															
COORD_MIN2			EQU		0011H	; coordenada do digito 2 dos minutos								   *
COORD_SEG1			EQU		0218H	; coordenada do digito 1 dos segundos								   *
COORD_SEG2			EQU		021CH	; coordenada do digito 2 dos segundos								   *
CRONO_MIN1			EQU		0F00H	; coordenada do digito 1 dos minutos (cronometro)					   *		
CRONO_MIN2			EQU		0F05H	; coordenada do digito 2 dos minutos (cronometro)					   *	
CRONO_SEG1			EQU		0F0CH	; coordenada do digito 1 dos segundos (cronometro)					   *	
CRONO_SEG2			EQU		0F11H	; coordenada do digito 2 dos segundos (cronometro)					   *
;																								           *	
; **********************************************************************************************************
; **********************************************************************************************************
; ******************************************** PLACE's *****************************************************
; **********************************************************************************************************
; **********************************************************************************************************
PLACE		3000H	;																			           *			
;																								           *	
; **********************************************************************************************************
; *********************** ESPACO RESERVADO PARA AS IMAGENS DOS NUMEROS GRANDES *****************************
; **********************************************************************************************************
;																										   *	
numeroG_0:	STRING 		0F0H,90H,90H,90H,90H,90H,90H,90H,0F0H 				; Imagem do numero 0 grande    *
numeroG_1:	STRING 		10H,10H,10H,10H,10H,10H,10H,10H,10H					; Imagem do numero 1 grande    *
numeroG_2: 	STRING		0F0H, 10H, 10H, 10H, 0F0H, 80H, 80H, 80H, 0F0H		; Imagem do numero 2 grande    *
numeroG_3:	STRING		0F0H, 10H, 10H, 10H, 0F0H, 10H, 10H, 10H, 0F0H		; Imagem do numero 3 grande    *
numeroG_4:	STRING		90H, 90H, 90H, 90H, 0F0H, 10H, 10H, 10H, 10H		; Imagem do numero 4 grande    *
numeroG_5:	STRING		0F0H, 80H, 80H, 80H, 0F0H, 10H, 10H, 10H, 0F0H		; Imagem do numero 5 grande    *
numeroG_6:	STRING		0F0H, 80H, 80H, 80H, 0F0H, 90H, 90H, 90H, 0F0H		; Imagem do numero 6 grande    *
numeroG_7:	STRING		0F0H, 10H, 10H, 10H, 10H, 10H, 10H, 10H, 10H		; Imagem do numero 7 grande    *
numeroG_8:	STRING		0F0H, 90H, 90H, 90H, 0F0H, 90H, 90H, 90H, 0F0H		; Imagem do numero 8 grande	   *  	
numeroG_9:	STRING		0F0H, 90H, 90H, 90H, 0F0H, 10H, 10H, 10H, 0F0H		; Imagem do numero 9 grande    *
;																										   *	
; **********************************************************************************************************
; *********************** ESPACO RESERVADO PARA AS IMAGENS DOS NUMEROS PEQUENOS ****************************
; **********************************************************************************************************
;																										   *	
numeroP_0:	STRING 		0E0H,0A0H,0A0H,0A0H,0A0H,0A0H,0E0H 					; Imagem do numero 0 pequeno   *
numeroP_1:	STRING 		20H,20H,20H,20H,20H,20H,20H							; Imagem do numero 1 pequeno   *
numeroP_2: 	STRING		0E0H,20H,20H,0E0H,80H,80H,0E0H						; Imagem do numero 2 pequeno   *
numeroP_3:	STRING		0E0H,20H,20H,0E0H,20H,20H,0E0H						; Imagem do numero 3 pequeno   *
numeroP_4:	STRING		0A0H, 0A0H,0A0H,0E0H,20H,20H,20H					; Imagem do numero 4 pequeno   *
numeroP_5:	STRING		0E0H,80H,80H,0E0H,20H,20H,0E0H						; Imagem do numero 5 pequeno   *
numeroP_6:	STRING		0E0H,80H,80H,0E0H,0A0H,0A0H,0E0H					; Imagem do numero 6 pequeno   *
numeroP_7:	STRING		0E0H,20H,20H,20H,20H,20H,20H						; Imagem do numero 7 pequeno   *
numeroP_8:	STRING		0E0H,0A0H,0A0H,0E0H,0A0H,0A0H,0E0H					; Imagem do numero 8 pequeno   *
numeroP_9:	STRING		0E0H,0A0H,0A0H,0E0H,20H,20H,20H						; Imagem do numero 9 pequeno   *
;																										   * 	
; **********************************************************************************************************	
; **********************************************************************************************************
; ***************************** ESPACO RESERVADO PARA A TABELA DE INTERRUPCOES *****************************
; **********************************************************************************************************	
; **********************************************************************************************************
; 																										   *	
PLACE		7000H							  ;															   *	
;																										   * 
; tabela de vectores de interrupcao																		   *		
tab:	WORD	int_0						  ; RTClock1 - 100 milisegundos								   *	
		WORD	0							  ; RTClock2 - 50 milisegundos 								   *
;		WORD	int_3						  ; Comunicacao com a MUART                                    *
;																										   *	
;																										   *	
;																										   *			
; **********************************************************************************************************	
; **********************************************************************************************************
; ************************************ ESPACO RESERVADO PARA A PILHA ***************************************
; **********************************************************************************************************	
; **********************************************************************************************************
PLACE		2000H	   ;																				   *			 			
pilha:		TABLE 100H ;																				   *			 	
;																										   *		
fim_pilha:	;																							   *	
;																										   *	
; **********************************************************************************************************	
; **********************************************************************************************************
; ******************************************* INICIALIZACOES ***********************************************
; **********************************************************************************************************	
; **********************************************************************************************************
PLACE		0				;																			   *			
inicio:						; inicializações gerais														   *	
	DI1						; Disable da interrupcao 1 										 		   	   *	
	DI0						; Disable da interrupcao 0												       *	
	DI						; Disable das interrupcoes (clock nao esta ainda a contar)	 			       *		
	MOV		R1, PXMIN		; move R1 com endereco de PIXELSCREEN										   *	
	MOV		R10, 00H		; inicializa o registo														   *	
	MOV		BTE, tab		; inicializa BTE															   *	
	MOV		SP, fim_pilha	; inicializa SP																   *
	Call	inicia_programa	; rotina que inicia o programa												   *					
	EI0						; Enable da interrupcao 0               									   *	
	EI						; Enable das interrupcoes o clock pode começar a contar					   	   *	
;																										   *		
; **********************************************************************************************************	
; **********************************************************************************************************
; ******************************************* CICLO_PRINCIPAL **********************************************
; **********************************************************************************************************	
; **********************************************************************************************************
;																										   *	 		
ciclo_da_vida:					; ciclo principal														   *			
	Call	processa_tecla		; chama ciclo que espera inputs para reencaminhar para rotinas			   *
	Call	decide_segundos		; rotina que atualiza relogio e decide o que atualizar				       *
	Call	trata_alarm			;																		   *
	JMP		ciclo_da_vida		; repete 																   *
; **********************************************************************************************************
;																										   *	
; **********************************************************************************************************
; **********************************************************************************************************
; ************************************************ ROTINAS *************************************************
; **********************************************************************************************************
; **********************************************************************************************************

; *********************************
;		FUNÇAO TRATA_ALARM
; DESCRIÇAO: --
; PARAMETROS: --
; DEVOLVE: --
; DEPENDENCIAS: --
; DESTROI: --
; NOTA: --
trata_alarm:
trata_alarm1:
	MOV		R1, FLAG_ALARM1	
	MOVB	R0, [R1]
	CMP		R0, 0H
	JZ		trata_alarm2
	
	MOV 	R2, LEDs
	MOV		R5, LED
	MOVB	R3, [R5]
	MOV		R4, 01H
	OR		R3, R4
	
	MOVB	[R2], R3
	MOV		R2, LED
	MOVB	[R2], R3 
	
trata_alarm2:	
	MOV		R1, FLAG_ALARM2	
	MOVB	R0, [R1]
	CMP		R0, 0H
	JZ		trata_alarm3
	
	MOV 	R2, LEDs
	MOV		R5, LED
	MOVB	R3, [R5]
	
	MOV		R4, 02H
	OR		R3, R4
	
	MOVB	[R2], R3
	MOV		R2, LED
	MOVB	[R2], R3 
	
trata_alarm3:
	MOV		R1, FLAG_ALARM3	
	MOVB	R0, [R1]
	CMP		R0, 0H
	JZ		fim_trata_alarm
	
	
	MOV 	R2, LEDs
	MOV		R5, LED
	MOVB	R3, [R5]
	
	MOV		R4, 4H
	OR		R3, R4
	
	MOVB	[R2], R3
	MOV		R2, LED
	MOVB	[R2], R3
	
fim_trata_alarm:
	RET

; *********************************
;		FUNÇAO INICIA_PROGRAMA
; DESCRIÇAO: Funcao que inicial o programa chama as rotinas iniciais, e inicializa variaveis e posicoes de memoria 
; PARAMETROS: --
; DEVOLVE: --
; DEPENDENCIAS: LIMPA_PIXEL_SCREEN, DESENHA_DOIS_PONTOS, DESENHA_NUMERO
; DESTROI: --
; NOTA: --

inicia_programa:
	MOV		R4, 00H						; move com valor "de limpeza"
	MOV		R2,HORAS_ANT				; move com endereco
	MOV		R5,MINUTOS_ANT				; move com endereco
	MOV		R3,SEGUNDOS_ANT				; move com endereco
	MOV		R8, MINUTOS					; move com endereco
	MOVB	[R5], R4					; limpa endereco
	MOVB	[R2], R4					; limpa endereco
	MOVB	[R3], R4					; limpa endereco
	MOVB	[R8], R4					; limpa endereco
	MOV		R5, LED
	MOVB	[R5], R4					; limpa endereco
	

	Call	limpa_vidros				; chamada rotina limpa_vidros (limpa pixel screen)							  
	Call	dois_pontos					; chamada rotina que desenha os dois pontos	
	
	MOV		R0, 0						; que numero desenhar
	MOV		R9, 1						; que tamanho desenhar 
	MOV		R1, COORD_HORAS1			; onde desenhar
	Call	desenha_numero				; chama funcao
	
	MOV		R0, 0						; que numero desenhar
	MOV		R9, 1						; que tamanho desenhar 
	MOV		R1, COORD_HORAS2			; onde desenhar
	Call	desenha_numero				; chama funcao
	
	MOV		R0, 0						; que numero desenhar
	MOV		R9, 1						; que tamanho desenhar 
	MOV		R1, COORD_MIN1				; onde desenhar
	Call	desenha_numero				; chama funcao
	
	MOV		R0, 0						; que numero desenhar
	MOV		R9, 1						; que tamanho desenhar 
	MOV		R1, COORD_MIN2				; onde desenhar
	Call	desenha_numero				; chama funcao
	
	MOV		R0, 0						; que numero desenhar
	MOV		R9, 0						; que tamanho desenhar 
	MOV		R1, COORD_SEG1				; onde desenhar
	Call	desenha_numero				; chama funcao
	
	MOV		R0, 0						; que numero desenhar
	MOV		R9, 0						; que tamanho desenhar 
	MOV		R1, COORD_SEG2				; onde desenhar
	Call	desenha_numero				; chama funcao
	
	MOV		R0, 0						; que numero desenhar
	MOV		R9, 1						; que tamanho desenhar 
	MOV		R1, CRONO_MIN1				; onde desenhar
	Call	desenha_numero				; chama funcao
	
	MOV		R0, 0						; que numero desenhar
	MOV		R9, 1						; que tamanho desenhar 
	MOV		R1, CRONO_MIN2				; onde desenhar
	Call	desenha_numero				; chama funcao
	
	MOV		R0, 0						; que numero desenhar
	MOV		R9, 1						; que tamanho desenhar 
	MOV		R1, CRONO_SEG1				; onde desenhar
	Call	desenha_numero				; chama funcao
	
	MOV		R0, 0						; que numero desenhar
	MOV		R9, 1						; que tamanho desenhar 
	MOV		R1, CRONO_SEG2				; onde desenhar
	Call	desenha_numero				; chama funcao
	
	RET

; *********************************
;		FUNÇAO ENABLE
; DESCRIÇAO: Funcao que inicia o relogio depois de um disable.  
; PARAMETROS: [SEGUNDOS], [MINUTOS], [HORAS] (ANTERIORES)
; DEVOLVE: [SEGUNDOS], [MINUTOS], [HORAS] (ACTUALIZADOS)
; DEPENDENCIAS: --
; DESTROI: --
; NOTA: --
enable:
	EI0		;	Enable da interrupcao 0 o programa vai voltar a iniciar-se e o clock pode começar a contar              	
	EI		;	Enable das interrupcoes
	RET		
	
; *********************************
;		FUNÇAO PROCESSA_TECLA
; DESCRIÇAO: Funcao que processa a tecla premida e reencaminha para a funcao correspondente
; PARAMETROS: --
; DEVOLVE: --
; DEPENDENCIAS: VARRIMENTO_TECLADO, ENABLE, DISABLE, ACERTA_RELOGIO, PROGRAMA_ALARME,<----------- alarm1, alarm2, alarm3 FALTAM!!!
; DESTROI: --
; NOTA: --

processa_tecla:
	Call	varrimento_teclado		; varre o teclado a espera de inputs 
	MOV		R1, NENHUMA_TECLA		; move para registo 	
	CMP		R2, 0					; alguma nova tecla premida?
	JZ		fim_processa_tecla		; se não acaba de processar inputs 
	CMP		R0, R1					; alguma tecla repetida? (ou a ser premida?)
	JZ		fim_processa_tecla		; se sim acaba de processar inputs 

	MOV		R1, TECLA_ACERTO_REL	; move R1, com '0FH'
	CMP		R0, R1					; a tecla '0FH' foi premida?
	JNZ		testa_disable			; se nao foi, testa funcao seguinte
	CALL	acerta_relogio			; se foi chama funcao de acertar relogio
	JMP		fim_processa_tecla		

testa_disable:
	MOV		R1, TECLA_DISABLE		; move R1, com '0DH'
	CMP		R0, R1					; a tecla '0DH' foi premida?
	JNZ		testa_enable			; se nao foi, testa funcao seguinte
	CALL	disable					; se foi chama funcao de desable
	JMP		fim_processa_tecla

testa_enable:
	MOV		R1, TECLA_ENABLE		; move R1, com '0EH'
	CMP		R0, R1					; a tecla '0EH' foi premida?
	JNZ		testa_alarm				; se nao foi, testa funcao seguinte
	CALL	enable					; se foi chama funcao de enable
	JMP		fim_processa_tecla
	
testa_alarm:
	MOV		R1, TECLA_PROG_ALARM	; move R1, com '0AH'		
	CMP		R0, R1					; a tecla '0AH' foi premida?
	JNZ		testa_cons_alarm1		; se nao foi, testa funcao seguinte
	CALL	prog_alarm				; se foi chama funcao de programacao de alarme
	JMP		fim_processa_tecla
	
testa_cons_alarm1:
	MOV		R1, TECLA_ALARM1		; move R1, com '01H'
	CMP		R0, R1					; a tecla '01H' foi premida?
	JNZ		testa_cons_alarm2		; se nao foi, testa funcao seguinte	
	CALL	consulta_alarm1			; se foi chama funcao de consulta de alarme 1
	JMP		fim_processa_tecla
	
testa_cons_alarm2:
	MOV		R1, TECLA_ALARM2		; move R1, com '02H'
	CMP		R0, R1					; a tecla '02H' foi premida?
	JNZ		testa_cons_alarm3		; se nao foi, testa funcao seguinte	
	CALL	consulta_alarm2			; se foi chama funcao de consulta de alarme 2
	JMP		fim_processa_tecla
	
testa_cons_alarm3:	
	MOV		R1, TECLA_ALARM3		; move R1, com '03H'
	CMP		R0, R1					; a tecla '03H' foi premida?
	JNZ		fim_processa_tecla		; se nao foi, testa funcao seguinte	
	CALL	consulta_alarm3			; se foi chama funcao de consulta de alarme 3
	JMP		fim_processa_tecla
	
fim_processa_tecla:
	Ret
		
; *********************************
;		FUNÇAO CONSULTA_ALARM1
; DESCRIÇAO: Funcao que imprime o valor do alarme1 no campo do cronometro 
; PARAMETROS: --
; DEVOLVE: --
; DEPENDENCIAS: DESENHA_NUMERO, VARRIMENTO_TECLADO, DECIDE_SEGUNDOS
; DESTROI: --
; NOTA: --
consulta_alarm1:
	MOV		R1, ALARM1_HORAS_ESQ		; move com endereco
	MOVB	R0, [R1]					; retira valor do endereco
 	
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_MIN1				; onde desenhar
	CALL	desenha_numero				; chama funcao
	
	MOV		R1, ALARM1_HORAS_DIR		; move com endereco
	MOVB	R0, [R1]					; retira valor do endereco
	
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_MIN2				; onde desenhar
	CALL	desenha_numero				; chama funcao
	
	MOV		R1, ALARM1_MINUTOS_ESQ		; move com endereco
	MOVB	R0, [R1]					; retira valor do endereco
	
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_SEG1				; onde desenhar
	CALL	desenha_numero				; chama funcao
	
	MOV		R1, ALARM1_MINUTOS_DIR		; move com endereco
	MOVB	R0, [R1]					; retira valor do endereco
	
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_SEG2				; onde desenhar
	CALL	desenha_numero				; chama funcao

ciclo_consulta_alarm1:
	CALL	decide_segundos				; ciclo a espera de input, o relogio continua a contar 
	CALL	varrimento_teclado			; varre teclado
	
	MOV		R1, 0AH						; move com valor da tecla 
	CMP		R0, R1						; a tecla '0AH' foi premida?
	JZ		sai_consulta_alarm1			; se sim sai da consulta 
	
	MOV		R1, 01H						; move valor para o registo 
	CMP		R0, R1						; a tecla '01H' foi premida?
	JZ		activa_alarme1				; activa alarme
	
	MOV		R1, 02H						; move para registo
	CMP		R0, R1						; a tecla '02H' foi premida 
	JZ		tag_cons_al2				; consulta alarme 2
	
	MOV		R1, 03H						; move para registo
	CMP		R0, R1						; a tecla '03H' foi premida?
	JZ		tag_cons_al3				; consulta alarme 3 
	JMP		ciclo_consulta_alarm1		; nenhuma tecla premida, repete a espera de inputs 
	
tag_cons_al2:
	Call	consulta_alarm2				; chama funcao
	RET
	
tag_cons_al3:
	Call	consulta_alarm3				; chama funcao
	RET
	
activa_alarme1:
	MOV		R1, 1						; move 1 para registo 
	MOV		R0, FLAG_ALARM1				; move com o endereco 	
	MOVB	[R0], R1					; actualiza flag
	JMP		sai_consulta_alarm1			
	
	
sai_consulta_alarm1:
	MOV		R0, 0						; volta a desenhar zeros 
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_MIN1				; onde desenhar
	CALL	desenha_numero				; chama funcao
	
	MOV		R0, 0						; volta a desenhar zeros 
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_MIN2				; onde desenhar
	CALL	desenha_numero				; chama funcao

	MOV		R0, 0						; volta a desenhar zeros 
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_SEG1				; onde desenhar
	CALL	desenha_numero				; chama funcao

	MOV		R0, 0						; volta a desenhar zeros 
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_SEG2				; onde desenhar
	CALL	desenha_numero				; chama funcao
		
	RET
	
; *********************************
;		FUNÇAO CONSULTA_ALARM2
; DESCRIÇAO: Funcao que imprime o valor do alarme2 no campo do cronometro 
; PARAMETROS: --
; DEVOLVE: --
; DEPENDENCIAS: DESENHA_NUMERO, VARRIMENTO_TECLADO, DECIDE_SEGUNDOS
; DESTROI: --
; NOTA: --
consulta_alarm2:
	MOV		R1, ALARM2_HORAS_ESQ		; move com endereco
	MOVB	R0, [R1]					; retira valor do endereco
 	
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_MIN1				; onde desenhar
	CALL	desenha_numero				; chama funcao
	
	MOV		R1, ALARM2_HORAS_DIR		; move com endereco
	MOVB	R0, [R1]					; retira valor do endereco
	
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_MIN2				; onde desenhar
	CALL	desenha_numero				; chama funcao
	
	MOV		R1, ALARM2_MINUTOS_ESQ		; move com endereco
	MOVB	R0, [R1]					; retira valor do endereco
	
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_SEG1				; onde desenhar
	CALL	desenha_numero				; chama funcao
	
	MOV		R1, ALARM2_MINUTOS_DIR		; move com endereco
	MOVB	R0, [R1]					; retira valor do endereco
	
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_SEG2				; onde desenhar
	CALL	desenha_numero				; chama funcao

ciclo_consulta_alarm2:
	CALL	decide_segundos				; ciclo a espera de input, o relogio continua a contar 
	CALL	varrimento_teclado			; varre teclado
	
	MOV		R1, 0AH						; move com valor da tecla 
	CMP		R0, R1						; a tecla '0AH' foi premida?
	JZ		sai_consulta_alarm2			; se sim sai da consulta 
	
	MOV		R1, 01H						; move para registo
	CMP		R0, R1						; a tecla foi premida?
	JZ		tag_consulta_alarm1			; chama funcao 
	
	MOV		R1, 03H						; move para registo
	CMP		R0, R1						; a tecla foi premida?
	JZ		tag_consulta_alarm3			; chama funcao 
	
	MOV		R1, 02H						; move para registo
	CMP		R0, R1						; a tecla foi premida?
	JZ		activa_alarme2				; chama funcao
	JMP		ciclo_consulta_alarm2		; nenhuma tecla premida? repete para novo input 

tag_consulta_alarm1:	
	Call 	consulta_alarm1				; chama funcao 
	RET
	
tag_consulta_alarm3:
	Call	consulta_alarm3				; chama funcao 
	RET
	
activa_alarme2:
	MOV		R1, 1						; move para registo 
	MOV		R0, FLAG_ALARM2				; move com endereco 
	MOVB	[R0], R1					; atualiza flag 
	JMP		sai_consulta_alarm2			
	
sai_consulta_alarm2:
	MOV		R0, 0						; volta a desenhar zeros 
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_MIN1				; onde desenhar
	CALL	desenha_numero				; chama funcao
	
	MOV		R0, 0						; volta a desenhar zeros 
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_MIN2				; onde desenhar
	CALL	desenha_numero				; chama funcao

	MOV		R0, 0						; volta a desenhar zeros 
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_SEG1				; onde desenhar
	CALL	desenha_numero				; chama funcao

	MOV		R0, 0						; volta a desenhar zeros 
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_SEG2				; onde desenhar
	CALL	desenha_numero				; chama funcao
		
	RET
	
; *********************************
;		FUNÇAO CONSULTA_ALARM3
; DESCRIÇAO: Funcao que imprime o valor do alarme3 no campo do cronometro 
; PARAMETROS: --
; DEVOLVE: --
; DEPENDENCIAS: DESENHA_NUMERO, VARRIMENTO_TECLADO, DECIDE_SEGUNDOS
; DESTROI: --
; NOTA: --
consulta_alarm3:
	MOV		R1, ALARM3_HORAS_ESQ		; move com endereco
	MOVB	R0, [R1]					; retira valor do endereco
 	
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_MIN1				; onde desenhar
	CALL	desenha_numero				; chama funcao
	
	MOV		R1, ALARM3_HORAS_DIR		; move com endereco
	MOVB	R0, [R1]					; retira valor do endereco
	
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_MIN2				; onde desenhar
	CALL	desenha_numero				; chama funcao
	
	MOV		R1, ALARM3_MINUTOS_ESQ		; move com endereco
	MOVB	R0, [R1]					; retira valor do endereco
	
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_SEG1				; onde desenhar
	CALL	desenha_numero				; chama funcao
	
	MOV		R1, ALARM3_MINUTOS_DIR		; move com endereco
	MOVB	R0, [R1]					; retira valor do endereco
	
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_SEG2				; onde desenhar
	CALL	desenha_numero				; chama funcao

ciclo_consulta_alarm3:
	CALL	decide_segundos				; ciclo a espera de input, o relogio continua a contar 
	CALL	varrimento_teclado			; varre teclado
	
	MOV		R1, 0AH						; move com valor da tecla 
	CMP		R0, R1						; a tecla '0AH' foi premida?
	JZ		sai_consulta_alarm3			; se sim sai da consulta 
	
	MOV		R1, 01H						; move para registo
	CMP		R0, R1						; a tecla foi premida?
	JZ		tcal1						; chama funcao
	
	MOV		R1, 02H						; move para registo
	CMP		R0, R1						; a tecla foi premida?
	JZ	tcal2							; chama funcao
	
	MOV		R1, 03H						; move para registo
	CMP		R0, R1						; a tecla foi premida?
	JZ		activa_alarme3				; chama funcao
	JMP		ciclo_consulta_alarm3		; se nao repete para input valido
	
tcal1:
	Call 	consulta_alarm1				; chama funcao		<---------------------- ERRO!!!!!!
	RET	
	
tcal2:	
	Call consulta_alarm2				; chama funcao      <----------------------- ERRO!!!!!
	RET
	
activa_alarme3:
	MOV		R1, 1						; move para registo 
	MOV		R0, FLAG_ALARM3				; move com endereco 
	MOVB	[R0], R1					; atualiza flag
	JMP		sai_consulta_alarm3
	
sai_consulta_alarm3:
	MOV		R0, 0						; volta a desenhar zeros 
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_MIN1				; onde desenhar
	CALL	desenha_numero				; chama funcao
	
	MOV		R0, 0						; volta a desenhar zeros 
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_MIN2				; onde desenhar
	CALL	desenha_numero				; chama funcao

	MOV		R0, 0						; volta a desenhar zeros 
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_SEG1				; onde desenhar
	CALL	desenha_numero				; chama funcao

	MOV		R0, 0						; volta a desenhar zeros 
	MOV		R9, 1						; tamanho a desenhar
	MOV		R1, CRONO_SEG2				; onde desenhar
	CALL	desenha_numero				; chama funcao
		
	RET	

; *********************************
;		FUNÇAO ACERTA_RELOGIO
; DESCRIÇAO: Funcao que acerta o relogio. (segundos a zero)
; PARAMETROS: [SEGUNDOS], [MINUTOS], [HORAS] (ANTERIORES)
; DEVOLVE: [SEGUNDOS], [MINUTOS], [HORAS] (ACTUALIZADOS)
; DEPENDENCIAS: DESENHA_NUMERO
; DESTROI: --
; NOTA: --
acerta_relogio:
	DI1							;	Disable da interrupcao 1 															   		   
	DI0							;	Disable da interrupcao 0												   		   *		
	DI							;	Disable das interrupcoes 			
	
	MOV		R0, 00H				; valor para limpar os enderecos 
	MOV		R1, HORAS_ANT		; move com endereco
	MOVB	[R1], R0			; Coloca horas anteriores a '00H'
	MOV		R1, HORAS			; move com endereco
	MOVB	[R1], R0			; Coloca horas atualizadas a '00H'
	MOV		R1, MINUTOS_ANT		; move com endereco
	MOVB	[R1], R0			; Coloca minutos anteriores a '00H'
	MOV		R1, MINUTOS			; move com endereco
	MOVB	[R1], R0			; Coloca minutos atualizados a '00H'
	MOV		R1, SEGUNDOS_ANT	; move com endereco
	MOVB	[R1], R0			; Coloca segundos anteriores a '00H'
	MOV		R10, 0				; Coloca a contagem de impulsos de RTC a 0
	
	MOV		R0, 0				; o que desenhar 
	MOV		R9, 1				; que tamanho desenhar 
	MOV		R1, COORD_HORAS1	; desenha '0' na posicao 1 das horas
	Call	desenha_numero
	
	MOV		R0, 0				; o que desenhar 
	MOV		R9, 1				; que tamanho desenhar 
	MOV		R1, COORD_HORAS2	; desenha '0' na posicao 2 das horas
	Call	desenha_numero
	
	MOV		R0, 0				; o que desenhar 
	MOV		R9, 1				; que tamanho desenhar 
	MOV		R1, COORD_MIN1		; desenha '0' na posicao 1 dos minutos
	Call	desenha_numero
	
	MOV		R0, 0				; o que desenhar 
	MOV		R9, 1				; que tamanho desenhar 
	MOV		R1, COORD_MIN2		; desenha '0' na posicao 2 dos minutos
	Call	desenha_numero
	
	MOV		R0, 0				; o que desenhar 
	MOV		R9, 0				; que tamanho desenhar 
	MOV		R1, COORD_SEG1		; desenha '0' na posicao 1 dos segundos
	Call	desenha_numero
	
	MOV		R0, 0				; o que desenhar 
	MOV		R9, 0				; que tamanho desenhar 
	MOV		R1, COORD_SEG2		; desenha '0' na posicao 2 dos segundos
	Call	desenha_numero
	
acerta_horas_esq:
	MOV		R9, 10							; move para registo 
	CALL	varrimento_teclado				; varre o teclado a espera de input  
	CMP		R2, 0							; houve alguma tecla premida?
	JZ		acerta_horas_esq				; entao repete ciclo, a espera de input 
	CMP		R0, 03H							; so aceita 0, 1 ou 2 para o digito das horas
	JGE		acerta_horas_esq				; repete o ciclo
	
	MOV		R2, R0							; copia de registo 
	MUL		R2, R9							; *10 para inserir na memoria o digito das "dezenas" das horas
	
	MOV		R9, HORAS						; move com endereco 
	MOVB	R1, [R9]						; vai buscar do endereco 
	ADD		R1, R2							; soma e
	MOVB	[R9], R1						; repoe
	
	MOV		R1, COORD_HORAS1				; onde desenhar 
	MOV		R9, 1							; que tamanho desenhar 
	MOV		R4, R0							; R0 e destruido no desenha numero R4, não (copia do valor de R0)
	CALL	desenha_numero					; chama funcao 	
	
	MOV		R0, R4 							; copia de R4 para repor R0 
	CMP		R0, 02H							; o input foi 2?
	JZ		acerta_horas_direita_se2		; entao chama funcao 	
	
acerta_horas_direita_nao2:
	CALL	varrimento_teclado				; varre o teclado 
	CMP		R2, 0							; n ha tecla premida
	JZ		acerta_horas_direita_nao2		; repete ciclo a espera de input 
	MOV		R1, 0AH							; se o 1º digito é 2 entao, aceitam se valores de '0' ate '9'
	CMP		R0, R1							
	JGE		acerta_horas_direita_nao2		; se >= '0AH' repete ate ter input valido 
	JMP	    acerta_horas_dir				
	
acerta_horas_direita_se2:
	CALL	varrimento_teclado				; varre o teclado 
	CMP		R2, 0							; n ha tecla premida
	JZ		acerta_horas_direita_se2		; repete ate haver input 
	MOV		R1, 04H							
	CMP		R0, R1							; so aceita 0, 1, 2 ou 3 para o digito da direita das horas
	JGE		acerta_horas_direita_se2		; Se >= 4 repete ate haver input valido 

acerta_horas_dir:
	MOV		R2, R0							; copia de registo 
	
	MOV		R9, HORAS						; move com endereço 
	MOVB	R1, [R9]						; vai buscar do endereco 
	ADD		R1, R2							; soma 
	MOVB	[R9], R1						; repoe na memoria 
	
	MOV		R1, COORD_HORAS2				; onde desenhar
	MOV		R9, 1							; que tamanha desenhar 
	CALL	desenha_numero					; chama a funcao 

acerta_min_esq:
	MOV		R9, 10							; move para registo 
	CALL	varrimento_teclado				; varre o teclado 
	CMP		R2, 0							; houve tecla premida?
	JZ		acerta_min_esq					; se nao houve repete ate haver 
	CMP		R0, 06H							
	JGE		acerta_min_esq					; input valido: <=5
	
	MOV		R2, R0							; copia de registo 				
	MUL		R2, R9							; *10 para inserir na memoria o digito das "dezenas" dos minutos
	
	MOV		R9, MINUTOS						; move com endereco 
	MOVB	R1, [R9]						; vai buscar da memoria 
	ADD		R1, R2							; soma 
	MOVB	[R9], R1						; e repoe 	
	
	MOV		R1, COORD_MIN1					; onde desenhar 
	MOV		R9, 1							; que tamanho desenhar 
	CALL	desenha_numero					; chama funcao 
	
acerta_min_dir:
	MOV		R9, 10							; move para registo 
	CALL	varrimento_teclado				; varre teclado
	CMP		R2, 0							; houve alguma tecla premida?
	JZ		acerta_min_dir					; entao repete ate haver 
	MOV		R2, 0AH							; move para registo 
	CMP		R0, R2 							; input valido?
	JGE		acerta_min_dir					; input valido: <= '0AH'
	
	MOV		R2, R0							; copia de registo 

	
	MOV		R9, MINUTOS						; move com endereco 
	MOVB	R1, [R9]						; vai buscar da memoria 
	ADD		R1, R2							; soma 
	MOVB	[R9], R1						; repoe 
	
	MOV		R1, COORD_MIN2					; onde desenhar 
	MOV		R9, 1							; que tamanho desenhar 
	
	CALL	desenha_numero					; chama funcao 

fim_acerta:
	CALL	varrimento_teclado				; varre teclado 
	MOV		R1, TECLA_ACERTO_REL			; move com '0AH'
	CMP		R0, R1							; a tecla premida foi '0AH'?
	JNZ		fim_acerta						; entao repete ate ser 
	
	EI0										; enable da interrupcao 0
	EI										; enable das interrupcoes 
	RET
; *********************************
;		FUNÇAO DISABLE
; DESCRIÇAO: Funcao para e reinicia o relógio  
; PARAMETROS: [SEGUNDOS], [MINUTOS], [HORAS] (ANTERIORES)
; DEVOLVE: [SEGUNDOS], [MINUTOS], [HORAS] (ACTUALIZADOS)
; DEPENDENCIAS: DESENHA_NUMERO
; DESTROI: R0, R1, R2, R7, R8, R9
; NOTA: --

disable:
	DI1								;	Disable da interrupcao 1
	DI0								;	Disable da interrupcao 0
	DI								;	Disable das interrupcoes
	
	MOV		R0, 00H					; valor para reiniciar o clock
	
	MOV		R1, HORAS_ANT			; move com o endereco
	MOVB	[R1], R0				; limpa
	
	MOV		R1, HORAS				; move com o endereco
	MOVB	[R1], R0				; limpa
	
	MOV		R1, MINUTOS_ANT			; move com o endereco
	MOVB	[R1], R0				; limpa
	
	MOV		R1, MINUTOS				; move com o endereco
	MOVB	[R1], R0				; limpa
	
	MOV		R1, SEGUNDOS_ANT		; move com o endereco
	MOVB	[R1], R0				; limpa
	MOV		R10, 0					; reinicia a contagem de impulsos RTC
	
	MOV		R0, 0					; numero a desenhar 
	MOV		R9, 1					; desenha numero grande
	MOV		R1, COORD_HORAS1		; onde desenhar 
	Call	desenha_numero			; chama funcao
	
	MOV		R0, 0					; numero a desenhar 
	MOV		R9, 1					; desenha numero grande
	MOV		R1, COORD_HORAS2		; onde desenhar 
	Call	desenha_numero			; chama funcao
	
	MOV		R0, 0					; numero a desenhar 
	MOV		R9, 1					; desenha numero grande
	MOV		R1, COORD_MIN1			; onde desenhar 
	Call	desenha_numero			; chama funcao
		
	MOV		R0, 0					; numero a desenhar 
	MOV		R9, 1					; desenha numero grande
	MOV		R1, COORD_MIN2			; onde desenhar 
	Call	desenha_numero			; chama funcao
	
	MOV		R0, 0					; numero a desenhar 
	MOV		R9, 0					; desenha numero grande
	MOV		R1, COORD_SEG1			; onde desenhar 
	Call	desenha_numero			; chama funcao
	
	MOV		R0, 0					; numero a desenhar 
	MOV		R9, 0					; desenha numero grande
	MOV		R1, COORD_SEG2			; onde desenhar 
	Call	desenha_numero			; chama funcao
	
	Ret	

; *********************************
;		FUNÇAO PROGRAMA_ALARME
; DESCRIÇAO: Funcao que programa um alarme
; PARAMETROS: --
; DEVOLVE: --
; DEPENDENCIAS: --
; DESTROI: --
; NOTA: --
prog_alarm:
	CALL	decide_segundos			; rotina esta a espera de input do utilizador tem de continuar a contar o tempo de relogio
	CALL	varrimento_teclado		; varre o teclado a espera de input 
	
	CMP		R0, 1H					; a tecla premida foi a tecla '1'?
	JZ		testa_alarm1			; entao chama a funcao 
	
	CMP		R0, 2H					; a tecla premida foi a tecla '2'?
	JZ		testa_alarm2			; entao chama a funcao 
	
	CMP		R0, 3H					; a tecla premida foi a tecla '3'?
	JZ		testa_alarm3			; entao chama a funcao
	
	JMP		prog_alarm				; se nao houver teclas premidas, repete a espera de input

testa_alarm1:
	CALL	prog_alarm1				; chama funcao
	RET								; volta ao processa_tecla a espera de mais inputs
	
testa_alarm2:
	CALL	prog_alarm2				; chama funcao
	RET								; volta ao processa_tecla a espera de mais inputs 
	
testa_alarm3:
	CALL	prog_alarm3				; chama funcao
	RET								; volta ao processa_tecla a espera de mais inputs 
	
; *********************************
;		FUNÇAO PROGRAMA_ALARME3
; DESCRIÇAO: Funcao que programa o alarme 3
; PARAMETROS: --
; DEVOLVE: --
; DEPENDENCIAS: --
; DESTROI: --
; NOTA: --
prog_alarm3:
	MOV		R0, 00H							; valor para limpar as posicoes de memoria 
	MOV		R1, ALARM3_HORAS
	MOVB	[R1], R0						; Coloca endereco das horas do alarme 1 a '00H' (limpa)
	MOV		R1, ALARM3_MINUTOS
	MOVB	[R1], R0						; Coloca endereco dos minutos do alarme 1 a '00H' (limpa)

alarm3_horas_esq:
	CALL	decide_segundos
	MOV		R9, 10
	CALL	varrimento_teclado				 
	CMP		R2, 0							
	JZ		alarm3_horas_esq				
	CMP		R0, 03H							 
	JGE		alarm3_horas_esq				 
	
	MOV		R3, ALARM3_HORAS_ESQ
	MOV		R2, R0 
	MOVB	[R3], R2
	MUL		R2, R9
	
	MOV		R9, ALARM3_HORAS
	MOVB	R1, [R9]
	ADD		R1, R2
	MOVB	[R9], R1
	
	MOV		R1, CRONO_MIN1
	MOV		R9, 1
	MOV		R4, R0							; R0 e destruido no desenha numero R4, não (copia do valor de R0)
	CALL	desenha_numero
	
	MOV		R0, R4 							; copia de R4 para repor R0 
	CMP		R0, 02H							
	JZ		alarm3_horas_dir_se2			
	
alarm3_horas_dir_nao2:
	CALL	decide_segundos
	CALL	varrimento_teclado				; varre o teclado 
	CMP		R2, 0							; n ha tecla premida
	JZ		alarm3_horas_dir_nao2		
	MOV		R1, 0AH							
	CMP		R0, R1							
	JGE		alarm3_horas_dir_nao2
	JMP	    alarm3_horas_dir
	
	
alarm3_horas_dir_se2:
	CALL	decide_segundos
	CALL	varrimento_teclado				; varre o teclado 
	CMP		R2, 0							; n ha tecla premida
	JZ		alarm3_horas_dir_se2		
	MOV		R1, 04H							
	CMP		R0, R1							; so aceita 0, 1, 2 ou 3 para o digito da direita das horas
	JGE		alarm3_horas_dir_se2
	
alarm3_horas_dir:
	MOV		R3, ALARM3_HORAS_DIR
	MOV		R2, R0
	MOVB	[R3], R2
	
	MOV		R9, ALARM3_HORAS
	MOVB	R1, [R9]
	ADD		R1, R2
	MOVB	[R9], R1
	
	MOV		R1, CRONO_MIN2
	MOV		R9, 1
	CALL	desenha_numero

alarm3_min_esq:
	CALL	decide_segundos
	CALL	varrimento_teclado				 
	CMP		R2, 0							
	JZ		alarm3_min_esq				
	CMP		R0, 06H							
	JGE		alarm3_min_esq					
	
	MOV		R9, 10
	MOV		R3, ALARM3_MINUTOS_ESQ
	MOV		R2, R0
	MOVB	[R3], R2
	MUL		R2, R9
	
	MOV		R9, ALARM3_MINUTOS
	MOVB	R1, [R9]
	ADD		R1, R2
	MOVB	[R9], R1
	
	MOV		R1, CRONO_SEG1					
	MOV		R9, 1
	
	CALL	desenha_numero		
	
alarm3_min_dir:
	MOV		R9, 10
	CALL	decide_segundos
	CALL	varrimento_teclado				 
	CMP		R2, 0							
	JZ		alarm3_min_dir
	MOV		R2, 0AH
	CMP		R0, R2 							
	JGE		alarm3_min_dir					
	
	MOV		R3, ALARM3_MINUTOS_DIR
	MOV		R2, R0
	MOVB	[R3], R2
	
	MOV		R9, ALARM3_MINUTOS
	MOVB	R1, [R9]
	ADD		R1, R2
	MOVB	[R9], R1
	
	MOV		R1, CRONO_SEG2
	MOV		R9, 1
	
	CALL	desenha_numero	
	
fim_alarm3:
	CALL	decide_segundos
	CALL	varrimento_teclado
	
	MOV		R1, TECLA_PROG_ALARM
	CMP		R0, R1
	JZ		desenha_0s_crono_alarm3
	
	MOV		R1, TECLA_ALARM3
	CMP		R0, R1
	JZ		activa_alarm3
	JMP		fim_alarm3 
	
activa_alarm3:
	MOV		R1, 1 
	MOV		R0, FLAG_ALARM3
	MOVB	[R0], R1
	
desenha_0s_crono_alarm3:
	MOV		R0, 0
	MOV		R9, 1
	MOV		R1, CRONO_MIN1
	Call	desenha_numero
	
	MOV		R0, 0
	MOV		R9, 1
	MOV		R1, CRONO_MIN2
	Call	desenha_numero
	
	MOV		R0, 0
	MOV		R9, 1
	MOV		R1, CRONO_SEG1
	Call	desenha_numero
	
	MOV		R0, 0
	MOV		R9, 1
	MOV		R1, CRONO_SEG2
	Call	desenha_numero



	RET
	
; *********************************
;		FUNÇAO PROGRAMA_ALARME2
; DESCRIÇAO: Funcao que programa o alarme 2
; PARAMETROS: --
; DEVOLVE: --
; DEPENDENCIAS: --
; DESTROI: --
; NOTA: --

prog_alarm2:
	MOV		R0, 00H				; valor para limpar as posicoes de memoria 
	MOV		R1, ALARM2_HORAS
	MOVB	[R1], R0			; Coloca endereco das horas do alarme 1 a '00H' (limpa)
	MOV		R1, ALARM2_MINUTOS
	MOVB	[R1], R0			; Coloca endereco dos minutos do alarme 1 a '00H' (limpa)

alarm2_horas_esq:
	CALL	decide_segundos
	MOV		R9, 10
	CALL	varrimento_teclado				 
	CMP		R2, 0							
	JZ		alarm2_horas_esq				
	CMP		R0, 03H							
	JGE		alarm2_horas_esq				 
	
	MOV		R3, ALARM2_HORAS_ESQ
	MOV		R2, R0
	MOVB	[R3], R2
	MUL		R2, R9
	
	MOV		R9, ALARM2_HORAS
	MOVB	R1, [R9]
	ADD		R1, R2
	MOVB	[R9], R1
	
	MOV		R1, CRONO_MIN1
	MOV		R9, 1
	MOV		R4, R0							; R0 e destruido no desenha numero R4, não (copia do valor de R0)
	CALL	desenha_numero
	
	MOV		R0, R4 							; copia de R4 para repor R0 
	CMP		R0, 02H							;
	JZ		alarm2_horas_dir_se2				
	
alarm2_horas_dir_nao2:
	CALL	decide_segundos
	CALL	varrimento_teclado				; varre o teclado 
	CMP		R2, 0							; n ha tecla premida
	JZ		alarm2_horas_dir_nao2		
	MOV		R1, 0AH							
	CMP		R0, R1							
	JGE		alarm2_horas_dir_nao2
	JMP	    alarm2_horas_dir
	
	
alarm2_horas_dir_se2:
	CALL	decide_segundos
	CALL	varrimento_teclado				; varre o teclado 
	CMP		R2, 0							; n ha tecla premida
	JZ		alarm2_horas_dir_se2		
	MOV		R1, 04H							
	CMP		R0, R1							; so aceita 0, 1, 2 ou 3 para o digito da direita das horas
	JGE		alarm2_horas_dir_se2
	
alarm2_horas_dir:
	MOV		R3, ALARM2_HORAS_DIR
	MOV		R2, R0
	MOVB	[R3], R2
	
	MOV		R9, ALARM2_HORAS
	MOVB	R1, [R9]
	ADD		R1, R2
	MOVB	[R9], R1
	
	MOV		R1, CRONO_MIN2
	MOV		R9, 1
	CALL	desenha_numero

alarm2_min_esq:
	CALL	decide_segundos
	CALL	varrimento_teclado				 
	CMP		R2, 0							
	JZ		alarm2_min_esq				
	CMP		R0, 06H							
	JGE		alarm2_min_esq					
	
	MOV  	R3, ALARM2_MINUTOS_ESQ
	MOV		R9, 10
	MOV		R2, R0
	MOVB	[R3], R2
	MUL		R2, R9
	
	MOV		R9, ALARM2_MINUTOS
	MOVB	R1, [R9]
	ADD		R1, R2
	MOVB	[R9], R1
	
	MOV		R1, CRONO_SEG1					
	MOV		R9, 1
	
	CALL	desenha_numero		
	
alarm2_min_dir:
	MOV		R9, 10
	CALL	decide_segundos
	CALL	varrimento_teclado				 
	CMP		R2, 0							
	JZ		alarm2_min_dir
	MOV		R2, 0AH
	CMP		R0, R2 							
	JGE		alarm2_min_dir					
	
	MOV		R3, ALARM2_MINUTOS_DIR
	MOV		R2, R0
	MOVB	[R3], R2

	
	MOV		R9, ALARM2_MINUTOS
	MOVB	R1, [R9]
	ADD		R1, R2
	MOVB	[R9], R1
	
	MOV		R1, CRONO_SEG2
	MOV		R9, 1
	
	CALL	desenha_numero	
	
fim_alarm2:
	CALL	decide_segundos
	CALL	varrimento_teclado
	
	MOV		R1, TECLA_PROG_ALARM
	CMP		R0, R1
	JZ		desenha_0s_crono_alarm2
	
	MOV		R1, TECLA_ALARM2
	CMP		R0, R1
	JZ		activa_alarm2
	JMP		fim_alarm2

activa_alarm2:
	MOV		R1, 1 
	MOV		R0, FLAG_ALARM2
	MOVB	[R0], R1

	
desenha_0s_crono_alarm2:
	MOV		R0, 0
	MOV		R9, 1
	MOV		R1, CRONO_MIN1
	Call	desenha_numero
	
	MOV		R0, 0
	MOV		R9, 1
	MOV		R1, CRONO_MIN2
	Call	desenha_numero
	
	MOV		R0, 0
	MOV		R9, 1
	MOV		R1, CRONO_SEG1
	Call	desenha_numero
	
	MOV		R0, 0
	MOV		R9, 1
	MOV		R1, CRONO_SEG2
	Call	desenha_numero



	RET

; *********************************
;		FUNÇAO PROGRAMA_ALARME1
; DESCRIÇAO: Funcao que programa o alarme 1
; PARAMETROS: --
; DEVOLVE: [ALARM1_HORAS_ESQ], [ALARM1_HORAS_DIR], [ALARM1_MINUTOS_ESQ], [ALARM1_MINUTOS_DIR]
; DEPENDENCIAS: VARRIMENTO_TECLADO, DECIDE_SEGUNDOS, DESENHA_NUMERO
; DESTROI: --
; NOTA: --
prog_alarm1:
	MOV		R0, 00H							; valor para limpar as posicoes de memoria 
	MOV		R1, ALARM1_HORAS
	MOVB	[R1], R0						; Coloca endereco das horas do alarme 1 a '00H' (limpa)
	MOV		R1, ALARM1_MINUTOS
	MOVB	[R1], R0						; Coloca endereco dos minutos do alarme 1 a '00H' (limpa)

alarm1_horas_esq:
	CALL	decide_segundos					; rotina esta a espera de input do utilizador tem de continuar a contar o tempo de relogio
	MOV		R9, 10							; para a multiplicacao que se segue (colocar valor na memoria)
	CALL	varrimento_teclado				; varre o teclado 
	CMP		R2, 0							; Alguma tecla premida?
	JZ		alarm1_horas_esq				; Se não repete ciclo a espera de input 
	CMP		R0, 03H							; para o 1º digito das horas, nao se aceita valores >=3
	JGE		alarm1_horas_esq				; greater or equal than '03H'
	
	MOV		R3, ALARM1_HORAS_ESQ			; solucao encontrada para contornar descodificacao do numero na memoria 
	MOV		R2, R0							; copia para o R2
	MOVB	[R3], R2						; copia da tecla premida para a memoria que mantem o digito intacto e sozinho
	MUL		R2, R9							; multiplicacao por 10 para inserir o digito das "dezenas" (referente as horas) na memoria 
	
	MOV		R9, ALARM1_HORAS				 
	MOVB	R1, [R9]						
	ADD		R1, R2							; soma ao registo e
	MOVB	[R9], R1						; coloca o digito das "dezenas" na memória
	
	MOV		R1, CRONO_MIN1					; desenha o digito correspondente a tecla premida na posicao correspondente
	MOV		R9, 1							; numero grande (parametros da rotina desenha_numero)
	MOV		R4, R0							; R0 e destruido no desenha numero R4, não (copia do valor de R0)
	CALL	desenha_numero					; chama rotina para desenhar 
	
	MOV		R0, R4 							; copia de R4 para repor R0 
	CMP		R0, 02H							
	JZ		alarm1_horas_dir_se2			
	
alarm1_horas_dir_nao2:
	CALL	decide_segundos					; rotina esta a espera de input do utilizador tem de continuar a contar o tempo de relogio
	CALL	varrimento_teclado				; varre o teclado a espera de input 
	CMP		R2, 0							; n ha tecla premida?
	JZ		alarm1_horas_dir_nao2			; se não repete ciclo a espera de input 
	MOV		R1, 0AH							
	CMP		R0, R1							; se o digito da esquerda nao foi 2 entao aceita-se valores desde '00H' até '09H'
	JGE		alarm1_horas_dir_nao2			; greater or equal than '0AH' 
	JMP	    alarm1_horas_dir				; se for >= '0AH' repete ciclo a espera de input valido 
	
	
alarm1_horas_dir_se2:
	CALL	decide_segundos					; rotina esta a espera de input do utilizador tem de continuar a contar o tempo de relogio
	CALL	varrimento_teclado				; varre o teclado a espera de input 
	CMP		R2, 0							; n ha tecla premida?
	JZ		alarm1_horas_dir_se2			; se não repete ciclo a espera de input
	MOV		R1, 04H							
	CMP		R0, R1							; como o digito da esquerda foi 2 entao apenas se aceita-se valores desde '00H' até '03H'
	JGE		alarm1_horas_dir_se2			; greater or equal than '0AH' 
	
alarm1_horas_dir:
	MOV		R3, ALARM1_HORAS_DIR			; mover R3 com endereco 
	MOV		R2, R0							; copia para R2 
	MOVB	[R3], R2						; guarda na memoria 
	
	MOV		R9, ALARM1_HORAS				; move R9 com endereco 
	MOVB	R1, [R9]						; tras da memoria o que ja la foi posto
	ADD		R1, R2							; e (agora como é o digito da direita ou das 'unidades') apenas soma
	MOVB	[R9], R1						; coloca na memória 
	
	MOV		R1, CRONO_MIN2					; desenha o digito correspondente a tecla premida na posicao correspondente
	MOV		R9, 1							; numero grande (parametros da rotina desenha_numero)
	CALL	desenha_numero					; chama rotina para desenhar 

alarm1_min_esq:
	CALL	decide_segundos
	CALL	varrimento_teclado				 
	CMP		R2, 0							
	JZ		alarm1_min_esq				
	CMP		R0, 06H							
	JGE		alarm1_min_esq					
	
	MOV		R3, ALARM1_MINUTOS_ESQ
	MOV		R9, 10
	MOV		R2, R0
	MOVB	[R3], R2
	MUL		R2, R9
	
	MOV		R9, ALARM1_MINUTOS
	MOVB	R1, [R9]
	ADD		R1, R2
	MOVB	[R9], R1
	
	MOV		R1, CRONO_SEG1					
	MOV		R9, 1
	
	CALL	desenha_numero		
	
alarm1_min_dir:
	MOV		R9, 10
	CALL	decide_segundos
	CALL	varrimento_teclado				 
	CMP		R2, 0							
	JZ		alarm1_min_dir
	MOV		R2, 0AH
	CMP		R0, R2 							
	JGE		alarm1_min_dir					
	
	MOV		R3, ALARM1_MINUTOS_DIR
	MOV		R2, R0
	MOVB	[R3], R2
	
	MOV		R9, ALARM1_MINUTOS
	MOVB	R1, [R9]
	ADD		R1, R2
	MOVB	[R9], R1
	
	MOV		R1, CRONO_SEG2
	MOV		R9, 1
	
	CALL	desenha_numero	
	
fim_alarm1:
	CALL	decide_segundos
	CALL	varrimento_teclado
	
	MOV		R1, TECLA_PROG_ALARM
	CMP		R0, R1
	JZ		desenha_0s_crono_alarm1
	
	MOV		R1, TECLA_ALARM1
	CMP		R0, R1
	JZ		activa_alarm1
	JMP		fim_alarm1
	
activa_alarm1:
	MOV		R1, 1 
	MOV		R0, FLAG_ALARM1
	MOVB	[R0], R1	

desenha_0s_crono_alarm1:
	MOV		R0, 0
	MOV		R9, 1
	MOV		R1, CRONO_MIN1
	Call	desenha_numero
	
	MOV		R0, 0
	MOV		R9, 1
	MOV		R1, CRONO_MIN2
	Call	desenha_numero
	
	MOV		R0, 0
	MOV		R9, 1
	MOV		R1, CRONO_SEG1
	Call	desenha_numero
	
	MOV		R0, 0
	MOV		R9, 1
	MOV		R1, CRONO_SEG2
	Call	desenha_numero

	RET
	
; *********************************
;		FUNÇAO VARRIMENTO_TECLADO
; DESCRIÇAO: Funcao que varre o teclado, localiza e calcula a tecla premida
; PARAMETROS: --
; DEVOLVE: R2 - 0 se nao houver alteracoes na tecla premida, 1 - caso contrario , [BUFFERN] (ou R0)- valor da tecla premida
; DEPENDENCIAS: --
; DESTROI: R3, R1, R0
; NOTA: --

varrimento_teclado:
; inicializações gerais
	MOV		R1, LINHA			; Teste da linha 1 
	MOV		R2, KEYPADINOUT		; R2 com o endereço do periférico
	MOV 	R0, 10H				; condicao de paragem 
	
; corpo principal do programa
cvarrimento_teclado:
	MOV		R2, KEYPADINOUT		; R2 com o endereço do periférico
	MOVB	[R2], R1			; Escrever no porto de saida
	MOVB	R3, [R2]			; Ler do porto de entrada
	MOV		R2, 000FH			; mascara isolar bits do porto(0-3) 
	AND		R3, R2				; Afectar as flags
	JZ		testanovalinha		; Nenhuma tecla premida entao testa-se uma nova linha
	JMP		calcula_numero		; 

testanovalinha:
	SHL		R1, 1				; nova linha a testar   
	CMP		R1, R0				; "                "
	JNZ		cvarrimento_teclado	; proxima linha a testar 
	MOV		R0, NENHUMA_TECLA	; nenhuma tecla premida 
	JMP		mostrar				; 

calcula_numero:
	MOV		R0, 0				
calcula_linha:
	SHR		R1, 1				
	JC		calcula_coluna		
	ADD		R0, 4				
	JMP 	calcula_linha		
calcula_coluna:
	SHR		R3, 1				
	JC		mostrar				
	ADD		R0, 1				
	JMP		calcula_coluna		
	
mostrar:
	MOV		R1, BUFFERN			
	MOVB	R2, [R1]			
	CMP		R2, R0				
	JZ		tecla_igual			
	MOVB	[R1], R0			
	MOV		R2, 1				; Houve alteracoes (nova tecla premida)
    JMP		fim_varrimento		
	
tecla_igual:
	MOV		R2, 0				; Nao houve alteracoes
	
fim_varrimento:
	RET

; *********************************
;		FUNÇAO LIMPA_PIXEL_SCREEN
; DESCRIÇAO: Funcao que varre o pixel screen e preenche com 0000H todos os bytes encontrados
; PARAMETROS: --
; DEVOLVE: --
; DEPENDENCIAS: --
; DESTROI: R1-R3
; NOTA: --

limpa_vidros:

	PUSH	R1
	PUSH	R2
	PUSH	R3
	
	MOV		R1, PXMIN
	MOV		R3, PXMAX
	ADD		R3, 1

ciclo_limpa:
	MOV 	R2, 0000H 		; Limpeza ao PIXELSCREEN
	MOVB	[R1], R2		; Mover 0's para o 1º endereco do PIXELSCREEN
	ADD		R1, 1			; Se nao estivermos no endereco final passamos para o endereco a seguir e repete-se o ciclo
	CMP		R3, R1			; Compere para verificar se ja nos econtramos no endereco final 
	JNZ		ciclo_limpa		; Chegamos ao endereco final podemos fazer Return da rotina

	POP		R3
	POP		R2
	POP		R1
	RET	
	
; *********************************
;		FUNÇAO DESENHA_DOIS_PONTOS
; DESCRIÇAO: Funcao que calcula a posicao e desenha os dois pontos do relogio e cornometro
; PARAMETROS: --
; DEVOLVE: --
; DEPENDENCIAS: --
; DESTROI: R2
; NOTA: Esta funcao e a primeira funcao de desenho no pixel screen de maneira a que os desenhos 
;		se mantenham coerentes com as mascaras dos numeros

dois_pontos:

	PUSH R1
	PUSH R2
	
	MOV		R1, PXMIN
	MOV		R2, 16					
	ADD		R1, 1				; Escrever no 2º byte
	ADD		R1, R2				; Calculo da coordenada y
	MOV		R2, 20H				; Marca do 1º ponto
	MOVB	[R1], R2			; Desenha o 1º ponto no PIXELSCREEN
	ADD		R1, 1				; Escrever no 3º byte
	MOV		R2, 02H				
	MOVB	[R1], R2			; Desenha o 2º ponto no PIXELSCREEN
	SUB		R1, 1				; Posição do 3º ponto
	MOV		R2, 8
	ADD		R1, R2
	MOV		R2, 20H
	MOVB	[R1], R2
	ADD		R1, 1				; Escrever no 3º byte
	MOV		R2, 02H				; 
	MOVB	[R1], R2
	SUB		R1, 1
	MOV		R2, 48
	ADD		R1, R2
	MOV		R2, 20H				; Marca do 1º ponto
	MOVB	[R1], R2			; Desenha o 1º ponto no PIXELSCREEN
	MOV		R2, 8
	MOV		R3, R2
	ADD		R1, R2				; Escrever no 3º byte
	MOV		R2, 20H				
	MOVB	[R1], R2			; Desenha o 2º ponto no PIXELSCREEN
	ADD		R1, 2				; move para o 4º byte
	MOV		R2, 0CH				; mov R2 com 8 para descer mais duas linhas
	ADD		R1, R2				
	MOV		R2, 0A8H
	MOVB	[R1], R2		
	
	POP R2
	POP	R1
	RET	
	
; *********************************
;		FUNÇAO DESENHA_NUMERO
; DESCRIÇAO: Funcao que calcula o byte em que se desenha o numero dado por parametro
; PARAMETROS: R0 - Numero a desenhar, R1 - Posicao a desenhar (LLCC), R9 - Tamanho do desenho que vai ser feito (0 - pequeno ou 1 - grande)
; DEVOLVE: --
; DEPENDENCIAS: CONVERTE_NUMERO
; DESTROI: R0-R3, R6, R9
; NOTA: --

desenha_numero:
	PUSH    R4
	PUSH    R5
	PUSH	R7
	PUSH    R8
	
	Call	converte_numero	
	MOV 	R2, PXMIN
	MOV		R3, R1
	SHR		R1, 8			; isolar a linha 
	SHL		R3, 8			; isolar a coluna
	SHR		R3, 8			
	
	MOV		R4, 4
	MUL 	R1, R4
	ADD		R2, R1
	
	MOV		R4, 8
	MOV		R1, R3
	DIV		R1, R4
	
	MOD		R3, R4
	ADD		R2, R1
	MOV		R8, 3
	PUSH	R0
	Push	R3
	
	CMP		R9, 0
	JNZ		isgrande
	MOV		R7, 3
	JMP		ciclo_desenho
isgrande:
	MOV		R7, 4
	
ciclo_desenho:
	POP		R3
	MOV		R1, R3
	POP		R0
	MOVB	R4, [R0]
	ADD		R0, 1
	MOVB	R5, [R0]
	ADD		R0, 1
	MOVB	R6, [R0]
	ADD		R0, 1
	PUSH	R0
	PUSH	R3
	MOV		R3, 0
	CMP		R9, 0
	JZ		desenha_pequeno
	MOV		R0, maskG			; Aplicacao da mascara
	JMP		coloca_bit

desenha_pequeno:
	MOV		R0, maskP

coloca_bit:
	CMP		R1, 0
	JZ		desenha_3_linhas
	ROR		R4, 1
	ROR		R5, 1
	ROR		R6, 1
	ROR		R0, 1
	JC		nao_tem_byte_extra
	MOV		R3, 1
nao_tem_byte_extra:
	SUB		R1, 1
	JMP	coloca_bit
	
desenha_3_linhas:
	
	MOVB	R1, [R2]
	AND		R1, R0
	OR		R1, R4
	MOVB 	[R2], R1
	CMP		R3, 1
	JNZ		salta_desenho_1
	
	ADD		R2, 1
	MOVB	R1, [R2]
	ROR		R0, 8
	ROR		R4, 8
	AND		R1, R0
	OR		R1, R4
	MOVB 	[R2], R1
	SUB		R2, 1
	ROR		R0, 8
	
salta_desenho_1:	
	ADD		R2, 4
	SUB		R7, 1
	CMP		R7, 0
	JZ		fim_ciclo_desenho
	
	MOVB	R1, [R2]
	AND		R1, R0
	OR		R1, R5
	MOVB 	[R2], R1
	
	CMP		R3, 1
	JNZ		salta_desenho_2
	
	ADD		R2, 1
	MOVB	R1, [R2]
	ROR		R0, 8
	ROR		R5, 8
	AND		R1, R0
	OR		R1, R5
	MOVB 	[R2], R1
	SUB		R2, 1
	ROR		R0, 8
	
salta_desenho_2:
	ADD		R2, 4
	
	
	MOVB	R1, [R2]
	AND		R1, R0
	OR		R1, R6
	MOVB 	[R2], R1
	
	CMP		R3, 1
	JNZ		salta_desenho_3
	
	ADD		R2, 1
	MOVB	R1, [R2]
	ROR		R0, 8
	ROR		R6, 8
	AND		R1, R0
	OR		R1, R6
	MOVB 	[R2], R1
	SUB		R2, 1
	ROR		R0, 8
	
salta_desenho_3:
	ADD		R2, 4
	SUB 	R8, 1
	CMP		R8, 0
	JNZ		ciclo_desenho
fim_ciclo_desenho:
	POP		R3
	POP		R0
	POP		R8
	POP 	R7
	POP		R5
	POP		R4
	
	RET
	
; *********************************
;		FUNÇAO CONVERTE_NUMERO
; DESCRIÇAO: Funcao que converte um numero contido num registo numa posicao da tabela correspondente a esse numero 
; PARAMETROS: R0, R9
; DEVOLVE: R0
; DEPENDENCIAS: --
; DESTROI: --
; NOTA: --

converte_numero:
	CMP		R9, 0					; o argumento da funcao desenha numero e 0? (e um numero pequeno ou grande?)
	JZ	converte_numero_pequeno		; se for reencaminha para converter para numero pequeno caso contrario continua
	MOV		R5, numeroG_0			; move R5 com a primeira posicao da tabela para os numeros grandes  
	MOV		R9, 9					; registo auxiliar com o numero de elementos da tabela 9 para numeros grandes 7 caso contrario
	MUL		R0, R9					; multiplicacao do numero a desenhar*n. das posicoes que esse numero ocupa
	ADD		R5, R0					; adicionar ao inicio da tabela
	MOV		R0, R5					; repor no R0 registo que serve de argumento para a rotina desenha_numero
	MOV		R9, 1					; mov R9 com 1, registo que serve de argumento para a rotina desenha_numero  
	JMP		fim_converte_numero		; tag com Ret que volta a funcao desenha_numero ja com os argumentos correctos a desenhar
	
converte_numero_pequeno:
	MOV		R5, numeroP_0			; move R5 com a primeira posicao da tabela para os numeros pequenos	
	MOV		R9, 7					; registo auxiliar com o numero de elementos da tabela 9 para numeros grandes 7 caso contrario
	MUL		R0, R9					; multiplicacao do numero a desenhar*n. das posicoes que esse numero ocupa
	ADD		R5, R0					; adicionar ao inicio da tabela
	MOV		R0, R5					; repor no R0 registo que serve de argumento para a rotina desenha_numero
	MOV		R9, 0					; mov R9 com 0, registo que serve de argumento para a rotina desenha_numero
	JMP		fim_converte_numero		; tag com Ret que volta a funcao desenha_numero ja com os argumentos correctos a desenhar
	
fim_converte_numero:
	RET

; *********************************
;		FUNÇAO INT_0
; DESCRIÇAO: Rotina de interrupcao referente ao Clock2
; PARAMETROS: R10
; DEVOLVE: [HORAS], [MINUTOS]
; DEPENDENCIAS: --
; DESTROI: R7, R8, R9
; NOTA: --

int_0:
	Push	R7
	PUSH	R8
	PUSH	R9				; instrucao de Push obrigatoria para registos que nao sejam o R10, pois podem ser chamados por outras rotinas

segundos:	
	MOV		R9, 600			; MOV R9 com os 600 milisegundos (60 segundos)
	ADD		R10, 1			; incrementa 100 milisegundos
	CMP		R10, R9			; compara com 60 segundos
	JZ	    minutos			
	JMP fim_int0
	
minutos:
	MOV		R10, 0			; reinicializacao de R10 devido a transicao de segundos para minutos 
	MOV		R8, MINUTOS		; endereco de memoria dos minutos
	MOVB 	R9, [R8]		; buscar os minutos atuais 
	ADD		R9, 1			 
	MOV		R7, 60			; registo auxiliar para a comparacao 		
	CMP		R9, R7			; segundos=60?
	JNZ		fim_minutos		; incrementou um minuto sem alterar o campo das horas 
	MOV		R9, 0			; incrementou-se uma hora => campo dos minutos passa a zero
	MOVB	[R8], R9		; reescreve-se na memoria
	JMP		horas			
	
horas:
	MOV		R8, HORAS		; endereco de memoria das horas
	MOVB	R9, [R8]		; R9 com o valor das horas atualizadas
	ADD		R9, 1			; soma 1
	MOV		R7, 24			; registo auxiliar para a comparacao 	
	CMP		R9, R7			; horas=24?
	JNZ		fim_horas		; se nao for sai da interrupcao
	MOV		R9, 0			; se for move 0 para o campo das horas
	MOVB	[R8], R9		; repor o valor na memoria
	JMP fim_int0
	
fim_minutos:
	MOVB	[R8], R9		; repor na memoria
	JMP fim_int0

fim_horas:
	MOVB	[R8], R9		; repor na memoria
	JMP fim_int0
	
fim_int0:		
	POP		R9			; comentario identico ao Push
	POP		R8
	POP		R7
	RFE

; *********************************
;		FUNÇAO DECIDE_SEGUNDOS
; DESCRIÇAO: Funcao que mediante o numero nos endereços dos segundos(ou R10) decide se houve alteracoes e o que desenhar 
; PARAMETROS: [SEGUNDOS], [MINUTOS], [HORAS] (ANTERIORES)
; DEVOLVE: [SEGUNDOS], [MINUTOS], [HORAS] (ACTUALIZADOS)
; DEPENDENCIAS: DESENHA_NUMERO
; DESTROI: R0, R1, R2, R7, R8, R9
; NOTA: --

decide_segundos:
	MOV		R1, R10				; copia do R10, como o R10 e um registo usado numa interrupcao nao se deve trabalhar com o mesmo por isso a copia
	MOV		R2,SEGUNDOS_ANT			
	MOV		R9, 0				; inicializa registo
	
ciclo_decide_segundos:
	MOV		R0, 10
	DIV		R1, R0				; obter	o numero de segundos real (em segundos e nao em milisegundos) 
	MOV		R9, R1				; copia de R1	
	MOD 	R1, R0				; R1, com o digito da direita dos segundos atual
	DIV		R9, R0				; R9, com o digito da esquerda dos segundos atual 
	MOVB	R8, [R2]			; R8, com segundos anteriores	
    MOV		R7, R8				; copia de registo para a separacao dos digitos anteriores
	DIV		R8, R0				; R8, com o digito da esquerda dos segundos anterior
	MOD		R7, R0				; R7, com o digito da direita dos segundos anterior
	CMP		R1, R7				; compara os segundos atuais com os segundos anteriores (os digitos sao iguais?)
	JZ		fim_decide			; se nao forem desenha novo digito no campo dos segundos, se for compara o digito da esquerda
		
desenha_segundo_dir:
	MOV		R7, R9				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				
	MUL		R7, R0				;	Reinsercao da memoria, como foi feita a separacao dos campos(minutos, segundos etc...)   ;					
	ADD		R7, R1				;	e necessario voltar a inserir na memoria como um so digito, faz se entao 				 ;
	MOVB	[R2], R7			;   as operacoes inversas para isso  														 ; 
	MOV		R7, R9				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	MOV		R0, R1
	MOV		R9, 0
	MOV		R1, COORD_SEG2  	
	Call	desenha_numero
	CMP		R7, R8				; compara os segundos atuais com os segundos anteriores (os digitos sao iguais?)
	JZ		fim_decide			; 
	
desenha_segundo_esq:
	MOV		R0, R7
	MOV		R9, 0
	MOV		R1, COORD_SEG1  	
	Call	desenha_numero

ciclo_decide_minutos:
	MOV		R9, 10			
	MOV		R2, MINUTOS_ANT		
	MOVB	R3, [R2]		    
	MOV		R4, R3				 
	DIV		R4, R9				; R4 a obter o digito da esquerda dos minutos anteriores
	MOD		R3, R9 				; R3 a obter o digito da direita dos minutos anteriores
	MOV		R2, MINUTOS			
	MOVB	R5, [R2]			
	MOV		R6, R5				
	DIV		R5, R9				; R5 a obter o digito da esquerda dos minutos atualizados
	MOD		R6, R9				; R6 a obter o digito da direita dos minutos atualizados
	CMP		R3, R6				
	JZ		fim_decide					
	
desenha_minuto_dir:
	MOV		R2, MINUTOS_ANT
	MOV		R7, R5				
	MUL		R7, R9					
	ADD		R7, R6					
	MOVB	[R2], R7			
	MOV		R7, R5					
	

	MOV		R0, R6 	
	MOV		R9, 1
	MOV		R1, COORD_MIN2
	Call	desenha_numero
	CMP		R4, R5
	JZ		fim_decide

desenha_minuto_esq:
	MOV		R0, R5
	MOV		R9, 1
	MOV		R1, COORD_MIN1  	
	Call	desenha_numero

ciclo_decide_horas:
	MOV		R9, 10
	MOV		R2, HORAS_ANT
	MOVB	R3, [R2]
	MOV		R4, R3			; R4, com o valor das horas anteriores
	DIV		R4, R9			; R4, com o valor do digito da esquerda das horas anteriores
	MOD		R3, R9 			; R3, com o valor do digito da direita das horas anteriores
	MOV		R2, HORAS		; R2, com o valor do endereco das horas atualizado
	MOVB	R5, [R2]		; R5, com o valor das horas atualizado
	MOV		R6, R5			; R6, com o valor das horas atualizado
	DIV		R5, R9			; R5, com o valor do digito da esquerda das horas atualizadas
	MOD		R6, R9			; R6, com o valor do digito da direita das horas atualizadas
	CMP		R3, R6
	JZ		fim_decide

desenha_hora_dir:
	MOV		R2, HORAS_ANT
	MOV		R7, R5				
	MUL		R7, R9					
	ADD		R7, R6					
	MOVB	[R2], R7			
	MOV		R7, R5				
	
	MOV		R0, R6 	
	MOV		R9, 1
	MOV		R1, COORD_HORAS2
	Call	desenha_numero
	CMP		R4, R5
	JZ		fim_decide
	
desenha_hora_esq:
	MOV		R0, R5
	MOV		R9, 1
	MOV		R1, COORD_HORAS1
	CALL	desenha_numero
	
fim_decide:
	RET

	
	
