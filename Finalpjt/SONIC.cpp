
#include "SONIC.h"
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>


#define Trigger1_On		PORTA |= 0x01
#define Trigger1_Off	PORTA &= ~0x01
#define Trigger2_On		PORTA |= 0x02
#define Trigger2_Off	PORTA &= ~0x02
#define Echo1			(PINL & 0x01)
#define Echo2			(PINL & 0x10)

unsigned int get_Echo(char ch);

unsigned int get_Echo(char ch)
{
	uint8_t range;
	switch(ch)
	{
		case 0 : Trigger1_On; _delay_us(10); Trigger1_Off; break;
		case 1 : Trigger2_On; _delay_us(10); Trigger2_Off; break;
	}
	switch(ch)
	{
		case 0 : while(Echo1 == 0x00); TCNT1 = 0x00; TCCR1B = 0x02; while(Echo1); break;
		case 1 : while(Echo2 == 0x00); TCNT1 = 0x00; TCCR1B = 0x02; while(Echo2); break;
	}
	TCCR1B = 0x08; range = TCNT1 / 116;
	return range;
}

