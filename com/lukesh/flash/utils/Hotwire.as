package com.lukesh.flash.utils {
	import flash.events.IEventDispatcher;

	public class Hotwire {
		protected var dispatcher : IEventDispatcher;
		protected var handler : Object;
		protected var prefix : String;
		protected var autoCap : Boolean;
		protected var events : Array;

		public function Hotwire(dispatcher : IEventDispatcher, handler : Object = null, prefix : String = "handle", autoCap : Boolean = true) {
			this.dispatcher = dispatcher;
			this.handler = handler ? handler : dispatcher;
			this.prefix = prefix;
			this.autoCap = autoCap;
			this.events = [];
		}

		public function wire(... rest) : void {
			_wire(rest, false);
		}

		public function weak(... rest) : void {
			_wire(rest, true);
		}

		public function unwire(... rest) : void {
			_unwire(rest.length > 0 ? rest : events);
		}

		protected function deriveHandlerName(eventName : String) : String {
			var handlerName : String = "";
			handlerName += prefix;
			handlerName += autoCap ? (function(n : String) : String {
				var a : Array = n.split("");
				a[0] = String(a[0]).toUpperCase();
				return a.join("");
			})(eventName) : eventName;
			return handlerName;
		}

		protected function _wire(arr : Array, weak : Boolean) : void {
			for (var i : int; i < arr.length; i++) {
				if (events.indexOf(arr[i]) > -1) {
					dispatcher.removeEventListener(arr[i], handler[deriveHandlerName(arr[i])]);
				} else {
					events.push(arr[i]);
				}
				dispatcher.addEventListener(arr[i], handler[deriveHandlerName(arr[i])], false, 0, weak);
			}
		}

		protected function _unwire(arr : Array) : void {
			for (var i : int; i < arr.length; i++) {
				dispatcher.removeEventListener(arr[i], handler[deriveHandlerName(arr[i])]);
				if (events.indexOf(arr[i]) > -1) {
					events.splice(events.indexOf(arr[i]));
				}
			}
		}
	}
}
