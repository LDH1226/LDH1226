/*
 * Finalpjt.cpp
 *
 * Created: 2022-05-30 오전 10:36:29
 * Author : Dohyun, Gitae
 */ 

#define F_CPU 16000000UL
#define FS_SEL 131

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <math.h>
#include <stdio.h>

#include "I2C.h"
#include "CLCD.h"
#include "SONIC.h"
#include "ws2812.h"

#define NUMBER_OF_LEDS 100
/******************************/
/***	Global Variable 	***/
/*******************************/

unsigned int time_cnt = 0;


/**********************************/
/***	Function Declaration	***/
/*********************************/

int main(void)
{
	/******************************/
    /***	Set I/O Register	***/
	/******************************/
	

	// GPIO
	DDRA = 0xFF;	// Sonic Senor Trigger
	DDRL = 0x00;	// Sonic Sensor Echo
			// POTR C 에 LED 할당
	
	
	sei();	// Enable interrupt
	
	
	/***************************/
	/***	Local Variable	 ***/
	/***************************/
	
	uint8_t range[2];		//for sonic
	char strbufferA[30];	// for CLCD
	char strbufferB[30];
	color led_strip[NUMBER_OF_LEDS];	// for LED
	
	uint8_t game_mode = 0;	//for main
	
	
	i2c_CLCD_set();
	LCD_INIT();
	LCD_CLEAR();
	LCD_XY(0,0); LCD_print((uint8_t *) "Hello");
	_delay_ms(1000);		// Check for clcd work
	

	/***************************/
	/***	Main Function	 ***/
	/***************************/
    
	// Use 'game_mode' variable to express states
	// 0 : wait, 1 : ready, 2 : game, 3 : end, else : error and return to 0
	
	while(1)
	{
		if (game_mode == 0)		// Wait mode
		{
			LCD_CLEAR();
			LCD_XY(0,0); LCD_print((uint8_t *) "Waiting for ");
			LCD_XY(0,1); LCD_print((uint8_t *) "start");
			
			// LED
			for (uint8_t i = 0; i < NUMBER_OF_LEDS; i++)
			{
				led_strip[i] = (color){ 50, 50, 50 };
			}
			update_led_strip(led_strip, NUMBER_OF_LEDS);	// Write the buffer to the led strip
			
			while
			(1)
			{
				range[0] = get_Echo(0); _delay_ms(100);		// Get Left distance
				range[1] = get_Echo(1); _delay_ms(100);		// Get Right distance
				
				if ((range[0] < 3) | (range[1] < 3))	// READY CONDITON (NEED MODIFYING)
				{
					game_mode = 1;
					break;
				}
				_delay_ms(10);
			}
		}	// Wait mode end
		
		else if (game_mode == 1)	// Ready mode
		{
			unsigned int cnt = 0;
			time_cnt = 0;
			
			LCD_CLEAR();
			LCD_XY(0,0); LCD_print((uint8_t *) "Ready!!");
			
			// LED
			for (uint8_t i = 0; i < NUMBER_OF_LEDS; i++)
			{
				led_strip[i] = (color){ 50, 25, 0 };	// Orange color
			}
			update_led_strip(led_strip, NUMBER_OF_LEDS);
			
			while(1)
			{
				range[0] = get_Echo(0); _delay_ms(100);		// Left distance
				range[1] = get_Echo(1); _delay_ms(100);		// Right distance
				
				if ((range[0] > 4) & (range[1] > 4))		// START CONDITON (NEED MODIFYING)
				{
					cnt++;
				}
				else
				{
					cnt = 0;
				}
				
				
				if (cnt >= 3)
				{
					game_mode = 2;
					break;
				}
				
				_delay_ms(10);
			}
		}	// Ready mode end
		
		else if (game_mode == 2)	// Game mode
		{
			LCD_CLEAR();
			LCD_XY(0,0); LCD_print((uint8_t *) "Start!!");
			
			// LED
			for (uint8_t i = 0; i < NUMBER_OF_LEDS; i++)
			{
				led_strip[i] = (color){ 0, 50, 0 };		// Green
			}
			update_led_strip(led_strip, NUMBER_OF_LEDS);
			
			
			while(1)
			{
				range[0] = get_Echo(0); _delay_ms(100);		// Left distance
				range[1] = get_Echo(1); _delay_ms(100);		// Right distance
				time_cnt++;
				
				LCD_CLEAR();
				sprintf(strbufferA, "Left : %d cm", range[0]);
				sprintf(strbufferB, "Right : %d cm", range[1]);
				LCD_XY(0,0); LCD_print((uint8_t *) strbufferA);
				LCD_XY(0,1); LCD_print((uint8_t *) strbufferB);
				
				if ((range[0] < 3) | (range[1] < 3))	// END CONDITON (NEED MODIFYING)
				{
					game_mode = 3;
					break;
				}
				_delay_ms(10);
			}
			
		}	// Game mode end
		
		else if (game_mode == 3)	// Game end mode
		{
			// LED
			for (uint8_t i = 0; i < NUMBER_OF_LEDS; i++)
			{
				led_strip[i] = (color){ 50, 0, 0 };
			}
			update_led_strip(led_strip, NUMBER_OF_LEDS);
			
			int i = 0;
			LCD_CLEAR();
			LCD_XY(0,0); LCD_print((uint8_t *) "Game Over!!");
			sprintf(strbufferA, "Score : %d", time_cnt);
			LCD_XY(0,1); LCD_print((uint8_t *) strbufferA);
			_delay_ms(1000);
			
			for (i=0;i<=3;i++)
			{
				LCD_CLEAR();
				_delay_ms(500);
				LCD_XY(0,0); LCD_print((uint8_t *) "Game Over!!");
				LCD_XY(0,1); LCD_print((uint8_t *) strbufferA);
				_delay_ms(500);
			}

			game_mode = 0;
		}
		
		else         // Not used state
		{
			game_mode = 0;
		}

		
	}	// end while
	
	
}


/*************************/
/*	Function Definition	 */
/*************************/

