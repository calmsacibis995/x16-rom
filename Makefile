
MACHINE     ?= x16

ifdef RELEASE_VERSION
	VERSION_DEFINE="-DRELEASE_VERSION=$(RELEASE_VERSION)"
endif
ifdef PRERELEASE_VERSION
	VERSION_DEFINE="-DPRERELEASE_VERSION=$(PRERELEASE_VERSION)"
endif

AS           = ca65
LD           = ld65

ASFLAGS      = --cpu 65SC02 -g -D bsw=1 -D drv1541=1 -I geos/inc -I geos -D CPU_65C02=1 -D MACHINE_X16=1 $(VERSION_DEFINE)

BUILD_DIR=build/$(MACHINE)

KERNAL_SOURCES = \
	kernal/kernal.s \
	kernal/editor.s \
	kernal/kbdbuf.s \
	kernal/channel/channel.s \
	kernal/ieee_switch.s \
	kernal/serial.s \
	kernal/memory.s \
	kernal/lzsa.s \
	kernal/drivers/x16/x16.s \
	kernal/drivers/x16/memory.s \
	kernal/drivers/x16/screen.s \
	kernal/drivers/x16/ps2.s \
	kernal/drivers/x16/ps2kbd.s \
	kernal/drivers/x16/ps2mouse.s \
	kernal/drivers/x16/joystick.s \
	kernal/drivers/x16/clock.s \
	kernal/drivers/x16/rs232.s \
	kernal/drivers/x16/framebuffer.s \
	kernal/drivers/x16/sprites.s \
	kernal/graph/graph.s \
	kernal/console.s \
	kernal/fonts/fonts.s

KEYMAP_SOURCES = \
	keymap/keymap.s

CBDOS_SOURCES = \
	cbdos/zeropage.s \
	cbdos/fat32.s \
	cbdos/util.s \
	cbdos/matcher.s \
	cbdos/sdcard.s \
	cbdos/spi_rw_byte.s \
	cbdos/spi_select_device.s \
	cbdos/spi_deselect.s \
	cbdos/main.s

GEOS_SOURCES= \
	geos/kernal/bitmask/bitmask2.s \
	geos/kernal/conio/conio1.s \
	geos/kernal/conio/conio2.s \
	geos/kernal/conio/conio3a.s \
	geos/kernal/conio/conio4.s \
	geos/kernal/conio/conio6.s \
	geos/kernal/dlgbox/dlgbox1a.s \
	geos/kernal/dlgbox/dlgbox1b.s \
	geos/kernal/dlgbox/dlgbox1c.s \
	geos/kernal/dlgbox/dlgbox1d.s \
	geos/kernal/dlgbox/dlgbox1e1.s \
	geos/kernal/dlgbox/dlgbox1e2.s \
	geos/kernal/dlgbox/dlgbox1f.s \
	geos/kernal/dlgbox/dlgbox1g.s \
	geos/kernal/dlgbox/dlgbox1h.s \
	geos/kernal/dlgbox/dlgbox1i.s \
	geos/kernal/dlgbox/dlgbox1j.s \
	geos/kernal/dlgbox/dlgbox1k.s \
	geos/kernal/dlgbox/dlgbox2.s \
	geos/kernal/files/files10.s \
	geos/kernal/files/files1a2a.s \
	geos/kernal/files/files1a2b.s \
	geos/kernal/files/files1b.s \
	geos/kernal/files/files2.s \
	geos/kernal/files/files3.s \
	geos/kernal/files/files6a.s \
	geos/kernal/files/files6b.s \
	geos/kernal/files/files6c.s \
	geos/kernal/files/files7.s \
	geos/kernal/files/files8.s \
	geos/kernal/graph/clrscr.s \
	geos/kernal/graph/inlinefunc.s \
	geos/kernal/graph/graphicsstring.s \
	geos/kernal/graph/graph2l1.s \
	geos/kernal/graph/pattern.s \
	geos/kernal/graph/inline.s \
	geos/kernal/header/header.s \
	geos/kernal/hw/hw1a.s \
	geos/kernal/hw/hw1b.s \
	geos/kernal/hw/hw2.s \
	geos/kernal/hw/hw3.s \
	geos/kernal/icon/icon1.s \
	geos/kernal/icon/icon2.s \
	geos/kernal/init/init1.s \
	geos/kernal/init/init2.s \
	geos/kernal/init/init3.s \
	geos/kernal/init/init4.s \
	geos/kernal/irq/irq.s \
	geos/kernal/jumptab/jumptab.s \
	geos/kernal/keyboard/keyboard1.s \
	geos/kernal/keyboard/keyboard2.s \
	geos/kernal/keyboard/keyboard3.s \
	geos/kernal/load/deskacc.s \
	geos/kernal/load/load1a.s \
	geos/kernal/load/load1b.s \
	geos/kernal/load/load1c.s \
	geos/kernal/load/load2.s \
	geos/kernal/load/load3.s \
	geos/kernal/load/load4b.s \
	geos/kernal/mainloop/mainloop.s \
	geos/kernal/math/shl.s \
	geos/kernal/math/shr.s \
	geos/kernal/math/muldiv.s \
	geos/kernal/math/neg.s \
	geos/kernal/math/dec.s \
	geos/kernal/math/random.s \
	geos/kernal/math/crc.s \
	geos/kernal/memory/memory1a.s \
	geos/kernal/memory/memory1b.s \
	geos/kernal/memory/memory2.s \
	geos/kernal/memory/memory3.s \
	geos/kernal/menu/menu1.s \
	geos/kernal/menu/menu2.s \
	geos/kernal/menu/menu3.s \
	geos/kernal/misc/misc.s \
	geos/kernal/mouse/mouse1.s \
	geos/kernal/mouse/mouse2.s \
	geos/kernal/mouse/mouse3.s \
	geos/kernal/mouse/mouse4.s \
	geos/kernal/mouse/mouseptr.s \
	geos/kernal/panic/panic.s \
	geos/kernal/patterns/patterns.s \
	geos/kernal/process/process.s \
	geos/kernal/reu/reu.s \
	geos/kernal/serial/serial1.s \
	geos/kernal/serial/serial2.s \
	geos/kernal/sprites/sprites.s \
	geos/kernal/time/time1.s \
	geos/kernal/time/time2.s \
	geos/kernal/tobasic/tobasic2.s \
	geos/kernal/vars/vars.s \
	geos/kernal/start/start64.s \
	geos/kernal/bitmask/bitmask1.s \
	geos/kernal/bitmask/bitmask3.s \
	geos/kernal/conio/conio5.s \
	geos/kernal/files/files9.s \
	geos/kernal/graph/bitmapclip.s \
	geos/kernal/graph/bitmapup.s \
	geos/kernal/graph/graph_bridge.s \
	geos/kernal/ramexp/ramexp1.s \
	geos/kernal/ramexp/ramexp2.s \
	geos/kernal/rename.s \
	geos/kernal/tobasic/tobasic1.s \
	geos/kernal/drvcbdos.s

BASIC_SOURCES= \
	kernsup/kernsup_basic.s \
	basic/basic.s \
	fplib/fplib.s

MONITOR_SOURCES= \
	kernsup/kernsup_monitor.s \
	monitor/monitor.s

CHARSET_SOURCES= \
	charset/petscii.s \
	charset/iso-8859-15.s

GENERIC_DEPS = \
	kernal.inc \
	mac.inc \
	io.inc \
	fb.inc \
	banks.inc \
	jsrfar.inc \
	regs.inc \
	kernsup/kernsup.inc

KERNAL_DEPS = \
	$(GENERIC_DEPS) \
	kernal/fonts/fonts.inc

KEYMAP_DEPS = \
	$(GENERIC_DEPS)

CBDOS_DEPS = \
	$(GENERIC_DEPS) \
	cbdos/errno.inc \
	cbdos/debug.inc \
	cbdos/fat32.inc \
	cbdos/rtc.inc \
	cbdos/fcntl.inc \
	cbdos/spi.inc \
	cbdos/65c02.inc \
	cbdos/common.inc \
	cbdos/sdcard.inc \
	cbdos/vera.inc

GEOS_DEPS= \
	$(GENERIC_DEPS) \
	geos/config.inc \
	geos/inc/printdrv.inc \
	geos/inc/kernal.inc \
	geos/inc/inputdrv.inc \
	geos/inc/diskdrv.inc \
	geos/inc/const.inc \
	geos/inc/jumptab.inc \
	geos/inc/geosmac.inc \
	geos/inc/geossym.inc \
	geos/inc/c64.inc

BASIC_DEPS= \
	$(GENERIC_DEPS) \
	fplib/fplib.inc

MONITOR_DEPS= \
	$(GENERIC_DEPS) \
	monitor/kernal_x16.i \
	monitor/kernal.i

CHARSET_DEPS= \
	$(GENERIC_DEPS)

KERNAL_OBJS  = $(addprefix $(BUILD_DIR)/, $(KERNAL_SOURCES:.s=.o))
KEYMAP_OBJS  = $(addprefix $(BUILD_DIR)/, $(KEYMAP_SOURCES:.s=.o))
CBDOS_OBJS   = $(addprefix $(BUILD_DIR)/, $(CBDOS_SOURCES:.s=.o))
GEOS_OBJS    = $(addprefix $(BUILD_DIR)/, $(GEOS_SOURCES:.s=.o))
BASIC_OBJS   = $(addprefix $(BUILD_DIR)/, $(BASIC_SOURCES:.s=.o))
MONITOR_OBJS = $(addprefix $(BUILD_DIR)/, $(MONITOR_SOURCES:.s=.o))
CHARSET_OBJS = $(addprefix $(BUILD_DIR)/, $(CHARSET_SOURCES:.s=.o))

BANK_BINS = \
	$(BUILD_DIR)/kernal.bin \
	$(BUILD_DIR)/keymap.bin \
	$(BUILD_DIR)/cbdos.bin \
	$(BUILD_DIR)/geos.bin \
	$(BUILD_DIR)/basic.bin \
	$(BUILD_DIR)/monitor.bin \
	$(BUILD_DIR)/charset.bin

all: $(BUILD_DIR)/rom.bin

$(BUILD_DIR)/rom.bin: $(BANK_BINS)
	cat $(BANK_BINS) > $@

clean:
	rm -rf $(BUILD_DIR)


$(BUILD_DIR)/%.o: %.s
	@mkdir -p $$(dirname $@)
	$(AS) $(ASFLAGS) $< -o $@


# Bank 0 : KERNAL
$(BUILD_DIR)/kernal.bin: $(KERNAL_OBJS) $(KERNAL_DEPS) kernal-$(MACHINE).cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C kernal-$(MACHINE).cfg $(KERNAL_OBJS) -o $@ -m $(BUILD_DIR)/kernal.map -Ln $(BUILD_DIR)/kernal.txt

# Bank 1 : KEYMAP
$(BUILD_DIR)/keymap.bin: $(KEYMAP_OBJS) $(KEYMAP_DEPS) keymap-$(MACHINE).cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C keymap-$(MACHINE).cfg $(KEYMAP_OBJS) -o $@ -m $(BUILD_DIR)/keymap.map -Ln $(BUILD_DIR)/keymap.txt

# Bank 2 : CBDOS
$(BUILD_DIR)/cbdos.bin: $(CBDOS_OBJS) $(CBDOS_DEPS) cbdos-$(MACHINE).cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C cbdos-$(MACHINE).cfg $(CBDOS_OBJS) -o $@ -m $(BUILD_DIR)/cbdos.map -Ln $(BUILD_DIR)/cbdos.txt

# Bank 3 : GEOS
$(BUILD_DIR)/geos.bin: $(GEOS_OBJS) $(GEOS_DEPS) geos-$(MACHINE).cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C geos-$(MACHINE).cfg $(GEOS_OBJS) -o $@ -m $(BUILD_DIR)/geos.map -Ln $(BUILD_DIR)/geos.txt

# Bank 4 : BASIC
$(BUILD_DIR)/basic.bin: $(BASIC_OBJS) $(BASIC_DEPS) basic-$(MACHINE).cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C basic-$(MACHINE).cfg $(BASIC_OBJS) -o $@ -m $(BUILD_DIR)/basic.map -Ln $(BUILD_DIR)/basic.txt

# Bank 5 : MONITOR
$(BUILD_DIR)/monitor.bin: $(MONITOR_OBJS) $(MONITOR_DEPS) monitor-$(MACHINE).cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C monitor-$(MACHINE).cfg $(MONITOR_OBJS) -o $@ -m $(BUILD_DIR)/monitor.map -Ln $(BUILD_DIR)/monitor.txt

# Bank 6 : CHARSET
$(BUILD_DIR)/charset.bin: $(CHARSET_OBJS) $(CHARSET_DEPS) charset-$(MACHINE).cfg
	@mkdir -p $$(dirname $@)
	$(LD) -C charset-$(MACHINE).cfg $(CHARSET_OBJS) -o $@ -m $(BUILD_DIR)/charset.map -Ln $(BUILD_DIR)/charset.txt
