this.Mercury.modalHandlers.insertMedia = {
    initialize: function() {
        this.element.find('.control-label input').on('click', this.onLabelChecked);
        this.element.find('.controls .optional, .controls .required').on('focus', (function(_this) {
            return function(event) {
                return _this.onInputFocused($(event.target));
            };
        })(this));
        this.focus('#media_image_url');
        this.initializeForm();
        this.element.find('#media_youtube_url').on('change', (function(_this) {
            return function(event) {
                return _this.checkYoutube();
            };
        })(this));
        return this.element.find('form').on('submit', (function(_this) {
            return function(event) {
                event.preventDefault();
                _this.checkYoutube();
                _this.validateForm();
                if (!_this.valid) {
                    _this.resize();
                    return;
                }
                _this.submitForm();
                return _this.hide();
            };
        })(this));
    },
    initializeForm: function() {
        var iframe, image, selection, src;
        if (!(Mercury.region && Mercury.region.selection)) {
            return;
        }
        selection = Mercury.region.selection();
        if (image = typeof selection.is === "function" ? selection.is('img') : void 0) {
            this.element.find('#media_image_url').val(image.attr('src'));
            this.element.find('#media_image_alignment').val(image.attr('align'));
            this.element.find('#media_image_float').val(image.attr('style') != null ? image.css('float') : '');
            this.focus('#media_image_url');
        }
        if (iframe = typeof selection.is === "function" ? selection.is('iframe') : void 0) {
            src = iframe.attr('src');
            if (/^https?:\/\/www.youtube.com\//i.test(src)) {
                this.element.find('#media_youtube_url').val("" + (src.match(/^https?/)[0]) + "://youtu.be/" + (src.match(/\/embed\/(\w+)/)[1]));
                this.element.find('#media_youtube_width').val(iframe.width());
                this.element.find('#media_youtube_height').val(iframe.height());
                return this.focus('#media_youtube_url');
            } else if (/^https?:\/\/player.vimeo.com\//i.test(src)) {
                this.element.find('#media_vimeo_url').val("" + (src.match(/^https?/)[0]) + "://vimeo.com/" + (src.match(/\/video\/(\w+)/)[1]));
                this.element.find('#media_vimeo_width').val(iframe.width());
                this.element.find('#media_vimeo_height').val(iframe.height());
                return this.focus('#media_vimeo_url');
            }
        }
    },
    focus: function(selector) {
        return setTimeout(((function(_this) {
            return function() {
                return _this.element.find(selector).focus();
            };
        })(this)), 300);
    },
    onLabelChecked: function() {
        var forInput;
        forInput = jQuery(this).closest('.control-label').attr('for');
        return jQuery(this).closest('.control-group').find("#" + forInput).focus();
    },
    onInputFocused: function(input) {
        input.closest('.control-group').find('input[type=radio]').prop('checked', true);
        if (input.closest('.media-options').length) {
            return;
        }
        this.element.find(".media-options").hide();
        this.element.find("#" + (input.attr('id').replace('media_', '')) + "_options").show();
        return this.resize(true);
    },
    addInputError: function(input, message) {
        input.after('<span class="help-inline error-message">' + Mercury.I18n(message) + '</span>').closest('.control-group').addClass('error');
        return this.valid = false;
    },
    clearInputErrors: function() {
        this.element.find('.control-group.error').removeClass('error').find('.error-message').remove();
        return this.valid = true;
    },
    checkYoutube: function() {
        var input, time, url, video;
        input = this.element.find('#media_youtube_url');
        url = input.val();
        if (/^https?:\/\/(www.)?youtube.com\//.test(url)) {
            video = url.match(/(\?|&)v=\w+/)[0].substring(3);
            time = url.match(/(\?|&)t=[\d|m|s]+/);
            time = time ? '?' + time[0].substring(1) : '';
            return input.val('http://youtu.be/' + video + time);
        }
    },
    validateForm: function() {
        var el, type, url;
        this.clearInputErrors();
        type = this.element.find('input[name=media_type]:checked').val();
        el = this.element.find("#media_" + type);
        switch (type) {
            case 'youtube_url':
                url = this.element.find('#media_youtube_url').val();
                if (!/^https?:\/\/youtu.be\//.test(url)) {
                    return this.addInputError(el, "is invalid");
                }
                break;
            case 'vimeo_url':
                url = this.element.find('#media_vimeo_url').val();
                if (!/^https?:\/\/vimeo.com\//.test(url)) {
                    return this.addInputError(el, "is invalid");
                }
                break;
            default:
                if (!el.val()) {
                    return this.addInputError(el, "can't be blank");
                }
        }
    },
    submitForm: function() {
        var alignment, attrs, code, float, protocol, type, url, value;
        type = this.element.find('input[name=media_type]:checked').val();
        switch (type) {
            case 'image_url':
                attrs = {
                    src: this.element.find('#media_image_url').val()
                };
                if (alignment = this.element.find('#media_image_alignment').val()) {
                    attrs['align'] = alignment;
                }
                if (float = this.element.find('#media_image_float').val()) {
                    attrs['style'] = 'float: ' + float + ';';
                }
                return Mercury.trigger('action', {
                    action: 'insertImage',
                    value: attrs
                });
            case 'youtube_url':
                url = this.element.find('#media_youtube_url').val();
                code = url.replace(/https?:\/\/youtu.be\//, '');
                protocol = 'http';
                if (/^https:/.test(url)) {
                    protocol = 'https';
                }
                value = jQuery('<iframe>', {
                    width: parseInt(this.element.find('#media_youtube_width').val(), 10) || 560,
                    height: parseInt(this.element.find('#media_youtube_height').val(), 10) || 349,
                    src: "" + protocol + "://www.youtube.com/embed/" + code + "?wmode=transparent",
                    frameborder: 0,
                    allowfullscreen: 'true'
                });

                wrapper = jQuery('<div>', { class: 'video-container' });
                value.appendTo(wrapper);
                return Mercury.trigger('action', {
                    action: 'insertHTML',
                    value: wrapper
                });
            case 'vimeo_url':
                url = this.element.find('#media_vimeo_url').val();
                code = url.replace(/^https?:\/\/vimeo.com\//, '');
                protocol = 'http';
                if (/^https:/.test(url)) {
                    protocol = 'https';
                }
                value = jQuery('<iframe>', {
                    width: parseInt(this.element.find('#media_vimeo_width').val(), 10) || 400,
                    height: parseInt(this.element.find('#media_vimeo_height').val(), 10) || 225,
                    src: "" + protocol + "://player.vimeo.com/video/" + code + "?title=1&byline=1&portrait=0&color=ffffff",
                    frameborder: 0
                });
                return Mercury.trigger('action', {
                    action: 'insertHTML',
                    value: value
                });
        }
    }
};