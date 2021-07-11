#include <stdint.h>
#include <libopencm3/cm3/systick.h>

void sys_tick_handler(void);

static volatile uint64_t _millis = 0;

static void systick_setup() {
	systick_set_clocksource(STK_CSR_CLKSOURCE_AHB);

	STK_CVR = 0;

	systick_set_reload(rcc_abh_frequency / 1000 -1);
	systick_interrupt_enable();
	systick_counter_enable();
}

uint64_t millis() {
	return _millis;
}

void sys_tick_handler(void) {
	_millis++;
}

void delay(uint64_t, duration) {
	const uint64_t until = millis() + duration;
	while(millis() < until);
}

