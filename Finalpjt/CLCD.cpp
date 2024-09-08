
#include "CLCD.h"

#define ADDRESS 0x27
#define addr_w	(ADDRESS << 1)
#define addr_r	(ADDRESS << 1) + 1

/* B7 - D7, B6 - D6, B5 - D5, B4 - D4, B3 - BackLight,
 B2 - Enable, B1 - Read/Write, B0 - Register Select */
#define RS1_EN1		0x05	// LCD data write + enable
#define RS1_EN0		0x01	// LCD data write + disable
#define RS0_EN1		0x04	// LCD Command write + enable
#define RS0_EN0		0x00	// LCD Command write + disable
#define BackLight	0x08	// LCD BackLight on

/*************************/
/*	Function Definition	 */
/*************************/

void i2c_CLCD_set(void)
{
	TWSR = 0x00;
	TWBR = 0x48;
}

void i2c_write(uint8_t i2c_data)
{
	i2c_start();
	i2c_tx(addr_w);
	i2c_tx(i2c_data);
	i2c_stop();
}

void LCD_DATA(uint8_t data)
{
	i2c_write((data & 0xF0) | RS1_EN1 | BackLight);
	i2c_write((data & 0xF0) | RS1_EN0 | BackLight);
	_delay_us(4);
	
	i2c_write(((data << 4) & 0xF0) |  RS1_EN1 | BackLight);
	i2c_write(((data << 4) & 0xF0) |  RS1_EN0 | BackLight);
	_delay_us(50);
}

void LCD_CMD(uint8_t cmd)
{
	i2c_write( (cmd & 0xF0) | RS0_EN1 | BackLight);
	i2c_write( (cmd & 0xF0) | RS0_EN0 | BackLight);
	_delay_us(4);
	
	i2c_write( (cmd << 4) & 0xF0 | RS0_EN1 | BackLight);
	i2c_write( (cmd << 4) & 0xF0 | RS0_EN0 | BackLight);
	_delay_us(50);
}

void LCD_INIT(void)
{
	LCD_CMD(0x02);	// Set 4bits mode
	_delay_us(100);
	LCD_CMD(0x28);	// 4 bits, 2 line, 5X8 font
	LCD_CLEAR();
	LCD_CMD(0x06);	// Set cursor move direction (Right)
	LCD_CMD(0x0C);	// Display on, cursor off, blink off
}

void LCD_XY(uint8_t x, uint8_t y)
{
	if (y==0) LCD_CMD(0x80 + x);
	else if (y==1) LCD_CMD(0xC0 + x);
	else if (y==2) LCD_CMD(0x94 + x);
	else if (y==3) LCD_CMD(0xD4 + x);
}

void LCD_CLEAR(void)
{
	LCD_CMD(0x01); // Clear display
	_delay_ms(2);
}

void LCD_print(uint8_t *str)
{
	while(*str) LCD_DATA(*str++);
}