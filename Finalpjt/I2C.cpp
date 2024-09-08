
#include "I2C.h"


void i2c_start(void)
{
	TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);
	while ( !(TWCR & (1 << TWINT)) );	// Wait for start completion
}

void i2c_stop(void)
{
	TWCR = (1 << TWINT) | (1 << TWSTO) | (1 << TWEN);
}

void i2c_tx(uint8_t data)
{
	TWDR = data;
	TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWEA);
	while ( !(TWCR & (1 << TWINT)) );	// Wait for Tx completion
}

uint8_t i2c_rx_ack(void)
{
	TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWEA);
	while ( !(TWCR & (1 << TWINT)) );	// Wait for Rx completion
	return TWDR;
}

uint8_t i2c_rx_nack(void)
{
	TWCR = (1 << TWINT) | (1 << TWEN);
	while ( !(TWCR & (1 << TWINT)) );	// Wait for Rx completion
	return TWDR;
}