GOTO: [Base-Projects](https://github.com/DamianKJKujawski/Base-Projects) [Ideas-Projects](https://github.com/DamianKJKujawski/Ideas-Projects) [MicroOS](https://github.com/DamianKJKujawski/MicroOS) [Electronics](https://github.com/DamianKJKujawski/Electronics) [Design Patterns](https://github.com/DamianKJKujawski/DesignPatterns) [MulticorePLCUnit](https://github.com/DamianKJKujawski/MulticorePLCUnit) [PCB Design](https://github.com/DamianKJKujawski/PCB) [Antennas](https://github.com/DamianKJKujawski/Antennas)

## MulticorePLCUnit:

### 4-Cores Implementation:

![image](https://github.com/DamianKJKujawski/MulticorePLCUnit/assets/160174331/47a41ac1-8580-4297-932f-58011cfb5ed6)

OPCODE:

```

* 				Instruction set for bit operands:			     *
*------------------------------------------ L O A D -----------------------------------------*

* Load Constant																	
( Instruction | Arg | 0+LU-OPcode )
 {0001} {0} {000}			Rb  		0 -> RLO	//1 cykl	//DECODER: {0001X}
 {0001} {1} {000}			Sb  		1 -> RLO

* Load from OV: (1 cycle operations)					//1 cycle	//DECODER: {0001X}
( Instruction | Arg | RLO-Addr )
 {0001} {X} {100}			LDb OV 		OV  -> RLO 

* Load from Comparator: (1 cycle operations)				//1 cycle	//DECODER: {0001X}
( Instruction | Arg | RLO-Addr )
 {0001} {X}} {101}			LDb CMP 	CMP -> RLO 

|* Load from RAM: (4 cycle operations)					//3 cycles	//DECODER: {00100}
|( Instruction | Arg | RLO-Addr )						
|---------------------------------------------------------------------------------------------
|{0010} {0} {001} 			LDb MEM		(MEM) -> RLO
|---------------------------------------------------------------------------------------------
|* Load from REGISTER:			//2 cycles	//DECODER: {00101}
|---------------------------------------------------------------------------------------------
|{0010} {1} {010}			LDb REG 	(REG) -> RLO 
|---------------------------------------------------------------------------------------------												

* LU:
 ( Instruction | RLO-Addr | LU-OPcode )

 {0011} {00} {00}			Ab CONST	RLO  x  CONST -> RLO	// 2 cycles // DECODER: {00110}
 {0011} {00} {01}			Ob CONST	RLO  +  CONST -> RLO 
 {0011} {00} {11}			Xb CONST	RLO xor CONST -> RLO

 {0100} {01} {00}			Ab MEM	 	RLO  x  (MEM) -> RLO	// 3 cycles // DECODER: {01000}
 {0100} {01} {01}			Ob MEM		RLO  +  (MEM) -> RLO
 {0100} {01} {11}			Xb MEM		RLO xor (MEM) -> RLO

 {0011} {10} {00}			Ab REG	 	RLO  x  (REG) -> RLO 	// 2 cycles // DECODER: {00110}
 {0011} {10} {01}			Ob REG		RLO  +  (REG) -> RLO 
 {0011} {10} {11}			Xb REG		RLO xor (REG) -> RLO
 
 {0100} {11} {10}			Nb 	       -RLO -> RLO		// 1 cycle // DECODER: {01001}

|* Save to RAM:
|---------------------------------------------------------------------------------------------
|{0101} {0} {001}			STb MEM	 	RLO -> (MEM)		//3 cycles // DECODER: {01010}
|---------------------------------------------------------------------------------------------
|* Save to Register:
|---------------------------------------------------------------------------------------------
|{0101} {1} {010}			STb REG	 	RLO -> (REG)		//2 cycles // DECODER: {01001}
|---------------------------------------------------------------------------------------------



==============================================================================================				
* Instruction set for word arguments:	
==============================================================================================	

* Load Constant (1 cycle operations)
 {0110} {X} {000}			LDw CONST	AKU_A -> AKU_B; CONST -> AKU_A		// 2 cyclec // DECODER: {01001}

*------------------------------------------ L O A D -----------------------------------------*
|* Load from RAM:
|{ Instruction | Bit=0/Word=1 | RLO-Addr }
|---------------------------------------------------------------------------------------------
|{0111} {0} {001}			LDw MEM		AKU_A -> AKU_B; (MEM) -> AKU_A		//3 cykle // DECODER: {01110}
|---------------------------------------------------------------------------------------------
|* Load from REGISTER:
|---------------------------------------------------------------------------------------------
|{0111} {1} {010}			LDw REG		AKU_A -> AKU_B; (REG) -> AKU_A		//2 cykle // DECODER: {01111}
|---------------------------------------------------------------------------------------------

* ALU:
 {1000} {0000}				AND  		AKU_B and AKU_A -> AKU_A 		0 -> OV		// 1 cycle 		// DECODER: 1000
 {1000} {0001}				OR  		AKU_B or AKU_A -> AKU_A 		0 -> OV 	// {00XX}  -> Clear OV
 {1000} {0010}				NEG  		-AKU_A -> AKU_A 			0 -> OV 	// {100X}  -> flag modification
 {1000} {0011}				XOR  		AKU_B xor AKU_A -> AKU_A 		0 -> OV		// (1XXX && !100X)) -> Set Comparator 
 
 {1000} {0100}				SL  		AKU_A << 1 AKU_A [15] -> OV 0 -> AKU_A [0]
 {1000} {0101}				SR  		AKU_A >> 1 AKU_A [0] -> OV 0 -> AKU_A [15] 
 {1000} {0110}				RL  		AKU_A << 1 AKU_A [15] -> OV AKU_A [15] -> AKU_A [0]  
 {1000} {0111}				RR  		AKU_A >> 1 AKU_A [0] -> OV AKU_A [0] -> AKU_A [15]
 
 {1000} {1000}				ADD  		AKU_B + AKU_A -> AKU_A 	(OV flag modification)	
 {1000} {1001}				SUB  		AKU_B – AKU_A -> AKU_A 	(OV flag modification)
 
 {1000} {1010}				EQ  		AKU_A = AKU_B -> RLO O 							
 {1000} {1011}				GT  		AKU_A > AKU_B -> RLO O 
 {1000} {1100}				GE  		AKU_A >= AKU_B -> RLO O 
 {1000} {1101}				NE 	 	AKU_A >< AKU_B -> RLO O 
 {1000} {1110}				LE  		AKU_A <= AKU_B -> RLO O 
 {1000} {1111}				LT  		AKU_A < AKU_B -> RLO O 

*------------------------------------------ S A V E -----------------------------------------*
|* Save to RAM:
|---------------------------------------------------------------------------------------------
|{1001} {0} {001}			STw MEM		AKU_A -> (MEM)		//3 cycles // DECODER: {10010}
|---------------------------------------------------------------------------------------------
|* Save to REGISTER:
|---------------------------------------------------------------------------------------------
|{1001} {1} {010}			STw REG		AKU_A -> (REG)		//2 cycles // DECODER: {10011}
|---------------------------------------------------------------------------------------------

==============================================================================================				
* Jumps:	
==============================================================================================
* Instruction set for jumps:
 {1010} {0} {000}			JMP 		Jump to the label	// 2 cycles // DECODER: {10100}

 {1010} {0} {001}			JMPC 		Jump to the label, if RLO=1
 {1010} {0} {010}			JMPCN 		Jump to the label, if RLO=0

 {1010} {0} {011}			JCMP 		Jump to the label, if CMP=1
 {1010} {0} {100}			JCMPN 		Jump to the label, if CMP=0

 {1010} {0} {101}			JOV 		Jump to the label, if OV=1
 {1010} {0} {110}			JOVN		Jump to the label, if OV=0

==============================================================================================				
* Sync:	(Semaphores)

* Stop CPU:
 {0000} {0000}					STOP

* Save to Semaphore:
 {1100} {0} {000}				SET	RLO -> (SEM)

* Read Semaphore:
 {1100} {1} {110}				READ	(SEM) -> RLO  

* Wait for Semaphore:
 {1101} {1110}					WAIT	(SEM) -> RLO

```
