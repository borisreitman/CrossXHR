package {
  import flash.display.Sprite;
  public class HttpRequesterManager extends Sprite {
    import flash.external.ExternalInterface;
    import HttpRequester;
    import flash.system.Security;
    Security.allowDomain("*");

    private var objects:Object;
    
    public function HttpRequesterManager():void {
        super();
        ExternalInterface.addCallback("create", create); 
        ExternalInterface.addCallback("addHeader", addHeader); 
        ExternalInterface.addCallback("send", send); 
        ExternalInterface.addCallback("finished", finished); 
        ExternalInterface.call("eval", "FlashHttpRequest_ready = 1");
        objects = new Object();
    }

    public function create(id:Number, method:String, url:String):void {
        var requester:HttpRequester = new HttpRequester(this, id, method, url);
        objects[id] = requester;
    }

    public function addHeader(id:String, name:String, value:String):void {
        objects[id].addHeader(name, value);
    }
    public function send(id:String, content:String):void {
        objects[id].send(content);
    }

    public function handler(id:String, status:String, data:String):void {
        ExternalInterface.call("FlashHttpRequest_handler", id, status, data);
    }
    public function finished(id:String):void {
        objects[id] = null;
    }
  }
}
