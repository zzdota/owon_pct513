package server;

import org.json.JSONException;
import org.json.JSONObject;

public class JsonUtil {
    public String ServerCfg(String host, int sslport, int port) throws JSONException {
        JSONObject mapbuf = new JSONObject();
        mapbuf.put("type", "wizardConfig");
        mapbuf.put("command", "serverCfg");
        JSONObject argument = new JSONObject();
        argument.put("host", host);
        argument.put("sslport", sslport);
        argument.put("port", port);
        mapbuf.put("argument",argument);
        mapbuf.put("sequence", 1000);
        String value =  mapbuf.toString();
        return value;
    }

    public String DevOwnerCfg(String owner, String agentid) throws JSONException {
        JSONObject mapbuf = new JSONObject();
        mapbuf.put("type", "wizardConfig");
        mapbuf.put("command", "DevOwnerCfg");
        JSONObject argument = new JSONObject();
        argument.put("Owner", owner);
        argument.put("agentid", agentid);
        mapbuf.put("argument",argument);
        mapbuf.put("sequence", 1001);
        String value =  mapbuf.toString();
        return value;
    }

    public String StartRegister() throws JSONException {
        JSONObject mapbuf = new JSONObject();
        mapbuf.put("type", "wizardConfig");
        mapbuf.put("command", "startRegister");
        mapbuf.put("sequence", 1002);
        String value =  mapbuf.toString();
        return value;
    }

    public String DevLocationCfg(int longitude, int latitude, String area) throws JSONException {
        JSONObject mapbuf = new JSONObject();
        mapbuf.put("type", "wizardConfig");
        mapbuf.put("command", "DevLocationCfg");
        mapbuf.put("sequence", 1003);
        JSONObject argument = new JSONObject();
        argument.put("Area", area);
        argument.put("Longitude", longitude);
        argument.put("Latitude", latitude);
        mapbuf.put("argument",argument);
        String value =  mapbuf.toString();
        return value;
    }
}
