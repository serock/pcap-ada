--  SPDX-License-Identifier: BSD-3-Clause
-----------------------------------------------------------------------------
--  Copyright (c) 2024 John Serock
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
private with Interfaces.C.Strings;

package Pcap is

private

   PCAP_ERRBUF_SIZE : constant := 256;

   type pcap_t is null record;

   type pcap_t_ptr is access pcap_t;

   function pcap_create (source : Interfaces.C.Strings.chars_ptr;
                         errbuf : Interfaces.C.Strings.chars_ptr) return pcap_t_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_create";

   procedure pcap_close (p : pcap_t_ptr)
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_close";

   function pcap_datalink_name_to_val (name : Interfaces.C.Strings.chars_ptr) return Interfaces.C.int
   with Import => True,
        Convention => C,
        External_Name => "pcap_datalink_name_to_val";

   function pcap_datalink_val_to_name (dlt : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import => True,
        Convention => C,
        External_Name => "pcap_datalink_val_to_name";

   function pcap_datalink_val_to_description (dlt : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import => True,
        Convention => C,
        External_Name => "pcap_datalink_val_to_description";

   function pcap_lib_version return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_lib_version";

   function pcap_open_dead (linktype : Interfaces.C.int;
                            snaplen  : Interfaces.C.int) return pcap_t_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_open_dead";

   function pcap_open_dead_with_tstamp_precision (linktype  : Interfaces.C.int;
                                                  snaplen   : Interfaces.C.int;
                                                  precision : Interfaces.C.unsigned) return pcap_t_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_open_dead_with_tstamp_precision";

end Pcap;
