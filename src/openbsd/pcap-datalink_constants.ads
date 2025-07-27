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
   DLT_LOOP                       : constant Datalink_Type := 12;
   DLT_ENC                        : constant Datalink_Type := 13;
   DLT_RAW                        : constant Datalink_Type := 14;
   DLT_SLIP_BSDOS                 : constant Datalink_Type := 15;
   DLT_PPP_BSDOS                  : constant Datalink_Type := 16;
   DLT_PFSYNC                     : constant Datalink_Type := 18;
   DLT_PPP_SERIAL                 : constant Datalink_Type := 50;
   DLT_PPP_ETHER                  : constant Datalink_Type := 51;
   DLT_C_HDLC                     : constant Datalink_Type := 104;
   DLT_IEEE802_11                 : constant Datalink_Type := 105;
   DLT_PFLOG                      : constant Datalink_Type := 117;
   DLT_IEEE802_11_RADIO           : constant Datalink_Type := 127;
   DLT_USER0                      : constant Datalink_Type := 147;
   DLT_USER1                      : constant Datalink_Type := 148;
   DLT_USER2                      : constant Datalink_Type := 149;
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
   DLT_MPLS                       : constant Datalink_Type := 219;
   DLT_USBPCAP                    : constant Datalink_Type := 249;

end Pcap.Datalink_Constants;
