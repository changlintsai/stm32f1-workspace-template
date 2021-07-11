# source file
SRC_FILE_NAME = SysTickTest

# linker script
LDSCRIPT = linkerScript.basic


LFLAGS_STM32=$(LFLAGS) $(SRC_FILE_NAME).c -T $(LDSCRIPT)

# STM32F1 starts up with HSI at 8Mhz
STM32F1_CFLAGS=$(M3_FLAGS) -DSTM32F1 -DLITTLE_BIT=200000 $(LFLAGS_STM32) -lopencm3_stm32f1

define RAWMakeBoard
	$(CC) -DRCC_LED1=RCC_$(1) -DPORT_LED1=$(1) -DPIN_LED1=$(2) \
		$(if $(5),-DRCC_LED2=RCC_$(5) -DPORT_LED2=$(5) -DPIN_LED2=$(6),) \
		$(3) -o $(OD)/stm32/$(4)
endef

define MakeBoard
BOARDS_ELF+=$(OD)/stm32/$(1).elf
BOARDS_BIN+=$(OD)/stm32/$(1).bin
BOARDS_HEX+=$(OD)/stm32/$(1).hex
$(OD)/stm32/$(1).elf: $(SRC_FILE_NAME).c libopencm3/lib/libopencm3_$(5).a
	@echo "  $(5) -> Creating $(OD)/stm32/$(1).elf"
	$(call RAWMakeBoard,$(2),$(3),$(4),$(1).elf,$(6),$(7))
endef


define stm32f1board
	$(call MakeBoard,$(1),$(2),$(3),$(STM32F1_CFLAGS),stm32f1,$(4),$(5))
endef

# STM32F1 boards
$(eval $(call stm32f1board,$(SRC_FILE_NAME),GPIOC,GPIO13))

