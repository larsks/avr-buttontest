#include <avr/io.h>
#include <util/delay.h> 

#include "Button.h"

#define PIN_LED0 PB0
#define PIN_LED1 PB3
#define PIN_LED2 PB2
#define PIN_BUTTON PB1

Button button(PIN_BUTTON);

int main() {
	// Configure PIN_LED as output
	DDRB = 1<<PIN_LED0 | 1<<PIN_LED1 | 1<<PIN_LED2;

	// Set pull-up on PIN_BUTTON
	PORTB |= 1<<PIN_BUTTON;

	while (1) {
		button.update();

		/* this directly tracks the state of the button */
		if (PINB & (1<<PIN_BUTTON)) {
			PORTB |= 1<<PIN_LED0;
		} else {
			PORTB &= ~(1<<PIN_LED0);
		}

		if (button.is_pressed()) {
			PORTB |= 1<<PIN_LED2;
		} else if (button.is_released()) {
			PORTB &= ~(1<<PIN_LED2);
		}

		if (button.is_down()) {
			PORTB |= 1<<PIN_LED1;
		} else if (button.is_up()) {
			PORTB &= ~(1<<PIN_LED1);
		}

		_delay_ms(5);
	}
}
