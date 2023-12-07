/*****************************************************************************

File:     http.h
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


#ifndef __HttpPersonality__H_
#define __HttpPersonality__H_



/**********************
class HttpConnection_t
**********************/

class HttpConnection_t
{
	public:
		HttpConnection_t();
		virtual ~HttpConnection_t();

		void ConsumeData (const char*, int);

		virtual void SendData (const char*, int);
		virtual void CloseConnection (bool after_writing);
		virtual void ProcessRequest (const char *method,
				const char *cookie,
				const char *ifnonematch,
				const char *content_type,
				const char *query_string,
				const char *path_info,
				const char *request_uri,
				const char *protocol,
				int postlength,
				const char *postdata,
				const char* hdrblock,
				int hdrblksize);

		virtual void ReceivePostData(const char *data, int len);
		virtual void SetNoEnvironmentStrings() {bSetEnvironmentStrings = false;}
		virtual void SetDontAccumulatePost() {bAccumulatePost = false;}

  private:

		enum {
			BaseState,
			PreheaderState,
			HeaderState,
			ReadingContentState,
			DispatchState,
			EndState
		} ProtocolState;

		enum {
			MaxLeadingBlanks = 12,
			MaxHeaderLineLength = 8 * 1024,
			MaxContentLength = 20 * 1024 * 1024,
			HeaderBlockSize = 16 * 1024
		};
		int nLeadingBlanks;

		char HeaderLine [MaxHeaderLineLength];
		int HeaderLinePos;

		char HeaderBlock [HeaderBlockSize];
		int HeaderBlockPos;

		int ContentLength;
		int ContentPos;
		char *_Content;

		bool bSetEnvironmentStrings;
		bool bAccumulatePost;
		bool bRequestSeen;
		bool bContentLengthSeen;

		const char *RequestMethod;
		std::string Cookie;
		std::string IfNoneMatch;
		std::string ContentType;
		std::string PathInfo;
		std::string RequestUri;
		std::string QueryString;
		std::string Protocol;

	private:
		bool _InterpretHeaderLine (const char*);
		bool _InterpretRequest (const char*);
		bool _DetectVerbAndSetEnvString (const char*, int);
		void _SendError (int);
};

#endif // __HttpPersonality__H_



