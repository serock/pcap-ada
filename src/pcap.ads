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
private with Interfaces.C.Strings;
private with System;

package Pcap is

   PCAP_ERRBUF_SIZE : constant := 256;

private

   type pcap_t is null record;

   type pcap_t_ptr is access pcap_t;

   type pcap_direction_t is
     (PCAP_D_INOUT,
      PCAP_D_IN,
      PCAP_D_OUT)
   with Convention => C;

   type pcap_stat is
      record
         ps_recv   : aliased Interfaces.C.unsigned;
         ps_drop   : aliased Interfaces.C.unsigned;
         ps_ifdrop : aliased Interfaces.C.unsigned;
      end record
   with Convention => C;

   function pcap_activate (p : pcap_t_ptr) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_activate";

   procedure pcap_breakloop (p : pcap_t_ptr)
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_breakloop";

   function pcap_can_set_rfmon (p : pcap_t_ptr) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_can_set_rfmon";

   function pcap_create (source : Interfaces.C.Strings.chars_ptr;
                         errbuf : Interfaces.C.Strings.chars_ptr) return pcap_t_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_create";

   procedure pcap_close (p : pcap_t_ptr)
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_close";

   function pcap_datalink (p : pcap_t_ptr) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_datalink";

   function pcap_datalink_name_to_val (name : Interfaces.C.Strings.chars_ptr) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_datalink_name_to_val";

   function pcap_datalink_val_to_name (dlt : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_datalink_val_to_name";

   function pcap_datalink_val_to_description (dlt : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_datalink_val_to_description";

   procedure pcap_free_datalinks (dlt_list : System.Address)
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_free_datalinks";

   procedure pcap_free_tstamp_types (tstamp_types : System.Address)
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_free_tstamp_types";

   function pcap_get_tstamp_precision (p : pcap_t_ptr) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_get_tstamp_precision";

   function pcap_geterr (p : pcap_t_ptr) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_geterr";

   function pcap_getnonblock (p      : pcap_t_ptr;
                              errbuf : Interfaces.C.Strings.chars_ptr) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_getnonblock";

   function pcap_lib_version return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_lib_version";

   function pcap_list_datalinks (p       :     pcap_t_ptr;
                                 dlt_buf : out System.Address) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_list_datalinks";

   function pcap_list_tstamp_types (p            :     pcap_t_ptr;
                                    tstamp_types : out System.Address) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_list_tstamp_types";

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

   function pcap_open_live (device  : Interfaces.C.Strings.chars_ptr;
                            snaplen : Interfaces.C.int;
                            promisc : Interfaces.C.int;
                            to_ms   : Interfaces.C.int;
                            errbuf  : Interfaces.C.Strings.chars_ptr) return pcap_t_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_open_live";

   procedure pcap_perror (p      : pcap_t_ptr;
                          prefix : Interfaces.C.Strings.chars_ptr)
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_perror";

   function pcap_set_buffer_size (p           : pcap_t_ptr;
                                  buffer_size : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_buffer_size";

   function pcap_set_datalink (p   : pcap_t_ptr;
                               dlt : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_datalink";

   function pcap_set_immediate_mode (p              : pcap_t_ptr;
                                     immediate_mode : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_immediate_mode";

   function pcap_set_promisc (p       : pcap_t_ptr;
                              promisc : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_promisc";

   function pcap_set_rfmon (p     : pcap_t_ptr;
                            rfmon : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_rfmon";

   function pcap_set_snaplen (p       : pcap_t_ptr;
                              snaplen : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_snaplen";

   function pcap_set_timeout (p     : pcap_t_ptr;
                              to_ms : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_timeout";

   function pcap_set_tstamp_precision (p                : pcap_t_ptr;
                                       tstamp_precision : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_tstamp_precision";

   function pcap_set_tstamp_type (p           : pcap_t_ptr;
                                  tstamp_type : Interfaces.C.int) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_set_tstamp_type";

   function pcap_setdirection (p : pcap_t_ptr; d : pcap_direction_t) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_setdirection";

   function pcap_setnonblock (p        : pcap_t_ptr;
                              nonblock : Interfaces.C.int;
                              errbuf   : Interfaces.C.Strings.chars_ptr) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_setnonblock";

   function pcap_stats (p  :     pcap_t_ptr;
                        ps : out pcap_stat) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_stats";

   function pcap_statustostr (error : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_statustostr";

   function pcap_strerror (error : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_strerror";

   function pcap_tstamp_type_name_to_val (name : Interfaces.C.Strings.chars_ptr) return Interfaces.C.int
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_tstamp_type_name_to_val";

   function pcap_tstamp_type_val_to_name (tstamp_type : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_tstamp_type_val_to_name";

   function pcap_tstamp_type_val_to_description (tstamp_type : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr
   with Import        => True,
        Convention    => C,
        External_Name => "pcap_tstamp_type_val_to_description";

end Pcap;
