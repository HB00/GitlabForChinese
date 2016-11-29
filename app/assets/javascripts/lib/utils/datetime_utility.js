/* eslint-disable func-names, space-before-function-paren, wrap-iife, no-var, no-param-reassign, no-cond-assign, comma-dangle, no-unused-expressions, prefer-template, padded-blocks, max-len */
/* global timeago */
/* global dateFormat */

/*= require timeago */
/*= require date.format */

(function() {
  (function(w) {
    var base;
    if (w.gl == null) {
      w.gl = {};
    }
    if ((base = w.gl).utils == null) {
      base.utils = {};
    }
    w.gl.utils.days = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];

    w.gl.utils.formatDate = function(datetime) {
      return dateFormat(datetime, 'mmm d, yyyy h:MMtt Z');
    };

    w.gl.utils.getDayName = function(date) {
      return this.days[date.getDay()];
    };

    w.gl.utils.localTimeAgo = function($timeagoEls, setTimeago) {
      if (setTimeago == null) {
        setTimeago = true;
      }

      $timeagoEls.each(function() {
        var $el = $(this);
        $el.attr('title', gl.utils.formatDate($el.attr('datetime')));

        if (setTimeago) {
          // Recreate with custom template
          $el.tooltip({
            template: '<div class="tooltip local-timeago" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
          });
        }
        gl.utils.renderTimeago($el);
      });
    };

    w.gl.utils.getTimeago = function() {
      var locale = function(number, index) {
        return [
          ['不到 1 分钟前', '刚刚前'],
          ['不到 1 分钟前', '%s 秒'],
          ['大约 1 分钟前', '1 分钟'],
          ['%s 分钟前', '%s 分钟'],
          ['大约 1 小时前', '1 小时'],
          ['大约 %s 小时前', '%s 小时'],
          ['1 天前', '1 天'],
          ['%s 天前', '%s 天'],
          ['1 星期前', '1 星期'],
          ['%s 星期前', '%s 星期'],
          ['1 个月前', '1 个月'],
          ['%s 个月前', '%s 个月'],
          ['1 年前', '1 年前'],
          ['%s 年前', '%s 年']
        ][index];
      };

      timeago.register('gl_en', locale);
      return timeago();
    };

    w.gl.utils.timeFor = function(time, suffix, expiredLabel) {
      var timefor;
      if (!time) {
        return '';
      }
      suffix || (suffix = 'remaining');
      expiredLabel || (expiredLabel = 'Past due');
      timefor = gl.utils.getTimeago().format(time).replace('in', '');
      if (timefor.indexOf('ago') > -1) {
        timefor = expiredLabel;
      } else {
        timefor = timefor.trim() + ' ' + suffix;
      }
      return timefor;
    };

    w.gl.utils.renderTimeago = function($element) {
      var timeagoInstance = gl.utils.getTimeago();
      timeagoInstance.render($element, 'gl_en');
    };

    w.gl.utils.getDayDifference = function(a, b) {
      var millisecondsPerDay = 1000 * 60 * 60 * 24;
      var date1 = Date.UTC(a.getFullYear(), a.getMonth(), a.getDate());
      var date2 = Date.UTC(b.getFullYear(), b.getMonth(), b.getDate());

      return Math.floor((date2 - date1) / millisecondsPerDay);
    };

  })(window);

}).call(this);
