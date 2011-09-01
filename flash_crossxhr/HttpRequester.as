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

        private var id:Number;
        private var request:URLRequest;
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
            if (request.method == 'POST')
              request.data = data;
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, handler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, handler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler);
            loader.load(request);
        }

        public function handler(e:Event):void {
          var loader:URLLoader = URLLoader(e.target);
          loader.removeEventListener(Event.COMPLETE, handler);
          loader.removeEventListener(IOErrorEvent.IO_ERROR, handler);
          var integration:String;
          if ( e.type != IOErrorEvent.IO_ERROR && e.type != SecurityErrorEvent.SECURITY_ERROR ) {
            parent.handler(id, 200, loader.data); // fix status
          } else {
            parent.handler(id, 0, loader.data); // error TODO
          }
        }
    }
}
