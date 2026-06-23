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
ifeq "$(wildcard nbproject/Makefile-local-release.mk)" "nbproject/Makefile-local-release.mk"
include nbproject/Makefile-local-release.mk
endif
endif

# Environment
MKDIR=mkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=release
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
SOURCEFILES_QUOTED_IF_SPACED=src/hal.c src/main.c src/usart_handler.c ../../common_lib/rtc/rtc_func.c ../../common_lib/rtc/rtc_pcf8563.c ../lib/i2c_tiny1614.c src/rtc_handler.c src/sun_times.c src/vbat_handler.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/src/hal.o ${OBJECTDIR}/src/main.o ${OBJECTDIR}/src/usart_handler.o ${OBJECTDIR}/_ext/676297949/rtc_func.o ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o ${OBJECTDIR}/src/rtc_handler.o ${OBJECTDIR}/src/sun_times.o ${OBJECTDIR}/src/vbat_handler.o
POSSIBLE_DEPFILES=${OBJECTDIR}/src/hal.o.d ${OBJECTDIR}/src/main.o.d ${OBJECTDIR}/src/usart_handler.o.d ${OBJECTDIR}/_ext/676297949/rtc_func.o.d ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d ${OBJECTDIR}/src/rtc_handler.o.d ${OBJECTDIR}/src/sun_times.o.d ${OBJECTDIR}/src/vbat_handler.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/src/hal.o ${OBJECTDIR}/src/main.o ${OBJECTDIR}/src/usart_handler.o ${OBJECTDIR}/_ext/676297949/rtc_func.o ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o ${OBJECTDIR}/src/rtc_handler.o ${OBJECTDIR}/src/sun_times.o ${OBJECTDIR}/src/vbat_handler.o

# Source Files
SOURCEFILES=src/hal.c src/main.c src/usart_handler.c ../../common_lib/rtc/rtc_func.c ../../common_lib/rtc/rtc_pcf8563.c ../lib/i2c_tiny1614.c src/rtc_handler.c src/sun_times.c src/vbat_handler.c



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
	${MAKE}  -f nbproject/Makefile-release.mk ${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=ATtiny1614
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/src/hal.o: src/hal.c  .generated_files/flags/release/24261ea4021d3799dc0f1899fc2c67d98b924c9e .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/hal.o.d 
	@${RM} ${OBJECTDIR}/src/hal.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/hal.o.d" -MT "${OBJECTDIR}/src/hal.o.d" -MT ${OBJECTDIR}/src/hal.o -o ${OBJECTDIR}/src/hal.o src/hal.c 
	
${OBJECTDIR}/src/main.o: src/main.c  .generated_files/flags/release/8db98b33259e76ac82497bbc934d8702cb560755 .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/main.o.d 
	@${RM} ${OBJECTDIR}/src/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/main.o.d" -MT "${OBJECTDIR}/src/main.o.d" -MT ${OBJECTDIR}/src/main.o -o ${OBJECTDIR}/src/main.o src/main.c 
	
${OBJECTDIR}/src/usart_handler.o: src/usart_handler.c  .generated_files/flags/release/ed4ec0c7a761f5cdb65007a40deac48231c44677 .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/usart_handler.o.d 
	@${RM} ${OBJECTDIR}/src/usart_handler.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/usart_handler.o.d" -MT "${OBJECTDIR}/src/usart_handler.o.d" -MT ${OBJECTDIR}/src/usart_handler.o -o ${OBJECTDIR}/src/usart_handler.o src/usart_handler.c 
	
${OBJECTDIR}/_ext/676297949/rtc_func.o: ../../common_lib/rtc/rtc_func.c  .generated_files/flags/release/569ec9aa1befefa3b7c2b5d4a247f257289b8b9a .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/676297949" 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_func.o.d 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_func.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/676297949/rtc_func.o.d" -MT "${OBJECTDIR}/_ext/676297949/rtc_func.o.d" -MT ${OBJECTDIR}/_ext/676297949/rtc_func.o -o ${OBJECTDIR}/_ext/676297949/rtc_func.o ../../common_lib/rtc/rtc_func.c 
	
${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o: ../../common_lib/rtc/rtc_pcf8563.c  .generated_files/flags/release/a7a233b9472011b45d97f04513b115a55ed401f6 .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/676297949" 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d" -MT "${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d" -MT ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o -o ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o ../../common_lib/rtc/rtc_pcf8563.c 
	
${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o: ../lib/i2c_tiny1614.c  .generated_files/flags/release/8e09411bae60284cb16a137ac169d0e3f701cab .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360930230" 
	@${RM} ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d" -MT "${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d" -MT ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o -o ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o ../lib/i2c_tiny1614.c 
	
${OBJECTDIR}/src/rtc_handler.o: src/rtc_handler.c  .generated_files/flags/release/1b73d049b02f841ba57288c9560a08181030c967 .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/rtc_handler.o.d 
	@${RM} ${OBJECTDIR}/src/rtc_handler.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/rtc_handler.o.d" -MT "${OBJECTDIR}/src/rtc_handler.o.d" -MT ${OBJECTDIR}/src/rtc_handler.o -o ${OBJECTDIR}/src/rtc_handler.o src/rtc_handler.c 
	
${OBJECTDIR}/src/sun_times.o: src/sun_times.c  .generated_files/flags/release/cf10def37627ef30f8db57ff9652fe7d6faa945a .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/sun_times.o.d 
	@${RM} ${OBJECTDIR}/src/sun_times.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/sun_times.o.d" -MT "${OBJECTDIR}/src/sun_times.o.d" -MT ${OBJECTDIR}/src/sun_times.o -o ${OBJECTDIR}/src/sun_times.o src/sun_times.c 
	
${OBJECTDIR}/src/vbat_handler.o: src/vbat_handler.c  .generated_files/flags/release/1ef528173a3a5d71b40150e41171882dba045c1a .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/vbat_handler.o.d 
	@${RM} ${OBJECTDIR}/src/vbat_handler.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/vbat_handler.o.d" -MT "${OBJECTDIR}/src/vbat_handler.o.d" -MT ${OBJECTDIR}/src/vbat_handler.o -o ${OBJECTDIR}/src/vbat_handler.o src/vbat_handler.c 
	
else
${OBJECTDIR}/src/hal.o: src/hal.c  .generated_files/flags/release/f6866f87d6ccfcdf5bafde49710812d4408fd80e .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/hal.o.d 
	@${RM} ${OBJECTDIR}/src/hal.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/hal.o.d" -MT "${OBJECTDIR}/src/hal.o.d" -MT ${OBJECTDIR}/src/hal.o -o ${OBJECTDIR}/src/hal.o src/hal.c 
	
${OBJECTDIR}/src/main.o: src/main.c  .generated_files/flags/release/e1b8408c7ceb448136f84acb926f18311d161c31 .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/main.o.d 
	@${RM} ${OBJECTDIR}/src/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/main.o.d" -MT "${OBJECTDIR}/src/main.o.d" -MT ${OBJECTDIR}/src/main.o -o ${OBJECTDIR}/src/main.o src/main.c 
	
${OBJECTDIR}/src/usart_handler.o: src/usart_handler.c  .generated_files/flags/release/22ac915a5e77595ffac1d79ab854e968fe79955d .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/usart_handler.o.d 
	@${RM} ${OBJECTDIR}/src/usart_handler.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/usart_handler.o.d" -MT "${OBJECTDIR}/src/usart_handler.o.d" -MT ${OBJECTDIR}/src/usart_handler.o -o ${OBJECTDIR}/src/usart_handler.o src/usart_handler.c 
	
${OBJECTDIR}/_ext/676297949/rtc_func.o: ../../common_lib/rtc/rtc_func.c  .generated_files/flags/release/33ea8029b92b79b1e5a23dd44b0cd2eb3b87136c .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/676297949" 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_func.o.d 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_func.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/676297949/rtc_func.o.d" -MT "${OBJECTDIR}/_ext/676297949/rtc_func.o.d" -MT ${OBJECTDIR}/_ext/676297949/rtc_func.o -o ${OBJECTDIR}/_ext/676297949/rtc_func.o ../../common_lib/rtc/rtc_func.c 
	
${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o: ../../common_lib/rtc/rtc_pcf8563.c  .generated_files/flags/release/237217521a57e0e2405cf7c04058ba84cd087d .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/676297949" 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d 
	@${RM} ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d" -MT "${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o.d" -MT ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o -o ${OBJECTDIR}/_ext/676297949/rtc_pcf8563.o ../../common_lib/rtc/rtc_pcf8563.c 
	
${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o: ../lib/i2c_tiny1614.c  .generated_files/flags/release/adad124cafc02bcb22cf55a18fa373c20309812d .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1360930230" 
	@${RM} ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d 
	@${RM} ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d" -MT "${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o.d" -MT ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o -o ${OBJECTDIR}/_ext/1360930230/i2c_tiny1614.o ../lib/i2c_tiny1614.c 
	
${OBJECTDIR}/src/rtc_handler.o: src/rtc_handler.c  .generated_files/flags/release/63bc91a42865197e924b6dab90648e8d0bcd04b3 .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/rtc_handler.o.d 
	@${RM} ${OBJECTDIR}/src/rtc_handler.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/rtc_handler.o.d" -MT "${OBJECTDIR}/src/rtc_handler.o.d" -MT ${OBJECTDIR}/src/rtc_handler.o -o ${OBJECTDIR}/src/rtc_handler.o src/rtc_handler.c 
	
${OBJECTDIR}/src/sun_times.o: src/sun_times.c  .generated_files/flags/release/6b63bc7e62a4a374f1fe0e80ec4e1ccbc3e5fc01 .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/sun_times.o.d 
	@${RM} ${OBJECTDIR}/src/sun_times.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/sun_times.o.d" -MT "${OBJECTDIR}/src/sun_times.o.d" -MT ${OBJECTDIR}/src/sun_times.o -o ${OBJECTDIR}/src/sun_times.o src/sun_times.c 
	
${OBJECTDIR}/src/vbat_handler.o: src/vbat_handler.c  .generated_files/flags/release/53c009f3384f0c7176dbfb2770adaf90115cf783 .generated_files/flags/release/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/src" 
	@${RM} ${OBJECTDIR}/src/vbat_handler.o.d 
	@${RM} ${OBJECTDIR}/src/vbat_handler.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -DXPRJ_release=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mno-const-data-in-progmem     -MD -MP -MF "${OBJECTDIR}/src/vbat_handler.o.d" -MT "${OBJECTDIR}/src/vbat_handler.o.d" -MT ${OBJECTDIR}/src/vbat_handler.o -o ${OBJECTDIR}/src/vbat_handler.o src/vbat_handler.c 
	
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
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_release=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -D__MPLAB_DEBUGGER_PK5=1 -gdwarf-2 -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -gdwarf-3 -mno-const-data-in-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_PK5=1
	@${RM} ${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.hex 
	
	
else
${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.map  -DXPRJ_release=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"src" -I"../../common_lib/rtc" -I"../lib" -Wall -gdwarf-3 -mno-const-data-in-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Nightlight_Tiny1614.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
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
