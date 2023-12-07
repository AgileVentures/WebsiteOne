/*****************************************************************************

File:     http.cpp
Date:     21Apr06

Copyright (C) 2006-07 by Francis Cianfrocca. All Rights Reserved.
Gmail: garbagecat10

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

*****************************************************************************/


#include <iostream>
#include <string>
#include <cstdlib>
#include <cstring>
#include <sstream>
#include <stdexcept>
#include <stdio.h>

#ifdef OS_WIN32
#include <windows.h>
#endif

using namespace std;

#include "http.h"


#ifdef OS_WIN32
#define strncasecmp _strnicmp
#define strcasecmp _stricmp
void setenv (const char *str, const char *value, bool replace)
{
	SetEnvironmentVariable (str, value);
}
void unsetenv (const char *str)
{
	SetEnvironmentVariable (str, NULL);
}
#endif


/**********************************
HttpConnection_t::HttpConnection_t
**********************************/

HttpConnection_t::HttpConnection_t()
{
	ProtocolState = BaseState;
	_Content = NULL;

	// By default, we set the standard CGI environment strings.
	// (This is primarily beneficial because it lets the caller use Ruby's CGI classes.)
	// The caller can switch this off in Ruby code, which greatly improves performance.
	bSetEnvironmentStrings = true;

	// This flag was added by Kirk Haines (thanks, Kirk). It preserves the original
	// behavior with respect to POST content, which was to accumulate it in a buffer
	// allocated and managed in this class. Kirk's mods allow callers to specify that
	// POST content be submitted directly to user code piece by piece as we receive it,
	// instead of buffering it here. To get the latter behavior, user code must call
	// dont_accumulate_post.
	bAccumulatePost = true;
}


/***********************************
HttpConnection_t::~HttpConnection_t
***********************************/

HttpConnection_t::~HttpConnection_t()
{
	if (_Content)
		free (_Content);
}



/**************************
HttpConnection_t::SendData
**************************/

void HttpConnection_t::SendData (const char *data, int length)
{
  cerr << "UNIMPLEMENTED SendData" << endl;
}


/*********************************
HttpConnection_t::CloseConnection
*********************************/

void HttpConnection_t::CloseConnection (bool after_writing)
{
  cerr << "UNIMPLEMENTED CloseConnection" << endl;
}


/********************************
HttpConnection_t::ProcessRequest
********************************/

void HttpConnection_t::ProcessRequest (const char *method,
		const char *cookie,
		const char *ifnonematch,
		const char *contenttype,
		const char *query_string,
		const char *path_info,
		const char *request_uri,
		const char *protocol,
		int post_length,
		const char *post_content,
		const char *hdrblock,
		int hdrblocksize)
{
  cerr << "UNIMPLEMENTED ProcessRequest" << endl;
}


/*********************************
HttpConnection_t::ReceivePostData
*********************************/

void HttpConnection_t::ReceivePostData (const char *data, int len)
{
	cerr << "UNIMPLEMENTED ReceivePostData" << endl;
}

/*****************************
HttpConnection_t::ConsumeData
*****************************/

void HttpConnection_t::ConsumeData (const char *data, int length)
{
	if (ProtocolState == EndState)
		return;

	if ((length > 0) && !data)
		throw std::runtime_error ("bad args consuming http data");

	while (length > 0) {
		//----------------------------------- BaseState
		// Initialize for a new request. Don't consume any data.
		// For anal-retentive security we may want to bzero the header block.
		if (ProtocolState == BaseState) {
			ProtocolState = PreheaderState;
			nLeadingBlanks = 0;
			HeaderLinePos = 0;
			HeaderBlockPos = 0;
			ContentLength = 0;
			ContentPos = 0;
			bRequestSeen = false;
			bContentLengthSeen = false;
			if (_Content) {
				free ((void*)_Content);
				_Content = NULL;
			}
			RequestMethod = NULL;
			#ifdef OS_WIN32
			Cookie.erase(Cookie.begin(),Cookie.end());
			IfNoneMatch.erase(IfNoneMatch.begin(),IfNoneMatch.end());
			ContentType.erase(ContentType.begin(),ContentType.end());
			PathInfo.erase(PathInfo.begin(),PathInfo.end());
			RequestUri.erase(RequestUri.begin(),RequestUri.end());
			QueryString.erase(QueryString.begin(),QueryString.end());
			Protocol.erase(Protocol.begin(),Protocol.end());
			#else
			Cookie.clear();
			IfNoneMatch.clear();
			ContentType.clear();
			PathInfo.clear();
			RequestUri.clear();
			QueryString.clear();
			Protocol.clear();
			#endif

			if (bSetEnvironmentStrings) {
				unsetenv ("REQUEST_METHOD");
				unsetenv ("HTTP_COOKIE");
				unsetenv ("IF_NONE_MATCH");
				unsetenv ("CONTENT_TYPE");
				unsetenv ("PATH_INFO");
				unsetenv ("REQUEST_URI");
				unsetenv ("QUERY_STRING");
				unsetenv ("PROTOCOL");
			}
		}

		//----------------------------------- PreheaderState
		// Consume blank lines (but not too many of them)
		while ((ProtocolState == PreheaderState) && (length > 0)) {
			if ((*data == '\r') || (*data == '\n')) {
				data++;
				length--;
				nLeadingBlanks++;
				if (nLeadingBlanks > MaxLeadingBlanks) {
					// TODO, log this.
					goto fail_connection;
				}
			}
			else
				ProtocolState = HeaderState;
		}

		//----------------------------------- HeaderState
		// Read HTTP headers.
		// This processing depends on the fact that the end
		// of the data buffer we receive will have a null terminator
		// just after the last byte indicated by the length parameter.
		// Cf notes in ConnectionDescriptor::Read.
		while ((ProtocolState == HeaderState) && (length > 0)) {
			if (*data == '\n') {
				HeaderLine [HeaderLinePos] = 0;
				if (!_InterpretHeaderLine (HeaderLine))
					goto send_error;
				if (HeaderLinePos == 0) {
					if (ContentLength > 0) {
						if (_Content)
							free (_Content);
						_Content = NULL;
						if (bAccumulatePost) {
							_Content = (char*) malloc (ContentLength + 1);
							if (!_Content)
								throw std::runtime_error ("resource exhaustion");
						}
						ContentPos = 0;
						ProtocolState = ReadingContentState;
					}
					else
						ProtocolState = DispatchState;
				}
				HeaderLinePos = 0;
				data++;
				length--;
			}
			else if (*data == '\r') {
				// ignore \r
				data++;
				length--;
			}
			else {
				const char *nl = strpbrk (data, "\r\n");
				int len = nl ? (nl - data) : length;
				if ((size_t)(HeaderLinePos + len) >= sizeof(HeaderLine)) {
					// TODO, log this
					goto fail_connection;
				}
				memcpy (HeaderLine + HeaderLinePos, data, len);
				data += len;
				length -= len;
				HeaderLinePos += len;
			}
		}


		//----------------------------------- ReadingContentState
		// Read POST content.
		while ((ProtocolState == ReadingContentState) && (length > 0)) {
			int len = ContentLength - ContentPos;
			if (len > length)
				len = length;

			if (bAccumulatePost)
				memcpy (_Content + ContentPos, data, len);
			else
				ReceivePostData (data, len);

			data += len;
			length -= len;
			ContentPos += len;
			if (ContentPos == ContentLength) {
				if (bAccumulatePost)
					_Content[ContentPos] = 0;
				ProtocolState = DispatchState;
			}
		}


		//----------------------------------- DispatchState
		if (ProtocolState == DispatchState) {
			ProcessRequest (RequestMethod, Cookie.c_str(), IfNoneMatch.c_str(), ContentType.c_str(), QueryString.c_str(), PathInfo.c_str(), RequestUri.c_str(), Protocol.c_str(), ContentLength, _Content, HeaderBlock, HeaderBlockPos);
			ProtocolState = BaseState;
		}
	}

	return;

	fail_connection:
	// For protocol errors or security violations- kill the connection dead.
	CloseConnection (false);
	ProtocolState = EndState;
	return;

	send_error:
	// for HTTP-level errors that will send back a response to the client.
	CloseConnection (true);
	ProtocolState = EndState;
	return;

}


/**************************************
HttpConnection_t::_InterpretHeaderLine
**************************************/

bool HttpConnection_t::_InterpretHeaderLine (const char *header)
{
	/* Return T/F to indicate whether we should continue processing
	 * this request. Return false to indicate that we detected a fatal
	 * error or other condition which should cause us to drop the
	 * connection.
	 * BY DEFINITION, this doesn't define any immediate fatal errors.
	 * That may need to change, in which case we'll have to return
	 * an error code rather than T/F, so the caller will know whether
	 * to drop the connection gracefully or not.
	 *
	 * There's something odd and possibly undesirable about how we're
	 * doing this. We fully process each header (including the request)
	 * _as we see it,_ and not at the end when all the headers have
	 * been seen. This saves us the trouble of keeping them all around
	 * and possibly parsing them twice, but it also means that when
	 * we emit errors from here (that generate HTTP responses other than
	 * 200 and therefore close the connection), we do so _immediately_
	 * and before looking at the rest of the headers. That might surprise
	 * and confuse some clients.
	 *
	 * Revised 27Sep06, we now store all the headers in one place, on a
	 * per-request basis, for the purpose of making them available to
	 * downstream users. At present this involves an undesirable extra
	 * memory copy. Eventually should rework the main header processing
	 * so it can be done in place.
	 */

	if (!header) // an assert, really.
		throw std::runtime_error ("bad arg interpreting headers");

	if (!bRequestSeen) {
		bRequestSeen = true;
		return _InterpretRequest (header);
	}

	if (!strncasecmp (header, "content-length:", 15)) {
		if (bContentLengthSeen) {
			// TODO, log this. There are some attacks that depend
			// on sending more than one content-length header.
			_SendError (406);
			return false;
		}
		bContentLengthSeen = true;
		const char *s = header + 15;
		while (*s && ((*s==' ') || (*s=='\t')))
			s++;
		ContentLength = atoi (s);
		if (ContentLength > MaxContentLength) {
			// TODO, log this.
			_SendError (406);
			return false;
		}
	}
	else if (!strncasecmp (header, "cookie:", 7)) {
		const char *s = header + 7;
		while (*s && ((*s==' ') || (*s=='\t')))
			s++;
		Cookie = s;
		if (bSetEnvironmentStrings)
			setenv ("HTTP_COOKIE", s, true);
	}
	else if (!strncasecmp (header, "If-none-match:", 14)) {
		const char *s = header + 14;
		while (*s && ((*s==' ') || (*s=='\t')))
			s++;
		IfNoneMatch = s;
		if (bSetEnvironmentStrings)
			setenv ("IF_NONE_MATCH", s, true);
	}
	else if (!strncasecmp (header, "Content-type:", 13)) {
		const char *s = header + 13;
		while (*s && ((*s==' ') || (*s=='\t')))
			s++;
		ContentType = s;
		if (bSetEnvironmentStrings)
			setenv ("CONTENT_TYPE", s, true);
	}


	// Copy the incoming header into a block
	if ((HeaderBlockPos + strlen(header) + 1) < HeaderBlockSize) {
		int len = strlen(header);
		memcpy (HeaderBlock+HeaderBlockPos, header, len);
		HeaderBlockPos += len;
		HeaderBlock [HeaderBlockPos++] = 0;
	}
	else {
		// TODO, log this.
		_SendError (406);
		return false;
	}

	return true;
}


/***********************************
HttpConnection_t::_InterpretRequest
***********************************/

bool HttpConnection_t::_InterpretRequest (const char *header)
{
	/* Return T/F to indicate whether we should continue processing
	 * this request. Return false to indicate that we detected a fatal
	 * error or other condition which should cause us to drop the
	 * connection.
	 * Interpret the contents of the given line as an HTTP request string.
	 * WE ASSUME the passed-in header is not null.
	 *
	 * In preparation for a CGI-style call, we set the following
	 * environment strings here (other code will DEPEND ON ALL OF
	 * THESE BEING SET HERE in case there are no errors):
	 * REQUEST_METHOD, PATH_INFO, QUERY_STRING.
	 *
	 * Oh and by the way, this code sucks. It's reasonably fast
	 * but not terribly fast, and it's ugly. Refactor someday.
	 */

	const char *blank = strchr (header, ' ');
	if (!blank) {
		_SendError (406);
		return false;
	}

	if (!_DetectVerbAndSetEnvString (header, blank - header))
		return false;

	blank++;
	if (*blank != '/') {
		_SendError (406);
		return false;
	}

	const char *blank2 = strchr (blank, ' ');
	if (!blank2) {
		_SendError (406);
		return false;
	}
	if (strcasecmp (blank2 + 1, "HTTP/1.0") && strcasecmp (blank2 + 1, "HTTP/1.1")) {
		_SendError (505);
		return false;
	}

	string prot (blank2+1);
	Protocol = prot.c_str();

	// Here, the request starts at blank and ends just before blank2.
	// Find the query-string (?) and/or fragment (#,;), if either are present. 
	const char *questionmark = strchr (blank, '?');
	if (questionmark && (questionmark >= blank2))
		questionmark = NULL;
	// const char *fragment = strpbrk ((questionmark ? (questionmark+1) : blank), "#;");
	const char *fragment = strpbrk ((questionmark ? (questionmark+1) : blank), "#");
	if (fragment && (fragment >= blank2))
		fragment = NULL;

	if (questionmark) {
		string req (blank, questionmark - blank);
		PathInfo = req.c_str();
		RequestUri = req.c_str();
		string qs (questionmark+1, fragment ? (fragment - (questionmark+1)) : (blank2 - (questionmark+1)));
		QueryString = qs.c_str();

		if (bSetEnvironmentStrings) {
			setenv ("PATH_INFO", req.c_str(), true);
			setenv ("REQUEST_URI", req.c_str(), true);
			setenv ("QUERY_STRING", qs.c_str(), true);
			setenv ("PROTOCOL", prot.c_str(), true);
		}
	}
	else if (fragment) {
		string req (blank, fragment - blank);
		PathInfo = req.c_str();
		RequestUri = req.c_str();
		#ifdef OS_WIN32
		QueryString.erase(QueryString.begin(),QueryString.end());
		#else
		QueryString.clear();
		#endif
		if (bSetEnvironmentStrings) {
			setenv ("PATH_INFO", req.c_str(), true);
			setenv ("REQUEST_URI", req.c_str(), true);
			setenv ("QUERY_STRING", "", true);
			setenv ("PROTOCOL", prot.c_str(), true);
		}
	}
	else {
		string req (blank, blank2 - blank);
		PathInfo = req.c_str();
		RequestUri = req.c_str();
		#ifdef OS_WIN32
		QueryString.erase(QueryString.begin(),QueryString.end());
		#else
		QueryString.clear();
		#endif
		if (bSetEnvironmentStrings) {
			setenv ("PATH_INFO", req.c_str(), true);
			setenv ("REQUEST_URI", req.c_str(), true);
			setenv ("QUERY_STRING", "", true);
			setenv ("PROTOCOL", prot.c_str(), true);
		}
	}
	
	return true;
}


/********************************************
HttpConnection_t::_DetectVerbAndSetEnvString
********************************************/

bool HttpConnection_t::_DetectVerbAndSetEnvString (const char *request, int verblength)
{
	/* Helper method for _InterpretRequest.
	 * WE MUST SET THE ENV STRING "REQUEST_METHOD" HERE
	 * unless there is an error.
	 * The hardcoded verbs MUST be static, as we'll carry around pointers to them.
	 */

	static const char *verbs[] = {
		"GET",
		"POST",
		"PUT",
		"DELETE",
		"HEAD"
	};

	int n_verbs = sizeof(verbs) / sizeof(const char*);

	// Warning, this algorithm is vulnerable to head-matches,
	// so compare the longer head-matching strings first.
	// We could fix this if we included the blank in the search
	// string but then we'd have to lop it off in the env string.
	// ALSO NOTICE the early return on success.
	for (int i=0; i < n_verbs; i++) {
		if (!strncasecmp (request, verbs[i], verblength) && (strlen(verbs[i]) == (size_t)verblength)) {
			RequestMethod = verbs[i];
			if (bSetEnvironmentStrings)
				setenv ("REQUEST_METHOD", verbs[i], 1);
			return true;
		}
	}

	_SendError (405);
	return false;
}



/****************************
HttpConnection_t::_SendError
****************************/

void HttpConnection_t::_SendError (int code)
{
	stringstream ss;
	ss << "HTTP/1.1 " << code << " ...\r\n";
	ss << "Connection: close\r\n";
	ss << "Content-type: text/plain\r\n";
	ss << "\r\n";
	ss << "Detected error: HTTP code " << code;

	SendData (ss.str().c_str(), ss.str().length());
}
