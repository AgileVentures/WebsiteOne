/*****************************************************************************

File:     libmain.cpp
Date:     06Apr06

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
#include <stdexcept>

using namespace std;

#include <ruby.h>
#include "http.h"



/**************************
class RubyHttpConnection_t
**************************/

class RubyHttpConnection_t: public HttpConnection_t
{
	public:
		RubyHttpConnection_t (VALUE v): Myself(v) {}
		virtual ~RubyHttpConnection_t() {}

		virtual void SendData (const char*, int);
		virtual void CloseConnection (bool after_writing);
		virtual void ProcessRequest (const char *request_method,
				const char *cookie,
				const char *ifnonematch,
				const char *contenttype,
				const char *query_string,
				const char *path_info,
				const char *request_uri,
				const char *protocol,
				int postlength,
				const char *postdata,
				const char *hdrblock,
				int hdrblocksize);
		virtual void ReceivePostData (const char *data, int len);

	private:
		VALUE Myself;
};


/******************************
RubyHttpConnection_t::SendData
******************************/

void RubyHttpConnection_t::SendData (const char *data, int length)
{
	rb_funcall (Myself, rb_intern ("send_data"), 1, rb_str_new (data, length));
}


/*************************************
RubyHttpConnection_t::CloseConnection
*************************************/

void RubyHttpConnection_t::CloseConnection (bool after_writing)
{
	VALUE v = rb_intern (after_writing ? "close_connection_after_writing" : "close_connection");
	rb_funcall (Myself, v, 0);
}


/*************************************
RubyHttpConnection_t::ReceivePostData
*************************************/

void RubyHttpConnection_t::ReceivePostData (const char *data, int len)
{
	VALUE data_val = Qnil;
	
	if ((len > 0) && data) {
		data_val = rb_str_new(data,len);
		rb_funcall (Myself, rb_intern ("receive_post_data"), 1, data_val);
	}
}
	
/************************************
RubyHttpConnection_t::ProcessRequest
************************************/

void RubyHttpConnection_t::ProcessRequest (const char *request_method,
		const char *cookie,
		const char *ifnonematch,
		const char *contenttype,
		const char *query_string,
		const char *path_info,
		const char *request_uri,
		const char *protocol,
		int post_length,
		const char *post_content,
		const char *hdr_block,
		int hdr_block_size)
{
	VALUE post = Qnil;
	VALUE headers = Qnil;
	VALUE req_method = Qnil;
	VALUE cookie_val = Qnil;
	VALUE ifnonematch_val = Qnil;
	VALUE contenttype_val = Qnil;
	VALUE path_info_val = Qnil;
	VALUE query_string_val = Qnil;
	VALUE request_uri_val = Qnil;
	VALUE protocol_val = Qnil;

	if ((post_length > 0) && post_content)
		post = rb_str_new (post_content, post_length);

	if (hdr_block && (hdr_block_size > 0))
		headers = rb_str_new (hdr_block, hdr_block_size);
	else
		headers = rb_str_new ("", 0);

	if (request_method && *request_method)
		req_method = rb_str_new (request_method, strlen (request_method));
	if (cookie && *cookie)
		cookie_val = rb_str_new (cookie, strlen (cookie));
	if (ifnonematch && *ifnonematch)
		ifnonematch_val = rb_str_new (ifnonematch, strlen (ifnonematch));
	if (contenttype && *contenttype)
		contenttype_val = rb_str_new (contenttype, strlen (contenttype));
	if (path_info && *path_info)
		path_info_val = rb_str_new (path_info, strlen (path_info));
	if (query_string && *query_string)
		query_string_val = rb_str_new (query_string, strlen (query_string));
	if (request_uri && *request_uri)
		request_uri_val = rb_str_new (request_uri, strlen (request_uri));
	if (protocol && *protocol)
		protocol_val = rb_str_new (protocol, strlen (protocol));

	rb_ivar_set (Myself, rb_intern ("@http_request_method"), req_method);
	rb_ivar_set (Myself, rb_intern ("@http_cookie"), cookie_val);
	rb_ivar_set (Myself, rb_intern ("@http_if_none_match"), ifnonematch_val);
	rb_ivar_set (Myself, rb_intern ("@http_content_type"), contenttype_val);
	rb_ivar_set (Myself, rb_intern ("@http_path_info"), path_info_val);
	rb_ivar_set (Myself, rb_intern ("@http_request_uri"), request_uri_val);
	rb_ivar_set (Myself, rb_intern ("@http_query_string"), query_string_val);
	rb_ivar_set (Myself, rb_intern ("@http_post_content"), post);
	rb_ivar_set (Myself, rb_intern ("@http_headers"), headers);
	rb_ivar_set (Myself, rb_intern ("@http_protocol"), protocol_val);
	rb_funcall (Myself, rb_intern ("process_http_request"), 0);
}


/*******
Statics
*******/

VALUE Intern_http_conn;

/***********
t_post_init
***********/

static VALUE t_post_init (VALUE self)
{
	RubyHttpConnection_t *hc = new RubyHttpConnection_t (self);
	if (!hc)
		throw std::runtime_error ("no http-connection object");

	rb_ivar_set (self, Intern_http_conn, LONG2NUM ((long)hc));
	return Qnil;
}


/**************
t_receive_data
**************/

static VALUE t_receive_data (VALUE self, VALUE data)
{
	int length = NUM2INT (rb_funcall (data, rb_intern ("length"), 0));
	RubyHttpConnection_t *hc = (RubyHttpConnection_t*)(NUM2LONG (rb_ivar_get (self, Intern_http_conn)));
	if (hc)
		hc->ConsumeData (StringValuePtr (data), length);
	return Qnil;
}

/*******************
t_receive_post_data
*******************/

static VALUE t_receive_post_data (VALUE self, VALUE data)
{
	/** This is a NOOP.  It should be overridden.  **/
	return Qnil;
}

/********
t_unbind
********/

static VALUE t_unbind (VALUE self)
{
	RubyHttpConnection_t *hc = (RubyHttpConnection_t*)(NUM2LONG (rb_ivar_get (self, Intern_http_conn)));
	if (hc)
		delete hc;
	return Qnil;
}


/**********************
t_process_http_request
**********************/

static VALUE t_process_http_request (VALUE self)
{
	// This is a stub in case the caller doesn't define it.
	rb_funcall (self, rb_intern ("send_data"), 1, rb_str_new2 ("HTTP/1.1 200 ...\r\nContent-type: text/plain\r\nContent-length: 8\r\n\r\nMonorail"));
	return Qnil;
}

/************************
t_no_environment_strings
************************/

static VALUE t_no_environment_strings (VALUE self)
{
	RubyHttpConnection_t *hc = (RubyHttpConnection_t*)(NUM2LONG (rb_ivar_get (self, Intern_http_conn)));
	if (hc)
		hc->SetNoEnvironmentStrings();
	return Qnil;
}

/**********************
t_dont_accumulate_post
**********************/

static VALUE t_dont_accumulate_post (VALUE self)
{
	RubyHttpConnection_t *hc = (RubyHttpConnection_t*)(NUM2LONG (rb_ivar_get (self, Intern_http_conn)));
	if (hc)
		hc->SetDontAccumulatePost();
	return Qnil;
}


/****************************
Init_eventmachine_httpserver
****************************/

extern "C" void Init_eventmachine_httpserver()
{
	Intern_http_conn = rb_intern ("http_conn");

	VALUE EmModule = rb_define_module ("EventMachine");
	VALUE HttpServer = rb_define_module_under (EmModule, "HttpServer");
	rb_define_method (HttpServer, "post_init", (VALUE(*)(...))t_post_init, 0);
	rb_define_method (HttpServer, "receive_data", (VALUE(*)(...))t_receive_data, 1);
	rb_define_method (HttpServer, "receive_post_data", (VALUE(*)(...))t_receive_post_data, 1);
	rb_define_method (HttpServer, "unbind", (VALUE(*)(...))t_unbind, 0);
	rb_define_method (HttpServer, "process_http_request", (VALUE(*)(...))t_process_http_request, 0);
	rb_define_method (HttpServer, "no_environment_strings", (VALUE(*)(...))t_no_environment_strings, 0);
	rb_define_method (HttpServer, "dont_accumulate_post", (VALUE(*)(...))t_dont_accumulate_post, 0);
}
