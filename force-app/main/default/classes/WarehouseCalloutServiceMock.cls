public class WarehouseCalloutServiceMock implements HttpCalloutMock {
    private String response;

    public WarehouseCalloutServiceMock(String response) {
        this.response = response;
    }

    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(response);
        res.setStatusCode(200);
        return res;
    }
}