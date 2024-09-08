/*
 * ws2812.h
 *
 * Created: 2022-05-17 오후 2:03:48
 *  Author: 3189
 */ 

#ifndef WS2812B_H_
#define WS2812B_H_

//the must correspond to the frequency of the chip
//------------------------------------
#ifndef F_CPU
#define F_CPU 16000000
#endif
//------------------------------------

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#if ( __AVR_ARCH__ >= 100 )
//if the processor is XMEGA or megaAVR 0-series
//------------------------------------
#define LED_PORT	PORTC
#define LED_PIN		7
//------------------------------------
#else
//if on older Atmel AVR chips
//------------------------------------
#define LED_STRIP_PORT PORTC
#define LED_STRIP_DDR  DDRC
#define LED_STRIP_PIN  7
//------------------------------------
#endif

typedef struct color
{
	uint8_t red;
	uint8_t green;
	uint8_t blue;
} color;

void __attribute__((noinline)) update_led_strip(color* colors, uint16_t number_of_leds);

#endif



