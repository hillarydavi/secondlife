//Created by Hillary Davi 11/8/2025
// == GLOBALS ==
key g_urlRequestID = NULL_KEY; // Key to track our URL request
integer g_listenHandle = -1;
string g_secureURL = "";       // Stores the Second Life secure URL
string g_n8nWebhookURL = "URLTOMYSERVER-PROCESSING"; // PUBLIC

string g_pendingReply = "";    // Stores the reply message while we scan for a nearby person
string g_lastSpeakerName = ""; // NEW: Stores the name of the avatar who spoke last
string g_ownerName = "";       // NEW: Stores the owner's name for easy default reset

// == STATES ==
default
{
    state_entry()
    {
        // Get owner's name and store it for resets
        g_ownerName = llGetDisplayName(llGetOwner());
        if (g_ownerName == "") // Fallback to username
        {
            g_ownerName = llGetUsername(llGetOwner());
        }
        llSetObjectName(g_ownerName); // Default to owner's name on start
        
        llOwnerSay("Requesting a secure public URL for this object...");
        g_urlRequestID = llRequestSecureURL();

        // Listen in local chat for all messages
        g_listenHandle = llListen(0, "", "", "");
    }

    listen(integer channel, string name, key id, string message)
    {
        // Only process if the speaker is an avatar
        if (llVecMag(llGetAgentSize(id)) == 0.0)
        {
            // Not an avatar — ignore
            return;
        }

        // NEW: Store the name of the person who just spoke
        g_lastSpeakerName = name; 

        // Clean message (trim extra spaces)
        string cleanMessage = llStringTrim(message, STRING_TRIM);

        // JSON body to send to n8n (includes secure URL)
        string body = "{\"sender\":\"" + name + "\", "
                    + "\"message\":\"" + cleanMessage + "\", "
                    + "\"secure_url\":\"" + g_secureURL + "\"}";

        // Send to n8n webhook
        if (g_n8nWebhookURL != "")
        {
            llHTTPRequest(g_n8nWebhookURL,
                [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/json"],
                body);
        }
        else
        {
            llOwnerSay("❌ ERROR: n8n webhook URL not set.");
        }
    }

    http_request(key id, string method, string body)
    {
        if (id == g_urlRequestID)
        {
            if (method == URL_REQUEST_GRANTED)
            {
                g_secureURL = body;
                llOwnerSay("✅ Second Life Webhook URL Granted:\n" + g_secureURL);
                llOwnerSay("ℹ️ Copy this URL and paste it into your n8n 'Webhook' node if desired.");
                g_urlRequestID = NULL_KEY;
            }
            else if (method == URL_REQUEST_DENIED)
            {
                llOwnerSay("❌ ERROR: Failed to get a public URL. Try resetting the script.");
            }
        }
        else if (method == "POST")
        {
            string msg = llJsonGetValue(body, ["msg"]);
            if (msg != "")
            {
                g_pendingReply = llStringTrim(msg, STRING_TRIM);
                // Sensor range is 96m and we look for Agents
                llSensor("", NULL_KEY, AGENT, 96.0, PI); 
            }
            else
            {
                llOwnerSay("⚠️ Warning: No 'msg' key found in JSON.");
            }
            llHTTPResponse(id, 200, "Webhook received. Processing reply.");
        }
        else if (method == "GET")
        {
            llHTTPResponse(id, 200, "Webhook for AI");
        }
        else
        {
            llHTTPResponse(id, 405, "Unsupported Method");
        }
    }

    // Sensor event to handle renaming before replying
    sensor(integer num_detected)
    {
        if (g_pendingReply == "") return;

        list nonSpeakerAgents;
        integer i;
        
        // MODIFIED: Build a list of agents, EXCLUDING the last person who spoke
        for (i = 0; i < num_detected; ++i)
        {
            string detectedName = llDetectedName(i);
            if ((llDetectedType(i) & AGENT) && (detectedName != g_lastSpeakerName))
            {
                nonSpeakerAgents += [detectedName];
            }
        }
        
        integer listLength = llGetListLength(nonSpeakerAgents);
        
        if (listLength > 0)
        {
            // Pick a random name from the list of *other* people
            integer randomIndex = (integer)llFrand((float)listLength);
            string randomName = llList2String(nonSpeakerAgents, randomIndex);
            
            llSetObjectName(randomName);     // Rename the object
            llSay(0, g_pendingReply);      // Shout the message
            g_pendingReply = "";             // Clear the pending message
            return;
        }

        // If no OTHER agents were detected, default to owner name
        llSetObjectName(g_ownerName); 
        llSay(0, g_pendingReply);
        g_pendingReply = "";
    }

    // No_sensor event to handle if no one is found
    no_sensor()
    {
        if (g_pendingReply == "") return;

        // No one is nearby (other than potentially the original speaker). 
        // Default to owner name before replying.
        llSetObjectName(g_ownerName);
        llShout(0, g_pendingReply);
        g_pendingReply = "";
    }

    touch_start(integer total_number)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if (change & (CHANGED_REGION | CHANGED_REGION_START | CHANGED_TELEPORT | CHANGED_INVENTORY | CHANGED_OWNER))
        {
            llOwnerSay("Object environment changed. Re-requesting public URL.");
            if (g_secureURL != "") llReleaseURL(g_secureURL);
            llResetScript();
        }
    }
}
