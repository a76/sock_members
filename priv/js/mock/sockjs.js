if (typeof define !== 'function') { 
    var define = require('/usr/local/lib/node_modules/amdefine')(module); 
}

define(function (require) {
	var filter = require('../core/filter');

	return {
	    __create: function (buffer) {
	    	function SockJS () {
	            this.filter = filter.__create();    
	    	};

	    	SockJS.prototype.send = function (request) {
	            var data = this.filter.execute(request.filtering, buffer),
	                total = data.length;

	            if (request.range) {
	            	data = data.slice(request.range.from, request.range.to);
	            }
	            
	            this.onmessage({
	            	key: request.key,
	            	action: 'rpc',
	            	request: request,
	            	data: data,
	            	total: total
	            });
	    	}; 

	    	return SockJS;
		}
    };   	
});