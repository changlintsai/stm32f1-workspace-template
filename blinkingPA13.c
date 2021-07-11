#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>

static void gpio_setup(void) {

	rcc_periph_clock_enable(RCC_GPIOC);
	gpio_set_mode(GPIOC, GPIO_MODE_OUTPUT_2_MHZ,
			GPIO_CNF_OUTPUT_PUSHPULL, GPIO13);
}

int main(void) {
	int i;

	gpio_setup();

	for(;;) {
		gpio_clear(GPIOC, GPIO13);
		for (i=0; i<4500000; i++) {
			__asm__("nop");
		}

		gpio_set(GPIOC, GPIO13);
		for (i=0; i<1500000; i++) {
			__asm__("nop");
		}
	}
	return 0;
}

