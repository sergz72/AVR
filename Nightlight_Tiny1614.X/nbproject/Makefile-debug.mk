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
ifeq "$(wildcard nbproject/Makefile-local-debug.mk)" "nbproject/Makefile-local-debug.mk"
include nbproject/Makefile-local-debug.mk
endif
endif

# Environment
MKDIR=mkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=debug
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
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
SOURCEFILES_QUOTED_IF_SPACED=src/hal.c src/main.c src/usart_handler.c ../../common_lib/rtc/rtc_func.c ../../common_lib/rtc/rtc_pcf8563.c ../lib/i2c_tiny1614.c src/rtc_handler.c src/sun_times.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/src/hal.o ${OBJECTDIR}/src/main.o ${OBJECTDIR}/src/usart_handler.o ${OBJECTDIR}/_ext/676297949/rtc_func.o ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o ${OBJECTDIR}/src/rtc_handler.o ${OBJECTDIR}/src/sun_times.o
POSSIBLE_DEPFILES=${OBJECTDIR}/src/hal.o.d ${OBJECTDIR}/src/main.o.d ${OBJECTDIR}/src/usart_handler.o.d ${OBJECTDIR}/_ext/676297949/rtc_func.o.d ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d ${OBJECTDIR}/src/rtc_handler.o.d ${OBJECTDIR}/src/sun_times.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/src/hal.o ${OBJECTDIR}/src/main.o ${OBJECTDIR}/src/usart_handler.o ${OBJECTDIR}/_ext/676297949/rtc_func.o ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o ${OBJECTDIR}/src/rtc_handler.o ${OBJECTDIR}/src/sun_times.o

# Source Files
SOURCEFILES=src/hal.c src/main.c src/usart_handler.c ../../common_lib/rtc/rtc_func.c ../../common_lib/rtc/rtc_pcf8563.c ../lib/i2c_tiny1614.c src/rtc_handler.c src/sun_times.c



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
	${MAKE}  -f nbproject/Makefile-debug.mk ${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=ATtiny1614
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/src/hal.o: src/hal.c  .generated_files/flags/debug/b99c204c3f90b45d0624fd4560450bb5bbe7fabd .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/hal.o.d 
	@${RM} ${OBJECTDIR}/src/hal.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/hal.o.d" -MT "${OBJECTDIR}/src/hal.o.d" -MT ${OBJECTDIR}/src/hal.o -o ${OBJECTDIR}/src/hal.o src/hal.c 
	
${OBJECTDIR}/src/main.o: src/main.c  .generated_files/flags/debug/bb8cc16c0cb921e3ecd9a899ba1b64e2ab08c038 .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/main.o.d 
	@${RM} ${OBJECTDIR}/src/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/main.o.d" -MT "${OBJECTDIR}/src/main.o.d" -MT ${OBJECTDIR}/src/main.o -o ${OBJECTDIR}/src/main.o src/main.c 
	
${OBJECTDIR}/src/usart_handler.o: src/usart_handler.c  .generated_files/flags/debug/39830a64acde6d037e25494e61cdd4a08a083f14 .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/usart_handler.o.d 
	@${RM} ${OBJECTDIR}/src/usart_handler.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/usart_handler.o.d" -MT "${OBJECTDIR}/src/usart_handler.o.d" -MT ${OBJECTDIR}/src/usart_handler.o -o ${OBJECTDIR}/src/usart_handler.o src/usart_handler.c 
	
${OBJECTDIR}/_ext/676297949/rtc_func.o: ../../common_lib/rtc/rtc_func.c  .generated_files/flags/debug/ee3fa190961427b8b95e852c1401d728e0dfabc9 .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/676297949" 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_func.o.d 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_func.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/676297949/rtc_func.o.d" -MT "${OBJECTDIR}/_ext/676297949/rtc_func.o.d" -MT ${OBJECTDIR}/_ext/676297949/rtc_func.o -o ${OBJECTDIR}/_ext/676297949/rtc_func.o ../../common_lib/rtc/rtc_func.c 
	
${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o: ../../common_lib/rtc/rtc_pcf8563.c  .generated_files/flags/debug/6cd48691c6a4c4b689d20f5c122245fba11ba35 .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/676297949" 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d" -MT "${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d" -MT ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o -o ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o ../../common_lib/rtc/rtc_pcf8563.c 
	
${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o: ../lib/i2c_tiny1614.c  .generated_files/flags/debug/aa1c53eabadd3780b999bfe39d9a0bc9f87c79b6 .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360930230" 
	@${RM} ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d" -MT "${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d" -MT ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o -o ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o ../lib/i2c_tiny1614.c 
	
${OBJECTDIR}/src/rtc_handler.o: src/rtc_handler.c  .generated_files/flags/debug/921b36a35caf3cdf9e2b20940158da8aee8a0a55 .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/rtc_handler.o.d 
	@${RM} ${OBJECTDIR}/src/rtc_handler.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/rtc_handler.o.d" -MT "${OBJECTDIR}/src/rtc_handler.o.d" -MT ${OBJECTDIR}/src/rtc_handler.o -o ${OBJECTDIR}/src/rtc_handler.o src/rtc_handler.c 
	
${OBJECTDIR}/src/sun_times.o: src/sun_times.c  .generated_files/flags/debug/affc53032108d69409a6e9dec4cba6b759507a66 .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/sun_times.o.d 
	@${RM} ${OBJECTDIR}/src/sun_times.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/sun_times.o.d" -MT "${OBJECTDIR}/src/sun_times.o.d" -MT ${OBJECTDIR}/src/sun_times.o -o ${OBJECTDIR}/src/sun_times.o src/sun_times.c 
	
else
${OBJECTDIR}/src/hal.o: src/hal.c  .generated_files/flags/debug/690a997bdd571fb56b766fc59018cf732e84592e .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/hal.o.d 
	@${RM} ${OBJECTDIR}/src/hal.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/hal.o.d" -MT "${OBJECTDIR}/src/hal.o.d" -MT ${OBJECTDIR}/src/hal.o -o ${OBJECTDIR}/src/hal.o src/hal.c 
	
${OBJECTDIR}/src/main.o: src/main.c  .generated_files/flags/debug/483b92721248e6b088b70230dfa48f5b0ff85a03 .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/main.o.d 
	@${RM} ${OBJECTDIR}/src/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/main.o.d" -MT "${OBJECTDIR}/src/main.o.d" -MT ${OBJECTDIR}/src/main.o -o ${OBJECTDIR}/src/main.o src/main.c 
	
${OBJECTDIR}/src/usart_handler.o: src/usart_handler.c  .generated_files/flags/debug/6cd21449fb2d41bc6b541e6bdf1c2e5c7a291513 .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/usart_handler.o.d 
	@${RM} ${OBJECTDIR}/src/usart_handler.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/usart_handler.o.d" -MT "${OBJECTDIR}/src/usart_handler.o.d" -MT ${OBJECTDIR}/src/usart_handler.o -o ${OBJECTDIR}/src/usart_handler.o src/usart_handler.c 
	
${OBJECTDIR}/_ext/676297949/rtc_func.o: ../../common_lib/rtc/rtc_func.c  .generated_files/flags/debug/298a38dd4e3045d56449a7664d878bab70ab5ec6 .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/676297949" 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_func.o.d 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_func.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/676297949/rtc_func.o.d" -MT "${OBJECTDIR}/_ext/676297949/rtc_func.o.d" -MT ${OBJECTDIR}/_ext/676297949/rtc_func.o -o ${OBJECTDIR}/_ext/676297949/rtc_func.o ../../common_lib/rtc/rtc_func.c 
	
${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o: ../../common_lib/rtc/rtc_pcf8563.c  .generated_files/flags/debug/d9a4be74ca926ce01757803be86ea04cc0915350 .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/676297949" 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d" -MT "${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d" -MT ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o -o ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o ../../common_lib/rtc/rtc_pcf8563.c 
	
${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o: ../lib/i2c_tiny1614.c  .generated_files/flags/debug/23479cd94dcb9136e9a118afdd475973c9a0a953 .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360930230" 
	@${RM} ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d" -MT "${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d" -MT ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o -o ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o ../lib/i2c_tiny1614.c 
	
${OBJECTDIR}/src/rtc_handler.o: src/rtc_handler.c  .generated_files/flags/debug/59e615e0a69b5f221271ddee4a70eb64bdc8553c .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/rtc_handler.o.d 
	@${RM} ${OBJECTDIR}/src/rtc_handler.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/rtc_handler.o.d" -MT "${OBJECTDIR}/src/rtc_handler.o.d" -MT ${OBJECTDIR}/src/rtc_handler.o -o ${OBJECTDIR}/src/rtc_handler.o src/rtc_handler.c 
	
${OBJECTDIR}/src/sun_times.o: src/sun_times.c  .generated_files/flags/debug/cf7fda4d6502ffaa8e406c4736dec0d72d52848f .generated_files/flags/debug/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/sun_times.o.d 
	@${RM} ${OBJECTDIR}/src/sun_times.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_debug=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/sun_times.o.d" -MT "${OBJECTDIR}/src/sun_times.o.d" -MT ${OBJECTDIR}/src/sun_times.o -o ${OBJECTDIR}/src/sun_times.o src/sun_times.c 
	
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
${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_debug=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2 -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -gdwarf-3 -mno-const-data-in-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_PK5=1
	@${RM} ${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.hex 
	
	
else
${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.map  -DXPRJ_debug=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -gdwarf-3 -mno-const-data-in-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
	${MP_CC_DIR}/avr-objcopy -O ihex "${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.hex"
	
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
