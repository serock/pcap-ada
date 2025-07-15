--  SPDX-License-Identifier: BSD-3-Clause
-----------------------------------------------------------------------------
--  Copyright (c) 2024-2025 John Serock
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are
--  met:
--
--  1. Redistributions of source code must retain the above copyright notice,
--     this list of conditions and the following disclaimer.
--
--  2. Redistributions in binary form must reproduce the above copyright
--     notice, this list of conditions and the following disclaimer in the
--     documentation and/or other materials provided with the distribution.
--
--  3. Neither the name of the copyright holder nor the names of its
--     contributors may be used to endorse or promote products derived from
--     this software without specific prior written permission.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
--  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
--  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
--  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
--  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
--  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
--  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
--  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
--  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-----------------------------------------------------------------------------
package Pcap.Datalink_Constants is

   DLT_NULL                       : constant Datalink_Type := 0;
   DLT_EN10MB                     : constant Datalink_Type := 1;
   DLT_EN3MB                      : constant Datalink_Type := 2;
   DLT_AX25                       : constant Datalink_Type := 3;
   DLT_PRONET                     : constant Datalink_Type := 4;
   DLT_CHAOS                      : constant Datalink_Type := 5;
   DLT_IEEE802                    : constant Datalink_Type := 6;
   DLT_ARCNET                     : constant Datalink_Type := 7;
   DLT_SLIP                       : constant Datalink_Type := 8;
   DLT_PPP                        : constant Datalink_Type := 9;
   DLT_FDDI                       : constant Datalink_Type := 10;
   DLT_ATM_RFC1483                : constant Datalink_Type := 11;
#if PCAP_ADA_OS_KIND = "openbsd"
   DLT_LOOP                       : constant Datalink_Type := 12;
#else
   DLT_RAW                        : constant Datalink_Type := 12;
#end if;
#if PCAP_ADA_OS_KIND = "freebsd"
   DLT_SLIP_BSDOS                 : constant Datalink_Type := 13;
#elsif PCAP_ADA_OS_KIND = "openbsd"
   DLT_ENC                        : constant Datalink_Type := 13;
#end if;
#if PCAP_ADA_OS_KIND = "freebsd"
   DLT_PPP_BSDOS                  : constant Datalink_Type := 14;
#elsif PCAP_ADA_OS_KIND = "openbsd"
   DLT_RAW                        : constant Datalink_Type := 14;
#end if;
#if not PCAP_ADA_OS_KIND = "freebsd"
   DLT_SLIP_BSDOS                 : constant Datalink_Type := 15;
   DLT_PPP_BSDOS                  : constant Datalink_Type := 16;
#end if;
#if PCAP_ADA_OS_KIND = "macos" or PCAP_ADA_OS_KIND = "openbsd"
   DLT_PFSYNC                     : constant Datalink_Type := 18;
#end if;
   DLT_ATM_CLIP                   : constant Datalink_Type := 19;
   DLT_REDBACK_SMARTEDGE          : constant Datalink_Type := 32;
   DLT_PPP_SERIAL                 : constant Datalink_Type := 50;
   DLT_PPP_ETHER                  : constant Datalink_Type := 51;
   DLT_SYMANTEC_FIREWALL          : constant Datalink_Type := 99;
   DLT_C_HDLC                     : constant Datalink_Type := 104;
   DLT_CHDLC                      : constant Datalink_Type := DLT_C_HDLC;
   DLT_IEEE802_11                 : constant Datalink_Type := 105;
   DLT_FRELAY                     : constant Datalink_Type := 107;
   DLT_LOOP                       : constant Datalink_Type := 108;
   DLT_ENC                        : constant Datalink_Type := 109;
   DLT_LINUX_SLL                  : constant Datalink_Type := 113;
   DLT_LTALK                      : constant Datalink_Type := 114;
   DLT_ECONET                     : constant Datalink_Type := 115;
   DLT_IPFILTER                   : constant Datalink_Type := 116;
   DLT_PFLOG                      : constant Datalink_Type := 117;
   DLT_CISCO_IOS                  : constant Datalink_Type := 118;
   DLT_PRISM_HEADER               : constant Datalink_Type := 119;
   DLT_AIRONET_HEADER             : constant Datalink_Type := 120;
#if PCAP_ADA_OS_KIND = "freebsd"
   DLT_PFSYNC                     : constant Datalink_Type := 121;
#else
   DLT_HHDLC                      : constant Datalink_Type := 121;
#end if;
   DLT_IP_OVER_FC                 : constant Datalink_Type := 122;
   DLT_SUNATM                     : constant Datalink_Type := 123;
   DLT_RIO                        : constant Datalink_Type := 124;
   DLT_PCI_EXP                    : constant Datalink_Type := 125;
   DLT_AURORA                     : constant Datalink_Type := 126;
   DLT_IEEE802_11_RADIO           : constant Datalink_Type := 127;
   DLT_TZSP                       : constant Datalink_Type := 128;
   DLT_ARCNET_LINUX               : constant Datalink_Type := 129;
   DLT_JUNIPER_MLPPP              : constant Datalink_Type := 130;
   DLT_JUNIPER_MLFR               : constant Datalink_Type := 131;
   DLT_JUNIPER_ES                 : constant Datalink_Type := 132;
   DLT_JUNIPER_GGSN               : constant Datalink_Type := 133;
   DLT_JUNIPER_MFR                : constant Datalink_Type := 134;
   DLT_JUNIPER_ATM2               : constant Datalink_Type := 135;
   DLT_JUNIPER_SERVICES           : constant Datalink_Type := 136;
   DLT_JUNIPER_ATM1               : constant Datalink_Type := 137;
   DLT_APPLE_IP_OVER_IEEE1394     : constant Datalink_Type := 138;
   DLT_MTP2_WITH_PHDR             : constant Datalink_Type := 139;
   DLT_MTP2                       : constant Datalink_Type := 140;
   DLT_MTP3                       : constant Datalink_Type := 141;
   DLT_SCCP                       : constant Datalink_Type := 142;
   DLT_DOCSIS                     : constant Datalink_Type := 143;
   DLT_LINUX_IRDA                 : constant Datalink_Type := 144;
   DLT_IBM_SP                     : constant Datalink_Type := 145;
   DLT_IBM_SN                     : constant Datalink_Type := 146;
   DLT_USER0                      : constant Datalink_Type := 147;
   DLT_USER1                      : constant Datalink_Type := 148;
   DLT_USER2                      : constant Datalink_Type := 149;
#if PCAP_ADA_OS_KIND = "macos"
   DLT_PKTAP                      : constant Datalink_Type := DLT_USER2;
#end if;
   DLT_USER3                      : constant Datalink_Type := 150;
   DLT_USER4                      : constant Datalink_Type := 151;
   DLT_USER5                      : constant Datalink_Type := 152;
   DLT_USER6                      : constant Datalink_Type := 153;
   DLT_USER7                      : constant Datalink_Type := 154;
   DLT_USER8                      : constant Datalink_Type := 155;
   DLT_USER9                      : constant Datalink_Type := 156;
   DLT_USER10                     : constant Datalink_Type := 157;
   DLT_USER11                     : constant Datalink_Type := 158;
   DLT_USER12                     : constant Datalink_Type := 159;
   DLT_USER13                     : constant Datalink_Type := 160;
   DLT_USER14                     : constant Datalink_Type := 161;
   DLT_USER15                     : constant Datalink_Type := 162;
   DLT_IEEE802_11_RADIO_AVS       : constant Datalink_Type := 163;
   DLT_JUNIPER_MONITOR            : constant Datalink_Type := 164;
   DLT_BACNET_MS_TP               : constant Datalink_Type := 165;
   DLT_PPP_PPPD                   : constant Datalink_Type := 166;
   DLT_LINUX_PPP_WITHDIRECTION    : constant Datalink_Type := DLT_PPP_PPPD;
   DLT_PPP_WITH_DIRECTION         : constant Datalink_Type := DLT_PPP_PPPD;
   DLT_JUNIPER_PPPOE              : constant Datalink_Type := 167;
   DLT_JUNIPER_PPPOE_ATM          : constant Datalink_Type := 168;
   DLT_GPRS_LLC                   : constant Datalink_Type := 169;
   DLT_GPF_T                      : constant Datalink_Type := 170;
   DLT_GPF_F                      : constant Datalink_Type := 171;
   DLT_GCOM_T1E1                  : constant Datalink_Type := 172;
   DLT_GCOM_SERIAL                : constant Datalink_Type := 173;
   DLT_JUNIPER_PIC_PEER           : constant Datalink_Type := 174;
   DLT_ERF_ETH                    : constant Datalink_Type := 175;
   DLT_ERF_POS                    : constant Datalink_Type := 176;
   DLT_LINUX_LAPD                 : constant Datalink_Type := 177;
   DLT_JUNIPER_ETHER              : constant Datalink_Type := 178;
   DLT_JUNIPER_PPP                : constant Datalink_Type := 179;
   DLT_JUNIPER_FRELAY             : constant Datalink_Type := 180;
   DLT_JUNIPER_CHDLC              : constant Datalink_Type := 181;
   DLT_MFR                        : constant Datalink_Type := 182;
   DLT_JUNIPER_VP                 : constant Datalink_Type := 183;
   DLT_A429                       : constant Datalink_Type := 184;
   DLT_A653_ICM                   : constant Datalink_Type := 185;
   DLT_USB_FREEBSD                : constant Datalink_Type := 186;
   DLT_USB                        : constant Datalink_Type := 186;
   DLT_BLUETOOTH_HCI_H4           : constant Datalink_Type := 187;
   DLT_IEEE802_16_MAC_CPS         : constant Datalink_Type := 188;
   DLT_USB_LINUX                  : constant Datalink_Type := 189;
   DLT_CAN20B                     : constant Datalink_Type := 190;
   DLT_IEEE802_15_4_LINUX         : constant Datalink_Type := 191;
   DLT_PPI                        : constant Datalink_Type := 192;
   DLT_IEEE802_16_MAC_CPS_RADIO   : constant Datalink_Type := 193;
   DLT_JUNIPER_ISM                : constant Datalink_Type := 194;
   DLT_IEEE802_15_4               : constant Datalink_Type := 195;
   DLT_SITA                       : constant Datalink_Type := 196;
   DLT_ERF                        : constant Datalink_Type := 197;
   DLT_RAIF1                      : constant Datalink_Type := 198;
   DLT_IPMB                       : constant Datalink_Type := 199;
   DLT_JUNIPER_ST                 : constant Datalink_Type := 200;
   DLT_BLUETOOTH_HCI_H4_WITH_PHDR : constant Datalink_Type := 201;
   DLT_AX25_KISS                  : constant Datalink_Type := 202;
   DLT_LAPD                       : constant Datalink_Type := 203;
   DLT_PPP_WITH_DIR               : constant Datalink_Type := 204;
   DLT_C_HDLC_WITH_DIR            : constant Datalink_Type := 205;
   DLT_FRELAY_WITH_DIR            : constant Datalink_Type := 206;
   DLT_LAPB_WITH_DIR              : constant Datalink_Type := 207;
   DLT_IPMB_LINUX                 : constant Datalink_Type := 209;
   DLT_FLEXRAY                    : constant Datalink_Type := 210;
   DLT_MOST                       : constant Datalink_Type := 211;
   DLT_LIN                        : constant Datalink_Type := 212;
   DLT_X2E_SERIAL                 : constant Datalink_Type := 213;
   DLT_X2E_XORAYA                 : constant Datalink_Type := 214;
   DLT_IEEE802_15_4_NONASK_PHY    : constant Datalink_Type := 215;
   DLT_LINUX_EVDEV                : constant Datalink_Type := 216;
   DLT_GSMTAP_UM                  : constant Datalink_Type := 217;
   DLT_GSMTAP_ABIS                : constant Datalink_Type := 218;
   DLT_MPLS                       : constant Datalink_Type := 219;
   DLT_USB_LINUX_MMAPPED          : constant Datalink_Type := 220;
   DLT_DECT                       : constant Datalink_Type := 221;
   DLT_AOS                        : constant Datalink_Type := 222;
   DLT_WIHART                     : constant Datalink_Type := 223;
   DLT_FC_2                       : constant Datalink_Type := 224;
   DLT_FC_2_WITH_FRAME_DELIMS     : constant Datalink_Type := 225;
   DLT_IPNET                      : constant Datalink_Type := 226;
   DLT_CAN_SOCKETCAN              : constant Datalink_Type := 227;
   DLT_IPV4                       : constant Datalink_Type := 228;
   DLT_IPV6                       : constant Datalink_Type := 229;
   DLT_IEEE802_15_4_NOFCS         : constant Datalink_Type := 230;
   DLT_DBUS                       : constant Datalink_Type := 231;
   DLT_JUNIPER_VS                 : constant Datalink_Type := 232;
   DLT_JUNIPER_SRX_E2E            : constant Datalink_Type := 233;
   DLT_JUNIPER_FIBRECHANNEL       : constant Datalink_Type := 234;
   DLT_DVB_CI                     : constant Datalink_Type := 235;
   DLT_MUX27010                   : constant Datalink_Type := 236;
   DLT_STANAG_5066_D_PDU          : constant Datalink_Type := 237;
   DLT_JUNIPER_ATM_CEMIC          : constant Datalink_Type := 238;
   DLT_NFLOG                      : constant Datalink_Type := 239;
   DLT_NETANALYZER                : constant Datalink_Type := 240;
   DLT_NETANALYZER_TRANSPARENT    : constant Datalink_Type := 241;
   DLT_IPOIB                      : constant Datalink_Type := 242;
   DLT_MPEG_2_TS                  : constant Datalink_Type := 243;
   DLT_NG40                       : constant Datalink_Type := 244;
   DLT_NFC_LLCP                   : constant Datalink_Type := 245;
#if not (PCAP_ADA_OS_KIND = "freebsd" or PCAP_ADA_OS_KIND = "macos" or PCAP_ADA_OS_KIND = "openbsd")
   DLT_PFSYNC                     : constant Datalink_Type := 246;
#end if;
   DLT_INFINIBAND                 : constant Datalink_Type := 247;
   DLT_SCTP                       : constant Datalink_Type := 248;
   DLT_USBPCAP                    : constant Datalink_Type := 249;
   DLT_RTAC_SERIAL                : constant Datalink_Type := 250;
   DLT_BLUETOOTH_LE_LL            : constant Datalink_Type := 251;
   DLT_WIRESHARK_UPPER_PDU        : constant Datalink_Type := 252;
   DLT_NETLINK                    : constant Datalink_Type := 253;
   DLT_BLUETOOTH_LINUX_MONITOR    : constant Datalink_Type := 254;
   DLT_BLUETOOTH_BREDR_BB         : constant Datalink_Type := 255;
   DLT_BLUETOOTH_LE_LL_WITH_PHDR  : constant Datalink_Type := 256;
   DLT_PROFIBUS_DL                : constant Datalink_Type := 257;
#if not PCAP_ADA_OS_KIND = "macos"
   DLT_PKTAP                      : constant Datalink_Type := 258;
#end if;
   DLT_EPON                       : constant Datalink_Type := 259;
   DLT_IPMI_HPM_2                 : constant Datalink_Type := 260;
   DLT_ZWAVE_R1_R2                : constant Datalink_Type := 261;
   DLT_ZWAVE_R3                   : constant Datalink_Type := 262;
   DLT_WATTSTOPPER_DLM            : constant Datalink_Type := 263;
   DLT_ISO_14443                  : constant Datalink_Type := 264;
   DLT_RDS                        : constant Datalink_Type := 265;

end Pcap.Datalink_Constants;
