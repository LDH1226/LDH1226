
#ifndef I2C_H_
#define I2C_H_

#include <avr/io.h>


void i2c_start(void);					// i2c 통신 시작
void i2c_stop(void);					// i2c 통신 종료
void i2c_tx(uint8_t data);				// Transmission data to slave
uint8_t i2c_rx_ack(void);				// Receive data from slave
uint8_t i2c_rx_nack(void);				// Receive data from slave

#endif /* I2C_H_ */