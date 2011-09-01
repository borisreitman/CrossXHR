package
{
    public dynamic class HttpRequester
    {
        import flash.errors.IOError;
        import flash.net.URLLoader;
        import flash.net.URLRequest;
        import flash.net.URLRequestMethod;
        import flash.net.URLRequestHeader;
		    import flash.events.Event;
		    import flash.events.IOErrorEvent;
		    import flash.events.SecurityErrorEvent;
		    import flash.events.HTTPStatusEvent;

		    import HTTPURLLoader;

        private var id:Number;
        private var request:URLRequest;
        private var status:Number;
        private var parent:Object;
        public function HttpRequester(parent_:Object,id_:Number, 
            method:String, url:String):void {
            id = id_;
            parent = parent_;
            request = new URLRequest(url);
            request.method = method=='GET' ? URLRequestMethod.GET : URLRequestMethod.POST;
        }

        public function addHeader(name:String, value:String):void {
            var header:URLRequestHeader = new URLRequestHeader(name, value);
            if (!request.requestHeaders)
              request.requestHeaders = new Array(header);
            else
              request.requestHeaders.push(header);
        }

        public function send(data:String):void {
            trace("request.url =  "+request.url);
            if (request.method == 'POST' || request.url.indexOf('/_alive') == -1 ) {
              request.data = data;
              var loader:URLLoader = new URLLoader();
              loader.addEventListener(Event.COMPLETE, handler);
              loader.addEventListener(IOErrorEvent.IO_ERROR, handler);
              loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler);
              loader.load(request);
            } else {
              var loader2:HTTPURLLoader = new HTTPURLLoader();
              loader2.addEventListener("complete", handler);
              loader2.addEventListener("httpStatus", onHTTPStatus);
              loader2.addEventListener(IOErrorEvent.IO_ERROR, handler);
              loader2.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler);
              loader2.load(request);
            }
        }

        private function onHTTPStatus(event:HTTPStatusEvent):void
        {
          status = event.status;
        } 

        public function handler(e:Event):void {
            var error:Boolean = e.type == IOErrorEvent.IO_ERROR ||
                 e.type == SecurityErrorEvent.SECURITY_ERROR;
            if (request.method == 'POST' || request.url.indexOf('/_alive')==-1) {
              var loader:URLLoader = URLLoader(e.target);
              loader.removeEventListener(Event.COMPLETE, handler);
              loader.removeEventListener(IOErrorEvent.IO_ERROR, handler);
              var integration:String;
              if ( !error )
                status = 200; // FIXME: fix status
              else
                status = 0;
              parent.handler(id, status, loader.data);
            } else {
              var loader2:HTTPURLLoader = HTTPURLLoader(e.target);
              loader2.close();
              if ( error )
                status = 0; // FIXME: fix status
              parent.handler(id, status, loader2.data);
            }
        }
    }
}
