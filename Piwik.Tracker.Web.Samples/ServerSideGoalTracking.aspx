<%--http://www.gnu.org/licenses/gpl-3.0.html GPL v3 or later--%>

<%@ Page Language="C#" %>
<%@ Import Namespace="Piwik" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>

This page tracks a goal conversion with the Server Side tracking API and displays the response. <br/><br/>

<% 
    Piwik.Tracker.PiwikTracker.URL = "http://a.esia.info";

    var piwikTracker = new Piwik.Tracker.PiwikTracker(3);
    piwikTracker.setRequestTimeout(2000);
    
    var attributionInfo = new Piwik.Tracker.AttributionInfo();

    //attributionInfo.campaignName = "CAMPAIGN NAME";
    //attributionInfo.campaignKeyword = "CAMPAIGN KEYWORD";
    attributionInfo.referrerTimestamp = DateTime.Now;
    attributionInfo.referrerUrl = "http://www.example.org/test/really?q=yes";

    piwikTracker.setAttributionInfo(attributionInfo);

    HttpWebResponse response = piwikTracker.doTrackPageView("test.apsx");

    if (response != null)
    {
        Response.Write(response.StatusCode);
        
        Stream receiveStream = response.GetResponseStream();
        Encoding encode = Encoding.GetEncoding("utf-8");
        
        // Pipes the stream to a higher level stream reader with the required encoding format. 
        var readStream = new StreamReader(receiveStream, encode);
        Response.Write("\r\nResponse stream received.");
        var read = new Char[256];
        
        // Reads 256 characters at a time.    
        int count = readStream.Read(read, 0, 256);
        Response.Write("HTML...\r\n");
        while (count > 0)
        {
            // Dumps the 256 characters on a string and displays the string to the console.
            String str = new String(read, 0, count);
            count = readStream.Read(read, 0, 256);
            Response.Write(str);
        }
    
        // Releases the resources of the Stream.
        readStream.Close();

        // Releases the resources of the response.
        response.Close();
    }
    response = null;
%>
