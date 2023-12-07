#----------------------------------------------------------------------------
#
# Copyright (C) 2006-07 by Francis Cianfrocca. All Rights Reserved.
#
# Gmail: garbagecat10
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
#---------------------------------------------------------------------------
#
# extconf.rb for Ruby/EventMachine
# We have to munge LDSHARED because this code needs a C++ link.
#

require 'mkmf'

flags = []

case RUBY_PLATFORM.split('-',2)[1]
when 'mswin32', 'mingw32', 'bccwin32'
  unless have_header('windows.h') and
      have_header('winsock.h') and
      have_library('kernel32') and
      have_library('rpcrt4') and
      have_library('gdi32')
    exit
  end

  flags << "-D OS_WIN32"
  flags << '-D BUILD_FOR_RUBY'
  flags << "-EHs"
  flags << "-GR"

  dir_config('ssl')
  if have_library('ssleay32') and
	  have_library('libeay32') and
	  have_header('openssl/ssl.h') and
	  have_header('openssl/err.h')
    flags << '-D WITH_SSL'
  else
    flags << '-D WITHOUT_SSL'
  end

when /solaris/
  unless have_library('pthread') and
	have_library('nsl') and
	have_library('socket')
	  exit
  end

  flags << '-D OS_UNIX'
  flags << '-D OS_SOLARIS8'
  flags << '-D BUILD_FOR_RUBY'

  dir_config('ssl')
  if have_library('ssl') and
	  have_library('crypto') and
	  have_header('openssl/ssl.h') and
	  have_header('openssl/err.h')
    flags << '-D WITH_SSL'
  else
    flags << '-D WITHOUT_SSL'
  end

  # on Unix we need a g++ link, not gcc.
  CONFIG['LDSHARED'] = "$(CXX) -shared"

when /darwin/
  flags << '-DOS_UNIX'
  flags << '-DBUILD_FOR_RUBY'

  dir_config('ssl')
  if have_library('ssl') and
	  have_library('crypto') and
	  have_library('C') and
	  have_header('openssl/ssl.h') and
	  have_header('openssl/err.h')
    flags << '-DWITH_SSL'
  else
    flags << '-DWITHOUT_SSL'
  end
  # on Unix we need a g++ link, not gcc.
  # Ff line contributed by Daniel Harple.
  CONFIG['LDSHARED'] = "$(CXX) " + CONFIG['LDSHARED'].split[1..-1].join(' ')

else
  unless have_library('pthread')
	  exit
  end

  flags << '-DOS_UNIX'
  flags << '-DBUILD_FOR_RUBY'

  dir_config('ssl')
  if have_library('ssl') and
	  have_library('crypto') and
	  have_header('openssl/ssl.h') and
	  have_header('openssl/err.h')
    flags << '-DWITH_SSL'
  else
    flags << '-DWITHOUT_SSL'
  end
  # on Unix we need a g++ link, not gcc.
  CONFIG['LDSHARED'] = "$(CXX) -shared"

  # Modify the mkmf constant LINK_SO so the generated shared object is stripped.
  # You might think modifying CONFIG['LINK_SO'] would be a better way to do this,
  # but it doesn't work because mkmf doesn't look at CONFIG['LINK_SO'] again after
  # it initializes.
  # linkso = Object.send :remove_const, "LINK_SO"
  # LINK_SO = linkso + "; strip $@"
end

if $CPPFLAGS
  $CPPFLAGS += ' ' + flags.join(' ')
else
  $CFLAGS += ' ' + flags.join(' ')
end


create_makefile "eventmachine_httpserver"
