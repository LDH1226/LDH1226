
#ifndef CLCD_H_
#define CLCD_H_

#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include "I2C.h"

/************************/
/* Function Declaration */
/************************/
void i2c_CLCD_set(void);
void i2c_write(uint8_t i2c_data);
void LCD_DATA(uint8_t data);
void LCD_CMD(uint8_t cmd);
void LCD_INIT(void);
void LCD_XY(uint8_t x, uint8_t y);
void LCD_CLEAR(void);
void LCD_print(uint8_t *str);

#endif /* CLCD_H_ */
