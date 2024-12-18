#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=mkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=-mafrlcsj
else
COMPARISON_BUILD=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=src/controller.c src/hal.c src/main.c src/ui.c ../../ARM_CLION/common_lib/display/font.c ../../ARM_CLION/common_lib/display/lcd_ssd1306.c ../../ARM_CLION/common_lib/display/fonts/font5.c ../../ARM_CLION/common_lib/display/fonts/font8_2.c ../../ARM_CLION/common_lib/display/lcd.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/src/controller.o ${OBJECTDIR}/src/hal.o ${OBJECTDIR}/src/main.o ${OBJECTDIR}/src/ui.o ${OBJECTDIR}/_ext/1979377065/font.o ${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o ${OBJECTDIR}/_ext/460521396/font5.o ${OBJECTDIR}/_ext/460521396/font8_2.o ${OBJECTDIR}/_ext/1979377065/lcd.o
POSSIBLE_DEPFILES=${OBJECTDIR}/src/controller.o.d ${OBJECTDIR}/src/hal.o.d ${OBJECTDIR}/src/main.o.d ${OBJECTDIR}/src/ui.o.d ${OBJECTDIR}/_ext/1979377065/font.o.d ${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o.d ${OBJECTDIR}/_ext/460521396/font5.o.d ${OBJECTDIR}/_ext/460521396/font8_2.o.d ${OBJECTDIR}/_ext/1979377065/lcd.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/src/controller.o ${OBJECTDIR}/src/hal.o ${OBJECTDIR}/src/main.o ${OBJECTDIR}/src/ui.o ${OBJECTDIR}/_ext/1979377065/font.o ${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o ${OBJECTDIR}/_ext/460521396/font5.o ${OBJECTDIR}/_ext/460521396/font8_2.o ${OBJECTDIR}/_ext/1979377065/lcd.o

# Source Files
SOURCEFILES=src/controller.c src/hal.c src/main.c src/ui.c ../../ARM_CLION/common_lib/display/font.c ../../ARM_CLION/common_lib/display/lcd_ssd1306.c ../../ARM_CLION/common_lib/display/fonts/font5.c ../../ARM_CLION/common_lib/display/fonts/font8_2.c ../../ARM_CLION/common_lib/display/lcd.c



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=ATtiny1614
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/src/controller.o: src/controller.c  .generated_files/flags/default/1b60bec058c80b46d50d13b5f744ce621ce1ebe4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/controller.o.d 
	@${RM} ${OBJECTDIR}/src/controller.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/controller.o.d" -MT "${OBJECTDIR}/src/controller.o.d" -MT ${OBJECTDIR}/src/controller.o -o ${OBJECTDIR}/src/controller.o src/controller.c 
	
${OBJECTDIR}/src/hal.o: src/hal.c  .generated_files/flags/default/dff7dc731574325c2443c5e105610fb35d18f822 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/hal.o.d 
	@${RM} ${OBJECTDIR}/src/hal.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/hal.o.d" -MT "${OBJECTDIR}/src/hal.o.d" -MT ${OBJECTDIR}/src/hal.o -o ${OBJECTDIR}/src/hal.o src/hal.c 
	
${OBJECTDIR}/src/main.o: src/main.c  .generated_files/flags/default/5aa931d629b10610459c066ab0f0c90f890472aa .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/main.o.d 
	@${RM} ${OBJECTDIR}/src/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/main.o.d" -MT "${OBJECTDIR}/src/main.o.d" -MT ${OBJECTDIR}/src/main.o -o ${OBJECTDIR}/src/main.o src/main.c 
	
${OBJECTDIR}/src/ui.o: src/ui.c  .generated_files/flags/default/d52e52e89ee44c2dbad9e8a016fd310f007437e7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/ui.o.d 
	@${RM} ${OBJECTDIR}/src/ui.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/ui.o.d" -MT "${OBJECTDIR}/src/ui.o.d" -MT ${OBJECTDIR}/src/ui.o -o ${OBJECTDIR}/src/ui.o src/ui.c 
	
${OBJECTDIR}/_ext/1979377065/font.o: ../../ARM_CLION/common_lib/display/font.c  .generated_files/flags/default/edf13b4701a1e78166bcb2b80b1329579bb6a2bb .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1979377065" 
	@${RM} ${OBJECTDIR}/_ext/1979377065/font.o.d 
	@${RM} ${OBJECTDIR}/_ext/1979377065/font.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1979377065/font.o.d" -MT "${OBJECTDIR}/_ext/1979377065/font.o.d" -MT ${OBJECTDIR}/_ext/1979377065/font.o -o ${OBJECTDIR}/_ext/1979377065/font.o ../../ARM_CLION/common_lib/display/font.c 
	
${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o: ../../ARM_CLION/common_lib/display/lcd_ssd1306.c  .generated_files/flags/default/774ec19e68a0a17d5027bad21bc52ff7370ce038 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1979377065" 
	@${RM} ${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o.d 
	@${RM} ${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o.d" -MT "${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o.d" -MT ${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o -o ${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o ../../ARM_CLION/common_lib/display/lcd_ssd1306.c 
	
${OBJECTDIR}/_ext/460521396/font5.o: ../../ARM_CLION/common_lib/display/fonts/font5.c  .generated_files/flags/default/1121d1936c5f119a82ff9669f17b7d7a7a630b0a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/460521396" 
	@${RM} ${OBJECTDIR}/_ext/460521396/font5.o.d 
	@${RM} ${OBJECTDIR}/_ext/460521396/font5.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/460521396/font5.o.d" -MT "${OBJECTDIR}/_ext/460521396/font5.o.d" -MT ${OBJECTDIR}/_ext/460521396/font5.o -o ${OBJECTDIR}/_ext/460521396/font5.o ../../ARM_CLION/common_lib/display/fonts/font5.c 
	
${OBJECTDIR}/_ext/460521396/font8_2.o: ../../ARM_CLION/common_lib/display/fonts/font8_2.c  .generated_files/flags/default/7bdf3faa328181dfc5dacc73042ae1ab003c20e9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/460521396" 
	@${RM} ${OBJECTDIR}/_ext/460521396/font8_2.o.d 
	@${RM} ${OBJECTDIR}/_ext/460521396/font8_2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/460521396/font8_2.o.d" -MT "${OBJECTDIR}/_ext/460521396/font8_2.o.d" -MT ${OBJECTDIR}/_ext/460521396/font8_2.o -o ${OBJECTDIR}/_ext/460521396/font8_2.o ../../ARM_CLION/common_lib/display/fonts/font8_2.c 
	
${OBJECTDIR}/_ext/1979377065/lcd.o: ../../ARM_CLION/common_lib/display/lcd.c  .generated_files/flags/default/4c55398d2136db0a34ba7b7ec08b2b69f73d46ff .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1979377065" 
	@${RM} ${OBJECTDIR}/_ext/1979377065/lcd.o.d 
	@${RM} ${OBJECTDIR}/_ext/1979377065/lcd.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1979377065/lcd.o.d" -MT "${OBJECTDIR}/_ext/1979377065/lcd.o.d" -MT ${OBJECTDIR}/_ext/1979377065/lcd.o -o ${OBJECTDIR}/_ext/1979377065/lcd.o ../../ARM_CLION/common_lib/display/lcd.c 
	
else
${OBJECTDIR}/src/controller.o: src/controller.c  .generated_files/flags/default/3b7fc831bca389bb45669ada95cf9e12b0fb888e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/controller.o.d 
	@${RM} ${OBJECTDIR}/src/controller.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/controller.o.d" -MT "${OBJECTDIR}/src/controller.o.d" -MT ${OBJECTDIR}/src/controller.o -o ${OBJECTDIR}/src/controller.o src/controller.c 
	
${OBJECTDIR}/src/hal.o: src/hal.c  .generated_files/flags/default/26663db196d7e35f2c85482f22d42f479dca3866 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/hal.o.d 
	@${RM} ${OBJECTDIR}/src/hal.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/hal.o.d" -MT "${OBJECTDIR}/src/hal.o.d" -MT ${OBJECTDIR}/src/hal.o -o ${OBJECTDIR}/src/hal.o src/hal.c 
	
${OBJECTDIR}/src/main.o: src/main.c  .generated_files/flags/default/72d17f4aff1446d34422ad6e46f10a53437938a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/main.o.d 
	@${RM} ${OBJECTDIR}/src/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/main.o.d" -MT "${OBJECTDIR}/src/main.o.d" -MT ${OBJECTDIR}/src/main.o -o ${OBJECTDIR}/src/main.o src/main.c 
	
${OBJECTDIR}/src/ui.o: src/ui.c  .generated_files/flags/default/f505d2a67669eefbeb263871a2ed19230bf4ba74 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/ui.o.d 
	@${RM} ${OBJECTDIR}/src/ui.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/ui.o.d" -MT "${OBJECTDIR}/src/ui.o.d" -MT ${OBJECTDIR}/src/ui.o -o ${OBJECTDIR}/src/ui.o src/ui.c 
	
${OBJECTDIR}/_ext/1979377065/font.o: ../../ARM_CLION/common_lib/display/font.c  .generated_files/flags/default/e41eeed67ff32b578400c441f307563107dd3004 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1979377065" 
	@${RM} ${OBJECTDIR}/_ext/1979377065/font.o.d 
	@${RM} ${OBJECTDIR}/_ext/1979377065/font.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1979377065/font.o.d" -MT "${OBJECTDIR}/_ext/1979377065/font.o.d" -MT ${OBJECTDIR}/_ext/1979377065/font.o -o ${OBJECTDIR}/_ext/1979377065/font.o ../../ARM_CLION/common_lib/display/font.c 
	
${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o: ../../ARM_CLION/common_lib/display/lcd_ssd1306.c  .generated_files/flags/default/d8c31b255825cf7384eebd6fe28fb4d51babeca4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1979377065" 
	@${RM} ${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o.d 
	@${RM} ${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o.d" -MT "${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o.d" -MT ${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o -o ${OBJECTDIR}/_ext/1979377065/lcd_ssd1306.o ../../ARM_CLION/common_lib/display/lcd_ssd1306.c 
	
${OBJECTDIR}/_ext/460521396/font5.o: ../../ARM_CLION/common_lib/display/fonts/font5.c  .generated_files/flags/default/ead2cd74ad25d409e33b0ec996d3688b8ca0ae8c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/460521396" 
	@${RM} ${OBJECTDIR}/_ext/460521396/font5.o.d 
	@${RM} ${OBJECTDIR}/_ext/460521396/font5.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/460521396/font5.o.d" -MT "${OBJECTDIR}/_ext/460521396/font5.o.d" -MT ${OBJECTDIR}/_ext/460521396/font5.o -o ${OBJECTDIR}/_ext/460521396/font5.o ../../ARM_CLION/common_lib/display/fonts/font5.c 
	
${OBJECTDIR}/_ext/460521396/font8_2.o: ../../ARM_CLION/common_lib/display/fonts/font8_2.c  .generated_files/flags/default/c9e715da14f5f6828430162d42da9bd63f17fe84 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/460521396" 
	@${RM} ${OBJECTDIR}/_ext/460521396/font8_2.o.d 
	@${RM} ${OBJECTDIR}/_ext/460521396/font8_2.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/460521396/font8_2.o.d" -MT "${OBJECTDIR}/_ext/460521396/font8_2.o.d" -MT ${OBJECTDIR}/_ext/460521396/font8_2.o -o ${OBJECTDIR}/_ext/460521396/font8_2.o ../../ARM_CLION/common_lib/display/fonts/font8_2.c 
	
${OBJECTDIR}/_ext/1979377065/lcd.o: ../../ARM_CLION/common_lib/display/lcd.c  .generated_files/flags/default/75031744e2d2e6c7b58f530536e7da7d9d77ee07 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1979377065" 
	@${RM} ${OBJECTDIR}/_ext/1979377065/lcd.o.d 
	@${RM} ${OBJECTDIR}/_ext/1979377065/lcd.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1979377065/lcd.o.d" -MT "${OBJECTDIR}/_ext/1979377065/lcd.o.d" -MT ${OBJECTDIR}/_ext/1979377065/lcd.o -o ${OBJECTDIR}/_ext/1979377065/lcd.o ../../ARM_CLION/common_lib/display/lcd.c 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"   -gdwarf-2 -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -gdwarf-3 -mno-const-data-in-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1
	@${RM} ${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.hex 
	
	
else
${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../ARM_CLION/common_lib/display" -Wall -gdwarf-3 -mno-const-data-in-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
	${MP_CC_DIR}/avr-objcopy -O ihex "${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "${DISTDIR}/Charger_Tiny1614.X.${IMAGE_TYPE}.hex"
	
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${OBJECTDIR}
	${RM} -r ${DISTDIR}

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(wildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
